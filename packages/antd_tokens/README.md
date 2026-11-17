# antd_tokens

> [!WARNING]
> **Beta 阶段 — 暂不建议在生产环境使用。** antd_tokens 当前处于 beta 阶段（0.x.0-beta.x），API 在 1.0.0 正式发布前可能随时变动，请仅用于评估、演示或开发体验。

Ant Design v6 Design Token system for Flutter — seed tokens, token generation algorithms, color token maps, and shadow tokens, precisely ported from [Ant Design](https://ant.design/) `components/theme`.

> **Beta** — This package is under active development. APIs may change before the stable release.

## Features

- **AntSeedToken** — The minimal input set for theming (colorPrimary, fontSize, borderRadius, …), with defaults identical to antd `seed.ts`.
- **Token generators** — `antGenFontMapToken`, `antGenRadius`, `antGenSizeMapToken`, `antGenControlHeight`, `antGenMotionDuration` — the Seed → Map derivation algorithms ported from antd `themes/shared/`.
- **AntColorTokens** — Complete color token set (Map Token + Alias Token) generated from a seed, with `light` / `dark` factories. Every token is available as a Flutter `Color`, plus raw CSS strings for debugging.
- **AntShadowTokens** — All antd box-shadow tokens (`boxShadow`, `boxShadowSecondary`, `boxShadowCard`, drawer / tabs shadows, …) converted to Flutter `List<BoxShadow>`.

## Getting started

```yaml
dependencies:
  antd_tokens: ^0.1.0-beta.1
```

```dart
import 'package:antd_tokens/antd_tokens.dart';
```

## Usage

### Seed tokens

```dart
// Default seed — identical to antd defaults
const seed = AntSeedToken();

// Customize
const custom = AntSeedToken(
  colorPrimary: '#722ed1',
  fontSize: 16,
  borderRadius: 8,
);

// Dark theme seed
final darkSeed = AntSeedToken.dark();
```

### Token generators

```dart
// Font size ladder (10 steps, antd genFontSizes)
final fontMap = antGenFontMapToken(14);
print(fontMap.fontSize);    // 14
print(fontMap.fontSizeLG);  // 16
print(fontMap.fontSizeHeading1); // 38

// Radius ladder
final radius = antGenRadius(6);
print(radius.borderRadiusSM); // 4
print(radius.borderRadiusLG); // 8

// Size map
final sizes = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
print(sizes.size);   // 16
print(sizes.sizeLG); // 24

// Control heights
final heights = antGenControlHeight(32);
print(heights.controlHeightSM); // 24
print(heights.controlHeightLG); // 40

// Motion durations
final motion = antGenMotionDuration(motionUnit: 0.1, motionBase: 0, motion: true);
print(motion.fast); // 0.1
print(motion.mid);  // 0.2
print(motion.slow); // 0.3
```

### Color tokens

```dart
// Generate from seed
final lightColors = AntColorTokens.light(seed);
final darkColors = AntColorTokens.dark(darkSeed);

// Access as Flutter Color
final primary = lightColors.colorPrimary;       // Color(0xFF1677FF)
final textSecondary = lightColors.colorTextSecondary;
final border = lightColors.colorBorder;

// Access raw CSS strings (debugging / export)
print(lightColors.css.colorPrimary);            // #1677ff
print(darkColors.css.colorBgContainer);         // #141414

// Check theme
print(lightColors.isDark); // false
```

### Shadow tokens

```dart
// Generate from the shadow base color
final shadows = AntShadowTokens.generate('#000000');

// Use in Flutter widgets
Container(
  decoration: BoxDecoration(
    color: theme.colorBgContainer,
    boxShadow: shadows.boxShadow,        // popup elevation
    borderRadius: BorderRadius.circular(6),
  ),
  child: ...,
);

// Other shadows
shadows.boxShadowSecondary;     // secondary popup
shadows.boxShadowTertiary;      // light float
shadows.boxShadowCard;          // card shadow
shadows.boxShadowDrawerRight;   // drawer directional shadows
shadows.boxShadowTabsOverflowLeft; // tabs overflow shadows
```

## Porting fidelity

The token derivation chain (Seed → Map → Alias) is ported line-by-line from antd `components/theme/themes/` (seed.ts, shared/genFontSizes.ts, shared/genRadius.ts, genColorMapToken.ts, alias.ts) and validated against antd's token snapshots to ensure visual parity with Ant Design React.

## License

MIT