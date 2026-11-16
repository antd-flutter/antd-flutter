/// AntPicker / AntPickerView 类型定义
library;

/// 选择器值类型
typedef AntPickerValue = String?;

/// 选择器列项
class AntPickerColumnItem {
  const AntPickerColumnItem({
    required this.label,
    required this.value,
    this.key,
  });

  /// 显示文本。
  final String label;

  /// 项值。
  final String value;

  /// 自定义 key。
  final String? key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntPickerColumnItem &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => Object.hash(label, value);

  @override
  String toString() => 'AntPickerColumnItem(label: $label, value: $value)';
}

/// 选择器列
typedef AntPickerColumn = List<AntPickerColumnItem>;