/// AntFlex 类型定义
library;

/// 主轴对齐方式。
enum AntFlexJustify {
  /// 起点对齐（默认）。
  start,

  /// 终点对齐。
  end,

  /// 居中对齐。
  center,

  /// 两端对齐，元素间间隔相等。
  spaceBetween,

  /// 每个元素两侧间隔相等。
  spaceAround,

  /// 所有间隔完全相等。
  spaceEvenly,
}

/// 交叉轴对齐方式。
enum AntFlexAlign {
  /// 起点对齐（默认）。
  start,

  /// 终点对齐。
  end,

  /// 居中对齐。
  center,

  /// 基线对齐。
  baseline,

  /// 拉伸填充交叉轴。
  stretch,
}

/// 间距尺寸预设。
enum AntFlexGapSize {
  /// 小间距（marginXS = 8）。
  small,

  /// 中间距（margin = 16）。
  middle,

  /// 大间距（marginLG = 24）。
  large,
}

/// Flex 间距配置。
///
/// 对齐 antd React 的 gap 属性，支持三种形式：
/// - 预设尺寸：[AntFlexGap.small] / [AntFlexGap.middle] / [AntFlexGap.large]
/// - 单值：[AntFlexGap.all]（同时设置行间距和列间距）
/// - 双值：[AntFlexGap.only]（分别设置行间距和列间距）
class AntFlexGap {
  const AntFlexGap._(this.size, this.rowValue, this.columnValue);

  /// 间距预设。
  final AntFlexGapSize? size;

  /// 自定义行间距值（交叉轴方向，换行时行与行之间）。
  final double? rowValue;

  /// 自定义列间距值（主轴方向，元素与元素之间）。
  final double? columnValue;

  /// 小间距预设。
  const AntFlexGap.small() : this._(AntFlexGapSize.small, null, null);

  /// 中间距预设。
  const AntFlexGap.middle() : this._(AntFlexGapSize.middle, null, null);

  /// 大间距预设。
  const AntFlexGap.large() : this._(AntFlexGapSize.large, null, null);

  /// 单值 — 同时设置行间距和列间距。
  const AntFlexGap.all(double value) : this._(null, value, value);

  /// 分别设置行间距和列间距。
  const AntFlexGap.only({double? row, double? column})
      : this._(null, row, column);
}