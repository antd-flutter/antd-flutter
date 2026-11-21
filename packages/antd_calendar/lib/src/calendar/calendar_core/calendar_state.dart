/// AntCalendarCoreState — 日历共享状态机（与渲染无关）。
///
/// 职责（C1 抽取自 `ant_calendar.dart` 的 State）：
/// - 受控 / 非受控值解析（value / defaultValue / 多选集合）；
/// - 单选 / range / multiSelect 选择状态与 allowClear；
/// - 当前展示月份、焦点日、面板模式（month/year）、格式（month/week/twoWeeks）；
/// - 月份导航 / 今日跳转 / validRange · minPage · maxPage 裁剪；
/// - onSelect / onChange / onRangeSelected / onPanelChange 等回调派发。
///
/// 渲染器只读本状态并通过公开方法触发变更；状态变化经 [ChangeNotifier]
/// 通知入口 State 重建，等价于原实现中的 `setState`。
library;

import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_core_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_math.dart';
import 'package:flutter/foundation.dart';

/// 日历共享状态机。
class AntCalendarCoreState extends ChangeNotifier {
  /// 以归一化配置创建状态（执行原 `initState` 的初始值解析）。
  AntCalendarCoreState({required AntCalendarCoreConfig config})
      : _config = config {
    final initial = config.value ??
        config.defaultValue ??
        (config.defaultSelectedDays.isNotEmpty
            ? config.defaultSelectedDays.first
            : DateTime.now());
    _internalValue = config.defaultValue != null
        ? calendarDateOnly(config.defaultValue!)
        : null;
    _internalSelectedDays = List<DateTime>.from(
      config.selectedDays ?? config.defaultSelectedDays,
    ).map(calendarDateOnly).toList();
    _focusedDate = calendarDateOnly(initial);
    _currentMonth = DateTime(initial.year, initial.month);
  }

  AntCalendarCoreConfig _config;
  DateTime? _internalValue;
  DateTime? _internalRangeStart;
  DateTime? _internalRangeEnd;
  List<DateTime> _internalSelectedDays = [];
  late DateTime _currentMonth;
  late DateTime _focusedDate;
  AntCalendarFormat? _internalFormat;
  AntCalendarMode? _internalMode;

  /// 当前归一化配置（只读）。
  AntCalendarCoreConfig get config => _config;

  /// 当前展示月份（当月 1 日）。
  DateTime get currentMonth => _currentMonth;

  /// 当前焦点日（周/两周视图锚点、onPanelChange 日期）。
  DateTime get focusedDate => _focusedDate;

  /// 当前生效的选中日期（受控优先，已去除时分秒）。
  DateTime? get selectedDate =>
      _config.value != null ? calendarDateOnly(_config.value!) : _internalValue;

  /// range 起点（过程态/完成态）。
  DateTime? get rangeStart => _internalRangeStart;

  /// range 终点（完成态才非空）。
  DateTime? get rangeEnd => _internalRangeEnd;

  /// range 选择是否处于「已选起点、待选终点」的过程态。
  bool get isRangePending =>
      _config.selectionMode == AntCalendarSelectionMode.range &&
      _internalRangeStart != null &&
      _internalRangeEnd == null;

  /// 当前生效的多选集合（受控优先，已去除时分秒）。
  List<DateTime> get multiSelected =>
      (_config.selectedDays ?? _internalSelectedDays)
          .map(calendarDateOnly)
          .toList();

  /// 当前生效的格式（受控优先）。
  AntCalendarFormat get format => _internalFormat ?? _config.calendarFormat;

  /// 当前生效的面板模式（受控优先，非受控取 initialMode）。
  AntCalendarMode get mode =>
      _internalMode ?? _config.mode ?? _config.initialMode;

  /// 周起始是否为周一。
  bool get weekStartsOnMonday => _config.weekStartsOnMonday;

  /// 当前格式下的可见日期列表。
  List<DateTime> get gridDays => calendarGridDays(
        format: format,
        month: _currentMonth,
        focusedDate: _focusedDate,
        weekStartsOnMonday: _config.weekStartsOnMonday,
      );

  /// 日期是否禁用（disabledDate / validRange / min / max）。
  bool isDisabled(DateTime day) => calendarDayDisabled(
        day,
        disabledDate: _config.disabledDate,
        validRange: _config.validRange,
        min: _config.min,
        max: _config.max,
      );

  /// 月份是否被导航范围裁剪。
  bool isMonthBlocked(DateTime month) => calendarMonthBlocked(
        month,
        validRange: _config.validRange,
        minPage: _config.minPage,
        maxPage: _config.maxPage,
      );

  /// 日期是否处于选中态（range / multi / single 各自语义）。
  bool isSelected(DateTime day) {
    if (_config.selectionMode == AntCalendarSelectionMode.range) {
      return calendarIsSameDay(day, _internalRangeStart) ||
          calendarIsSameDay(day, _internalRangeEnd);
    }
    if (_config.multiSelect) {
      return multiSelected.any((d) => calendarIsSameDay(d, day));
    }
    return calendarIsSameDay(day, selectedDate);
  }

  /// 日期是否处于已完成 range 的内部区间（不含起止端点）。
  bool isInRange(DateTime day) =>
      _config.selectionMode == AntCalendarSelectionMode.range &&
      _internalRangeStart != null &&
      _internalRangeEnd != null &&
      day.isAfter(_internalRangeStart!) &&
      day.isBefore(_internalRangeEnd!);

  /// 日期关联的事件列表（eventLoader，默认空）。
  List<DateTime> eventsOf(DateTime day) =>
      _config.eventLoader?.call(day) ?? const [];

  /// 入口 Widget 更新时同步配置，复现原 `didUpdateWidget` 的受控重置语义。
  void updateConfig(AntCalendarCoreConfig next) {
    final old = _config;
    if (next.value != null && next.value != old.value) {
      final v = next.value!;
      _focusedDate = calendarDateOnly(v);
      _currentMonth = DateTime(v.year, v.month);
      if (next.selectionMode == AntCalendarSelectionMode.range) {
        _internalRangeStart = calendarDateOnly(v);
        _internalRangeEnd = null;
      }
    }
    if (next.calendarFormat != old.calendarFormat) {
      _internalFormat = null;
    }
    if (next.mode != null && next.mode != old.mode) {
      _internalMode = null;
    }
    if (next.selectedDays != null && next.selectedDays != old.selectedDays) {
      _internalSelectedDays = List<DateTime>.from(
        next.selectedDays!,
      ).map(calendarDateOnly).toList();
    }
    _config = next;
  }

  /// 点击日期（选择状态机入口）。
  void handleDayTap(DateTime day) {
    final dayOnly = calendarDateOnly(day);
    if (isDisabled(dayOnly)) return;

    if (_config.multiSelect) {
      final next = List<DateTime>.from(multiSelected);
      final existing = next.indexWhere((d) => calendarIsSameDay(d, dayOnly));
      if (existing >= 0) {
        next.removeAt(existing);
      } else {
        next.add(dayOnly);
        next.sort((a, b) => a.compareTo(b));
      }
      if (_config.selectedDays == null) {
        _internalSelectedDays = next;
      }
      notifyListeners();
      _config.onSelectMulti?.call(next);
      _config.onSelect?.call(dayOnly);
      _config.onChange?.call(dayOnly);
      return;
    }

    if (_config.selectionMode == AntCalendarSelectionMode.range) {
      if (_internalRangeStart != null &&
          _internalRangeEnd == null &&
          !calendarIsSameDay(_internalRangeStart, dayOnly)) {
        final start = _internalRangeStart!;
        final end = dayOnly;
        final lo = start.isBefore(end) ? start : end;
        final hi = start.isBefore(end) ? end : start;
        if (_config.value == null) {
          _internalRangeStart = lo;
          _internalRangeEnd = hi;
          _focusedDate = hi;
          _currentMonth = DateTime(hi.year, hi.month);
        }
        notifyListeners();
        _config.onSelect?.call(dayOnly);
        _config.onChange?.call(dayOnly);
        _config.onRangeSelected?.call(lo, hi);
        return;
      }
      // 开始新一轮范围选择。
      if (_config.value == null) {
        _internalRangeStart = dayOnly;
        _internalRangeEnd = null;
      }
      notifyListeners();
      _config.onSelect?.call(dayOnly);
      _config.onChange?.call(dayOnly);
      return;
    }

    // 单选模式：allowClear 支持点击已选日期清除选择。
    if (_config.allowClear && calendarIsSameDay(selectedDate, dayOnly)) {
      if (_config.value == null) {
        _internalValue = null;
      }
      notifyListeners();
      _config.onChange?.call(null);
      return;
    }

    if (_config.value == null) {
      _internalValue = dayOnly;
      _focusedDate = dayOnly;
      _currentMonth = DateTime(dayOnly.year, dayOnly.month);
    } else {
      // 受控模式：点击非本月日期同样切换展示月份以保持可见。
      _focusedDate = dayOnly;
      _currentMonth = DateTime(dayOnly.year, dayOnly.month);
    }
    notifyListeners();
    _config.onSelect?.call(dayOnly);
    _config.onChange?.call(dayOnly);
  }

  /// 切换可见格式（calendarFormat 增强能力）。
  void setFormat(AntCalendarFormat format) {
    if (format == this.format) return;
    _internalFormat = format;
    notifyListeners();
    _config.onFormatChanged?.call(format);
  }

  /// 切换面板模式（month / year）。
  void setMode(AntCalendarMode mode) {
    if (mode == this.mode) return;
    if (_config.mode == null) {
      _internalMode = mode;
    }
    notifyListeners();
    _config.onModeChanged?.call(mode);
    _config.onPanelChange?.call(_focusedDate, mode);
  }

  /// 按 delta 个月（或周）导航。
  void goToMonth(int delta) {
    if (format != AntCalendarFormat.month) {
      // week/twoWeeks 格式下按周步进导航。
      final step = format == AntCalendarFormat.week
          ? kCalendarDaysPerWeek
          : kCalendarDaysPerWeek * 2;
      _focusedDate = _focusedDate.add(Duration(days: delta * step));
      _currentMonth = DateTime(_focusedDate.year, _focusedDate.month);
      notifyListeners();
      _notifyPanelChanged(_focusedDate, mode);
      return;
    }
    final target = DateTime(_currentMonth.year, _currentMonth.month + delta);
    if (isMonthBlocked(target)) return;
    _currentMonth = target;
    _focusedDate = DateTime(target.year, target.month, 1);
    notifyListeners();
    _notifyPanelChanged(_focusedDate, mode);
  }

  /// 按 delta 年导航（月粒度裁剪）。
  void goToYear(int delta) {
    final target = DateTime(_currentMonth.year + delta, _currentMonth.month);
    if (isMonthBlocked(target)) return;
    _currentMonth = target;
    _focusedDate = DateTime(target.year, target.month, 1);
    notifyListeners();
    _notifyPanelChanged(_focusedDate, mode);
  }

  /// 回到当前月并聚焦今天。
  void goToToday() {
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _focusedDate = calendarDateOnly(now);
    notifyListeners();
    _notifyPanelChanged(_currentMonth, mode);
  }

  /// 跳转到指定年月（导航裁剪生效）。
  void jumpToYearMonth(int year, int month) {
    final target = DateTime(year, month);
    if (isMonthBlocked(target)) return;
    _currentMonth = target;
    _focusedDate = DateTime(year, month, 1);
    notifyListeners();
    _notifyPanelChanged(target, mode);
  }

  void _notifyPanelChanged(DateTime date, AntCalendarMode mode) {
    _config.onPanelChange?.call(date, mode);
    _config.onPageChange?.call(date.year, date.month);
  }
}
