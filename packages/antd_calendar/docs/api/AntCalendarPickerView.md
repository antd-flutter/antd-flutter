<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarPickerView

> 种类：类

```dart
class AntCalendarPickerView
```

内嵌日历选择视图 — 直接渲染日历网格，支持单选/范围选择。

## 构造函数

### `AntCalendarPickerView({super.key, this.selectionMode = AntCalendarSelectionMode.single, this.value, this.defaultValue = const [], this.onChange, this.min, this.max, this.weekStartsOn = AntCalendarWeekStartsOn.sunday, this.allowClear = true, this.locale})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `selectionMode` | `AntCalendarSelectionMode` | = AntCalendarSelectionMode.single | — |
| `value` | `List<DateTime>?` | 可选 | — |
| `defaultValue` | `List<DateTime>` | = const [] | — |
| `onChange` | `ValueChanged<List<DateTime>>?` | 可选 | — |
| `min` | `DateTime?` | 可选 | — |
| `max` | `DateTime?` | 可选 | — |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | = AntCalendarWeekStartsOn.sunday | — |
| `allowClear` | `bool` | = true | — |
| `locale` | `AntCalendarLocale?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 点击已选日期是否清除选择 |
| `defaultValue` | `List<DateTime>` | 非受控初始值 |
| `locale` | `AntCalendarLocale?` | 国际化文案 |
| `max` | `DateTime?` | 最大可选日期 |
| `min` | `DateTime?` | 最小可选日期 |
| `onChange` | `ValueChanged<List<DateTime>>?` | 选择变化回调 |
| `selectionMode` | `AntCalendarSelectionMode` | 选择模式 |
| `value` | `List<DateTime>?` | 受控值（单选 0~1 个元素，范围 0~2 个元素） |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | 周起始日 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCalendarPickerView>` | — |

