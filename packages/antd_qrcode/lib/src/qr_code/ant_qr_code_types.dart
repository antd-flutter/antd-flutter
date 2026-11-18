/// AntQRCode 类型定义
library;

/// 二维码纠错等级 — 对齐 antd v6 QRCode 的 errorLevel。
enum AntQRCodeErrorLevel {
  /// 低（7% 纠错）
  l,

  /// 中（15% 纠错，默认）
  m,

  /// 四分之一（25% 纠错）
  q,

  /// 高（30% 纠错）
  h,
}

/// 二维码状态 — 对齐 antd v6 QRCode 的 status。
enum AntQRCodeStatus {
  /// 正常（默认）
  active,

  /// 已过期 — 显示覆盖层，点击可刷新
  expired,

  /// 已扫描 — 显示已扫描覆盖层
  scanned,
}
