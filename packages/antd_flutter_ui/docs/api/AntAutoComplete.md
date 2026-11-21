<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAutoComplete

> 种类：类

```dart
class AntAutoComplete
```

自动补全输入组件。

输入时展示匹配的选项下拉，选中后回填输入框。

## 构造函数

### `AntAutoComplete({super.key, this.options = const [], this.labelOf, this.valueOf, this.disabledOf, this.itemBuilder, this.value, this.defaultValue, this.onChange, this.onSelect, this.placeholder, this.disabled = false, this.allowClear = false, this.filterOption = true, this.size = AntAutoCompleteSize.middle, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<T>` | = const [] | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `valueOf` | `String Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onSelect` | `ValueChanged<T>?` | 可选 | — |
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
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `filterOption` | `bool` | 是否根据输入过滤选项 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整行下拉项自定义渲染（仍由组件负责点击与禁用态） |
| `labelOf` | `String Function(T item)?` | 选项展示文案（下拉行文本 + 过滤匹配文本），缺省 '$item' |
| `onChange` | `ValueChanged<String>?` | 输入值变化回调 |
| `onSelect` | `ValueChanged<T>?` | 选中选项回调（回传模型对象） |
| `options` | `List<T>` | 补全选项列表（任意模型） |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntAutoCompleteSize` | 尺寸 |
| `value` | `String?` | 受控值 |
| `valueOf` | `String Function(T item)?` | 选中后回填到输入框的文本，缺省与 labelOf 一致 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAutoComplete<T>>` | — |

