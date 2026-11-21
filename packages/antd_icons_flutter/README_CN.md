# antd_icons_flutter - Flutter 的 Ant Design 图标库

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/README_CN.md)

`antd_icons_flutter` 无需 React 桥接，把 Ant Design 图标集带入 Flutter。它包含 698 个 Outlined 与 Filled 图标（打包为单个可 tree-shake 的 TTF 字体），以及 150 个 TwoTone 图标（打包为 SVG 资源），全部移植自 `@ant-design/icons-svg`。命名与 React 包一致，`AntIcons.checkOutlined` 直接对应 `<CheckOutlined />`，既有组件代码可以一一迁移。

本包在一个组件背后提供两条渲染路径。`IconData` 常量通过字体同步渲染，是密集工具栏与列表的合适默认值。TwoTone 路径常量通过 `flutter_svg` 渲染并在运行时替换颜色，既保留 antd 的双层质感，又能让主色跟随主题。`AntdIcon` 按参数类型分发，因此同一屏混用两种风格无需引入不同组件。

## 定位与设计

- **一次导入，三种风格。** Outlined、Filled 与 TwoTone 都可从同一出口获取：字体图标用 `AntIcons`，SVG 路径用 `AntIconsTwotone`。
- **常见场景用 TTF。** Outlined 与 Filled 共用 `fonts/AntIcons.ttf`；每个常量都是私有区的 `const IconData`，Flutter 的图标 tree-shaking 依然生效。
- **只在值得时使用 SVG。** TwoTone 每个字形需要两种颜色，单色字体无法表达。本包打包 SVG 资源并在运行时着色，而不是生成成千上万个字体变体。
- **`AntdIcon` 隐藏分发细节。** 传 `IconData` 走字体路径，传 `String` 走 SVG 路径。传错颜色参数会被忽略而非抛异常，符合图标代码“先渲染出来”的预期。
- **命名与 antd React 保持兼容。** `Outlined`、`Filled`、`TwoTone` 后缀遵循上游命名，迁移机械且可搜索。
- **无障碍按需开启。** 装饰性图标默认静默；功能性图标应传入 `semanticLabel`，让读屏器播报其用途。

## 安装

要求 Dart 3.0+、Flutter 3.10+。

```yaml
dependencies:
  antd_icons_flutter: ^1.0.1
```

字体与 TwoTone 资源已随包提供，应用侧无需额外声明资源。

## 快速开始

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              // Outlined / Filled：TTF 字体渲染。
              AntdIcon(AntIcons.checkOutlined),
              AntdIcon(AntIcons.heartFilled, color: Colors.red, size: 32),

              // TwoTone：SVG 渲染，默认 #333 + #E6E6E6。
              AntdIcon(
                AntIconsTwotone.heartTwoTone,
                twoToneColor: Colors.red,
                semanticLabel: 'Favourite',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
```

## API

[API 文档](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/docs/api-index.md)

### 字体图标：直接使用或经 `AntdIcon`

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:flutter/material.dart';

const toolbar = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    AntdIcon(AntIcons.checkOutlined),
    Icon(AntIcons.searchOutlined, size: 20),
    AntdIcon(AntIcons.searchOutlined, size: 20, color: Colors.blue),
  ],
);
```

### 为 TwoTone 图标着色

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:flutter/material.dart';

const statusIcon = AntdIcon(
  AntIconsTwotone.checkCircleTwoTone,
  size: 40,
  twoToneColor: Color(0xFF1677FF),
  semanticLabel: 'Verified',
);
```

### 浏览图标目录

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  print(AntIcons.outlinedIcons.length); // 447
  print(AntIcons.filledIcons.length); // 251
  print(AntIconsTwotone.twotoneIcons.length); // 150

  // 每项为 (name, icon/path) 记录。
  print(AntIcons.outlinedIcons.first.$1);
}
```

## 项目结构

```text
antd_icons_flutter/
├── lib/
│   ├── antd_icons_flutter.dart      # 公共出口
│   └── src/
│       ├── ant_icons.dart           # Outlined + Filled IconData 与目录
│       ├── ant_icons_twotone.dart   # TwoTone SVG 路径常量与目录
│       └── antd_icon.dart           # 统一的 AntdIcon 组件
├── assets/twotone/                  # 150 个打包的 SVG 资源
├── fonts/AntIcons.ttf               # Outlined + Filled 字形
├── test/
│   └── antd_icon_test.dart
└── docs/
    ├── api-index.md
    └── api/
```

## 许可证

MIT

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" />
