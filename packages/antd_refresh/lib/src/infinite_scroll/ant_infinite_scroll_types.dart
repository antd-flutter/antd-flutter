/// AntInfiniteScroll — 类型定义与默认配置
///
/// 存放 AntInfiniteScroll 组件的默认文案与默认值常量，
/// 与组件实现（ant_infinite_scroll.dart）分离，便于复用与维护。
///
/// 对齐 antd-mobile InfiniteScroll 的默认文案。
library;

/// AntInfiniteScroll 默认配置。
class AntInfiniteScrollDefaults {
  const AntInfiniteScrollDefaults._();

  /// 默认触发阈值（逻辑像素），滚动位置距底部小于该值时触发加载。
  static const double threshold = 0;

  /// 默认加载中文案。
  static const String loadingText = '加载中';

  /// 默认还有更多数据时的提示文案。
  static const String hasMoreText = '上拉加载更多';

  /// 默认没有更多数据时的提示文案。
  static const String noMoreText = '没有更多了';

  /// 默认加载失败提示文案。
  static const String loadFailedText = '加载失败';

  /// 默认加载失败重试按钮文案。
  static const String loadFailedRetryText = '点击重试';
}
