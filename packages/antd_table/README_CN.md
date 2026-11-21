# antd_table - Flutter 泛型 Ant Design 表格

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/README_CN.md)

## 定位与设计

`antd_table` 在**你的行模型 `T`** 之上渲染强类型数据表格。`AntTable<T>` 负责表头、表体、排序、筛选、分页、行选择、展开行、树形行与汇总行；`AntTableColumn<T>` 描述每个叶子列或表头分组。数据不会被包进 Map 或合成行对象——列的 `cell` 回调直接拿到你的对象以及兄弟行下标。

设计原则：

- **列是结构，单元格是内容。** `title` 与可选的 `width` / `align` / `fixed` 决定网格，`cell` 决定每格显示什么。
- **分组递归。** 带非空 `children` 的列成为表头分组；只有叶子列参与数据渲染。
- **树形行自动推断。** `childrenOf` 返回非空时该行成为父行，展开、缩进与选择联动由此派生。
- **布局显式。** 不传 `scrollX` / `scrollY` 时表格适应父容器；传入后启用横向滚动（固定列吸边）与纵向虚拟滚动。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_table: ^1.0.0
```

用 `AntTheme` 包裹子树；行高、边框、表头底色与密度均来自设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

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

`rowKey` 为每行提供稳定标识，供选择与展开使用；显式提供可避免数据顺序变化时状态错位。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_table/docs/api-index.md)

### 1. 单列排序与筛选

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

第一列表头同时提供排序切换与筛选菜单，第二列默认升序。排序与筛选在行数据交给表格内处理，变更回调携带叶子列下标。

### 2. 行选择与展开行

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

`selectedRowKeys` 使选择受控，`onChange` 必须把新集合写回 state。提供 `expandedRowRender` 后展开箭头自动出现。

### 3. 树形行、表头分组与汇总行

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

`childrenOf` 返回非空列表的行成为可折叠父行。`Members` 列是由两个叶子列组成的表头分组，`summary` 按叶子列下标返回页脚单元格。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/table/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_table/
├── lib/
│   ├── antd_table.dart                 # barrel 导出
│   └── src/table/
│       ├── ant_table.dart              # 表头、表体、滚动与树形行
│       └── ant_table_types.dart        # 列、选择、汇总与枚举
├── example/lib/main.dart               # 可运行示例
├── docs/api-index.md                   # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
