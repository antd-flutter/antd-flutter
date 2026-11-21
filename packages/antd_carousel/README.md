# antd_carousel - Ant Design carousel built on PageView

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/README_CN.md)

## Positioning & design

`antd_carousel` brings the Ant Design Carousel to Flutter: a fixed-height page switcher with autoplay, infinite loop, dots in four positions, arrows, vertical mode, a controlled or uncontrolled index, and a controller for programmatic jumps. Its API follows the antd React Carousel, so concepts map one-to-one.

- **Built on `PageView`.** The package is a layout and state wrapper around `PageView` / `PageView.builder`, not a custom render object.
- **Loop without cloning.** Infinite loop uses `PageView.builder` with a large page offset and index modulo mapping, so continuous swiping in either direction never bounces at the ends and pages are not duplicated.
- **Pages stay plain widgets.** The carousel never wraps pages in its own transforms; custom transitions and parallax effects belong in your page widgets.
- **Fixed-height overlay.** Pages fill the box while dots and arrows are positioned on top in a `Stack`, so the widget always needs a bounded height — pass `height` or place it in a fixed-height parent.
- **One implementation for every platform.** Mobile, desktop and web share the same code; only `pauseOnHover` and arrow opacity are pointer-aware.
- **Theme-aware.** Colors and sizing come from the nearest `AntThemeData`, falling back to the light theme when no `AntTheme` is present.

## Installation

Requires Dart `>=3.0.0 <4.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_carousel: ^1.0.0
```

## Quick start

The following application is complete and runnable:

```dart
import 'package:antd_carousel/antd_carousel.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const CarouselApp());

class CarouselApp extends StatelessWidget {
  const CarouselApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 480,
              height: 200,
              child: AntCarousel(
                autoplay: true,
                loop: true,
                children: const [
                  ColoredBox(
                    color: Color(0xFF1677FF),
                    child: Center(child: Text('1')),
                  ),
                  ColoredBox(
                    color: Color(0xFF52C41A),
                    child: Center(child: Text('2')),
                  ),
                  ColoredBox(
                    color: Color(0xFFFAAD14),
                    child: Center(child: Text('3')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/docs/api-index.md)

Import `package:antd_carousel/antd_carousel.dart` for `AntCarousel`, `AntCarouselController` and `AntCarouselDotPosition`.

### Pages and a fixed height

`children` and `items` are interchangeable; exactly one is required.

```dart
final pages = <Widget>[
  const ColoredBox(color: Color(0xFF1677FF)),
  const ColoredBox(color: Color(0xFF52C41A)),
  const ColoredBox(color: Color(0xFFFAAD14)),
];

AntCarousel(
  height: 200,
  children: pages,
);
```

### Autoplay, loop and arrows

```dart
AntCarousel(
  autoplay: true,
  autoplayInterval: const Duration(seconds: 3),
  loop: true,
  arrows: true,
  height: 220,
  children: pages,
);
```

### Controller and page changes

```dart
final controller = AntCarouselController();

AntCarousel(
  controller: controller,
  onChange: (index) {},
  height: 200,
  children: pages,
);

// From a button or a keyboard shortcut:
controller.goTo(2);
controller.goTo(0, animate: false);
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/carousel/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_carousel/
├── lib/
│   ├── antd_carousel.dart               # Public barrel
│   └── src/carousel/
│       ├── ant_carousel.dart            # PageView-based carousel widget
│       └── ant_carousel_types.dart      # Dot position enum and controller
├── example/lib/main.dart                # Demo gallery
├── docs/api-index.md                    # Generated API index
├── test/carousel/ant_carousel_test.dart # Widget tests
├── CHANGELOG.md
├── README.md
├── README_CN.md
└── pubspec.yaml
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
