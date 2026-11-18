/// AntPullToRefresh 指示器状态机 Notifier。
///
/// 架构参考 [easy_refresh](https://pub.dev/packages/easy_refresh)
/// （MIT License）的 `IndicatorNotifier` 设计整体重写：
/// - 状态（mode / offset / footer mode）与动画全部收敛在 Notifier 中，
///   指示器组件（[AntPullToRefreshHeader] / [AntPullToRefreshFooter]）
///   只消费状态渲染，不持有逻辑（对应 ER「Notifier 驱动 + 指示器只 build」
///   与 custom position 指示器的 Listenable 形态）；
/// - 任务编排由 Notifier 统一完成：触发 → 刷新/加载中 → 等待任务完成 →
///   结果回写（footer 的 more / noMore / failed）→ 回弹复位；
/// - 位移动画收敛在 Notifier（Notifier 内部持有动画控制器，
///   对应 ER IndicatorNotifier 的 clamping 动画控制器思路）。
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh_types.dart';

/// 头部展开/回弹动画时长（与组件层的 [kAntPullToRefreshDuration] 对齐）。
const Duration kIndicatorAnimationDuration = Duration(milliseconds: 300);

/// 单包独享的刷新/加载指示器状态机。
///
/// 一次完整的下拉刷新生命周期：
/// idle → pulling → canRelease →（释放）refreshing → complete → idle；
/// 加载更多生命周期：idle → loading →（结果）idle / noMore / failed。
class AntPullToRefreshIndicator extends ChangeNotifier {
  /// 创建状态机。
  ///
  /// [vsync] 用于位移回弹动画（对应 ER Notifier 内部持有动画控制器）；
  /// [onModeChanged] / [onFooterModeChanged] 在状态跃迁时回调，
  /// 供组件转发 `pullStatusChange` 等对外 API。
  AntPullToRefreshIndicator({
    required TickerProvider vsync,
    this.onModeChanged,
    this.onFooterModeChanged,
  }) {
    _offsetController = AnimationController(
      vsync: vsync,
      duration: kIndicatorAnimationDuration,
    )..addListener(_handleOffsetTick);
  }

  /// 头部状态跃迁回调（对外 [AntPullToRefresh.pullStatusChange]）。
  final ValueChanged<AntPullToRefreshStatus>? onModeChanged;

  /// 底部状态跃迁回调（组件内部接线重试等）。
  final ValueChanged<AntPullToRefreshFooterStatus>? onFooterModeChanged;

  late final AnimationController _offsetController;

  /// 当前回弹动画（Tween 驱动，见 [animateTo]）。
  Animation<double>? _offsetAnimation;

  AntPullToRefreshStatus _mode = AntPullToRefreshStatus.idle;

  /// 当前头部状态。
  AntPullToRefreshStatus get mode => _mode;

  double _offset = 0;

  /// 当前头部/内容位移量。
  double get offset => _offset;

  AntPullToRefreshFooterStatus _footerMode = AntPullToRefreshFooterStatus.idle;

  /// 当前底部（加载更多）状态。
  AntPullToRefreshFooterStatus get footerMode => _footerMode;

  /// 运行期配置（由组件在 didUpdateWidget 时同步）。
  double _headHeight = 40;
  double _threshold = 60;
  bool _isTop = true;

  /// 当前一次拉动是否由桌面滚轮驱动（滚轮没有「松手」事件，
  /// 由组件层的停止滚动计时触发 release）。
  bool wheelDriven = false;

  /// 加载更多触发臂：滚动离开底部边缘后重新武装，防止短列表在底部
  /// 反复触发（对齐 ER footer 的 canProcess 思路）。
  bool _loadArmed = true;

  /// 加载更多执行中标记（防重入，对应 ER 任务 in-progress 判定）。
  bool _loadingMore = false;

  // ============================================================
  // 配置
  // ============================================================

  /// 同步组件配置（headHeight / threshold / pointer），状态不变。
  void configure({
    required double headHeight,
    required double threshold,
    required bool isTop,
  }) {
    _headHeight = headHeight;
    _threshold = threshold;
    _isTop = isTop;
  }

  double get headHeight => _headHeight;
  double get threshold => _threshold;

  /// 指针位置是否在顶部（top 下拉 / bottom 上拉）。
  bool get isTop => _isTop;

  /// 最大下拉距离 = headHeight * 3（参照轮子 maxOverScrollExtent 思路）。
  static const double maxPullFactor = 3;

  // ============================================================
  // 状态查询
  // ============================================================

  /// 是否允许响应拉动（刷新中/完成阶段不响应新的下拉）。
  bool get canPull =>
      _mode == AntPullToRefreshStatus.idle ||
      _mode == AntPullToRefreshStatus.pulling ||
      _mode == AntPullToRefreshStatus.canRelease;

  /// 是否处于任务执行阶段（刷新中/完成），期间不触发新的任务。
  bool get taskRunning =>
      _mode == AntPullToRefreshStatus.refreshing ||
      _mode == AntPullToRefreshStatus.complete;

  bool get loadingMore => _loadingMore;

  // ============================================================
  // 拉动状态机
  // ============================================================

  /// 更新头部状态并通知。
  void _setMode(AntPullToRefreshStatus status) {
    if (_mode == status) return;
    _mode = status;
    onModeChanged?.call(status);
    notifyListeners();
  }

  /// 更新底部状态并通知。
  void _setFooterMode(AntPullToRefreshFooterStatus status) {
    if (_footerMode == status) return;
    _footerMode = status;
    onFooterModeChanged?.call(status);
    notifyListeners();
  }

  /// 位移累积（触摸过冲与桌面滚轮共用；[wheelDriven] 由调用方标记）。
  void _accumulate(double delta) {
    _offset = (_offset + delta)
        .clamp(0.0, _headHeight * maxPullFactor);
    _setMode(
      _offset >= _threshold
          ? AntPullToRefreshStatus.canRelease
          : AntPullToRefreshStatus.pulling,
    );
    if (_offset <= 0) {
      wheelDriven = false;
      _setMode(AntPullToRefreshStatus.idle);
    }
    notifyListeners();
  }

  /// 触摸过冲拉动（移动端主路径）。
  void drag(double overscroll) {
    if (!canPull) return;
    _accumulate(_isTop ? -overscroll : overscroll);
  }

  /// 桌面端滚轮拉动：累积位移并标记滚轮驱动。
  void wheelPull(double step) {
    if (!canPull) return;
    wheelDriven = true;
    _accumulate(step);
  }

  /// 松手：超过阈值触发刷新，否则回弹（滚动结束路径）。
  void release(Future<void> Function()? onRefresh) {
    wheelDriven = false;
    if (!canPull) return;
    if (_offset >= _threshold && onRefresh != null) {
      runRefresh(onRefresh);
    } else {
      _setMode(AntPullToRefreshStatus.idle);
      animateTo(0);
    }
  }

  // ============================================================
  // 任务编排（刷新）
  // ============================================================

  /// 执行刷新：头部展开到 headHeight → 等待任务完成 → 结果回写 → 回弹。
  ///
  /// 对应 ER 的任务编排（trigger → processing → processed → done）。
  Future<void> runRefresh(Future<void> Function()? task) async {
    _setMode(AntPullToRefreshStatus.refreshing);
    animateTo(_headHeight);
    try {
      await task?.call();
    } catch (_) {
      // 刷新回调异常不阻塞流程，照常完成回弹。
    }
    _setMode(AntPullToRefreshStatus.complete);
    // 刷新成功后重置 footer 的 noMore/failed 状态（对齐 easy_refresh
    // callRefresh 重置 footer 的行为）。
    if (_footerMode != AntPullToRefreshFooterStatus.idle &&
        _footerMode != AntPullToRefreshFooterStatus.loading) {
      _setFooterMode(AntPullToRefreshFooterStatus.idle);
    }
    animateTo(0);
  }

  // ============================================================
  // 任务编排（加载更多）
  // ============================================================

  /// 滚动结束停在底部边缘时判断是否触发加载更多。
  bool shouldLoadMore(ScrollMetrics metrics) {
    if (!_loadArmed || _loadingMore) return false;
    if (_footerMode == AntPullToRefreshFooterStatus.noMore) return false;
    return metrics.pixels >=
        metrics.maxScrollExtent - precisionErrorTolerance;
  }

  /// 滚动离开底部边缘 → 重新武装加载更多。
  void armLoadIfScrolled(ScrollMetrics metrics) {
    if (metrics.pixels < metrics.maxScrollExtent - precisionErrorTolerance) {
      _loadArmed = true;
    }
  }

  /// 触发加载更多（滚动到底部 / 失败重试）。
  ///
  /// 返回任务是否被触发；结果通过 footer 状态回写。
  Future<bool> startLoad({
    required bool enableLoadMore,
    required Future<AntPullToRefreshLoadResult> Function()? onLoadMore,
    bool fromRetry = false,
  }) async {
    if (!enableLoadMore || onLoadMore == null) return false;
    if (_loadingMore) return false;
    if (taskRunning) return false;
    if (!fromRetry && _footerMode == AntPullToRefreshFooterStatus.noMore) {
      return false;
    }
    _loadingMore = true;
    _setFooterMode(AntPullToRefreshFooterStatus.loading);
    AntPullToRefreshLoadResult result;
    try {
      result = await onLoadMore();
    } catch (_) {
      // 回调异常视为加载失败，展示重试。
      result = AntPullToRefreshLoadResult.failed;
    }
    _loadingMore = false;
    switch (result) {
      case AntPullToRefreshLoadResult.more:
        // 回到 idle；需滚动离开底部边缘后重新武装，避免短列表循环触发。
        _setFooterMode(AntPullToRefreshFooterStatus.idle);
        _loadArmed = false;
        break;
      case AntPullToRefreshLoadResult.noMore:
        _setFooterMode(AntPullToRefreshFooterStatus.noMore);
        break;
      case AntPullToRefreshLoadResult.failed:
        _setFooterMode(AntPullToRefreshFooterStatus.failed);
        break;
    }
    return true;
  }

  // ============================================================
  // 动画
  // ============================================================

  /// 回弹到目标位移（Notifier 内部持有动画控制器，
  /// 对应 ER IndicatorNotifier 的 clamping 动画控制器思路）。
  void animateTo(double target) {
    _offsetAnimation = Tween<double>(
      begin: _offset,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _offsetController,
        curve: Curves.easeOutCubic,
      ),
    );
    _offsetController.forward(from: 0);
  }

  void _handleOffsetTick() {
    final anim = _offsetAnimation;
    if (anim == null) return;
    _offset = anim.value;
    notifyListeners();
  }

  @override
  void dispose() {
    _offsetController.removeListener(_handleOffsetTick);
    _offsetController.dispose();
    super.dispose();
  }
}

/// 内层可滚动组件是否停在拉动边缘（top：顶部；bottom：底部）。
///
/// 滚轮事件被 Scrollable 的 PointerSignalResolver 消费后，
/// 在边缘处会被 clamp 成 no-op，不会产生任何过冲通知，
/// 因此需要用滚动度量自行判定「继续滚动即是拉动」。
bool atPullEdge(ScrollMetrics? metrics, {required bool isTop}) {
  if (metrics == null) return true;
  return isTop
      ? metrics.pixels <= metrics.minScrollExtent + precisionErrorTolerance
      : metrics.pixels >= metrics.maxScrollExtent - precisionErrorTolerance;
}
