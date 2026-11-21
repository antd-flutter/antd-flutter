# 数据组件泛型化约定（P08 · 2026-11-21）

1.0 发布前允许破坏性 API。目标：组件直接吃使用者的模型 `T`，不再要求构造 `Ant*Item/Option` 或 `Map` 行。

## 硬性规则

1. **数据参数泛型化**：集合用 `List<T> dataSource` / `List<T> items`；值为 `T value`。组件类带 `<T>`。
2. **结构化取数只靠回调**：
   - `Object Function(T item)? keyOf`（缺省用 index）
   - `List<T> Function(T item)? childrenOf`（树、级联、菜单、分组）
   - `bool Function(T item)? disabledOf`
3. **渲染一律 builder**：
   - 标签/单值：`Widget Function(BuildContext context, T item)? labelBuilder`（Select/Radio/Checkbox/Tree 标题等）
   - 行/项整体：`Widget Function(BuildContext context, T item, int index)? itemBuilder`（Table cell、List 行、Tab 条、Steps 项）
   - 可选文本回退：`String? label`/`String? title` 与 builder 二选一（构造器 assert）。
4. **删除字符串取值**：不再有 `dataIndex`、`String key` 强约束；排序/筛选用 `Comparator<T>? sorter`、`bool Function(T, T)? filter`。
5. **不强制旧模型**：`AntTableColumn<T>`、`AntMenuItem<T>` 等仍可保留，但其字段泛型化；不能既要求用户构造旧模型又无 builder。
6. **类型文件保持在各自 `*_types.dart` 并导出**；公共 typedef（`AntItemBuilder<T>` 等）放组件包内，不新建跨包依赖。
7. **示例与测试同步**：每组件至少 1 条「用户自定义模型」用例；既有测试改到新 API；`fvm flutter analyze` + `fvm flutter test` 全绿。
8. 双端样式规则 R38（桌面 antd v6 / 移动 antd-mobile v5）与图标规则 R39（只用 AntIcons）继续生效。
9. **不要 commit / push**；不要动 `packages/antd_keyboard`（子任务进行中）、`packages/antd_icons_flutter`（图标源）、`example/lib/data/migration_status.dart` 与验收状态表。由 lead 统一回归、提交。

## 参考形态

```dart
// Table
AntTable<User>(
  dataSource: users,
  rowKey: (u) => u.id,
  columns: [
    AntTableColumn<User>(
      title: '姓名',
      cell: (context, u, i) => Text(u.name),
      sorter: (a, b) => a.name.compareTo(b.name),
    ),
  ],
);

// Tree
AntTree<Category>(
  dataSource: categories,
  keyOf: (c) => c.id,
  titleBuilder: (context, c) => Text(c.name),
  childrenOf: (c) => c.children,
);

// Select
AntSelect<User>(
  options: users,
  value: selected,
  labelBuilder: (context, u) => Text(u.name),
  onChange: (u) => setState(() => selected = u),
);
```

## 交付要求（子代理回报格式）
- 改动组件清单 + 新 API 签名
- 每条组件的「自定义模型」测试名
- `analyze` / `test` 结果数字
- 未解决项与建议
