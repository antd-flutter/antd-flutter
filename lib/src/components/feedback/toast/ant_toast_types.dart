/// AntToast 类型定义
library;

/// 轻提示展示位置。
enum AntToastPosition {
  /// 顶部
  top,

  /// 屏幕中央（默认）
  center,

  /// 底部
  bottom,
}

/// 内置图标类型。
enum AntToastIconType {
  /// 成功
  success,

  /// 失败
  fail,

  /// 加载中（默认不自动消失）
  loading,
}
