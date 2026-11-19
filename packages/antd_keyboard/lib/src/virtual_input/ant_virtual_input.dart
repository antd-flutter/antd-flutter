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

export 'package:antd_keyboard/src/virtual_input/ant_virtual_input_types.dart';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../engines/ant_keyboard/ant_keyboard.dart';
import '../engines/ant_keyboard/ant_keyboard_layout.dart';
import '../engines/ant_keyboard/ant_keyboard_theme.dart';
import '../engines/input_platform.dart';
import '../engines/keyboard_overlay.dart';
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
    this.keyboardLayout,
    this.keyboardTheme,
    this.keyboardDesktop = false,
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

  /// 通用键盘布局（null 时使用数字键盘预设 AntNumberKeyboard）。
  final AntKeyboardLayout? keyboardLayout;

  /// 键盘主题覆盖。
  final AntKeyboardThemeData? keyboardTheme;

  /// 键盘桌面密度（展示形态由调用方决定）。
  final bool keyboardDesktop;

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

  /// 桌面端系统输入支持
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
      _desktopController = TextEditingController(text: _internalValue);
      _desktopFocus = FocusNode()..addListener(_handleDesktopFocus);
    }
    if (widget.autoFocus) {
      _focused = true;
      if (!_desktop) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showKeyboard());
      }
    }
  }

  @override
  void didUpdateWidget(covariant AntVirtualInput oldWidget) {
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
    _desktopController?.dispose();
    super.dispose();
  }

  void _handleDesktopFocus() {
    final focused = _desktopFocus?.hasFocus ?? false;
    setState(() => _focused = focused);
    if (focused) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
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
    _showKeyboard();
  }

  void _blur() {
    if (!_focused) return;
    setState(() => _focused = false);
    _kb.hide();
    widget.onBlur?.call();
  }

  void _showKeyboard() {
    // TODO(keyboard-form): 弹出形态待参考库接入后完善（见 keyboard_overlay.dart）
    final layout = widget.keyboardLayout;
    _kb.show(
      context,
      layout != null
          // 通用键盘引擎：文本/符号/邮箱/自定义布局
          ? AntKeyboard(
              layout: layout,
              theme: widget.keyboardTheme ??
                  AntKeyboardThemeData(desktop: widget.keyboardDesktop),
              onTextInput: (s) => _handleChange(_currentValue + s),
              onBackspace: () {
                if (_currentValue.isNotEmpty) {
                  _handleChange(
                    _currentValue.substring(0, _currentValue.length - 1),
                  );
                }
              },
              onConfirm: () {
                _handleConfirm();
                _blur();
              },
              onHide: _blur,
            )
          // 默认：数字键盘预设
          : AntNumberKeyboard(
              value: _currentValue,
              onChange: _handleChange,
              confirmText: widget.confirmText,
              onConfirm: () {
                _handleConfirm();
                _blur();
              },
              randomOrder: widget.randomOrder,
              customKey: widget.customKey,
              theme: widget.keyboardTheme,
              desktop: widget.keyboardDesktop,
            ),
      onDismiss: _blur,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final value = _currentValue;
    if (_desktop) {
      return _buildDesktopInput(t, value);
    }

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
      ],
    );
  }

  /// 桌面端：表现为普通输入框，走系统键盘，不嵌入自定义键盘
  Widget _buildDesktopInput(AntThemeData t, String value) {
    final borderColor = widget.disabled
        ? t.colorBorder
        : _focused
            ? t.colorPrimary
            : t.colorBorder;

    return Container(
      height: t.controlHeight.w,
      padding: EdgeInsets.symmetric(horizontal: t.marginSM.w),
      decoration: BoxDecoration(
        color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
        border: Border.all(color: borderColor, width: 1.w),
        borderRadius: BorderRadius.circular(t.borderRadius.w),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _desktopController,
              focusNode: _desktopFocus,
              enabled: !widget.disabled,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: TextStyle(
                fontSize: t.fontSize.sp,
                color: widget.disabled ? t.colorTextDisabled : t.colorText,
              ),
              cursorColor: t.colorPrimary,
              onSubmitted: (v) => widget.onEnterPress?.call(v),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: t.fontSize.sp,
                  color: t.colorTextPlaceholder,
                ),
                hintText: widget.placeholder,
              ),
              onChanged: _handleChange,
            ),
          ),
          if (widget.clearable && value.isNotEmpty && !widget.disabled) ...[
            SizedBox(width: t.marginXS.w),
            GestureDetector(
              onTap: () {
                _desktopController?.clear();
                _handleClear();
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.cancel,
                size: 16.w,
                color: t.colorTextQuaternary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}