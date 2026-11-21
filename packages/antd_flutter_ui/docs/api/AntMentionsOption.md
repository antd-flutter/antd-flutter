<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMentionsOption

> 种类：类

```dart
class AntMentionsOption
```

提及选项（旧模型，自 1.x 起推荐直接用
`AntMentions<T>(options: List<T>)` 配合 `labelOf` / `valueOf`）。

## 构造函数

### `AntMentionsOption({required this.value, this.label, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String` | 可选 | — |
| `label` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `disabled` | `bool` | 是否禁用 |
| `label` | `String?` | 显示文本（默认与 value 相同） |
| `value` | `String` | 选项值（插入到文本中的内容） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `displayLabel` | `String` | 显示文本 |

