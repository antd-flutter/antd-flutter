# Changelog

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Added `AntFastColor`, a mutable RGBA color type with parsing for hex (`#rgb`, `#rrggbb`, `#rrggbbaa`, optional `#`), `rgb()`/`rgba()`, `hsl()`/`hsla()`, and `hsv()`/`hsb()` values, plus `AntRgb`/`AntHsl`/`AntHsv` models and polymorphic `AntFastColor.of` construction.
- Added color manipulation and inspection on `AntFastColor`: `lighten`, `darken`, `mix`, `tint`, `shade`, `onBackground`, `setR`/`setG`/`setB`/`setA`, luminance, hue, saturation, lightness, value, brightness, `isDark`/`isLight`, `clone`, and hex/rgb/hsl/hsv conversions.
- Added `antGeneratePalette` for 10-step light and dark palettes derived from antd's fixed mapping tables, with the main color at index 5.
- Added `AntPaletteOptions` to select the dark mapping table and override its background color.
- Added `AntColor` with `fromSeed`, `fromSeedDark`, `fromRawPalette`, `fromRawPaletteDark`, and `fromMapped`, exposing `step1`-`step10`, `step1Color`-`step10Color`, `main`, `mainColor`, `palette`, and step indexing.
- Added `AntPresetColors` with the 13 antd preset seeds and `antGeneratePresetPalettes` for bulk light or dark preset maps.
- Added `antParseColor` for `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`, and `rgba()` strings, falling back to opaque black for unsupported input.
