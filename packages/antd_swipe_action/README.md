# antd_swipe_action - Swipe-to-reveal actions for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/README_CN.md)

`antd_swipe_action` implements the Ant Design Mobile SwipeAction interaction for Flutter lists and rows. Swiping a row horizontally reveals a set of actions on the opposite side; the content follows the finger, resists past its action width, and snaps open or closed on release. It is designed for touch-first surfaces such as message lists, cart rows, and inbox items.

## Positioning & design

- **One row, two action groups.** `rightActions` are revealed by swiping left, while `leftActions` are revealed by swiping right.
- **The gesture is horizontal-only.** A horizontal drag recognizer handles the row, so a vertical `ListView`/`CustomScrollView` keeps scrolling normally.
- **The row follows the finger.** Movement is 1:1 up to the total action width, then rubber-bands; release snaps to an open or closed position.
- **Actions are declarative.** Buttons are `AntSwipeActionItem` values with text, color, callback, and disabled state; there is no imperative controller.
- **The package is self-contained.** It depends on `antd_theme` and `material_ui` only.

## Installation

Requires Flutter 3.10+ and Dart 3.0+.

```yaml
dependencies:
  antd_swipe_action: ^1.0.0
```

Wrap the app subtree in `AntTheme`; the default action color and the row background come from the active theme:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_swipe_action/antd_swipe_action.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Inbox')),
            body: ListView(
              children: [
                AntSwipeAction(
                  rightActions: [
                    AntSwipeActionItem(
                      text: 'Archive',
                      onPressed: () => debugPrint('archive'),
                    ),
                  ],
                  child: const ListTile(
                    title: Text('Quarterly report'),
                    subtitle: Text('Swipe left to archive'),
                  ),
                ),
                AntSwipeAction(
                  rightActions: [
                    AntSwipeActionItem(
                      text: 'Delete',
                      color: Colors.red,
                      onPressed: () => debugPrint('delete'),
                    ),
                  ],
                  child: const ListTile(
                    title: Text('Old invoice'),
                    subtitle: Text('Swipe left to delete'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
```

Swiping a row to the left reveals the `Archive`/`Delete` buttons. Tapping a button runs its callback and closes the row because `closeOnAction` defaults to `true`.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/docs/api-index.md)

Reveal actions on both sides of a row:

```dart
AntSwipeAction(
  leftActions: [
    AntSwipeActionItem(
      text: 'Pin',
      color: Colors.blueGrey,
      onPressed: () => debugPrint('pin'),
    ),
  ],
  rightActions: [
    AntSwipeActionItem(
      text: 'Share',
      color: Colors.blue,
      onPressed: () => debugPrint('share'),
    ),
    AntSwipeActionItem(
      text: 'Delete',
      color: Colors.red,
      onPressed: () => debugPrint('delete'),
    ),
  ],
  child: const ListTile(title: Text('Swipe either way')),
)
```

Keep the row open after an action and observe its lifecycle:

```dart
AntSwipeAction(
  closeOnAction: false,
  onOpened: (side) => debugPrint('opened on $side'),
  onClosed: () => debugPrint('closed'),
  rightActions: [
    AntSwipeActionItem(
      text: 'Select',
      onPressed: () => debugPrint('selected'),
    ),
  ],
  child: const ListTile(title: Text('Stays open after selection')),
)
```

Build rows from a list with disabled and colored actions:

```dart
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) {
    final message = messages[index];
    return AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: 'Edit',
          onPressed: () => edit(message),
        ),
        AntSwipeActionItem(text: 'Locked', disabled: true),
        AntSwipeActionItem(
          text: 'Remove',
          color: Theme.of(context).colorScheme.error,
          onPressed: () => remove(message),
        ),
      ],
      child: ListTile(title: Text(message.title)),
    );
  },
)
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/swipe_action/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_swipe_action/
├── lib/
│   ├── antd_swipe_action.dart                  # barrel export
│   └── src/swipe_action/
│       ├── ant_swipe_action.dart               # gesture, snap animation, action layer
│       └── ant_swipe_action_types.dart         # item model and constants
├── test/
│   └── ant_swipe_action_test.dart              # behavior, geometry, and snap logic
├── example/lib/main.dart                       # interactive gallery entry
└── docs/api-index.md                           # per-symbol API index
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
