# antd_icons_flutter

Ant Design icons for Flutter — 850+ 图标，覆盖 Outlined / Filled / TwoTone 三种风格，移植自 `@ant-design/icons-svg`。

## 安装

```yaml
dependencies:
  antd_icons_flutter: ^1.0.1
```

## 用法

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ── AntdIcon 统一组件（推荐） ─────────────────────────────
// Outlined / Filled（TTF 字体渲染）
AntdIcon(AntIcons.checkOutlined);
AntdIcon(AntIcons.searchOutlined, size: 24, color: Colors.blue);

// TwoTone（SVG 渲染，默认 #333 + #E6E6E6）
AntdIcon(AntIconsTwotone.checkCircleTwoTone);

// TwoTone 自定义主色（次色自动生成）
AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red);

// ── Flutter 原生 Icon（仅 TTF） ──────────────────────────
Icon(AntIcons.checkOutlined);
Icon(AntIcons.heartFilled, color: Colors.red);
```

命名与 antd React 对齐：

| antd React | antd_icons_flutter |
|---|---|
| `<CheckOutlined />` | `AntIcons.checkOutlined` |
| `<CheckCircleFilled />` | `AntIcons.checkCircleFilled` |
| `<CheckCircleTwoTone />` | `AntIconsTwotone.checkCircleTwoTone` |

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 图标画廊（在线搜索 + TwoTone 取色）：<https://antd-flutter.github.io/antd-flutter/icons/>

## License

MIT License，详见 [LICENSE](LICENSE)。
