## 0.1.0-beta.1

Initial beta release.

- `AntFastColor` — color manipulation ported from `@ant-design/fast-color` v3:
  - Construct from hex / rgb / hsl / hsv strings, or raw RGB / HSL / HSV values
  - `lighten`, `darken`, `mix`, `tint`, `shade`, `onBackground`
  - `toHexString`, `toRgbString`, `toHslString`, `toRgb`, `toHsl`, `toHsv`
  - `isDark`, `isLight`, `getLuminance`, `getBrightness`
- `antGeneratePalette` — Ant Design 10-step palette generation with dark theme support
- `AntPresetColors` — 13 Ant Design preset color seed constants
- `antGeneratePresetPalettes` — generate all preset palettes (light / dark)
- `AntColor` — palette wrapper with step-by-step access (hex string & Flutter `Color`)
- `antParseColor` — CSS color string → Flutter `Color`