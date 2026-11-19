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

export 'package:antd_keyboard/src/passcode_input/ant_passcode_input_types.dart';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../engines/input_platform.dart';
import '../engines/keyboard_overlay.dart';
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

  /// 桌面端系统输入支持（透明 TextField 覆盖格子区域采集输入）
  late final bool _desktop;

  /// 移动端底部弹出键盘控制器
  final AntKeyboardOverlayController _kb = AntKeyboardOverlayController();
  TextEditingController? _desktopController;
  FocusNode? _desktopFocus;

  String get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _desktop = isDesktopInputPlatform();
    if (_desktop) {
      _desktopController = TextEditingController(text: _internalValue)
        ..addListener(_handleDesktopInput);
      _desktopFocus = FocusNode()..addListener(_handleDesktopFocus);
    }
    if (widget.autofocus) {
      _active = true;
      if (_desktop) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _desktopFocus?.requestFocus());
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_active || !mounted) return;
          _kb.show(
            context,
            AntNumberKeyboard(
              value: _currentValue,
              onChange: _handleChange,
              maxLength: widget.length,
            ),
            onDismiss: () => setState(() => _active = false),
          );
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant AntPasscodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalValue = widget.value!;
      if (_desktop &&
          _desktopController != null &&
          _desktopController!.text != _internalValue) {
        _desktopController!.text = _internalValue;
      }
    }
  }

  @override
  void dispose() {
    _kb.hide();
    _desktopFocus?.removeListener(_handleDesktopFocus);
    _desktopFocus?.dispose();
    _desktopController?.removeListener(_handleDesktopInput);
    _desktopController?.dispose();
    super.dispose();
  }

  void _handleDesktopFocus() {
    setState(() => _active = _desktopFocus?.hasFocus ?? false);
  }

  void _handleDesktopInput() {
    _handleChange(_desktopController?.text ?? '');
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
    if (_desktop) {
      _desktopFocus?.requestFocus();
      return;
    }
    if (!widget.keyboard) return;
    setState(() => _active = !_active);
    if (_active) {
      // TODO(keyboard-form): 弹出形态待参考库接入后完善（见 keyboard_overlay.dart）
      _kb.show(
        context,
        AntNumberKeyboard(
          value: _currentValue,
          onChange: _handleChange,
          maxLength: widget.length,
        ),
        onDismiss: () => setState(() => _active = false),
      );
    } else {
      _kb.hide();
    }
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
        // 格子均分铺满宽度
        child: Row(
          children: [
            for (var i = 0; i < cells.length; i++) Expanded(child: cells[i]),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleActive,
          behavior: HitTestBehavior.opaque,
          child: _desktop
              ? Stack(
                  children: [
                    cellsRow,
                    // 桌面端：透明 TextField 覆盖格子区域，走系统键盘输入
                    Positioned.fill(
                      child: TextField(
                        controller: _desktopController,
                        focusNode: _desktopFocus,
                        maxLength: widget.length,
                        obscureText: !widget.plain,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Colors.transparent),
                        cursorColor: Colors.transparent,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                )
              : cellsRow,
        ),
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