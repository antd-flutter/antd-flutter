<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_calendar API 文档总览

> 自动生成时间：2026-11-21T23:54:41.558561；共 31 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（15）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendar`](api/AntCalendar.md) | 日历 — 纯展示型日历面板（双端形态 + 增强能力） |
| [`AntCalendarBuiltInNavButton`](api/AntCalendarBuiltInNavButton.md) | 移动端头部内置导航按钮标记（AntCalendar.prevMonthButton 等默认值） |
| [`AntCalendarCellRenderInfo`](api/AntCalendarCellRenderInfo.md) | 单元格渲染信息（antd v6 cellRender / fullCellRender 的 info 参数对齐） |
| [`AntCalendarController`](api/AntCalendarController.md) | AntCalendar 的控制器：程序化翻页与年月跳转 |
| [`AntCalendarHeaderRenderConfig`](api/AntCalendarHeaderRenderConfig.md) | 自定义头部渲染配置（antd v6 headerRender 的 config 对齐） |
| [`AntCalendarLocale`](api/AntCalendarLocale.md) | 日历国际化文案 |
| [`AntCalendarLocaleProvider`](api/AntCalendarLocaleProvider.md) | 日历国际化注入 — InheritedWidget，包裹一次全局生效 |
| [`AntCalendarMonthNavigator`](api/AntCalendarMonthNavigator.md) | 月份导航目标接口：由 AntCalendar 内部 State 实现，Controller 调用 |
| [`AntCalendarPage`](api/AntCalendarPage.md) | 年月页面（antd-mobile Page 对齐），用于 minPage/maxPage 面板导航范围限制 |
| [`AntCalendarPicker`](api/AntCalendarPicker.md) | 底部弹窗日历选择器 — 点击触发器弹出底部面板，内含日历视图 |
| [`AntCalendarPickerView`](api/AntCalendarPickerView.md) | 内嵌日历选择视图 — 直接渲染日历网格，支持单选/范围选择 |
| [`AntCalendarSelectInfo`](api/AntCalendarSelectInfo.md) | 选中事件附加信息（antd v6 onSelect(date, info) 的 info 对齐） |
| [`AntCalendarValidRange`](api/AntCalendarValidRange.md) | 有效日期范围（antd v6 validRange 对齐） |
| [`AntPickerColumn`](api/AntPickerColumn.md) | 单列滚轮数据（泛型） |
| [`AntPickerView`](api/AntPickerView.md) | 内嵌滚轮选择器 — 多列滚轮，选中项实时回调 |

## 枚举（8）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendarCellType`](api/AntCalendarCellType.md) | 单元格类型（antd v6 info.type 对齐）：日期格 / 月格 |
| [`AntCalendarFormat`](api/AntCalendarFormat.md) | 日历可见格式（吸收 tablecalendar calendarFormat，参考 Apache-2.0 源码改造） |
| [`AntCalendarLayout`](api/AntCalendarLayout.md) | 日历布局形态（双实现切换） |
| [`AntCalendarMode`](api/AntCalendarMode.md) | 日历面板模式（antd v6 mode 对齐：月面板 / 年面板） |
| [`AntCalendarPlatform`](api/AntCalendarPlatform.md) | 日历平台渲染器选择（C1 引入 |
| [`AntCalendarSelectSource`](api/AntCalendarSelectSource.md) | 选择来源（antd v6 SelectInfo.source 对齐） |
| [`AntCalendarSelectionMode`](api/AntCalendarSelectionMode.md) | 日历选择模式 |
| [`AntCalendarWeekStartsOn`](api/AntCalendarWeekStartsOn.md) | 周起始日设置 |

## 类型定义（8）

| 名称 | 说明 |
| --- | --- |
| [`AntCalendarCellRender`](api/AntCalendarCellRender.md) | cellRender 内容层渲染回调（antd v6 cellRender 对齐）： 返回 null 时回退默认内… |
| [`AntCalendarDateCellBuilder`](api/AntCalendarDateCellBuilder.md) | 自定义日期单元格构建回调 |
| [`AntCalendarFullCellRender`](api/AntCalendarFullCellRender.md) | fullCellRender 整格渲染回调（antd v6 fullCellRender 对齐）： 返回 null… |
| [`AntCalendarHeaderRender`](api/AntCalendarHeaderRender.md) | 自定义头部渲染回调（antd v6 headerRender 对齐，仅桌面渲染器生效） |
| [`AntCalendarMobileCellRender`](api/AntCalendarMobileCellRender.md) | 移动端整格包裹渲染回调（C3 新增，antd-mobile cellRender 包裹语义） |
| [`AntCalendarMonthCellRender`](api/AntCalendarMonthCellRender.md) | 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐） |
| [`AntCalendarMonthFullCellRender`](api/AntCalendarMonthFullCellRender.md) | 月面板整格渲染回调（antd v6 monthFullCellRender 对齐） |
| [`AntCalendarPanelChangeCallback`](api/AntCalendarPanelChangeCallback.md) | 面板变化回调（antd v6 onPanelChange 对齐）： 面板模式切换或展示月份变化时触发 |

