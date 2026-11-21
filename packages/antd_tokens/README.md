# antd_tokens - Ant Design v6 design tokens for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/README_CN.md)

`antd_tokens` is the token layer of the `antd_flutter` stack. It ports Ant Design v6's seed tokens, token generators, color alias maps, and shadow tokens into pure Dart. The package answers one question for every downstream widget: given a seed (primary color, font size, radius base, control height), what exact value should a component use for `colorTextSecondary`, `fontSizeHeading1`, or `controlHeightSM`?

Keeping generation separate from theming is intentional. The generators are plain functions with no `BuildContext`, no widgets, and no inherited state, so the same algorithms can run in tests, CLI tools, or a theme object. `AntSeedToken` is immutable and `copyWith`-friendly; `AntColorTokens` and `AntShadowTokens` produce Flutter `Color` and `BoxShadow` values while also exposing the original CSS strings through `AntColorTokensCss` for producers that emit CSS variables.

## Positioning & design

- **Seed → map → alias, exactly as antd does it.** Each generator mirrors the corresponding antd function (`genFontSizes`, `genRadius`, `genSizeMapToken`, `genControlHeight`, and the motion part of `genCommonMapToken`), including its rounding and clamping rules.
- **Functions, not framework objects.** Every generator is a top-level function that returns an immutable value object. There is no hidden global state and no dependency on Flutter's widget tree.
- **Light and dark are two mappings of the same seeds.** `AntColorTokens.light` and `.dark` share the alias names; only the mapping tables differ, so component code never branches on brightness.
- **CSS strings stay available.** `AntColorTokensCss` exposes the raw values (`#1677ff`, `rgba(...)`) next to the parsed `Color` getters, which keeps web and mobile outputs aligned.
- **Shadows are generated from one color.** `AntShadowTokens.generate` derives all 13 elevation sets from a single shadow color, so dark themes only need to change that input.

## Installation

Requires Dart 3.0+ and Flutter 3.10+.

```yaml
dependencies:
  antd_tokens: ^1.0.0
```

## Quick start

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  // Start from antd defaults and override only what the brand changes.
  const seed = AntSeedToken();
  final brand = seed.copyWith(colorPrimary: '#722ed1', borderRadius: 8);

  // Generators turn scalar seeds into complete ladders.
  print(antGenFontMapToken(brand.fontSize).fontSizeLG); // 16
  print(antGenRadius(brand.borderRadius).borderRadiusLG); // 8

  // Color aliases are generated as one map per brightness.
  final colors = AntColorTokens.light(brand);
  print(colors.colorPrimary);
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/docs/api-index.md)

### Derive size, height, and motion ladders

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final sizes = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
  print(sizes.size); // 16
  print(sizes.sizeXXL); // 48

  final heights = antGenControlHeight(32);
  print(heights.controlHeightSM); // 24

  final motion = antGenMotionDuration(
    motionUnit: 0.1,
    motionBase: 0,
    motion: true,
  );
  print(motion.mid); // 0.2
}
```

### Read color aliases for light and dark

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final light = AntColorTokens.light(const AntSeedToken());
  print(light.colorPrimary);
  print(light.css.colorPrimary); // '#1677ff'

  final dark = AntColorTokens.dark(AntSeedToken.dark());
  print(dark.colorBgContainer);
}
```

### Build elevation from one shadow color

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final shadows = AntShadowTokens.generate('#000000');
  print(shadows.boxShadow.length);
  print(shadows.boxShadowSecondary);
}
```

## Project structure

```text
antd_tokens/
├── lib/
│   ├── antd_tokens.dart             # Public barrel
│   └── src/
│       ├── ant_seed_token.dart      # Seed token + light/dark factories
│       ├── ant_token_generators.dart # Generator aggregate export
│       ├── ant_color_tokens.dart    # Color alias map (light/dark)
│       ├── ant_shadow_tokens.dart   # Elevation sets
│       ├── generators/              # Font, radius, size, height, motion
│       └── css/                     # AntColorTokensCss raw strings
├── test/
│   ├── ant_color_tokens_test.dart
│   ├── ant_seed_token_test.dart
│   ├── ant_shadow_tokens_test.dart
│   └── ant_token_generators_test.dart
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
