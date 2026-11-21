/// AntCalendar 共享核心内部类型（不对外导出）。
///
/// [AntCalendarCoreConfig] 是入口 `AntCalendar` 归一化后的不可变快照：
/// 渲染器与状态机都只读它，不再直接依赖 `AntCalendar` Widget，
/// 从而保证 core 与 desktop/mobile 渲染层解耦。
library;

import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:flutter/widgets.dart';

/// 归一化后的日历配置（入口层 `AntCalendar` → core / 渲染器）。
///
/// 字段均为渲染/状态机所需的纯数据或回调，不包含 Widget。
/// 入口每次 build 重新生成，[AntCalendarCoreState.updateConfig] 负责
/// 复现原 `didUpdateWidget` 的受控字段重置语义。
class AntCalendarCoreConfig {
  /// 创建配置快照。
  const AntCalendarCoreConfig({
    this.value,
    this.defaultValue,
    this.onSelect,
    this.onSelectWithInfo,
    this.onChange,
    this.dateCell,
    this.cellRender,
    this.fullCellRender,
    this.dateCellRender,
    this.dateFullCellRender,
    this.monthCellRender,
    this.monthFullCellRender,
    this.headerRender,
    this.showWeek = false,
    this.renderDate,
    this.renderLabel,
    this.mobileCellRender,
    required this.weekStartsOnMonday,
    this.disabledDate,
    this.validRange,
    this.min,
    this.max,
    this.minPage,
    this.maxPage,
    required this.calendarFormat,
    this.onFormatChanged,
    required this.showFormatSwitcher,
    required this.showModeSwitcher,
    this.mode,
    required this.initialMode,
    this.onModeChanged,
    this.onPanelChange,
    this.onPageChange,
    this.selectionMode,
    required this.allowClear,
    required this.multiSelect,
    this.selectedDays,
    required this.defaultSelectedDays,
    this.onSelectMulti,
    this.onRangeSelected,
    this.rangeValue,
    this.defaultRangeValue,
    this.onRangeChange,
    this.eventLoader,
    required this.showYearNavButtons,
    required this.enableYearMonthDropdown,
  });

  // ---- 值 / 选择 ----

  /// 受控选中日期（单选）。
  final DateTime? value;

  /// 非受控初始选中日期。
  final DateTime? defaultValue;

  /// 日期选中回调（兼容旧 API）。
  final ValueChanged<DateTime>? onSelect;

  /// 带来源的选中回调（antd v6 `onSelect(date, info)` 对齐）。
  /// 与 [onSelect] 同时触发，来源见 [AntCalendarSelectInfo.source]。
  final void Function(DateTime date, AntCalendarSelectInfo info)?
      onSelectWithInfo;

  /// 选中变化回调（allowClear 清除时为 null）。
  final ValueChanged<DateTime?>? onChange;

  // ---- 渲染回调 ----

  /// 日期单元格内容构建（dateCell，三层中优先级最低）。
  final AntCalendarDateCellBuilder? dateCell;

  /// 单元格内容渲染（cellRender，优先级高于 dateCell）。
  final AntCalendarCellRender? cellRender;

  /// 整格渲染（fullCellRender，最高优先级）。
  final AntCalendarFullCellRender? fullCellRender;

  /// 已废弃：antd v6 的 `dateCellRender`，桌面路径映射到 [cellRender]。
  final Widget? Function(DateTime date)? dateCellRender;

  /// 已废弃：antd v6 的 `dateFullCellRender`，桌面路径映射到 [fullCellRender]。
  final Widget? Function(DateTime date)? dateFullCellRender;

  /// 自定义头部（antd v6 `headerRender`，仅桌面渲染器生效）。
  final AntCalendarHeaderRender? headerRender;

  /// 是否展示周序号列（antd v6 `showWeek`，仅桌面渲染器生效）。
  final bool showWeek;

  /// 月面板单元格内容渲染。
  final AntCalendarMonthCellRender? monthCellRender;

  /// 月面板整格渲染。
  final AntCalendarMonthFullCellRender? monthFullCellRender;

  /// 日期数字位自定义渲染（antd-mobile renderDate）。
  final Widget? Function(DateTime date)? renderDate;

  /// 日卡子标题渲染（antd-mobile renderLabel）。
  final Widget? Function(DateTime date)? renderLabel;

  /// 移动端整格包裹渲染（antd-mobile cellRender 包裹语义）。
  final AntCalendarMobileCellRender? mobileCellRender;

  // ---- 范围 / 禁用 ----

  /// 周起始是否为周一（由 [AntCalendarWeekStartsOn] 归一化）。
  final bool weekStartsOnMonday;

  /// 日期禁用判定。
  final bool Function(DateTime date)? disabledDate;

  /// 有效日期范围。
  final AntCalendarValidRange? validRange;

  /// 最小可选日期。
  final DateTime? min;

  /// 最大可选日期。
  final DateTime? max;

  /// 面板导航最小年月页。
  final AntCalendarPage? minPage;

  /// 面板导航最大年月页。
  final AntCalendarPage? maxPage;

  // ---- 面板 / 格式 ----

  /// 可见格式（month / twoWeeks / week）。
  final AntCalendarFormat calendarFormat;

  /// 格式切换回调。
  final ValueChanged<AntCalendarFormat>? onFormatChanged;

  /// 是否展示格式切换按钮。
  final bool showFormatSwitcher;

  /// 是否展示月/年面板切换器（入口已按 `fullscreen/layout` 求值）。
  final bool showModeSwitcher;

  /// 受控面板模式。
  final AntCalendarMode? mode;

  /// 非受控初始面板模式。
  final AntCalendarMode initialMode;

  /// 面板模式变化回调。
  final ValueChanged<AntCalendarMode>? onModeChanged;

  /// 面板变化回调。
  final AntCalendarPanelChangeCallback? onPanelChange;

  /// 展示月份变化回调。
  final void Function(int year, int month)? onPageChange;

  // ---- 选择模式 ----

  /// 单选 / 范围选择；null 表示仅展示、不可点击。
  final AntCalendarSelectionMode? selectionMode;

  /// 点击已选日期是否清除选择。
  final bool allowClear;

  /// 是否多选（增强能力）。
  final bool multiSelect;

  /// 受控多选集合。
  final List<DateTime>? selectedDays;

  /// 非受控多选初始集合。
  final List<DateTime> defaultSelectedDays;

  /// 多选变化回调。
  final ValueChanged<List<DateTime>>? onSelectMulti;

  /// 范围选择完成回调。
  final void Function(DateTime start, DateTime end)? onRangeSelected;

  /// 受控范围值（长度 2、已排序；同日表示选择中）。
  final List<DateTime>? rangeValue;

  /// 非受控初始范围值（长度 2、已排序；同日表示选择中）。
  final List<DateTime>? defaultRangeValue;

  /// 范围值变化回调（选择中为 [date, date]，完成为 [begin, end]，
  /// 清空为 null）。
  final ValueChanged<List<DateTime>?>? onRangeChange;

  /// 事件点加载器。
  final List<DateTime> Function(DateTime day)? eventLoader;

  // ---- 头部 ----

  /// 是否展示年份导航按钮。
  final bool showYearNavButtons;

  /// 年月标题是否可点弹出快速跳转面板。
  final bool enableYearMonthDropdown;
}
