# antd_theme - Ant Design v6 theming for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/README_CN.md)

`antd_theme` turns the raw tokens from `antd_tokens` into a Flutter theme you can read from the widget tree. It carries the three antd layers end to end — **Seed → Map → Alias** — and exposes one `AntThemeData` object with roughly a hundred color aliases, typography, spacing, radius, control-height, motion, shadow, z-index, and screen-breakpoint values. Components read `theme.colorBgContainer` or `theme.fontSizeHeading1` instead of hard-coding numbers or branching on brightness.

The package also owns the parts of theming that are Flutter-specific: an `AntTheme` inherited scope, an `AntThemeBuilder` convenience widget, a Material bridge (`toThemeData()`) so stock Material widgets inherit antd values, breakpoint and platform helpers, and `AntScale` for turning design values into device values through `theme.s()`. It does not ship visual components; it defines the contract those components consume.

## Positioning & design

- **One object, three layers.** `AntThemeData` holds the seed, the generated token maps, and the alias getters. Creating a theme with `fromSeed` re-runs generation; reading `theme.colorPrimary` is a direct field access after that.
- **Brightness is a property, not a code path.** `AntThemeData.light()` and `.dark()` produce the same API surface. Components never check `isDark` to pick a color; they ask for the alias and the matching mapping table supplies it.
- **Material bridge, not a replacement.** `toThemeData()` maps antd tokens onto `ColorScheme`, `TextTheme`, and component themes so native Material controls look consistent. `AntTheme` wraps the app in `Theme(data: ...)` while keeping `AntThemeData` available through the inherited scope.
- **Scaling has one entry point.** `theme.s(12)` multiplies a design value by `AntScale.factor`. `AntScale.auto(context)` derives that factor from the shortest screen side, clamped between `min` and `max` and disabled on desktop; `AntScale.none` keeps values 1:1.
- **Responsive data is inherited, not rebuilt per widget.** `AntResponsiveInit` resolves width, breakpoint, device type, orientation, fold state, and platform once, then exposes them through `AntResponsive` for cheap lookups.
- **Platform quirks stay in one place.** `AntPlatform` centralizes hover, touch-ripple, scrollbar, and keyboard expectations instead of scattering `Platform.isX` checks across components.

## Installation

Requires Dart 3.0+ and Flutter 3.10+.

```yaml
dependencies:
  antd_theme: ^1.0.0
```

## Quick start

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AntTheme(
      data: AntThemeData.light(scale: const AntScale(1.1)),
      child: MaterialApp(
        home: AntThemeBuilder(
          builder: (context, theme) {
            return Scaffold(
              backgroundColor: theme.colorBgLayout,
              body: Center(
                child: Container(
                  padding: EdgeInsets.all(theme.s(16)),
                  decoration: BoxDecoration(
                    color: theme.colorBgContainer,
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG),
                    boxShadow: theme.boxShadowTertiary,
                  ),
                  child: Text(
                    'Ant Design tokens in Flutter',
                    style: TextStyle(
                      color: theme.colorText,
                      fontSize: theme.fontSizeLG,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/docs/api-index.md)

### Create themes, scale values, bridge to Material

```dart
import 'package:antd_theme/antd_theme.dart';

void main() {
  final light = AntThemeData.light();
  final dark = AntThemeData.dark();

  print(light.colorPrimary);
  print(dark.colorBgContainer);
  print(light.s(12)); // design value scaled by the theme factor

  // Stock Material widgets can inherit the antd values too.
  final material = light.toThemeData();
  print(material.colorScheme.primary);
}
```

### Branch on breakpoints and platform

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: BreakpointBadge()));

class BreakpointBadge extends StatelessWidget {
  const BreakpointBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final breakpoint = AntBreakpoint.of(context);
    final compact = breakpoint == null ||
        breakpoint == AntBreakpoint.xs ||
        breakpoint == AntBreakpoint.sm;

    return Center(
      child: Text(
        compact ? 'compact layout' : 'wide layout (${breakpoint!.name})',
        style: TextStyle(fontSize: AntPlatform.isDesktop ? 14 : 16),
      ),
    );
  }
}
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/theme/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
antd_theme/
├── lib/
│   ├── antd_theme.dart              # Public barrel
│   └── src/
│       ├── ant_theme_data.dart      # AntThemeData + alias getters + s()
│       ├── ant_theme.dart           # AntTheme scope + AntThemeBuilder
│       ├── ant_material_bridge.dart # toThemeData() bridge
│       ├── ant_responsive.dart      # AntResponsiveInit / AntResponsive
│       ├── ant_breakpoint.dart      # Breakpoint resolution
│       ├── ant_scale.dart           # Design-to-device scaling
│       ├── ant_platform.dart        # Platform capability helpers
│       ├── ant_screen_util.dart
│       ├── ant_overlay_material.dart
│       ├── enum/                    # Breakpoint / responsive enums
│       └── types/                   # Layout and sub-token data types
├── test/
│   ├── ant_material_bridge_test.dart
│   ├── ant_responsive_test.dart
│   ├── ant_scale_test.dart
│   └── ant_theme_test.dart
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
