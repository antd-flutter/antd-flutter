<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelectorOption

> 种类：类

```dart
class AntSelectorOption
```

选择器选项（旧模型，自 1.x 起推荐直接用 `AntSelector<T>(options: List<T>)`
配合 `labelOf` / `labelBuilder` / `descriptionOf`）。

## 构造函数

### `AntSelectorOption({required this.value, required this.label, this.description, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T` | 可选 | — |
| `label` | `Widget` | 可选 | — |
| `description` | `Widget?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `description` | `Widget?` | 描述文本 |
| `disabled` | `bool` | 是否禁用 |
| `label` | `Widget` | 选项标签 |
| `value` | `T` | 选项值 |

