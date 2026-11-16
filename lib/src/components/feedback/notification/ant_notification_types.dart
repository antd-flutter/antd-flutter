/// AntNotification 类型定义
library;

/// 通知类型。
enum AntNotificationType {
  /// 信息
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,
}

/// 通知弹出位置（屏幕四角）。
enum AntNotificationPlacement {
  /// 右上角（默认）
  topRight,

  /// 左上角
  topLeft,

  /// 右下角
  bottomRight,

  /// 左下角
  bottomLeft,
}
