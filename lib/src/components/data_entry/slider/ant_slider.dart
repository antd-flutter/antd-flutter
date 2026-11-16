/// AntSlider — antd React Slider 的 Flutter 实现
///
/// API 与 antd React Slider 对齐：
/// - [value] / [defaultValue] — 受控/非受控值
/// - [min] / [max] / [step] — 范围与步长
/// - [onChange] / [onChangeEnd] — 变化回调
/// - [disabled] — 是否禁用
/// - [marks] — 刻度标记
/// - [tooltipVisible] — 提示是否常显
///
/// ```dart
/// AntSlider(
///   defaultValue: 30,
///   min: 0,
///   max: 100,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/slider/ant_slider_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/slider/ant_slider_types.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntSlider
// ============================================================

/// 滑动输入条 — 滑动型输入器，展示当前值和可选范围。
///
/// 对齐 antd React Slider 组件。
class AntSlider extends StatefulWidget {
  const AntSlider({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChange,
    this.onChangeEnd,
    this.disabled = false,
    this.marks = const [],
    this.tooltipVisible = false,
    this.autofocus = false,
  });

  /// 受控值。
  final double? value;

  /// 非受控初始值。
  final double defaultValue;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 步长，0 表示连续。
  final double step;

  /// 值变化回调。
  final ValueChanged<double>? onChange;

  /// 拖动结束回调。
  final ValueChanged<double>? onChangeEnd;

  /// 是否禁用。
  final bool disabled;

  /// 刻度标记。
  final List<AntSliderMark> marks;

  /// 提示是否常显（默认仅拖拽时显示）。
  final bool tooltipVisible;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntSlider> createState() => _AntSliderState();
}

class _AntSliderState extends State<AntSlider> {
  double _internalValue = 0;
  bool _dragging = false;

  double get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue.clamp(widget.min, widget.max);
  }

  double _valueToPercent(double v) {
    final range = widget.max - widget.min;
    if (range <= 0) return 0;
    return ((v - widget.min) / range).clamp(0.0, 1.0);
  }

  double _percentToValue(double percent) {
    var v = widget.min + percent * (widget.max - widget.min);
    if (widget.step > 0) {
      v = ((v - widget.min) / widget.step).round() * widget.step + widget.min;
    }
    return v.clamp(widget.min, widget.max);
  }

  void _updateValue(double percent) {
    final v = _percentToValue(percent);
    if (v != _currentValue) {
      _internalValue = v;
      widget.onChange?.call(v);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final percent = _valueToPercent(_currentValue);
    final showTooltip = widget.tooltipVisible || _dragging;
    final trackHeight = 4.w;
    final thumbSize = 14.w;
    final activeColor =
        widget.disabled ? theme.colorTextDisabled : theme.colorPrimary;
    final inactiveColor = widget.disabled
        ? theme.colorFillSecondary
        : theme.colorFillSecondary;

    final hasMarks = widget.marks.isNotEmpty;

    Widget slider = LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final thumbDx = percent * trackWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: widget.disabled
              ? null
              : (_) {
                  setState(() => _dragging = true);
                },
          onHorizontalDragUpdate: widget.disabled
              ? null
              : (details) {
                  _updateValue(
                      (details.localPosition.dx / trackWidth).clamp(0.0, 1.0));
                },
          onHorizontalDragEnd: widget.disabled
              ? null
              : (_) {
                  setState(() => _dragging = false);
                  widget.onChangeEnd?.call(_currentValue);
                },
          onTapDown: widget.disabled
              ? null
              : (details) {
                  _updateValue(
                      (details.localPosition.dx / trackWidth).clamp(0.0, 1.0));
                  widget.onChangeEnd?.call(_currentValue);
                },
          child: SizedBox(
            height: (hasMarks ? 32 : 16).w,
            width: trackWidth,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // 轨道
                Positioned(
                  left: 0,
                  right: 0,
                  top: (hasMarks ? 32 : 16).w / 2 - trackHeight / 2,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),
                // 已填充轨道
                Positioned(
                  left: 0,
                  width: thumbDx,
                  top: (hasMarks ? 32 : 16).w / 2 - trackHeight / 2,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),
                // 刻度点
                if (hasMarks)
                  ...widget.marks.map((mark) {
                    final markPercent = _valueToPercent(mark.value);
                    final isPassed = _currentValue >= mark.value;
                    return Positioned(
                      left: markPercent * trackWidth - 2.w,
                      top: (hasMarks ? 32 : 16).w / 2 - 2.w,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassed
                              ? (widget.disabled
                                  ? theme.colorBgContainer
                                  : Colors.white)
                              : inactiveColor,
                          border: isPassed && !widget.disabled
                              ? null
                              : Border.all(
                                  color: widget.disabled
                                      ? theme.colorBorder
                                      : theme.colorSplit,
                                  width: 1.w,
                                ),
                        ),
                      ),
                    );
                  }),
                // 提示气泡
                if (showTooltip)
                  Positioned(
                    left: thumbDx - 20.w,
                    top: 0,
                    child: Container(
                      width: 40.w,
                      height: 22.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorBgContainer,
                        borderRadius: BorderRadius.circular(theme.borderRadiusSM.w),
                        border: Border.all(color: theme.colorSplit),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _currentValue % 1 == 0
                            ? _currentValue.toInt().toString()
                            : _currentValue.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: theme.fontSizeSM.sp,
                          color: theme.colorText,
                        ),
                      ),
                    ),
                  ),
                // 拖拽手柄
                Positioned(
                  left: thumbDx - thumbSize / 2,
                  top: (hasMarks ? 32 : 16).w / 2 - thumbSize / 2,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.disabled
                          ? theme.colorBgContainerDisabled
                          : Colors.white,
                      border: Border.all(
                        color: activeColor,
                        width: 2.w,
                      ),
                      boxShadow: widget.disabled
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // 刻度标签
    if (hasMarks) {
      slider = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          slider,
          Padding(
            padding: EdgeInsets.only(top: 4.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackWidth = constraints.maxWidth;
                return SizedBox(
                  height: 16.w,
                  child: Stack(
                    children: widget.marks.map((mark) {
                      final markPercent = _valueToPercent(mark.value);
                      return Positioned(
                        left: markPercent * trackWidth - 16.w,
                        width: 32.w,
                        child: Text(
                          mark.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: theme.fontSizeSM.sp,
                            color: theme.colorTextTertiary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return slider;
  }
}