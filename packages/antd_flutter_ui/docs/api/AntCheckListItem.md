<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCheckListItem

> 种类：类

```dart
class AntCheckListItem
```

复选列表项（旧模型，自 1.x 起推荐直接用
`AntCheckList<T>(items: List<T>)` 配合 `labelOf` / `labelBuilder`）。

## 构造函数

### `AntCheckListItem({required this.value, required this.child, this.description, this.prefix, this.disabled = false, this.readOnly = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `description` | `Widget?` | 可选 | — |
| `prefix` | `Widget?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `readOnly` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 主内容 |
| `description` | `Widget?` | 描述文本 |
| `disabled` | `bool` | 是否禁用 |
| `prefix` | `Widget?` | 前缀内容 |
| `readOnly` | `bool` | 是否只读 |
| `value` | `T` | 项的值 |

