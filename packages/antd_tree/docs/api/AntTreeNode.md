<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTreeNode

> 种类：类

```dart
class AntTreeNode
```

树节点数据。

## 构造函数

### `AntTreeNode({required this.key, required this.title, this.children, this.disabled = false, this.checkable = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String` | 可选 | — |
| `children` | `List<AntTreeNode>?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `checkable` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `checkable` | `bool` | 是否显示复选框（仅 checkable 开启时生效） |
| `children` | `List<AntTreeNode>?` | 子节点 |
| `disabled` | `bool` | 是否禁用（不可选中/不可勾选/不可展开） |
| `key` | `String` | 节点唯一标识 |
| `title` | `String` | 节点显示文本 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isLeaf` | `bool` | 是否叶子节点 |

