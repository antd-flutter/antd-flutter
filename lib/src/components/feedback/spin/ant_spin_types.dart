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
