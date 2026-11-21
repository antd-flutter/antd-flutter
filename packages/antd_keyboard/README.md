# antd_keyboard - Ant Design keyboards and virtual input fields for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/README_CN.md)

## Positioning & design

`antd_keyboard` supplies on-screen keyboards and the input fields that use them. The building blocks are `AntKeyboard` (render any layout of rows and keys), `AntNumberKeyboard` (a ready-made numeric pad panel), `AntPasscodeInput` (PIN cells that open a keyboard), and `AntVirtualInput` (a form field whose text is entered through a keyboard rather than the system IME). Layouts are plain data — rows of `AntKeyboardKey` — so a custom keypad is a declaration, not a widget tree.

Design rules:

- **Layout is data.** `AntKeyboardLayout` holds `AntKeyboardRow`s of `AntKeyboardKey.text` / `AntKeyboardKey.action`; presets (`numeric`, `decimal`, `text`, `symbol`, `email`, `qwertyDesktop`) are just prebuilt declarations.
- **The field owns the value.** Keyboards emit intent (`onTextInput`, `onBackspace`, `onConfirm`, `onKey`); the field or your state supplies the string.
- **Controls are optional.** Control bars, backspace auto-repeat, and hardware-key handling are opt-in, so the same keyboard serves both kiosk-style and desktop-style input.
- **Overlays are explicit.** `AntKeyboardOverlayController.show` attaches a keyboard to a position on screen when a layout must float above content.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_keyboard: ^1.0.0
```

Wrap the subtree in `AntTheme`; key surfaces, pressed states, and the passcode cells follow the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_keyboard/antd_keyboard.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: const MaterialApp(home: NumericPadPage()),
      ),
    );

class NumericPadPage extends StatefulWidget {
  const NumericPadPage({super.key});

  @override
  State<NumericPadPage> createState() => _NumericPadPageState();
}

class _NumericPadPageState extends State<NumericPadPage> {
  String _amount = '';

  void _append(String text) {
    setState(() => _amount += text);
  }

  void _backspace() {
    if (_amount.isEmpty) return;
    setState(() => _amount = _amount.substring(0, _amount.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amount')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _amount.isEmpty ? '0' : _amount,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Expanded(
            child: AntKeyboard(
              layout: AntKeyboardLayout.numeric(),
              confirmText: 'Done',
              onTextInput: _append,
              onBackspace: _backspace,
              onConfirm: () => debugPrint('confirmed $_amount'),
              onKey: (key) => debugPrint('key ${key.action}'),
            ),
          ),
        ],
      ),
    );
  }
}
```

The pad renders the standard 3×4 numeric grid with a confirm key. `onTextInput` receives one character at a time, and backspace auto-repeat is enabled by default for held presses.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/docs/api-index.md)

### 1. A custom layout built from rows and keys

```dart
AntKeyboard(
  layout: AntKeyboardLayout(
    rows: [
      AntKeyboardRow([
        AntKeyboardKey.text('7'),
        AntKeyboardKey.text('8'),
        AntKeyboardKey.text('9'),
      ]),
      AntKeyboardRow([
        AntKeyboardKey.text('4'),
        AntKeyboardKey.text('5'),
        AntKeyboardKey.text('6'),
      ]),
      AntKeyboardRow([
        AntKeyboardKey.text('1'),
        AntKeyboardKey.text('2'),
        AntKeyboardKey.text('3'),
        AntKeyboardKey.action(AntKeyAction.backspace, actionLabel: '⌫'),
      ]),
      AntKeyboardRow([
        AntKeyboardKey.text('0', flex: 2),
        AntKeyboardKey.action(AntKeyAction.confirm, actionLabel: 'Pay', flex: 2),
      ]),
    ],
  ),
  showControlBar: true,
  onTextInput: _append,
  onBackspace: _backspace,
  onConfirm: () => debugPrint('pay $_amount'),
)
```

`flex` distributes width within a row, so a wide zero and a wide confirm key sit next to each other. Action keys route to `onBackspace`, `onConfirm`, or the generic `onKey`, depending on their `AntKeyAction`.

### 2. A ready-made numeric pad panel

```dart
AntNumberKeyboard(
  title: 'Verification code',
  maxLength: 6,
  confirmText: 'Submit',
  randomOrder: false,
  onChange: (value) => debugPrint('value $value'),
  onInput: (key) => debugPrint('pressed $key'),
  onDelete: () => debugPrint('deleted'),
  onConfirm: (value) => debugPrint('submit $value'),
  onClose: () => debugPrint('closed'),
)
```

`AntNumberKeyboard` is the whole panel: title, value display, keys, confirm, and a close button. It manages its own buffer when `value` is omitted, so it can be dropped inside a bottom sheet as-is.

### 3. Passcode cells and a virtual input

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    AntPasscodeInput(
      length: 6,
      separated: true,
      error: false,
      onFill: (code) => debugPrint('filled $code'),
      onChange: (code) => debugPrint('typed $code'),
    ),
    const SizedBox(height: 24),
    AntVirtualInput(
      placeholder: 'Search',
      clearable: true,
      keyboardPreset: AntKeyboardPreset.text,
      onEnterPress: (value) => debugPrint('submit $value'),
    ),
  ],
)
```

`AntPasscodeInput` opens its numeric keyboard on tap and reports `onFill` when all cells are filled. `AntVirtualInput` looks like a text field but suppresses the system IME, showing the preset keyboard (or `keyboardLayout`) instead, which keeps input predictable on kiosk and embedded devices.

## Project structure

```text
packages/antd_keyboard/
├── lib/
│   ├── antd_keyboard.dart              # barrel export
│   └── src/
│       ├── engines/
│       │   ├── ant_keyboard/           # layout model, keys, renderer
│       │   ├── keyboard_overlay.dart   # floating keyboard controller
│       │   └── keyboard_input_model.dart
│       ├── number_keyboard/            # numeric pad panel
│       ├── passcode_input/             # PIN cells + keyboard
│       └── virtual_input/              # form field + keyboard
├── example/lib/main.dart               # runnable gallery
├── docs/api-index.md                   # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
