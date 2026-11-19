<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_calendar API 文档总览

> 自动生成时间：2026-11-20T00:16:30.387956；共 25 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（12）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendar`](api/AntCalendar.md) | 日历 — 纯展示型日历面板（双端形态 + 增强能力） |
| [`AntCalendarCellRenderInfo`](api/AntCalendarCellRenderInfo.md) | 单元格渲染信息（antd v6 cellRender / fullCellRender 的 info 参数对齐） |
| [`AntCalendarController`](api/AntCalendarController.md) | AntCalendar 的控制器：程序化翻页与年月跳转 |
| [`AntCalendarLocale`](api/AntCalendarLocale.md) | 日历国际化文案 |
| [`AntCalendarLocaleProvider`](api/AntCalendarLocaleProvider.md) | 日历国际化注入 — InheritedWidget，包裹一次全局生效 |
| [`AntCalendarMonthNavigator`](api/AntCalendarMonthNavigator.md) | 月份导航目标接口：由 AntCalendar 内部 State 实现，Controller 调用 |
| [`AntCalendarPage`](api/AntCalendarPage.md) | 年月页面（antd-mobile Page 对齐），用于 minPage/maxPage 面板导航范围限制 |
| [`AntCalendarPicker`](api/AntCalendarPicker.md) | 底部弹窗日历选择器 — 点击触发器弹出底部面板，内含日历视图 |
| [`AntCalendarPickerView`](api/AntCalendarPickerView.md) | 内嵌日历选择视图 — 直接渲染日历网格，支持单选/范围选择 |
| [`AntCalendarValidRange`](api/AntCalendarValidRange.md) | 有效日期范围（antd v6 validRange 对齐） |
| [`AntPickerColumnItem`](api/AntPickerColumnItem.md) | 选择器列项 |
| [`AntPickerView`](api/AntPickerView.md) | 内嵌滚轮选择器 — 多列滚轮，选中项实时回调 |

## 枚举（5）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendarFormat`](api/AntCalendarFormat.md) | 日历可见格式（吸收 tablecalendar calendarFormat，参考 Apache-2.0 源码改造） |
| [`AntCalendarLayout`](api/AntCalendarLayout.md) | 日历布局形态（双实现切换） |
| [`AntCalendarMode`](api/AntCalendarMode.md) | 日历面板模式（antd v6 mode 对齐：月面板 / 年面板） |
| [`AntCalendarSelectionMode`](api/AntCalendarSelectionMode.md) | 日历选择模式 |
| [`AntCalendarWeekStartsOn`](api/AntCalendarWeekStartsOn.md) | 周起始日设置 |

## 类型定义（8）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendarCellRender`](api/AntCalendarCellRender.md) | cellRender 内容层渲染回调（antd v6 cellRender 对齐）： 返回 null 时回退默认内… |
| [`AntCalendarDateCellBuilder`](api/AntCalendarDateCellBuilder.md) | 自定义日期单元格构建回调 |
| [`AntCalendarFullCellRender`](api/AntCalendarFullCellRender.md) | fullCellRender 整格渲染回调（antd v6 fullCellRender 对齐）： 返回 null… |
| [`AntCalendarMonthCellRender`](api/AntCalendarMonthCellRender.md) | 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐） |
| [`AntCalendarMonthFullCellRender`](api/AntCalendarMonthFullCellRender.md) | 月面板整格渲染回调（antd v6 monthFullCellRender 对齐） |
| [`AntCalendarPanelChangeCallback`](api/AntCalendarPanelChangeCallback.md) | 面板变化回调（antd v6 onPanelChange 对齐）： 面板模式切换或展示月份变化时触发 |
| [`AntPickerColumn`](api/AntPickerColumn.md) | 选择器列 |
| [`AntPickerValue`](api/AntPickerValue.md) | 选择器值类型 |

