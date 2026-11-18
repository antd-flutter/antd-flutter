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
