# antd_keyboard - Flutter 虚拟键盘与虚拟输入控件

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/README_CN.md)

## 定位与设计

`antd_keyboard` 提供屏幕键盘以及使用它们的输入控件。基础构件包括：`AntKeyboard`（渲染任意行/键布局）、`AntNumberKeyboard`（开箱即用的数字键盘面板）、`AntPasscodeInput`（点击唤起键盘的 PIN 输入格）、`AntVirtualInput`（通过键盘而非系统输入法输入的表单控件）。布局是纯数据——若干行 `AntKeyboardKey`——因此自定义键盘是声明，而不是控件树。

设计原则：

- **布局即数据。** `AntKeyboardLayout` 由 `AntKeyboardRow` 组成，行内是 `AntKeyboardKey.text` / `AntKeyboardKey.action`；预设（`numeric`、`decimal`、`text`、`symbol`、`email`、`qwertyDesktop`）只是预置声明。
- **值归输入控件所有。** 键盘只发出意图（`onTextInput`、`onBackspace`、`onConfirm`、`onKey`），字符串由控件或你的状态提供。
- **增强能力可选。** 控制栏、退格连删、硬件按键处理均为按需开启，同一套键盘既能用于自助终端也能用于桌面场景。
- **浮层显式创建。** 需要让键盘浮在内容之上时，用 `AntKeyboardOverlayController.show` 把键盘挂到屏幕指定位置。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_keyboard: ^1.0.0
```

用 `AntTheme` 包裹子树；按键表面、按下态与验证码格子均跟随设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

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

键盘渲染标准 3×4 数字网格并带确认键。`onTextInput` 每次收到一个字符，长按退格默认启用连删。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_keyboard/docs/api-index.md)

### 1. 用行与键组合自定义布局

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

`flex` 决定行内宽度权重，因此宽零键与宽确认键可以并排。动作键按 `AntKeyAction` 分派到 `onBackspace`、`onConfirm` 或通用 `onKey`。

### 2. 开箱即用的数字键盘面板

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

`AntNumberKeyboard` 是一个完整面板：标题、数值显示、按键、确认与关闭按钮。不传 `value` 时它自己维护缓冲，可直接放进底部弹层。

### 3. 验证码格与虚拟输入框

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

`AntPasscodeInput` 点击后唤起数字键盘，填满所有格子时回调 `onFill`。`AntVirtualInput` 外观是文本框，但屏蔽系统输入法，改为展示预设键盘（或 `keyboardLayout`），让自助终端与嵌入式设备上的输入保持可控。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/keyboard/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_keyboard/
├── lib/
│   ├── antd_keyboard.dart              # barrel 导出
│   └── src/
│       ├── engines/
│       │   ├── ant_keyboard/           # 布局模型、按键与渲染器
│       │   ├── keyboard_overlay.dart   # 浮动键盘控制器
│       │   └── keyboard_input_model.dart
│       ├── number_keyboard/            # 数字键盘面板
│       ├── passcode_input/             # 验证码格 + 键盘
│       └── virtual_input/              # 表单控件 + 键盘
├── example/lib/main.dart               # 可运行示例
├── docs/api-index.md                   # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
