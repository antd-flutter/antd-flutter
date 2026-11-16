/// AntLoading — antd-mobile Loading（加载）的 Flutter 实现
///
/// 与 AntSpin（桌面风格：size 三档/tip/child 遮罩模式）不同，AntLoading
/// 是移动端轻量纯转圈图标。
///
/// API 与 antd-mobile v5 对齐：
/// - [AntLoading.color] — 图标颜色（默认主色）
/// - [AntLoading.size] — 图标尺寸（默认 18）
/// - [AntLoading.child] — 可选内容（显示在转圈图标旁/下方）
/// - [AntLoading.speed] — 旋转速度（默认 [AntLoadingSpeed.normal]）
/// - [AntLoading.direction] — 内容排布方向（默认右侧）
///
/// ```dart
/// AntLoading()
/// AntLoading(size: 24, color: theme.colorError)
/// AntLoading(child: Text('加载中...'))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_loading_types.dart';
export 'ant_loading_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 旋转圆环 key，便于测试断言动画与尺寸。
const Key kAntLoadingRingKey = Key('__ant_loading_ring__');

/// 旋转容器 key（RotationTransition 外层）。
const Key kAntLoadingRotateKey = Key('__ant_loading_rotate__');

// ============================================================
// AntLoading
// ============================================================

/// 加载 — 移动端轻量旋转加载图标。
///
/// 对齐 antd-mobile Loading 组件：四分之三圆弧匀速旋转，
/// 颜色默认取主题主色，可通过 [AntLoading.color]/[AntLoading.size] 定制，
/// 传入 [AntLoading.child] 时与内容组合展示。
class AntLoading extends StatefulWidget {
  const AntLoading({
    super.key,
    this.color,
    this.size = kAntLoadingSize,
    this.child,
    this.speed = AntLoadingSpeed.normal,
    this.direction = kAntLoadingDefaultDirection,
  });

  /// 图标颜色（默认主色）。
  final Color? color;

  /// 图标尺寸（默认 18）。
  final double size;

  /// 可选内容（与转圈图标组合展示）。
  final Widget? child;

  /// 旋转速度（默认 [AntLoadingSpeed.normal]）。
  final AntLoadingSpeed speed;

  /// 内容排布方向（默认图标在左、内容在右）。
  final AntLoadingDirection direction;

  @override
  State<AntLoading> createState() => _AntLoadingState();
}

class _AntLoadingState extends State<AntLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: (1000 ~/ widget.speed.revolutionsPerSecond),
    ),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final Color color = widget.color ?? theme.colorPrimary;

    final Widget ring = RotationTransition(
      key: kAntLoadingRotateKey,
      turns: _controller,
      child: SizedBox(
        key: kAntLoadingRingKey,
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _LoadingRingPainter(paintColor: color)),
      ),
    );

    final Widget? inner = widget.child;
    if (inner == null) return ring;

    final List<Widget> children = [
      ring,
      SizedBox(width: widget.size / 3, height: widget.size / 3),
      inner,
    ];

    return widget.direction == AntLoadingDirection.row
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// 转圈绘制器（3/4 圆弧，模拟 antd-mobile 加载缺口）。
class _LoadingRingPainter extends CustomPainter {
  const _LoadingRingPainter({required this.paintColor});

  /// 描边颜色（公开字段，供测试断言）。
  final Color paintColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = kAntLoadingStrokeWidth
      ..strokeCap = StrokeCap.round;

    final double radius = (size.shortestSide - paint.strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, 0, kAntLoadingArcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_LoadingRingPainter oldDelegate) =>
      oldDelegate.paintColor != paintColor;
}
