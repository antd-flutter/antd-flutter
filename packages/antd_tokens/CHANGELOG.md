## 0.1.0-beta.1

Initial beta release.

- `AntSeedToken` — seed token configuration with defaults identical to antd `seed.ts`, plus `AntSeedToken.dark()` factory
- Token generators ported from antd `themes/shared/`:
  - `antGenFontSizes` / `antGenFontMapToken` — 10-step font size ladder and font map tokens
  - `antGenRadius` — radius ladder (XS / SM / base / LG / Outer)
  - `antGenSizeMapToken` — size map tokens (XXS … XXL)
  - `antGenControlHeight` — control height tokens (XS / SM / LG)
  - `antGenMotionDuration` — motion duration tokens (fast / mid / slow)
- `AntColorTokens` — complete color token set (Map Token + Alias Token) with `light` / `dark` factories, exposed as Flutter `Color` and raw CSS strings (`AntColorTokensCss`)
- `AntShadowTokens` — all antd box-shadow tokens converted to Flutter `List<BoxShadow>` (popup, card, drawer, tabs overflow, popover arrow)