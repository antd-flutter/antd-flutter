# antd_splitter - Resizable split panes for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/README_CN.md)

`antd_splitter` brings the Ant Design Splitter pattern to Flutter. It arranges two or more panes along a horizontal or vertical axis and lets the user drag the dividers to resize them. Panels can declare an initial size, a controlled size, minimum and maximum constraints, and whether they can be collapsed.

The widget is intentionally a **layout** component, not a scrolling one: it re-lays out its children as the divider moves. For this reason there is no sliver variant, and the splitter must receive a bounded size on its main axis.

## Positioning & design

- **Panels are configuration objects.** `children` only accepts `AntSplitterPanel`; each panel holds its constraints and one child.
- **Sizes are logical pixels.** Render sizes are multiplied by the active `AntTheme` scale, so the same layout adapts to density.
- **State is owned by the caller when controlled.** A non-null `AntSplitterPanel.size` is authoritative; the caller must update it from `onResize` for dragging to stick.
- **The callback is the source of truth.** Resize and collapse callbacks report the full vector of panel sizes, not a delta.
- **One small dependency surface.** The package depends on `antd_theme`, `antd_icons_flutter`, and `material_ui`; it does not depend on the main `antd_flutter_plus` barrel.

## Installation

Requires Flutter 3.10+ and Dart 3.0+.

```yaml
dependencies:
  antd_splitter: ^1.0.0
```

Wrap the subtree in `AntTheme` so panel chrome, divider colors, and scale come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_splitter/antd_splitter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 240,
                child: AntSplitter(
                  children: [
                    AntSplitterPanel(
                      defaultSize: 180,
                      min: 120,
                      child: const ColoredBox(
                        color: Color(0xFFE6F4FF),
                        child: Center(child: Text('Sidebar')),
                      ),
                    ),
                    AntSplitterPanel(
                      child: const ColoredBox(
                        color: Color(0xFFF6FFED),
                        child: Center(child: Text('Content')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

Panels without `defaultSize` share the remaining space equally. In the example the sidebar claims 180 logical pixels and the content pane takes the rest.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/docs/api-index.md)

Add size constraints and a collapse control:

```dart
AntSplitter(
  onCollapse: (collapsed, sizes) {
    debugPrint('collapsed=$collapsed sizes=$sizes');
  },
  children: [
    AntSplitterPanel(
      defaultSize: 220,
      min: 160,
      max: 360,
      collapsible: true,
      child: const Center(child: Text('Inspector')),
    ),
    AntSplitterPanel(
      min: 320,
      child: const Center(child: Text('Canvas')),
    ),
    AntSplitterPanel(
      defaultSize: 180,
      resizable: false,
      child: const Center(child: Text('Pinned')),
    ),
  ],
)
```

Nest a horizontal splitter inside a vertical one:

```dart
SizedBox(
  height: 320,
  child: AntSplitter(
    layout: AntSplitterLayout.vertical,
    children: [
      AntSplitterPanel(
        defaultSize: 96,
        child: const Center(child: Text('Toolbar')),
      ),
      AntSplitterPanel(
        child: AntSplitter(
          children: [
            AntSplitterPanel(
              defaultSize: 200,
              min: 160,
              child: const Center(child: Text('Navigator')),
            ),
            AntSplitterPanel(
              child: const Center(child: Text('Editor')),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

Commit sizes only when the drag ends and write them back from `onResize`:

```dart
AntSplitter(
  lazy: true,
  onResize: (sizes) => setState(() => _sidebarSize = sizes.first),
  children: [
    AntSplitterPanel(
      size: _sidebarSize,
      min: 160,
      max: 400,
      child: const Center(child: Text('Controlled sidebar')),
    ),
    AntSplitterPanel(
      child: const Center(child: Text('Content')),
    ),
  ],
)
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/splitter/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_splitter/
├── lib/
│   ├── antd_splitter.dart                  # barrel export
│   └── src/splitter/
│       ├── ant_splitter.dart               # splitter, panel, drag/collapse engine
│       └── ant_splitter_types.dart         # layout enum and collapse callback
├── test/
│   ├── ant_splitter_test.dart              # behavior and edge cases
│   └── ant_splitter_matrix_test.dart       # layout matrix and hit-target geometry
├── example/lib/main.dart                   # interactive gallery entry
└── docs/api-index.md                       # per-symbol API index
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
