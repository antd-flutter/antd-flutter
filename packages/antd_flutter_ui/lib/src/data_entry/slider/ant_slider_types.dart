/// AntSlider 类型定义
library;

/// 滑动输入条刻度标记（现成模型）。
///
/// 也可以直接传 `List<double>` 或任意业务模型，配合
/// `AntSlider<T>(markValueOf: ..., markLabelOf: ...)`。
class AntSliderMark {
  const AntSliderMark({
    required this.value,
    required this.label,
  });

  /// 刻度值。
  final double value;

  /// 刻度文本。
  final String label;
}
