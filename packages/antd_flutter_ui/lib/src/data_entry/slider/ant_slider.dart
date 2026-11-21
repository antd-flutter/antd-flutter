/// AntSlider — antd React Slider 的 Flutter 实现
///
/// API 与 antd React Slider 对齐：
/// - [value] / [defaultValue] — 受控/非受控值
/// - [min] / [max] / [step] — 范围与步长
/// - [onChange] / [onChangeEnd] — 变化回调
/// - [disabled] — 是否禁用
/// - [marks] — 刻度标记（任意模型 `List<T>`，配 [markValueOf] / [markLabelOf]）
/// - [tooltipVisible] — 提示是否常显
///
/// ```dart
/// // 最简：刻度直接用数值
/// AntSlider<double>(
///   defaultValue: 30,
///   marks: const [0.0, 50.0, 100.0],
///   markLabelOf: (v) => '${v.toInt()}%',
///   onChange: (v) => print(v),
/// );
///
/// // 自定义模型
/// AntSlider<Stop>(
///   marks: stops,
///   markValueOf: (s) => s.value,
///   markLabelOf: (s) => s.label,
/// );
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/slider/ant_slider_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntSlider
// ============================================================

/// 滑动输入条 — 滑动型输入器，展示当前值和可选范围。
///
/// 对齐 antd React Slider 组件。
class AntSlider<T> extends StatefulWidget {
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
    this.markValueOf,
    this.markLabelOf,
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

  /// 刻度标记（任意模型）。
  final List<T> marks;

  /// 刻度对应的数值，缺省当 `T` 是 [num] 时直接取 `toDouble()`。
  final double Function(T mark)? markValueOf;

  /// 刻度文本，缺省 `'$mark'`。
  final String Function(T mark)? markLabelOf;

  /// 提示是否常显（默认仅拖拽时显示）。
  final bool tooltipVisible;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntSlider<T>> createState() => _AntSliderState<T>();
}

class _AntSliderState<T> extends State<AntSlider<T>> {
  double _internalValue = 0;
  bool _dragging = false;

  double get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue.clamp(widget.min, widget.max);
  }

  /// 刻度数值。
  double _markValue(T mark) {
    final fn = widget.markValueOf;
    if (fn != null) return fn(mark);
    if (mark is num) return mark.toDouble();
    throw StateError(
      'AntSlider: 无法从 $T 提取刻度数值，请提供 markValueOf；'
      '刻度文本可用 markLabelOf 自定义。',
    );
  }

  /// 刻度文本。
  String _markLabel(T mark) => widget.markLabelOf?.call(mark) ?? '$mark';

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
    final trackHeight = theme.s(4);
    final thumbSize = theme.s(14);
    final activeColor =
        widget.disabled ? theme.colorTextDisabled : theme.colorPrimary;
    final inactiveColor =
        widget.disabled ? theme.colorFillSecondary : theme.colorFillSecondary;

    final hasMarks = widget.marks.isNotEmpty;
    final baseHeight = theme.s((hasMarks ? 32 : 16));
    final trackCenter = baseHeight / 2;

    Widget slider = LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final thumbDx = percent * trackWidth;

        final track = GestureDetector(
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
                    (details.localPosition.dx / trackWidth).clamp(0.0, 1.0),
                  );
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
                    (details.localPosition.dx / trackWidth).clamp(0.0, 1.0),
                  );
                  widget.onChangeEnd?.call(_currentValue);
                },
          child: SizedBox(
            height: baseHeight,
            width: trackWidth,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // 轨道
                Positioned(
                  left: 0,
                  right: 0,
                  top: trackCenter - trackHeight / 2,
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
                  top: trackCenter - trackHeight / 2,
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
                    final markValue = _markValue(mark);
                    final markPercent = _valueToPercent(markValue);
                    final isPassed = _currentValue >= markValue;
                    return Positioned(
                      left: markPercent * trackWidth - theme.s(2),
                      top: trackCenter - theme.s(2),
                      child: Container(
                        width: theme.s(4),
                        height: theme.s(4),
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
                                  width: theme.s(1),
                                ),
                        ),
                      ),
                    );
                  }),
                // 提示气泡：绘制于外层 overlay（见下方），不参与布局
                // 拖拽手柄
                Positioned(
                  left: thumbDx - thumbSize / 2,
                  top: trackCenter - thumbSize / 2,
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
                        width: theme.s(2),
                      ),
                      boxShadow: widget.disabled
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
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

        // 提示气泡 overlay：悬浮于轨道上方，不占布局空间、不影响滑块自身位置
        final bubble = Positioned(
          left: (thumbDx - theme.s(20))
              .clamp(0.0, (trackWidth - theme.s(40)).clamp(0.0, double.infinity)),
          bottom: baseHeight + theme.s(6),
          child: Container(
            width: theme.s(40),
            height: theme.s(22),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorBgContainer,
              borderRadius: BorderRadius.circular(theme.borderRadiusSM),
              border: Border.all(color: theme.colorSplit),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
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
                fontSize: theme.fontSizeSM,
                color: theme.colorText,
              ),
            ),
          ),
        );

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: [track, if (showTooltip) bubble],
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
            padding: EdgeInsets.only(top: theme.s(4)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackWidth = constraints.maxWidth;
                return SizedBox(
                  height: theme.s(16),
                  child: Stack(
                    children: widget.marks.map((mark) {
                      final markPercent = _valueToPercent(_markValue(mark));
                      return Positioned(
                        left: markPercent * trackWidth - theme.s(16),
                        width: theme.s(32),
                        child: Text(
                          _markLabel(mark),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: theme.fontSizeSM,
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
