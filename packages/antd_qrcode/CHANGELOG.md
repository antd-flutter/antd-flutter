# Changelog

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_qrcode` package.

### Features

- `AntQRCode` renders a QR code from a `String` with `CustomPaint`, sized in theme-scaled design pixels.
- Four error-correction levels (`AntQRCodeErrorLevel.l/m/q/h`) mapping to 7%, 15%, 25% and 30% recoverable data.
- Optional foreground and background colors, defaulting to the Ant Design text and container colors.
- Optional 1 px `colorSplit` border with `borderRadiusLG` corners via `bordered`.
- Optional center glyph (`icon`, `iconSize`) rendered only while the code is active.
- Status overlays for `active`, `expired` and `scanned`; the expired overlay becomes tappable when `onRefresh` is provided.
- Theme integration through `antd_theme` for radius, border color, text color and background color.
- Self-contained pure-Dart QR engine absorbed from `package:qr` 3.0.3, wrapped behind an internal `AntQrMatrix` middleware and stable against a pre-migration baseline.
- Public `AntQrPainter` for rendering the same modules on a custom canvas.

### Notes

- Display only: no scanning, decoding or image export.
- Overlay labels are fixed Chinese strings and are not localized.
- `size` includes 12 px padding on each side, so the painted module area is `size - 24`.
- The center glyph is a built-in icon rather than a custom logo slot.
- The absorbed QR engine remains BSD-3-Clause; see `LICENSE-THIRD-PARTY.md`.
