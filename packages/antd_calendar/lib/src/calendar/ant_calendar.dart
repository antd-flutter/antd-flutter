/// AntCalendar — antd React Calendar 的 Flutter 实现（双端形态 + 增强能力）。
///
/// 纯展示型日历面板，提供月视图网格（固定 6 行 7 列）、月份导航、
/// 日期选择、今天高亮、禁用日期与自定义单元格等能力。
///
/// 双端形态（经 [AntCalendarLayout] 自适应或手动指定）：
/// - fullscreen（桌面，参考 antd v6）：大格子 + dateCell 内容插槽 +
///   头部年月下拉快速跳转 + 月/年面板切换（mode/onPanelChange）；
/// - card（移动，参考 antd-mobile）：紧凑面板 + 滑动手势翻页 +
///   年导航按钮 + renderDate/renderLabel 分层渲染。
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
import 'package:antd_calendar/src/calendar/ant_calendar_locale.dart';
import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'package:antd_calendar/src/calendar/ant_calendar_controller.dart';
export 'package:antd_calendar/src/calendar/ant_calendar_locale.dart';
export 'package:antd_calendar/src/calendar/ant_calendar_types.dart';

/// 年月跳转面板的年份跨度（当前年前 [_kYearDropdownPastYears] 年，后 [_kYearDropdownFutureYears] 年）。
const int _kYearDropdownPastYears = 20;
const int _kYearDropdownFutureYears = 10;

/// 日期单元格下方最多展示的事件点数量。
const int _kMaxEventDots = 3;

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
    this.onChange,
    this.weekStartsOn = AntCalendarWeekStartsOn.monday,
    this.fullscreen = false,
    this.dateCell,
    this.cellRender,
    this.fullCellRender,
    this.monthCellRender,
    this.monthFullCellRender,
    this.disabledDate,
    this.validRange,
    this.min,
    this.max,
    this.minPage,
    this.maxPage,
    this.header,
    this.layout = AntCalendarLayout.auto,
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
    this.allowClear = false,
    this.selectionMode = AntCalendarSelectionMode.single,
    this.onRangeSelected,
    this.multiSelect = false,
    this.selectedDays,
    this.defaultSelectedDays = const [],
    this.onSelectMulti,
    this.eventLoader,
    this.showYearNavButtons = false,
    this.enableYearMonthDropdown = true,
    this.locale,
    this.controller,
  });

  /// 受控选中日期（单选模式）。
  final DateTime? value;

  /// 非受控初始选中日期。
  final DateTime? defaultValue;

  /// 日期被选中时的回调（所有选择模式下均触发，保持向后兼容；
  /// allowClear 清除选择时不触发）。
  final ValueChanged<DateTime>? onSelect;

  /// 选中变化回调（antd v6 onChange / antd-mobile onChange 对齐）：
  /// 单选选中时传日期，allowClear 清除时传 null；range/multi 模式
  /// 下传本次点击的日期。
  final ValueChanged<DateTime?>? onChange;

  /// 周起始日。
  final AntCalendarWeekStartsOn weekStartsOn;

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

  /// 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐）。
  final AntCalendarMonthCellRender? monthCellRender;

  /// 月面板整格渲染回调（antd v6 monthFullCellRender 对齐）。
  final AntCalendarMonthFullCellRender? monthFullCellRender;

  /// 判断日期是否不可选。
  final bool Function(DateTime date)? disabledDate;

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

  /// 自定义头部内容，为 null 时使用默认头部（年月标题 + 导航 + 本月按钮）。
  final Widget? header;

  /// 布局形态：auto 经 AntResponsive 自适应（desktop/web → fullscreen，
  /// phone/tablet → card），或手动强制 fullscreen/card。默认 auto。
  final AntCalendarLayout layout;

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

  /// 展示月份变化回调（antd-mobile onPageChange 对齐）。
  final void Function(int year, int month)? onPageChange;

  /// 日期数字位自定义渲染（antd-mobile renderDate 对齐），
  /// null 时渲染默认日期数字。
  final Widget? Function(DateTime date)? renderDate;

  /// 日卡子标题渲染（antd-mobile renderLabel 对齐，日期数字下方
  /// 子标题位，如农历/节日），null 时渲染事件点标记。
  final Widget? Function(DateTime date)? renderLabel;

  /// 点击已选日期是否清除选择（antd-mobile allowClear 对齐），
  /// 仅单选模式生效；清除时 [onChange] 收到 null、[onSelect] 不触发。
  final bool allowClear;

  /// 选择模式：单选或范围选择。
  final AntCalendarSelectionMode selectionMode;

  /// 范围选择完成回调（第二次点击结束时触发；start ≤ end）。
  final void Function(DateTime start, DateTime end)? onRangeSelected;

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
  DateTime? _internalValue;
  DateTime? _internalRangeStart;
  DateTime? _internalRangeEnd;
  List<DateTime> _internalSelectedDays = [];
  late DateTime _currentMonth;
  late DateTime _focusedDate;
  AntCalendarFormat? _internalFormat;
  AntCalendarMode? _internalMode;

  /// 当前生效的选中日期（去除时分秒后比较）。
  DateTime? get _selectedDate =>
      widget.value != null ? _dateOnly(widget.value!) : _internalValue;

  /// 当前生效的格式（受控优先）。
  AntCalendarFormat get _format =>
      _internalFormat ?? widget.calendarFormat;

  /// 当前生效的面板模式（受控优先，非受控取 initialMode）。
  AntCalendarMode get _mode =>
      _internalMode ?? widget.mode ?? widget.initialMode;

  /// 当前生效的国际化文案（参数优先，其次 Provider 注入，回退中文预设）。
  AntCalendarLocale get _locale =>
      widget.locale ?? AntCalendarLocale.of(context);

  /// 当前生效的布局形态。
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

  List<DateTime> get _multiSelected => (widget.selectedDays ?? _internalSelectedDays)
      .map(_dateOnly)
      .toList();

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    final initial = widget.value ??
        (widget.defaultValue) ??
        (widget.defaultSelectedDays.isNotEmpty
            ? widget.defaultSelectedDays.first
            : DateTime.now());
    _internalValue =
        widget.defaultValue != null ? _dateOnly(widget.defaultValue!) : null;
    _internalSelectedDays = List<DateTime>.from(
      widget.selectedDays ?? widget.defaultSelectedDays,
    ).map(_dateOnly).toList();
    _focusedDate = _dateOnly(initial);
    _currentMonth = DateTime(initial.year, initial.month);
  }

  @override
  void didUpdateWidget(covariant AntCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    if (widget.value != null && widget.value != oldWidget.value) {
      final v = widget.value!;
      _focusedDate = _dateOnly(v);
      _currentMonth = DateTime(v.year, v.month);
      if (widget.selectionMode == AntCalendarSelectionMode.range) {
        _internalRangeStart = _dateOnly(v);
        _internalRangeEnd = null;
      }
    }
    if (widget.calendarFormat != oldWidget.calendarFormat) {
      _internalFormat = null;
    }
    if (widget.mode != null && widget.mode != oldWidget.mode) {
      _internalMode = null;
    }
    if (widget.selectedDays != null &&
        widget.selectedDays != oldWidget.selectedDays) {
      _internalSelectedDays = List<DateTime>.from(
        widget.selectedDays!,
      ).map(_dateOnly).toList();
    }
  }

  DateTime _dateOnly(DateTime d) => calendarDateOnly(d);

  bool _isSameDay(DateTime? a, DateTime? b) => calendarIsSameDay(a, b);

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  bool _isDisabled(DateTime day) {
    if (widget.disabledDate?.call(day) ?? false) return true;
    if (widget.validRange != null && !widget.validRange!.contains(day)) {
      return true;
    }
    if (widget.min != null && day.isBefore(_dateOnly(widget.min!))) return true;
    if (widget.max != null && day.isAfter(_dateOnly(widget.max!))) return true;
    return false;
  }

  /// 月份是否被导航范围裁剪（validRange / minPage / maxPage 语义，
  /// 按月粒度：整月与允许范围无交集才禁止导航）。
  bool _isMonthBlocked(DateTime month) {
    if (widget.validRange != null) {
      final range = widget.validRange!;
      final monthStart = DateTime(month.year, month.month);
      final monthEnd = DateTime(month.year, month.month + 1, 0);
      if (monthEnd.isBefore(range.start) || monthStart.isAfter(range.end)) {
        return true;
      }
    }
    if (widget.minPage != null &&
        widget.minPage!.compareTo(month.year, month.month) > 0) {
      return true;
    }
    if (widget.maxPage != null &&
        widget.maxPage!.compareTo(month.year, month.month) < 0) {
      return true;
    }
    return false;
  }

  bool get _weekStartsOnMonday =>
      widget.weekStartsOn == AntCalendarWeekStartsOn.monday;

  /// 是否展示月/年面板切换器（null 时仅 fullscreen 展示）。
  bool get _showModeSwitcher =>
      widget.showModeSwitcher ??
      (widget.fullscreen ||
          widget.layout == AntCalendarLayout.fullscreen);

  /// 生成当前格式下的可见日期列表（网格计算委托 ui 日历网格引擎）。
  List<DateTime> _buildGridDays() {
    switch (_format) {
      case AntCalendarFormat.month:
        return buildCalendarMonthGrid(
          _currentMonth,
          weekStartsOnMonday: _weekStartsOnMonday,
        );
      case AntCalendarFormat.twoWeeks:
        return buildCalendarTwoWeeksGrid(
          _focusedDate,
          weekStartsOnMonday: _weekStartsOnMonday,
        );
      case AntCalendarFormat.week:
        return buildCalendarWeekGrid(
          _focusedDate,
          weekStartsOnMonday: _weekStartsOnMonday,
        );
    }
  }

  void _notifyPanelChanged(DateTime date, AntCalendarMode mode) {
    widget.onPanelChange?.call(date, mode);
    widget.onPageChange?.call(date.year, date.month);
  }

  void _onDayTap(DateTime day) {
    final dayOnly = _dateOnly(day);
    if (_isDisabled(dayOnly)) return;

    if (widget.multiSelect) {
      final next = List<DateTime>.from(_multiSelected);
      final existing = next.indexWhere((d) => _isSameDay(d, dayOnly));
      if (existing >= 0) {
        next.removeAt(existing);
      } else {
        next.add(dayOnly);
        next.sort((a, b) => a.compareTo(b));
      }
      if (widget.selectedDays == null) {
        setState(() => _internalSelectedDays = next);
      }
      widget.onSelectMulti?.call(next);
      widget.onSelect?.call(dayOnly);
      widget.onChange?.call(dayOnly);
      return;
    }

    if (widget.selectionMode == AntCalendarSelectionMode.range) {
      if (_internalRangeStart != null && _internalRangeEnd == null &&
          !_isSameDay(_internalRangeStart, dayOnly)) {
        final start = _internalRangeStart!;
        final end = dayOnly;
        final lo = start.isBefore(end) ? start : end;
        final hi = start.isBefore(end) ? end : start;
        if (widget.value == null) {
          setState(() {
            _internalRangeStart = lo;
            _internalRangeEnd = hi;
            _focusedDate = hi;
            _currentMonth = DateTime(hi.year, hi.month);
          });
        }
        widget.onSelect?.call(dayOnly);
        widget.onChange?.call(dayOnly);
        widget.onRangeSelected?.call(lo, hi);
        return;
      }
      // 开始新一轮范围选择。
      if (widget.value == null) {
        setState(() {
          _internalRangeStart = dayOnly;
          _internalRangeEnd = null;
        });
      } else {
        setState(() {});
      }
      widget.onSelect?.call(dayOnly);
      widget.onChange?.call(dayOnly);
      return;
    }

    // 单选模式：allowClear 支持点击已选日期清除选择。
    if (widget.allowClear && _isSameDay(_selectedDate, dayOnly)) {
      if (widget.value == null) {
        setState(() => _internalValue = null);
      }
      widget.onChange?.call(null);
      return;
    }

    if (widget.value == null) {
      setState(() {
        _internalValue = dayOnly;
        _focusedDate = dayOnly;
        _currentMonth = DateTime(dayOnly.year, dayOnly.month);
      });
    } else {
      // 受控模式：点击非本月日期同样切换展示月份以保持可见。
      setState(() {
        _focusedDate = dayOnly;
        _currentMonth = DateTime(dayOnly.year, dayOnly.month);
      });
    }
    widget.onSelect?.call(dayOnly);
    widget.onChange?.call(dayOnly);
  }

  void _setFormat(AntCalendarFormat format) {
    if (format == _format) return;
    setState(() => _internalFormat = format);
    widget.onFormatChanged?.call(format);
  }

  void _setMode(AntCalendarMode mode) {
    if (mode == _mode) return;
    if (widget.mode == null) {
      setState(() => _internalMode = mode);
    }
    widget.onModeChanged?.call(mode);
    widget.onPanelChange?.call(_focusedDate, mode);
  }

  void _goToMonth(int delta) {
    if (_format != AntCalendarFormat.month) {
      // week/twoWeeks 格式下按周步进导航。
      final step = _format == AntCalendarFormat.week
          ? kCalendarDaysPerWeek
          : kCalendarDaysPerWeek * 2;
      setState(() {
        _focusedDate = _focusedDate.add(Duration(days: delta * step));
        _currentMonth = DateTime(_focusedDate.year, _focusedDate.month);
      });
      _notifyPanelChanged(_focusedDate, _mode);
      return;
    }
    final target = DateTime(_currentMonth.year, _currentMonth.month + delta);
    if (_isMonthBlocked(target)) return;
    setState(() {
      _currentMonth = target;
      _focusedDate = DateTime(target.year, target.month, 1);
    });
    _notifyPanelChanged(_focusedDate, _mode);
  }

  void _goToYear(int delta) {
    final target = DateTime(_currentMonth.year + delta, _currentMonth.month);
    if (_isMonthBlocked(target)) return;
    setState(() {
      _currentMonth = target;
      _focusedDate = DateTime(target.year, target.month, 1);
    });
    _notifyPanelChanged(_focusedDate, _mode);
  }

  void _goToCurrentMonth() {
    final now = DateTime.now();
    setState(() {
      _currentMonth = DateTime(now.year, now.month);
      _focusedDate = _dateOnly(now);
    });
    _notifyPanelChanged(_currentMonth, _mode);
  }

  void _jumpToYearMonth(int year, int month) {
    final target = DateTime(year, month);
    if (_isMonthBlocked(target)) return;
    setState(() {
      _currentMonth = target;
      _focusedDate = DateTime(year, month, 1);
    });
    _notifyPanelChanged(target, _mode);
  }

  // AntCalendarMonthNavigator（AntCalendarController 程序化入口）。

  @override
  void navigateMonths(int delta) => _goToMonth(delta);

  @override
  void navigateToYearMonth(int year, int month) => _jumpToYearMonth(year, month);

  @override
  void navigateToToday() => _goToCurrentMonth();

  @override
  void dispose() {
    widget.controller?.detach(this);
    super.dispose();
  }

  /// 头部年月快速跳转面板（antd v6 行为，复用 AntPickerView 滚轮，
  /// 列文案走 locale yearLabel/monthLabel）。
  void _showYearMonthDropdown() {
    final t = AntTheme.of(context);
    final loc = widget.locale ?? AntCalendarLocale.of(context);
    final years = <AntPickerColumnItem>[
      for (var y = DateTime.now().year - _kYearDropdownPastYears;
          y <= DateTime.now().year + _kYearDropdownFutureYears;
          y++)
        AntPickerColumnItem(label: loc.yearLabel(y), value: '$y'),
    ];
    final months = <AntPickerColumnItem>[
      for (var m = 1; m <= 12; m++)
        AntPickerColumnItem(label: loc.monthLabel(m), value: '$m'),
    ];
    String? selectedYear = '${_currentMonth.year}';
    String? selectedMonth = '${_currentMonth.month}';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.colorBgContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.borderRadiusLG),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(sheetContext).pop(),
                      child: Text(
                        loc.effectiveCancelText,
                        style: TextStyle(
                          fontSize: t.fontSize,
                          color: t.colorText,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _jumpToYearMonth(
                          int.tryParse(selectedYear ?? '') ?? _currentMonth.year,
                          int.tryParse(selectedMonth ?? '') ?? _currentMonth.month,
                        );
                      },
                      child: Text(
                        loc.effectiveConfirmText,
                        style: TextStyle(
                          fontSize: t.fontSize,
                          color: t.colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AntPickerView(
                defaultValue: ['${_currentMonth.year}', '${_currentMonth.month}'],
                columns: [years, months],
                onChange: (vals) {
                  selectedYear = vals[0];
                  selectedMonth = vals.length > 1 ? vals[1] : null;
                },
                height: 200.h,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fullscreen = _isFullscreen(context);
    final days = _buildGridDays();
    final today = _dateOnly(DateTime.now());
    final weekLabels = _locale.weekLabelsFor(
      weekStartsOnMonday: _weekStartsOnMonday,
    );

    final body = _mode == AntCalendarMode.year
        ? _buildMonthPanel(t, fullscreen)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: fullscreen ? 8.w : 4.w),
                child: Row(
                  children: weekLabels
                      .map(
                        (label) => Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize:
                                    fullscreen ? t.fontSize : t.fontSizeSM,
                                color: t.colorTextSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // 移动（card）形态支持左右滑动手势翻页（antd-mobile 惯例）。
              fullscreen
                  ? _buildDayGrid(t, days, today, fullscreen)
                  : GestureDetector(
                      onHorizontalDragEnd: (details) {
                        final v = details.primaryVelocity ?? 0;
                        if (v < 0) {
                          _goToMonth(1);
                        } else if (v > 0) {
                          _goToMonth(-1);
                        }
                      },
                      child: _buildDayGrid(t, days, today, fullscreen),
                    ),
            ],
          );

    return Container(
      padding: EdgeInsets.all(fullscreen ? 8.w : 4.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.header != null)
            widget.header!
          else
            _buildHeader(t, fullscreen),
          body,
        ],
      ),
    );
  }

  Widget _buildDayGrid(
    AntThemeData t,
    List<DateTime> days,
    DateTime today,
    bool fullscreen,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        (days.length / kCalendarDaysPerWeek).ceil(),
        (row) => Row(
          children: List.generate(kCalendarDaysPerWeek, (col) {
            final day = days[row * kCalendarDaysPerWeek + col];
            return Expanded(
              child: _buildDayCell(t, _dateOnly(day), today, fullscreen),
            );
          }),
        ),
      ),
    );
  }

  /// 默认头部：年导航 + 月导航 + 年月标题（可点跳转）+ 模式切换 +
  /// 格式切换 + 「本月」按钮。
  Widget _buildHeader(AntThemeData t, bool fullscreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
      child: Row(
        children: [
          if (widget.showYearNavButtons)
            _buildNavIcon(
              t,
              AntIcons.doubleLeftOutlined,
              () => _goToYear(-1),
            ),
          _buildNavIcon(t, AntIcons.leftOutlined, () => _goToMonth(-1)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap:
                      widget.enableYearMonthDropdown ? _showYearMonthDropdown : null,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _locale.monthTitle(_currentMonth.year, _currentMonth.month),
                          style: TextStyle(
                            fontSize: t.fontSizeLG,
                            fontWeight: FontWeight.w600,
                            color: t.colorText,
                          ),
                        ),
                        if (widget.enableYearMonthDropdown) ...[
                          SizedBox(width: 2.w),
                          Icon(
                            AntIcons.downOutlined,
                            size: 16.w,
                            color: t.colorTextSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_showModeSwitcher) ...[
                  SizedBox(width: 8.w),
                  _buildModeSwitcher(t),
                ],
              ],
            ),
          ),
          if (widget.showFormatSwitcher) _buildFormatSwitcher(t),
          GestureDetector(
            onTap: _goToCurrentMonth,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              child: Text(
                _locale.effectiveTodayText,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorPrimary,
                ),
              ),
            ),
          ),
          _buildNavIcon(t, AntIcons.rightOutlined, () => _goToMonth(1)),
          if (widget.showYearNavButtons)
            _buildNavIcon(
              t,
              AntIcons.doubleRightOutlined,
              () => _goToYear(1),
            ),
        ],
      ),
    );
  }

  /// 月/年面板切换器（antd v6 头部 Radio 对齐）。
  Widget _buildModeSwitcher(AntThemeData t) {
    final items = {
      AntCalendarMode.month: _locale.effectiveModeMonthText,
      AntCalendarMode.year: _locale.effectiveModeYearText,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.entries.map((entry) {
        final active = entry.key == _mode;
        return GestureDetector(
          onTap: () => _setMode(entry.key),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: active ? t.colorPrimary : Colors.transparent,
              borderRadius: BorderRadius.horizontal(
                left: entry.key == AntCalendarMode.month
                    ? Radius.circular(t.borderRadiusSM)
                    : Radius.zero,
                right: entry.key == AntCalendarMode.year
                    ? Radius.circular(t.borderRadiusSM)
                    : Radius.zero,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: active ? Colors.white : t.colorTextSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavIcon(AntThemeData t, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 20.w, color: t.colorText),
      ),
    );
  }

  /// 格式切换按钮组（月 / 两周 / 周，table_calendar onFormatChanged 对齐）。
  Widget _buildFormatSwitcher(AntThemeData t) {
    const labels = {
      AntCalendarFormat.month: '月',
      AntCalendarFormat.twoWeeks: '两周',
      AntCalendarFormat.week: '周',
    };
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: labels.entries.map((entry) {
          final active = entry.key == _format;
          return GestureDetector(
            onTap: () => _setFormat(entry.key),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: active ? t.colorPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(t.borderRadiusSM),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: active ? Colors.white : t.colorTextSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 年面板：12 个月单元格网格（antd v6 year mode 对齐）。
  Widget _buildMonthPanel(AntThemeData t, bool fullscreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 3; row++)
          Row(
            children: [
              for (var col = 0; col < 4; col++)
                Expanded(
                  child: _buildMonthCell(
                    t,
                    DateTime(_currentMonth.year, row * 4 + col + 1),
                    fullscreen,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildMonthCell(AntThemeData t, DateTime month, bool fullscreen) {
    final disabled = _isMonthBlocked(month) ||
        (widget.min != null &&
            month.isBefore(DateTime(widget.min!.year, widget.min!.month))) ||
        (widget.max != null &&
            month.isAfter(DateTime(widget.max!.year, widget.max!.month)));
    final isCurrent = _isSameMonth(month, DateTime.now());

    Widget content = widget.monthFullCellRender?.call(month) ??
        Container(
          margin: EdgeInsets.all(4.w),
          constraints: BoxConstraints(minHeight: fullscreen ? 64.w : 36.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.borderRadiusSM),
            border: Border.all(
              color: isCurrent ? t.colorPrimary : t.colorSplit,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: widget.monthCellRender?.call(month) ??
              Text(
                _locale.monthLabel(month.month),
                style: TextStyle(
                  fontSize: fullscreen ? t.fontSizeLG : t.fontSize,
                  fontWeight: FontWeight.w500,
                  color: disabled
                      ? t.colorTextDisabled
                      : isCurrent
                          ? t.colorPrimary
                          : t.colorText,
                ),
              ),
        );

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              _jumpToYearMonth(month.year, month.month);
              _setMode(AntCalendarMode.month);
            },
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }

  List<DateTime> _eventsOf(DateTime day) =>
      widget.eventLoader?.call(day) ?? const [];

  Widget _buildDayCell(
    AntThemeData t,
    DateTime day,
    DateTime today,
    bool fullscreen,
  ) {
    final isCurrentMonth =
        day.month == _currentMonth.month && day.year == _currentMonth.year;
    final isToday = _isSameDay(day, today);
    final events = _eventsOf(day);

    final isSelected = switch (widget.selectionMode) {
      AntCalendarSelectionMode.range =>
        _isSameDay(day, _internalRangeStart) ||
            _isSameDay(day, _internalRangeEnd),
      _ =>
        widget.multiSelect
            ? _multiSelected.any((d) => _isSameDay(d, day))
            : _isSameDay(day, _selectedDate),
    };
    final isInRange = widget.selectionMode == AntCalendarSelectionMode.range &&
        _internalRangeStart != null &&
        _internalRangeEnd != null &&
        day.isAfter(_internalRangeStart!) &&
        day.isBefore(_internalRangeEnd!);
    final isRangePending = widget.selectionMode == AntCalendarSelectionMode.range &&
        _internalRangeStart != null &&
        _internalRangeEnd == null;

    final disabled = _isDisabled(day);
    final info = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: isSelected,
      isCurrentMonth: isCurrentMonth,
      isDisabled: disabled,
      isInValidRange: widget.validRange?.contains(day) ?? true,
    );

    Color textColor;
    Color? bgColor;
    if (disabled) {
      textColor = t.colorTextDisabled;
    } else if (isSelected) {
      textColor = Colors.white;
      bgColor = t.colorPrimary;
    } else if (isInRange) {
      textColor = t.colorPrimary;
      bgColor = t.colorPrimary.withValues(alpha: 0.1);
    } else if (isToday) {
      textColor = t.colorPrimary;
    } else if (!isCurrentMonth) {
      textColor = t.colorTextQuaternary;
    } else {
      textColor = t.colorText;
    }

    Widget content = widget.cellRender?.call(day, info) ??
        widget.dateCell?.call(
          day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: isSelected,
        ) ??
        _buildDefaultCellContent(
          t,
          day,
          textColor,
          isCurrentMonth,
          events,
          fullscreen,
        );

    Widget cell = Container(
      margin: EdgeInsets.all(fullscreen ? 2.w : 1.w),
      constraints: BoxConstraints(
        // card 形态对齐 antd-mobile 单元格比例（约 44 高 / 53 宽），
        // fullscreen 形态对齐 antd v6 大格子。
        minHeight: fullscreen ? 72.w : 44.w,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          fullscreen ? t.borderRadiusSM : t.borderRadius,
        ),
        border: (isToday && !isSelected) ||
                (isRangePending && _isSameDay(day, _internalRangeStart))
            ? Border.all(color: t.colorPrimary, width: 1)
            : null,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: fullscreen ? 4.w : 0,
      ),
      child: content,
    );

    // fullCellRender 整格接管（antd v6 fullCellRender 对齐），
    // 点击仍由组件统一处理。
    final rendered = widget.fullCellRender?.call(day, info);
    if (rendered != null) cell = rendered;

    return GestureDetector(
      onTap: disabled ? null : () => _onDayTap(day),
      behavior: HitTestBehavior.opaque,
      child: cell,
    );
  }

  /// 默认单元格内容：日期数字（renderDate 可覆盖）+ 子标题
  /// （renderLabel / 事件点标记）。
  Widget _buildDefaultCellContent(
    AntThemeData t,
    DateTime day,
    Color textColor,
    bool isCurrentMonth,
    List<DateTime> events,
    bool fullscreen,
  ) {
    final Widget? subtitle = widget.renderLabel?.call(day) ??
        (events.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: fullscreen ? 4.w : 1.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < events.length && i < _kMaxEventDots; i++)
                      Container(
                        width: fullscreen ? 6.w : 3.w,
                        height: fullscreen ? 6.w : 3.w,
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          color: textColor == Colors.white
                              ? Colors.white
                              : t.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              )
            : fullscreen
                ? SizedBox(height: 4.w)
                : null);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.renderDate?.call(day) ??
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: fullscreen ? t.fontSizeXL : t.fontSizeSM,
                color: fullscreen && !isCurrentMonth
                    ? t.colorTextDisabled
                    : textColor,
                fontWeight: fullscreen ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
        if (subtitle != null) subtitle,
      ],
    );
  }
}
