# antd_masonry - Greedy-column masonry layout and sliver variant

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/README_CN.md)

`antd_masonry` lays out widgets of different heights in balanced columns, following the antd React Masonry API. Items placed with `AntMasonryItem` declare a height and a column span; the layout engine puts each item into the currently shortest column, and a sliver variant composes with `CustomScrollView`.

The package is a pure layout container. It holds no scroll state and no controller: scrolling belongs to whatever scroll view hosts it, and changing the content means rebuilding with a different `children` list.

## Positioning & design

| Aspect | Decision |
| --- | --- |
| Model | Stateless layout container driven entirely by its `children` list |
| Height source | `AntMasonryItem.height`; it is both the placement input and the rendered box height |
| Placement | Greedy shortest column when any item declares a height; round-robin when none does |
| Span | `AntMasonryItem.span` columns wide; a full-width item takes the tallest column as its baseline |
| Responsive | `AntMasonryResponsive` resolves the column count from the container width using antd grid breakpoints |
| Sliver | `AntSliverMasonry` wraps the same engine in a `SliverToBoxAdapter`; non-lazy by design |
| Spacing | `gutter` / `verticalGutter` scale with the theme's `s()` factor; item heights are exact logical pixels |

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_masonry: ^1.0.0
```

Inside this monorepo:

```yaml
dependencies:
  antd_masonry:
    path: ../packages/antd_masonry
```

## Quick start

```dart
import 'package:antd_masonry/antd_masonry.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MasonryApp());

class MasonryApp extends StatelessWidget {
  const MasonryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AntMasonry(
              columns: 3,
              gutter: 12,
              children: const [
                AntMasonryItem(
                  height: 120,
                  child: ColoredBox(color: Color(0xFF1677FF)),
                ),
                AntMasonryItem(
                  height: 180,
                  child: ColoredBox(color: Color(0xFF52C41A)),
                ),
                AntMasonryItem(
                  height: 90,
                  child: ColoredBox(color: Color(0xFFFAAD14)),
                ),
                AntMasonryItem(
                  height: 220,
                  child: ColoredBox(color: Color(0xFFFF4D4F)),
                ),
                AntMasonryItem(
                  height: 140,
                  child: ColoredBox(color: Color(0xFF722ED1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/docs/api-index.md)

Resolve the column count from the container width:

```dart
AntMasonry(
  responsiveColumns: const AntMasonryResponsive(xs: 1, sm: 2, lg: 3, xl: 4),
  gutter: 16,
  children: const [
    AntMasonryItem(height: 120, child: Card(child: Text('A'))),
    AntMasonryItem(height: 180, child: Card(child: Text('B'))),
  ],
)
```

Let an item span multiple columns, including a full-width row:

```dart
AntMasonry(
  columns: 3,
  gutter: 16,
  children: const [
    AntMasonryItem(height: 120, child: Card(child: Text('A'))),
    AntMasonryItem(height: 160, span: 2, child: Card(child: Text('Wide'))),
    AntMasonryItem(height: 100, span: 3, child: Card(child: Text('Full row'))),
  ],
)
```

Compose the sliver variant with a `CustomScrollView`:

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(title: Text('Masonry')),
    AntSliverMasonry(
      columns: 3,
      gutter: 16,
      fallbackItemHeight: 120,
      children: const [
        AntMasonryItem(height: 100, child: Card(child: Text('A'))),
        AntMasonryItem(height: 160, span: 2, child: Card(child: Text('B'))),
      ],
    ),
  ],
)
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/masonry/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
antd_masonry/
├── lib/
│   ├── antd_masonry.dart                  # Public barrel
│   └── src/masonry/
│       ├── ant_masonry.dart               # Masonry widget + AntMasonryItem
│       ├── ant_masonry_layout.dart        # Shared placement engine
│       ├── ant_masonry_types.dart         # AntMasonryResponsive
│       └── ant_sliver_masonry.dart        # Sliver variant
├── example/lib/main.dart                  # Demo gallery
├── test/
│   ├── masonry/ant_masonry_test.dart
│   └── masonry/ant_sliver_masonry_test.dart
├── docs/api-index.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
