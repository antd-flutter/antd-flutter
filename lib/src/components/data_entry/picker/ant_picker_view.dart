/// AntPickerView — antd-mobile PickerView 内嵌滚轮选择器的 Flutter 实现
///
/// 嵌入页面的多列滚轮选择器，基于 CupertinoPicker 实现 iOS 风格滚轮。
///
/// ```dart
/// AntPickerView(
///   columns: [
///     [AntPickerColumnItem(label: '周一', value: 'mon'), ...],
///   ],
///   onChange: (vals) => print(vals),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/picker/ant_picker_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/picker/ant_picker_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 内嵌滚轮选择器 — 多列滚轮，选中项实时回调。
class AntPickerView extends StatefulWidget {
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
  final List<AntPickerColumn> columns;

  /// 受控值（各列选中值）。
  final List<AntPickerValue>? value;

  /// 非受控初始值。
  final List<AntPickerValue> defaultValue;

  /// 选中变化回调。
  final ValueChanged<List<AntPickerValue>>? onChange;

  /// 单项高度。
  final double itemHeight;

  /// 整体高度。
  final double height;

  @override
  State<AntPickerView> createState() => _AntPickerViewState();
}

class _AntPickerViewState extends State<AntPickerView> {
  late List<AntPickerValue> _innerValue;
  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();
    _innerValue = List<AntPickerValue>.from(
      widget.value ?? widget.defaultValue,
    );
    _syncControllers();
  }

  void _syncControllers() {
    _controllers = [];
    for (var i = 0; i < widget.columns.length; i++) {
      final idx = _indexOf(widget.columns[i], _safeValueAt(i));
      _controllers.add(FixedExtentScrollController(initialItem: idx));
    }
  }

  @override
  void didUpdateWidget(covariant AntPickerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns.length != oldWidget.columns.length) {
      for (final c in _controllers) {
        c.dispose();
      }
      _innerValue = List<AntPickerValue>.from(
        widget.value ?? widget.defaultValue,
      );
      _syncControllers();
      return;
    }
    if (widget.value != null) {
      for (var i = 0; i < widget.value!.length && i < _innerValue.length; i++) {
        if (widget.value![i] != _innerValue[i]) {
          _innerValue[i] = widget.value![i];
          final idx = _indexOf(widget.columns[i], _innerValue[i]);
          if (_controllers[i].selectedItem != idx) {
            _controllers[i].jumpToItem(idx);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  AntPickerValue _safeValueAt(int index) {
    if (index < _innerValue.length) return _innerValue[index];
    return null;
  }

  int _indexOf(AntPickerColumn column, AntPickerValue value) {
    if (value == null) return 0;
    final idx = column.indexWhere((item) => item.value == value);
    return idx >= 0 ? idx : 0;
  }

  void _onColumnChanged(int colIndex, int itemIndex) {
    final column = widget.columns[colIndex];
    if (itemIndex >= column.length) return;
    final newVal = column[itemIndex].value;
    if (colIndex < _innerValue.length) {
      _innerValue[colIndex] = newVal;
    } else {
      while (_innerValue.length <= colIndex) {
        _innerValue.add(null);
      }
      _innerValue[colIndex] = newVal;
    }
    widget.onChange?.call(List<AntPickerValue>.from(_innerValue));
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
              child: _WheelColumn(
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

/// 单列滚轮
class _WheelColumn extends StatelessWidget {
  const _WheelColumn({
    required this.column,
    required this.controller,
    required this.itemHeight,
    required this.fontSize,
    required this.colorText,
    required this.onSelected,
  });

  final AntPickerColumn column;
  final FixedExtentScrollController controller;
  final double itemHeight;
  final double fontSize;
  final Color colorText;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: itemHeight,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.black.withValues(alpha: 0.04),
      ),
      onSelectedItemChanged: onSelected,
      children: column.map((item) {
        return Center(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: fontSize,
              color: colorText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}