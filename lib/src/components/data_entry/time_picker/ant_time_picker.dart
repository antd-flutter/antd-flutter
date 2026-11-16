/// AntTimePicker — antd React TimePicker 的 Flutter 实现
///
/// API 与 antd React TimePicker 对齐：
/// - [value] / [defaultValue] — 受控/非受控时间
/// - [onChange] — 时间变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [size] / [hourStep] / [minuteStep] / [secondStep]
///
/// ```dart
/// AntTimePicker(
///   defaultValue: TimeOfDay(hour: 10, minute: 30),
///   onChange: (time) => print(time),
/// )
/// ```
library;

import 'dart:math' as math;

import 'package:antd_flutter_plus/src/components/data_entry/time_picker/ant_time_picker_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/time_picker/ant_time_picker_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntTimePicker
// ============================================================

/// 时间选择框 — 输入或选择时间。
///
/// 对齐 antd React TimePicker 组件。
class AntTimePicker extends StatefulWidget {
  const AntTimePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.size = AntTimePickerSize.middle,
    this.hourStep = 1,
    this.minuteStep = 1,
    this.secondStep = 1,
    this.autofocus = false,
  });

  /// 受控时间值。
  final TimeOfDay? value;

  /// 非受控初始时间。
  final TimeOfDay? defaultValue;

  /// 时间变化回调。
  final ValueChanged<TimeOfDay?>? onChange;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntTimePickerSize size;

  /// 小时步长。
  final int hourStep;

  /// 分钟步长。
  final int minuteStep;

  /// 秒步长。
  final int secondStep;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntTimePicker> createState() => _AntTimePickerState();
}

class _AntTimePickerState extends State<AntTimePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  TimeOfDay? _internalValue;

  bool get _currentOpen => _internalOpen;

  TimeOfDay? get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted) return;
    setState(() => _internalOpen = value);
    if (value) {
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
      builder: (context) => _TimePickerOverlay(
        fieldKey: _fieldKey,
        layerLink: _layerLink,
        value: _currentValue,
        hourStep: widget.hourStep,
        minuteStep: widget.minuteStep,
        secondStep: widget.secondStep,
        themeData: theme,
        onSelect: (time) {
          _internalValue = time;
          widget.onChange?.call(time);
          if (mounted) {
            setState(() {});
            _overlayEntry?.markNeedsBuild();
          }
        },
        onConfirm: () => _setOpen(false),
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

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  double get _controlHeight {
    switch (widget.size) {
      case AntTimePickerSize.large:
        return 40;
      case AntTimePickerSize.middle:
        return 32;
      case AntTimePickerSize.small:
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
                Icons.access_time,
                size: 14.w,
                color: widget.disabled
                    ? theme.colorTextDisabled
                    : theme.colorTextSecondary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: value == null
                    ? Text(
                        widget.placeholder ?? '请选择时间',
                        style: TextStyle(
                          fontSize: theme.fontSize.sp,
                          color: theme.colorTextPlaceholder,
                        ),
                      )
                    : Text(
                        _formatTime(value),
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
// _TimePickerOverlay — 时间面板浮层
// ============================================================

class _TimePickerOverlay extends StatefulWidget {
  const _TimePickerOverlay({
    required this.fieldKey,
    required this.layerLink,
    required this.value,
    required this.hourStep,
    required this.minuteStep,
    required this.secondStep,
    required this.themeData,
    required this.onSelect,
    required this.onConfirm,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final LayerLink layerLink;
  final TimeOfDay? value;
  final int hourStep;
  final int minuteStep;
  final int secondStep;
  final AntThemeData themeData;
  final ValueChanged<TimeOfDay> onSelect;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  State<_TimePickerOverlay> createState() => _TimePickerOverlayState();
}

class _TimePickerOverlayState extends State<_TimePickerOverlay> {
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.value?.hour ?? 0;
    _minute = widget.value?.minute ?? 0;
    _second = 0;
  }

  void _notifyChange() {
    widget.onSelect(TimeOfDay(hour: _hour, minute: _minute));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;

    final fieldCtx = widget.fieldKey.currentContext;
    if (fieldCtx == null) return const SizedBox.shrink();
    final fieldBox = fieldCtx.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize) return const SizedBox.shrink();
    final fieldSize = fieldBox.size;

    final hours = <int>[];
    for (var h = 0; h < 24; h += widget.hourStep) {
      hours.add(h);
    }
    final minutes = <int>[];
    for (var m = 0; m < 60; m += widget.minuteStep) {
      minutes.add(m);
    }
    final seconds = <int>[];
    for (var s = 0; s < 60; s += widget.secondStep) {
      seconds.add(s);
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: 0,
          top: fieldSize.height + 4,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            child: TapRegion(
              onTapOutside: (_) => widget.onDismiss(),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: math.max(fieldSize.width, 220.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 8.w,),
                  decoration: BoxDecoration(
                    color: theme.colorBgContainer,
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG.w),
                    border: Border.all(color: theme.colorSplit),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _WheelColumn(
                              items: hours
                                  .map((h) => h.toString().padLeft(2, '0'))
                                  .toList(),
                              selectedIndex: hours.indexOf(_hour.clamp(
                                  hours.first, hours.last,),),
                              theme: theme,
                              onSelected: (index) {
                                setState(() => _hour = hours[index]);
                                _notifyChange();
                              },
                            ),
                          ),
                          _Separator(theme: theme),
                          Expanded(
                            child: _WheelColumn(
                              items: minutes
                                  .map((m) => m.toString().padLeft(2, '0'))
                                  .toList(),
                              selectedIndex: minutes.indexOf(_minute.clamp(
                                  minutes.first, minutes.last,),),
                              theme: theme,
                              onSelected: (index) {
                                setState(() => _minute = minutes[index]);
                                _notifyChange();
                              },
                            ),
                          ),
                          _Separator(theme: theme),
                          Expanded(
                            child: _WheelColumn(
                              items: seconds
                                  .map((s) => s.toString().padLeft(2, '0'))
                                  .toList(),
                              selectedIndex: seconds.indexOf(_second.clamp(
                                  seconds.first, seconds.last,),),
                              theme: theme,
                              onSelected: (index) {
                                setState(() => _second = seconds[index]);
                                _notifyChange();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: widget.onConfirm,
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(theme.borderRadius.w),
                            ),
                          ),
                          child: Text(
                            '确定',
                            style: TextStyle(fontSize: theme.fontSizeSM.sp),
                          ),
                        ),
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
// _Separator — 时分秒冒号分隔
// ============================================================

class _Separator extends StatelessWidget {
  const _Separator({required this.theme});

  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: theme.fontSizeLG.sp,
          color: theme.colorTextSecondary,
        ),
      ),
    );
  }
}

// ============================================================
// _WheelColumn — 滚轮列
// ============================================================

class _WheelColumn extends StatelessWidget {
  const _WheelColumn({
    required this.items,
    required this.selectedIndex,
    required this.theme,
    required this.onSelected,
  });

  final List<String> items;
  final int selectedIndex;
  final AntThemeData theme;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.w,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemExtent: 36.w,
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        controller: ScrollController(
          initialScrollOffset: math.max(0, selectedIndex - 2) * 36.w,
        ),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              alignment: Alignment.center,
              color: selected ? theme.colorFillSecondary : Colors.transparent,
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: theme.fontSize.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? theme.colorPrimary : theme.colorText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}