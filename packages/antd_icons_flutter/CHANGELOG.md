## 1.0.1

文档与示例同步小版本，无 API 变更。

- 新增人工文档：[使用指南](docs/usage.md)、[图标目录](docs/icons-catalog.md)（498 个基础名 × 3 种形态，共 698 个图标，按语义域分组）
- example 正式化：国际化（中英文）、亮暗主题切换、嵌入模式、置顶搜索的图标画廊示例
- README 移除 Beta 横幅，补充文档章节链接

## 1.0.0

First stable release.

- **Outlined** icons (447) + **Filled** icons (251) — TTF font mode, `AntIcons` class with `IconData` constants
- **TwoTone** icons (150) — SVG assets rendered via `flutter_svg`, `AntIconsTwotone` class with asset path constants
- **`AntdIcon` widget** — unified component for both TTF and SVG modes, with `twoToneColor` support for TwoTone customization
- Self-contained `tool/generate.mjs` — downloads latest `@ant-design/icons-svg` from npm and regenerates all assets
- All naming aligned with antd React (`checkOutlined`, `heartFilled`, `checkCircleTwoTone`)