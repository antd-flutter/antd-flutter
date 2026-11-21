/// AntSearchBar 类型定义
library;

/// 取消按钮显示策略
enum AntSearchBarCancelMode {
  /// 始终隐藏取消按钮
  never,

  /// 仅在聚焦时显示取消按钮
  focus,

  /// 始终显示取消按钮
  always,
}