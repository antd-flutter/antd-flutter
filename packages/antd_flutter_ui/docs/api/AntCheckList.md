<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCheckList

> 种类：类

```dart
class AntCheckList
```

复选列表 — 列表样式的单选/多选组件。

对齐 antd-mobile React CheckList。

## 构造函数

### `AntCheckList({super.key, this.value, this.defaultValue, this.multiple = false, this.onChange, this.disabled = false, this.readOnly = false, this.showCheckMark = true, this.activeIcon, required this.items})`

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
| `items` | `List<AntCheckListItem<T>>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIcon` | `Widget?` | 自定义选中图标 |
| `defaultValue` | `List<T>?` | 非受控初始选中值列表 |
| `disabled` | `bool` | 是否整体禁用 |
| `items` | `List<AntCheckListItem<T>>` | 列表项 |
| `multiple` | `bool` | 是否支持多选 |
| `onChange` | `ValueChanged<List<T>>?` | 选中值变化回调 |
| `readOnly` | `bool` | 是否整体只读 |
| `showCheckMark` | `bool` | 是否显示勾选标记 |
| `value` | `List<T>?` | 受控选中值列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCheckList<T>>` | — |

