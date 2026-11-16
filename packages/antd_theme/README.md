# antd_theme

> [!WARNING]
> **Beta 阶段 — 暂不建议在生产环境使用。** antd_flutter_plus 当前处于 beta 阶段（0.x.0-beta.x），API 在 1.0.0 正式发布前可能随时变动，请仅用于评估、演示或开发体验。

Ant Design v6 theme system for Flutter — theme data, theme injection, responsive breakpoints, and screen adaptation, built on top of [`antd_tokens`](https://pub.dev/packages/antd_tokens) and [`antd_color`](https://pub.dev/packages/antd_color).

> **Beta** — This package is under active development. APIs may change before the stable release.

## Features

- **AntThemeData** — Complete theme data generated from a seed token via the antd Seed → Map → Alias derivation chain. Provides `light()`, `dark()`, and `fromSeed()` factories, plus convenient accessors for every alias token (colors, fonts, radius, sizes, control heights, spacing, line widths, motion, shadows, z-index, screen breakpoints).
- **AntTheme / AntThemeBuilder** — `InheritedWidget` that injects `AntThemeData` into the widget tree. Retrieve the current theme with `AntTheme.of(context)` or use `AntThemeBuilder` for a build-time shortcut.
- **AntBreakpoint / AntBreakpoints** — antd responsive breakpoint enum (xs ~ xxxl) with `fromWidth` / `of` and comparison operators, plus `isUp` / `isDown` / `isBetween` utilities.
- **AntScreenUtilInit** — Screen adaptation wrapper around `flutter_screenutil` with built-in desktop auto-adaptation (scale factor = 1 on desktop). Only `.w` / `.sp` / `.r` extensions are supported.

## Getting started

```yaml
dependencies:
  antd_theme: ^0.1.0-beta.1
```

```dart
import 'package:antd_theme/antd_theme.dart';
```

## Usage

### Theme data

```dart
// Default light theme — identical to antd defaults
final light = AntThemeData.light();

// Dark theme
final dark = AntThemeData.dark();

// Custom seed
final custom = AntThemeData.fromSeed(
  const AntSeedToken(colorPrimary: '#722ed1', borderRadius: 8),
);

// Access tokens directly
Container(
  color: light.colorBgContainer,
  padding: EdgeInsets.all(light.padding),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: light.fontSizeLG,
      color: light.colorText,
    ),
  ),
);
```

### Theme injection

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(
    home: AntThemeBuilder(builder: (context, theme) {
      return Scaffold(
        backgroundColor: theme.colorBgLayout,
        body: Center(
          child: Text(
            'Themed!',
            style: TextStyle(color: theme.colorPrimary),
          ),
        ),
      );
    }),
  ),
);
```

### Responsive breakpoints

```dart
// Current breakpoint from context
final bp = AntBreakpoint.of(context);
if (bp >= AntBreakpoint.md) {
  // ≥768 layout
}

// Utility checks
if (AntBreakpoints.isDown(context, AntBreakpoint.sm)) {
  // <576 mobile layout
}
if (AntBreakpoints.isBetween(context, AntBreakpoint.md, AntBreakpoint.lg)) {
  // 768 ≤ width < 992
}
```

### Screen adaptation

```dart
AntScreenUtilInit(
  builder: (context, child) => AntTheme(
    data: AntThemeData.light(),
    child: MaterialApp(...),
  ),
);

// Use .w / .sp / .r extensions (never .h)
SizedBox(width: 100.w);
Text('Hello', style: TextStyle(fontSize: 14.sp));
BorderRadius.circular(6.r);
```

On desktop (window width ≥ 768 by default), the scale factor is automatically set to 1 so components keep their logical pixel sizes. Set `desktopBreakpoint: null` to disable this behavior.

## License

MIT