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
///
/// 交互来源：
/// - 移动端：触摸拖拽过冲（OverscrollNotification）驱动
/// - 桌面端（macOS/Windows/Linux/web）：鼠标滚轮在顶部继续向上滚动
///   累积位移，停止滚动约 400ms 后按阈值触发刷新（参照
///   [pull_to_refresh_flutter3](https://github.com/xxzj990-game/flutter_pulltorefresh)
///   「滚轮位移累积 + 停止即 ballistic 触发」的思路）
///
/// ```dart
/// AntPullToRefresh(
///   onRefresh: () async {
///     await Future<void>.delayed(const Duration(seconds: 1));
///   },
///   child: ListView(children: const [Text('item')]),
/// )
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/gestures.dart' show PointerScrollEvent, PointerSignalEvent;
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh_header.dart';
import 'ant_pull_to_refresh_types.dart';
export 'ant_pull_to_refresh_header.dart';
export 'ant_pull_to_refresh_types.dart';

// ============================================================
// 常量与测试定位 Key
// ============================================================

/// 头部高度标记 key，便于测试定位头部容器。
const Key kAntPullToRefreshHeaderKey = ValueKey<String>('AntPullToRefreshHeader');

/// 默认头部高度。
const double kAntPullToRefreshHeadHeight = 40;

/// 默认触发阈值。
const double kAntPullToRefreshThreshold = 60;

/// 回弹动画时长。
const Duration kAntPullToRefreshDuration = Duration(milliseconds: 300);

/// 最大下拉距离 = headHeight * 3（参照轮子 maxOverScrollExtent 思路）。
const double kAntPullToRefreshMaxPullFactor = 3;

/// 桌面端滚轮拉动后停止滚动到触发刷新的等待时长。
const Duration kAntPullToRefreshWheelSettleDuration = Duration(milliseconds: 400);

/// 默认文案。
const String kAntPullToRefreshPullingText = '下拉刷新';
const String kAntPullToRefreshReleasingText = '释放刷新';
const String kAntPullToRefreshFinishingText = '加载中...';
const String kAntPullToRefreshCompleteText = '刷新完成';

/// 头部指示器图标尺寸。
const double kAntPullToRefreshIndicatorSize = 16;

/// 头部指示器图标与文案间距。
const double kAntPullToRefreshIndicatorSpacing = 8;

/// 头部指示器文案字号。
const double kAntPullToRefreshTextFontSize = 14;

// ============================================================
// AntPullToRefresh
// ============================================================

/// 下拉刷新 — 在可滚动内容顶部下拉触发刷新。
///
/// 对齐 antd-mobile PullToRefresh 组件：下拉时头部跟随位移并显示
/// 「下拉刷新 → 释放刷新 → 加载转圈 → 完成」提示，松手超过
/// [AntPullToRefresh.threshold] 触发 [AntPullToRefresh.onRefresh]，
/// Future 完成后自动回弹。
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

  @override
  State<AntPullToRefresh> createState() => _AntPullToRefreshState();
}

class _AntPullToRefreshState extends State<AntPullToRefresh>
    with SingleTickerProviderStateMixin {
  /// 当前头部/内容位移量。
  double _offset = 0;

  AntPullToRefreshStatus _status = AntPullToRefreshStatus.idle;

  /// 当前一次拉动是否由桌面滚轮驱动（滚轮没有「松手」事件，
  /// 由停止滚动计时触发 release，需屏蔽滚轮事件流中的 ScrollEndNotification）。
  bool _wheelDriven = false;

  /// 滚轮停止滚动 → 触发 release 的延时计时器。
  Timer? _wheelSettleTimer;

  /// 内层可滚动组件最近一次的滚动度量（判定是否在拉动边缘）。
  ScrollMetrics? _lastMetrics;

  late final AnimationController _bounceController = AnimationController(
    vsync: this,
    duration: kAntPullToRefreshDuration,
  );

  Animation<double>? _bounceAnimation;

  bool get _isTop => widget.pointer == AntPullToRefreshPointer.top;

  @override
  void initState() {
    super.initState();
    _bounceController.addListener(_handleBounceTick);
  }

  @override
  void dispose() {
    _wheelSettleTimer?.cancel();
    _bounceController.removeListener(_handleBounceTick);
    _bounceController.dispose();
    super.dispose();
  }

  void _handleBounceTick() {
    final anim = _bounceAnimation;
    if (anim == null) return;
    setState(() => _offset = anim.value);
  }

  /// 回弹到目标位移。
  void _animateTo(double target) {
    _bounceAnimation = Tween<double>(begin: _offset, end: target).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOutCubic),
    );
    _bounceController.forward(from: 0);
  }

  /// 更新状态并通知回调。
  void _updateStatus(AntPullToRefreshStatus status) {
    if (_status == status) return;
    _status = status;
    widget.pullStatusChange?.call(status);
  }

  /// 是否允许响应下拉手势。
  bool get _canPull =>
      _status == AntPullToRefreshStatus.idle ||
      _status == AntPullToRefreshStatus.pulling ||
      _status == AntPullToRefreshStatus.canRelease;

  /// 内层可滚动组件是否停在拉动边缘（top：顶部；bottom：底部）。
  ///
  /// 滚轮事件被 Scrollable 的 PointerSignalResolver 消费后，
  /// 在边缘处会被 clamp 成 no-op，不会产生任何过冲通知，
  /// 因此需要用滚动度量自行判定「继续滚动即是拉动」。
  bool get _atPullEdge {
    final metrics = _lastMetrics;
    if (metrics == null) return true;
    return _isTop
        ? metrics.pixels <=
            metrics.minScrollExtent + precisionErrorTolerance
        : metrics.pixels >=
            metrics.maxScrollExtent - precisionErrorTolerance;
  }

  /// 处理滚动过冲位移（触摸拖拽路径，移动端不变）。
  void _handleOverscroll(double overscroll) {
    if (!_canPull) return;
    final double delta = _isTop ? -overscroll : overscroll;
    setState(() {
      _offset =
          (_offset + delta).clamp(0.0, widget.headHeight * kAntPullToRefreshMaxPullFactor);
      _updateStatus(
        _offset >= widget.threshold
            ? AntPullToRefreshStatus.canRelease
            : AntPullToRefreshStatus.pulling,
      );
    });
  }

  /// 桌面端鼠标滚轮拉动（与触摸共用同一状态机）。
  ///
  /// - 朝拉动方向滚动且内层滚动停在边缘 → 累积位移；
  /// - 反向滚动 → 回退位移（回到 0 即回 idle）；
  /// - 停止滚动 [kAntPullToRefreshWheelSettleDuration] 后 → 走 release。
  void _handleWheelPull(PointerScrollEvent event) {
    if (!AntPlatform.isDesktop) return;
    if (!_canPull) return;
    final double delta = event.scrollDelta.dy;
    if (delta == 0) return;
    // top：向上滚（dy < 0）为拉动；bottom：向下滚（dy > 0）为拉动。
    final double step = _isTop ? -delta : delta;
    if (step > 0 && !_atPullEdge) return;
    if (step < 0 && _offset <= 0) return;

    _wheelSettleTimer?.cancel();
    setState(() {
      _offset =
          (_offset + step).clamp(0.0, widget.headHeight * kAntPullToRefreshMaxPullFactor);
      if (_offset <= 0) {
        _wheelDriven = false;
        _updateStatus(AntPullToRefreshStatus.idle);
        return;
      }
      _wheelDriven = true;
      _updateStatus(
        _offset >= widget.threshold
            ? AntPullToRefreshStatus.canRelease
            : AntPullToRefreshStatus.pulling,
      );
    });
    // 滚轮停止滚动即视为「松手」。
    _wheelSettleTimer = Timer(kAntPullToRefreshWheelSettleDuration, () {
      if (!mounted || !_wheelDriven || !_canPull) return;
      _handleRelease();
    });
  }

  void _cancelWheelSettle() {
    _wheelSettleTimer?.cancel();
    _wheelSettleTimer = null;
  }

  /// 松手：超过阈值触发刷新，否则回弹。
  void _handleRelease() {
    _cancelWheelSettle();
    if (!_canPull) return;
    _wheelDriven = false;
    if (_offset >= widget.threshold && widget.onRefresh != null) {
      _runRefresh();
    } else {
      _updateStatus(AntPullToRefreshStatus.idle);
      _animateTo(0);
    }
  }

  /// 执行刷新：头部展开到 headHeight → 等待 onRefresh → 完成后回弹。
  Future<void> _runRefresh() async {
    _updateStatus(AntPullToRefreshStatus.refreshing);
    _animateTo(widget.headHeight);
    try {
      await widget.onRefresh?.call();
    } catch (_) {
      // 刷新回调异常不阻塞流程，照常完成回弹。
    }
    if (!mounted) return;
    _updateStatus(AntPullToRefreshStatus.complete);
    _animateTo(0);
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) _handleWheelPull(event);
  }

  bool _handleNotification(Notification notification) {
    // 记录内层滚动度量，供滚轮判定拉动边缘。
    if (notification is ScrollMetricsNotification) {
      _lastMetrics = notification.metrics;
    } else if (notification is ScrollUpdateNotification) {
      _lastMetrics = notification.metrics;
    }
    if (notification is! ScrollNotification) return false;

    // 刷新中/完成阶段不响应新的下拉。
    if (_status == AntPullToRefreshStatus.refreshing ||
        _status == AntPullToRefreshStatus.complete) {
      return false;
    }
    if (notification is OverscrollNotification) {
      final bool hit = _isTop
          ? notification.overscroll < 0
          : notification.overscroll > 0;
      if (hit) _handleOverscroll(notification.overscroll);
      return false;
    }
    if (notification is ScrollEndNotification) {
      // 滚轮每个 tick 都会产生 ScrollEndNotification（pointerScroll
      // 内部 didStartScroll/didEndScroll），滚轮拉动由停止计时触发
      // release，不能在这里提前回弹。
      if (!_wheelDriven) _handleRelease();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bool isTop = _isTop;

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: NotificationListener<Notification>(
        onNotification: _handleNotification,
        child: Stack(
          children: [
            // 内容区（随下拉位移整体下移/上移）
            Positioned.fill(
              key: const ValueKey<String>('AntPullToRefreshContent'),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  // 吞掉默认的 Material 拉伸/波纹过冲指示器，避免与头部提示冲突。
                  notification.disallowIndicator();
                  return true;
                },
                child: Transform.translate(
                  offset: Offset(0, isTop ? _offset : -_offset),
                  child: widget.child,
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
                      ? _offset - widget.headHeight
                      : widget.headHeight - _offset,
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: theme.colorBgLayout,
                  // 未下拉时头部整体移出可视区，内容不参与命中与语义树。
                  child: Visibility(
                    visible: _offset > 0,
                    child: widget.header ??
                        AntPullToRefreshHeader(
                          status: _status,
                          pullingText: widget.pullingText,
                          releasingText: widget.releasingText,
                          finishingText: widget.finishingText,
                          completeText: widget.completeText,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
