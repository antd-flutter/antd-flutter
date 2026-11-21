# P09 · Calendar 双端各自实现与功能对齐（排队任务，2026-11-21 立项）

> 用户指令（m04587，逐字）："Calendar UI按照各自平台实现一套，功能也按各自antd平台对齐实现，如果能整合就整合到一起，不能的话就做一下不同平台的区分适配 **这个任务等所有任务完成后再开始，也生成任务来逐步进行**"。
>
> 状态：**排队中**。等当前全部任务（剩余验收项、ScreenUtil/AntScale 改造、其它修复）完成后再启动；启动前先重读本文件与两端源码。

## 1. 现状

`packages/antd_calendar`（约 2000 行）当前是「一个控件两套分支」：

| 文件 | 行数 | 内容 |
|---|---:|---|
| `lib/src/calendar/ant_calendar.dart` | 1183 | 月视图 + 双端形态（fullscreen/card）交织在同一 State 中 |
| `lib/src/calendar/ant_calendar_types.dart` | 190 | 布局/格式/选择模式/单元格信息等类型 |
| `lib/src/calendar/ant_calendar_locale.dart` | 461 | 多语言 |
| `lib/src/calendar/ant_calendar_controller.dart` | 69 | 翻页/跳转控制器 |
| `lib/src/calendar_picker/ant_calendar_picker.dart` | 715 | 移动端弹层选择器 |

已有能力：月网格、月份导航、日期选择、今天高亮、禁用、自定义单元格、month/year 面板切换、validRange/min/max、range + multiSelect、事件点、week/twoWeeks 格式、renderDate/renderLabel、年月下拉、滑动翻页。

问题：
- 双端 UI 与交互逻辑混在一个 State，`fullscreen` 分支与 `card` 分支互相牵制（此前 Calendar 打磨就出现过 card 布局被 fullscreen 判定覆盖的 bug）；
- 功能是「两端并集」，既不是 antd v6 的完整能力，也不是 antd-mobile v5 的完整能力（例如桌面缺 `headerRender/showWeek`，移动缺 `selectionMode` 命名与 range 拖选过程态）；
- 增强能力（table_calendar 血统：week/twoWeeks、multiSelect）与 antd 语义无关，却占用主 API，导致「按平台对齐」时无法判断哪些该保留。

## 2. 双端功能矩阵（目标）

### 2.1 桌面 · antd v6 Calendar（`.temp/ant-design/components/calendar/`）

| 能力 | 目标 |
|---|---|
| `value/defaultValue` 受控/非受控 | ✅ |
| `mode: month \| year` 受控 + `onPanelChange(date, mode)` | ✅ |
| `onSelect(date, info{source})`，source = date/year/month/customize | ✅ |
| `onChange(date)` | ✅（与 onSelect 语义区分） |
| `fullscreen`（v6 中 Calendar 默认即 fullscreen 面板） | ✅ |
| `headerRender` 自定义头部 | ✅ 新增 |
| `cellRender / fullCellRender`（含 info：today/originNode/type） | ✅ 完整 |
| `dateCellRender/dateFullCellRender/monthCellRender/monthFullCellRender`（deprecated 兼容） | ✅ 保留映射 |
| `disabledDate`、`validRange` | ✅ |
| `showWeek`（周序号列） | ✅ 新增 |
| `weekStartsOn` 默认 Sunday（antd 默认） | ✅ 与移动端区分 |
| 语义化 `classNames/styles`（Flutter 侧以 `cellDecoration`/`styles` 对象替代） | 评估后提供等价钩子 |
| 月份面板（year mode 下 12 个格子） | ✅ 对齐 |

### 2.2 移动 · antd-mobile v5 Calendar（`.temp/ant-design-mobile/src/components/calendar/`）

| 能力 | 目标 |
|---|---|
| `selectionMode: single \| range`（不传 = 只展示不可选） | ✅ 新增（替代/映射现有 selectionMode） |
| `value/defaultValue`：single = `Date?`，range = `[Date, Date]?` | ✅ 类型分型 |
| `onChange`：single `(Date?)`，range `([Date,Date]?)` | ✅ 与桌面签名区分 |
| `allowClear` 默认 **true**（点已选日期取消） | ✅ 对齐默认值 |
| `min/max`、`shouldDisableDate` | ✅（与 disabledDate 合并语义） |
| `minPage/maxPage`（`Page{year,month}`） | ✅ 类型对齐 |
| `onPageChange(year, month)` | ✅ |
| `weekStartsOn: Monday \| Sunday`，默认 **Sunday** | ✅ 对齐 |
| `renderLabel`（日期下方标签）、`renderDate`（格子内容） | ✅ 分层 |
| `cellRender(oriNode, info)` 包裹式自定义 | ✅ |
| 左右箭头：`prevMonthButton/prevYearButton/nextMonthButton/nextYearButton` | ✅ 可替换 |
| 头部标题（居中「2024年6月」+ 双侧箭头） | ✅ |
| range 选择过程态（首次点击→预览到悬停/点击终点；移动端拖选） | ✅ |
| `CalendarRef.jumpTo/jumpToToday` | ✅ |

### 2.3 现有增强能力（非 antd 血统）去留

| 能力 | 决策 |
|---|---|
| `week / twoWeeks` 格式 | 保留为**扩展能力**（`AntCalendarExtensions` 或参数），不进入两端核心路径；文档标注「非 antd 对齐项」 |
| `multiSelect` | 同上，桌面/移动均不默认暴露 |
| `eventLoader` 事件点 | 保留为扩展（移动 `renderLabel` 可覆盖，桌面 `cellRender` 可覆盖） |
| `layout: auto/fullscreen/card` | 保留 `auto` 作平台选择；显式 `fullscreen/card` 保留一个版本兼容后废弃 |
| `header` 自定义 Widget | 桌面映射 `headerRender`；移动映射头部替换 |

## 3. 架构：什么整合、什么分平台

**整合（共享）**——纯逻辑，与渲染无关：
- `calendar_math.dart`：月网格生成、6×7 行、周起始、范围/页码换算、min/max 与 validRange 裁剪、Page{year,month}。
- `calendar_state.dart`：受控/非受控值、选择状态机（single/range/预览）、面板模式（month/year）、当前页。
- `calendar_locale.dart`：保留现有本地化，抽 `markItems`、月份/年份格式化。
- `calendar_types.dart`：公共类型（保留 + 新增 `AntCalendarPage`、`AntCalendarSelectionMode`、`AntCalendarCellInfo`）。

**分平台（独立渲染器）**：
```
lib/src/calendar/
  ant_calendar.dart            // 统一入口：platform 分派 + 参数归一化 + 兼容层
  calendar_core/               // ← 共享逻辑
    calendar_math.dart
    calendar_state.dart
    calendar_core_types.dart
  desktop/
    ant_calendar_desktop.dart  // antd v6 fullscreen 渲染
    desktop_header.dart        // 年月下拉 + 月/年切换
    desktop_month_panel.dart
    desktop_year_panel.dart
  mobile/
    ant_calendar_mobile.dart   // antd-mobile v5 渲染
    mobile_header.dart         // 居中标题 + 双箭头
    mobile_range_painter.dart  // 范围过程态/拖选
```
- 判定规则：**逻辑可共享则共享；视觉/交互/回调签名不同则各写一套**，不允许在渲染代码里用 `if (isMobile)` 打补丁（入口层一次性分发）。
- 公共 API：`AntCalendar` 保持单一类，新增 `platform: AntCalendarPlatform.{auto,desktop,mobile}`（默认 auto = `AntPlatform.isMobile ? mobile : desktop`）；平台专属参数按「桌面段 / 移动段」分组注释，互斥组合用 assert 校验。
- `AntCalendarPicker`（弹层）继续只服务移动端，内部改为复用 `AntCalendarMobile`；桌面不提供 Picker 形态。

## 4. 分阶段任务（每阶段独立可验收、可提交）

| 阶段 | 内容 | 产出/验收 | 预估 |
|---|---|---|---|
| **C0 调研与基线** | 通读 antd v6 Calendar + antd-mobile v5 Calendar 源码与全部 demo；跑通现有 5 个 calendar 测试文件（93 项）作为基线；产出 `calendar-parity-matrix.md`（本文件第 2 节细化到每个参数/默认值/回调） | 矩阵文档 + 基线测试全绿 | 1 天 |
| **C1 抽共享核心** | 抽出 `calendar_math/state/locale/types`，`ant_calendar.dart` 只保留分派与参数归一化；现有渲染先原样搬进 `desktop/` 与 `mobile/`（行为不变） | 93 项测试不改断言全过；示例无变化 | 1.5 天 |
| **C2 桌面渲染器** | 按 antd v6 重写 `desktop/`：header（年月下拉+mode 切换）、month/year 面板、cellRender/fullCellRender(+info)、headerRender、showWeek、validRange/disabledDate、onPanelChange/onSelect(source)/onChange；删除桌面不该有的 week/twoWeeks/multiSelect 分支 | 新增桌面渲染测试 ≥12 条；桌面示例页（`example/lib/pages/calendar_page.dart` 桌面段） | 2–3 天 |
| **C3 移动渲染器** | 按 antd-mobile v5 重写 `mobile/`：selectionMode single/range、allowClear 默认 true、weekStartsOn 默认 Sunday、minPage/maxPage(Page)、onPageChange、renderLabel/renderDate/cellRender、四向箭头替换、range 过程态与拖选；`AntCalendarPicker` 复用 | 新增移动渲染测试 ≥12 条；移动示例段与 CalendarPicker 联动 | 2–3 天 |
| **C4 兼容与整合判定** | 记录每条「共享/分平台」的最终判定；旧参数（`fullscreen/card/layout`、`calendarFormat`、`multiSelect`）映射与 `@Deprecated`；扩展能力收敛到显式入口 | 迁移说明 + 兼容测试 | 1 天 |
| **C5 示例与视觉验收** | 示例页按平台分段（或 `platform` 切换）；桌面 1728×972、移动 2007×2853 截图对照 antd 官网截图；用户验收 | 截图 + 验收记录 | 1 天 |
| **C6 收口** | `gen_docs.sh` 重跑、API 文档更新、CHANGELOG、状态表备注、删除死代码与临时测试；全量回归（包 + 示例 + 21 包） | 全绿 + 提交推送 | 1 天 |

合计约 **9–11 天**，可分 6–8 个提交；C2/C3 可并行（两个子代理），但 C1 必须先完成。

## 5. 关键决策点（执行时需确认）

1. **统一入口 vs 两个公开类**：推荐单一 `AntCalendar(platform:)` 自动分派；若你希望业务显式选 `AntCalendar.desktop()` / `AntCalendar.mobile()`，可在 C4 增加命名构造。
2. **增强能力（week/twoWeeks/multiSelect/eventLoader）**：推荐保留为扩展（不进两端核心），文档标注非 antd；如你要求「完全只保留 antd 能力」，C4 直接删除。
3. **桌面 fullscreen**：antd v6 的 Calendar 本身就是 fullscreen 面板，推荐桌面只保留这一形态；`card` 仅移动端。
4. **默认周起始**：桌面 Sunday（antd 默认）/ 移动 Sunday（antd-mobile 默认），现有实现默认 Monday，切换属破坏性变更。
5. **CalendarPicker**：仅移动端；桌面无对应 antd 组件，不新增。

## 6. 风险

- 现有 93 项测试大量依赖当前混合实现（如 `layout: card` 的桌面分支、44.w 单元格），C2/C3 会有较多断言重写——属预期，需按平台拆分测试文件（`calendar_desktop_test.dart` / `calendar_mobile_test.dart`）。
- 周起始默认从 Monday 改 Sunday 会影响所有现有示例与用户代码，需在迁移说明中显著标注。
- 移动端 range 拖选涉及手势与滚动冲突（日历在页面内滚动），需在 C3 单独验证。
- 与 R38/R40 的关系：本任务只处理 Calendar；R38（双端样式）与 R40（泛型数据）在 Calendar 上同时适用，`AntCalendar` 无数据集合，主要受 R38 约束。

## 7. 启动条件

- 当前队列全部完成：剩余 23 项组件终验、ScreenUtil/AntScale 改造（待用户拍板）、以及期间用户新增的所有修复。
- 启动第一步：重读本文件 → `git log` 确认 develop 状态 → 跑 calendar 基线测试 → 产出细化矩阵（C0）。
