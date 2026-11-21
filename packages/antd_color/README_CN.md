# antd_color - Flutter 的 Ant Design 颜色系统

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/README_CN.md)

`antd_color` 是 `antd_flutter` 体系的颜色基础层。它把 Ant Design v6 背后的算法——10 阶色板生成、颜色操作、预设种子色与 CSS 颜色解析——移植为依赖极少的 Dart 实现。下游的 `antd_tokens`、`antd_theme` 与各组件包都从这里取色，因此这里算出的值与浏览器中 antd 的值保持一致。

本包刻意止步于颜色：不包含 Widget、不包含 `ThemeData`、也不包含设计令牌。这条边界让它既能在纯 Dart 工具（资源生成器、CLI 校验）中使用，也能在 Flutter 应用中使用。`AntColor` 同时提供 hex 字符串和 Flutter `Color` 对象，调用方不必每帧重新解析；`AntFastColor` 是用于一次性调整的小型可变值类型；`antParseColor` 只支持 antd 实际会输出的格式（`#rgb`、`#rrggbb`、`#rrggbbaa`、`rgb()`、`rgba()`），让不支持的输入可预期地失败，而不是被猜测。

## 定位与设计

- **算法保真优先于 API 数量。** 色板生成遵循 antd 固定的亮色与暗色映射表，默认预设的输出由快照测试锁定。
- **不包含 Flutter Widget。** 唯一的 Flutter 依赖是 `dart:ui` 的 `Color`，因此依赖成本很低。
- **两种颜色表示，同一数据源。** `AntColor` 提供 `stepN`（hex）与 `stepNColor`（`Color`），两者都由同一份色板列表计算。
- **静默兜底既是特性也是陷阱。** `antParseColor` 对无法识别的字符串返回黑色而不抛异常；把用户输入交给解析器前请先校验。
- **字符串与类型模型可互换。** `AntFastColor.of` 接受 hex、`rgb()`/`rgba()`、`hsl()`/`hsv()` 字符串、`AntRgb`、`AntHsl`、`AntHsv` 或另一个 `AntFastColor`，调用方可停留在数据到达时的表示形式。

## 安装

要求 Dart 3.0+、Flutter 3.10+。

```yaml
dependencies:
  antd_color: ^1.0.0
```

## 快速开始

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  // 生成原始 10 阶色板；索引 5 为主色（对应 antd 第 6 阶）。
  final palette = antGeneratePalette('#1677FF');
  print(palette[5]); // '#1677ff'

  // 包装为色板对象以获得类型化访问；亮色与暗色使用不同工厂。
  final primary = AntColor.fromSeed('#1677FF');
  print(primary.main); // '#1677ff'
  print(primary.step5); // 悬浮态步阶

  // 一次性颜色调整支持链式调用。
  print(AntFastColor(primary.step5).darken(10).toHexString());
}
```

## API

[API 文档](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/docs/api-index.md)

### 生成色板与预设

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  final dark = antGeneratePalette(
    AntPresetColors.purple,
    const AntPaletteOptions(theme: 'dark'),
  );
  print(dark[4]);

  // 一次生成全部 antd 预设色板。
  final presets = antGeneratePresetPalettes(dark: true);
  print(presets['blue']![0]);
}
```

### 使用 `AntColor` 按步阶取色

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  final palette = AntColor.fromSeed('#722ED1');
  print(palette[1]); // 最浅一阶
  print(palette.mainColor);

  final dark = AntColor.fromSeedDark('#722ED1', background: '#141414');
  print(dark.step10);
}
```

### 操作与解析颜色

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  final base = AntFastColor('#1677FF');
  print(base.lighten(10).toHexString());
  print(base.mix('#722ED1', 50).toHexString());
  print(base.isDark());

  final parsed = antParseColor('rgba(22, 119, 255, 0.5)');
  print(parsed);
}
```

## 项目结构

```text
antd_color/
├── lib/
│   ├── antd_color.dart              # 公共出口
│   └── src/
│       ├── ant_fast_color.dart      # 颜色操作与模型转换
│       ├── ant_color_palette.dart   # 10 阶色板算法
│       ├── ant_color.dart           # 色板包装（hex + Color）
│       ├── ant_color_presets.dart   # 预设种子与批量生成
│       ├── ant_parse_color.dart     # CSS 字符串 -> Flutter Color
│       ├── config/                  # AntPaletteOptions
│       └── types/                   # AntRgb / AntHsl / AntHsv
├── test/
│   ├── ant_color_palette_test.dart
│   └── ant_fast_color_test.dart
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
