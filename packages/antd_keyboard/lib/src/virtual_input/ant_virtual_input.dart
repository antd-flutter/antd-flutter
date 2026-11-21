/// AntVirtualInput — antd-mobile VirtualInput 虚拟输入的 Flutter 实现
///
/// API 与 antd-mobile React VirtualInput 对齐：
/// - [AntVirtualInput] — 虚拟输入（value/placeholder/clearable/内置数字键盘）
///
/// 移动端：无边框文本 + 闪烁光标（antd-mobile `virtual-input.less`），
/// 点击展开底部键盘；桌面端：antd v6 Input 形态，默认走系统键盘，
/// 传 `keyboardDesktop: true` 时额外弹出 QWERTY 软键盘（绑定同一 controller）。
///
/// ```dart
/// AntVirtualInput(
///   placeholder: '请输入',
///   clearable: true,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_keyboard/src/virtual_input/ant_virtual_input_types.dart';

import 'package:material_ui/material_ui.dart';

import '../engines/ant_keyboard/ant_keyboard.dart';
import '../engines/ant_keyboard/ant_keyboard_controller.dart';
import '../engines/ant_keyboard/ant_keyboard_layout.dart';
import '../engines/ant_keyboard/ant_keyboard_theme.dart';
import '../engines/input_platform.dart';
import '../engines/keyboard_overlay.dart';
import '../number_keyboard/ant_number_keyboard.dart';

/// 虚拟输入 — 通过内置键盘输入的只读输入框。
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
    this.keyboardPreset,
    this.keyboardAlignTop = false,
    this.keyboardShowControlBar = false,
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

  /// 通用键盘布局（优先级高于 [keyboardPreset]；两者都为 null 时使用
  /// 数字键盘预设 AntNumberKeyboard）。
  final AntKeyboardLayout? keyboardLayout;

  /// 键盘预设类型（便捷参数；[keyboardLayout] 显式指定时忽略）。
  final AntKeyboardPreset? keyboardPreset;

  /// 键盘弹出对齐：贴底（默认）/贴顶。
  final bool keyboardAlignTop;

  /// 桌面展示形态下显示控制条（贴底/贴顶切换按钮）。
  final bool keyboardShowControlBar;

  /// 键盘主题覆盖。
  final AntKeyboardThemeData? keyboardTheme;

  /// 桌面形态：是否额外弹出 QWERTY 软键盘（默认走系统键盘）。
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

class _AntVirtualInputState extends State<AntVirtualInput>
    with SingleTickerProviderStateMixin {
  late String _internalValue;
  bool _focused = false;

  /// 是否桌面平台。
  late final bool _desktop = isDesktopInputPlatform();

  final AntKeyboardOverlayController _kb = AntKeyboardOverlayController();
  final AntKeyboardController _keyboardController = AntKeyboardController();
  late final TextEditingController _controller =
      TextEditingController(text: _initialText);
  late final FocusNode _focusNode = FocusNode();
  late final AnimationController _caret = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  String get _currentValue => widget.value ?? _internalValue;

  String get _initialText => widget.value ?? widget.defaultValue;

  /// 是否使用自定义软键盘（移动端恒为 true；桌面端需显式开启）。
  bool get _useCustomKeyboard => !_desktop || widget.keyboardDesktop;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntVirtualInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalValue = widget.value!;
      if (_controller.text != _internalValue) {
        _controller.value = TextEditingValue(
          text: _internalValue,
          selection: TextSelection.collapsed(offset: _internalValue.length),
        );
      }
    }
    if (widget.disabled && _focused) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _kb.dispose();
    _keyboardController.dispose();
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _caret.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final text = _controller.text;
    if (text == _currentValue) {
      if (mounted) setState(() {});
      return;
    }
    _handleChange(text);
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    final focused = _focusNode.hasFocus;
    if (focused == _focused) return;
    setState(() => _focused = focused);
    if (focused) {
      if (!_desktop) _caret.repeat();
      widget.onFocus?.call();
      if (_useCustomKeyboard) _showKeyboard();
    } else {
      _caret.stop();
      if (_kb.showing) _kb.hide();
      widget.onBlur?.call();
    }
  }

  void _handleChange(String value) {
    if (value == _currentValue) return;
    if (widget.value != null) {
      widget.onChange?.call(value);
    } else {
      setState(() => _internalValue = value);
      widget.onChange?.call(value);
    }
  }

  void _handleClear() {
    if (widget.disabled) return;
    if (_currentValue.isEmpty) return;
    _controller.clear();
  }

  void _handleConfirm() {
    widget.onEnterPress?.call(_currentValue);
    _blur();
  }

  void _blur() {
    _focusNode.unfocus();
  }

  void _showKeyboard() {
    if (widget.disabled || _kb.showing) return;
    final layout = widget.keyboardLayout ??
        (widget.keyboardPreset == null
            ? null
            : AntKeyboardLayouts.of(widget.keyboardPreset!));
    // 显式指定布局/预设，或桌面形态开启软键盘时，使用通用键盘引擎；
    // 否则移动端默认数字键盘（AntNumberKeyboard）。
    final useEngine = layout != null || widget.keyboardDesktop;
    final keyboard = useEngine
        ? AntKeyboard(
            layout: layout ??
                (_desktop
                    ? AntKeyboardLayout.qwertyDesktop()
                    : AntKeyboardLayout.numeric()),
            controller: _keyboardController,
            theme: widget.keyboardTheme ??
                AntKeyboardThemeData(desktop: widget.keyboardDesktop),
            confirmText: widget.confirmText,
            onConfirm: _handleConfirm,
            onHide: _blur,
            showControlBar:
                widget.keyboardDesktop && widget.keyboardShowControlBar,
            onAlignTop: () => _kb.realign(context, alignTop: true),
            onAlignBottom: () => _kb.realign(context, alignTop: false),
          )
        : AntNumberKeyboard(
            value: _currentValue,
            onChange: _handleChange,
            confirmText: widget.confirmText,
            onConfirm: _handleConfirm,
            randomOrder: widget.randomOrder,
            customKey: widget.customKey,
            theme: widget.keyboardTheme,
            desktop: widget.keyboardDesktop,
          );
    if (useEngine) {
      _keyboardController.attach(
        controller: _controller,
        focusNode: _focusNode,
        maxLines: 1,
        onChanged: _handleChange,
      );
    }
    _kb.show(
      context,
      keyboard,
      alignTop: widget.keyboardAlignTop,
      onDismiss: () {
        if (!mounted) return;
        if (_focusNode.hasFocus) _focusNode.unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    if (_desktop) {
      return _buildDesktopInput(t);
    }
    return _buildVirtual(t);
  }

  // ---------------------------------------------------------------------------
  // 移动端：antd-mobile VirtualInput（无边框 + 光标 + 尾部图标）
  // ---------------------------------------------------------------------------

  Widget _buildVirtual(AntThemeData t) {
    final value = _currentValue;
    final color = widget.disabled ? t.colorTextDisabled : t.colorText;
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.disabled) return;
          if (_focusNode.hasFocus) {
            _blur();
          } else {
            _focusNode.requestFocus();
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.s(24)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (value.isEmpty)
                        Text(
                          widget.placeholder ?? '',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: t.fontSize,
                            color: t.colorTextPlaceholder,
                          ),
                        )
                      else
                        Text(
                          value,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: t.fontSize,
                            letterSpacing: 1,
                            color: color,
                          ),
                        ),
                      if (_focused && !widget.disabled)
                        Padding(
                          padding: EdgeInsets.only(left: t.s(1)),
                          child: AnimatedBuilder(
                            animation: _caret,
                            builder: (context, child) => Opacity(
                              opacity: _caret.value < 0.5 ? 1 : 0,
                              child: child,
                            ),
                            child: Container(
                              key: const ValueKey('ant-virtual-input-caret'),
                              width: t.s(2),
                              height: t.fontSize * 1.1,
                              color: t.colorPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.clearable &&
                  value.isNotEmpty &&
                  !widget.disabled) ...[
                SizedBox(width: t.marginXS),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleClear,
                  child: Padding(
                    padding: EdgeInsets.all(t.s(4)),
                    child: AntdIcon(
                      AntIcons.closeCircleFilled,
                      key: const ValueKey('ant-virtual-input-clear'),
                      size: t.s(16),
                      color: t.colorTextQuaternary,
                      semanticLabel: '清空',
                    ),
                  ),
                ),
              ],
              if (_focused && !widget.disabled) ...[
                SizedBox(width: t.s(4)),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _blur,
                  child: Padding(
                    padding: EdgeInsets.all(t.s(4)),
                    child: AntdIcon(
                      AntIcons.downOutlined,
                      key: const ValueKey('ant-virtual-input-hide'),
                      size: t.s(18),
                      color: t.colorTextSecondary,
                      semanticLabel: '收起键盘',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 桌面端：antd v6 Input 形态，可选 QWERTY 软键盘
  // ---------------------------------------------------------------------------

  Widget _buildDesktopInput(AntThemeData t) {
    final value = _currentValue;
    final borderColor = widget.disabled
        ? t.colorBorder
        : _focused
            ? t.colorPrimary
            : t.colorBorder;

    return Container(
      height: t.controlHeight,
      padding: EdgeInsets.symmetric(horizontal: t.marginSM),
      decoration: BoxDecoration(
        color:
            widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
        border: Border.all(color: borderColor, width: t.s(1)),
        borderRadius: BorderRadius.circular(t.borderRadius),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.disabled,
              readOnly: false,
              showCursor: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                fontSize: t.fontSize,
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
                  fontSize: t.fontSize,
                  color: t.colorTextPlaceholder,
                ),
                hintText: widget.placeholder,
              ),
            ),
          ),
          if (widget.clearable && value.isNotEmpty && !widget.disabled) ...[
            SizedBox(width: t.marginXS),
            GestureDetector(
              onTap: _handleClear,
              behavior: HitTestBehavior.opaque,
              child: AntdIcon(
                AntIcons.closeCircleFilled,
                key: const ValueKey('ant-virtual-input-clear'),
                size: t.s(16),
                color: t.colorTextQuaternary,
                semanticLabel: '清空',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
