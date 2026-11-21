<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTransferItem

> 种类：类

```dart
class AntTransferItem
```

穿梭框数据项

传入 `children` 即为树形（TreeTransfer）模式；不传则保持扁平列表模式。

## 构造函数

### `AntTransferItem({required this.key, required this.title, this.description, this.disabled = false, this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `children` | `List<AntTransferItem>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntTransferItem>?` | 子级数据（树形模式） |
| `description` | `String?` | 描述文本 |
| `disabled` | `bool` | 是否禁用（树模式下禁用会向下传递到整个子树） |
| `key` | `String` | 项唯一标识 |
| `title` | `String` | 标题 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hasChildren` | `bool` | 是否包含子级（children 非空） |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `_listEquals` | `bool` | — |

