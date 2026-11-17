# antd_flutter_plus

[![pub package](https://img.shields.io/pub/v/antd_flutter_plus.svg)](https://pub.dev/packages/antd_flutter_plus)

> [!WARNING]
> **本包即将停用，请不要接入。** `antd_flutter_plus` 正在进行整体重构拆分：通用基础能力将沉淀到基础库 `antd_flutter_ui`，Picker、Table 等复杂组件将拆分为独立的单组件包（如 `antd_picker`、`antd_table` 等）。本伞包在拆分完成后将不再维护，现有组件文档将迁移至各独立包的 README 与文档页。

## 拆分背景

本仓库原先以单一伞包 `antd_flutter_plus` 聚合全部组件。为了降低接入成本、缩小依赖面，组件库正在拆分为：

- **基础库 `antd_flutter_ui`**：主题、令牌、颜色、图标等通用基础能力
- **独立复杂组件包**：Picker、Table 等体量较大的组件各自独立成包，按需引入

## 未来接入方式

拆分完成后，可按需选择：

1. **全量伞包**：引入聚合包，一次性获得全部组件（适合快速试用与完整体验）
2. **单组件包**：只引入所需组件对应的包（适合对包体积与依赖面敏感的生产项目）

各组件的安装方式与文档将以独立包页面为准。

## 链接

- [官网](https://antd-flutter.github.io/antd-flutter/)
- [图标 Gallery](https://antd-flutter.github.io/antd-flutter/icons/)
- [GitHub](https://github.com/antd-flutter/antd-flutter)
- [GitCode](https://gitcode.com/antd-flutter/antd-flutter)
- [问题反馈](https://github.com/antd-flutter/antd-flutter/issues)

## License

MIT
