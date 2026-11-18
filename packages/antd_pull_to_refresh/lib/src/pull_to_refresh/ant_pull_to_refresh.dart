/// AntPullToRefresh — antd-mobile PullToRefresh（下拉刷新）的 Flutter 实现
///
/// API 与 antd-mobile v5 对齐：
/// - [AntPullToRefresh.child] — 可滚动内容（必须是可滚动组件）
/// - [AntPullToRefresh.onRefresh] — 下拉刷新回调（Future 完成后回弹）
/// - [AntPullToRefresh.headHeight] — 头部高度（默认 40）
/// - [AntPullToRefresh.threshold] — 触发刷新的下拉阈值（默认 60）
/// - [AntPullToRefresh.pullStatusChange] — 状态变化回调
/// - [AntPullToRefresh.completeText] / [AntPullToRefresh.pullingText] /
///   [AntPullToRefresh.releasingText] / [AntPullToRefresh.finishingText] — 各阶段文案
/// - [AntPullToRefresh.pointer] — 指针位置（top 下拉 / bottom 上拉，默认 top）
/// - [AntPullToRefresh.enableLoadMore] / [AntPullToRefresh.onLoadMore] —
///   底部加载更多（easy_refresh footer 能力）
///
/// 实现架构参考 [easy_refresh](https://pub.dev/packages/easy_refresh)
/// （MIT License）整体重写（零新增依赖，吸收其架构思路）：
/// - **Notifier 状态机**：状态（mode/offset/footer mode）与任务编排
///   （refresh/load）收敛在 [AntPullToRefreshIndicator]（对应 ER 的
///   `IndicatorNotifier`），指示器组件只消费状态渲染；
/// - **ScrollBehavior 注入**（对应 ER 的 `ERScrollBehavior`）：物理保留
///   平台默认 + `AlwaysScrollableScrollPhysics`（空列表也可下拉），
///   `dragDevices` 包含鼠标（桌面端允许鼠标拖拽）；
/// - **Stack 指示器挂载**：头部/底部指示器以 Stack 挂载，随位移滑入，
///   组件经 ListenableBuilder 订阅 Notifier（对应 ER custom position
///   指示器的 Listenable 形态）。
///
/// 交互来源：
/// - 移动端：触摸拖拽过冲（OverscrollNotification）驱动
/// - 桌面端（macOS/Windows/Linux/web）：鼠标滚轮在顶部继续向上滚动
///   累积位移，停止滚动约 400ms 后按阈值触发刷新。滚轮事件通过
///   [GestureBinding.pointerSignalResolver] 正确参与事件竞争：只有
///   指针位于本组件内、内层滚动已到拉动边缘时才注册接管，
///   与同页其他滚动容器互不冲突
///
/// ```dart
/// AntPullToRefresh(
///   onRefresh: () async {
///     await Future<void>.delayed(const Duration(seconds: 1));
///   },
///   enableLoadMore: true,
///   onLoadMore: () async => AntPullToRefreshLoadResult.more,
///   child: ListView(children: const [Text('item')]),
/// )
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart'
    show
        GestureBinding,
        PointerDeviceKind,
        PointerScrollEvent,
        PointerSignalEvent;
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh_footer.dart';
import 'ant_pull_to_refresh_header.dart';
import 'ant_pull_to_refresh_notifier.dart';
import 'ant_pull_to_refresh_types.dart';
export 'ant_pull_to_refresh_footer.dart';
export 'ant_pull_to_refresh_header.dart';
export 'ant_pull_to_refresh_notifier.dart';
export 'ant_pull_to_refresh_types.dart';

// ============================================================
// 常量与测试定位 Key
// ============================================================

/// 头部高度标记 key，便于测试定位头部容器。
const Key kAntPullToRefreshHeaderKey =
    ValueKey<String>('AntPullToRefreshHeader');

/// 底部（加载更多）指示器标记 key。
const Key kAntPullToRefreshFooterKey =
    ValueKey<String>('AntPullToRefreshFooter');

/// 失败态「点击重试」标记 key。
const Key kAntPullToRefreshFooterRetryKey =
    ValueKey<String>('AntPullToRefreshFooterRetry');

/// 默认头部高度。
const double kAntPullToRefreshHeadHeight = 40;

/// 默认触发阈值。
const double kAntPullToRefreshThreshold = 60;

/// 回弹动画时长。
const Duration kAntPullToRefreshDuration = kIndicatorAnimationDuration;

/// 最大下拉距离 = headHeight * 3（参照轮子 maxOverScrollExtent 思路）。
const double kAntPullToRefreshMaxPullFactor =
    AntPullToRefreshIndicator.maxPullFactor;

/// 桌面端滚轮拉动后停止滚动到触发刷新的等待时长。
const Duration kAntPullToRefreshWheelSettleDuration =
    Duration(milliseconds: 400);

/// 默认文案。
const String kAntPullToRefreshPullingText = '下拉刷新';
const String kAntPullToRefreshReleasingText = '释放刷新';
const String kAntPullToRefreshFinishingText = '加载中...';
const String kAntPullToRefreshCompleteText = '刷新完成';

/// 底部（加载更多）默认文案。
const String kAntPullToRefreshLoadingText = '加载中...';
const String kAntPullToRefreshNoMoreText = '没有更多了';
const String kAntPullToRefreshFailedText = '加载失败';
const String kAntPullToRefreshRetryText = '点击重试';

/// 头部指示器图标尺寸。
const double kAntPullToRefreshIndicatorSize = 16;

/// 头部指示器图标与文案间距。
const double kAntPullToRefreshIndicatorSpacing = 8;

/// 头部指示器文案字号。
const double kAntPullToRefreshTextFontSize = 14;

// ============================================================
// AntPullToRefresh
// ============================================================

/// 下拉刷新 — 在可滚动内容顶部下拉触发刷新，滚动到底部触发加载更多。
///
/// 对齐 antd-mobile PullToRefresh 组件：下拉时头部跟随位移并显示
/// 「下拉刷新 → 释放刷新 → 加载转圈 → 完成」提示，松手超过
/// [AntPullToRefresh.threshold] 触发 [AntPullToRefresh.onRefresh]，
/// Future 完成后自动回弹。
///
/// 额外提供 easy_refresh 风格的加载更多能力：开启
/// [AntPullToRefresh.enableLoadMore] 并传入 [AntPullToRefresh.onLoadMore]
/// 后，内容滚动到底部自动触发加载；回调返回
/// [AntPullToRefreshLoadResult.noMore] 后不再触发，
/// 返回 [AntPullToRefreshLoadResult.failed] 后点击重试再次触发。
///
/// 桌面端支持鼠标滚轮：在列表顶部继续向上滚动滚轮即累积下拉位移，
/// 停止滚动 [kAntPullToRefreshWheelSettleDuration] 后超过阈值即触发刷新。
class AntPullToRefresh extends StatefulWidget {
  const AntPullToRefresh({
    super.key,
    required this.child,
    this.onRefresh,
    this.headHeight = kAntPullToRefreshHeadHeight,
    this.threshold = kAntPullToRefreshThreshold,
    this.pullStatusChange,
    this.completeText,
    this.pullingText,
    this.releasingText,
    this.finishingText,
    this.pointer = AntPullToRefreshPointer.top,
    this.header,
    this.enableRefresh = true,
    this.enableLoadMore = false,
    this.onLoadMore,
    this.loadingText,
    this.noMoreText,
    this.failedText,
    this.retryText,
    this.footer,
  });

  /// 可滚动内容（必须是 ListView / CustomScrollView 等可滚动组件才能下拉）。
  final Widget child;

  /// 下拉刷新回调（Future 完成后自动回弹）。
  final Future<void> Function()? onRefresh;

  /// 头部高度（默认 40）。
  final double headHeight;

  /// 触发刷新的下拉阈值（默认 60）。
  final double threshold;

  /// 状态变化回调（idle/pulling/canRelease/refreshing/complete）。
  final ValueChanged<AntPullToRefreshStatus>? pullStatusChange;

  /// 刷新完成文案。
  final String? completeText;

  /// 下拉中（未达阈值）文案。
  final String? pullingText;

  /// 达到阈值释放即刷新文案。
  final String? releasingText;

  /// 刷新中文案（伴随转圈显示）。
  final String? finishingText;

  /// 指针位置：top 顶部下拉（默认）/ bottom 底部上拉。
  final AntPullToRefreshPointer pointer;

  /// 自定义头部内容（替换默认的状态提示）。
  final Widget? header;

  /// 是否启用下拉刷新（默认 true）。
  final bool enableRefresh;

  /// 是否启用滚动到底部自动加载更多（默认 false，需配合 [onLoadMore]）。
  final bool enableLoadMore;

  /// 加载更多回调：滚动到底部自动触发。
  ///
  /// 返回 [AntPullToRefreshLoadResult] 控制 footer 后续状态：
  /// more（可继续加载）/ noMore（不再触发）/ failed（点击重试）。
  final Future<AntPullToRefreshLoadResult> Function()? onLoadMore;

  /// 加载中文案（伴随转圈显示）。
  final String? loadingText;

  /// 没有更多文案。
  final String? noMoreText;

  /// 加载失败文案。
  final String? failedText;

  /// 失败后重试按钮文案。
  final String? retryText;

  /// 自定义底部内容（替换默认的加载更多指示器）。
  final Widget? footer;

  @override
  AntPullToRefreshState createState() => AntPullToRefreshState();
}

/// [AntPullToRefresh] 的 State（公开以便外部经 GlobalKey 程序化触发刷新，
/// 对应 easy_refresh controller 的 `callRefresh` 能力）。
class AntPullToRefreshState extends State<AntPullToRefresh>
    with SingleTickerProviderStateMixin {
  /// 程序化触发下拉刷新（对应 easy_refresh controller 的 `callRefresh`）：
  /// 头部展开 → 等待 [AntPullToRefresh.onRefresh] 完成 → 回弹。
  Future<void> callRefresh() => _indicator.runRefresh(widget.onRefresh);

  /// 指示器状态机（架构参考 easy_refresh IndicatorNotifier）：
  /// 状态/动画/任务编排全部收敛于此，本 State 只做事件路由与布局。
  late final AntPullToRefreshIndicator _indicator = AntPullToRefreshIndicator(
    vsync: this,
    onModeChanged: (status) => widget.pullStatusChange?.call(status),
  );

  /// 内层可滚动组件最近一次的滚动度量（判定是否在拉动边缘）。
  ScrollMetrics? _lastMetrics;

  /// 滚轮停止滚动 → 触发 release 的延时计时器。
  Timer? _wheelSettleTimer;

  @override
  void initState() {
    super.initState();
    _indicator.configure(
      headHeight: widget.headHeight,
      threshold: widget.threshold,
      isTop: widget.pointer == AntPullToRefreshPointer.top,
    );
  }

  @override
  void didUpdateWidget(covariant AntPullToRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    _indicator.configure(
      headHeight: widget.headHeight,
      threshold: widget.threshold,
      isTop: widget.pointer == AntPullToRefreshPointer.top,
    );
  }

  @override
  void dispose() {
    _wheelSettleTimer?.cancel();
    _indicator.dispose();
    super.dispose();
  }

  bool get _isTop => _indicator.isTop;

  // ============================================================
  // 桌面端滚轮（PointerSignalResolver 竞争模式）
  // ============================================================

  /// 内层可滚动组件是否停在拉动边缘（top：顶部；bottom：底部）。
  bool get _atPullEdge =>
      atPullEdge(_lastMetrics, isTop: _isTop);

  /// 滚轮事件处理（非消费式入口）。
  ///
  /// - 拉动方向且已到边缘：通过 [GestureBinding.pointerSignalResolver]
  ///   注册接管 —— 此场景下内层 Scrollable 判定滚动无位移不会注册，
  ///   我们成为唯一注册者，胜出后阻断平台默认（页面）滚动；
  /// - 反向且有已累积位移：只回退自身头部位移，不竞争事件（内层
  ///   滚动照常滚动），非消费式处理不影响任何其他监听者。
  void _handlePointerSignalWrapper(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!AntPlatform.isDesktop) return;
    if (!widget.enableRefresh) return;
    if (!_indicator.canPull) return;
    final double delta = event.scrollDelta.dy;
    if (delta == 0) return;
    // top：向上滚（dy < 0）为拉动；bottom：向下滚（dy > 0）为拉动。
    final double step = _isTop ? -delta : delta;
    final bool wantsPull = step > 0 && _atPullEdge;
    final bool wantsRetract = step < 0 && _indicator.offset > 0;
    if (wantsPull) {
      GestureBinding.instance.pointerSignalResolver.register(
        event,
        _handleResolvedWheel,
      );
    } else if (wantsRetract) {
      _handleWheelEvent(event);
    }
  }

  /// 竞争胜出后的滚轮处理：阻断平台默认（页面）滚动，再走拉动状态机。
  void _handleResolvedWheel(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    event.respond(allowPlatformDefault: false);
    _handleWheelEvent(event);
  }

  /// 桌面端鼠标滚轮拉动（与触摸共用同一状态机）。
  ///
  /// - 朝拉动方向滚动且内层滚动停在边缘 → 累积位移；
  /// - 反向滚动 → 回退位移（回到 0 即回 idle）；
  /// - 停止滚动 [kAntPullToRefreshWheelSettleDuration] 后 → 走 release。
  void _handleWheelEvent(PointerScrollEvent event) {
    if (!widget.enableRefresh || !_indicator.canPull) return;
    final double delta = event.scrollDelta.dy;
    if (delta == 0) return;
    final double step = _isTop ? -delta : delta;
    if (step > 0 && !_atPullEdge) return;
    if (step < 0 && _indicator.offset <= 0) return;

    _wheelSettleTimer?.cancel();
    _indicator.wheelPull(step);
    // 滚轮停止滚动即视为「松手」。
    _wheelSettleTimer = Timer(kAntPullToRefreshWheelSettleDuration, () {
      if (!mounted || !_indicator.wheelDriven || !_indicator.canPull) return;
      _indicator.release(widget.onRefresh);
    });
  }

  // ============================================================
  // 滚动通知路由
  // ============================================================

  bool _handleNotification(Notification notification) {
    // 记录内层滚动度量，供滚轮判定拉动边缘。
    if (notification is ScrollMetricsNotification) {
      _lastMetrics = notification.metrics;
    } else if (notification is ScrollUpdateNotification) {
      _lastMetrics = notification.metrics;
      // 滚动离开底部边缘 → 重新武装加载更多。
      _indicator.armLoadIfScrolled(notification.metrics);
    }
    if (notification is! ScrollNotification) return false;

    if (notification is OverscrollNotification) {
      final bool hit =
          _isTop ? notification.overscroll < 0 : notification.overscroll > 0;
      if (hit && widget.enableRefresh) _indicator.drag(notification.overscroll);
      return false;
    }
    if (notification is ScrollEndNotification) {
      // 滚轮每个 tick 都会产生 ScrollEndNotification（pointerScroll
      // 内部 didStartScroll/didEndScroll），滚轮拉动由停止计时触发
      // release，不能在这里提前回弹。
      if (!_indicator.wheelDriven && widget.enableRefresh) {
        _indicator.release(widget.onRefresh);
      }
      _maybeLoadMore(notification.metrics);
    }
    return false;
  }

  /// 滚动结束停在底部边缘时触发加载更多（结果由 Notifier 回写 footer）。
  Future<void> _maybeLoadMore(ScrollMetrics metrics) async {
    if (!widget.enableLoadMore) return;
    if (!_indicator.shouldLoadMore(metrics)) return;
    await _indicator.startLoad(
      enableLoadMore: true,
      onLoadMore: widget.onLoadMore,
    );
  }

  /// 失败态点击重试。
  Future<void> _retryLoad() async {
    await _indicator.startLoad(
      enableLoadMore: true,
      onLoadMore: widget.onLoadMore,
      fromRetry: true,
    );
  }

  // ============================================================
  // 布局（Stack 指示器挂载，ListenableBuilder 订阅 Notifier）
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bool isTop = _isTop;

    return ListenableBuilder(
      listenable: _indicator,
      builder: (context, _) {
        final double offset = _indicator.offset.clamp(
          0.0,
          widget.headHeight * kAntPullToRefreshMaxPullFactor,
        );
        final bool showFooter = widget.enableLoadMore &&
            _indicator.footerMode != AntPullToRefreshFooterStatus.idle;

        return NotificationListener<Notification>(
          onNotification: _handleNotification,
          child: ScrollConfiguration(
            // 架构参考 easy_refresh ERScrollBehavior：注入滚动行为，
            // 平台物理兜底 AlwaysScrollable（空列表也可下拉），
            // 关闭默认过冲指示器，桌面端允许鼠标拖拽滚动。
            behavior: const _AntPullToRefreshScrollBehavior(),
            child: Stack(
              children: [
                // 内容区（随下拉位移整体下移/上移）
                Positioned.fill(
                  key: const ValueKey<String>('AntPullToRefreshContent'),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      // 吞掉默认的 Material 拉伸/波纹过冲指示器，
                      // 避免与头部提示冲突（对应 ER 关闭过冲指示器）。
                      notification.disallowIndicator();
                      return true;
                    },
                    child: Transform.translate(
                      offset: Offset(0, isTop ? offset : -offset),
                      child: Listener(
                        // 滚轮竞争监听器下沉到 child 内层：命中测试比
                        // Scrollable 的监听器更深，pointerSignalResolver
                        // 深度优先注册保证本组件只在自身条件下接管事件，
                        // 不与同页其他滚动容器冲突。
                        onPointerSignal: _handlePointerSignalWrapper,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
                // 头部（下拉时从边缘滑入）
                Positioned(
                  key: kAntPullToRefreshHeaderKey,
                  left: 0,
                  right: 0,
                  top: isTop ? 0 : null,
                  bottom: isTop ? null : 0,
                  height: widget.headHeight,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      isTop
                          ? offset - widget.headHeight
                          : widget.headHeight - offset,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      color: theme.colorBgLayout,
                      // 未下拉时头部整体移出可视区，内容不参与命中与语义树。
                      child: Visibility(
                        visible: offset > 0,
                        child: widget.header ??
                            AntPullToRefreshHeader(
                              status: _indicator.mode,
                              pullingText: widget.pullingText,
                              releasingText: widget.releasingText,
                              finishingText: widget.finishingText,
                              completeText: widget.completeText,
                            ),
                      ),
                    ),
                  ),
                ),
                // 底部（加载更多）指示器
                Positioned(
                  key: kAntPullToRefreshFooterKey,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: widget.headHeight,
                  child: IgnorePointer(
                    ignoring: !showFooter,
                    child: Visibility(
                      visible: showFooter,
                      child: Container(
                        alignment: Alignment.center,
                        color: theme.colorBgLayout,
                        child: widget.footer ??
                            AntPullToRefreshFooter(
                              status: _indicator.footerMode,
                              loadingText: widget.loadingText,
                              noMoreText: widget.noMoreText,
                              failedText: widget.failedText,
                              retryText: widget.retryText,
                              onRetry: _retryLoad,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// AntPullToRefresh 的滚动行为（架构参考 easy_refresh `ERScrollBehavior`）。
///
/// - 物理保留平台默认（Clamping/Bouncing），外层包 `AlwaysScrollableScrollPhysics`
///   保证空列表也能下拉；
/// - 不构建默认过冲指示器（组件内部已用 `disallowIndicator` 兜底）；
/// - `dragDevices` 包含鼠标：桌面端/web 支持鼠标拖拽滚动。
class _AntPullToRefreshScrollBehavior extends ScrollBehavior {
  const _AntPullToRefreshScrollBehavior();

  static final Set<PointerDeviceKind> _kAllDragDevices =
      Set<PointerDeviceKind>.from(PointerDeviceKind.values);

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return AlwaysScrollableScrollPhysics(
      parent: super.getScrollPhysics(context),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => _kAllDragDevices;
}
