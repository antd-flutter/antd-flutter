# antd_color API 文档

`antd_color` 是 Ant Design v6 颜色系统的 Flutter/Dart 实现，精确移植 `@ant-design/fast-color` v3 与 `@ant-design/colors` 的 `generate` 色板生成算法，保证 Dart 侧生成的色值与 antd 源码逐一断言对齐。本包不依赖 Flutter 框架 Widget 体系（仅使用 `dart:ui` 的 `Color`），可在纯 Dart 环境使用色板与颜色运算能力。

## 使用场景

- **动态主题色**：从任意种子色生成 antd 风格的 10 阶色板，映射到 `colorPrimaryBg`、`colorPrimaryHover`、`colorPrimaryActive` 等 Token。
- **暗色主题**：同一种子色生成暗色主题色板（与 antd 暗色映射算法一致）。
- **颜色运算**：加深/变浅/混合/透明度合成等操作，结果与 `@ant-design/fast-color` 一致。
- **CSS 颜色解析**：将 `#hex`、`rgb()`、`rgba()` 字符串解析为 Flutter `Color`。

文档按 API 面划分为三个部分：

| 文件 | 内容 |
| --- | --- |
| [color.md](color.md) | `AntFastColor` 及 `AntRgb` / `AntHsl` / `AntHsv` |
| [palette.md](palette.md) | `antGeneratePalette`、`AntPaletteOptions`、`AntPresetColors`、`antGeneratePresetPalettes` |
| [parse.md](parse.md) | `antParseColor`、`AntColor` |
