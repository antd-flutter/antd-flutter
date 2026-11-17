# antd_icons_flutter

Ant Design icons for Flutter — 850+ icons covering Outlined, Filled and TwoTone styles, ported from [`@ant-design/icons-svg`](https://github.com/ant-design/ant-design-icons).

**[📚 Icon Gallery](https://antd-flutter.github.io/antd-flutter/icons/)** — browse all 850+ icons with live search and TwoTone color picker.

## Features

- **TTF font mode** — Outlined (447) + Filled (251) packed in a single TTF font, native Flutter rendering
- **TwoTone SVG mode** — 150 dual-color icons rendered via `flutter_svg`, with runtime color customization
- **Unified `AntdIcon` widget** — one component for both TTF and SVG modes, API aligned with antd React
- **Ant Design fidelity** — naming convention matches antd React (`checkOutlined`, `heartFilled`, `checkCircleTwoTone`)

## Getting started

```yaml
dependencies:
  antd_icons_flutter: ^1.0.1
```

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
```

## Usage

### AntdIcon widget (recommended)

```dart
// Outlined / Filled (TTF font)
AntdIcon(AntIcons.checkOutlined)
AntdIcon(AntIcons.searchOutlined, size: 24, color: Colors.blue)

// TwoTone (SVG, default #333 + #E6E6E6)
AntdIcon(AntIconsTwotone.checkCircleTwoTone)

// TwoTone with custom primary color (secondary auto-generated)
AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
```

### Flutter Icon widget (TTF only)

```dart
Icon(AntIcons.checkOutlined)
Icon(AntIcons.heartFilled, color: Colors.red)
```

### Naming convention

| antd React | antd_icons_flutter |
|---|---|
| `<CheckOutlined />` | `AntIcons.checkOutlined` |
| `<CheckCircleFilled />` | `AntIcons.checkCircleFilled` |
| `<CheckCircleTwoTone />` | `AntIconsTwotone.checkCircleTwoTone` |

### Inside antd_flutter_plus

If you use `antd_flutter_plus`, icons are re-exported automatically:

```dart
import 'package:antd_flutter_plus/antd_flutter_plus.dart';

AntButton(icon: AntdIcon(AntIcons.searchOutlined), child: Text('Search'))
```

## Documentation

- [API 文档总览](docs/api-index.md)（每个公开 API 独立页面，位于 docs/api/）— 698 图标常量见 AntIcons / AntIconsTwotone 类页成员表

## Regenerating assets

The `tool/` directory contains a self-contained generator that downloads the latest `@ant-design/icons-svg` from npm and regenerates all assets:

```bash
cd tool && npm install && node generate.mjs
```

Options: `--version <ver>` · `--clean` · `--registry <url>`

## Icon list

Full icon list available at [ant.design/components/icon](https://ant.design/components/icon).

## License

MIT