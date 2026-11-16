/// AntProgress 类型定义
library;

/// 进度条状态。
enum AntProgressStatus {
  /// 普通（默认，主题色）
  normal,

  /// 成功
  success,

  /// 异常
  exception,

  /// 激活动画
  active,
}

/// 进度条类型。
enum AntProgressType {
  /// 线形
  line,

  /// 圆形
  circle,
}
