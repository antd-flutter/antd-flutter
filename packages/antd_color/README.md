# antd_color

Ant Design v6 color system for Flutter — fast color manipulation, palette generation, and CSS color parsing, precisely ported from [`@ant-design/fast-color`](https://github.com/ant-design/fast-color) v3.

## Features

- **AntFastColor** — Create colors from hex / rgb / hsl / hsv strings; lighten, darken, mix, tint, shade, adjust alpha, and convert between formats.
- **Palette generation** — `antGeneratePalette` produces the signature Ant Design 10-step color scale (blue-1 … blue-10) from any base color, with dark theme support.
- **Preset palettes** — All 13 Ant Design preset colors (red, volcano, orange, gold, yellow, lime, green, cyan, blue, geekblue, purple, magenta, grey) ready to use.
- **Flutter-native** — Every color is accessible as a Flutter `Color` alongside its hex string.
- **CSS color parsing** — `antParseColor` converts any CSS color string into a Flutter `Color`.

## Getting started

```yaml
dependencies:
  antd_color: ^1.0.0
```

```dart
import 'package:antd_color/antd_color.dart';
```

## Usage

### Color manipulation

```dart
// Create from any CSS color string (shorthand for AntFastColor.of)
final base = AntFastColor('#1677ff');

// Lighten / darken (amount is a percentage 0-100)
final lighter = base.lighten(20);
final darker = base.darken(10);

// Mix two colors (amount is a percentage 0-100)
final mixed = base.mix('#ffffff', 50);

// Tint / shade (mix with white / black)
final tinted = base.tint(20);
final shaded = base.shade(10);

// Adjust alpha
final semi = base.setA(0.45);

// Convert
print(base.toHexString()); // #1677ff
print(base.toRgb());       // AntRgb(r: 22, g: 119, b: 255)
print(base.toRgbString()); // rgb(22,119,255)
print(base.toHsl());       // AntHsl(h: 215, s: 1.0, l: 0.54)
print(base.toHsv());       // AntHsv(h: 215, s: 0.91, v: 1.0)

// Check brightness
print(base.isDark());      // false
print(base.getLuminance()); // ~0.21 (WCAG relative luminance)
```

### Generate a 10-step palette

```dart
// Light theme palette
final palette = antGeneratePalette('#1677ff');
// palette[0] … palette[9] — hex strings, lightest to darkest

// Dark theme palette
final darkPalette = antGeneratePalette(
  '#1677ff',
  AntPaletteOptions(theme: 'dark', backgroundColor: '#141414'),
);
```

### Preset colors

```dart
// All 13 preset palettes (Map<String, List<String>>)
final presets = antGeneratePresetPalettes();
final blue = presets['blue']!; // 10-step hex strings

// Dark variants
final darkPresets = antGeneratePresetPalettes(dark: true);

// Or use the seed constants directly
final seed = AntPresetColors.blue; // #1677FF
```

### AntColor — palette wrapper

```dart
// Generate from a seed color (light theme mapping)
final antBlue = AntColor.fromSeed('#1677ff');

// Access by step (1-10) as hex string
print(antBlue.step1);  // lightest
print(antBlue.main);   // step 6 — the primary color
print(antBlue.step10); // darkest
print(antBlue[5]);     // operator access by step number

// Access by step (1-10) as Flutter Color
final primary = antBlue.step6Color;
final hover = antBlue.step5Color;
final active = antBlue.step7Color;
final colorAt3 = antBlue.colorAt(3);

// Dark theme variant
final antBlueDark = AntColor.fromSeedDark('#1677ff');
```

### Parse CSS color strings

```dart
// hex / rgb / rgba strings → Flutter Color
final c1 = antParseColor('#1677ff');
final c2 = antParseColor('rgba(22, 119, 255, 0.6)');
```

## Documentation

- [颜色系统总览](docs/color.md)
- [色板生成](docs/palette.md)
- [CSS 颜色解析](docs/parse.md)
- [API 索引](docs/api-index.md)

## Porting fidelity

The color algorithms (RGB ↔ HSL ↔ HSV conversion, palette generation with hue/saturation/brightness steps and dark theme mixing) are ported line-by-line from `@ant-design/fast-color` v3 and validated against its test fixtures to ensure visual parity with Ant Design React.

## License

MIT