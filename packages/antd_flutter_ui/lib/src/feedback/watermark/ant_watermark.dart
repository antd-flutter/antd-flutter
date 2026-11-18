/// AntWatermark — antd React Watermark（水印）的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [content] — 水印文字（字符串或 `List<String>` 多行）
/// - [child] — 被覆盖的内容
/// - [fontSize] — 字体大小（默认 16）
/// - [fontColor] — 字体颜色（默认低透明度主题文字色）
/// - [rotate] — 旋转角度，默认 -22°
/// - [gapX] / [gapY] — 水印间距（默认 100）
/// - [zIndex] — 层级
/// - [opacity] — 整体透明度（默认 0.15）
///
/// 水印层通过 [CustomPainter] 平铺绘制，使用 [IgnorePointer]
/// 包裹，不拦截子内容的手势。
///
/// 尺寸方案：通过 [GlobalKey] 在 post-frame 阶段测量 [child]
/// 的实际渲染尺寸，水印层以等尺寸 [SizedBox.fromSize] 叠放，
/// 不调用 intrinsic 尺寸、不假设父约束有界，
/// 因此兼容滚动容器（SingleChildScrollView/ListView 等）
/// 与任意父级；窗口尺寸变化（[didChangeMetrics]）时自动重测。
///
/// ```dart
/// AntWatermark(content: '水印文字', child: ListView(...))
/// AntWatermark(content: ['多行', '水印'], child: ...)
/// AntWatermark(content: '水印文字') // 填充满父级模式
/// ```
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_watermark_types.dart';

export 'ant_watermark_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 水印层 CustomPaint 标记 key，便于测试定位水印。
const Key kAntWatermarkPaintKey = ValueKey<String>('AntWatermarkPaint');

/// 水印层容器标记 key。
const Key kAntWatermarkLayerKey = ValueKey<String>('AntWatermarkLayer');

// ============================================================
// AntWatermark
// ============================================================

/// 水印 — 给页面指定区域添加水印。
///
/// 对齐 antd React Watermark 组件：文字平铺、可旋转、
/// 可配置字号颜色与间距，水印层不拦截手势。
///
/// [child] 可空：
/// - 传入 child：水印层自动测量 child 尺寸并等尺寸叠放；
/// - 传 null：填充满父级模式，要求父级约束有界。
class AntWatermark extends StatefulWidget {
  const AntWatermark({
    super.key,
    required this.content,
    this.child,
    this.fontSize,
    this.fontColor,
    this.rotate = kAntWatermarkRotate,
    this.gapX = kAntWatermarkGapX,
    this.gapY = kAntWatermarkGapY,
    this.zIndex = 0,
    this.opacity = kAntWatermarkOpacity,
  });

  /// 水印文字（String 或 `List<String>` 多行展示）。
  final Object content;

  /// 被水印覆盖的内容。
  ///
  /// 可空：传 null 时进入填充满父级模式，
  /// 此时要求父级约束有界（如 Scaffold body 已被约束的区域）。
  final Widget? child;

  /// 字体大小。
  final double? fontSize;

  /// 字体颜色。
  final Color? fontColor;

  /// 旋转角度（度，默认 -22）。
  final double rotate;

  /// 水平间距。
  final double gapX;

  /// 垂直间距。
  final double gapY;

  /// 水印层级（相对覆盖层）。
  final int zIndex;

  /// 整体透明度。
  final double opacity;

  /// 归一化为多行文字列表。
  List<String> get lines {
    final value = content;
    if (value is List<String>) return value;
    if (value is String) return [value];
    return [value.toString()];
  }

  /// 便捷构造：单条字符串水印。
  factory AntWatermark.text(
    String text, {
    Key? key,
    Widget? child,
    double? fontSize,
    Color? fontColor,
    double rotate = kAntWatermarkRotate,
    double gapX = kAntWatermarkGapX,
    double gapY = kAntWatermarkGapY,
    int zIndex = 0,
    double opacity = kAntWatermarkOpacity,
  }) {
    return AntWatermark(
      key: key,
      content: [text],
      fontSize: fontSize,
      fontColor: fontColor,
      rotate: rotate,
      gapX: gapX,
      gapY: gapY,
      zIndex: zIndex,
      opacity: opacity,
      child: child,
    );
  }

  @override
  State<AntWatermark> createState() => _AntWatermarkState();
}

// ============================================================
// _AntWatermarkState — 尺寸测量与水印层叠放
// ============================================================

class _AntWatermarkState extends State<AntWatermark>
    with WidgetsBindingObserver {
  final GlobalKey _childKey = GlobalKey();
  Size _childSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChild());
  }

  @override
  void didUpdateWidget(AntWatermark old) {
    super.didUpdateWidget(old);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChild());
  }

  @override
  void didChangeMetrics() {
    // 窗口尺寸变化时重测 child 尺寸
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChild());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _measureChild() {
    final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final boxSize = box.size;
    // 复制一份纯 Size：box.size 在 debug 模式带 _DebugSize 归属标记，
    // 直接存入 state 再作为 CustomPaint.preferredSize 参与布局，
    // 会触发 debugAdoptSize 断言（尺寸归属协议违规）。
    final size = Size(boxSize.width, boxSize.height);
    if (size != _childSize) {
      setState(() => _childSize = size); // 相等跳过，避免循环
    }
  }

  /// 构建水印覆盖层（不依赖父约束，按测量尺寸绘制）。
  Widget _buildOverlay(AntThemeData theme) {
    return IgnorePointer(
      child: Opacity(
        opacity: widget.opacity.clamp(0.0, 1.0),
        child: CustomPaint(
          key: kAntWatermarkPaintKey,
          size: _childSize,
          painter: _WatermarkPainter(
            content: widget.lines,
            fontSize: widget.fontSize ?? kAntWatermarkFontSize,
            fontColor: widget.fontColor ?? theme.colorText,
            rotate: widget.rotate,
            gapX: widget.gapX,
            gapY: widget.gapY,
            zIndex: widget.zIndex,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final overlay = _buildOverlay(theme);

    final child = widget.child;
    if (child == null) {
      // 填充模式：父级有界
      return Stack(
        key: kAntWatermarkLayerKey,
        fit: StackFit.expand,
        children: [ClipRect(child: overlay)],
      );
    }
    return Stack(
      key: kAntWatermarkLayerKey,
      children: [
        KeyedSubtree(key: _childKey, child: child),
        // 水印层与 child 等尺寸居中叠放（尺寸相等即完全覆盖）；
        // 首帧测量完成前暂不展示水印层。
        if (_childSize != Size.zero)
          SizedBox.fromSize(size: _childSize, child: overlay),
      ],
    );
  }
}

// ============================================================
// _WatermarkPainter — 平铺水印画笔
// ============================================================

/// 平铺绘制水印文字的画笔：按 gapX/gapY 间距重复，
/// 整体按 [rotate] 角度旋转。
class _WatermarkPainter extends CustomPainter {
  _WatermarkPainter({
    required this.content,
    required this.fontSize,
    required this.fontColor,
    required this.rotate,
    required this.gapX,
    required this.gapY,
    required this.zIndex,
  });

  /// 水印文字（多行，已归一化）。
  final List<String> content;

  /// 字体大小。
  final double fontSize;

  /// 字体颜色。
  final Color fontColor;

  /// 旋转角度（度）。
  final double rotate;

  /// 水平间距。
  final double gapX;

  /// 垂直间距。
  final double gapY;

  /// 水印层级。
  final int zIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (content.isEmpty || size.isEmpty) return;

    // 预量测单个水印块的尺寸
    final lineHeights = <double>[];
    var tileW = 0.0;
    var tileH = 0.0;
    final textPainters = <TextPainter>[];
    for (final line in content) {
      final tp = TextPainter(
        text: TextSpan(
          text: line,
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainters.add(tp);
      lineHeights.add(tp.height);
      tileW = math.max(tileW, tp.width);
      tileH += tp.height + fontSize * 0.3;
    }

    final stepX = tileW + gapX;
    final stepY = tileH + gapY;
    if (stepX <= 0 || stepY <= 0) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotate * math.pi / 180);

    // 旋转后覆盖整个画布所需的绘制半径
    final radius = math.sqrt(
          size.width * size.width + size.height * size.height,
        ) /
        2;

    final cols = (radius * 2 / stepX).ceil() + 1;
    final rows = (radius * 2 / stepY).ceil() + 1;

    final lineGap = fontSize * 0.3;
    for (var r = -rows; r <= rows; r++) {
      for (var c = -cols; c <= cols; c++) {
        final origin = Offset(
          -radius + c * stepX + gapX / 2,
          -radius + r * stepY + gapY / 2,
        );
        if (origin.dx > size.width / 2 + radius ||
            origin.dy > size.height / 2 + radius) {
          continue;
        }
        var dy = origin.dy;
        for (var i = 0; i < textPainters.length; i++) {
          textPainters[i].paint(canvas, Offset(origin.dx, dy));
          dy += lineHeights[i] + lineGap;
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.content != content ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.fontColor != fontColor ||
        oldDelegate.rotate != rotate ||
        oldDelegate.gapX != gapX ||
        oldDelegate.gapY != gapY ||
        oldDelegate.zIndex != zIndex;
  }
}
