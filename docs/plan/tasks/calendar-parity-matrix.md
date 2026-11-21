# C0 · Calendar 双端对齐矩阵（2026-11-21）

> 隶属 P09（`docs/plan/tasks/P09-calendar-platform-split.md`）。本文件把任务书第 2 节细化到「参数 / 默认值 / 回调签名 / 现状 / 差距」，作为 C1–C4 的验收清单。

## 0. 基线（C0 起点）

| 项 | 结果 |
|---|---|
| 分支 | `develop`，HEAD `da6197c`（ScreenUtil 移除） |
| `antd_calendar` analyze | No issues |
| `antd_calendar` 测试 | **93/93 通过**（6 个文件：ant_calendar_test 28、full_feature 20、enhancement 17、locale 12、controller 10、picker 6） |
| 参考源码 | `.temp/ant-design/components/calendar/`（antd v6，generateCalendar.tsx + Header.tsx）、`.temp/ant-design-mobile/src/components/calendar/`（v5，calendar.tsx） |

现状结构：`ant_calendar.dart` 1183 行，fullscreen（桌面）与 card（移动）两套渲染交织在一个 State；`ant_calendar_picker.dart` 715 行仅服务移动端弹层。

## 1. 桌面 · antd v6（generateCalendar.tsx / Header.tsx）

| antd 参数 | 类型 / 默认 | 现状 | 差距 |
|---|---|---|---|
| `value` / `defaultValue` | `DateType`，非受控默认 now | `value` / `defaultValue` | 无 |
| `mode` | `'month' \| 'year'`，受控；内部另有面板态 | `mode` + `initialMode` | 无（受控语义需补测试） |
| `onPanelChange(date, mode)` | 面板切换/月份变化 | `onPanelChange` | 无 |
| `onSelect(date, {source})` | source: `year/month/date/customize` | `onSelect(DateTime)` 无 source | **缺 SelectInfo** |
| `onChange(date)` | 选中变化 | `onChange(DateTime?)`（多模式复用） | 默认值/清除语义需分平台 |
| `fullscreen` | bool，默认 true（v6 面板本身） | `fullscreen` + `layout` | 桌面固定 fullscreen，参数待废弃 |
| `headerRender(config)` | 自定义头部（value/type/onChange/onTypeChange） | `header: Widget?` 整体替换 | **缺 headerRender 配置式** |
| `cellRender(date, info)` | info: `type/today/originNode` | `cellRender(date, info)`，info 含 today/selected/currentMonth/disabled/validRange | 缺 `type`（date/month）、`originNode` |
| `fullCellRender(date, info)` | 同上 | `fullCellRender` | 同上 |
| `dateCellRender` / `dateFullCellRender` | deprecated，映射到 cellRender/fullCellRender | `dateCell` | 命名不同，deprecated 映射待补 |
| `monthCellRender` / `monthFullCellRender` | 年面板 12 格 | 已有 | 无 |
| `disabledDate(date)` | 返回禁用 | `disabledDate` | 无 |
| `validRange` | `[start, end]`，面板导航裁剪 | `AntCalendarValidRange` | 无 |
| `showWeek` | 周序号列（默认 false） | 无 | **缺** |
| `weekStartsOn` | 无此参数（antd 默认周日） | 默认 **monday** | **默认值需改 sunday** |
| `classNames` / `styles` | 语义化 className/styles 对象 | 无 | 评估后提供 `cellDecoration` 等价钩子 |
| 年/月下拉 | YearSelect（year±10，validRange 裁剪）+ MonthSelect + 模式 Radio.Group | 已有（`enableYearMonthDropdown`、`showModeSwitcher`） | 默认值/宽度细节对齐 |

桌面面板行为：月视图 6×7、年月下拉、mode 切换按钮、cell 高约 100px（fullscreen）。

## 2. 移动 · antd-mobile v5（calendar.tsx）

| antd-mobile 参数 | 类型 / 默认 | 现状 | 差距 |
|---|---|---|---|
| `selectionMode` | `'single' \| 'range'`，不传 = 只展示 | `selectionMode` 默认 single | **不传应不可选**（当前默认可选） |
| `value` / `defaultValue` | single: `Date?`；range: `[Date,Date]?`；默认 null | 单 `DateTime?` + `onRangeSelected` | **range 类型分型缺失** |
| `onChange` | single `(Date?)`；range `([Date,Date]?)` | `onChange(DateTime?)` | 签名待分型 |
| `allowClear` | **默认 true** | 默认 false | **默认值需改** |
| `max` / `min` | Date | 已有 | 无 |
| `shouldDisableDate` | `(date) => bool` | 用 `disabledDate` | 合并语义，保留一个主参数 + 别名 |
| `minPage` / `maxPage` | `Page{year,month}` | `AntCalendarPage` 已有 | 无 |
| `onPageChange(year, month)` | 页码变化 | `onPageChange` | 无 |
| `weekStartsOn` | `'Monday' \| 'Sunday'`，默认 **Sunday** | 默认 monday | **默认值需改 sunday** |
| `renderLabel(date)` | 日期下方标签 | 已有 | 无 |
| `renderDate(date)` | 格子日期内容替换 | 已有 | 无 |
| `cellRender(oriNode, {date})` | 包裹式自定义 | 无（`cellRender` 是桌面语义的内容替换） | **需区分包裹 vs 替换** |
| `prev/nextMonthButton`、`prev/nextYearButton` | ReactNode 替换 | `showYearNavButtons` 布尔 | **缺四向按钮替换** |
| 头部 | 居中「2024年6月」+ 左右箭头（默认只翻月） | 有年月文字与可选年按钮 | 布局/行为对齐 |
| range 过程态 | 首次点击 → 预览到第二次点击；移动端按压拖选 | 无预览选中 | **缺过程态与拖选** |
| `CalendarRef.jumpTo/jumpToToday` | imperative | `AntCalendarController` | 对齐命名 |
| `Page` 类型 | `{year, month}` | `AntCalendarPage` | 无 |

参考 demo：`.temp/ant-design-mobile/src/components/calendar/demos/`（basic / range / custom / page 等）。

## 3. 共享 vs 分平台（C1 抽离依据）

| 模块 | 内容 | 归属 |
|---|---|---|
| 月网格 | 6×7 生成、周起始、首末日、补位日期 | 共享 `calendar_math` |
| 范围/页码 | validRange 裁剪、min/max、Page 比较、翻页边界 | 共享 `calendar_math` |
| 选择状态机 | 受控/非受控、single/range/预览、allowClear | 共享 `calendar_state` |
| 面板状态 | month/year、当前页、mode 受控 | 共享 `calendar_state` |
| 本地化 | 月份/星期文案、markItems | 共享 `calendar_locale` |
| 公共类型 | CellInfo/Page/SelectionMode/SelectSource | 共享 `calendar_core_types` |
| 渲染与手势 | 头部、网格样式、滑动翻页、range 拖选、cell 包裹 | 桌面 / 移动各自 `desktop/`、`mobile/` |
| 弹层 | AntCalendarPicker | 移动 only（复用 `AntCalendarMobile`） |
| 增强能力 | week/twoWeeks、multiSelect、eventLoader | 扩展入口，不进两端核心 |

分派规则：入口 `AntCalendar(platform: auto|desktop|mobile)` 一次性选择渲染器；渲染器内部禁止 `if (isMobile)`。

## 4. 破坏性变更清单（C4 需在迁移说明标注）

1. `weekStartsOn` 默认 Monday → **Sunday**（双端 antd 默认）；示例与测试同步。
2. 移动端 `selectionMode` 不传 = **只展示不可选**（当前默认可选）。
3. 移动端 `allowClear` 默认 true。
4. `onSelect` 增加 `AntCalendarSelectInfo{source}`（桌面）；保留旧单参回调为 `onSelectDate` 兼容或在 C4 删除。
5. `onChange` 双端签名分型（桌面 `DateTime`；移动 single `DateTime?` / range `[DateTime,DateTime]?`）。
6. range 值类型由「首尾两次点击分别回调」改为 `([DateTime,DateTime]?)` 受控值。
7. `layout: fullscreen/card`、`calendarFormat`、`multiSelect` 收敛为扩展/废弃参数。
8. `cellRender` 语义分平台：桌面 = 内容替换（antd），移动 = 包裹（antd-mobile）——同名不同签名，需文档显著标注。

## 5. 用户已拍板（2026-11-21）

| # | 问题 | 决策 |
|---|---|---|
| 1 | 入口形式 | **单一 `AntCalendar(platform: auto\|desktop\|mobile)`**（默认按 `AntPlatform` 分派） |
| 2 | 增强能力（week/twoWeeks/multiSelect/eventLoader） | **保留为扩展入口**，文档标注「非 antd 对齐项」 |
| 3 | 桌面形态 | **保留 card 形态**：桌面渲染器同时支持 fullscreen 与 card 两种 layout |
| 4 | 周起始默认 | **Sunday**（破坏性；C4 切换并同步示例/测试） |
| 5 | CalendarPicker | **仅移动端** |

## 6. C0 结论

- 基线 93 项全绿，可作为 C1 重构的安全网。
- 桌面最大缺口：`onSelect.source`、`showWeek`、`headerRender`、info.type/originNode、deprecated 映射。
- 移动最大缺口：selectionMode 不传不可选、range 值分型与过程态/拖选、allowClear 默认、四向按钮替换、cellRender 包裹语义、周起始默认。
- C1 目标：把「月网格 + 状态机 + 页码裁剪 + 本地化」抽成无渲染依赖的 core，现有渲染原样搬入 desktop/mobile，93 项断言不变。
