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

/// 选择器选项
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