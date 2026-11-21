# Changelog

## 1.0.2

- Web support: platform detection no longer imports dart:io (conditional platform_os loader).
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Added `AntThemeData` with the full Seed -> Map -> Alias pipeline, including light, dark, and `fromSeed` factories and around 100 color aliases.
- Added typography, radius, spacing, control-height, line-width, motion, shadow, z-index, opacity, and screen-breakpoint getters to `AntThemeData`.
- Added `AntThemeData.s()` and `AntScale` for design-value scaling, with fixed, identity, and screen-derived (`auto`) factors.
- Added `AntTheme` and `AntThemeScope` for inherited theme access, plus `AntThemeBuilder` for rebuilding with `(context, theme)`.
- Added the `AntMaterialTheme.toThemeData()` bridge, mapping antd tokens onto Flutter's color scheme, text theme, and component themes, with an optional brightness override.
- Added `AntBreakpoint` and `AntBreakpoints` for antd grid breakpoints, comparison operators, and `isUp`/`isDown`/`isBetween` queries.
- Added `AntResponsive`, `AntResponsiveInit`, and `AntLayoutData` for width, breakpoint, device type, orientation, fold state, platform, and scale factor resolution.
- Added `AntPlatform` for centralized web, desktop, mobile, and input-capability checks.
- Added `AntOverlayMaterial` for Material-based popup and sheet overlays.
