/// AntSpin 类型定义 — 对齐 antd React Spin 的配置项
library;

/// Spin 尺寸。
enum AntSpinSize {
  /// 大（32 逻辑像素）。
  large(32),

  /// 中（默认，20 逻辑像素）。
  middle(20),

  /// 小（14 逻辑像素）。
  small(14);

  const AntSpinSize(this.indicatorSize);

  /// 指示器尺寸（逻辑像素）。
  final double indicatorSize;
}

/// Spin 指示器样式 — 对齐 antd React Spin 的 indicator 风格。
enum AntSpinIndicatorType {
  /// 旋转圆环（默认，与 antd-mobile 风格一致的 3/4 圆弧）。
  circle,

  /// antd 经典四点旋转点阵动画。
  dot,
}
