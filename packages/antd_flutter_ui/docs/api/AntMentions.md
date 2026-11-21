<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMentions

> 种类：类

```dart
class AntMentions
```

提及组件。

在文本输入中通过输入 '@' 等前缀触发选项列表。

## 构造函数

### `AntMentions({super.key, this.options = const [], this.labelOf, this.valueOf, this.disabledOf, this.itemBuilder, this.value, this.defaultValue, this.onChange, this.onSelect, this.prefix = '@', this.placeholder, this.disabled = false, this.allowClear = false, this.size = AntMentionsSize.middle, this.maxRows = 3})`

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
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整行下拉项自定义渲染（点击与禁用态仍由组件负责） |
| `labelOf` | `String Function(T item)?` | 选项展示文案（下拉行文本 + 过滤匹配文本），缺省 '$item' |
| `maxRows` | `int` | 最大行数 |
| `onChange` | `ValueChanged<String>?` | 文本变化回调 |
| `onSelect` | `ValueChanged<T>?` | 选中提及项回调（回传模型对象） |
| `options` | `List<T>` | 提及选项列表（任意模型） |
| `placeholder` | `String?` | 占位文本 |
| `prefix` | `String` | 触发字符 |
| `size` | `AntMentionsSize` | 尺寸 |
| `value` | `String?` | 受控文本值 |
| `valueOf` | `String Function(T item)?` | 选中后插入到文本中的内容，缺省与 labelOf 一致 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntMentions<T>>` | — |

