<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTree

> 种类：类

```dart
class AntTree
```

树形控件 — 多层次的结构列表。

对齐 antd React Tree 组件。

## 构造函数

### `AntTree({super.key, this.treeData = const [], this.defaultExpandedKeys, this.defaultExpandAll = false, this.expandedKeys, this.onExpand, this.selectable = true, this.defaultSelectedKeys, this.selectedKeys, this.onSelect, this.checkable = false, this.defaultCheckedKeys, this.checkedKeys, this.onCheck, this.checkStrictly = false, this.showLine = false, this.indent})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `treeData` | `List<AntTreeNode>` | = const [] | — |
| `defaultExpandedKeys` | `List<String>?` | 可选 | — |
| `defaultExpandAll` | `bool` | = false | — |
| `expandedKeys` | `List<String>?` | 可选 | — |
| `onExpand` | `ValueChanged<List<String>>?` | 可选 | — |
| `selectable` | `bool` | = true | — |
| `defaultSelectedKeys` | `List<String>?` | 可选 | — |
| `selectedKeys` | `List<String>?` | 可选 | — |
| `onSelect` | `ValueChanged<List<String>>?` | 可选 | — |
| `checkable` | `bool` | = false | — |
| `defaultCheckedKeys` | `List<String>?` | 可选 | — |
| `checkedKeys` | `List<String>?` | 可选 | — |
| `onCheck` | `AntTreeOnCheck?` | 可选 | — |
| `checkStrictly` | `bool` | = false | — |
| `showLine` | `bool` | = false | — |
| `indent` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `checkStrictly` | `bool` | 严格勾选模式：父子不联动 |
| `checkable` | `bool` | 是否显示复选框 |
| `checkedKeys` | `List<String>?` | 受控勾选的节点 key |
| `defaultCheckedKeys` | `List<String>?` | 默认勾选的节点 key |
| `defaultExpandAll` | `bool` | 默认展开全部节点 |
| `defaultExpandedKeys` | `List<String>?` | 默认展开的节点 key |
| `defaultSelectedKeys` | `List<String>?` | 默认选中的节点 key |
| `expandedKeys` | `List<String>?` | 受控展开的节点 key |
| `indent` | `double?` | 每级缩进宽度，默认 24 |
| `onCheck` | `AntTreeOnCheck?` | 勾选回调 |
| `onExpand` | `ValueChanged<List<String>>?` | 展开/收起回调 |
| `onSelect` | `ValueChanged<List<String>>?` | 选中回调 |
| `selectable` | `bool` | 是否可选中 |
| `selectedKeys` | `List<String>?` | 受控选中的节点 key |
| `showLine` | `bool` | 是否显示连接线 |
| `treeData` | `List<AntTreeNode>` | 树节点数据 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTree>` | — |

