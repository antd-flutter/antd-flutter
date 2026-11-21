/// AntRefreshController 族 — 刷新组件的程序化控制（R35.2 Controller 优先）
///
/// 对齐 Flutter 惯例（ScrollController / EasyRefreshController 模式）：
/// 组件暴露可选 `controller` 参数，外部经 Controller 调用程序化动作
/// （callRefresh / callLoadMore），替代 GlobalKey State 直调路径；
/// attach/detach 由组件内部在生命周期中调用（使用方无需手动调用），
/// 对应 ScrollPosition 的 attach/detach 惯例。
///
/// ```dart
/// final controller = AntPullToRefreshController();
/// AntPullToRefresh(controller: controller, ...);
/// controller.callRefresh(); // 程序化触发下拉刷新
/// ```
library;

import 'infinite_scroll/ant_infinite_scroll.dart';
import 'pull_to_refresh/ant_pull_to_refresh.dart';

/// 刷新组件 Controller 基类：统一 [isAttached] 生命周期状态与未挂载保护。
abstract class AntRefreshController {
  bool _attached = false;

  /// 是否已挂载到组件（组件 initState 时 attach，dispose 时 detach）。
  bool get isAttached => _attached;

  /// 更新挂载状态（组件内部调用）。
  void _setAttached(bool value) => _attached = value;

  /// 未挂载时抛错（对齐 ScrollController 无 position 时 assert 的惯例）。
  void _requireAttached() {
    if (!_attached) {
      throw StateError(
        '$runtimeType 未挂载到组件（isAttached=false），请确认 controller '
        '已传入对应组件的 controller 参数且组件已在树上。',
      );
    }
  }
}

/// [AntPullToRefresh] 的控制器：程序化触发下拉刷新。
class AntPullToRefreshController extends AntRefreshController {
  AntPullToRefreshState? _state;

  /// 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例）。
  void attach(AntPullToRefreshState state) {
    _state = state;
    _setAttached(true);
  }

  /// 组件销毁/换绑时由内部调用。
  void detach(AntPullToRefreshState state) {
    if (identical(_state, state)) {
      _state = null;
      _setAttached(false);
    }
  }

  /// 程序化触发下拉刷新：头部展开 → 等待 onRefresh 完成 → 回弹。
  ///
  /// 未挂载（[isAttached] == false）时抛 [StateError]。
  Future<void> callRefresh() {
    _requireAttached();
    return _state!.callRefresh();
  }
}

/// [AntInfiniteScroll] 的控制器：程序化触发加载更多 / 重置分页状态。
class AntInfiniteScrollController extends AntRefreshController {
  AntInfiniteScrollState? _state;

  /// 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例）。
  void attach(AntInfiniteScrollState state) {
    _state = state;
    _setAttached(true);
  }

  /// 组件销毁/换绑时由内部调用。
  void detach(AntInfiniteScrollState state) {
    if (identical(_state, state)) {
      _state = null;
      _setAttached(false);
    }
  }

  /// 程序化触发加载更多（加载中为空操作；失败态下等价于点击重试）。
  ///
  /// 未挂载（[isAttached] == false）时抛 [StateError]。
  Future<void> callLoadMore() {
    _requireAttached();
    return _state!.callLoadMore();
  }

  /// 重置分页状态：清除失败态并恢复「还有更多」（切换数据源/筛选条件后使用）。
  ///
  /// 未挂载（[isAttached] == false）时抛 [StateError]。
  void reset() {
    _requireAttached();
    _state!.reset();
  }
}
