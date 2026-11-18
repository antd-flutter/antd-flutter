/// AntPullToRefresh 指示器状态机 Notifier。
///
/// 架构参考 [easy_refresh](https://pub.dev/packages/easy_refresh)
/// （MIT License）的 `IndicatorNotifier` 设计整体重写：
/// - 状态（mode / offset）与动画全部收敛在 Notifier 中，
///   指示器组件（[AntPullToRefreshHeader]）
///   只消费状态渲染，不持有逻辑（对应 ER「Notifier 驱动 + 指示器只 build」
///   与 custom position 指示器的 Listenable 形态）；
/// - 任务编排由 Notifier 统一完成：触发 → 刷新中 → 等待任务完成 → 回弹复位；
/// - 位移动画收敛在 Notifier（Notifier 内部持有动画控制器，
///   对应 ER IndicatorNotifier 的 clamping 动画控制器思路）。
library;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh_types.dart';

/// 头部展开/回弹动画时长（与组件层的 [kAntPullToRefreshDuration] 对齐）。
const Duration kIndicatorAnimationDuration = Duration(milliseconds: 300);

/// 单包独享的刷新指示器状态机。
///
/// 一次完整的下拉刷新生命周期：
/// idle → pulling → canRelease →（释放）refreshing → complete → idle。
class AntPullToRefreshIndicator extends ChangeNotifier {
  /// 创建状态机。
  ///
  /// [vsync] 用于位移回弹动画（对应 ER Notifier 内部持有动画控制器）；
  /// [onModeChanged] 在状态跃迁时回调，
  /// 供组件转发 `pullStatusChange` 等对外 API。
  AntPullToRefreshIndicator({
    required TickerProvider vsync,
    this.onModeChanged,
  }) {
    _offsetController = AnimationController(
      vsync: vsync,
      duration: kIndicatorAnimationDuration,
    )..addListener(_handleOffsetTick);
  }

  /// 头部状态跃迁回调（对外 [AntPullToRefresh.pullStatusChange]）。
  final ValueChanged<AntPullToRefreshStatus>? onModeChanged;

  late final AnimationController _offsetController;

  /// 当前回弹动画（Tween 驱动，见 [animateTo]）。
  Animation<double>? _offsetAnimation;

  /// 当前动画目标位移（0 = 回弹复位，到位后状态机回 idle）。
  double _animTarget = 0;

  AntPullToRefreshStatus _mode = AntPullToRefreshStatus.idle;

  /// 当前头部状态。
  AntPullToRefreshStatus get mode => _mode;

  double _offset = 0;

  /// 当前头部/内容位移量。
  double get offset => _offset;

  /// 运行期配置（由组件在 didUpdateWidget 时同步）。
  double _headHeight = 40;
  double _threshold = 50; // 与组件层 kAntPullToRefreshThreshold 对齐。
  bool _isTop = true;

  /// 当前一次拉动是否由桌面滚轮驱动（滚轮没有「松手」事件，
  /// 由组件层的停止滚动计时触发 release）。
  bool wheelDriven = false;

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

  /// 位移累积（触摸过冲与桌面滚轮共用；[wheelDriven] 由调用方标记）。
  void _accumulate(double delta) {
    _offset = (_offset + delta).clamp(0.0, _headHeight * maxPullFactor);
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

  /// 物理层过冲同步（Bouncing 系物理：过冲直接写入 pixels 超出范围，
  /// 不产生 OverscrollNotification，由组件层从滚动度量换算位移后同步）。
  ///
  /// [amount] 为过冲量（拉动方向为正）；≤0 表示已回到范围内（回弹/回拉），
  /// 位移清零并回 idle。刷新中/完成阶段不响应（由 runRefresh 接管动画）。
  void syncOverscroll(double amount) {
    if (!canPull) return;
    if (amount <= 0) {
      if (_offset > 0) {
        _offset = 0;
        wheelDriven = false;
        _setMode(AntPullToRefreshStatus.idle);
        notifyListeners();
      }
      return;
    }
    _offset = amount.clamp(0.0, _headHeight * maxPullFactor);
    _setMode(
      _offset >= _threshold
          ? AntPullToRefreshStatus.canRelease
          : AntPullToRefreshStatus.pulling,
    );
    notifyListeners();
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

  /// 执行刷新：头部展开到 headHeight → 等待任务完成 → 回弹。
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
    animateTo(0);
  }

  // ============================================================
  // 动画
  // ============================================================

  /// 回弹到目标位移（Notifier 内部持有动画控制器，
  /// 对应 ER IndicatorNotifier 的 clamping 动画控制器思路）。
  void animateTo(double target) {
    _animTarget = target;
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
    // 回弹复位动画（目标 0）到位后状态机回 idle：complete/pulling/canRelease
    // 残留会让 canPull 恒为 false，导致后续手势永久失效。
    // （展开动画目标 > 0，不能复位。）
    if (_animTarget <= 0 &&
        _offset <= 0 &&
        _mode != AntPullToRefreshStatus.idle) {
      wheelDriven = false;
      _setMode(AntPullToRefreshStatus.idle);
    }
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
