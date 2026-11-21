# antd_icons_flutter - Ant Design icons for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/README_CN.md)

`antd_icons_flutter` brings the Ant Design icon set to Flutter without a React bridge. It ships 698 Outlined and Filled icons as a single tree-shakeable TTF font, plus 150 TwoTone icons as packaged SVG assets, all ported from `@ant-design/icons-svg`. Names mirror the React package, so `AntIcons.checkOutlined` maps directly to `<CheckOutlined />` and existing component code translates one-to-one.

The package gives you two rendering paths behind one widget. `IconData` constants render synchronously through the font, which is the right default for dense toolbars and lists. TwoTone path constants render through `flutter_svg` with runtime color substitution, which keeps the two-layer antd look while letting the primary color follow your theme. `AntdIcon` dispatches on the argument type, so mixing both styles in one screen does not require separate widgets.

## Positioning & design

- **One import, three styles.** Outlined, Filled, and TwoTone are all reachable from the same barrel: `AntIcons` for the font icons and `AntIconsTwotone` for the SVG paths.
- **TTF for the common case.** Outlined and Filled share `fonts/AntIcons.ttf`; each constant is a `const IconData` in the private-use area, so Flutter's icon tree-shaking still applies.
- **SVG only where it earns its cost.** TwoTone needs two colors per glyph, which a monochrome font cannot express. The package bundles the SVG assets and colorizes them at runtime instead of generating thousands of font variants.
- **`AntdIcon` hides the dispatch.** Passing an `IconData` selects the font path; passing a `String` selects the SVG path. The wrong color parameter is ignored rather than throwing, matching the "just render something" expectation of icon code.
- **Names stay compatible with antd React.** The camelCase suffixes `Outlined`, `Filled`, and `TwoTone` follow the upstream names, which keeps migration mechanical and searchable.
- **Accessibility is opt-in.** Decorative icons stay silent by default; functional icons should pass `semanticLabel` so screen readers announce their purpose.

## Installation

Requires Dart 3.0+ and Flutter 3.10+.

```yaml
dependencies:
  antd_icons_flutter: ^1.0.1
```

The font and the TwoTone assets are bundled with the package; no extra asset declaration is needed in your app.

## Quick start

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
              // Outlined / Filled: TTF font rendering.
              AntdIcon(AntIcons.checkOutlined),
              AntdIcon(AntIcons.heartFilled, color: Colors.red, size: 32),

              // TwoTone: SVG rendering, default #333 + #E6E6E6.
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

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_icons_flutter/docs/api-index.md)

### Font icons, directly or through `AntdIcon`

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

### Colour a TwoTone icon

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

### Browse the catalogs

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  print(AntIcons.outlinedIcons.length); // 447
  print(AntIcons.filledIcons.length); // 251
  print(AntIconsTwotone.twotoneIcons.length); // 150

  // Each entry is a (name, icon/path) record.
  print(AntIcons.outlinedIcons.first.$1);
}
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/icons/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
antd_icons_flutter/
├── lib/
│   ├── antd_icons_flutter.dart      # Public barrel
│   └── src/
│       ├── ant_icons.dart           # Outlined + Filled IconData + catalogs
│       ├── ant_icons_twotone.dart   # TwoTone SVG path constants + catalog
│       └── antd_icon.dart           # Unified AntdIcon widget
├── assets/twotone/                  # 150 packaged SVG assets
├── fonts/AntIcons.ttf               # Outlined + Filled glyphs
├── test/
│   └── antd_icon_test.dart
└── docs/
    ├── api-index.md
    └── api/
```

## License

MIT

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" />
