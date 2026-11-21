/// AntCalendar — antd React Calendar 的 Flutter 实现（双端形态 + 增强能力）。
///
/// 纯展示型日历面板，提供月视图网格（固定 6 行 7 列）、月份导航、
/// 日期选择、今天高亮、禁用日期与自定义单元格等能力。
///
/// 双端形态（经 [AntCalendarLayout] 自适应或手动指定）：
/// - fullscreen（桌面，参考 antd v6）：大格子 + dateCell 内容插槽 +
///   头部年月下拉快速跳转 + 月/年面板切换（mode/onPanelChange）；
/// - card（移动，参考 antd-mobile v5）：居中月份标题 + 四向箭头翻页 +
///   renderDate/renderLabel/mobileCellRender 分层渲染。
///   扩展能力（week/twoWeeks、multiSelect、eventLoader、格式/模式切换）
///   仍可用，但仅在参数启用时走兼容渲染分支。
///
/// 增强能力（吸收 table_calendar 3.3.0，Apache-2.0 源码研究改造）：
/// - 格式切换：month / twoWeeks / week（[AntCalendarFormat]）；
/// - range 范围选择与 multiSelect 多选；
/// - 事件点标记（[AntCalendar.eventLoader]）；
/// - 头部年月文字可点弹出年月选择面板（内部复用 AntPickerView）。
///
/// 全量功能对齐（桌面 antd v6 + 移动 antd-mobile v5）：
/// - 三层自定义渲染：cellRender / fullCellRender / dateCell；
/// - 月面板自定义：monthCellRender / monthFullCellRender；
/// - validRange 有效范围、min/max、minPage/maxPage 导航裁剪；
/// - mode 受控（month/year 面板）+ onPanelChange；
/// - onChange 受控回调 + allowClear 清除选择。
///
/// ```dart
/// AntCalendar(
///   defaultValue: DateTime(2024, 6, 1),
///   onSelect: (date) => print(date),
/// )
/// ```
library;

import 'package:antd_calendar/src/calendar/ant_calendar_controller.dart';
import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_core_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_locale.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_state.dart';
import 'package:antd_calendar/src/calendar/desktop/ant_calendar_desktop.dart';
import 'package:antd_calendar/src/calendar/mobile/ant_calendar_mobile.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/widgets.dart';

export 'package:antd_calendar/src/calendar/ant_calendar_controller.dart';
export 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
export 'package:antd_calendar/src/calendar/calendar_core/calendar_locale.dart';

/// 日历 — 纯展示型日历面板（双端形态 + 增强能力）。
///
/// 对齐 antd React Calendar 核心 API，向后兼容既有
/// value/defaultValue/onSelect/weekStartsOn/disabledDate/dateCell/fullscreen/card
/// 等参数。
class AntCalendar extends StatefulWidget {
  const AntCalendar({
    super.key,
    this.value,
    this.defaultValue,
    this.onSelect,
    this.onSelectWithInfo,
    this.onChange,
    this.weekStartsOn,
    this.fullscreen = false,
    this.dateCell,
    this.cellRender,
    this.fullCellRender,
    this.headerRender,
    this.showWeek = false,
    @Deprecated('Use cellRender instead (antd v6)') this.dateCellRender,
    @Deprecated('Use fullCellRender instead (antd v6)') this.dateFullCellRender,
    this.monthCellRender,
    this.monthFullCellRender,
    this.disabledDate,
    this.shouldDisableDate,
    this.validRange,
    this.min,
    this.max,
    this.minPage,
    this.maxPage,
    this.header,
    this.layout = AntCalendarLayout.auto,
    this.platform = AntCalendarPlatform.auto,
    this.calendarFormat = AntCalendarFormat.month,
    this.onFormatChanged,
    this.showFormatSwitcher = false,
    this.showModeSwitcher,
    this.mode,
    this.initialMode = AntCalendarMode.month,
    this.onModeChanged,
    this.onPanelChange,
    this.onPageChange,
    this.renderDate,
    this.renderLabel,
    this.mobileCellRender,
    this.allowClear,
    this.selectionMode = AntCalendarSelectionMode.single,
    this.onRangeSelected,
    this.rangeValue,
    this.defaultRangeValue,
    this.onRangeChange,
    this.prevYearButton =
        const AntCalendarBuiltInNavButton(AntIcons.doubleLeftOutlined),
    this.prevMonthButton =
        const AntCalendarBuiltInNavButton(AntIcons.leftOutlined),
    this.nextMonthButton =
        const AntCalendarBuiltInNavButton(AntIcons.rightOutlined),
    this.nextYearButton =
        const AntCalendarBuiltInNavButton(AntIcons.doubleRightOutlined),
    this.multiSelect = false,
    this.selectedDays,
    this.defaultSelectedDays = const [],
    this.onSelectMulti,
    this.eventLoader,
    this.showYearNavButtons = false,
    this.enableYearMonthDropdown = true,
    this.locale,
    this.controller,
  })  : assert(
          rangeValue == null || rangeValue.length == 2,
          'rangeValue 必须是长度为 2 的列表',
        ),
        assert(
          defaultRangeValue == null || defaultRangeValue.length == 2,
          'defaultRangeValue 必须是长度为 2 的列表',
        ),
        assert(
          rangeValue == null ||
              selectionMode == AntCalendarSelectionMode.range ||
              selectionMode == null,
          'rangeValue 仅 range 模式可用',
        ),
        assert(
          defaultRangeValue == null ||
              selectionMode == AntCalendarSelectionMode.range ||
              selectionMode == null,
          'defaultRangeValue 仅 range 模式可用',
        ),
        assert(
          rangeValue == null || platform != AntCalendarPlatform.desktop,
          'rangeValue 仅移动端渲染器支持',
        ),
        assert(
          defaultRangeValue == null || platform != AntCalendarPlatform.desktop,
          'defaultRangeValue 仅移动端渲染器支持',
        );

  /// 受控选中日期（单选模式）。
  final DateTime? value;

  /// 非受控初始选中日期。
  final DateTime? defaultValue;

  /// 日期被选中时的回调（所有选择模式下均触发，保持向后兼容；
  /// allowClear 清除选择时不触发）。
  final ValueChanged<DateTime>? onSelect;

  /// 带选择来源的选中回调（antd v6 `onSelect(date, info)` 对齐）：
  /// [AntCalendarSelectInfo.source] 区分日期点击 / 年下拉 / 月下拉 /
  /// 自定义头部；与 [onSelect] 同时触发，二者可任选其一使用。
  final void Function(DateTime date, AntCalendarSelectInfo info)?
      onSelectWithInfo;

  /// 选中变化回调（antd v6 onChange / antd-mobile onChange 对齐）：
  /// 单选选中时传日期，allowClear 清除时传 null；range/multi 模式
  /// 下传本次点击的日期。
  final ValueChanged<DateTime?>? onChange;

  /// 周起始日；null 时默认 **周日**（antd v6 / antd-mobile v5 双端默认）。
  /// 如需周一起始显式传 [AntCalendarWeekStartsOn.monday]。
  final AntCalendarWeekStartsOn? weekStartsOn;

  /// 是否全屏模式（大格子），默认 false 为 card 紧凑模式。
  ///
  /// 兼容参数：true 时强制 fullscreen 形态（优先级高于 [layout]）。
  final bool fullscreen;

  /// 自定义日期单元格内容渲染回调（三层：fullCellRender > cellRender >
  /// dateCell > 默认），返回 null 时回退下一层。
  final AntCalendarDateCellBuilder? dateCell;

  /// 单元格内容渲染回调（antd v6 cellRender 对齐，带状态 info；
  /// 优先级高于 [dateCell]）。
  final AntCalendarCellRender? cellRender;

  /// 整格渲染回调（antd v6 fullCellRender 对齐）：完全接管单元格
  /// 渲染（含背景/边框/选择态视觉，点击仍由组件处理）。
  final AntCalendarFullCellRender? fullCellRender;

  /// 自定义头部渲染（antd v6 `headerRender` 对齐，仅桌面渲染器生效）：
  /// 传 null 时使用桌面默认头部（年/月下拉 + 月年模式切换）；
  /// 优先级高于 [header]。
  final AntCalendarHeaderRender? headerRender;

  /// 是否展示周序号列（antd v6 `showWeek` 对齐，仅桌面渲染器生效）。
  final bool showWeek;

  /// 已废弃：请使用 [cellRender]（antd v6 将 dateCellRender 并入
  /// cellRender，原有 dateCell 插槽继续可用）。
  @Deprecated('Use cellRender instead (antd v6)')
  final Widget? Function(DateTime date)? dateCellRender;

  /// 已废弃：请使用 [fullCellRender]（antd v6 将 dateFullCellRender
  /// 并入 fullCellRender）。
  @Deprecated('Use fullCellRender instead (antd v6)')
  final Widget? Function(DateTime date)? dateFullCellRender;

  /// 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐）。
  final AntCalendarMonthCellRender? monthCellRender;

  /// 月面板整格渲染回调（antd v6 monthFullCellRender 对齐）。
  final AntCalendarMonthFullCellRender? monthFullCellRender;

  /// 判断日期是否不可选。
  final bool Function(DateTime date)? disabledDate;

  /// [disabledDate] 的别名（antd-mobile `shouldDisableDate` 对齐）：
  /// 两者任一命中即禁用；与 min/max/validRange 叠加生效。
  final bool Function(DateTime date)? shouldDisableDate;

  /// 有效日期范围（antd v6 validRange 对齐）：范围外日期不可交互，
  /// 面板导航裁剪在范围内。
  final AntCalendarValidRange? validRange;

  /// 最小可选日期（antd-mobile min 对齐）。
  final DateTime? min;

  /// 最大可选日期（antd-mobile max 对齐）。
  final DateTime? max;

  /// 面板导航最小年月页（antd-mobile minPage 对齐）。
  final AntCalendarPage? minPage;

  /// 面板导航最大年月页（antd-mobile maxPage 对齐）。
  final AntCalendarPage? maxPage;

  /// 自定义头部内容，为 null 时使用默认头部
  /// （移动端：居中月份标题 + 四向箭头；桌面端：年月下拉 + 模式切换）。
  final Widget? header;

  /// 布局形态：auto 经 AntResponsive 自适应（desktop/web → fullscreen，
  /// phone/tablet → card），或手动强制 fullscreen/card。默认 auto。
  final AntCalendarLayout layout;

  /// 平台渲染器选择：auto 按 [AntPlatform] 分派（mobile → 移动渲染器，
  /// 其余 → 桌面渲染器）；desktop/mobile 可强制指定。默认 auto。
  final AntCalendarPlatform platform;

  /// 可见格式：month / twoWeeks / week（table_calendar calendarFormat 对齐）。
  final AntCalendarFormat calendarFormat;

  /// 格式切换回调。
  final ValueChanged<AntCalendarFormat>? onFormatChanged;

  /// 是否在头部展示格式切换按钮（可隐藏，默认 false）。
  final bool showFormatSwitcher;

  /// 是否展示月/年面板切换器（antd v6 头部 Radio 对齐）；
  /// null 时仅在 fullscreen 形态展示。
  final bool? showModeSwitcher;

  /// 受控面板模式（month / year 面板；R35 受控语义：非 null 时以参数为准）。
  final AntCalendarMode? mode;

  /// 非受控初始面板模式（默认 month）。
  final AntCalendarMode initialMode;

  /// 面板模式变化回调。
  final ValueChanged<AntCalendarMode>? onModeChanged;

  /// 面板变化回调（antd v6 onPanelChange 对齐）：
  /// 展示月份变化或面板模式切换时触发。
  final AntCalendarPanelChangeCallback? onPanelChange;

  /// 展示月份变化回调（antd-mobile onPageChange 对齐）：
  /// 仅在翻页/跳转后触发，初始渲染不触发（对齐 useUpdateEffect）。
  final void Function(int year, int month)? onPageChange;

  /// 日期数字位自定义渲染（antd-mobile renderDate 对齐），
  /// null 时渲染默认日期数字。
  final Widget? Function(DateTime date)? renderDate;

  /// 日卡子标题渲染（antd-mobile renderLabel 对齐，日期数字下方
  /// 子标题位，如农历/节日）；null 时移动默认路径留空，兼容分支
  /// （启用 [eventLoader]）降级为事件点标记。
  final Widget? Function(DateTime date)? renderLabel;

  // ---- 移动端专属：整格包裹渲染（C3） ----

  /// 移动端整格包裹渲染（C3 新增，antd-mobile `cellRender` 包裹语义）：
  /// 与桌面替换式 [cellRender] 不同，本回调接收默认单元格后包裹返回，
  /// 点击仍由组件统一处理。用于给整格加边框/角标/自定义布局。
  final AntCalendarMobileCellRender? mobileCellRender;

  /// 点击已选日期是否清除选择（antd-mobile allowClear 对齐），
  /// 单选与范围模式生效；清除时 [onChange] 收到 null、[onSelect] 不触发。
  /// null 时按渲染器取默认：移动端 true、桌面 false。
  final bool? allowClear;

  /// 选择模式：单选 / 范围选择；null 表示仅展示、不可点击
  /// （此时 [allowClear] 等选择语义均不生效）。
  final AntCalendarSelectionMode? selectionMode;

  /// 范围选择完成回调（第二次点击结束时触发；start ≤ end）。
  final void Function(DateTime start, DateTime end)? onRangeSelected;

  // ---- 移动端专属：范围值（C3，受控/非受控） ----

  /// 受控范围值（移动端 range 模式）：长度 2、已排序；
  /// `[date, date]` 表示「已选起点、待选终点」，传 null 表示未选择。
  final List<DateTime>? rangeValue;

  /// 非受控初始范围值（长度 2、已排序）。
  final List<DateTime>? defaultRangeValue;

  /// 范围值变化回调（移动端 range 模式）：选择中回传 `[date, date]`，
  /// 完成回传 `[begin, end]`，清空回传 null；与 [onChange] 同时派发。
  final ValueChanged<List<DateTime>?>? onRangeChange;

  // ---- 移动端专属：头部四向导航按钮（C3） ----

  /// 上一年按钮；null 隐藏，默认内置双左箭头。
  final Widget? prevYearButton;

  /// 上一月按钮；null 隐藏，默认内置左箭头。
  final Widget? prevMonthButton;

  /// 下一月按钮；null 隐藏，默认内置右箭头。
  final Widget? nextMonthButton;

  /// 下一年按钮；null 隐藏，默认内置双右箭头。
  final Widget? nextYearButton;

  /// 是否多选模式（与 range 互斥，multiSelect 优先）。
  final bool multiSelect;

  /// 受控多选日期集合。
  final List<DateTime>? selectedDays;

  /// 非受控多选初始集合。
  final List<DateTime> defaultSelectedDays;

  /// 多选变化回调。
  final ValueChanged<List<DateTime>>? onSelectMulti;

  /// 事件加载器：返回某日期关联的事件列表，日期下方渲染小圆点标记
  /// （table_calendar eventLoader 对齐）。
  final List<DateTime> Function(DateTime day)? eventLoader;

  /// 是否展示年份导航按钮（双箭头，antd-mobile prevYearButton/
  /// nextYearButton 对齐），默认 false。
  final bool showYearNavButtons;

  /// 头部年月文字是否可点弹出年月快速跳转面板（antd v6 行为，默认 true）。
  final bool enableYearMonthDropdown;

  /// 国际化文案；null 时经 [AntCalendarLocaleProvider] 注入读取，仍未注入回退中文预设。
  final AntCalendarLocale? locale;

  /// 程序化控制器（R35.2 Controller 优先）：经 [AntCalendarController
  /// .previousMonth]/[AntCalendarController.nextMonth]/
  /// [AntCalendarController.goToYearMonth]/[AntCalendarController.jumpToToday]
  /// 程序化翻页与跳转。
  final AntCalendarController? controller;

  @override
  State<AntCalendar> createState() => _AntCalendarState();
}

class _AntCalendarState extends State<AntCalendar>
    implements AntCalendarMonthNavigator {
  late AntCalendarCoreState _core;

  @override
  void initState() {
    super.initState();
    _core = AntCalendarCoreState(config: _coreConfig());
    _core.addListener(_onCoreChanged);
    widget.controller?.attach(this);
  }

  @override
  void didUpdateWidget(covariant AntCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    _core.updateConfig(_coreConfig());
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _core.removeListener(_onCoreChanged);
    _core.dispose();
    super.dispose();
  }

  void _onCoreChanged() {
    if (mounted) setState(() {});
  }

  /// 把公开参数归一化为共享状态机配置（构造参数不变）。
  AntCalendarCoreConfig _coreConfig() {
    final isDesktop = _isDesktopPlatform;
    final bool weekStartsOnMonday;
    switch (widget.weekStartsOn) {
      case AntCalendarWeekStartsOn.monday:
        weekStartsOnMonday = true;
      case AntCalendarWeekStartsOn.sunday:
        weekStartsOnMonday = false;
      case null:
        // 双端 antd 默认：周日为一周起始（antd v6 / antd-mobile v5）。
        weekStartsOnMonday = false;
    }
    final disabledDate = _combinedDisabledDate();
    return AntCalendarCoreConfig(
      value: widget.value,
      defaultValue: widget.defaultValue,
      onSelect: widget.onSelect,
      onSelectWithInfo: widget.onSelectWithInfo,
      onChange: widget.onChange,
      dateCell: widget.dateCell,
      cellRender: widget.cellRender,
      fullCellRender: widget.fullCellRender,
      dateCellRender: widget.dateCellRender,
      dateFullCellRender: widget.dateFullCellRender,
      headerRender: widget.headerRender,
      showWeek: widget.showWeek,
      monthCellRender: widget.monthCellRender,
      monthFullCellRender: widget.monthFullCellRender,
      renderDate: widget.renderDate,
      renderLabel: widget.renderLabel,
      mobileCellRender: widget.mobileCellRender,
      weekStartsOnMonday: weekStartsOnMonday,
      disabledDate: disabledDate,
      validRange: widget.validRange,
      min: widget.min,
      max: widget.max,
      minPage: widget.minPage,
      maxPage: widget.maxPage,
      calendarFormat: widget.calendarFormat,
      onFormatChanged: widget.onFormatChanged,
      showFormatSwitcher: widget.showFormatSwitcher,
      // 兼容语义：showModeSwitcher 未显式指定时，桌面渲染器恒展示
      // （card 形态也保留月/年切换）；移动渲染器沿用 fullscreen 判定。
      showModeSwitcher: widget.showModeSwitcher ??
          (_isDesktopPlatform
              ? true
              : (widget.fullscreen ||
                  widget.layout == AntCalendarLayout.fullscreen)),
      mode: widget.mode,
      initialMode: widget.initialMode,
      onModeChanged: widget.onModeChanged,
      onPanelChange: widget.onPanelChange,
      onPageChange: widget.onPageChange,
      selectionMode: widget.selectionMode,
      allowClear: widget.allowClear ?? !isDesktop,
      multiSelect: widget.multiSelect,
      selectedDays: widget.selectedDays,
      defaultSelectedDays: widget.defaultSelectedDays,
      onSelectMulti: widget.onSelectMulti,
      onRangeSelected: widget.onRangeSelected,
      rangeValue: _normalizeRange(widget.rangeValue),
      defaultRangeValue: _normalizeRange(widget.defaultRangeValue),
      onRangeChange: widget.onRangeChange,
      eventLoader: widget.eventLoader,
      showYearNavButtons: widget.showYearNavButtons,
      enableYearMonthDropdown: widget.enableYearMonthDropdown,
    );
  }

  /// 合并 [AntCalendar.disabledDate] 与 [AntCalendar.shouldDisableDate] 别名。
  bool Function(DateTime)? _combinedDisabledDate() {
    final disabledDate = widget.disabledDate;
    final shouldDisableDate = widget.shouldDisableDate;
    if (disabledDate == null) return shouldDisableDate;
    if (shouldDisableDate == null) return disabledDate;
    return (date) => disabledDate(date) || shouldDisableDate(date);
  }

  /// 范围值去时分秒并按时间排序（长度 2 已由构造断言保证）。
  List<DateTime>? _normalizeRange(List<DateTime>? value) {
    if (value == null) return null;
    return value
        .map((date) => DateTime(date.year, date.month, date.day))
        .toList()
      ..sort((a, b) => a.compareTo(b));
  }

  /// 是否走桌面渲染器（与 build 中 platform 解析保持一致）。
  bool get _isDesktopPlatform {
    switch (widget.platform) {
      case AntCalendarPlatform.desktop:
        return true;
      case AntCalendarPlatform.mobile:
        return false;
      case AntCalendarPlatform.auto:
        return !AntPlatform.isMobile;
    }
  }

  /// 当前生效的布局形态（C1 保持旧 fullscreen/layout 语义）。
  bool _isFullscreen(BuildContext context) {
    if (widget.fullscreen) return true;
    switch (widget.layout) {
      case AntCalendarLayout.fullscreen:
        return true;
      case AntCalendarLayout.card:
        return false;
      case AntCalendarLayout.auto:
        // 无 AntResponsive 包裹（纯 flutter_test 环境）时回退为 web 桌面形态。
        final deviceType =
            AntResponsive.maybeOf(context)?.deviceType ?? AntDeviceType.web;
        return deviceType == AntDeviceType.desktop ||
            deviceType == AntDeviceType.web;
    }
  }

  @override
  void navigateMonths(int delta) => _core.goToMonth(delta);

  @override
  void navigateToYearMonth(int year, int month) =>
      _core.jumpToYearMonth(year, month);

  @override
  void navigateToToday() => _core.goToToday();

  @override
  Widget build(BuildContext context) {
    final fullscreen = _isFullscreen(context);
    final locale = widget.locale ?? AntCalendarLocale.of(context);
    final platform = widget.platform == AntCalendarPlatform.auto
        ? (AntPlatform.isMobile
            ? AntCalendarPlatform.mobile
            : AntCalendarPlatform.desktop)
        : widget.platform;

    if (platform == AntCalendarPlatform.mobile) {
      return AntCalendarMobile(
        core: _core,
        fullscreen: fullscreen,
        locale: locale,
        header: widget.header,
        prevYearButton: widget.prevYearButton,
        prevMonthButton: widget.prevMonthButton,
        nextMonthButton: widget.nextMonthButton,
        nextYearButton: widget.nextYearButton,
      );
    }
    return AntCalendarDesktop(
      core: _core,
      fullscreen: fullscreen,
      locale: locale,
      header: widget.header,
    );
  }
}
