# Changelog

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Added `AntSeedToken` with antd-aligned defaults for seed colors, font family and size, line width and type, motion curve and duration, radius, size unit and step, control height, z-index, opacity, wireframe, and focus outline.
- Added `AntSeedToken.dark()` and `copyWith`, enabling dark-neutral seeds and partial overrides without rebuilding every field.
- Added `antGenFontSizes`, `antGetLineHeight`, and `antGenFontMapToken` for the font-size ladder, component and heading sizes, line heights, and font heights.
- Added `antGenRadius` for the `XS`/`SM`/`LG`/`Outer` radius ladder, including antd's range-based derivation rules.
- Added `antGenSizeMapToken` for the `sizeXXS`-`sizeXXL` spacing ladder.
- Added `antGenControlHeight` for `controlHeightSM`, `controlHeightXS`, and `controlHeightLG`.
- Added `antGenMotionDuration` for fast, mid, and slow durations, with a zeroed result when motion is disabled.
- Added `AntColorTokens` with light and dark factories, around 100 parsed color aliases, and `AntColorTokensCss` for the raw CSS strings behind each alias.
- Added `AntShadowTokens.generate` with 13 elevation sets covering popups, cards, arrows, four drawer directions, and four tabs-overflow directions.
