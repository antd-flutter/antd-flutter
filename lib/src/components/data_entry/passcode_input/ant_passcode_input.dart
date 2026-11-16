/// AntPasscodeInput — antd-mobile PasscodeInput 密码格子输入的 Flutter 实现
///
/// API 与 antd-mobile React PasscodeInput 对齐：
/// - [AntPasscodeInput] — 密码格子输入（value/length/plain/error/separated/onFill）
///
/// ```dart
/// AntPasscodeInput(
///   length: 6,
///   plain: false,
///   onFill: (v) => print('filled: $v'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/passcode_input/ant_passcode_input_types.dart';

import 'package:material_ui/material_ui.dart';

import '../number_keyboard/ant_number_keyboard.dart';

/// 密码格子输入 — 用于验证码/密码场景的格子输入组件。
///
/// 对齐 antd-mobile React PasscodeInput。默认内置 [AntNumberKeyboard]，
/// 点击格子区域可展开/收起键盘。
class AntPasscodeInput extends StatefulWidget {
  const AntPasscodeInput({
    super.key,
    this.value,
    this.defaultValue = '',
    this.onChange,
    this.onFill,
    this.length = 6,
    this.plain = false,
    this.error = false,
    this.separated = false,
    this.keyboard = true,
    this.autofocus = false,
  });

  /// 受控当前值。
  final String? value;

  /// 非受控初始值。
  final String defaultValue;

  /// 值变化回调。
  final ValueChanged<String>? onChange;

  /// 填满回调（值长度达到 [length] 时触发）。
  final ValueChanged<String>? onFill;

  /// 格子数量。
  final int length;

  /// 是否明文展示。
  final bool plain;

  /// 是否错误状态。
  final bool error;

  /// 是否格子分离。
  final bool separated;

  /// 是否内置数字键盘。
  final bool keyboard;

  /// 是否自动展开键盘。
  final bool autofocus;

  @override
  State<AntPasscodeInput> createState() => _AntPasscodeInputState();
}

class _AntPasscodeInputState extends State<AntPasscodeInput> {
  late String _internalValue;
  bool _active = false;

  String get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    if (widget.autofocus) {
      _active = true;
    }
  }

  @override
  void didUpdateWidget(covariant AntPasscodeInput oldWidget) {
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
    if (v.length >= widget.length) {
      widget.onFill?.call(v);
    }
  }

  void _toggleActive() {
    if (!widget.keyboard) return;
    setState(() => _active = !_active);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final value = _currentValue;

    final cells = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      final hasChar = i < value.length;
      final isCursor = _active && i == value.length;
      cells.add(_buildCell(t, i, hasChar, isCursor, value));
    }

    final Widget cellsRow;
    if (widget.separated) {
      cellsRow = Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0) SizedBox(width: t.marginXS.w),
            Expanded(child: cells[i]),
          ],
        ],
      );
    } else {
      cellsRow = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.error
                ? t.colorError
                : _active
                    ? t.colorPrimary
                    : t.colorBorder,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: cells),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleActive,
          behavior: HitTestBehavior.opaque,
          child: cellsRow,
        ),
        if (widget.keyboard && _active) ...[
          SizedBox(height: t.marginSM.w),
          AntNumberKeyboard(
            value: value,
            onChange: _handleChange,
            maxLength: widget.length,
          ),
        ],
      ],
    );
  }

  Widget _buildCell(
    AntThemeData t,
    int index,
    bool hasChar,
    bool isCursor,
    String value,
  ) {
    final borderColor = widget.error
        ? t.colorError
        : _active
            ? t.colorPrimary
            : t.colorBorder;

    Widget content;
    if (hasChar) {
      content = widget.plain
          ? Text(
              value[index],
              style: TextStyle(
                fontSize: t.fontSizeLG.sp,
                fontWeight: FontWeight.w600,
                color: t.colorText,
              ),
            )
          : Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: t.colorText,
                shape: BoxShape.circle,
              ),
            );
    } else if (isCursor) {
      content = Container(
        width: 2.w,
        height: 24.w,
        color: t.colorPrimary,
      );
    } else {
      content = const SizedBox.shrink();
    }

    final cell = Container(
      height: 48.w,
      alignment: Alignment.center,
      child: content,
    );

    if (widget.separated) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.w),
          borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
        ),
        child: cell,
      );
    }

    if (index < widget.length - 1) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: t.colorSplit, width: 1.w),
          ),
        ),
        child: cell,
      );
    }
    return cell;
  }
}