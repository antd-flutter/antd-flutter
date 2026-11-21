<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelector

> 种类：类

```dart
class AntSelector
```

选择组 — 标签/网格风格的单选/多选组件。

对齐 antd-mobile React Selector。

## 构造函数

### `AntSelector({super.key, this.value, this.defaultValue, required this.options, this.labelOf, this.labelBuilder, this.descriptionOf, this.descriptionBuilder, this.itemBuilder, this.disabledOf, this.multiple = false, this.onChange, this.disabled = false, this.readOnly = false, this.columns})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<T>?` | 可选 | — |
| `defaultValue` | `List<T>?` | 可选 | — |
| `options` | `List<T>` | 可选 | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `descriptionOf` | `String Function(T item)?` | 可选 | — |
| `descriptionBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `multiple` | `bool` | = false | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `readOnly` | `bool` | = false | — |
| `columns` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `columns` | `int?` | 列数（null 时自动换行） |
| `defaultValue` | `List<T>?` | 非受控初始选中值列表 |
| `descriptionBuilder` | `Widget Function(BuildContext context, T item)?` | 选项描述的自定义渲染 |
| `descriptionOf` | `String Function(T item)?` | 选项描述的字符串简写 |
| `disabled` | `bool` | 是否整体禁用 |
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整项内容自定义渲染（替换内置 label + description 布局） |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 选项 label 的自定义渲染 |
| `labelOf` | `String Function(T item)?` | 选项的字符串 label 简写（未提供 labelBuilder 时作为文本渲染） |
| `multiple` | `bool` | 是否支持多选 |
| `onChange` | `ValueChanged<List<T>>?` | 选中值变化回调 |
| `options` | `List<T>` | 选项列表（任意模型） |
| `readOnly` | `bool` | 是否整体只读 |
| `value` | `List<T>?` | 受控选中值列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSelector<T>>` | — |

