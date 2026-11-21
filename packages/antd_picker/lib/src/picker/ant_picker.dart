/// AntPicker — antd-mobile Picker 底部弹出选择器的 Flutter 实现
///
/// 点击触发器弹出底部面板，内含多列滚轮选择器，支持确认/取消。
/// 每列直接使用使用者自己的模型 `T`，通过 [AntPickerColumn.labelBuilder]
/// 渲染、[AntPickerColumn.keyOf] 提供唯一标识。
///
/// ```dart
/// AntPicker<Season>(
///   columns: [
///     AntPickerColumn<Season>(
///       dataSource: seasons,
///       keyOf: (s) => s.id,
///       labelBuilder: (context, s) => Text(s.name),
///     ),
///   ],
///   onConfirm: (items) => print(items.map((e) => e.name)),
///   child: const Text('打开选择器'),
/// )
/// ```
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 底部弹出选择器 — 弹出面板中展示多列滚轮。
///
/// 列数据为 `List<AntPickerColumn<T>>`，值可以是 `T` 本身，也可以是
/// `keyOf` 返回的 key（两者都支持）。
class AntPicker<T> extends StatefulWidget {
  const AntPicker({
    super.key,
    required this.columns,
    this.value,
    this.defaultValue = const [],
    this.title,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.onSelect,
    this.closeOnMaskClick = true,
    this.visible,
    this.onClose,
    this.child,
    this.itemHeight = 40,
    this.pickerHeight = 260,
  });

  /// 列数据。
  final List<AntPickerColumn<T>> columns;

  /// 受控值：元素可以是 `T`，也可以是 `keyOf` 返回的 key。
  final List<Object>? value;

  /// 非受控初始值：元素可以是 `T`，也可以是 `keyOf` 返回的 key。
  final List<Object> defaultValue;

  /// 面板标题。
  final String? title;

  /// 确认按钮文本。
  final String confirmText;

  /// 取消按钮文本。
  final String cancelText;

  /// 确认回调，返回每列选中的 `T`。
  final ValueChanged<List<T>>? onConfirm;

  /// 取消回调。
  final VoidCallback? onCancel;

  /// 选中变化回调（滚轮滚动时触发），返回每列选中的 `T`。
  final ValueChanged<List<T>>? onSelect;

  /// 点击遮罩是否关闭。
  final bool closeOnMaskClick;

  /// 受控可见性。
  final bool? visible;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 触发器组件（点击打开面板）。
  final Widget? child;

  /// 单项高度。
  final double itemHeight;

  /// 滚轮区域高度。
  final double pickerHeight;

  @override
  State<AntPicker<T>> createState() => _AntPickerState<T>();
}

class _AntPickerState<T> extends State<AntPicker<T>> {
  late List<int> _lastIndexes;
  late List<int> _currentIndexes;

  @override
  void initState() {
    super.initState();
    _lastIndexes = _indexesFor(widget.value ?? widget.defaultValue);
    _currentIndexes = List<int>.from(_lastIndexes);
    if (widget.visible == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible && widget.visible != null) {
      if (widget.visible!) _open();
    }
    final value = widget.value;
    if (value != null && !_sameValueList(value, oldWidget.value)) {
      _lastIndexes = _indexesFor(value);
      _currentIndexes = List<int>.from(_lastIndexes);
    }
  }

  List<int> _indexesFor(List<Object> values) {
    return [
      for (var i = 0; i < widget.columns.length; i++)
        _resolveIndex(
          widget.columns[i],
          i < values.length ? values[i] : null,
        ),
    ];
  }

  int _resolveIndex(AntPickerColumn<T> column, Object? value) {
    if (value == null || column.dataSource.isEmpty) return 0;
    for (var i = 0; i < column.dataSource.length; i++) {
      final item = column.dataSource[i];
      final key = column.keyOf?.call(item) ?? i;
      if (key == value || identical(item, value) || item == value) return i;
    }
    return 0;
  }

  List<T> _itemsAt(List<int> indexes) {
    final items = <T>[];
    for (var i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      if (column.dataSource.isEmpty) continue;
      final raw = i < indexes.length ? indexes[i] : 0;
      final index = raw < 0
          ? 0
          : raw >= column.dataSource.length
              ? column.dataSource.length - 1
              : raw;
      items.add(column.dataSource[index]);
    }
    return items;
  }

  void _open() {
    final themeData = AntTheme.of(context);
    _currentIndexes = List<int>.from(_lastIndexes);
    showModalBottomSheet<void>(
      context: context,
      isDismissible: widget.closeOnMaskClick,
      enableDrag: false,
      backgroundColor: themeData.colorBgContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(themeData.borderRadiusLG),
        ),
      ),
      builder: (sheetContext) {
        return _PickerSheet<T>(
          themeData: themeData,
          title: widget.title,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          columns: widget.columns,
          initialIndexes: _currentIndexes,
          itemHeight: widget.itemHeight,
          pickerHeight: widget.pickerHeight,
          onCancel: () {
            Navigator.of(sheetContext).pop();
            widget.onCancel?.call();
          },
          onConfirm: (indexes) {
            Navigator.of(sheetContext).pop();
            _lastIndexes = List<int>.from(indexes);
            _currentIndexes = List<int>.from(indexes);
            widget.onConfirm?.call(_itemsAt(indexes));
          },
          onSelect: (indexes) {
            _currentIndexes = List<int>.from(indexes);
            widget.onSelect?.call(_itemsAt(indexes));
          },
        );
      },
    ).then((_) {
      // Sheet closed (by mask tap or swipe)
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _open,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}

bool _sameValueList(List<Object> a, List<Object>? b) {
  if (b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!identical(a[i], b[i]) && a[i] != b[i]) return false;
  }
  return true;
}

/// 底部面板内容
class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.themeData,
    required this.columns,
    required this.initialIndexes,
    this.title,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.itemHeight = 40,
    this.pickerHeight = 260,
    this.onConfirm,
    this.onCancel,
    this.onSelect,
  });

  final AntThemeData themeData;
  final List<AntPickerColumn<T>> columns;
  final List<int> initialIndexes;
  final String? title;
  final String confirmText;
  final String cancelText;
  final double itemHeight;
  final double pickerHeight;
  final ValueChanged<List<int>>? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<List<int>>? onSelect;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  late List<T> _values;

  @override
  void initState() {
    super.initState();
    _values = [
      for (var i = 0; i < widget.columns.length; i++)
        widget.columns[i].dataSource[_clamp(
          i < widget.initialIndexes.length ? widget.initialIndexes[i] : 0,
          widget.columns[i].dataSource.length,
        )],
    ];
  }

  int _clamp(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return length - 1;
    return index;
  }

  int _indexOfItem(AntPickerColumn<T> column, T item) {
    final index = column.dataSource.indexWhere(
      (element) => identical(element, item) || element == item,
    );
    return index >= 0 ? index : 0;
  }

  List<int> get _indexes => [
        for (var i = 0; i < widget.columns.length; i++)
          _indexOfItem(widget.columns[i], _values[i]),
      ];

  @override
  Widget build(BuildContext context) {
    final t = widget.themeData;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: t.colorSplit, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onCancel,
                child: Text(
                  widget.cancelText,
                  style: TextStyle(
                    fontSize: t.fontSize,
                    color: t.colorText,
                  ),
                ),
              ),
              if (widget.title != null)
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: t.fontSize,
                        fontWeight: FontWeight.w500,
                        color: t.colorText,
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              GestureDetector(
                onTap: () => widget.onConfirm?.call(_indexes),
                child: Text(
                  widget.confirmText,
                  style: TextStyle(
                    fontSize: t.fontSize,
                    color: t.colorPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Body
        AntPickerView<T>(
          columns: widget.columns,
          value: _values,
          itemHeight: widget.itemHeight,
          height: widget.pickerHeight,
          onChange: (items) {
            setState(() => _values = items);
            widget.onSelect?.call(_indexes);
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
