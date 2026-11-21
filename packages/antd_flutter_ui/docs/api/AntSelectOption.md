<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelectOption

> 种类：类

```dart
class AntSelectOption
```

选择器选项（旧模型，自 1.x 起推荐直接用 `AntSelect<T>(options: List<T>)`
配合 `labelOf` / `valueExtractor`）。

## 构造函数

### `AntSelectOption({required this.value, required this.label, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T` | 可选 | — |
| `label` | `String` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `disabled` | `bool` | 是否禁用 |
| `label` | `String` | 选项文本 |
| `value` | `T` | 选项值 |

