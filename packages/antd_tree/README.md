# antd_tree - Generic tree and tree select for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/README_CN.md)

## Positioning & design

`antd_tree` provides two Ant Design tree controls over **your own model `T`**: `AntTree<T>` for hierarchical display with expansion, selection, and optional checkboxes, and `AntTreeSelect<T>` for choosing one or more keys from the same hierarchy in a dropdown. The hierarchy is described entirely by callbacks — `keyOf`, `titleBuilder`, `childrenOf`, `disabledOf`, `checkableOf`, and `labelOf` on the select.

Design rules:

- **Your model is the tree.** There is no required node wrapper; children come from `childrenOf`.
- **Keys carry state.** Expansion, selection, and checked sets contain the values returned by `keyOf`.
- **Controlled and uncontrolled variants coexist.** `expandedKeys` / `selectedKeys` / `checkedKeys` / `value` are controlled when non-null; the matching `default*` props seed uncontrolled state.
- **Checking follows tree semantics by default.** A parent check cascades down, a partly checked parent reports an indeterminate state, and `checkStrictly` opts out of cascading.
- **Layout, not scrolling.** `AntTree` renders a column and does not scroll; wrap it in a scroll view when the hierarchy can exceed the viewport. `AntTreeSelect` manages its own dropdown scrolling.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_tree: ^1.0.0
```

Wrap the subtree in `AntTheme`; row height, indentation, colors, and dropdown chrome come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:material_ui/material_ui.dart';

class Region {
  const Region(
    this.id,
    this.name, {
    this.children = const <Region>[],
  });

  final int id;
  final String name;
  final List<Region> children;
}

const regions = <Region>[
  Region(
    1,
    'Zhejiang',
    children: [
      Region(2, 'Hangzhou'),
      Region(3, 'Ningbo'),
    ],
  ),
  Region(
    4,
    'Jiangsu',
    children: [
      Region(5, 'Nanjing'),
      Region(6, 'Suzhou'),
    ],
  ),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 280,
                child: SingleChildScrollView(
                  child: AntTree<Region>(
                    dataSource: regions,
                    keyOf: (region) => region.id,
                    titleBuilder: (context, region) => Text(region.name),
                    childrenOf: (region) => region.children,
                    defaultExpandAll: true,
                    checkable: true,
                    onCheck: (checked, halfChecked) {
                      debugPrint('checked=$checked half=$halfChecked');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

The example renders an expandable, checkable region tree with every branch open. Checking `Zhejiang` selects both cities; checking only `Hangzhou` puts the parent into the half-checked state.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/docs/api-index.md)

### 1. Controlled expansion and selection

```dart
class ControlledTree extends StatefulWidget {
  const ControlledTree({super.key});

  @override
  State<ControlledTree> createState() => _ControlledTreeState();
}

class _ControlledTreeState extends State<ControlledTree> {
  Set<Object> _expanded = <Object>{1};
  Set<Object> _selected = <Object>{2};

  @override
  Widget build(BuildContext context) {
    return AntTree<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      titleBuilder: (context, region) => Text(region.name),
      childrenOf: (region) => region.children,
      expandedKeys: _expanded,
      onExpand: (keys) => setState(() => _expanded = keys),
      selectedKeys: _selected,
      onSelect: (keys) => setState(() => _selected = keys),
    );
  }
}
```

The caller owns `expandedKeys` and `selectedKeys`. Returning the callback's set keeps the tree and your state in sync.

### 2. Per-node rules and strict checking

```dart
AntTree<Region>(
  dataSource: regions,
  keyOf: (region) => region.id,
  titleBuilder: (context, region) => Text(region.name),
  childrenOf: (region) => region.children,
  checkable: true,
  checkStrictly: true,
  showLine: true,
  checkableOf: (region) => region.children.isEmpty,
  disabledOf: (region) => region.id == 3,
  onCheck: (checked, halfChecked) {
    debugPrint('checked=$checked half=$halfChecked');
  },
)
```

`showLine` draws hierarchy guides, while only leaves show a checkbox. `Ningbo` is disabled for selection and checking. With `checkStrictly: true` the parent is no longer derived from its descendants, so `checked` contains only the directly toggled node.

### 3. Single and multiple tree select

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    AntTreeSelect<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      labelOf: (region) => region.name,
      childrenOf: (region) => region.children,
      treeDefaultExpandAll: true,
      placeholder: 'Select a region',
      allowClear: true,
      onChange: (value) => debugPrint('selected $value'),
    ),
    const SizedBox(height: 12),
    AntTreeSelect<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      labelOf: (region) => region.name,
      childrenOf: (region) => region.children,
      multiple: true,
      defaultValue: const <Object>[2, 5],
      onChange: (value) => debugPrint('selected $value'),
    ),
  ],
)
```

In multiple mode the trigger shows chips and `onChange` emits a `List<Object>`. In single mode it emits one key, or `null` after clearing.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/tree/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_tree/
├── lib/
│   ├── antd_tree.dart                     # barrel export
│   └── src/
│       ├── tree/
│       │   ├── ant_tree.dart              # expand / select / check rendering
│       │   └── ant_tree_types.dart        # callbacks and typedefs
│       └── tree_select/
│           ├── ant_tree_select.dart       # trigger and dropdown
│           └── ant_tree_select_types.dart # size enum and callbacks
├── example/lib/main.dart                  # runnable gallery
├── docs/api-index.md                      # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
