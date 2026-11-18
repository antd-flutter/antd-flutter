/// AntPullToRefresh 类型定义 — antd-mobile PullToRefresh 的 Flutter 实现
library;

/// 下拉刷新状态。
///
/// 对齐 antd-mobile PullToRefresh 的生命周期：
/// idle → pulling → canRelease → refreshing → complete。
enum AntPullToRefreshStatus {
  /// 初始状态（未下拉）。
  idle,

  /// 下拉中但未达到触发阈值。
  pulling,

  /// 下拉已达到阈值，松手即可触发刷新。
  canRelease,

  /// 刷新中（onRefresh 执行期间）。
  refreshing,

  /// 刷新完成（展示 completeText，回弹结束后回到 idle）。
  complete,
}

/// 下拉刷新指针位置。
///
/// 对齐 antd-mobile PullToRefresh 的 pointer 属性：
/// - top：从列表顶部下拉刷新（默认）
/// - bottom：从列表底部上拉刷新
enum AntPullToRefreshPointer {
  /// 顶部下拉（默认）。
  top,

  /// 底部上拉。
  bottom,
}

/// 加载更多（footer）状态。
///
/// 结构参照 [easy_refresh](https://pub.dev/packages/easy_refresh)
/// 的 `IndicatorMode` 中 load 相关状态（MIT License）精简：
/// idle → loading →（more 回到 idle / noMore / failed 点击重试）。
enum AntPullToRefreshFooterStatus {
  /// 初始状态（footer 不展示）。
  idle,

  /// 加载更多中（转圈展示）。
  loading,

  /// 没有更多数据（文案展示，不再触发）。
  noMore,

  /// 加载失败（文案 + 点击重试）。
  failed,
}

/// [AntPullToRefresh.onLoadMore] 的加载结果。
///
/// 参照 easy_refresh `IndicatorResult` 精简为三个结果：
/// - [more]：还有更多数据，footer 回到 idle，可继续触发；
/// - [noMore]：没有更多数据，footer 常驻提示，直到下次刷新成功后重置；
/// - [failed]：加载失败，footer 展示失败态，点击重试再次触发。
enum AntPullToRefreshLoadResult {
  /// 还有更多数据。
  more,

  /// 没有更多数据。
  noMore,

  /// 加载失败。
  failed,
}
