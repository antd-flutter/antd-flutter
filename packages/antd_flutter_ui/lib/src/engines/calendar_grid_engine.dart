/// CalendarGridEngine — 跨包共享的日历网格计算引擎
///
/// 纯日期计算（无 Flutter/Widget 依赖），供日历类组件（antd_calendar 的
/// AntCalendar / AntCalendarPickerView 等）复用，对齐滚轮引擎的上移模式：
/// 组件包只留 UI 与回调，网格/周起始/日期工具等可沉淀逻辑统一收口本引擎。
///
/// 规则约定（DRY）：
/// - 周起始：monday=true 时周一起始（weekday-1 补位），否则周日起始（weekday%7 补位）
/// - 日期比较一律去除时分秒（dateOnly）
library;

/// 每个日期网格的最大单元格数量（6 行 × 7 列，月视图）。
const int kCalendarMaxWeeks = 6;

/// 一周的列数。
const int kCalendarDaysPerWeek = 7;

/// 去除时分秒，仅保留年月日。
DateTime calendarDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// 两个日期是否为同一天（任一为 null 返回 false）。
bool calendarIsSameDay(DateTime? a, DateTime? b) =>
    a != null &&
    b != null &&
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day;

/// 按周起始约定计算某月 1 号在网格中的前置补位天数。
int calendarMonthLeadingOffset(
  DateTime month, {
  required bool weekStartsOnMonday,
}) {
  final first = DateTime(month.year, month.month, 1);
  return weekStartsOnMonday ? first.weekday - 1 : first.weekday % kCalendarDaysPerWeek;
}

/// 某日所在周的起始日（按周起始约定对齐）。
DateTime calendarStartOfWeek(DateTime day, {required bool weekStartsOnMonday}) {
  final weekday = day.weekday; // Mon=1..Sun=7
  final diff =
      weekStartsOnMonday ? weekday - 1 : weekday % kCalendarDaysPerWeek;
  return calendarDateOnly(day).subtract(Duration(days: diff));
}

/// 生成月份网格：固定 [maxWeeks] 行（默认 6 行 × 7 列，上下月补位）。
List<DateTime> buildCalendarMonthGrid(
  DateTime month, {
  required bool weekStartsOnMonday,
  int maxWeeks = kCalendarMaxWeeks,
}) {
  final first = DateTime(month.year, month.month, 1);
  final offset =
      calendarMonthLeadingOffset(month, weekStartsOnMonday: weekStartsOnMonday);
  final start = first.subtract(Duration(days: offset));
  return List.generate(
    maxWeeks * kCalendarDaysPerWeek,
    (i) => start.add(Duration(days: i)),
  );
}

/// 生成自适应行数的月份网格：按当月实际天数向上取整为整周（紧凑布局用）。
List<DateTime> buildCalendarCompactMonthGrid(
  DateTime month, {
  required bool weekStartsOnMonday,
}) {
  final first = DateTime(month.year, month.month, 1);
  final offset =
      calendarMonthLeadingOffset(month, weekStartsOnMonday: weekStartsOnMonday);
  final start = first.subtract(Duration(days: offset));
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final totalCells = ((offset + daysInMonth) / kCalendarDaysPerWeek).ceil() *
      kCalendarDaysPerWeek;
  return List.generate(totalCells, (i) => start.add(Duration(days: i)));
}

/// 生成锚定日期所在周的网格（周视图）。
List<DateTime> buildCalendarWeekGrid(
  DateTime anchorDay, {
  required bool weekStartsOnMonday,
}) {
  final start = calendarStartOfWeek(anchorDay, weekStartsOnMonday: weekStartsOnMonday);
  return List.generate(
    kCalendarDaysPerWeek,
    (i) => start.add(Duration(days: i)),
  );
}

/// 生成锚定日期所在两周的网格（两周视图）。
List<DateTime> buildCalendarTwoWeeksGrid(
  DateTime anchorDay, {
  required bool weekStartsOnMonday,
}) {
  final start = calendarStartOfWeek(anchorDay, weekStartsOnMonday: weekStartsOnMonday);
  return List.generate(
    kCalendarDaysPerWeek * 2,
    (i) => start.add(Duration(days: i)),
  );
}
