# antd_table - Generic Ant Design table for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/README_CN.md)

## Positioning & design

`antd_table` renders a typed data table over **your row model `T`**. `AntTable<T>` owns the header, body, sorting, filtering, pagination, row selection, expandable rows, tree rows, and summary rows; `AntTableColumn<T>` describes each leaf column or header group. Nothing is wrapped in maps or synthetic row records — a column's `cell` callback receives your object directly, plus its index among siblings.

Design rules:

- **Columns are structure, cells are content.** `title` and optional `width` / `align` / `fixed` shape the grid; `cell` decides what each cell shows.
- **Grouping is recursive.** A column with non-empty `children` becomes a header group; leaf columns are the only ones that render data.
- **Tree rows are inferred.** A non-null `childrenOf` result turns a row into a parent; expansion, indentation, and selection cascading follow from it.
- **Layout is explicit.** Without `scrollX` / `scrollY` the table fits its parent; supplying them enables horizontal scrolling with pinned columns and vertical virtualized scrolling.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_table: ^1.0.0
```

Wrap the subtree in `AntTheme`; row height, borders, header background, and density come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_table/antd_table.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.tag,
  });

  final int id;
  final String name;
  final int age;
  final String tag;
}

const users = <User>[
  User(id: 1, name: 'Alice', age: 32, tag: 'Admin'),
  User(id: 2, name: 'Bob', age: 27, tag: 'Editor'),
  User(id: 3, name: 'Carol', age: 41, tag: 'Viewer'),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AntTable<User>(
                rowKey: (user) => user.id,
                bordered: true,
                columns: [
                  AntTableColumn<User>(
                    title: 'Name',
                    cell: (context, user, index) => Text(user.name),
                  ),
                  AntTableColumn<User>(
                    title: 'Age',
                    width: 100,
                    align: AntTableAlign.right,
                    cell: (context, user, index) => Text('${user.age}'),
                  ),
                  AntTableColumn<User>(
                    title: 'Role',
                    cell: (context, user, index) => Text(user.tag),
                  ),
                ],
                dataSource: users,
              ),
            ),
          ),
        ),
      ),
    );
```

`rowKey` gives each row a stable identity for selection and expansion; keeping it explicit avoids state drifting when the data order changes.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/docs/api-index.md)

### 1. Sorting and filtering a column

```dart
AntTable<User>(
  rowKey: (user) => user.id,
  columns: [
    AntTableColumn<User>(
      title: 'Name',
      sorter: (a, b) => a.name.compareTo(b.name),
      filters: const [
        AntTableFilterItem(text: 'Admin', value: 'Admin'),
        AntTableFilterItem(text: 'Editor', value: 'Editor'),
      ],
      onFilter: (value, user) => user.tag == value,
      cell: (context, user, index) => Text(user.name),
    ),
    AntTableColumn<User>(
      title: 'Age',
      width: 100,
      sorter: (a, b) => a.age.compareTo(b.age),
      defaultSortOrder: AntTableSortOrder.ascend,
      cell: (context, user, index) => Text('${user.age}'),
    ),
  ],
  dataSource: users,
  onSortChange: (leafIndex, order) => debugPrint('sort $leafIndex -> $order'),
  onFilterChange: (leafIndex, values) => debugPrint('filter $leafIndex -> $values'),
)
```

The first column header offers both a sort toggle and a filter menu; the second starts ascending. Sorting and filtering are applied to the rows before they reach `dataSource` rebuilds, and the change callbacks receive the leaf column index.

### 2. Row selection and expandable rows

```dart
class SelectableTable extends StatefulWidget {
  const SelectableTable({super.key});

  @override
  State<SelectableTable> createState() => _SelectableTableState();
}

class _SelectableTableState extends State<SelectableTable> {
  Set<Object> _selected = <Object>{1};

  @override
  Widget build(BuildContext context) {
    return AntTable<User>(
      rowKey: (user) => user.id,
      rowSelection: AntTableRowSelection<User>(
        selectedRowKeys: _selected,
        onChange: (keys) => setState(() => _selected = keys),
      ),
      expandedRowRender: (context, user, index) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text('${user.name} is ${user.age} years old'),
      ),
      columns: [
        AntTableColumn<User>(
          title: 'Name',
          cell: (context, user, index) => Text(user.name),
        ),
        AntTableColumn<User>(
          title: 'Role',
          cell: (context, user, index) => Text(user.tag),
        ),
      ],
      dataSource: users,
    );
  }
}
```

`selectedRowKeys` makes selection controlled, so `onChange` must write the set back. The expand chevron appears automatically once `expandedRowRender` is supplied.

### 3. Tree rows, grouped headers, and a summary row

```dart
class Team {
  const Team(this.id, this.name, this.members);

  final int id;
  final String name;
  final List<User> members;
}

final teams = <Team>[
  Team(10, 'Platform', const [User(id: 1, name: 'Alice', age: 32, tag: 'Admin')]),
  Team(20, 'Design', const [User(id: 2, name: 'Bob', age: 27, tag: 'Editor')]),
];

AntTable<Team>(
  rowKey: (team) => team.id,
  childrenOf: (team) => team.members.isEmpty ? null : team.members,
  defaultExpandAllRows: true,
  columns: [
    AntTableColumn<Team>(
      title: 'Team',
      cell: (context, team, index) => Text(team.name),
    ),
    AntTableColumn<Team>(
      title: 'Members',
      children: [
        AntTableColumn<Team>(
          title: 'Name',
          cell: (context, team, index) => Text('${team.members.length} people'),
        ),
        AntTableColumn<Team>(
          title: 'Avg age',
          cell: (context, team, index) => Text(
            team.members.isEmpty
                ? '-'
                : (team.members.map((m) => m.age).reduce((a, b) => a + b) /
                        team.members.length)
                    .toStringAsFixed(1),
          ),
        ),
      ],
    ),
  ],
  dataSource: teams,
  summary: (data) => [
    AntTableSummaryCell(
      columnIndex: 0,
      colSpan: 3,
      child: Text('${data.length} teams'),
    ),
  ],
)
```

Rows whose `childrenOf` returns a non-empty list become collapsible parents. The `Members` column is a header group spanning its two leaf columns, and `summary` returns footer cells positioned by leaf column index.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/table/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_table/
├── lib/
│   ├── antd_table.dart                 # barrel export
│   └── src/table/
│       ├── ant_table.dart              # header, body, scroll, tree rows
│       └── ant_table_types.dart        # columns, selection, summary, enums
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
