<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendar

> 种类：类

```dart
class AntCalendar
```

日历 — 纯展示型日历面板（双端形态 + 增强能力）。

对齐 antd React Calendar 核心 API，向后兼容既有
value/defaultValue/onSelect/weekStartsOn/disabledDate/dateCell/fullscreen/card
等参数。

## 构造函数

### `AntCalendar({super.key, this.value, this.defaultValue, this.onSelect, this.weekStartsOn = AntCalendarWeekStartsOn.monday, this.fullscreen = false, this.dateCell, this.disabledDate, this.header, this.layout = AntCalendarLayout.auto, this.calendarFormat = AntCalendarFormat.month, this.onFormatChanged, this.showFormatSwitcher = false, this.selectionMode = AntCalendarSelectionMode.single, this.onRangeSelected, this.multiSelect = false, this.selectedDays, this.defaultSelectedDays = const [], this.onSelectMulti, this.eventLoader, this.enableYearMonthDropdown = true, this.locale})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `DateTime?` | 可选 | — |
| `defaultValue` | `DateTime?` | 可选 | — |
| `onSelect` | `ValueChanged<DateTime>?` | 可选 | — |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | = AntCalendarWeekStartsOn.monday | — |
| `fullscreen` | `bool` | = false | — |
| `dateCell` | `AntCalendarDateCellBuilder?` | 可选 | — |
| `disabledDate` | `bool Function(DateTime date)?` | 可选 | — |
| `header` | `Widget?` | 可选 | — |
| `layout` | `AntCalendarLayout` | = AntCalendarLayout.auto | — |
| `calendarFormat` | `AntCalendarFormat` | = AntCalendarFormat.month | — |
| `onFormatChanged` | `ValueChanged<AntCalendarFormat>?` | 可选 | — |
| `showFormatSwitcher` | `bool` | = false | — |
| `selectionMode` | `AntCalendarSelectionMode` | = AntCalendarSelectionMode.single | — |
| `onRangeSelected` | `void Function(DateTime start, DateTime end)?` | 可选 | — |
| `multiSelect` | `bool` | = false | — |
| `selectedDays` | `List<DateTime>?` | 可选 | — |
| `defaultSelectedDays` | `List<DateTime>` | = const [] | — |
| `onSelectMulti` | `ValueChanged<List<DateTime>>?` | 可选 | — |
| `eventLoader` | `List<DateTime> Function(DateTime day)?` | 可选 | — |
| `enableYearMonthDropdown` | `bool` | = true | — |
| `locale` | `AntCalendarLocale?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `calendarFormat` | `AntCalendarFormat` | 可见格式：month / twoWeeks / week（tablecalendar calendarFormat… |
| `dateCell` | `AntCalendarDateCellBuilder?` | 自定义日期单元格渲染回调，返回 null 时使用默认渲染 |
| `defaultSelectedDays` | `List<DateTime>` | 非受控多选初始集合 |
| `defaultValue` | `DateTime?` | 非受控初始选中日期 |
| `disabledDate` | `bool Function(DateTime date)?` | 判断日期是否不可选 |
| `enableYearMonthDropdown` | `bool` | 头部年月文字是否可点弹出年月快速跳转面板（antd v6 行为，默认 true） |
| `eventLoader` | `List<DateTime> Function(DateTime day)?` | 事件加载器：返回某日期关联的事件列表，日期下方渲染小圆点标记 （tablecalendar eventLoader… |
| `fullscreen` | `bool` | 是否全屏模式（大格子），默认 false 为 card 紧凑模式 |
| `header` | `Widget?` | 自定义头部内容，为 null 时使用默认头部（年月标题 + 导航 + 本月按钮） |
| `layout` | `AntCalendarLayout` | 布局形态：auto 经 AntResponsive 自适应（desktop/web → fullscreen， p… |
| `locale` | `AntCalendarLocale?` | 国际化文案 |
| `multiSelect` | `bool` | 是否多选模式（与 range 互斥，multiSelect 优先） |
| `onFormatChanged` | `ValueChanged<AntCalendarFormat>?` | 格式切换回调 |
| `onRangeSelected` | `void Function(DateTime start, DateTime end)?` | 范围选择完成回调（第二次点击结束时触发 |
| `onSelect` | `ValueChanged<DateTime>?` | 日期被选中时的回调（所有选择模式下均触发，保持向后兼容） |
| `onSelectMulti` | `ValueChanged<List<DateTime>>?` | 多选变化回调 |
| `selectedDays` | `List<DateTime>?` | 受控多选日期集合 |
| `selectionMode` | `AntCalendarSelectionMode` | 选择模式：单选或范围选择 |
| `showFormatSwitcher` | `bool` | 是否在头部展示格式切换按钮（可隐藏，默认 false） |
| `value` | `DateTime?` | 受控选中日期（单选模式） |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | 周起始日 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCalendar>` | — |

