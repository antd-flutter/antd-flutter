# antd_qrcode - QR code renderer with error levels and status overlays

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/README_CN.md)

`antd_qrcode` renders a QR code from a string, following the antd v6 QRCode API. It supports the four error-correction levels, custom foreground/background colors, a border, an optional center glyph, and the `active` / `expired` / `scanned` status overlays.

The component is display-only: it encodes text into a QR matrix and paints it, but does not scan, decode, or export images. Encoding runs on a pure-Dart engine absorbed from `package:qr` 3.0.3 (BSD-3-Clause); painting happens in `CustomPaint`, so there is no third-party rendering dependency, no platform channel, and no network access.

## Positioning & design

| Aspect | Decision |
| --- | --- |
| Direction | Encode text → QR matrix → painted modules. No decoding, no scanning, no image export |
| Engine | `package:qr` 3.0.3 source absorbed into `lib/src/engines/qr/`, exposed only through `AntQrMatrix` |
| Rendering | `CustomPaint` with `AntQrPainter`; every dark module is a square, including finder and alignment patterns |
| Sizing | Outer box is `size`, the code area is `size` minus 12 px padding on each side, all scaled by the theme factor |
| Status | QR stays painted underneath a 92%-opaque overlay for `expired` and `scanned` |
| Localization | Overlay labels are fixed Chinese strings; the API is not localized |

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_qrcode: ^1.0.0
```

Inside this monorepo:

```yaml
dependencies:
  antd_qrcode:
    path: ../packages/antd_qrcode
```

## Quick start

```dart
import 'package:antd_qrcode/antd_qrcode.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const QrApp());

class QrApp extends StatelessWidget {
  const QrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: AntQRCode(
              value: 'https://github.com/flutter-open/antd-flutter',
              size: 200,
              errorLevel: AntQRCodeErrorLevel.h,
              bordered: true,
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/docs/api-index.md)

Increase redundancy and add a center glyph:

```dart
AntQRCode(
  value: 'https://example.com/ticket/001',
  size: 220,
  errorLevel: AntQRCodeErrorLevel.h,
  icon: true,
  iconSize: 44,
)
```

Use a custom foreground and background palette:

```dart
AntQRCode(
  value: 'WIFI:S:AntdDemo;T:WPA;P:password;;',
  color: const Color(0xFF0B3D91),
  bgColor: const Color(0xFFF7F9FC),
  bordered: false,
)
```

Show the expired overlay and refresh the payload when it is tapped:

```dart
AntQRCode(
  value: 'ticket-001',
  status: AntQRCodeStatus.expired,
  onRefresh: () => debugPrint('request a new token'),
)
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/qr_code/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
antd_qrcode/
├── lib/
│   ├── antd_qrcode.dart                    # Public barrel
│   └── src/
│       ├── qr_code/
│       │   ├── ant_qr_code.dart            # AntQRCode + AntQrPainter
│       │   └── ant_qr_code_types.dart      # Error level + status enums
│       └── engines/qr/                     # Absorbed pure-Dart QR engine
│           ├── ant_qr_engine.dart          # Middleware: AntQrMatrix
│           ├── qr_code.dart
│           ├── qr_image.dart
│           └── error_correct_level.dart
├── example/lib/main.dart                   # Demo gallery
├── test/
│   ├── ant_qr_code_test.dart
│   └── qr_engine_baseline_test.dart
├── docs/api-index.md
├── LICENSE-THIRD-PARTY.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE). The absorbed QR engine is BSD-3-Clause; see [LICENSE-THIRD-PARTY.md](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/LICENSE-THIRD-PARTY.md).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
