/// AntInputNumber — antd InputNumber 数字输入框的 Flutter 实现
///
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

import 'package:antd_flutter_plus/src/components/data_entry/input_number/ant_input_number_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/input_number/ant_input_number_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

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
  bool _focused = false;
  double? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.defaultValue;
    _controller = TextEditingController(
      text: _formatValue(_currentValue) ?? (widget.placeholder ?? ''),
    );
    if (_currentValue == null && widget.placeholder != null) {
      _controller.text = '';
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      final f = _focusNode.hasFocus;
      if (f != _focused) {
        setState(() => _focused = f);
      }
      if (!f) {
        _commitText();
      }
    });
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(AntInputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _currentValue) {
      _currentValue = widget.value;
      _controller.text = _formatValue(_currentValue) ?? '';
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

  /// 将文本提交为数值
  void _commitText() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _currentValue = null;
      widget.onChange?.call(null);
      return;
    }
    final v = double.tryParse(text);
    if (v == null) {
      // 无效输入，恢复原值
      _controller.text = _formatValue(_currentValue) ?? '';
      return;
    }
    _setValue(v, notify: true);
  }

  /// 设置值（含 min/max clamp 与 precision）
  void _setValue(double v, {bool notify = false}) {
    var nv = v;
    if (widget.min != null && nv < widget.min!) nv = widget.min!;
    if (widget.max != null && nv > widget.max!) nv = widget.max!;
    final p = widget.precision;
    if (p != null) {
      nv = double.parse(nv.toStringAsFixed(p));
    }
    _currentValue = nv;
    final formatted = _formatValue(nv) ?? '';
    if (_controller.text != formatted) {
      _controller.text = formatted;
      _controller.selection = TextSelection.collapsed(offset: formatted.length);
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
    _setValue(next, notify: true);
    widget.onStep?.call(_currentValue);
  }

  /// 是否可增
  bool get _canUp =>
      !widget.disabled && (widget.max == null || (_currentValue ?? widget.min ?? 0) < widget.max!);

  /// 是否可减
  bool get _canDown =>
      !widget.disabled && (widget.min == null || (_currentValue ?? widget.min ?? 0) > widget.min!);

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final height = _heightOf(t, widget.size);
    final fontSize = _fontSizeOf(t, widget.size);
    final iconSize = widget.size == AntInputSize.small ? 10.sp : 12.sp;
    final showUp = widget.controls == AntInputNumberControls.upDown ||
        widget.controls == AntInputNumberControls.up;
    final showDown = widget.controls == AntInputNumberControls.upDown ||
        widget.controls == AntInputNumberControls.down;

    final borderColor = widget.disabled
        ? t.colorBorder
        : _borderColorOf(t, widget.status, _focused);
    final bg = widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer;

    final textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: !widget.disabled,
      keyboardType: widget.keyboardType ??
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      ],
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: widget.disabled ? t.colorTextDisabled : t.colorText,
      ),
      cursorColor: t.colorPrimary,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        counterText: '',
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintStyle: TextStyle(
          fontSize: fontSize.sp,
          color: t.colorTextPlaceholder,
        ),
        hintText: _currentValue == null ? widget.placeholder : null,
      ),
      onSubmitted: (_) => _commitText(),
    );

    final content = Row(
      children: [
        if (widget.prefix != null)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: IconTheme.merge(
              data: IconThemeData(size: iconSize, color: t.colorTextTertiary),
              child: widget.prefix!,
            ),
          ),
        Expanded(child: textField),
        if (widget.controls != AntInputNumberControls.none) ...[
          if (showDown)
            _buildStepButton(t, iconSize, Icons.remove, _canDown, () => _step(false)),
          if (showUp)
            _buildStepButton(t, iconSize, Icons.add, _canUp, () => _step(true)),
        ],
      ],
    );

    final inputBody = !widget.bordered
        ? Container(
            height: height.w,
            color: bg,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            alignment: Alignment.center,
            child: content,
          )
        : AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: height.w,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(t.borderRadius.w),
              border: Border.all(color: borderColor, width: 1.w),
              boxShadow: _focused && !widget.disabled
                  ? [
                      BoxShadow(
                        color: _outlineColorOf(t, widget.status).withValues(alpha: 0.8),
                        blurRadius: t.controlOutlineWidth.w,
                      ),
                    ]
                  : null,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            alignment: Alignment.center,
            child: content,
          );

    // addon
    if (widget.addonBefore == null && widget.addonAfter == null) {
      return inputBody;
    }
    return IntrinsicHeight(
      child: Row(
        children: [
          if (widget.addonBefore != null)
            _buildAddon(t, widget.addonBefore!, height, fontSize, true),
          Expanded(child: inputBody),
          if (widget.addonAfter != null)
            _buildAddon(t, widget.addonAfter!, height, fontSize, false),
        ],
      ),
    );
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Icon(
          icon,
          size: iconSize,
          color: enabled ? t.colorTextSecondary : t.colorTextDisabled,
        ),
      ),
    );
  }

  /// 前置/后置标签
  Widget _buildAddon(AntThemeData t, Widget child, double height, double fontSize, bool before) {
    return Container(
      height: height.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: t.colorFillSecondary.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: t.colorBorder, width: 1.w),
          bottom: BorderSide(color: t.colorBorder, width: 1.w),
          left: before ? BorderSide(color: t.colorBorder, width: 1.w) : BorderSide.none,
          right: !before ? BorderSide(color: t.colorBorder, width: 1.w) : BorderSide.none,
        ),
        borderRadius: BorderRadius.horizontal(
          left: before ? Radius.circular(t.borderRadius.w) : Radius.zero,
          right: !before ? Radius.circular(t.borderRadius.w) : Radius.zero,
        ),
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: fontSize.sp, color: t.colorText),
        child: child,
      ),
    );
  }
}

// ============================================================
// 内部工具（尺寸/颜色映射，与 ant_input.dart 保持一致）
// ============================================================

double _heightOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.controlHeightLG;
    case AntInputSize.middle:
      return t.controlHeight;
    case AntInputSize.small:
      return t.controlHeightSM;
  }
}

double _fontSizeOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.fontSizeLG;
    case AntInputSize.middle:
      return t.fontSize;
    case AntInputSize.small:
      return t.fontSizeSM;
  }
}

Color _borderColorOf(AntThemeData t, AntInputStatus status, bool focused) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorError;
    case AntInputStatus.warning:
      return t.colorWarning;
    case AntInputStatus.normal:
      return focused ? t.colorPrimary : t.colorBorder;
  }
}

Color _outlineColorOf(AntThemeData t, AntInputStatus status) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorErrorOutline;
    case AntInputStatus.warning:
      return t.colorWarningOutline;
    case AntInputStatus.normal:
      return t.controlOutline;
  }
}