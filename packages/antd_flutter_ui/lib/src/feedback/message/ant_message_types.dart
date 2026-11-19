/// AntMessage 类型定义
library;

/// 全局提示类型。
enum AntMessageType {
  /// 普通（信息）
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,

  /// 加载中（默认不自动消失）
  loading,
}
