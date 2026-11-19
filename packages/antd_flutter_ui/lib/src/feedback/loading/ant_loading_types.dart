/// AntLoading 类型定义 — 对齐 antd-mobile Loading 的配置项
library;


/// Loading 旋转速度配置（每秒旋转圈数）。
class AntLoadingSpeed {
  const AntLoadingSpeed._(this.revolutionsPerSecond);

  /// 每秒旋转圈数。
  final double revolutionsPerSecond;

  /// 默认速度（约每秒 1.4 圈，对齐 antd-mobile 观感）。
  static const AntLoadingSpeed normal = AntLoadingSpeed._(1.4);

  /// 慢速（每秒 0.8 圈）。
  static const AntLoadingSpeed slow = AntLoadingSpeed._(0.8);

  /// 快速（每秒 2 圈）。
  static const AntLoadingSpeed fast = AntLoadingSpeed._(2);
}

/// Loading 默认尺寸。
const double kAntLoadingSize = 18;

/// 圆弧缺口比例（3/4 圆弧，对齐 antd-mobile 转圈观感）。
const double kAntLoadingArcSweep = 4.6;

/// 圆弧描边宽度。
const double kAntLoadingStrokeWidth = 2;

/// 内容在转圈图标之后（右侧）。
const AntLoadingDirection kAntLoadingDefaultDirection =
    AntLoadingDirection.row;

/// 内容排布方向。
enum AntLoadingDirection {
  /// 转圈图标在左，内容在右（默认）。
  row,

  /// 转圈图标在上，内容在下。
  column,
}
