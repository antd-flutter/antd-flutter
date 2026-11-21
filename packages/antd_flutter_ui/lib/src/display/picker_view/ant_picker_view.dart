/// AntPickerView — antd-mobile PickerView 内嵌滚轮选择器的 Flutter 实现（antd_flutter_ui 基础库）
///
/// 嵌入页面的多列滚轮选择器，基于 CupertinoPicker 实现 iOS 风格滚轮。
/// 作为通用滚轮视图沉淀于 ui 基础库，供 Picker / CalendarPicker /
/// 后续 Date/Time Picker 等组件复用。
///
/// 列数据直接是使用者自己的模型 `T`，通过 [AntPickerColumn.labelBuilder]
/// 渲染、[AntPickerColumn.keyOf] 提供唯一标识；[value] 中的元素可以是
/// `T` 本身，也可以是 `keyOf` 返回的 key。
///
/// ```dart
/// AntPickerView<Season>(
///   columns: [
///     AntPickerColumn<Season>(
///       dataSource: seasons,
///       keyOf: (s) => s.id,
///       labelBuilder: (context, s) => Text(s.name),
///     ),
///   ],
///   onChange: (items) => print(items.map((e) => e.name)),
/// )
/// ```
library;

export 'package:antd_flutter_ui/src/engines/wheel_column_model.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 内嵌滚轮选择器 — 多列滚轮，选中项实时回调。
class AntPickerView<T> extends StatefulWidget {
  const AntPickerView({
    super.key,
    required this.columns,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.itemHeight = 40,
    this.height = 240,
  });

  /// 列数据。
  final List<AntPickerColumn<T>> columns;

  /// 受控值（各列选中值，元素可为 `T` 或 key）。
  final List<Object?>? value;

  /// 非受控初始值（元素可为 `T` 或 key）。
  final List<Object?> defaultValue;

  /// 选中变化回调（返回各列选中的模型）。
  final ValueChanged<List<T>>? onChange;

  /// 单项高度。
  final double itemHeight;

  /// 整体高度。
  final double height;

  @override
  State<AntPickerView<T>> createState() => _AntPickerViewState<T>();
}

class _AntPickerViewState<T> extends State<AntPickerView<T>> {
  late List<int> _indexes;
  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _indexes = _indexesFor(widget.value ?? widget.defaultValue);
    _controllers = [
      for (final index in _indexes)
        FixedExtentScrollController(initialItem: index),
    ];
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant AntPickerView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_columnsChanged(oldWidget.columns)) {
      _disposeControllers();
      _initControllers();
      return;
    }
    final value = widget.value;
    if (value == null) return;
    for (var i = 0; i < widget.columns.length; i++) {
      final index = _indexOf(
        widget.columns[i],
        i < value.length ? value[i] : null,
      );
      if (_indexes[i] == index) continue;
      _indexes[i] = index;
      if (_controllers[i].hasClients) {
        _controllers[i].jumpToItem(index);
      }
    }
  }

  bool _columnsChanged(List<AntPickerColumn<T>> oldColumns) {
    if (widget.columns.length != oldColumns.length) return true;
    for (var i = 0; i < widget.columns.length; i++) {
      if (!identical(
        widget.columns[i].dataSource,
        oldColumns[i].dataSource,
      )) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  List<int> _indexesFor(List<Object?> values) {
    return [
      for (var i = 0; i < widget.columns.length; i++)
        _indexOf(widget.columns[i], i < values.length ? values[i] : null),
    ];
  }

  int _indexOf(AntPickerColumn<T> column, Object? value) {
    if (value == null || column.dataSource.isEmpty) return 0;
    for (var i = 0; i < column.dataSource.length; i++) {
      final item = column.dataSource[i];
      final key = column.keyOf?.call(item) ?? i;
      if (key == value || identical(item, value) || item == value) return i;
    }
    return 0;
  }

  List<T> _selectedValues() {
    return [
      for (var i = 0; i < widget.columns.length; i++)
        widget.columns[i].dataSource[_indexes[i]],
    ];
  }

  void _onColumnChanged(int colIndex, int itemIndex) {
    final column = widget.columns[colIndex];
    if (itemIndex < 0 || itemIndex >= column.dataSource.length) return;
    if (_indexes[colIndex] == itemIndex) return;
    _indexes[colIndex] = itemIndex;
    widget.onChange?.call(_selectedValues());
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          for (var i = 0; i < widget.columns.length; i++)
            Expanded(
              child: WheelPickerColumn<T>(
                column: widget.columns[i],
                controller: _controllers[i],
                itemHeight: widget.itemHeight,
                fontSize: t.fontSize,
                colorText: t.colorText,
                onSelected: (idx) => _onColumnChanged(i, idx),
              ),
            ),
        ],
      ),
    );
  }
}
