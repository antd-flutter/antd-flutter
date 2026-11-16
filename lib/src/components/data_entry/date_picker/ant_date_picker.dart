/// AntDatePicker — antd React DatePicker 的 Flutter 实现
///
/// API 与 antd React DatePicker 对齐：
/// - [value] / [defaultValue] — 受控/非受控日期
/// - [onChange] — 日期变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [size]
///
/// ```dart
/// AntDatePicker(
///   defaultValue: DateTime(2024, 1, 15),
///   onChange: (date) => print(date),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/date_picker/ant_date_picker_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/date_picker/ant_date_picker_types.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntDatePicker
// ============================================================

/// 日期选择框 — 输入或选择日期。
///
/// 对齐 antd React DatePicker 组件。
class AntDatePicker extends StatefulWidget {
  const AntDatePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.size = AntDatePickerSize.middle,
    this.format = 'yyyy-MM-dd',
    this.autofocus = false,
  });

  /// 受控日期值。
  final DateTime? value;

  /// 非受控初始日期。
  final DateTime? defaultValue;

  /// 日期变化回调。
  final ValueChanged<DateTime?>? onChange;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntDatePickerSize size;

  /// 日期显示格式（目前支持 yyyy-MM-dd）。
  final String format;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntDatePicker> createState() => _AntDatePickerState();
}

class _AntDatePickerState extends State<AntDatePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  DateTime? _internalValue;
  late DateTime _panelMonth;

  bool get _currentOpen => _internalOpen;

  DateTime? get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _panelMonth = _currentValue ?? DateTime.now();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted) return;
    setState(() {
      _internalOpen = value;
    });
    if (value) {
      _panelMonth = _currentValue ?? DateTime.now();
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    if (!mounted) return;
    final theme = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DatePickerOverlay(
        fieldKey: _fieldKey,
        layerLink: _layerLink,
        panelMonth: _panelMonth,
        selectedDate: _currentValue,
        themeData: theme,
        onPanelChange: (month) {
          if (!mounted) return;
          setState(() => _panelMonth = month);
          _overlayEntry?.markNeedsBuild();
        },
        onSelect: (date) {
          _internalValue = date;
          widget.onChange?.call(date);
          _setOpen(false);
        },
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleClear() {
    _internalValue = null;
    widget.onChange?.call(null);
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  double get _controlHeight {
    switch (widget.size) {
      case AntDatePickerSize.large:
        return 40;
      case AntDatePickerSize.middle:
        return 32;
      case AntDatePickerSize.small:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final height = _controlHeight.w;
    final open = _currentOpen;
    final value = _currentValue;

    final showClear = widget.allowClear && value != null && !widget.disabled;

    return GestureDetector(
      onTap: widget.disabled ? null : () => _setOpen(!open),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          key: _fieldKey,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: theme.marginSM.w),
          decoration: BoxDecoration(
            color: widget.disabled
                ? theme.colorBgContainerDisabled
                : theme.colorBgContainer,
            borderRadius: BorderRadius.circular(theme.borderRadius.w),
            border: Border.all(
              color: open && !widget.disabled
                  ? theme.controlOutline
                  : theme.colorBorder,
              width: open && !widget.disabled
                  ? theme.controlOutlineWidth.w
                  : 1.w,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.w,
                color: widget.disabled
                    ? theme.colorTextDisabled
                    : theme.colorTextSecondary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: value == null
                    ? Text(
                        widget.placeholder ?? '请选择日期',
                        style: TextStyle(
                          fontSize: theme.fontSize.sp,
                          color: theme.colorTextPlaceholder,
                        ),
                      )
                    : Text(
                        _formatDate(value),
                        style: TextStyle(
                          fontSize: theme.fontSize.sp,
                          color: theme.colorText,
                        ),
                      ),
              ),
              if (showClear)
                GestureDetector(
                  onTap: _handleClear,
                  child: Icon(
                    Icons.cancel,
                    size: 14.w,
                    color: theme.colorTextPlaceholder,
                  ),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14.w,
                  color: widget.disabled
                      ? theme.colorTextDisabled
                      : theme.colorTextSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _DatePickerOverlay — 日历浮层
// ============================================================

class _DatePickerOverlay extends StatelessWidget {
  const _DatePickerOverlay({
    required this.fieldKey,
    required this.layerLink,
    required this.panelMonth,
    required this.selectedDate,
    required this.themeData,
    required this.onPanelChange,
    required this.onSelect,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final LayerLink layerLink;
  final DateTime panelMonth;
  final DateTime? selectedDate;
  final AntThemeData themeData;
  final ValueChanged<DateTime> onPanelChange;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onDismiss;

  static const _weekdays = ['日', '一', '二', '三', '四', '五', '六'];

  @override
  Widget build(BuildContext context) {
    final theme = themeData;

    final fieldCtx = fieldKey.currentContext;
    if (fieldCtx == null) return const SizedBox.shrink();
    final fieldBox = fieldCtx.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize) return const SizedBox.shrink();
    final fieldSize = fieldBox.size;

    final year = panelMonth.year;
    final month = panelMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7;

    final today = DateTime.now();
    final isToday = (d) =>
        d.year == today.year &&
        d.month == today.month &&
        d.day == today.day;

    final dayCells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      dayCells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final selected = selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;
      dayCells.add(
        _DayCell(
          day: day,
          selected: selected,
          isToday: isToday(date),
          theme: theme,
          onTap: () => onSelect(date),
        ),
      );
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: onDismiss,
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: 0,
          top: fieldSize.height + 4,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            child: TapRegion(
              onTapOutside: (_) => onDismiss(),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 280.w,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: theme.colorBgContainer,
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG.w),
                    border: Border.all(color: theme.colorSplit),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 年月导航
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _NavButton(
                            icon: Icons.chevron_left,
                            theme: theme,
                            onTap: () => onPanelChange(
                                DateTime(year, month - 1, 1)),
                          ),
                          Text(
                            '$year年$month月',
                            style: TextStyle(
                              fontSize: theme.fontSize.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorText,
                            ),
                          ),
                          _NavButton(
                            icon: Icons.chevron_right,
                            theme: theme,
                            onTap: () => onPanelChange(
                                DateTime(year, month + 1, 1)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),
                      // 星期表头
                      Row(
                        children: _weekdays
                            .map((w) => Expanded(
                                  child: Center(
                                    child: Text(
                                      w,
                                      style: TextStyle(
                                        fontSize: theme.fontSizeSM.sp,
                                        color: theme.colorTextTertiary,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 4.w),
                      // 日期网格
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 2.w,
                        crossAxisSpacing: 2.w,
                        childAspectRatio: 1,
                        children: dayCells,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _DayCell — 日期单元格
// ============================================================

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.theme,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool isToday;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? t.colorPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(t.borderRadius.w),
          border: isToday && !selected
              ? Border.all(color: t.colorPrimary, width: 1.w)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: t.fontSizeSM.sp,
              color: selected
                  ? Colors.white
                  : isToday
                      ? t.colorPrimary
                      : t.colorText,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _NavButton — 月份导航按钮
// ============================================================

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.theme,
    required this.onTap,
  });

  final IconData icon;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.borderRadius.w),
        ),
        child: Icon(
          icon,
          size: 18.w,
          color: theme.colorTextSecondary,
        ),
      ),
    );
  }
}