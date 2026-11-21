/// CalendarMath — 日历共享数学逻辑（与渲染无关）。
///
/// C1 抽取自 `ant_calendar.dart` 的私有辅助逻辑：
/// - 6×7 月网格 / 两周 / 周视图生成、周起始与上下月补位；
/// - validRange / minPage / maxPage 的月份导航裁剪；
/// - disabledDate / validRange / min / max 的日期禁用判定；
/// - 日期归一化与同日/同月比较。
///
/// 底层网格计算复用 `antd_flutter_ui` 的 CalendarGridEngine（跨包共享），
/// 本文件只做日历语义层的组合，不依赖任何 Widget / 渲染代码。
library;

import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';

export 'package:antd_flutter_ui/antd_flutter_ui.dart'
    show
        calendarDateOnly,
        calendarIsSameDay,
        kCalendarDaysPerWeek,
        kCalendarMaxWeeks;

/// 周序号（antd v6 showWeek 对齐）：一年中第几周。
///
/// 以 [weekStartsOnMonday] 决定周起始；每周从周起始日算起，
/// 含 1 月 1 日的那一周记为第 1 周（antd/dayjs week-of-year 语义）。
int calendarWeekNumber(
  DateTime date, {
  required bool weekStartsOnMonday,
}) {
  final day = calendarDateOnly(date);
  final firstDayIndex = weekStartsOnMonday ? DateTime.monday : DateTime.sunday;
  int offset(DateTime value) => (value.weekday - firstDayIndex) % 7;
  final weekStart = day.subtract(Duration(days: offset(day)));
  final firstWeekStart = DateTime(day.year).subtract(
    Duration(days: offset(DateTime(day.year))),
  );
  return weekStart.difference(firstWeekStart).inDays ~/ 7 + 1;
}

/// 两个日期是否属于同一展示月份（仅比较年/月）。
bool calendarIsSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// 周起始约定是否以周一为第一天。
bool calendarWeekStartsOnMonday(AntCalendarWeekStartsOn weekStartsOn) =>
    weekStartsOn == AntCalendarWeekStartsOn.monday;

/// 按可见格式生成网格日期列表（month = 固定 6×7；week / twoWeeks 锚定焦点日）。
///
/// [month] 用于月视图，[focusedDate] 用于周/两周视图；
/// 返回的日期均已归一化为当天零点。
List<DateTime> calendarGridDays({
  required AntCalendarFormat format,
  required DateTime month,
  required DateTime focusedDate,
  required bool weekStartsOnMonday,
}) {
  switch (format) {
    case AntCalendarFormat.month:
      return buildCalendarMonthGrid(
        month,
        weekStartsOnMonday: weekStartsOnMonday,
      );
    case AntCalendarFormat.twoWeeks:
      return buildCalendarTwoWeeksGrid(
        focusedDate,
        weekStartsOnMonday: weekStartsOnMonday,
      );
    case AntCalendarFormat.week:
      return buildCalendarWeekGrid(
        focusedDate,
        weekStartsOnMonday: weekStartsOnMonday,
      );
  }
}

/// 某日期是否被禁用（disabledDate / validRange / min / max 任一命中）。
///
/// 语义与 C1 之前的 State 私有实现完全一致：先判 disabledDate，
/// 再判 validRange（按天包含边界），最后判 min/max（按天比较）。
bool calendarDayDisabled(
  DateTime day, {
  bool Function(DateTime date)? disabledDate,
  AntCalendarValidRange? validRange,
  DateTime? min,
  DateTime? max,
}) {
  if (disabledDate?.call(day) ?? false) return true;
  if (validRange != null && !validRange.contains(day)) return true;
  if (min != null && day.isBefore(calendarDateOnly(min))) return true;
  if (max != null && day.isAfter(calendarDateOnly(max))) return true;
  return false;
}

/// 某月是否被导航范围裁剪（validRange / minPage / maxPage 语义）。
///
/// 按月粒度：整月与允许范围无交集才禁止导航（与既有行为一致）。
bool calendarMonthBlocked(
  DateTime month, {
  AntCalendarValidRange? validRange,
  AntCalendarPage? minPage,
  AntCalendarPage? maxPage,
}) {
  if (validRange != null) {
    final monthStart = DateTime(month.year, month.month);
    final monthEnd = DateTime(month.year, month.month + 1, 0);
    if (monthEnd.isBefore(validRange.start) ||
        monthStart.isAfter(validRange.end)) {
      return true;
    }
  }
  if (minPage != null && minPage.compareTo(month.year, month.month) > 0) {
    return true;
  }
  if (maxPage != null && maxPage.compareTo(month.year, month.month) < 0) {
    return true;
  }
  return false;
}
