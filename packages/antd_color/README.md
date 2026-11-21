# antd_color - Ant Design's color system for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/README_CN.md)

`antd_color` is the color foundation of the `antd_flutter` stack. It ports the algorithms behind Ant Design v6 — 10-step palette generation, color manipulation, preset seeds, and CSS color parsing — into dependency-light Dart. Every downstream package (`antd_tokens`, `antd_theme`, component packages) derives its colors from this package, so the values here are the same values antd produces in the browser.

The package deliberately stops at color: it contains no widgets, no `ThemeData`, and no design tokens. That boundary keeps it usable in pure-Dart tools (asset generators, CLI checks) as well as in Flutter apps. `AntColor` carries both hex strings and Flutter `Color` objects so callers do not pay for parsing on every frame; `AntFastColor` is a small mutable value type for one-off adjustments; `antParseColor` intentionally supports only the formats antd actually emits (`#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`, `rgba()`) so that unsupported input fails predictably instead of being guessed at.

## Positioning & design

- **Algorithm fidelity over API surface.** Palette generation follows antd's fixed light and dark mapping tables, and snapshot tests pin the output of the default presets.
- **No Flutter widgets.** The only Flutter dependency is `dart:ui`'s `Color`, which keeps the package cheap to depend on.
- **Two color representations, one source of truth.** `AntColor` exposes `stepN` (hex) and `stepNColor` (`Color`), all computed from the same palette list.
- **Silent fallback is a feature and a trap.** `antParseColor` returns black for unsupported strings rather than throwing. Validate user input before handing it to the parser.
- **Strings and typed models are interchangeable.** `AntFastColor.of` accepts hex, `rgb()`/`rgba()`, `hsl()`/`hsv()` strings, `AntRgb`, `AntHsl`, `AntHsv`, or another `AntFastColor`, so callers can stay in whichever representation their data arrives in.

## Installation

Requires Dart 3.0+ and Flutter 3.10+.

```yaml
dependencies:
  antd_color: ^1.0.0
```

## Quick start

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  // Generate the raw 10-step palette; index 5 is the main color (antd step 6).
  final palette = antGeneratePalette('#1677FF');
  print(palette[5]); // '#1677ff'

  // Wrap the palette for typed access; light and dark have separate factories.
  final primary = AntColor.fromSeed('#1677FF');
  print(primary.main); // '#1677ff'
  print(primary.step5); // hover step

  // One-off adjustments stay chainable.
  print(AntFastColor(primary.step5).darken(10).toHexString());
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_color/docs/api-index.md)

### Generate palettes and presets

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  final dark = antGeneratePalette(
    AntPresetColors.purple,
    const AntPaletteOptions(theme: 'dark'),
  );
  print(dark[4]);

  // Every antd preset seed in one call.
  final presets = antGeneratePresetPalettes(dark: true);
  print(presets['blue']![0]);
}
```

### Walk a palette with `AntColor`

```dart
import 'package:antd_color/antd_color.dart';

void main() {
  final palette = AntColor.fromSeed('#722ED1');
  print(palette[1]); // lightest step
  print(palette.mainColor);

  final dark = AntColor.fromSeedDark('#722ED1', background: '#141414');
  print(dark.step10);
}
```

### Manipulate and parse colors

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

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/color/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
antd_color/
├── lib/
│   ├── antd_color.dart              # Public barrel
│   └── src/
│       ├── ant_fast_color.dart      # Color manipulation and conversions
│       ├── ant_color_palette.dart   # 10-step palette algorithm
│       ├── ant_color.dart           # Palette wrapper (hex + Color)
│       ├── ant_color_presets.dart   # Preset seeds and batch generation
│       ├── ant_parse_color.dart     # CSS string -> Flutter Color
│       ├── config/                  # AntPaletteOptions
│       └── types/                   # AntRgb / AntHsl / AntHsv
├── test/
│   ├── ant_color_palette_test.dart
│   └── ant_fast_color_test.dart
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
