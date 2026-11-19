<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMentions

> 种类：类

```dart
class AntMentions
```

提及组件。

在文本输入中通过输入 '@' 等前缀触发选项列表。

## 构造函数

### `AntMentions({super.key, this.options = const [], this.value, this.defaultValue, this.onChange, this.onSelect, this.prefix = '@', this.placeholder, this.disabled = false, this.allowClear = false, this.size = AntMentionsSize.middle, this.maxRows = 3})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<AntMentionsOption>` | = const [] | — |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onSelect` | `ValueChanged<AntMentionsOption>?` | 可选 | — |
| `prefix` | `String` | = '@' | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `size` | `AntMentionsSize` | = AntMentionsSize.middle | — |
| `maxRows` | `int` | = 3 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否显示清除按钮 |
| `defaultValue` | `String?` | 非受控默认值 |
| `disabled` | `bool` | 是否禁用 |
| `maxRows` | `int` | 最大行数 |
| `onChange` | `ValueChanged<String>?` | 文本变化回调 |
| `onSelect` | `ValueChanged<AntMentionsOption>?` | 选中提及项回调 |
| `options` | `List<AntMentionsOption>` | 提及选项列表 |
| `placeholder` | `String?` | 占位文本 |
| `prefix` | `String` | 触发字符 |
| `size` | `AntMentionsSize` | 尺寸 |
| `value` | `String?` | 受控文本值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntMentions>` | — |

