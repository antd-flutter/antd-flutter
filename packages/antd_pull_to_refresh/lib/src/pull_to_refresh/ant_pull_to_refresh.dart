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
/// ```dart
/// AntPullToRefresh(
///   onRefresh: () async {
///     await Future<void>.delayed(const Duration(seconds: 1));
///   },
///   child: ListView(children: const [Text('item')]),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh_types.dart';
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

/// 默认文案。
const String kAntPullToRefreshPullingText = '下拉刷新';
const String kAntPullToRefreshReleasingText = '释放刷新';
const String kAntPullToRefreshFinishingText = '加载中...';
const String kAntPullToRefreshCompleteText = '刷新完成';

// ============================================================
// AntPullToRefresh
// ============================================================

/// 下拉刷新 — 在可滚动内容顶部下拉触发刷新。
///
/// 对齐 antd-mobile PullToRefresh 组件：下拉时头部跟随位移并显示
/// 「下拉刷新 → 释放刷新 → 加载转圈 → 完成」提示，松手超过
/// [AntPullToRefresh.threshold] 触发 [AntPullToRefresh.onRefresh]，
/// Future 完成后自动回弹。
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

  late final AnimationController _bounceController = AnimationController(
    vsync: this,
    duration: kAntPullToRefreshDuration,
  );

  Animation<double>? _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController.addListener(_handleBounceTick);
  }

  @override
  void dispose() {
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

  /// 处理滚动过冲位移。
  void _handleOverscroll(double overscroll) {
    if (!_canPull) return;
    final double delta =
        widget.pointer == AntPullToRefreshPointer.top ? -overscroll : overscroll;
    setState(() {
      _offset = (_offset + delta).clamp(0.0, widget.headHeight * 3);
      _updateStatus(
        _offset >= widget.threshold
            ? AntPullToRefreshStatus.canRelease
            : AntPullToRefreshStatus.pulling,
      );
    });
  }

  /// 松手：超过阈值触发刷新，否则回弹。
  void _handleRelease() {
    if (!_canPull) return;
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

  bool _handleScrollNotification(ScrollNotification notification) {
    // 刷新中/完成阶段不响应新的下拉。
    if (_status == AntPullToRefreshStatus.refreshing ||
        _status == AntPullToRefreshStatus.complete) {
      return false;
    }
    if (notification is OverscrollNotification) {
      final bool hit = widget.pointer == AntPullToRefreshPointer.top
          ? notification.overscroll < 0
          : notification.overscroll > 0;
      if (hit) _handleOverscroll(notification.overscroll);
      return false;
    }
    if (notification is ScrollEndNotification) {
      _handleRelease();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bool isTop = widget.pointer == AntPullToRefreshPointer.top;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
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
                isTop ? _offset - widget.headHeight : widget.headHeight - _offset,
              ),
              child: Container(
                alignment: Alignment.center,
                color: theme.colorBgLayout,
                // 未下拉时头部整体移出可视区，内容不参与命中与语义树。
                child: Visibility(
                  visible: _offset > 0,
                  child: widget.header ?? _buildDefaultHeader(theme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 默认头部：按状态显示 文案 + 箭头 / 转圈 / 完成标记。
  Widget _buildDefaultHeader(AntThemeData theme) {
    final String text = switch (_status) {
      AntPullToRefreshStatus.canRelease =>
        widget.releasingText ?? kAntPullToRefreshReleasingText,
      AntPullToRefreshStatus.refreshing =>
        widget.finishingText ?? kAntPullToRefreshFinishingText,
      AntPullToRefreshStatus.complete =>
        widget.completeText ?? kAntPullToRefreshCompleteText,
      _ => widget.pullingText ?? kAntPullToRefreshPullingText,
    };

    final Widget indicator = switch (_status) {
      AntPullToRefreshStatus.canRelease => Icon(
          Icons.arrow_upward,
          size: 16,
          color: theme.colorTextSecondary,
        ),
      AntPullToRefreshStatus.refreshing => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      AntPullToRefreshStatus.complete => Icon(
          Icons.check,
          size: 16,
          color: theme.colorSuccess,
        ),
      _ => Icon(
          Icons.arrow_downward,
          size: 16,
          color: theme.colorTextSecondary,
        ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorTextSecondary,
          ),
        ),
      ],
    );
  }
}
