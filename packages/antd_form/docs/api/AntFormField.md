<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFormField

> 种类：类

```dart
class AntFormField
```

表单字段状态，通过 `AntFormItem.builder` 传递给表单控件。

## 构造函数

### `AntFormField({required this.value, this.errorText, required this.didChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T?` | 可选 | — |
| `errorText` | `String?` | 可选 | — |
| `didChange` | `ValueChanged<T>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `didChange` | `ValueChanged<T>` | 更新字段值（触发校验取决于 validateTrigger） |
| `errorText` | `String?` | 当前校验错误文案（无错误时为 null） |
| `value` | `T?` | 当前字段值 |

