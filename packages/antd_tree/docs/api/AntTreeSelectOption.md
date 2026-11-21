<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTreeSelectOption

> 种类：类

```dart
class AntTreeSelectOption
```

树节点数据结构

## 构造函数

### `AntTreeSelectOption({required this.value, required this.label, this.children, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String` | 可选 | — |
| `label` | `String` | 可选 | — |
| `children` | `List<AntTreeSelectOption>?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntTreeSelectOption>?` | 子节点 |
| `disabled` | `bool` | 是否禁用 |
| `label` | `String` | 节点显示文本 |
| `value` | `String` | 节点值 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isLeaf` | `bool` | 是否叶子节点（无子节点或子节点为空） |

