<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCheckList

> 种类：类

```dart
class AntCheckList
```

复选列表 — 列表样式的单选/多选组件。

对齐 antd-mobile React CheckList。

## 构造函数

### `AntCheckList({super.key, this.value, this.defaultValue, this.multiple = false, this.onChange, this.disabled = false, this.readOnly = false, this.showCheckMark = true, this.activeIcon, required this.items, this.labelOf, this.labelBuilder, this.descriptionOf, this.descriptionBuilder, this.prefixOf, this.prefixBuilder, this.itemBuilder, this.disabledOf, this.readOnlyOf})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<T>?` | 可选 | — |
| `defaultValue` | `List<T>?` | 可选 | — |
| `multiple` | `bool` | = false | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `readOnly` | `bool` | = false | — |
| `showCheckMark` | `bool` | = true | — |
| `activeIcon` | `Widget?` | 可选 | — |
| `items` | `List<T>` | 可选 | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `descriptionOf` | `String Function(T item)?` | 可选 | — |
| `descriptionBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `prefixOf` | `String Function(T item)?` | 可选 | — |
| `prefixBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `readOnlyOf` | `bool Function(T item)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIcon` | `Widget?` | 自定义选中图标 |
| `defaultValue` | `List<T>?` | 非受控初始选中值列表 |
| `descriptionBuilder` | `Widget Function(BuildContext context, T item)?` | 描述内容的自定义渲染 |
| `descriptionOf` | `String Function(T item)?` | 描述文本的字符串简写 |
| `disabled` | `bool` | 是否整体禁用 |
| `disabledOf` | `bool Function(T item)?` | 列表项是否禁用 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整行自定义渲染（替换内置行布局，仍保留点击与勾选逻辑） |
| `items` | `List<T>` | 列表项（任意模型） |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 主内容的自定义渲染 |
| `labelOf` | `String Function(T item)?` | 主内容的字符串 label 简写（未提供 labelBuilder 时作为文本渲染） |
| `multiple` | `bool` | 是否支持多选 |
| `onChange` | `ValueChanged<List<T>>?` | 选中值变化回调 |
| `prefixBuilder` | `Widget Function(BuildContext context, T item)?` | 前缀内容的自定义渲染 |
| `prefixOf` | `String Function(T item)?` | 前缀内容的字符串简写 |
| `readOnly` | `bool` | 是否整体只读 |
| `readOnlyOf` | `bool Function(T item)?` | 列表项是否只读 |
| `showCheckMark` | `bool` | 是否显示勾选标记 |
| `value` | `List<T>?` | 受控选中值列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCheckList<T>>` | — |

