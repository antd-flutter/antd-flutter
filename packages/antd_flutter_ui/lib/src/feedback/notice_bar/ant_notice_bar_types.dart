/// AntNoticeBar 类型定义 — 与 antd-mobile NoticeBar API 对齐
library;

/// 通告栏语义颜色类型。
enum AntNoticeBarColor {
  /// 默认 — 灰底白字（对应 antd-mobile `default`）。
  normal,

  /// 警告 — 黄底深字（对应 antd-mobile `alert`）。
  alert,

  /// 错误 — 红底白字。
  error,

  /// 信息 — 蓝底深字。
  info,

  /// 成功 — 绿底深字。
  success,
}

/// 通告栏形状。
enum AntNoticeBarShape {
  /// 直角（默认）— 无圆角。
  rectangular,

  /// 圆角 — 四角小圆角。
  neutral,

  /// 圆形 — 胶囊形大圆角。
  rounded,
}

/// 通告栏边框模式。
enum AntNoticeBarBorder {
  /// 仅上下边框（默认）。
  block,

  /// 全边框。
  full,

  /// 无边框。
  none,
}