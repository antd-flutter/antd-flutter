/// AntPageIndicator — antd-mobile v5 PageIndicator 的 Flutter 实现
///
/// API 与 antd-mobile 对齐：
/// - [total] — 页数（点总数）
/// - [current] — 受控当前页
/// - [defaultCurrent] — 非受控默认当前页
/// - [direction] — horizontal / vertical
/// - [color] — 预设配色 primary / white
/// - [dotColor]/[activeDotColor] — 自定义颜色
/// - [dotSize]/[activeDotSize]/[dotSpacing] — 自定义尺寸与间距（.w 缩放）
///
/// ```dart
/// AntPageIndicator(total: 5)
/// AntPageIndicator(total: 5, current: page, direction: AntPageIndicatorDirection.vertical)
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/page_indicator/ant_page_indicator_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/page_indicator/ant_page_indicator_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// 内部：默认尺寸（对齐 page-indicator.less）
// ============================================================

const double _kDotSize = 3;
const double _kActiveDotSize = 13;
const double _kDotSpacing = 3;
const double _kDotBorderRadius = 1;

/// Ant Design 页码指示器。
class AntPageIndicator extends StatefulWidget {
  const AntPageIndicator({
    super.key,
    required this.total,
    this.current,
    this.defaultCurrent = 0,
    this.direction = AntPageIndicatorDirection.horizontal,
    this.color = AntPageIndicatorPresetColor.primary,
    this.dotColor,
    this.activeDotColor,
    this.dotSize,
    this.activeDotSize,
    this.dotSpacing,
  });

  /// 点总数（页数）。
  final int total;

  /// 受控当前页（为 null 时内部自管理，初始值取 [defaultCurrent]）。
  final int? current;

  /// 非受控模式下的默认当前页。
  final int defaultCurrent;

  /// 排列方向。
  final AntPageIndicatorDirection direction;

  /// 预设配色。
  final AntPageIndicatorPresetColor color;

  /// 自定义普通点颜色（覆盖 [color] 预设）。
  final Color? dotColor;

  /// 自定义激活点颜色（覆盖 [color] 预设）。
  final Color? activeDotColor;

  /// 普通点尺寸（逻辑像素，内部 .w 缩放；默认 3）。
  final double? dotSize;

  /// 激活点尺寸（逻辑像素，内部 .w 缩放；默认 13）。
  final double? activeDotSize;

  /// 点间距（逻辑像素，内部 .w 缩放；默认 3）。
  final double? dotSpacing;

  @override
  State<AntPageIndicator> createState() => _AntPageIndicatorState();
}

class _AntPageIndicatorState extends State<AntPageIndicator> {
  late int _internalCurrent = widget.defaultCurrent.clamp(0, widget.total - 1);

  bool get _controlled => widget.current != null;

  int get _current =>
      (_controlled ? widget.current! : _internalCurrent).clamp(0, widget.total - 1);

  @override
  void didUpdateWidget(AntPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 非受控模式下 total 变化后收敛内部值
    if (!_controlled && _internalCurrent > widget.total - 1) {
      _internalCurrent = widget.total - 1;
    }
  }

  (Color, Color) _resolveColors(AntThemeData theme) {
    if (widget.color == AntPageIndicatorPresetColor.white) {
      return (const Color(0x80FFFFFF), const Color(0xFFFFFFFF));
    }
    return (theme.colorFillQuaternary, theme.colorPrimary);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final (defaultDotColor, defaultActiveColor) = _resolveColors(theme);
    final dotColor = widget.dotColor ?? defaultDotColor;
    final activeColor = widget.activeDotColor ?? defaultActiveColor;
    final dotSize = (widget.dotSize ?? _kDotSize).w;
    final activeDotSize = (widget.activeDotSize ?? _kActiveDotSize).w;
    final spacing = (widget.dotSpacing ?? _kDotSpacing).w;
    final isHorizontal = widget.direction == AntPageIndicatorDirection.horizontal;
    final current = _current;

    final dots = <Widget>[];
    for (var i = 0; i < widget.total; i++) {
      final active = i == current;
      // 水平方向激活点沿宽度伸展，垂直方向沿高度伸展
      final mainSize = active ? activeDotSize : dotSize;
      final crossSize = dotSize;
      dots.add(
        AnimatedContainer(
          key: ValueKey('page_indicator_dot_$i'),
          duration: theme.motionDurationMid,
          curve: Curves.easeInOut,
          width: isHorizontal ? mainSize : crossSize,
          height: isHorizontal ? crossSize : mainSize,
          margin: EdgeInsets.only(
            right: isHorizontal && i < widget.total - 1 ? spacing : 0,
            bottom: !isHorizontal && i < widget.total - 1 ? spacing : 0,
          ),
          decoration: BoxDecoration(
            color: active ? activeColor : dotColor,
            borderRadius: BorderRadius.circular(_kDotBorderRadius.r),
          ),
        ),
      );
    }

    return isHorizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: dots)
        : Column(mainAxisSize: MainAxisSize.min, children: dots);
  }
}
