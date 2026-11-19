/// AntNumberKeyboard — antd-mobile NumberKeyboard 数字键盘的 Flutter 实现
///
/// 基于 ui 通用键盘引擎 `AntKeyboard`（engines/ant_keyboard）实现，
/// numeric 预设布局 + customKey / randomOrder / 确认键参数化。
/// API 与 antd-mobile 对齐并保持向后兼容。
///
/// ```dart
/// AntNumberKeyboard(
///   onChange: (v) => print(v),
///   confirmText: '确定',
///   onConfirm: () => print('confirmed'),
/// )
/// ```
library;

import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard.dart';
import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard_layout.dart';
import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard_theme.dart';
import 'package:antd_keyboard/src/engines/keyboard_input_model.dart';

export 'package:antd_keyboard/src/number_keyboard/ant_number_keyboard_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 数字键盘 — 提供数字输入面板。
///
/// 对齐 antd-mobile React NumberKeyboard。
class AntNumberKeyboard extends StatefulWidget {
  const AntNumberKeyboard({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.maxLength,
    this.confirmText,
    this.onConfirm,
    this.randomOrder = false,
    this.customKey,
    this.title,
    this.visible = true,
    this.onClose,
    this.theme,
    this.desktop = false,
  });

  /// 受控当前值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 值变化回调。
  final ValueChanged<String>? onChange;

  /// 最大输入长度。
  final int? maxLength;

  /// 确认按钮文案（null 则不显示确认键）。
  final String? confirmText;

  /// 确认回调。
  final VoidCallback? onConfirm;

  /// 数字是否乱序。
  final bool randomOrder;

  /// 自定义按键（如 '.' 或 'X'）。
  final String? customKey;

  /// 标题。
  final String? title;

  /// 是否可见。
  final bool visible;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 键盘主题覆盖（null 时从 AntTheme 派生）。
  final AntKeyboardThemeData? theme;

  /// 桌面密度（键高/间距更大 + 悬停反馈；展示形态由调用方决定）。
  final bool desktop;

  @override
  State<AntNumberKeyboard> createState() => _AntNumberKeyboardState();
}

class _AntNumberKeyboardState extends State<AntNumberKeyboard> {
  late KeyboardInputBuffer _buffer;
  late List<String> _keyOrder;

  @override
  void initState() {
    super.initState();
    _buffer = KeyboardInputBuffer(
      initialText: widget.value ?? widget.defaultValue ?? '',
      maxLength: widget.maxLength,
    );
    _keyOrder = buildNumberKeyOrder(randomOrder: widget.randomOrder);
  }

  @override
  void didUpdateWidget(AntNumberKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _buffer.text) {
      _buffer.text = widget.value!;
    }
    if (widget.randomOrder != oldWidget.randomOrder) {
      _keyOrder = buildNumberKeyOrder(randomOrder: widget.randomOrder);
    }
  }

  void _applyNext(String? next) {
    if (next == null) return;
    if (widget.value == null) {
      setState(() => _buffer.text = next);
    } else {
      _buffer.text = next;
    }
    widget.onChange?.call(next);
  }

  void _onTextInput(String text) {
    _applyNext(_buffer.append(text));
  }

  void _onBackspace() {
    _applyNext(_buffer.backspace());
  }

  void _onConfirm() {
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    final t = AntTheme.of(context);
    final hasConfirm = widget.confirmText != null;
    final d = _keyOrder;

    // numeric 预设：随机序/自定义键参数化布局
    final layout = AntKeyboardLayout(rows: [
      AntKeyboardRow(_keys([d[0], d[1], d[2]])),
      AntKeyboardRow(_keys([d[3], d[4], d[5]])),
      AntKeyboardRow(_keys([d[6], d[7], d[8]])),
      AntKeyboardRow([
        widget.customKey != null
            ? AntKeyboardKey.text(widget.customKey!)
            : const AntKeyboardKey.action(AntKeyAction.none),
        const AntKeyboardKey.text('0'),
        const AntKeyboardKey.action(AntKeyAction.backspace),
        if (hasConfirm)
          AntKeyboardKey.action(
            AntKeyAction.confirm,
            actionLabel: widget.confirmText,
            flex: 2,
          ),
      ]),
    ],);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: t.marginSM.w),
            child: Text(
              widget.title!,
              style: TextStyle(
                fontSize: t.fontSizeSM.sp,
                color: t.colorTextSecondary,
              ),
            ),
          ),
        AntKeyboard(
          layout: layout,
          theme: widget.theme ??
              AntKeyboardThemeData(
                surfaceColor: t.colorBgContainer,
                keyBackgroundColor: t.colorFillSecondary,
                desktop: widget.desktop,
              ),
          onTextInput: _onTextInput,
          onBackspace: _onBackspace,
          onConfirm: _onConfirm,
          onHide: widget.onClose,
        ),
      ],
    );
  }

  List<AntKeyboardKey> _keys(List<String> texts) =>
      [for (final s in texts) AntKeyboardKey.text(s)];
}
