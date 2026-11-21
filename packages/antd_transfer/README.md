# antd_transfer - Generic transfer and tree transfer for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/README_CN.md)

## Positioning & design

`antd_transfer` implements the Ant Design Transfer interaction over **your own model `T`**. It renders a source pane and a target pane with checkbox selection, move and return operations, optional search, and one-way mode. When an item exposes children through `childrenOf`, the same widget becomes a tree transfer with parent/child check cascading, an indeterminate half-checked state, and subtree moves.

The data layer is deliberately thin. There is no wrapper item class and no `Map` row: the widget reads your objects through small callbacks (`keyOf`, `titleBuilder`, `descriptionOf`, `childrenOf`, `disabledOf`, `searchTextOf`), and every callback and controlled prop speaks in keys rather than object instances.

Design rules:

- **Keys carry state.** `targetKeys`, `selectedKeys`, and every move callback use the values returned by `keyOf`.
- **The widget never mutates your data.** `targetKeys` and `selectedKeys` are controlled when non-null; the matching `default*` props seed uncontrolled usage.
- **Tree mode is inferred.** A node whose `childrenOf` returns a non-empty list becomes a branch; there is no separate tree widget or mode switch.
- **Rendering is self-contained.** Pane chrome, borders, and metrics come from `AntTheme`; the package depends on `antd_theme`, `antd_icons_flutter`, and `antd_flutter_ui` for the shared checkbox primitive.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_transfer: ^1.0.0
```

Wrap the app (or the subtree that uses the widget) in `AntTheme` so the panes pick up colors, borders, and scaling:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_transfer/antd_transfer.dart';
import 'package:material_ui/material_ui.dart';

class FileItem {
  const FileItem(
    this.id,
    this.name, {
    this.description,
    this.disabled = false,
    this.children = const <FileItem>[],
  });

  final int id;
  final String name;
  final String? description;
  final bool disabled;
  final List<FileItem> children;
}

const source = <FileItem>[
  FileItem(1, 'Design.fig', description: 'Figma'),
  FileItem(2, 'Spec.md', description: 'Markdown'),
  FileItem(3, 'Budget.xlsx', description: 'Spreadsheet', disabled: true),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 320,
                child: AntTransfer<FileItem>(
                  dataSource: source,
                  keyOf: (item) => item.id,
                  titleBuilder: (context, item) => Text(item.name),
                  descriptionOf: (item) => item.description,
                  defaultTargetKeys: const <Object>[2],
                  onChange: (targetKeys, direction, moveKeys) {
                    debugPrint('$direction moved $moveKeys -> $targetKeys');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

The widget shows two panes with a transfer button. `Spec.md` starts on the target side, and the disabled `Budget.xlsx` row can neither be selected nor moved.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/docs/api-index.md)

### 1. Controlled target keys and selection

```dart
class ControlledTransfer extends StatefulWidget {
  const ControlledTransfer({super.key});

  @override
  State<ControlledTransfer> createState() => _ControlledTransferState();
}

class _ControlledTransferState extends State<ControlledTransfer> {
  List<Object> _targetKeys = <Object>[2];
  List<Object> _selectedKeys = <Object>[];

  @override
  Widget build(BuildContext context) {
    return AntTransfer<FileItem>(
      dataSource: source,
      keyOf: (item) => item.id,
      titleBuilder: (context, item) => Text(item.name),
      targetKeys: _targetKeys,
      selectedKeys: _selectedKeys,
      onChange: (targetKeys, direction, moveKeys) {
        setState(() => _targetKeys = targetKeys);
      },
      onSelectChange: (sourceSelected, targetSelected) {
        setState(() {
          _selectedKeys = <Object>[...sourceSelected, ...targetSelected];
        });
      },
    );
  }
}
```

Once `targetKeys` is supplied the owner must write the next list back in `onChange`; otherwise the panes keep rendering the previous ownership.

### 2. Tree transfer from a custom model

```dart
const tree = <FileItem>[
  FileItem(
    10,
    'Design',
    children: [
      FileItem(11, 'UI.fig'),
      FileItem(12, 'Icons.svg'),
    ],
  ),
  FileItem(
    20,
    'Engineering',
    children: [
      FileItem(21, 'API.md'),
      FileItem(22, 'Schema.sql', disabled: true),
    ],
  ),
];

AntTransfer<FileItem>(
  dataSource: tree,
  keyOf: (item) => item.id,
  titleBuilder: (context, item) => Text(item.name),
  childrenOf: (item) => item.children,
  disabledOf: (item) => item.disabled,
  defaultExpandAll: true,
  defaultTargetKeys: const <Object>[11, 21],
  onChange: (targetKeys, direction, moveKeys) {
    debugPrint('tree move $direction: $moveKeys');
  },
)
```

Checking `Design` checks both of its children. A partly checked branch reports the indeterminate state. Moving a branch moves its whole subtree, while the disabled `Schema.sql` is excluded from selection and moves.

### 3. Search and one-way mode

```dart
AntTransfer<FileItem>(
  dataSource: source,
  keyOf: (item) => item.id,
  titleBuilder: (context, item) => Text(item.name),
  descriptionOf: (item) => item.description,
  titles: const ['Available files', 'Attached'],
  operations: const ['Attach', ''],
  showSearch: true,
  oneWay: true,
  filterOption: (input, item) =>
      item.name.toLowerCase().contains(input.toLowerCase()),
  onChange: (targetKeys, direction, moveKeys) {
    debugPrint('attached $moveKeys');
  },
)
```

`oneWay: true` hides the return operation so items can only move to the target pane. An empty string in `operations` keeps the icon-only button for that direction.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/transfer/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_transfer/
├── lib/
│   ├── antd_transfer.dart              # barrel export
│   └── src/transfer/
│       ├── ant_transfer.dart           # panes, selection, moves, tree logic
│       └── ant_transfer_types.dart     # direction enum and callback typedefs
├── example/lib/main.dart               # runnable gallery
├── docs/api-index.md                   # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
