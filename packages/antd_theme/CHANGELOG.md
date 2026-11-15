## 0.1.0-beta.1

Initial beta release.

- `AntThemeData` — complete theme data generated from `AntSeedToken` via the antd Seed → Map → Alias derivation chain, with `light` / `dark` / `fromSeed` factories and convenient accessors for every alias token (colors, fonts, radius, sizes, control heights, spacing, line widths, motion, shadows, z-index, screen breakpoints)
- `AntTheme` — `InheritedWidget` that injects `AntThemeData` into the widget tree; `AntTheme.of(context)` retrieves the current theme
- `AntThemeBuilder` — convenience builder that provides `AntThemeData` during build
- `AntBreakpoint` — antd responsive breakpoint enum (xs ~ xxxl) with `fromWidth` / `of` and comparison operators (`>=`, `<=`, `>`, `<`)
- `AntBreakpoints` — breakpoint utilities (`isUp` / `isDown` / `isBetween`)
- `AntScreenUtilInit` — screen adaptation wrapper around `flutter_screenutil` with built-in desktop auto-adaptation (scale factor = 1 on desktop); only `.w` / `.sp` / `.r` extensions are supported (`.h` is prohibited)