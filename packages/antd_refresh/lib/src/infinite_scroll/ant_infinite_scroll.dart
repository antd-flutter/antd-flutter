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
/// 通过 [NotificationListener] 监听滚动与布局变化，
/// 底部进入阈值范围自动触发 [AntInfiniteScroll.loadMore]，不侵入子树。
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

  @override
  State<AntInfiniteScroll> createState() => _AntInfiniteScrollState();
}

class _AntInfiniteScrollState extends State<AntInfiniteScroll> {
  /// 是否还有更多数据。
  bool _hasMore = true;

  /// 是否正在加载。
  bool _loading = false;

  /// 是否加载失败。
  bool _failed = false;

  /// 祖先滚动容器位置（组件嵌在滚动视图内的用法）。
  ScrollPosition? _ancestorPosition;

  /// 是否已完成首次阈值检查。
  bool _initialChecked = false;

  /// 防重入锁：加载中不重复触发。
  bool get _canLoad => !_loading && !_failed && _hasMore;

  @override
  void initState() {
    super.initState();
    // 首帧布局完成后读取一次滚动度量：内容不足一屏（无法产生滚动事件）
    // 或初始即处于阈值范围内时，实现初始自动加载。
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeInitialCheck());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _ancestorPosition)) {
      final oldPosition = _ancestorPosition;
      if (oldPosition != null) oldPosition.removeListener(_onAncestorScroll);
      _ancestorPosition = position;
      position?.addListener(_onAncestorScroll);
    }
  }

  @override
  void dispose() {
    _ancestorPosition?.removeListener(_onAncestorScroll);
    super.dispose();
  }

  /// 祖先滚动位置变化时检查阈值。
  void _onAncestorScroll() {
    final position = _ancestorPosition;
    if (position != null && position.hasContentDimensions) {
      _check(position);
    }
  }

  /// 执行首次阈值检查；滚动度量未就绪时延后重试。
  void _maybeInitialCheck() {
    if (!mounted || _initialChecked) return;
    final metrics =
        _ancestorPosition ?? _resolveDescendantMetrics(context);
    if (metrics == null || !metrics.hasContentDimensions) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _maybeInitialCheck());
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
  Future<void> _loadMore({bool isRetry = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      if (isRetry) _failed = false;
    });
    try {
      final hasMore = await widget.loadMore();
      if (!mounted) return;
      setState(() {
        _hasMore = hasMore;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _check(notification.metrics);
        return false;
      },
      child: NotificationListener<ScrollMetricsNotification>(
        // 布局变化（如列表内容变短）时同样检查，对齐 antd-mobile 行为。
        onNotification: (notification) {
          _check(notification.metrics);
          return false;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [widget.child, _buildFooter(context)],
        ),
      ),
    );
  }

  /// 底部状态区：加载中 / 失败重试 / 没有更多 / 还有更多。
  Widget _buildFooter(BuildContext context) {
    final theme = AntTheme.of(context);
    final style = TextStyle(
      fontSize: 14.sp,
      color: theme.colorTextSecondary,
    );

    if (_loading) {
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

    if (_failed) {
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

    if (!_hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: Text(
          widget.noMoreText ?? AntInfiniteScrollDefaults.noMoreText,
          style: style.copyWith(color: theme.colorTextTertiary),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      child: Text(
        widget.hasMoreText ?? AntInfiniteScrollDefaults.hasMoreText,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
