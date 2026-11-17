/// 滚轮选择列数据模型 — 滚轮选择引擎（wheel picker engine）共用的列/项/值类型。
///
/// 由 antd_picker 全族（Picker/PickerView/DatePicker/TimePicker/CalendarPicker/
/// Cascader）消费；P08 拆分时自主包 `data_entry/picker/ant_picker_types.dart`
/// 上移至 antd_flutter_ui 共享引擎层，注释与语义保持不变。
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
