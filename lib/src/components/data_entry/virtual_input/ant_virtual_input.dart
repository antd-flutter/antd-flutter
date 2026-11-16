/// AntVirtualInput — antd-mobile VirtualInput 虚拟输入的 Flutter 实现
///
/// API 与 antd-mobile React VirtualInput 对齐：
/// - [AntVirtualInput] — 虚拟输入（value/placeholder/clearable/内置数字键盘）
///
/// ```dart
/// AntVirtualInput(
///   placeholder: '请输入',
///   clearable: true,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/virtual_input/ant_virtual_input_types.dart';

import 'package:flutter/material.dart';

import '../number_keyboard/ant_number_keyboard.dart';

/// 虚拟输入 — 通过内置数字键盘输入的只读输入框。
///
/// 对齐 antd-mobile React VirtualInput。点击输入框展开数字键盘，
/// 不唤起系统软键盘，适用于安全输入场景。
class AntVirtualInput extends StatefulWidget {
  const AntVirtualInput({
    super.key,
    this.value,
    this.defaultValue = '',
    this.onChange,
    this.placeholder,
    this.clearable = false,
    this.disabled = false,
    this.confirmText,
    this.onEnterPress,
    this.randomOrder = false,
    this.customKey,
    this.autoFocus = false,
    this.onFocus,
    this.onBlur,
  });

  /// 受控当前值。
  final String? value;

  /// 非受控初始值。
  final String defaultValue;

  /// 值变化回调。
  final ValueChanged<String>? onChange;

  /// 占位文案。
  final String? placeholder;

  /// 是否可清空。
  final bool clearable;

  /// 是否禁用。
  final bool disabled;

  /// 键盘确认按钮文案。
  final String? confirmText;

  /// 确认回调（回车/确认键）。
  final ValueChanged<String>? onEnterPress;

  /// 键盘数字是否乱序。
  final bool randomOrder;

  /// 键盘自定义按键。
  final String? customKey;

  /// 是否自动聚焦。
  final bool autoFocus;

  /// 聚焦回调。
  final VoidCallback? onFocus;

  /// 失焦回调。
  final VoidCallback? onBlur;

  @override
  State<AntVirtualInput> createState() => _AntVirtualInputState();
}

class _AntVirtualInputState extends State<AntVirtualInput> {
  late String _internalValue;
  bool _focused = false;

  String get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    if (widget.autoFocus) {
      _focused = true;
    }
  }

  @override
  void didUpdateWidget(covariant AntVirtualInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalValue = widget.value!;
    }
  }

  void _handleChange(String v) {
    if (v == _currentValue) return;
    if (widget.value != null) {
      widget.onChange?.call(v);
    } else {
      setState(() => _internalValue = v);
      widget.onChange?.call(v);
    }
  }

  void _handleClear() {
    if (widget.value != null) {
      widget.onChange?.call('');
    } else {
      setState(() => _internalValue = '');
      widget.onChange?.call('');
    }
  }

  void _handleConfirm() {
    widget.onEnterPress?.call(_currentValue);
  }

  void _focus() {
    if (widget.disabled || _focused) return;
    setState(() => _focused = true);
    widget.onFocus?.call();
  }

  void _blur() {
    if (!_focused) return;
    setState(() => _focused = false);
    widget.onBlur?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final value = _currentValue;

    final borderColor = widget.disabled
        ? t.colorBorder
        : _focused
            ? t.colorPrimary
            : t.colorBorder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _focus,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: t.controlHeight.w,
            padding: EdgeInsets.symmetric(horizontal: t.marginSM.w),
            decoration: BoxDecoration(
              color: widget.disabled
                  ? t.colorBgContainerDisabled
                  : t.colorBgContainer,
              border: Border.all(color: borderColor, width: 1.w),
              borderRadius: BorderRadius.circular(t.borderRadius.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: value.isNotEmpty
                      ? Text(
                          value,
                          style: TextStyle(
                            fontSize: t.fontSize.sp,
                            color: widget.disabled
                                ? t.colorTextDisabled
                                : t.colorText,
                          ),
                        )
                      : Text(
                          widget.placeholder ?? '',
                          style: TextStyle(
                            fontSize: t.fontSize.sp,
                            color: t.colorTextPlaceholder,
                          ),
                        ),
                ),
                if (widget.clearable &&
                    value.isNotEmpty &&
                    _focused &&
                    !widget.disabled) ...[
                  SizedBox(width: t.marginXS.w),
                  GestureDetector(
                    onTap: _handleClear,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      Icons.cancel,
                      size: 16.w,
                      color: t.colorTextQuaternary,
                    ),
                  ),
                ],
                if (_focused && !widget.disabled) ...[
                  SizedBox(width: t.marginXS.w),
                  GestureDetector(
                    onTap: _blur,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      Icons.keyboard_hide_outlined,
                      size: 20.w,
                      color: t.colorTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_focused && !widget.disabled) ...[
          SizedBox(height: t.marginSM.w),
          AntNumberKeyboard(
            value: value,
            onChange: _handleChange,
            confirmText: widget.confirmText,
            onConfirm: widget.onEnterPress != null ? _handleConfirm : null,
            randomOrder: widget.randomOrder,
            customKey: widget.customKey,
          ),
        ],
      ],
    );
  }
}