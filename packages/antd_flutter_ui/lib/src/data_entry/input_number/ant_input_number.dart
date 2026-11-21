/// AntInputNumber — antd InputNumber 数字输入框的 Flutter 实现
///
/// 基于 [AntInput] 实现（共享边框/填充/hover/禁用态/addon 整合），
/// 通过点击或键盘输入数值，支持步进、精度、上下限。
///
/// ```dart
/// AntInputNumber(
///   min: 0,
///   max: 100,
///   step: 1,
///   precision: 2,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number_types.dart';
// 项目约定：material 系组件统一经 material_ui 引入
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// 数字输入框 — 支持步进按钮、上下限、精度控制。
class AntInputNumber extends StatefulWidget {
  const AntInputNumber({
    super.key,
    this.value,
    this.defaultValue,
    this.min,
    this.max,
    this.step = 1,
    this.precision,
    this.disabled = false,
    this.controls = AntInputNumberControls.upDown,
    this.size = AntInputSize.middle,
    this.status = AntInputStatus.normal,
    this.onChange,
    this.onStep,
    this.placeholder,
    this.prefix,
    this.addonBefore,
    this.addonAfter,
    this.keyboardType,
    this.bordered = true,
    this.focusNode,
    this.autofocus = false,
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

  /// 数值精度（小数位数）。
  final int? precision;

  /// 是否禁用。
  final bool disabled;

  /// 步进按钮模式。
  final AntInputNumberControls controls;

  /// 尺寸。
  final AntInputSize size;

  /// 校验状态。
  final AntInputStatus status;

  /// 变化回调。
  final ValueChanged<double?>? onChange;

  /// 步进回调。
  final ValueChanged<double?>? onStep;

  /// 占位文本。
  final String? placeholder;

  /// 前缀。
  final Widget? prefix;

  /// 前置标签。
  final Widget? addonBefore;

  /// 后置标签。
  final Widget? addonAfter;

  /// 键盘类型。
  final TextInputType? keyboardType;

  /// 是否显示边框。
  final bool bordered;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntInputNumber> createState() => _AntInputNumberState();
}

class _AntInputNumberState extends State<AntInputNumber> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  double? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.defaultValue;
    _controller = TextEditingController(text: _formatValue(_currentValue) ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      // 失焦时将文本提交为数值（clamp/precision/非法恢复）
      if (!_focusNode.hasFocus) {
        _commitText();
      }
    });
    if (widget.autofocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(covariant AntInputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _currentValue) {
      _currentValue = widget.value;
      final formatted = _formatValue(_currentValue) ?? '';
      if (_controller.text != formatted) {
        _controller.text = formatted;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  /// 格式化数值为文本
  String? _formatValue(double? v) {
    if (v == null) return null;
    final p = widget.precision;
    if (p != null) return v.toStringAsFixed(p);
    // 去除末尾多余的 .0
    if (v == v.truncateToDouble()) return v.truncate().toString();
    return v.toString();
  }

  /// 将文本提交为数值（失焦/回车）
  void _commitText() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      if (_currentValue != null) {
        _currentValue = null;
        widget.onChange?.call(null);
      }
      return;
    }
    final v = double.tryParse(text);
    if (v == null) {
      // 无效输入，恢复原值
      final restored = _formatValue(_currentValue) ?? '';
      if (_controller.text != restored) {
        _controller.text = restored;
      }
      return;
    }
    _setClamped(v, notify: true, syncText: true);
  }

  /// clamp + precision 后写入 _currentValue
  double _clamp(double v) {
    var nv = v;
    if (widget.min != null && nv < widget.min!) nv = widget.min!;
    if (widget.max != null && nv > widget.max!) nv = widget.max!;
    final p = widget.precision;
    if (p != null) {
      nv = double.parse(nv.toStringAsFixed(p));
    }
    return nv;
  }

  void _setClamped(double v, {bool notify = false, bool syncText = false}) {
    final nv = _clamp(v);
    _currentValue = nv;
    if (syncText) {
      final formatted = _formatValue(nv) ?? '';
      if (_controller.text != formatted) {
        _controller.text = formatted;
        _controller.selection = TextSelection.collapsed(offset: formatted.length);
      }
    }
    if (notify) {
      widget.onChange?.call(nv);
    }
  }

  /// 步进
  void _step(bool up) {
    if (widget.disabled) return;
    final base = _currentValue ?? widget.min ?? 0;
    var next = up ? base + widget.step : base - widget.step;
    if (widget.min != null && next < widget.min!) next = widget.min!;
    if (widget.max != null && next > widget.max!) next = widget.max!;
    _setClamped(next, notify: true, syncText: true);
    widget.onStep?.call(_currentValue);
  }

  /// 是否可增
  bool get _canUp => !widget.disabled &&
      (widget.max == null || (_currentValue ?? widget.min ?? 0) < widget.max!);

  /// 是否可减
  bool get _canDown => !widget.disabled &&
      (widget.min == null || (_currentValue ?? widget.min ?? 0) > widget.min!);

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final iconSize = widget.size == AntInputSize.small ? t.s(10) : t.s(12);
    final showUp = widget.controls == AntInputNumberControls.upDown ||
        widget.controls == AntInputNumberControls.up;
    final showDown = widget.controls == AntInputNumberControls.down ||
        widget.controls == AntInputNumberControls.upDown;

    // 步进按钮置于输入框内部（suffix），与 antd InputNumber up/down 形态一致
    final stepButtons = (widget.controls == AntInputNumberControls.none)
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDown) ...[
                SizedBox(width: t.s(4)),
                _buildStepButton(t, iconSize, AntIcons.minusOutlined, _canDown, () => _step(false)),
              ],
              if (showUp) ...[
                SizedBox(width: t.s(4)),
                _buildStepButton(t, iconSize, AntIcons.plusOutlined, _canUp, () => _step(true)),
              ],
            ],
          );

    // 基于 AntInput 实现：边框/填充/hover/禁用态/addon 整合全部复用
    return AntInput(
      controller: _controller,
      focusNode: _focusNode,
      disabled: widget.disabled,
      size: widget.size,
      status: widget.status,
      bordered: widget.bordered,
      placeholder: widget.placeholder,
      prefix: widget.prefix,
      addonBefore: widget.addonBefore,
      addonAfter: widget.addonAfter,
      keyboardType: widget.keyboardType ??
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      ],
      autofocus: widget.autofocus,
      onChange: (_) => _handleTextChange(),
      onPressEnter: _commitText,
      suffix: stepButtons,
    );
  }

  /// 输入变化：合法数字即时通知（非法输入不通知，失焦/回车时恢复原值）
  void _handleTextChange() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      if (_currentValue != null) {
        _currentValue = null;
        widget.onChange?.call(null);
      }
      return;
    }
    final v = double.tryParse(text);
    if (v != null) {
      _setClamped(v, notify: true);
    }
  }

  /// 步进按钮
  Widget _buildStepButton(
    AntThemeData t,
    double iconSize,
    IconData icon,
    bool enabled,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: iconSize,
        color: enabled ? t.colorTextSecondary : t.colorTextDisabled,
      ),
    );
  }
}
