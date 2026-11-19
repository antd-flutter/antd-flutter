<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAutoComplete

> 种类：类

```dart
class AntAutoComplete
```

自动补全输入组件。

输入时展示匹配的选项下拉，选中后回填输入框。

## 构造函数

### `AntAutoComplete({super.key, this.options = const [], this.value, this.defaultValue, this.onChange, this.onSelect, this.placeholder, this.disabled = false, this.allowClear = false, this.filterOption = true, this.size = AntAutoCompleteSize.middle, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<AntAutoCompleteOption>` | = const [] | — |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onSelect` | `ValueChanged<AntAutoCompleteOption>?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `filterOption` | `bool` | = true | — |
| `size` | `AntAutoCompleteSize` | = AntAutoCompleteSize.middle | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否显示清除按钮 |
| `autofocus` | `bool` | 自动聚焦 |
| `defaultValue` | `String?` | 非受控默认值 |
| `disabled` | `bool` | 是否禁用 |
| `filterOption` | `bool` | 是否根据输入过滤选项 |
| `onChange` | `ValueChanged<String>?` | 输入值变化回调 |
| `onSelect` | `ValueChanged<AntAutoCompleteOption>?` | 选中选项回调 |
| `options` | `List<AntAutoCompleteOption>` | 补全选项列表 |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntAutoCompleteSize` | 尺寸 |
| `value` | `String?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAutoComplete>` | — |

