<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelector

> 种类：类

```dart
class AntSelector
```

选择组 — 标签/网格风格的单选/多选组件。

对齐 antd-mobile React Selector。

## 构造函数

### `AntSelector({super.key, this.value, this.defaultValue, required this.options, this.multiple = false, this.onChange, this.disabled = false, this.readOnly = false, this.columns})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<T>?` | 可选 | — |
| `defaultValue` | `List<T>?` | 可选 | — |
| `options` | `List<AntSelectorOption<T>>` | 可选 | — |
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
| `disabled` | `bool` | 是否整体禁用 |
| `multiple` | `bool` | 是否支持多选 |
| `onChange` | `ValueChanged<List<T>>?` | 选中值变化回调 |
| `options` | `List<AntSelectorOption<T>>` | 选项列表 |
| `readOnly` | `bool` | 是否整体只读 |
| `value` | `List<T>?` | 受控选中值列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSelector<T>>` | — |

