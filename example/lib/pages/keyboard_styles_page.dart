import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_keyboard/antd_keyboard.dart';
import 'package:material_ui/material_ui.dart';

/// 键盘通用布局样式总览：展示 `AntKeyboard` 的各预设布局与主题覆盖能力。
class KeyboardStylesPage extends StatefulWidget {
  const KeyboardStylesPage({super.key});

  @override
  State<KeyboardStylesPage> createState() => _KeyboardStylesPageState();
}

class _KeyboardStylesPageState extends State<KeyboardStylesPage> {
  String _text = '';
  String _desktop = '';
  String _number = '';
  String _decimal = '';
  String _symbol = '';
  String _email = '';
  String _dark = '';

  void _append(String current, String input, void Function(String) assign) {
    assign(current + input);
  }

  void _backspace(String current, void Function(String) assign) {
    if (current.isEmpty) return;
    final runes = current.runes.toList()..removeLast();
    assign(String.fromCharCodes(runes));
  }

  Widget _section(String title, String value, Widget keyboard) {
    final t = AntTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: t.colorText,
                    ),
                  ),
                ),
                Text(
                  value.isEmpty ? '（未输入）' : value,
                  style: TextStyle(fontSize: 13, color: t.colorTextSecondary),
                ),
              ],
            ),
          ),
          keyboard,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          '文本键盘（移动）',
          _text,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.text),
            onTextInput: (v) => _append(_text, v, (s) => setState(() => _text = s)),
            onBackspace: () => _backspace(_text, (s) => setState(() => _text = s)),
          ),
        ),
        _section(
          '桌面 QWERTY',
          _desktop,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.qwertyDesktop),
            onTextInput: (v) =>
                _append(_desktop, v, (s) => setState(() => _desktop = s)),
            onBackspace: () =>
                _backspace(_desktop, (s) => setState(() => _desktop = s)),
          ),
        ),
        _section(
          '数字键盘',
          _number,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.numeric),
            confirmText: '确定',
            onTextInput: (v) =>
                _append(_number, v, (s) => setState(() => _number = s)),
            onBackspace: () =>
                _backspace(_number, (s) => setState(() => _number = s)),
          ),
        ),
        _section(
          '小数键盘',
          _decimal,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.decimal),
            onTextInput: (v) =>
                _append(_decimal, v, (s) => setState(() => _decimal = s)),
            onBackspace: () =>
                _backspace(_decimal, (s) => setState(() => _decimal = s)),
          ),
        ),
        _section(
          '符号键盘',
          _symbol,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.symbol),
            onTextInput: (v) =>
                _append(_symbol, v, (s) => setState(() => _symbol = s)),
            onBackspace: () =>
                _backspace(_symbol, (s) => setState(() => _symbol = s)),
          ),
        ),
        _section(
          '邮箱键盘',
          _email,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.email),
            onTextInput: (v) =>
                _append(_email, v, (s) => setState(() => _email = s)),
            onBackspace: () =>
                _backspace(_email, (s) => setState(() => _email = s)),
          ),
        ),
        _section(
          '主题覆盖（深色键面）',
          _dark,
          AntKeyboard(
            layout: AntKeyboardLayouts.of(AntKeyboardPreset.text),
            theme: const AntKeyboardThemeData(
              surfaceColor: Color(0xFF1F1F1F),
              keyBackgroundColor: Color(0xFF2B2B2B),
              keyForegroundColor: Color(0xFFFFFFFF),
              keyPressedBackgroundColor: Color(0xFF3A3A3A),
              actionKeyBackgroundColor: Color(0xFF3A3A3A),
              actionKeyForegroundColor: Color(0xFFFFFFFF),
              keyBorderColor: Color(0xFF3A3A3A),
              confirmBackgroundColor: Color(0xFF1677FF),
              confirmForegroundColor: Color(0xFFFFFFFF),
            ),
            onTextInput: (v) => _append(_dark, v, (s) => setState(() => _dark = s)),
            onBackspace: () =>
                _backspace(_dark, (s) => setState(() => _dark = s)),
          ),
        ),
      ],
    );
  }
}
