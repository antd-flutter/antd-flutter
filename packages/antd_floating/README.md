# antd_floating - Draggable floating panel and floating bubble

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/README_CN.md)

## Positioning & design

`antd_floating` implements two antd-mobile v5 components for Flutter: `AntFloatingPanel`, a bottom sheet that snaps between anchor heights, and `AntFloatingBubble`, a draggable action button that can open a menu. Both are gesture-driven and self-contained.

- **Two independent widgets.** Each mirrors its antd-mobile counterpart and can be used on its own.
- **Panel geometry.** Anchors are ascending ratios (0–1) of a base height — the parent's height, or `contentHeight` when set. The panel starts at the lowest anchor.
- **Panel motion.** Height follows the drag directly; on release it animates to the nearest anchor in 250 ms.
- **Bubble geometry.** Position is relative to the parent's top-left and scaled by the active theme factor, so the bubble keeps its proportions across density settings.
- **Bubble hit area.** The bubble renders a full-size transparent layer and uses `IgnorePointer` outside itself and its menu. Place it in a `Stack` or `Overlay` above the content it floats over.
- **State access.** Both components expose a `ChangeNotifier` controller; calls on a detached controller are safe no-ops.
- **Content scrolls itself.** The panel adds no scroll behavior and is bottom-aligned; put a `ListView` / `CustomScrollView` inside it.

## Installation

Requires Dart `>=3.0.0 <4.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_floating: ^1.0.0
```

## Quick start

The following application is complete and runnable:

```dart
import 'package:antd_floating/antd_floating.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const FloatingApp());

class FloatingApp extends StatelessWidget {
  const FloatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: Color(0xFFF5F5F5))),
              Align(
                alignment: Alignment.bottomCenter,
                child: AntFloatingPanel(
                  onHeightChange: (ratio) => debugPrint('panel: $ratio'),
                  child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
                  ),
                ),
              ),
              AntFloatingBubble(
                initialPos: const Offset(24, 120),
                onClick: () => debugPrint('bubble tapped'),
                child: const Icon(Icons.edit_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/docs/api-index.md)

Import `package:antd_floating/antd_floating.dart` for the two widgets, their controllers and their option types.

### Panel with custom anchors

```dart
AntFloatingPanel(
  anchors: const [0.3, 0.6, 1.0],
  onHeightChange: (ratio) => debugPrint('$ratio'),
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
  ),
);
```

### Programmatic panel control

```dart
final panel = AntFloatingPanelController();

AntFloatingPanel(
  controller: panel,
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
  ),
);

// From a button or a keyboard shortcut:
panel.expand();
panel.snapToAnchorAt(1);
panel.collapse();
panel.resetToInitial();
```

### Bubble with a menu

```dart
AntFloatingBubble(
  initialPos: const Offset(24, 120),
  autoSnapToEdge: true,
  menu: [
    AntFloatingBubbleMenuAction(
      label: 'Edit',
      icon: const Icon(Icons.edit_outlined),
      onClick: () {},
    ),
    AntFloatingBubbleMenuAction(
      label: 'Share',
      icon: const Icon(Icons.share_outlined),
      onClick: () {},
    ),
  ],
  child: const Icon(Icons.add, color: Colors.white),
);
```

## Project structure

```text
packages/antd_floating/
├── lib/
│   ├── antd_floating.dart                     # Public barrel
│   └── src/
│       ├── floating_panel/
│       │   ├── ant_floating_panel.dart        # Panel widget
│       │   ├── ant_floating_panel_types.dart  # Height-change typedef
│       │   └── ant_floating_panel_controller.dart
│       └── floating_bubble/
│           ├── ant_floating_bubble.dart       # Bubble widget
│           ├── ant_floating_bubble_types.dart # Axis, edge and menu action
│           └── ant_floating_bubble_controller.dart
├── example/lib/main.dart                      # Demo gallery
├── docs/api-index.md                          # Generated API index
├── test/
│   ├── floating_panel/ant_floating_panel_test.dart
│   └── floating_bubble/ant_floating_bubble_test.dart
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
