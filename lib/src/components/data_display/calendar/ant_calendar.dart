/// AntCalendar — antd React Calendar 的 Flutter 实现。
///
/// 纯展示型日历面板，提供月视图网格（固定 6 行 7 列）、月份导航、
/// 日期选择、今天高亮、禁用日期与自定义单元格等能力。
///
/// ```dart
/// AntCalendar(
///   defaultValue: DateTime(2024, 6, 1),
///   onSelect: (date) => print(date),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_display/calendar/ant_calendar_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

export 'package:antd_flutter_plus/src/components/data_display/calendar/ant_calendar_types.dart';

/// 每个日期网格的固定单元格数量（6 行 × 7 列）。
const int _kCalendarCellCount = 42;

/// 一周的列数。
const int _kDaysPerWeek = 7;

/// 日历 — 纯展示型日历面板。
///
/// 对齐 antd React Calendar 核心 API。
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
  });

  /// 受控选中日期。
  final DateTime? value;

  /// 非受控初始选中日期。
  final DateTime? defaultValue;

  /// 日期被选中时的回调。
  final ValueChanged<DateTime>? onSelect;

  /// 周起始日。
  final AntCalendarWeekStartsOn weekStartsOn;

  /// 是否全屏模式（大格子），默认 false 为 card 紧凑模式。
  final bool fullscreen;

  /// 自定义日期单元格渲染回调，返回 null 时使用默认渲染。
  final AntCalendarDateCellBuilder? dateCell;

  /// 判断日期是否不可选。
  final bool Function(DateTime date)? disabledDate;

  /// 自定义头部内容，为 null 时使用默认头部（年月标题 + 导航 + 本月按钮）。
  final Widget? header;

  @override
  State<AntCalendar> createState() => _AntCalendarState();
}

class _AntCalendarState extends State<AntCalendar> {
  DateTime? _internalValue;
  late DateTime _currentMonth;

  /// 当前生效的选中日期（去除时分秒后比较）。
  DateTime? get _selectedDate =>
      widget.value != null ? _dateOnly(widget.value!) : _internalValue;

  @override
  void initState() {
    super.initState();
    final initial = widget.value ?? widget.defaultValue ?? DateTime.now();
    _internalValue =
        widget.defaultValue != null ? _dateOnly(widget.defaultValue!) : null;
    _currentMonth = DateTime(initial.year, initial.month);
  }

  @override
  void didUpdateWidget(covariant AntCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      final v = widget.value!;
      _currentMonth = DateTime(v.year, v.month);
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDisabled(DateTime day) => widget.disabledDate?.call(day) ?? false;

  /// 生成固定 [_kCalendarCellCount] 个单元格的日期列表（上下月补位）。
  List<DateTime> _buildGridDays() {
    final first = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final offset = widget.weekStartsOn == AntCalendarWeekStartsOn.monday
        ? first.weekday - 1
        : first.weekday % _kDaysPerWeek;
    final start = first.subtract(Duration(days: offset));
    return List.generate(
      _kCalendarCellCount,
      (i) => start.add(Duration(days: i)),
    );
  }

  void _onDayTap(DateTime day) {
    final dayOnly = _dateOnly(day);
    if (_isDisabled(dayOnly)) return;
    if (widget.value == null) {
      setState(() {
        _internalValue = dayOnly;
        _currentMonth = DateTime(dayOnly.year, dayOnly.month);
      });
    } else {
      // 受控模式：点击非本月日期同样切换展示月份以保持可见。
      setState(() {
        _currentMonth = DateTime(dayOnly.year, dayOnly.month);
      });
    }
    widget.onSelect?.call(dayOnly);
  }

  void _goToMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
      );
    });
  }

  void _goToCurrentMonth() {
    setState(() {
      _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final days = _buildGridDays();
    final today = _dateOnly(DateTime.now());
    final selected = _selectedDate;
    final weekLabels = widget.weekStartsOn == AntCalendarWeekStartsOn.monday
        ? const ['一', '二', '三', '四', '五', '六', '日']
        : const ['日', '一', '二', '三', '四', '五', '六'];

    return Container(
      padding: EdgeInsets.all(widget.fullscreen ? 8.w : 4.w),
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
            _buildHeader(t),
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.fullscreen ? 8.w : 4.w),
            child: Row(
              children: weekLabels
                  .map(
                    (label) => Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: widget.fullscreen ? t.fontSize : t.fontSizeSM,
                            color: t.colorTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Column(
            children: List.generate(
              _kCalendarCellCount ~/ _kDaysPerWeek,
              (row) => Row(
                children: List.generate(_kDaysPerWeek, (col) {
                  final day = days[row * _kDaysPerWeek + col];
                  return Expanded(
                    child: _buildDayCell(
                      t,
                      _dateOnly(day),
                      today,
                      selected,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 默认头部：年月标题 + 上/下月导航 + 「本月」按钮。
  Widget _buildHeader(AntThemeData t) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _goToMonth(-1),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.chevron_left,
                size: 20.w,
                color: t.colorText,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${_currentMonth.year}年${_currentMonth.month}月',
                style: TextStyle(
                  fontSize: t.fontSizeLG,
                  fontWeight: FontWeight.w600,
                  color: t.colorText,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _goToCurrentMonth,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              child: Text(
                '本月',
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorPrimary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _goToMonth(1),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.chevron_right,
                size: 20.w,
                color: t.colorText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    AntThemeData t,
    DateTime day,
    DateTime today,
    DateTime? selected,
  ) {
    final isCurrentMonth = day.month == _currentMonth.month &&
        day.year == _currentMonth.year;
    final isToday = _isSameDay(day, today);
    final isSelected = selected != null && _isSameDay(day, selected);
    final disabled = _isDisabled(day);
    final fullscreen = widget.fullscreen;

    Color textColor;
    Color? bgColor;
    if (disabled) {
      textColor = t.colorTextDisabled;
    } else if (isSelected) {
      textColor = Colors.white;
      bgColor = t.colorPrimary;
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
        _buildDefaultCellContent(t, day, textColor, isCurrentMonth);

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
          border: isToday && !isSelected
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

  /// 默认单元格内容：日期数字；全屏模式下非本月灰显、本月正常展示。
  Widget _buildDefaultCellContent(
    AntThemeData t,
    DateTime day,
    Color textColor,
    bool isCurrentMonth,
  ) {
    final fullscreen = widget.fullscreen;
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
        if (fullscreen) SizedBox(height: 4.w),
      ],
    );
  }
}
