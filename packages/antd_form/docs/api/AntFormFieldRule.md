<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFormFieldRule

> 种类：类

```dart
class AntFormFieldRule
```

字段校验规则

## 构造函数

### `AntFormFieldRule({this.required = false, this.message, this.pattern, this.min, this.max, this.minLength, this.maxLength, this.type = AntFormFieldRuleType.string, this.validator})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `required` | `bool` | = false | — |
| `message` | `String?` | 可选 | — |
| `pattern` | `RegExp?` | 可选 | — |
| `min` | `double?` | 可选 | — |
| `max` | `double?` | 可选 | — |
| `minLength` | `int?` | 可选 | — |
| `maxLength` | `int?` | 可选 | — |
| `type` | `AntFormFieldRuleType` | = AntFormFieldRuleType.string | — |
| `validator` | `String? Function(dynamic value)?` | 可选 | — |

### `AntFormFieldRule.required({this.message})`

创建必填规则

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `message` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `max` | `double?` | 数值最大值（仅对数值类型生效） |
| `maxLength` | `int?` | 字符串最大长度 |
| `message` | `String?` | 错误提示文案（未通过校验时显示） |
| `min` | `double?` | 数值最小值（仅对数值类型生效） |
| `minLength` | `int?` | 字符串最小长度 |
| `pattern` | `RegExp?` | 正则表达式校验（仅对字符串值生效） |
| `required` | `bool` | 是否必填 |
| `type` | `AntFormFieldRuleType` | 值类型约束 |
| `validator` | `String? Function(dynamic value)?` | 自定义校验器，返回错误文案或 null（通过） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_isEmpty` | `bool` | — |
| `validate` | `String?` | 校验单个值，返回错误文案或 null（通过） |

