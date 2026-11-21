/// 滚轮选择列数据模型 — 滚轮选择引擎（wheel picker engine）共用的列模型。
///
/// 由 antd_picker 全族（Picker/PickerView/DatePicker/TimePicker/CalendarPicker/
/// Cascader）与 antd_calendar 消费；列数据直接是使用者自己的模型 `T`，
/// 渲染与取值分别交给 [AntPickerColumn.labelBuilder] 与 [AntPickerColumn.keyOf]，
/// 不再要求构造字符串 label/value 项。
library;

import 'package:material_ui/material_ui.dart';

/// 单列滚轮数据（泛型）。
///
/// 一列滚轮直接吃使用者的模型 `T`：
///
/// ```dart
/// AntPickerColumn<Season>(
///   dataSource: seasons,
///   keyOf: (s) => s.id,
///   labelBuilder: (context, s) => Text(s.name),
/// )
/// ```
class AntPickerColumn<T> {
  const AntPickerColumn({
    required this.dataSource,
    this.labelBuilder,
    this.keyOf,
  }) : assert(dataSource.length > 0, 'AntPickerColumn.dataSource 不能为空');

  /// 列数据。
  final List<T> dataSource;

  /// 选项自定义渲染；为空时回退为 `Text(item.toString())`。
  final Widget Function(BuildContext context, T item)? labelBuilder;

  /// 选项唯一标识；为空时使用选项下标。
  final Object Function(T item)? keyOf;

  /// 选项标识（缺省下标）。
  Object keyAt(int index) {
    final item = dataSource[index];
    return keyOf?.call(item) ?? index;
  }
}
