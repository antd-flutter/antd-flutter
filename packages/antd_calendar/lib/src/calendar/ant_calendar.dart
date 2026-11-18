/// AntCalendar — antd React Calendar 的 Flutter 实现（双端形态 + 增强能力）。
///
/// 纯展示型日历面板，提供月视图网格（固定 6 行 7 列）、月份导航、
/// 日期选择、今天高亮、禁用日期与自定义单元格等能力。
///
/// 双端形态（经 [AntCalendarLayout] 自适应或手动指定）：
/// - fullscreen（桌面，参考 antd v6）：大格子 + dateCell 内容插槽 +
///   头部年月下拉快速跳转；
/// - card（移动，参考 antd-mobile）：紧凑面板 + 滑动手势翻页。
///
/// 增强能力（吸收 table_calendar 3.3.0，Apache-2.0 源码研究改造）：
/// - 格式切换：month / twoWeeks / week（[AntCalendarFormat]）；
/// - range 范围选择与 multiSelect 多选；
/// - 事件点标记（[AntCalendar.eventLoader]）；
/// - 头部年月文字可点弹出年月选择面板（内部复用 AntPickerView）。
///
/// ```dart
/// AntCalendar(
///   defaultValue: DateTime(2024, 6, 1),
///   onSelect: (date) => print(date),
/// )
/// ```
library;

import 'package:antd_calendar/src/calendar/ant_calendar_locale.dart';
import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

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
    this.weekStartsOn = AntCalendarWeekStartsOn.monday,
    this.fullscreen = false,
    this.dateCell,
    this.disabledDate,
    this.header,
    this.layout = AntCalendarLayout.auto,
    this.calendarFormat = AntCalendarFormat.month,
    this.onFormatChanged,
    this.showFormatSwitcher = false,
    this.selectionMode = AntCalendarSelectionMode.single,
    this.onRangeSelected,
    this.multiSelect = false,
    this.selectedDays,
    this.defaultSelectedDays = const [],
    this.onSelectMulti,
    this.eventLoader,
    this.enableYearMonthDropdown = true,
    this.locale,
  });

  /// 受控选中日期（单选模式）。
  final DateTime? value;

  /// 非受控初始选中日期。
  final DateTime? defaultValue;

  /// 日期被选中时的回调（所有选择模式下均触发，保持向后兼容）。
  final ValueChanged<DateTime>? onSelect;

  /// 周起始日。
  final AntCalendarWeekStartsOn weekStartsOn;

  /// 是否全屏模式（大格子），默认 false 为 card 紧凑模式。
  ///
  /// 兼容参数：true 时强制 fullscreen 形态（优先级高于 [layout]）。
  final bool fullscreen;

  /// 自定义日期单元格渲染回调，返回 null 时使用默认渲染。
  final AntCalendarDateCellBuilder? dateCell;

  /// 判断日期是否不可选。
  final bool Function(DateTime date)? disabledDate;

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

  /// 头部年月文字是否可点弹出年月快速跳转面板（antd v6 行为，默认 true）。
  final bool enableYearMonthDropdown;

  /// 国际化文案；null 时经 [AntCalendarLocaleProvider] 注入读取，仍未注入回退中文预设。
  final AntCalendarLocale? locale;

  @override
  State<AntCalendar> createState() => _AntCalendarState();
}

class _AntCalendarState extends State<AntCalendar> {
  DateTime? _internalValue;
  DateTime? _internalRangeStart;
  DateTime? _internalRangeEnd;
  List<DateTime> _internalSelectedDays = [];
  late DateTime _currentMonth;
  late DateTime _focusedDate;
  AntCalendarFormat? _internalFormat;

  /// 当前生效的选中日期（去除时分秒后比较）。
  DateTime? get _selectedDate =>
      widget.value != null ? _dateOnly(widget.value!) : _internalValue;

  /// 当前生效的格式（受控优先）。
  AntCalendarFormat get _format =>
      _internalFormat ?? widget.calendarFormat;

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
    if (widget.selectedDays != null &&
        widget.selectedDays != oldWidget.selectedDays) {
      _internalSelectedDays = List<DateTime>.from(
        widget.selectedDays!,
      ).map(_dateOnly).toList();
    }
  }

  DateTime _dateOnly(DateTime d) => calendarDateOnly(d);

  bool _isSameDay(DateTime? a, DateTime? b) => calendarIsSameDay(a, b);

  bool _isDisabled(DateTime day) => widget.disabledDate?.call(day) ?? false;

  bool get _weekStartsOnMonday =>
      widget.weekStartsOn == AntCalendarWeekStartsOn.monday;

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
  }

  void _setFormat(AntCalendarFormat format) {
    if (format == _format) return;
    setState(() => _internalFormat = format);
    widget.onFormatChanged?.call(format);
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
      return;
    }
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
      );
      _focusedDate = DateTime(_currentMonth.year, _currentMonth.month, 1);
    });
  }

  void _goToCurrentMonth() {
    final now = DateTime.now();
    setState(() {
      _currentMonth = DateTime(now.year, now.month);
      _focusedDate = _dateOnly(now);
    });
  }

  void _jumpToYearMonth(int year, int month) {
    setState(() {
      _currentMonth = DateTime(year, month);
      _focusedDate = DateTime(year, month, 1);
    });
  }

  /// 头部年月快速跳转面板（antd v6 行为，复用 AntPickerView 滚轮）。
  void _showYearMonthDropdown() {
    final t = AntTheme.of(context);
    final loc = widget.locale ?? AntCalendarLocale.of(context);
    final years = <AntPickerColumnItem>[
      for (var y = DateTime.now().year - _kYearDropdownPastYears;
          y <= DateTime.now().year + _kYearDropdownFutureYears;
          y++)
        AntPickerColumnItem(label: '$y年', value: '$y'),
    ];
    final months = <AntPickerColumnItem>[
      for (var m = 1; m <= 12; m++)
        AntPickerColumnItem(label: '$m月', value: '$m'),
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

    final grid = Column(
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
              ? grid
              : GestureDetector(
                  onHorizontalDragEnd: (details) {
                    final v = details.primaryVelocity ?? 0;
                    if (v < 0) {
                      _goToMonth(1);
                    } else if (v > 0) {
                      _goToMonth(-1);
                    }
                  },
                  child: grid,
                ),
        ],
      ),
    );
  }

  /// 默认头部：年月标题（可点跳转）+ 格式切换 + 导航 + 「本月」按钮。
  Widget _buildHeader(AntThemeData t, bool fullscreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
      child: Row(
        children: [
          _buildNavIcon(t, Icons.chevron_left, () => _goToMonth(-1)),
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
                            Icons.keyboard_arrow_down,
                            size: 16.w,
                            color: t.colorTextSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
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
          _buildNavIcon(t, Icons.chevron_right, () => _goToMonth(1)),
        ],
      ),
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

    Widget content = widget.dateCell?.call(
          day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: isSelected,
        ) ??
        _buildDefaultCellContent(t, day, textColor, isCurrentMonth, events);

    return GestureDetector(
      onTap: disabled ? null : () => _onDayTap(day),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.all(fullscreen ? 2.w : 1.w),
        constraints: BoxConstraints(
          minHeight: fullscreen ? 72.w : 32.w,
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
      ),
    );
  }

  /// 默认单元格内容：日期数字 + 事件点标记；全屏模式下非本月灰显。
  Widget _buildDefaultCellContent(
    AntThemeData t,
    DateTime day,
    Color textColor,
    bool isCurrentMonth,
    List<DateTime> events,
  ) {
    final fullscreen = widget.fullscreen || _isFullscreen(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        if (events.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: fullscreen ? 4.w : 1.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0;
                    i < events.length && i < _kMaxEventDots;
                    i++)
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
        else if (fullscreen)
          SizedBox(height: 4.w),
      ],
    );
  }
}
