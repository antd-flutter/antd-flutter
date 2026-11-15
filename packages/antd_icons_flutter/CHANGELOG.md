## 1.0.0

First stable release.

- **Outlined** icons (447) + **Filled** icons (251) — TTF font mode, `AntIcons` class with `IconData` constants
- **TwoTone** icons (150) — SVG assets rendered via `flutter_svg`, `AntIconsTwotone` class with asset path constants
- **`AntdIcon` widget** — unified component for both TTF and SVG modes, with `twoToneColor` support for TwoTone customization
- Self-contained `tool/generate.mjs` — downloads latest `@ant-design/icons-svg` from npm and regenerates all assets
- All naming aligned with antd React (`checkOutlined`, `heartFilled`, `checkCircleTwoTone`)