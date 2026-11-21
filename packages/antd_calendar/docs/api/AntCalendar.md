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

### `AntCalendar({super.key, this.value, this.defaultValue, this.onSelect, this.onSelectWithInfo, this.onChange, this.weekStartsOn, this.fullscreen = false, this.dateCell, this.cellRender, this.fullCellRender, this.headerRender, this.showWeek = false, @Deprecated('Use cellRender instead (antd v6)') this.dateCellRender, @Deprecated('Use fullCellRender instead (antd v6)') this.dateFullCellRender, this.monthCellRender, this.monthFullCellRender, this.disabledDate, this.shouldDisableDate, this.validRange, this.min, this.max, this.minPage, this.maxPage, this.header, this.layout = AntCalendarLayout.auto, this.platform = AntCalendarPlatform.auto, this.calendarFormat = AntCalendarFormat.month, this.onFormatChanged, this.showFormatSwitcher = false, this.showModeSwitcher, this.mode, this.initialMode = AntCalendarMode.month, this.onModeChanged, this.onPanelChange, this.onPageChange, this.renderDate, this.renderLabel, this.mobileCellRender, this.allowClear, this.selectionMode = AntCalendarSelectionMode.single, this.onRangeSelected, this.rangeValue, this.defaultRangeValue, this.onRangeChange, this.prevYearButton = const AntCalendarBuiltInNavButton(AntIcons.doubleLeftOutlined), this.prevMonthButton = const AntCalendarBuiltInNavButton(AntIcons.leftOutlined), this.nextMonthButton = const AntCalendarBuiltInNavButton(AntIcons.rightOutlined), this.nextYearButton = const AntCalendarBuiltInNavButton(AntIcons.doubleRightOutlined), this.multiSelect = false, this.selectedDays, this.defaultSelectedDays = const [], this.onSelectMulti, this.eventLoader, this.showYearNavButtons = false, this.enableYearMonthDropdown = true, this.locale, this.controller})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `DateTime?` | 可选 | — |
| `defaultValue` | `DateTime?` | 可选 | — |
| `onSelect` | `ValueChanged<DateTime>?` | 可选 | — |
| `onSelectWithInfo` | `void Function(DateTime date, AntCalendarSelectInfo info)?` | 可选 | — |
| `onChange` | `ValueChanged<DateTime?>?` | 可选 | — |
| `weekStartsOn` | `AntCalendarWeekStartsOn?` | 可选 | — |
| `fullscreen` | `bool` | = false | — |
| `dateCell` | `AntCalendarDateCellBuilder?` | 可选 | — |
| `cellRender` | `AntCalendarCellRender?` | 可选 | — |
| `fullCellRender` | `AntCalendarFullCellRender?` | 可选 | — |
| `headerRender` | `AntCalendarHeaderRender?` | 可选 | — |
| `showWeek` | `bool` | = false | — |
| `dateCellRender` | `Widget? Function(DateTime date)?` | 可选 | — |
| `dateFullCellRender` | `Widget? Function(DateTime date)?` | 可选 | — |
| `monthCellRender` | `AntCalendarMonthCellRender?` | 可选 | — |
| `monthFullCellRender` | `AntCalendarMonthFullCellRender?` | 可选 | — |
| `disabledDate` | `bool Function(DateTime date)?` | 可选 | — |
| `shouldDisableDate` | `bool Function(DateTime date)?` | 可选 | — |
| `validRange` | `AntCalendarValidRange?` | 可选 | — |
| `min` | `DateTime?` | 可选 | — |
| `max` | `DateTime?` | 可选 | — |
| `minPage` | `AntCalendarPage?` | 可选 | — |
| `maxPage` | `AntCalendarPage?` | 可选 | — |
| `header` | `Widget?` | 可选 | — |
| `layout` | `AntCalendarLayout` | = AntCalendarLayout.auto | — |
| `platform` | `AntCalendarPlatform` | = AntCalendarPlatform.auto | — |
| `calendarFormat` | `AntCalendarFormat` | = AntCalendarFormat.month | — |
| `onFormatChanged` | `ValueChanged<AntCalendarFormat>?` | 可选 | — |
| `showFormatSwitcher` | `bool` | = false | — |
| `showModeSwitcher` | `bool?` | 可选 | — |
| `mode` | `AntCalendarMode?` | 可选 | — |
| `initialMode` | `AntCalendarMode` | = AntCalendarMode.month | — |
| `onModeChanged` | `ValueChanged<AntCalendarMode>?` | 可选 | — |
| `onPanelChange` | `AntCalendarPanelChangeCallback?` | 可选 | — |
| `onPageChange` | `void Function(int year, int month)?` | 可选 | — |
| `renderDate` | `Widget? Function(DateTime date)?` | 可选 | — |
| `renderLabel` | `Widget? Function(DateTime date)?` | 可选 | — |
| `mobileCellRender` | `AntCalendarMobileCellRender?` | 可选 | — |
| `allowClear` | `bool?` | 可选 | — |
| `selectionMode` | `AntCalendarSelectionMode?` | = AntCalendarSelectionMode.single | — |
| `onRangeSelected` | `void Function(DateTime start, DateTime end)?` | 可选 | — |
| `rangeValue` | `List<DateTime>?` | 可选 | — |
| `defaultRangeValue` | `List<DateTime>?` | 可选 | — |
| `onRangeChange` | `ValueChanged<List<DateTime>?>?` | 可选 | — |
| `prevYearButton` | `Widget?` | = const AntCalendarBuiltInNavButton(AntIcons.doubleLeftOutlined) | — |
| `prevMonthButton` | `Widget?` | = const AntCalendarBuiltInNavButton(AntIcons.leftOutlined) | — |
| `nextMonthButton` | `Widget?` | = const AntCalendarBuiltInNavButton(AntIcons.rightOutlined) | — |
| `nextYearButton` | `Widget?` | = const AntCalendarBuiltInNavButton(AntIcons.doubleRightOutlined) | — |
| `multiSelect` | `bool` | = false | — |
| `selectedDays` | `List<DateTime>?` | 可选 | — |
| `defaultSelectedDays` | `List<DateTime>` | = const [] | — |
| `onSelectMulti` | `ValueChanged<List<DateTime>>?` | 可选 | — |
| `eventLoader` | `List<DateTime> Function(DateTime day)?` | 可选 | — |
| `showYearNavButtons` | `bool` | = false | — |
| `enableYearMonthDropdown` | `bool` | = true | — |
| `locale` | `AntCalendarLocale?` | 可选 | — |
| `controller` | `AntCalendarController?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool?` | 点击已选日期是否清除选择（antd-mobile allowClear 对齐）， 单选与范围模式生效 |
| `calendarFormat` | `AntCalendarFormat` | 可见格式：month / twoWeeks / week（tablecalendar calendarFormat… |
| `cellRender` | `AntCalendarCellRender?` | 单元格内容渲染回调（antd v6 cellRender 对齐，带状态 info |
| `controller` | `AntCalendarController?` | 程序化控制器（R35.2 Controller 优先）：经 AntCalendarController .prev… |
| `dateCell` | `AntCalendarDateCellBuilder?` | 自定义日期单元格内容渲染回调（三层：fullCellRender > cellRender > dateCell … |
| `dateCellRender` | `Widget? Function(DateTime date)?` | 已废弃：请使用 cellRender（antd v6 将 dateCellRender 并入 cellRender… |
| `dateFullCellRender` | `Widget? Function(DateTime date)?` | 已废弃：请使用 fullCellRender（antd v6 将 dateFullCellRender 并入 fu… |
| `defaultRangeValue` | `List<DateTime>?` | 非受控初始范围值（长度 2、已排序） |
| `defaultSelectedDays` | `List<DateTime>` | 非受控多选初始集合 |
| `defaultValue` | `DateTime?` | 非受控初始选中日期 |
| `disabledDate` | `bool Function(DateTime date)?` | 判断日期是否不可选 |
| `enableYearMonthDropdown` | `bool` | 头部年月文字是否可点弹出年月快速跳转面板（antd v6 行为，默认 true） |
| `eventLoader` | `List<DateTime> Function(DateTime day)?` | 事件加载器：返回某日期关联的事件列表，日期下方渲染小圆点标记 （tablecalendar eventLoader… |
| `fullCellRender` | `AntCalendarFullCellRender?` | 整格渲染回调（antd v6 fullCellRender 对齐）：完全接管单元格 渲染（含背景/边框/选择态视觉… |
| `fullscreen` | `bool` | 是否全屏模式（大格子），默认 false 为 card 紧凑模式 |
| `header` | `Widget?` | 自定义头部内容，为 null 时使用默认头部 （移动端：居中月份标题 + 四向箭头 |
| `headerRender` | `AntCalendarHeaderRender?` | 自定义头部渲染（antd v6 headerRender 对齐，仅桌面渲染器生效）： 传 null 时使用桌面默认… |
| `initialMode` | `AntCalendarMode` | 非受控初始面板模式（默认 month） |
| `layout` | `AntCalendarLayout` | 布局形态：auto 经 AntResponsive 自适应（desktop/web → fullscreen， p… |
| `locale` | `AntCalendarLocale?` | 国际化文案 |
| `max` | `DateTime?` | 最大可选日期（antd-mobile max 对齐） |
| `maxPage` | `AntCalendarPage?` | 面板导航最大年月页（antd-mobile maxPage 对齐） |
| `min` | `DateTime?` | 最小可选日期（antd-mobile min 对齐） |
| `minPage` | `AntCalendarPage?` | 面板导航最小年月页（antd-mobile minPage 对齐） |
| `mobileCellRender` | `AntCalendarMobileCellRender?` | 移动端整格包裹渲染（C3 新增，antd-mobile cellRender 包裹语义）： 与桌面替换式 cell… |
| `mode` | `AntCalendarMode?` | 受控面板模式（month / year 面板 |
| `monthCellRender` | `AntCalendarMonthCellRender?` | 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐） |
| `monthFullCellRender` | `AntCalendarMonthFullCellRender?` | 月面板整格渲染回调（antd v6 monthFullCellRender 对齐） |
| `multiSelect` | `bool` | 是否多选模式（与 range 互斥，multiSelect 优先） |
| `nextMonthButton` | `Widget?` | 下一月按钮 |
| `nextYearButton` | `Widget?` | 下一年按钮 |
| `onChange` | `ValueChanged<DateTime?>?` | 选中变化回调（antd v6 onChange / antd-mobile onChange 对齐）： 单选选中时… |
| `onFormatChanged` | `ValueChanged<AntCalendarFormat>?` | 格式切换回调 |
| `onModeChanged` | `ValueChanged<AntCalendarMode>?` | 面板模式变化回调 |
| `onPageChange` | `void Function(int year, int month)?` | 展示月份变化回调（antd-mobile onPageChange 对齐）： 仅在翻页/跳转后触发，初始渲染不触发… |
| `onPanelChange` | `AntCalendarPanelChangeCallback?` | 面板变化回调（antd v6 onPanelChange 对齐）： 展示月份变化或面板模式切换时触发 |
| `onRangeChange` | `ValueChanged<List<DateTime>?>?` | 范围值变化回调（移动端 range 模式）：选择中回传 date, date， 完成回传 begin, end，清… |
| `onRangeSelected` | `void Function(DateTime start, DateTime end)?` | 范围选择完成回调（第二次点击结束时触发 |
| `onSelect` | `ValueChanged<DateTime>?` | 日期被选中时的回调（所有选择模式下均触发，保持向后兼容 |
| `onSelectMulti` | `ValueChanged<List<DateTime>>?` | 多选变化回调 |
| `onSelectWithInfo` | `void Function(DateTime date, AntCalendarSelectInfo info)?` | 带选择来源的选中回调（antd v6 onSelect(date, info) 对齐）： AntCalendarS… |
| `platform` | `AntCalendarPlatform` | 平台渲染器选择：auto 按 AntPlatform 分派（mobile → 移动渲染器， 其余 → 桌面渲染器） |
| `prevMonthButton` | `Widget?` | 上一月按钮 |
| `prevYearButton` | `Widget?` | 上一年按钮 |
| `rangeValue` | `List<DateTime>?` | 受控范围值（移动端 range 模式）：长度 2、已排序 |
| `renderDate` | `Widget? Function(DateTime date)?` | 日期数字位自定义渲染（antd-mobile renderDate 对齐）， null 时渲染默认日期数字 |
| `renderLabel` | `Widget? Function(DateTime date)?` | 日卡子标题渲染（antd-mobile renderLabel 对齐，日期数字下方 子标题位，如农历/节日） |
| `selectedDays` | `List<DateTime>?` | 受控多选日期集合 |
| `selectionMode` | `AntCalendarSelectionMode?` | 选择模式：单选 / 范围选择 |
| `shouldDisableDate` | `bool Function(DateTime date)?` | disabledDate 的别名（antd-mobile shouldDisableDate 对齐）： 两者任一命… |
| `showFormatSwitcher` | `bool` | 是否在头部展示格式切换按钮（可隐藏，默认 false） |
| `showModeSwitcher` | `bool?` | 是否展示月/年面板切换器（antd v6 头部 Radio 对齐） |
| `showWeek` | `bool` | 是否展示周序号列（antd v6 showWeek 对齐，仅桌面渲染器生效） |
| `showYearNavButtons` | `bool` | 是否展示年份导航按钮（双箭头，antd-mobile prevYearButton/ nextYearButton… |
| `validRange` | `AntCalendarValidRange?` | 有效日期范围（antd v6 validRange 对齐）：范围外日期不可交互， 面板导航裁剪在范围内 |
| `value` | `DateTime?` | 受控选中日期（单选模式） |
| `weekStartsOn` | `AntCalendarWeekStartsOn?` | 周起始日 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCalendar>` | — |

