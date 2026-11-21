<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPickerView

> 种类：类

```dart
class AntPickerView
```

内嵌滚轮选择器 — 多列滚轮，选中项实时回调。

## 构造函数

### `AntPickerView({super.key, required this.columns, this.value, this.defaultValue = const [], this.onChange, this.itemHeight = 40, this.height = 240})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columns` | `List<AntPickerColumn<T>>` | 可选 | — |
| `value` | `List<Object?>?` | 可选 | — |
| `defaultValue` | `List<Object?>` | = const [] | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `itemHeight` | `double` | = 40 | — |
| `height` | `double` | = 240 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `columns` | `List<AntPickerColumn<T>>` | 列数据 |
| `defaultValue` | `List<Object?>` | 非受控初始值（元素可为 T 或 key） |
| `height` | `double` | 整体高度 |
| `itemHeight` | `double` | 单项高度 |
| `onChange` | `ValueChanged<List<T>>?` | 选中变化回调（返回各列选中的模型） |
| `value` | `List<Object?>?` | 受控值（各列选中值，元素可为 T 或 key） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPickerView<T>>` | — |

