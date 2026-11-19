/// AntInfiniteScroll — antd-mobile InfiniteScroll 的 Flutter 实现
///
/// API 与 antd-mobile v5 InfiniteScroll 对齐：
/// - [AntInfiniteScroll.child] — 列表内容（任意滚动组件/Column 均可）
/// - [AntInfiniteScroll.loadMore] — 加载函数，返回 `false` 表示没有更多
/// - [AntInfiniteScroll.threshold] — 触发阈值（距底部距离，逻辑像素）
/// - [AntInfiniteScroll.loadingText] / [AntInfiniteScroll.hasMoreText] /
///   [AntInfiniteScroll.noMoreText] / [AntInfiniteScroll.loadFailedText] — 文案
/// - [AntInfiniteScroll.loadFailedRetryText] — 失败重试按钮文案
///
/// 通过内层 [NotificationListener] 消费隔离（onNotification 返回 true
/// 阻断冒泡）捕获 child 子树自身的滚动度量，底部进入阈值范围自动触发
/// [AntInfiniteScroll.loadMore]，不侵入子树。
///
/// **child 必须包含可滚动组件**（ListView / SingleChildScrollView 等，
/// 对齐 antd-mobile InfiniteScroll 用法）：触发只属于自己的包裹对象，
/// child 无滚动组件时（组件整体嵌在宿主页面滚动视图里被动滚动）不会
/// 触发加载，让宿主页面滚动正常通过。
///
/// ```dart
/// AntInfiniteScroll(
///   loadMore: () async => items.addAll(fetchPage()),
///   child: Column(children: [...]),
/// )
/// ```
library;

import 'ant_infinite_scroll_types.dart';

export 'ant_infinite_scroll_types.dart';

import 'package:antd_theme/antd_theme.dart';

import 'package:material_ui/material_ui.dart';

import '../ant_refresh_controller.dart';

/// 无限滚动 — 滚动到底部自动加载更多数据。
///
/// 对齐 antd-mobile InfiniteScroll 组件。
class AntInfiniteScroll extends StatefulWidget {
  const AntInfiniteScroll({
    super.key,
    required this.child,
    required this.loadMore,
    this.threshold = AntInfiniteScrollDefaults.threshold,
    this.loadingText,
    this.hasMoreText,
    this.noMoreText,
    this.loadFailedText,
    this.loadFailedRetryText,
    this.controller,
  });

  /// 列表内容，由使用方传入（ListView / Column 等任意滚动内容）。
  final Widget child;

  /// 加载函数，返回 `false` 表示没有更多数据。
  final Future<bool> Function() loadMore;

  /// 触发阈值：滚动位置距底部小于该值（逻辑像素）时触发加载，默认 0。
  final double threshold;

  /// 加载中文案，为空时取默认文案。
  final String? loadingText;

  /// 还有更多数据时的提示文案，为空时取默认文案。
  final String? hasMoreText;

  /// 没有更多数据时的提示文案，为空时取默认文案。
  final String? noMoreText;

  /// 加载失败提示文案，为空时取默认文案。
  final String? loadFailedText;

  /// 加载失败重试按钮文案，为空时取默认文案。
  final String? loadFailedRetryText;

  /// 程序化控制器（R35.2 Controller 优先）：经 [AntInfiniteScrollController
  /// .callLoadMore]/[AntInfiniteScrollController.reset] 程序化操作。
  final AntInfiniteScrollController? controller;

  @override
  AntInfiniteScrollState createState() => AntInfiniteScrollState();
}

/// 底部状态区阶段（footer 局部刷新粒度，R35：禁止整组件 setState）。
enum _AntInfiniteScrollPhase {
  /// 还有更多（不渲染常驻 footer）。
  idle,

  /// 加载中。
  loading,

  /// 加载失败（展示重试）。
  failed,

  /// 没有更多。
  noMore,
}

/// [AntInfiniteScroll] 的 State（公开供 [AntInfiniteScrollController] 挂载）。
class AntInfiniteScrollState extends State<AntInfiniteScroll> {
  /// 底部状态区阶段（ValueNotifier + ListenableBuilder 局部刷新 footer，
  /// R35：状态变化只重建 footer，不做整组件 setState）。
  final ValueNotifier<_AntInfiniteScrollPhase> _phase =
      ValueNotifier(_AntInfiniteScrollPhase.idle);

  /// 按当前布尔状态同步 footer 阶段并触发局部刷新。
  void _syncPhase() {
    _AntInfiniteScrollPhase next;
    if (_loading) {
      next = _AntInfiniteScrollPhase.loading;
    } else if (_failed) {
      next = _AntInfiniteScrollPhase.failed;
    } else if (!_hasMore) {
      next = _AntInfiniteScrollPhase.noMore;
    } else {
      next = _AntInfiniteScrollPhase.idle;
    }
    if (_phase.value != next) _phase.value = next;
  }

  /// 是否还有更多数据。
  bool _hasMore = true;

  /// 是否正在加载。
  bool _loading = false;

  /// 是否加载失败。
  bool _failed = false;

  /// child 子树最内层滚动组件最近一次的滚动度量（内层消费隔离存储值，
  /// 状态机/触发逻辑只读该值，不感知外层页面滚动）。
  ScrollMetrics? _childMetrics;

  /// 是否已完成首次阈值检查。
  bool _initialChecked = false;

  /// 首次滚动度量解析重试次数上限（child 迟迟不含滚动组件时停止轮询）。
  static const int _kMaxResolveAttempts = 10;

  int _resolveAttempts = 0;

  /// 防重入锁：加载中不重复触发。
  bool get _canLoad => !_loading && !_failed && _hasMore;

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    // 首帧布局完成后读取一次滚动度量：内容不足一屏（无法产生滚动事件）
    // 或初始即处于阈值范围内时，实现初始自动加载。
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeInitialCheck());
  }

  @override
  void didUpdateWidget(covariant AntInfiniteScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _phase.dispose();
    super.dispose();
  }

  /// 程序化触发加载更多（Controller 入口；失败态下等价于点击重试）。
  Future<void> callLoadMore() => _loadMore(isRetry: _failed);

  /// 重置分页状态：清除失败态并恢复「还有更多」（Controller 入口）。
  void reset() {
    if (!_failed && _hasMore && !_loading) return;
    _failed = false;
    _hasMore = true;
    _initialChecked = true;
    _syncPhase();
  }

  /// 执行首次阈值检查；滚动度量未就绪时延后重试（有次数上限）。
  void _maybeInitialCheck() {
    if (!mounted || _initialChecked) return;
    final metrics = _childMetrics ?? _resolveDescendantMetrics(context);
    if (metrics == null || !metrics.hasContentDimensions) {
      if (++_resolveAttempts < _kMaxResolveAttempts) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _maybeInitialCheck());
      }
      return;
    }
    _initialChecked = true;
    _check(metrics);
  }

  /// 从子树中找到最近的 [ScrollableState] 并返回其滚动度量
  ///（child 自带滚动视图的用法）。
  static ScrollMetrics? _resolveDescendantMetrics(BuildContext context) {
    ScrollMetrics? found;
    void visit(Element element) {
      if (found != null) return;
      if (element is StatefulElement && element.state is ScrollableState) {
        found = (element.state as ScrollableState).position;
        return;
      }
      element.visitChildElements(visit);
    }

    context.visitChildElements(visit);
    return found;
  }

  /// 检查滚动位置是否进入触发阈值范围。
  void _check(ScrollMetrics metrics) {
    if (!_canLoad) return;
    if (metrics.pixels < metrics.maxScrollExtent - widget.threshold) {
      return;
    }
    _loadMore();
  }

  /// 执行加载：成功时按返回值更新 hasMore，异常时进入失败态。
  ///
  /// 状态变化经 [_syncPhase] 走 ValueNotifier 局部刷新 footer（R35）。
  Future<void> _loadMore({bool isRetry = false}) async {
    if (_loading) return;
    _loading = true;
    if (isRetry) _failed = false;
    _syncPhase();
    try {
      final hasMore = await widget.loadMore();
      if (!mounted) return;
      _hasMore = hasMore;
      _loading = false;
      _syncPhase();
    } catch (_) {
      if (!mounted) return;
      _failed = true;
      _loading = false;
      _syncPhase();
    }
  }

  /// child 子树是否停在触发边缘（内层消费隔离的判定条件）。
  bool _atTriggerEdge(ScrollMetrics metrics) =>
      metrics.pixels >= metrics.maxScrollExtent - widget.threshold;

  /// 内层通知处理：只接受 child 子树最内层（depth == 0）滚动组件的通知，
  /// 度量存入 [_childMetrics] 后由状态机触发判定。
  ///
  /// 消费隔离：滚动到达触发边缘后的继续滚动、以及 loading 期间的一切
  /// 子树滚动通知就地消费（返回 true 阻断冒泡），不再驱动外层页面滚动；
  /// 未到边缘且非加载中时放行冒泡，保留外层（如顶部下拉刷新组件）组合能力。
  bool _handleChildNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final metrics = notification.metrics;
    _childMetrics = metrics;
    _check(metrics);
    if (!_atTriggerEdge(metrics) && !_loading) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleChildNotification,
      child: NotificationListener<ScrollMetricsNotification>(
        // 布局变化（如列表内容变短）时同样检查，对齐 antd-mobile 行为。
        // 该通知同样只来自 child 子树内的滚动组件。
        onNotification: (notification) {
          _childMetrics = notification.metrics;
          _check(notification.metrics);
          return false;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.child,
            // footer 局部刷新：阶段状态经 ValueNotifier 驱动，不做整组件
            // setState（R35）。
            ValueListenableBuilder<_AntInfiniteScrollPhase>(
              valueListenable: _phase,
              builder: (context, phase, _) => _buildFooter(context, phase),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部状态区：加载中 / 失败重试 / 没有更多 / 还有更多。
  ///
  /// idle 且还有更多时不渲染常驻提示（对齐 antd-mobile：footer 仅在
  /// 加载中 / 失败 / 没有更多三个状态展示，避免未触发时底部常驻占位）。
  Widget _buildFooter(BuildContext context, _AntInfiniteScrollPhase phase) {
    final theme = AntTheme.of(context);
    final style = TextStyle(
      fontSize: 14.sp,
      color: theme.colorTextSecondary,
    );

    if (phase == _AntInfiniteScrollPhase.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: theme.colorPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              widget.loadingText ?? AntInfiniteScrollDefaults.loadingText,
              style: style,
            ),
          ],
        ),
      );
    }

    if (phase == _AntInfiniteScrollPhase.failed) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: GestureDetector(
          onTap: () => _loadMore(isRetry: true),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.loadFailedText ??
                    AntInfiniteScrollDefaults.loadFailedText,
                style: style.copyWith(color: theme.colorTextTertiary),
              ),
              SizedBox(width: 8.w),
              Text(
                widget.loadFailedRetryText ??
                    AntInfiniteScrollDefaults.loadFailedRetryText,
                style: style.copyWith(color: theme.colorPrimary),
              ),
            ],
          ),
        ),
      );
    }

    if (phase == _AntInfiniteScrollPhase.noMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: Text(
          widget.noMoreText ?? AntInfiniteScrollDefaults.noMoreText,
          style: style.copyWith(color: theme.colorTextTertiary),
          textAlign: TextAlign.center,
        ),
      );
    }

    // idle 且还有更多：不渲染常驻 footer。
    return const SizedBox.shrink();
  }
}
