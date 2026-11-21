/// AntInput 类型定义
library;

/// 输入框尺寸
enum AntInputSize {
  /// 大号（controlHeightLG = 40）
  large,

  /// 中号（controlHeight = 32，默认）
  middle,

  /// 小号（controlHeightSM = 24）
  small,
}

/// 输入框校验状态
enum AntInputStatus {
  /// 正常
  normal,

  /// 错误
  error,

  /// 警告
  warning,
}