/// AntBorderBeam — 边框流光（社区 antd BorderBeam 效果）的 Flutter 实现
///
/// API 对齐社区 antd BorderBeam：
/// - [AntBorderBeam.child] — 容器内容
/// - [AntBorderBeam.size] — 边框宽度（默认 3）
/// - [AntBorderBeam.colorPrimary] — 流光主色
/// - [AntBorderBeam.colorSecondary] — 流光副色（渐变终点，同时是普通边框色基色）
/// - [AntBorderBeam.duration] — 动画周期（默认 6s）
/// - [AntBorderBeam.reverse] — 反向流动
/// - [AntBorderBeam.borderRadius] — 圆角
/// - [AntBorderBeam.initialOffset] — 初始相位（0~1）
///
/// ```dart
/// AntBorderBeam(
///   colorPrimary: Colors.blue,
///   borderRadius: BorderRadius.circular(12),
///   child: const Text('流光边框'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_border_beam_types.dart';
export 'ant_border_beam_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntBorderBeam
// ============================================================

/// 边框流光 — 圆角矩形边框上有一段渐变流光沿边框循环移动。
class AntBorderBeam extends StatefulWidget {
  const AntBorderBeam({
    super.key,
    required this.child,
    this.size = kAntBorderBeamDefaultSize,
    this.colorPrimary,
    this.colorSecondary,
    this.duration =
        const Duration(seconds: kAntBorderBeamDefaultDurationSeconds),
    this.reverse = false,
    this.borderRadius,
    this.initialOffset = 0,
    this.padding,
  });

  /// 容器内容。
  final Widget child;

  /// 边框宽度，默认 3。
  final double size;

  /// 流光主色，默认取主题 colorPrimary。
  final Color? colorPrimary;

  /// 流光副色，默认取主题 colorBorder。
  final Color? colorSecondary;

  /// 动画周期，默认 6 秒。
  final Duration duration;

  /// 是否反向流动，默认 false。
  final bool reverse;

  /// 圆角。
  final BorderRadius? borderRadius;

  /// 初始相位（0~1），默认 0。
  final double initialOffset;

  /// 内容内边距。
  final EdgeInsets? padding;

  @override
  State<AntBorderBeam> createState() => _AntBorderBeamState();
}

class _AntBorderBeamState extends State<AntBorderBeam>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.initialOffset.clamp(0.0, 1.0),
    )..repeat(reverse: false);
  }

  @override
  void didUpdateWidget(covariant AntBorderBeam oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final colorPrimary = widget.colorPrimary ?? theme.colorPrimary;
    final colorSecondary = widget.colorSecondary ?? theme.colorBorder;
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(theme.borderRadiusLG);

    return CustomPaint(
      key: kAntBorderBeamPaintKey,
      foregroundPainter: AntBorderBeamPainter(
        progress: _controller,
        colorPrimary: colorPrimary,
        colorSecondary: colorSecondary,
        size: widget.size,
        borderRadius: borderRadius,
        reverse: widget.reverse,
      ),
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(widget.size * 4),
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// AntBorderBeamPainter
// ============================================================

/// 边框流光画笔 — 普通色边框 + 沿边框循环移动的渐变流光段。
class AntBorderBeamPainter extends CustomPainter {
  AntBorderBeamPainter({
    required this.progress,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.size,
    required this.borderRadius,
    required this.reverse,
  }) : super(repaint: progress);

  /// 动画进度（0~1 循环）。
  final Animation<double> progress;

  /// 流光主色。
  final Color colorPrimary;

  /// 流光副色。
  final Color colorSecondary;

  /// 边框宽度。
  final double size;

  /// 圆角。
  final BorderRadius borderRadius;

  /// 是否反向流动。
  final bool reverse;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final beamProgress = reverse ? 1 - progress.value : progress.value;
    final half = size / 2;
    final inner = (Offset.zero & canvasSize).deflate(half);
    final rrect = RRect.fromRectAndCorners(
      inner,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    // 普通边框（副色的弱化版）
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size
      ..color = colorSecondary.withValues(alpha: 0.25);
    canvas.drawRRect(rrect, basePaint);

    // 流光段：沿边框路径循环移动
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final total = metric.length;
    final beamLength = total * kAntBorderBeamLengthRatio;
    final start = beamProgress * total;
    final end = (start + beamLength) % total;
    final Path beamPath;
    if (end > start) {
      beamPath = metric.extractPath(start, end);
    } else {
      beamPath = metric.extractPath(start, total);
      beamPath.addPath(metric.extractPath(0, end), Offset.zero);
    }

    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colorSecondary.withValues(alpha: 0),
          colorPrimary,
          colorSecondary.withValues(alpha: 0),
        ],
      ).createShader(beamPath.getBounds());
    canvas.drawPath(beamPath, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant AntBorderBeamPainter oldDelegate) =>
      oldDelegate.colorPrimary != colorPrimary ||
      oldDelegate.colorSecondary != colorSecondary ||
      oldDelegate.size != size ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.reverse != reverse ||
      oldDelegate.progress != progress;
}
