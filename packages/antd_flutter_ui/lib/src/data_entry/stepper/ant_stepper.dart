/// AntStepper — antd-mobile Stepper 步进器的 Flutter 实现
///
/// 通过 + / - 按钮和键盘输入调整数值，支持步长、上下限、精度控制。
///
/// ```dart
/// AntStepper(
///   min: 0,
///   max: 10,
///   step: 1,
///   defaultValue: 3,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/stepper/ant_stepper_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/stepper/ant_stepper_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

/// 步进器 — 移动端数值调节组件。
class AntStepper extends StatefulWidget {
  const AntStepper({
    super.key,
    this.value,
    this.defaultValue,
    this.min,
    this.max,
    this.step = 1,
    this.digits,
    this.disabled = false,
    this.inputReadOnly = false,
    this.allowEmpty = false,
    this.size = AntStepperSize.middle,
    this.onChange,
    this.onFocus,
    this.onBlur,
  });

  /// 受控值。
  final double? value;

  /// 非受控初始值。
  final double? defaultValue;

  /// 最小值。
  final double? min;

  /// 最大值。
  final double? max;

  /// 步长。
  final double step;

  /// 小数位数精度。
  final int? digits;

  /// 是否禁用。
  final bool disabled;

  /// 输入框是否只读。
  final bool inputReadOnly;

  /// 是否允许清空。
  final bool allowEmpty;

  /// 尺寸。
  final AntStepperSize size;

  /// 变化回调。
  final ValueChanged<double?>? onChange;

  /// 聚焦回调。
  final VoidCallback? onFocus;

  /// 失焦回调。
  final VoidCallback? onBlur;

  @override
  State<AntStepper> createState() => _AntStepperState();
}

class _AntStepperState extends State<AntStepper> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _focused = false;
  double? _internalValue;

  bool get _isControlled => widget.value != null;

  double? get _currentValue => _isControlled ? widget.value : _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _controller = TextEditingController(text: _formatValue(_currentValue));
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AntStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled && widget.value != oldWidget.value) {
      if (!_focused) {
        _controller.text = _formatValue(widget.value);
      }
    }
    if (!_isControlled && widget.defaultValue != oldWidget.defaultValue) {
      _internalValue = widget.defaultValue;
      if (!_focused) {
        _controller.text = _formatValue(_internalValue);
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = _focusNode.hasFocus;
    if (_focused != focused) {
      setState(() => _focused = focused);
      if (focused) {
        // 聚焦时显示原始数值
        _controller.text = _currentValue?.toString() ?? '';
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
        widget.onFocus?.call();
      } else {
        // 失焦时格式化显示
        _controller.text = _formatValue(_currentValue);
        widget.onBlur?.call();
      }
    }
  }

  String _formatValue(double? v) {
    if (v == null) return '';
    if (widget.digits != null) {
      return v.toStringAsFixed(widget.digits!);
    }
    // 去除多余的 .0
    final s = v.toString();
    if (s.endsWith('.0')) return s.substring(0, s.length - 2);
    return s;
  }

  double _clampValue(double v) {
    if (widget.min != null && v < widget.min!) return widget.min!;
    if (widget.max != null && v > widget.max!) return widget.max!;
    return v;
  }

  void _setValue(double? next) {
    if (next != null) {
      next = _clampValue(next);
      if (widget.digits != null) {
        next = double.parse(next.toStringAsFixed(widget.digits!));
      }
    }
    if (!_isControlled) {
      setState(() => _internalValue = next);
    }
    widget.onChange?.call(next);
  }

  void _handleInputChange(String text) {
    if (text.isEmpty) {
      if (widget.allowEmpty) {
        _setValue(null);
      } else {
        _setValue(0);
      }
      return;
    }
    final parsed = double.tryParse(text);
    if (parsed != null) {
      _setValue(parsed);
    }
  }

  void _handleOffset(bool positive) {
    final current = _currentValue ?? 0;
    final next = current + (positive ? widget.step : -widget.step);
    _setValue(next);
    // 更新输入框显示
    if (!_focused) {
      setState(() {
        _controller.text = _formatValue(_isControlled ? widget.value : _internalValue);
      });
    }
  }

  bool get _minusDisabled {
    if (widget.disabled) return true;
    final v = _currentValue;
    if (v == null) return false;
    if (widget.min != null) return v <= widget.min!;
    return false;
  }

  bool get _plusDisabled {
    if (widget.disabled) return true;
    final v = _currentValue;
    if (v == null) return false;
    if (widget.max != null) return v >= widget.max!;
    return false;
  }

  double get _height {
    switch (widget.size) {
      case AntStepperSize.large:
        return 36;
      case AntStepperSize.middle:
        return 32;
      case AntStepperSize.small:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final h = _height.w;
    final borderColor =
        _focused ? theme.colorPrimary : theme.colorBorder;
    final buttonColor = widget.disabled ? theme.colorTextDisabled : theme.colorPrimary;
    final inputBg = widget.disabled ? theme.colorBgContainerDisabled : theme.colorBgContainer;

    return Container(
      height: h,
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: borderColor, width: theme.controlOutlineWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            theme: theme,
            icon: Icons.remove,
            onTap: _minusDisabled ? null : () => _handleOffset(false),
            color: buttonColor,
            disabled: _minusDisabled,
          ),
          Container(
            width: 1,
            height: h * 0.6,
            color: theme.colorSplit,
          ),
          SizedBox(
            width: 44.w,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: widget.inputReadOnly || widget.disabled,
              enabled: !widget.disabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
              ],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: theme.fontSizeSM,
                color: widget.disabled ? theme.colorTextDisabled : theme.colorText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: (h - theme.fontSizeSM) / 2),
              ),
              onChanged: _handleInputChange,
            ),
          ),
          Container(
            width: 1,
            height: h * 0.6,
            color: theme.colorSplit,
          ),
          _buildButton(
            theme: theme,
            icon: Icons.add,
            onTap: _plusDisabled ? null : () => _handleOffset(true),
            color: buttonColor,
            disabled: _plusDisabled,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required AntThemeData theme,
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
    required bool disabled,
  }) {
    final iconSize = widget.size == AntStepperSize.small ? 14.0 : 18.0;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: _height.w,
        height: _height.w,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize.w,
          color: disabled ? theme.colorTextDisabled : color,
        ),
      ),
    );
  }
}