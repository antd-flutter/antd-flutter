<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDatePicker

> 种类：类

```dart
class AntDatePicker
```

日期选择框 — 输入或选择日期。

对齐 antd React DatePicker 组件。

## 构造函数

### `AntDatePicker({super.key, this.value, this.defaultValue, this.onChange, this.allowClear = false, this.placeholder, this.disabled = false, this.size = AntDatePickerSize.middle, this.format = 'yyyy-MM-dd', this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `DateTime?` | 可选 | — |
| `defaultValue` | `DateTime?` | 可选 | — |
| `onChange` | `ValueChanged<DateTime?>?` | 可选 | — |
| `allowClear` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntDatePickerSize` | = AntDatePickerSize.middle | — |
| `format` | `String` | = 'yyyy-MM-dd' | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `DateTime?` | 非受控初始日期 |
| `disabled` | `bool` | 是否禁用 |
| `format` | `String` | 日期显示格式（目前支持 yyyy-MM-dd） |
| `onChange` | `ValueChanged<DateTime?>?` | 日期变化回调 |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntDatePickerSize` | 尺寸 |
| `value` | `DateTime?` | 受控日期值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDatePicker>` | — |

