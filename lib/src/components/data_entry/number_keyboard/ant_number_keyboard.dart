/// AntNumberKeyboard — antd-mobile NumberKeyboard 数字键盘的 Flutter 实现
///
/// API 与 antd-mobile React NumberKeyboard 对齐：
/// - [AntNumberKeyboard] — 数字键盘组件（value/onChange/confirmText/customKey/randomOrder）
///
/// ```dart
/// AntNumberKeyboard(
///   onChange: (v) => print(v),
///   confirmText: '确定',
///   onConfirm: () => print('confirmed'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/number_keyboard/ant_number_keyboard_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
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

  void _onKeyPress(String key) {
    _applyNext(_buffer.append(key));
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

    return Container(
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        border: Border(
          top: BorderSide(color: t.colorSplit, width: 1.w),
        ),
      ),
      child: Column(
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
          Padding(
            padding: EdgeInsets.all(t.marginXS.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildNumberGrid(t),
                ),
                if (hasConfirm) ...[
                  SizedBox(width: t.marginXS.w),
                  _buildConfirmButton(t),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberGrid(AntThemeData t) {
    final rows = <Widget>[];

    // 第 1-3 行：数字 1-9
    for (var row = 0; row < 3; row++) {
      if (row > 0) rows.add(SizedBox(height: t.marginXS.w));
      rows.add(
        Row(
          children: [
            for (var col = 0; col < 3; col++) ...[
              if (col > 0) SizedBox(width: t.marginXS.w),
              Expanded(
                child: _KeyButton(
                  text: _keyOrder[row * 3 + col],
                  onTap: () => _onKeyPress(_keyOrder[row * 3 + col]),
                  theme: t,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // 第 4 行：customKey + 0 + 退格
    rows.add(SizedBox(height: t.marginXS.w));
    rows.add(
      Row(
        children: [
          if (widget.customKey != null) ...[
            Expanded(
              child: _KeyButton(
                text: widget.customKey!,
                onTap: () => _onKeyPress(widget.customKey!),
                theme: t,
              ),
            ),
            SizedBox(width: t.marginXS.w),
          ] else ...[
            const Expanded(child: SizedBox()),
            SizedBox(width: t.marginXS.w),
          ],
          Expanded(
            child: _KeyButton(
              text: '0',
              onTap: () => _onKeyPress('0'),
              theme: t,
            ),
          ),
          SizedBox(width: t.marginXS.w),
          Expanded(
            child: _KeyButton(
              icon: Icons.backspace_outlined,
              onTap: _onBackspace,
              theme: t,
            ),
          ),
        ],
      ),
    );

    return Column(children: rows);
  }

  Widget _buildConfirmButton(AntThemeData t) {
    return GestureDetector(
      onTap: _onConfirm,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80.w,
        constraints: BoxConstraints(
          minHeight: (3 * 44 + 2 * t.marginXS).w,
        ),
        decoration: BoxDecoration(
          color: t.colorPrimary,
          borderRadius: BorderRadius.circular(t.borderRadius.w),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.confirmText!,
          style: TextStyle(
            fontSize: t.fontSize.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    this.text,
    this.icon,
    required this.onTap,
    required this.theme,
  });

  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44.w,
        decoration: BoxDecoration(
          color: t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius.w),
        ),
        alignment: Alignment.center,
        child: text != null
            ? Text(
                text!,
                style: TextStyle(
                  fontSize: t.fontSizeLG.sp,
                  color: t.colorText,
                  fontWeight: FontWeight.w500,
                ),
              )
            : Icon(
                icon,
                size: 22.w,
                color: t.colorTextSecondary,
              ),
      ),
    );
  }
}