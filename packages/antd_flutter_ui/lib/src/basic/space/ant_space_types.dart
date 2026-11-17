/// AntSpace 类型定义
library;

/// 排列方向。
enum AntSpaceDirection {
  /// 水平排列（默认）。
  horizontal,

  /// 垂直排列。
  vertical,
}

/// 交叉轴对齐方式。
enum AntSpaceAlign {
  /// 起点对齐。
  start,

  /// 终点对齐。
  end,

  /// 居中对齐。
  center,

  /// 基线对齐。
  baseline,
}

/// 间距尺寸预设。
enum AntSpaceGapSize {
  /// 小间距（marginXS = 8）。
  small,

  /// 中间距（margin = 16）。
  middle,

  /// 大间距（marginLG = 24）。
  large,
}

/// Space 间距配置。
///
/// 对齐 antd React Space 的 size 属性，支持三种形式：
/// - 预设尺寸：[AntSpaceSize.small] / [AntSpaceSize.middle] / [AntSpaceSize.large]
/// - 单值：[AntSpaceSize.all]（同时设置水平和垂直间距）
/// - 双值：[AntSpaceSize.only]（分别设置水平和垂直间距）
class AntSpaceSize {
  const AntSpaceSize._(this.preset, this.horizontalValue, this.verticalValue);

  /// 间距预设。
  final AntSpaceGapSize? preset;

  /// 自定义水平间距值。
  final double? horizontalValue;

  /// 自定义垂直间距值。
  final double? verticalValue;

  /// 小间距预设。
  const AntSpaceSize.small() : this._(AntSpaceGapSize.small, null, null);

  /// 中间距预设。
  const AntSpaceSize.middle() : this._(AntSpaceGapSize.middle, null, null);

  /// 大间距预设。
  const AntSpaceSize.large() : this._(AntSpaceGapSize.large, null, null);

  /// 单值 — 同时设置水平和垂直间距。
  const AntSpaceSize.all(double value)
      : this._(null, value, value);

  /// 分别设置水平和垂直间距。
  const AntSpaceSize.only({double? horizontal, double? vertical})
      : this._(null, horizontal, vertical);
}