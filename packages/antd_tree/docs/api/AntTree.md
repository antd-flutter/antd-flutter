<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTree

> 种类：类

```dart
class AntTree
```

树形控件。

```dart
AntTree<Category>(
  dataSource: categories,
  keyOf: (c) => c.id,
  titleBuilder: (_, c) => Text(c.name),
  childrenOf: (c) => c.children,
  checkable: true,
  checkedKeys: checked,
  onCheck: (keys, half) {},
);
```

## 构造函数

### `AntTree({super.key, required this.dataSource, this.keyOf, this.titleBuilder, this.childrenOf, this.disabledOf, this.checkableOf, this.defaultExpandedKeys, this.defaultExpandAll = false, this.expandedKeys, this.onExpand, this.selectable = true, this.defaultSelectedKeys, this.selectedKeys, this.onSelect, this.checkable = false, this.defaultCheckedKeys, this.checkedKeys, this.onCheck, this.checkStrictly = false, this.showLine = false, this.indent})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dataSource` | `List<T>` | 可选 | — |
| `keyOf` | `AntTreeKeyOf<T>?` | 可选 | — |
| `titleBuilder` | `AntTreeTitleBuilder<T>?` | 可选 | — |
| `childrenOf` | `AntTreeChildrenOf<T>?` | 可选 | — |
| `disabledOf` | `AntTreeDisabledOf<T>?` | 可选 | — |
| `checkableOf` | `AntTreeCheckableOf<T>?` | 可选 | — |
| `defaultExpandedKeys` | `Set<Object>?` | 可选 | — |
| `defaultExpandAll` | `bool` | = false | — |
| `expandedKeys` | `Set<Object>?` | 可选 | — |
| `onExpand` | `ValueChanged<Set<Object>>?` | 可选 | — |
| `selectable` | `bool` | = true | — |
| `defaultSelectedKeys` | `Set<Object>?` | 可选 | — |
| `selectedKeys` | `Set<Object>?` | 可选 | — |
| `onSelect` | `ValueChanged<Set<Object>>?` | 可选 | — |
| `checkable` | `bool` | = false | — |
| `defaultCheckedKeys` | `Set<Object>?` | 可选 | — |
| `checkedKeys` | `Set<Object>?` | 可选 | — |
| `onCheck` | `AntTreeOnCheck?` | 可选 | — |
| `checkStrictly` | `bool` | = false | — |
| `showLine` | `bool` | = false | — |
| `indent` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `checkStrictly` | `bool` | 父子勾选是否不联动 |
| `checkable` | `bool` | 是否显示勾选框 |
| `checkableOf` | `AntTreeCheckableOf<T>?` | 可勾选判断 |
| `checkedKeys` | `Set<Object>?` | 受控勾选 key 集合 |
| `childrenOf` | `AntTreeChildrenOf<T>?` | 子节点读取器 |
| `dataSource` | `List<T>` | 数据源（树形结构由 childrenOf 描述 |
| `defaultCheckedKeys` | `Set<Object>?` | 非受控默认勾选的 key 集合 |
| `defaultExpandAll` | `bool` | 是否默认展开全部父节点 |
| `defaultExpandedKeys` | `Set<Object>?` | 非受控默认展开的 key 集合 |
| `defaultSelectedKeys` | `Set<Object>?` | 非受控默认选中的 key 集合 |
| `disabledOf` | `AntTreeDisabledOf<T>?` | 禁用判断 |
| `expandedKeys` | `Set<Object>?` | 受控展开 key 集合 |
| `indent` | `double?` | 每级缩进宽度 |
| `keyOf` | `AntTreeKeyOf<T>?` | 从数据项提取唯一 key |
| `onCheck` | `AntTreeOnCheck?` | 勾选状态变化回调 |
| `onExpand` | `ValueChanged<Set<Object>>?` | 展开状态变化回调（参数为 keyOf 提取的 key） |
| `onSelect` | `ValueChanged<Set<Object>>?` | 选中状态变化回调 |
| `selectable` | `bool` | 标题是否可选中 |
| `selectedKeys` | `Set<Object>?` | 受控选中 key 集合 |
| `showLine` | `bool` | 是否显示连接线 |
| `titleBuilder` | `AntTreeTitleBuilder<T>?` | 节点标题构建器 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTree<T>>` | — |

