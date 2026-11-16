/// AntSpin — antd React Spin 的 Flutter 实现
///
/// API 与 antd React Spin 对齐：
/// - [spinning] — 是否处于加载中
/// - [size] — 指示器尺寸（large/middle/small）
/// - [tip] — 加载文案（显示在指示器下方）
/// - [child] — 包裹模式：spinning 时子内容加遮罩转圈
/// - [indicator] — 自定义指示器
///
/// ```dart
/// AntSpin(spinning: true, tip: '加载中...')
/// AntSpin(spinning: spinning, child: ListView(...))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/feedback/spin/ant_spin_types.dart';
export 'package:antd_flutter_plus/src/components/feedback/spin/ant_spin_types.dart';
import 'package:flutter/material.dart';

/// 遮罩层 key（供测试与外部结构断言使用）。
const Key kAntSpinMaskKey = Key('__ant_spin_mask__');

/// 圆弧缺口比例（与 antd 圆环一致的 3/4 圆弧）。
const double _kArcSweep = 4.4;

// ============================================================
// AntSpin
// ============================================================

/// 加载中 — 用于页面或区块的等待状态。
///
/// 对齐 antd React Spin 组件。
class AntSpin extends StatefulWidget {
  const AntSpin({
    super.key,
    this.spinning = true,
    this.size = AntSpinSize.middle,
    this.tip,
    this.child,
    this.indicator,
  });

  /// 是否处于加载中。
  final bool spinning;

  /// 指示器尺寸。
  final AntSpinSize size;

  /// 加载文案（显示在指示器下方）。
  final String? tip;

  /// 包裹的内容（设置后进入包裹模式）。
  final Widget? child;

  /// 自定义指示器（设置后替代默认圆环）。
  final Widget? indicator;

  @override
  State<AntSpin> createState() => _AntSpinState();
}

class _AntSpinState extends State<AntSpin> {
  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    final inner = widget.child;
    if (inner == null) {
      return _buildIndicatorColumn(theme);
    }

    return Stack(
      children: [
        inner,
        if (widget.spinning) ...[
          Positioned.fill(
            key: kAntSpinMaskKey,
            child: Container(
              color: theme.colorBgContainer.withValues(alpha: 0.45),
              alignment: Alignment.center,
              child: _buildIndicatorColumn(theme),
            ),
          ),
        ],
      ],
    );
  }

  /// 指示器 + 可选文案的纵向组合。
  Widget _buildIndicatorColumn(AntThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIndicator(theme),
        if (widget.tip != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.tip!,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorPrimary,
            ),
          ),
        ],
      ],
    );
  }

  /// 构建指示器（自定义或默认旋转圆环）。
  Widget _buildIndicator(AntThemeData theme) {
    if (widget.indicator != null) {
      return widget.indicator!;
    }
    return _SpinRing(size: widget.size.indicatorSize, color: theme.colorPrimary);
  }
}

// ============================================================
// 默认旋转圆环指示器
// ============================================================

/// 默认圆环指示器 — 旋转动画 + CustomPainter 圆弧。
class _SpinRing extends StatefulWidget {
  const _SpinRing({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  State<_SpinRing> createState() => _SpinRingState();
}

class _SpinRingState extends State<_SpinRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: _controller.value * 2 * 3.14159265,
          child: child,
        ),
        child: CustomPaint(painter: _SpinRingPainter(color: widget.color)),
      ),
    );
  }
}

/// 圆环绘制器（3/4 圆弧，模拟 antd 转圈缺口）。
class _SpinRingPainter extends CustomPainter {
  const _SpinRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final radius = (size.shortestSide - paint.strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, 0, _kArcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_SpinRingPainter oldDelegate) =>
      oldDelegate.color != color;
}
