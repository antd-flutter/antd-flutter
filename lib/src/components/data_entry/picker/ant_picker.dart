/// AntPicker — antd-mobile Picker 底部弹出选择器的 Flutter 实现
///
/// 点击触发器弹出底部面板，内含多列滚轮选择器，支持确认/取消。
///
/// ```dart
/// AntPicker(
///   columns: [seasons],
///   onConfirm: (vals) => print(vals),
///   child: Text('打开选择器'),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/picker/ant_picker_view.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/picker/ant_picker_types.dart';
import 'package:material_ui/material_ui.dart';

/// 底部弹出选择器 — 弹出面板中展示多列滚轮。
class AntPicker extends StatefulWidget {
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
  final List<AntPickerColumn> columns;

  /// 受控值。
  final List<AntPickerValue>? value;

  /// 非受控初始值。
  final List<AntPickerValue> defaultValue;

  /// 面板标题。
  final String? title;

  /// 确认按钮文本。
  final String confirmText;

  /// 取消按钮文本。
  final String cancelText;

  /// 确认回调。
  final ValueChanged<List<AntPickerValue>>? onConfirm;

  /// 取消回调。
  final VoidCallback? onCancel;

  /// 选中变化回调（滚轮滚动时触发）。
  final ValueChanged<List<AntPickerValue>>? onSelect;

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
  State<AntPicker> createState() => _AntPickerState();
}

class _AntPickerState extends State<AntPicker> {
  List<AntPickerValue>? _lastConfirmed;
  List<AntPickerValue> _currentValue = [];

  @override
  void initState() {
    super.initState();
    _lastConfirmed = List<AntPickerValue>.from(
      widget.value ?? widget.defaultValue,
    );
    _currentValue = List<AntPickerValue>.from(_lastConfirmed!);
    if (widget.visible == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible && widget.visible != null) {
      if (widget.visible!) {
        _open();
      }
    }
    if (widget.value != null && widget.value != oldWidget.value) {
      _lastConfirmed = List<AntPickerValue>.from(widget.value!);
      _currentValue = List<AntPickerValue>.from(_lastConfirmed ?? []);
    }
  }

  void _open() {
    final themeData = AntTheme.of(context);
    _currentValue = List<AntPickerValue>.from(_lastConfirmed ?? []);
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
        return _PickerSheet(
          themeData: themeData,
          title: widget.title,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          columns: widget.columns,
          value: _currentValue,
          itemHeight: widget.itemHeight,
          pickerHeight: widget.pickerHeight,
          onCancel: () {
            Navigator.of(sheetContext).pop();
            widget.onCancel?.call();
          },
          onConfirm: () {
            Navigator.of(sheetContext).pop();
            _lastConfirmed = List<AntPickerValue>.from(_currentValue);
            widget.onConfirm?.call(_currentValue);
          },
          onSelect: (vals) {
            _currentValue = vals;
            widget.onSelect?.call(vals);
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

/// 底部面板内容
class _PickerSheet extends StatefulWidget {
  const _PickerSheet({
    required this.themeData,
    required this.columns,
    required this.value,
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
  final List<AntPickerColumn> columns;
  final List<AntPickerValue> value;
  final String? title;
  final String confirmText;
  final String cancelText;
  final double itemHeight;
  final double pickerHeight;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<List<AntPickerValue>>? onSelect;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late List<AntPickerValue> _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = List<AntPickerValue>.from(widget.value);
  }

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
                onTap: widget.onConfirm,
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
        AntPickerView(
          columns: widget.columns,
          value: _innerValue,
          itemHeight: widget.itemHeight,
          height: widget.pickerHeight,
          onChange: (vals) {
            _innerValue = vals;
            widget.onSelect?.call(vals);
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}