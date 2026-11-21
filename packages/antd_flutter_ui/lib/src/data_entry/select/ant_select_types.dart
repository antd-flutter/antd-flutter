/// AntSelect 类型定义
library;

/// 选择器模式
enum AntSelectMode {
  /// 单选
  single,

  /// 多选
  multiple,
}

/// 选择器尺寸
enum AntSelectSize {
  /// 大号
  large,

  /// 中号（默认）
  middle,

  /// 小号
  small,
}

/// 选择器选项（旧模型，自 1.x 起推荐直接用 `AntSelect<T>(options: List<T>)`
/// 配合 `labelOf` / `valueExtractor`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf；本类将在 2.0 移除')
class AntSelectOption<T> {
  const AntSelectOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  /// 选项值。
  final T value;

  /// 选项文本。
  final String label;

  /// 是否禁用。
  final bool disabled;
}
