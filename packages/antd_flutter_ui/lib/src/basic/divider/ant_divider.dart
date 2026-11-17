/// AntDivider — antd Divider 分割线的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [type] — horizontal / vertical
/// - [orientation] — 标题位置（left / center / right）
/// - [orientationMargin] — 标题边距
/// - [plain] — 文字是否普通样式
/// - [variant] — solid / dashed / dotted
/// - [dashed] — 虚线便捷属性（等价 variant: dashed）
/// - [child] — 标题内容
/// - [color] / [thickness] / [indent] / [endIndent] / [spacing] — 样式覆盖
///
/// 尺寸令牌：thickness = lineWidth，spacing = marginLG，
/// 标题字号 = fontSizeSM（plain）/ fontSize，分割线颜色 = colorSplit。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_divider_types.dart';

// ============================================================
// AntDivider
// ============================================================

/// 分割线 — 区隔内容的分割线。
///
/// 对不同段落文本元素进行分割，也可用于页面内垂直分割。
///
/// ```dart
/// AntDivider() // 水平实线
/// AntDivider(child: Text('标题')) // 带标题
/// AntDivider(type: AntDividerType.vertical) // 垂直
/// AntDivider(variant: AntDividerVariant.dashed) // 虚线
/// ```
class AntDivider extends StatelessWidget {
  const AntDivider({
    super.key,
    this.type = AntDividerType.horizontal,
    this.orientation = AntDividerOrientation.center,
    this.orientationMargin,
    this.plain = false,
    this.variant = AntDividerVariant.solid,
    this.dashed = false,
    this.child,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.spacing,
  });

  /// 分割线类型。
  final AntDividerType type;

  /// 标题位置（仅水平分割线带 [child] 时生效）。
  final AntDividerOrientation orientation;

  /// 标题与边缘的边距。设置后 [orientation] 左/右时标题固定在边距处。
  final double? orientationMargin;

  /// 文字是否显示为普通正文样式（字号更小、颜色更淡）。
  final bool plain;

  /// 线条样式变体。设置 [dashed] 为 true 时自动切换为 dashed。
  final AntDividerVariant variant;

  /// 虚线便捷属性。为 true 时等价 [variant] = dashed。
  final bool dashed;

  /// 标题内容。
  final Widget? child;

  /// 自定义分割线颜色（默认 colorSplit）。
  final Color? color;

  /// 自定义线条粗细（默认 lineWidth）。
  final double? thickness;

  /// 水平分割线左侧缩进。
  final double? indent;

  /// 水平分割线右侧缩进。
  final double? endIndent;

  /// 水平分割线上下间距（默认 marginLG）。
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final effectiveVariant =
        dashed ? AntDividerVariant.dashed : variant;
    final lineColor = color ?? theme.colorSplit;
    final lineThickness = (thickness ?? theme.lineWidth).w;

    switch (type) {
      case AntDividerType.horizontal:
        return _buildHorizontal(
          context,
          theme,
          effectiveVariant,
          lineColor,
          lineThickness,
        );
      case AntDividerType.vertical:
        return _buildVertical(
          context,
          theme,
          effectiveVariant,
          lineColor,
          lineThickness,
        );
    }
  }

  /// 构建水平分割线。
  Widget _buildHorizontal(
    BuildContext context,
    AntThemeData theme,
    AntDividerVariant effectiveVariant,
    Color lineColor,
    double lineThickness,
  ) {
    final effectiveSpacing = (spacing ?? theme.marginLG).w;
    final effectiveIndent = (indent ?? 0).w;
    final effectiveEndIndent = (endIndent ?? 0).w;

    if (child == null) {
      // 无标题：简单水平线
      return Container(
        height: effectiveSpacing,
        margin: EdgeInsets.only(
          left: effectiveIndent,
          right: effectiveEndIndent,
        ),
        child: Center(
          child: _VariantLine(
            variant: effectiveVariant,
            color: lineColor,
            thickness: lineThickness,
            direction: Axis.horizontal,
          ),
        ),
      );
    }

    // 有标题：根据 orientation 布局
    final textStyle = TextStyle(
      fontSize: (plain ? theme.fontSizeSM : theme.fontSize).sp,
      color: plain ? theme.colorTextSecondary : theme.colorTextPlaceholder,
      fontWeight: plain ? FontWeight.normal : FontWeight.w500,
    );

    final textPadding = theme.paddingXS.w;
    final margin = orientationMargin?.w;

    return Container(
      margin: EdgeInsets.symmetric(vertical: effectiveSpacing / 2),
      padding: EdgeInsets.only(
        left: effectiveIndent,
        right: effectiveEndIndent,
      ),
      child: Row(
        children: _buildSegmentedLine(
          theme,
          effectiveVariant,
          lineColor,
          lineThickness,
          textStyle,
          textPadding,
          margin,
        ),
      ),
    );
  }

  /// 根据方向构建 [线段, 标题, 线段] 布局。
  List<Widget> _buildSegmentedLine(
    AntThemeData theme,
    AntDividerVariant effectiveVariant,
    Color lineColor,
    double lineThickness,
    TextStyle textStyle,
    double textPadding,
    double? margin,
  ) {
    final lineWidget = _VariantLine(
      variant: effectiveVariant,
      color: lineColor,
      thickness: lineThickness,
      direction: Axis.horizontal,
    );

    final titleWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: textPadding),
      child: DefaultTextStyle(
        style: textStyle,
        child: child!,
      ),
    );

    switch (orientation) {
      case AntDividerOrientation.center:
        return [
          Expanded(child: lineWidget),
          titleWidget,
          Expanded(child: lineWidget),
        ];
      case AntDividerOrientation.left:
        if (margin != null) {
          return [
            SizedBox(width: margin, child: lineWidget),
            titleWidget,
            Expanded(child: lineWidget),
          ];
        }
        // 无 margin 时左侧线占 5%
        return [
          Expanded(flex: 1, child: lineWidget),
          titleWidget,
          Expanded(flex: 19, child: lineWidget),
        ];
      case AntDividerOrientation.right:
        if (margin != null) {
          return [
            Expanded(child: lineWidget),
            titleWidget,
            SizedBox(width: margin, child: lineWidget),
          ];
        }
        // 无 margin 时右侧线占 5%
        return [
          Expanded(flex: 19, child: lineWidget),
          titleWidget,
          Expanded(flex: 1, child: lineWidget),
        ];
    }
  }

  /// 构建垂直分割线。
  Widget _buildVertical(
    BuildContext context,
    AntThemeData theme,
    AntDividerVariant effectiveVariant,
    Color lineColor,
    double lineThickness,
  ) {
    final effectiveSpacing = (spacing ?? theme.marginXXS).w;

    return Container(
      width: effectiveSpacing,
      margin: EdgeInsets.symmetric(horizontal: effectiveSpacing / 2),
      child: Center(
        // 默认高度 0.9em（对齐 antd web）：Row 内松约束下高度为 0 会不可见
        child: SizedBox(
          height: theme.fontSize * 0.9,
          child: _VariantLine(
            variant: effectiveVariant,
            color: lineColor,
            thickness: lineThickness,
            direction: Axis.vertical,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 内部：变体线条
// ============================================================

/// 支持实线 / 虚线 / 点线的绘制组件。
class _VariantLine extends StatelessWidget {
  const _VariantLine({
    required this.variant,
    required this.color,
    required this.thickness,
    required this.direction,
  });

  final AntDividerVariant variant;
  final Color color;
  final double thickness;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (variant == AntDividerVariant.solid) {
      // 实线直接用 Container
      if (direction == Axis.horizontal) {
        return Container(height: thickness, color: color);
      }
      return Container(width: thickness, color: color);
    }

    // 虚线 / 点线用 CustomPaint
    return LayoutBuilder(
      builder: (context, constraints) {
        final isHorizontal = direction == Axis.horizontal;
        final length = isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        if (!length.isFinite || length <= 0) {
          return isHorizontal
              ? Container(height: thickness, color: color)
              : Container(width: thickness, color: color);
        }

        return SizedBox(
          width: isHorizontal ? length : thickness,
          height: isHorizontal ? thickness : length,
          child: CustomPaint(
            painter: _VariantLinePainter(
              variant: variant,
              color: color,
              thickness: thickness,
              isHorizontal: isHorizontal,
              length: length,
            ),
          ),
        );
      },
    );
  }
}

/// 虚线 / 点线画笔。
class _VariantLinePainter extends CustomPainter {
  _VariantLinePainter({
    required this.variant,
    required this.color,
    required this.thickness,
    required this.isHorizontal,
    required this.length,
  });

  final AntDividerVariant variant;
  final Color color;
  final double thickness;
  final bool isHorizontal;
  final double length;

  /// 虚线段长度。
  static const double _dashLength = 4;

  /// 虚线间隔。
  static const double _dashGap = 4;

  /// 点线间隔。
  static const double _dotGap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = variant == AntDividerVariant.dotted
          ? StrokeCap.round
          : StrokeCap.butt
      ..style = PaintingStyle.stroke;

    if (isHorizontal) {
      final y = size.height / 2;
      if (variant == AntDividerVariant.dashed) {
        double x = 0;
        while (x < length) {
          final end = (x + _dashLength).clamp(0.0, length).toDouble();
          canvas.drawLine(Offset(x, y), Offset(end, y), paint);
          x += _dashLength + _dashGap;
        }
      } else {
        // dotted
        double x = thickness / 2;
        while (x < length) {
          canvas.drawCircle(Offset(x, y), thickness / 2, paint..style = PaintingStyle.fill);
          x += _dotGap + thickness;
        }
      }
    } else {
      final x = size.width / 2;
      if (variant == AntDividerVariant.dashed) {
        double y = 0;
        while (y < length) {
          final end = (y + _dashLength).clamp(0.0, length).toDouble();
          canvas.drawLine(Offset(x, y), Offset(x, end), paint);
          y += _dashLength + _dashGap;
        }
      } else {
        // dotted
        double y = thickness / 2;
        while (y < length) {
          canvas.drawCircle(Offset(x, y), thickness / 2, paint..style = PaintingStyle.fill);
          y += _dotGap + thickness;
        }
      }
    }
  }

  @override
  bool shouldRepaint(_VariantLinePainter oldDelegate) =>
      oldDelegate.variant != variant ||
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.length != length ||
      oldDelegate.isHorizontal != isHorizontal;
}