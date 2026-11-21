<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTableRowSelectionItem

> 种类：类

```dart
class AntTableRowSelectionItem
```

自定义选择项（对齐 antd `rowSelection.selections`）。

## 构造函数

### `AntTableRowSelectionItem({required this.text, required this.onSelect})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `onSelect` | `ValueChanged<Set<Object>>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `onSelect` | `ValueChanged<Set<Object>>` | 点击回调（参数为全部可选行 key 集合） |
| `text` | `String` | 选择项文本 |

