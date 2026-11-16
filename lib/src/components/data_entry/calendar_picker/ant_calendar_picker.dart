/// AntCalendarPicker — antd-mobile CalendarPicker 日历选择器的 Flutter 实现。
///
/// 提供内嵌视图（AntCalendarPickerView）和底部弹窗（AntCalendarPicker）两种形态，
/// 支持单选和范围选择模式。
///
/// ```dart
/// AntCalendarPicker(
///   selectionMode: AntCalendarSelectionMode.range,
///   onConfirm: (dates) => print(dates),
///   child: Text('选择日期'),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/calendar_picker/ant_calendar_picker_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

export 'package:antd_flutter_plus/src/components/data_entry/calendar_picker/ant_calendar_picker_types.dart';

// ============================================================
// AntCalendarPickerView — 内嵌日历视图
// ============================================================

/// 内嵌日历选择视图 — 直接渲染日历网格，支持单选/范围选择。
class AntCalendarPickerView extends StatefulWidget {
  const AntCalendarPickerView({
    super.key,
    this.selectionMode = AntCalendarSelectionMode.single,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.min,
    this.max,
    this.weekStartsOn = AntCalendarWeekStartsOn.sunday,
    this.allowClear = true,
  });

  /// 选择模式。
  final AntCalendarSelectionMode selectionMode;

  /// 受控值（单选 0~1 个元素，范围 0~2 个元素）。
  final List<DateTime>? value;

  /// 非受控初始值。
  final List<DateTime> defaultValue;

  /// 选择变化回调。
  final ValueChanged<List<DateTime>>? onChange;

  /// 最小可选日期。
  final DateTime? min;

  /// 最大可选日期。
  final DateTime? max;

  /// 周起始日。
  final AntCalendarWeekStartsOn weekStartsOn;

  /// 点击已选日期是否清除选择。
  final bool allowClear;

  @override
  State<AntCalendarPickerView> createState() => _AntCalendarPickerViewState();
}

class _AntCalendarPickerViewState extends State<AntCalendarPickerView> {
  List<DateTime> _internalValue = [];
  late DateTime _currentMonth;

  List<DateTime> get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = List<DateTime>.from(widget.defaultValue);
    final base =
        _currentValue.isNotEmpty ? _currentValue.first : DateTime.now();
    _currentMonth = DateTime(base.year, base.month);
    _clampMonth();
  }

  @override
  void didUpdateWidget(covariant AntCalendarPickerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      if (widget.value!.isNotEmpty) {
        final v = widget.value!.first;
        _currentMonth = DateTime(v.year, v.month);
      }
    }
  }

  void _clampMonth() {
    if (widget.min != null) {
      final minMonth = DateTime(widget.min!.year, widget.min!.month);
      if (_isBeforeMonth(_currentMonth, minMonth)) {
        _currentMonth = minMonth;
      }
    }
    if (widget.max != null) {
      final maxMonth = DateTime(widget.max!.year, widget.max!.month);
      if (_isAfterMonth(_currentMonth, maxMonth)) {
        _currentMonth = maxMonth;
      }
    }
  }

  bool _isBeforeMonth(DateTime a, DateTime b) =>
      a.year < b.year || (a.year == b.year && a.month < b.month);

  bool _isAfterMonth(DateTime a, DateTime b) =>
      a.year > b.year || (a.year == b.year && a.month > b.month);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isDisabled(DateTime day) {
    if (widget.min != null && day.isBefore(_dateOnly(widget.min!))) return true;
    if (widget.max != null && day.isAfter(_dateOnly(widget.max!))) return true;
    return false;
  }

  void _onDayTap(DateTime day) {
    if (_isDisabled(day)) return;
    final current = _currentValue;
    final dayOnly = _dateOnly(day);

    List<DateTime> newValue;
    if (widget.selectionMode == AntCalendarSelectionMode.single) {
      if (current.length == 1 && _isSameDay(current.first, dayOnly)) {
        newValue = widget.allowClear ? [] : [dayOnly];
      } else {
        newValue = [dayOnly];
      }
    } else {
      if (current.isEmpty || current.length == 2) {
        newValue = [dayOnly];
      } else if (current.length == 1) {
        if (_isSameDay(current.first, dayOnly)) {
          newValue = widget.allowClear ? [] : [dayOnly];
        } else if (dayOnly.isBefore(current.first)) {
          newValue = [dayOnly, current.first];
        } else {
          newValue = [current.first, dayOnly];
        }
      } else {
        newValue = [dayOnly];
      }
    }

    if (widget.value == null) {
      _internalValue = newValue;
    }
    widget.onChange?.call(newValue);
    setState(() {
      if (newValue.isNotEmpty) {
        _currentMonth = DateTime(newValue.first.year, newValue.first.month);
      }
    });
  }

  void _goToMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final first = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final offset = widget.weekStartsOn == AntCalendarWeekStartsOn.monday
        ? first.weekday - 1
        : first.weekday % 7;
    final start = first.subtract(Duration(days: offset));
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final totalCells =
        ((offset + daysInMonth) / 7).ceil() * 7;
    return List.generate(totalCells, (i) => start.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final days = _getDaysInMonth();
    final today = _dateOnly(DateTime.now());
    final selected = _currentValue.map(_dateOnly).toList();

    final weekLabels = widget.weekStartsOn == AntCalendarWeekStartsOn.monday
        ? const ['一', '二', '三', '四', '五', '六', '日']
        : const ['日', '一', '二', '三', '四', '五', '六'];

    final isRange = widget.selectionMode == AntCalendarSelectionMode.range;
    final hasRange = isRange && selected.length == 2;

    bool isStart(DateTime d) => isRange && selected.isNotEmpty && _isSameDay(d, selected.first);
    bool isEnd(DateTime d) => hasRange && _isSameDay(d, selected.last);
    bool isMiddle(DateTime d) =>
        hasRange && d.isAfter(selected.first) && d.isBefore(selected.last);
    bool isSingleSelected(DateTime d) =>
        !isRange && selected.isNotEmpty && _isSameDay(d, selected.first);

    final canGoPrev = widget.min == null ||
        !_isBeforeMonth(
          DateTime(_currentMonth.year, _currentMonth.month - 1),
          DateTime(widget.min!.year, widget.min!.month),
        );
    final canGoNext = widget.max == null ||
        !_isAfterMonth(
          DateTime(_currentMonth.year, _currentMonth.month + 1),
          DateTime(widget.max!.year, widget.max!.month),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 月份导航
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              _buildNavButton(t, canGoPrev, () => _goToMonth(-1), Icons.chevron_left),
              Expanded(
                child: Center(
                  child: Text(
                    '${_currentMonth.year}年${_currentMonth.month}月',
                    style: TextStyle(
                      fontSize: t.fontSizeLG,
                      fontWeight: FontWeight.w500,
                      color: t.colorText,
                    ),
                  ),
                ),
              ),
              _buildNavButton(t, canGoNext, () => _goToMonth(1), Icons.chevron_right),
            ],
          ),
        ),
        // 周标签
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: weekLabels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: t.fontSizeSM,
                      color: t.colorTextSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // 日期网格
        Column(
          children: List.generate(
            (days.length / 7).ceil(),
            (row) => Row(
              children: List.generate(7, (col) {
                final day = days[row * 7 + col];
                return Expanded(
                  child: _buildDayCell(t, day, today, isStart, isEnd, isMiddle, isSingleSelected),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(
    AntThemeData t,
    bool enabled,
    VoidCallback onTap,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Icon(
          icon,
          size: 24.w,
          color: enabled ? t.colorText : t.colorTextDisabled,
        ),
      ),
    );
  }

  Widget _buildDayCell(
    AntThemeData t,
    DateTime day,
    DateTime today,
    bool Function(DateTime) isStart,
    bool Function(DateTime) isEnd,
    bool Function(DateTime) isMiddle,
    bool Function(DateTime) isSingleSelected,
  ) {
    final dayOnly = _dateOnly(day);
    final isCurrentMonth = day.month == _currentMonth.month;
    final isToday = _isSameDay(dayOnly, today);
    final start = isStart(dayOnly);
    final end = isEnd(dayOnly);
    final middle = isMiddle(dayOnly);
    final singleSelected = isSingleSelected(dayOnly);
    final disabled = _isDisabled(dayOnly);
    final selected = start || end || singleSelected;

    Color textColor;
    Color? bgColor;
    BorderRadius? borderRadius;
    EdgeInsets margin = EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h);

    if (disabled) {
      textColor = t.colorTextDisabled;
    } else if (selected) {
      textColor = Colors.white;
      bgColor = t.colorPrimary;
      borderRadius = BorderRadius.circular(t.borderRadiusSM);
    } else if (middle) {
      textColor = t.colorPrimary;
      bgColor = t.colorPrimary.withValues(alpha: 0.1);
      borderRadius = BorderRadius.zero;
      margin = EdgeInsets.zero;
    } else if (isToday) {
      textColor = t.colorPrimary;
    } else if (!isCurrentMonth) {
      textColor = t.colorTextQuaternary;
    } else {
      textColor = t.colorText;
    }

    // 范围端点的圆角和边距
    if (start) {
      borderRadius = BorderRadius.horizontal(left: Radius.circular(t.borderRadiusSM));
      margin = EdgeInsets.only(left: 2.w, top: 1.h, bottom: 1.h);
    } else if (end) {
      borderRadius = BorderRadius.horizontal(right: Radius.circular(t.borderRadiusSM));
      margin = EdgeInsets.only(right: 2.w, top: 1.h, bottom: 1.h);
    }

    return GestureDetector(
      onTap: disabled ? null : () => _onDayTap(day),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: textColor,
              fontWeight: selected || isToday ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// AntCalendarPicker — 底部弹窗日历选择器
// ============================================================

/// 底部弹窗日历选择器 — 点击触发器弹出底部面板，内含日历视图。
class AntCalendarPicker extends StatefulWidget {
  const AntCalendarPicker({
    super.key,
    this.selectionMode = AntCalendarSelectionMode.single,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.min,
    this.max,
    this.weekStartsOn = AntCalendarWeekStartsOn.sunday,
    this.allowClear = true,
    this.title,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.visible,
    this.onClose,
    this.closeOnMaskClick = true,
    this.child,
  });

  /// 选择模式。
  final AntCalendarSelectionMode selectionMode;

  /// 受控值。
  final List<DateTime>? value;

  /// 非受控初始值。
  final List<DateTime> defaultValue;

  /// 选择变化回调（弹窗内选择时触发）。
  final ValueChanged<List<DateTime>>? onChange;

  /// 最小可选日期。
  final DateTime? min;

  /// 最大可选日期。
  final DateTime? max;

  /// 周起始日。
  final AntCalendarWeekStartsOn weekStartsOn;

  /// 点击已选日期是否清除选择。
  final bool allowClear;

  /// 面板标题。
  final String? title;

  /// 确认按钮文本。
  final String confirmText;

  /// 取消按钮文本。
  final String cancelText;

  /// 确认回调。
  final ValueChanged<List<DateTime>>? onConfirm;

  /// 取消回调。
  final VoidCallback? onCancel;

  /// 受控可见性。
  final bool? visible;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 点击遮罩是否关闭。
  final bool closeOnMaskClick;

  /// 触发器组件（点击打开面板）。
  final Widget? child;

  @override
  State<AntCalendarPicker> createState() => _AntCalendarPickerState();
}

class _AntCalendarPickerState extends State<AntCalendarPicker> {
  List<DateTime>? _lastConfirmed;
  List<DateTime> _currentValue = [];

  @override
  void initState() {
    super.initState();
    _lastConfirmed = List<DateTime>.from(widget.value ?? widget.defaultValue);
    _currentValue = List<DateTime>.from(_lastConfirmed!);
    if (widget.visible == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntCalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible && widget.visible != null) {
      if (widget.visible!) _open();
    }
    if (widget.value != null && widget.value != oldWidget.value) {
      _lastConfirmed = List<DateTime>.from(widget.value!);
      _currentValue = List<DateTime>.from(_lastConfirmed!);
    }
  }

  void _open() {
    final themeData = AntTheme.of(context);
    _currentValue = List<DateTime>.from(_lastConfirmed ?? []);
    showModalBottomSheet<void>(
      context: context,
      isDismissible: widget.closeOnMaskClick,
      enableDrag: false,
      backgroundColor: themeData.colorBgContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(themeData.borderRadiusLG),
        ),
      ),
      builder: (sheetContext) {
        return _CalendarSheet(
          themeData: themeData,
          title: widget.title,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          selectionMode: widget.selectionMode,
          value: _currentValue,
          min: widget.min,
          max: widget.max,
          weekStartsOn: widget.weekStartsOn,
          allowClear: widget.allowClear,
          onCancel: () {
            Navigator.of(sheetContext).pop();
            widget.onCancel?.call();
          },
          onConfirm: () {
            Navigator.of(sheetContext).pop();
            _lastConfirmed = List<DateTime>.from(_currentValue);
            widget.onConfirm?.call(_currentValue);
          },
          onChange: (dates) {
            _currentValue = dates;
            widget.onChange?.call(dates);
          },
        );
      },
    ).then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _open,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}

/// 底部面板内容。
class _CalendarSheet extends StatefulWidget {
  const _CalendarSheet({
    required this.themeData,
    required this.selectionMode,
    required this.value,
    this.title,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.min,
    this.max,
    this.weekStartsOn = AntCalendarWeekStartsOn.sunday,
    this.allowClear = true,
    this.onConfirm,
    this.onCancel,
    this.onChange,
  });

  final AntThemeData themeData;
  final AntCalendarSelectionMode selectionMode;
  final List<DateTime> value;
  final String? title;
  final String confirmText;
  final String cancelText;
  final DateTime? min;
  final DateTime? max;
  final AntCalendarWeekStartsOn weekStartsOn;
  final bool allowClear;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<List<DateTime>>? onChange;

  @override
  State<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<_CalendarSheet> {
  late List<DateTime> _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = List<DateTime>.from(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.themeData;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 头部
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: t.colorSplit, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onCancel,
                child: Text(
                  widget.cancelText,
                  style: TextStyle(fontSize: t.fontSize, color: t.colorText),
                ),
              ),
              if (widget.title != null)
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: t.fontSize,
                        fontWeight: FontWeight.w500,
                        color: t.colorText,
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              GestureDetector(
                onTap: widget.onConfirm,
                child: Text(
                  widget.confirmText,
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
        // 日历视图
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AntCalendarPickerView(
            selectionMode: widget.selectionMode,
            value: _innerValue,
            min: widget.min,
            max: widget.max,
            weekStartsOn: widget.weekStartsOn,
            allowClear: widget.allowClear,
            onChange: (dates) {
              setState(() {
                _innerValue = dates;
              });
              widget.onChange?.call(dates);
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
