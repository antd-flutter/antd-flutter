/// 键盘语义键自绘字形。
///
/// antd 图标库没有键盘语义键（退格 / Shift / CapsLock / Enter / Tab / Space），
/// 按仓库规则 R39「无对应语义时按 antd 外观自绘」，这里用 [CustomPainter]
/// 以 24×24 网格绘制，随 [size] 等比缩放，颜色走主题令牌。
library;

import 'package:material_ui/material_ui.dart';

/// 键盘语义键字形类型。
enum AntKeyboardGlyphType {
  /// 退格：左侧尖角的圆角矩形 + 叉号。
  backspace,

  /// Shift：向上的空心箭头。
  shift,

  /// CapsLock：向上的实心箭头 + 底部横条。
  capsLock,

  /// Enter：向左折返的箭头。
  enter,

  /// Tab：向右箭头 + 右端竖线。
  tab,

  /// Space：宽横条（开口向上的 U 形）。
  space,
}

/// 键盘语义键字形（替代 Material `Icons.*`）。
class AntKeyboardGlyph extends StatelessWidget {
  /// 创建字形。
  const AntKeyboardGlyph(
    this.type, {
    super.key,
    required this.size,
    required this.color,
  });

  /// 字形类型。
  final AntKeyboardGlyphType type;

  /// 绘制边长（字形按 24×24 网格等比缩放）。
  final double size;

  /// 描边/填充颜色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AntKeyboardGlyphPainter(type: type, color: color),
      ),
    );
  }
}

class _AntKeyboardGlyphPainter extends CustomPainter {
  const _AntKeyboardGlyphPainter({required this.type, required this.color});

  final AntKeyboardGlyphType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case AntKeyboardGlyphType.backspace:
        final shape = Path()
          ..moveTo(9.5, 4.5)
          ..lineTo(20.5, 4.5)
          ..quadraticBezierTo(22, 4.5, 22, 6)
          ..lineTo(22, 18)
          ..quadraticBezierTo(22, 19.5, 20.5, 19.5)
          ..lineTo(9.5, 19.5)
          ..lineTo(3, 12)
          ..close();
        canvas.drawPath(shape, stroke);
        canvas.drawLine(const Offset(12.5, 9), const Offset(17, 15), stroke);
        canvas.drawLine(const Offset(17, 9), const Offset(12.5, 15), stroke);
      case AntKeyboardGlyphType.shift:
        final arrow = Path()
          ..moveTo(12, 3)
          ..lineTo(20.5, 11.5)
          ..lineTo(15.5, 11.5)
          ..lineTo(15.5, 20.5)
          ..lineTo(8.5, 20.5)
          ..lineTo(8.5, 11.5)
          ..lineTo(3.5, 11.5)
          ..close();
        canvas.drawPath(arrow, stroke);
      case AntKeyboardGlyphType.capsLock:
        final arrow = Path()
          ..moveTo(12, 2.5)
          ..lineTo(20.5, 11)
          ..lineTo(15.5, 11)
          ..lineTo(15.5, 18)
          ..lineTo(8.5, 18)
          ..lineTo(8.5, 11)
          ..lineTo(3.5, 11)
          ..close();
        canvas.drawPath(arrow, fill);
        canvas.drawRRect(
          RRect.fromLTRBR(7, 20, 17, 22, const Radius.circular(1)),
          fill,
        );
      case AntKeyboardGlyphType.enter:
        canvas.drawPath(
          Path()
            ..moveTo(20.5, 5)
            ..lineTo(20.5, 12.5)
            ..lineTo(8.5, 12.5),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(12.5, 8.5)
            ..lineTo(8.5, 12.5)
            ..lineTo(12.5, 16.5),
          stroke,
        );
      case AntKeyboardGlyphType.tab:
        canvas.drawLine(const Offset(3, 12), const Offset(16, 12), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(12, 8)
            ..lineTo(16, 12)
            ..lineTo(12, 16),
          stroke,
        );
        canvas.drawLine(const Offset(19.5, 6.5), const Offset(19.5, 17.5), stroke);
      case AntKeyboardGlyphType.space:
        canvas.drawPath(
          Path()
            ..moveTo(4, 9)
            ..lineTo(4, 13.5)
            ..lineTo(20, 13.5)
            ..lineTo(20, 9),
          stroke,
        );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AntKeyboardGlyphPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}
