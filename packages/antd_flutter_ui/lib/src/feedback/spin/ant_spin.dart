/// AntSpin — antd React Spin 的 Flutter 实现
///
/// API 与 antd React Spin 对齐：
/// - [spinning] — 是否处于加载中
/// - [size] — 指示器尺寸（large/middle/small：32/20/14）
/// - [tip] — 加载文案（显示在指示器下方）
/// - [child] — 包裹模式：spinning 时子内容加遮罩转圈
/// - [indicator] — 自定义指示器
/// - [indicatorType] — 指示器样式（circle 圆环 / dot 四点旋转点阵）
/// - [fullscreen] — 全屏遮罩加载模式
/// - [delay] — 延迟显示（防快速加载闪烁，antd delay 语义）
///
/// ```dart
/// AntSpin(spinning: true, tip: '加载中...')
/// AntSpin(spinning: spinning, child: ListView(...))
/// AntSpin(spinning: true, indicatorType: AntSpinIndicatorType.dot)
/// AntSpin(spinning: true, fullscreen: true, tip: '全屏加载中')
/// AntSpin(spinning: true, delay: const Duration(milliseconds: 300))
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';

import 'ant_spin_types.dart';
export 'ant_spin_types.dart';

import 'package:material_ui/material_ui.dart';

/// 遮罩层 key（供测试与外部结构断言使用）。
const Key kAntSpinMaskKey = Key('__ant_spin_mask__');

/// 全屏遮罩层 key。
const Key kAntSpinFullscreenKey = Key('__ant_spin_fullscreen__');

/// dot 点阵指示器 key（供测试断言渲染）。
const Key kAntSpinDotsKey = Key('__ant_spin_dots__');

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
    this.indicatorType = AntSpinIndicatorType.circle,
    this.fullscreen = false,
    this.delay,
  });

  /// 是否处于加载中。
  final bool spinning;

  /// 指示器尺寸。
  final AntSpinSize size;

  /// 加载文案（显示在指示器下方）。
  final String? tip;

  /// 包裹的内容（设置后进入包裹模式）。
  final Widget? child;

  /// 自定义指示器（设置后替代默认指示器）。
  final Widget? indicator;

  /// 指示器样式（仅在未提供 [indicator] 时生效）。
  final AntSpinIndicatorType indicatorType;

  /// 是否全屏遮罩加载模式（antd Spin fullscreen：居中指示器 + 全屏半透明遮罩）。
  final bool fullscreen;

  /// 延迟显示时长。spinning 切为 true 后经过该时长才显示指示器，
  /// 防止快速加载闪烁（antd Spin delay 语义）。
  final Duration? delay;

  @override
  State<AntSpin> createState() => _AntSpinState();
}

class _AntSpinState extends State<AntSpin> {
  /// delay 语义：delay 生效期间不显示指示器。
  bool _delayElapsed = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDelay();
  }

  @override
  void didUpdateWidget(covariant AntSpin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delay != oldWidget.delay ||
        widget.spinning != oldWidget.spinning) {
      _delayTimer?.cancel();
      _delayTimer = null;
      if (!widget.spinning) {
        // 停止加载时重置 delay 语义。
        if (_delayElapsed) setState(() => _delayElapsed = false);
      } else if (widget.delay == null) {
        if (!_delayElapsed) setState(() => _delayElapsed = true);
      } else {
        _scheduleDelay();
      }
    }
  }

  void _scheduleDelay() {
    if (widget.delay == null) {
      _delayElapsed = true;
      return;
    }
    _delayElapsed = false;
    if (widget.spinning) {
      _delayTimer = Timer(widget.delay!, () {
        if (mounted && widget.spinning) {
          setState(() => _delayElapsed = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  /// 实际生效的加载状态（delay 未到时视为未加载）。
  bool get _effectiveSpinning => widget.spinning && _delayElapsed;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    final inner = widget.child;
    if (widget.fullscreen) {
      // 全屏模式：有 child 时叠加全屏遮罩，无 child 时独立全屏遮罩。
      if (inner != null) {
        return Stack(
          children: [
            inner,
            if (_effectiveSpinning)
              Positioned.fill(
                key: kAntSpinFullscreenKey,
                child: _buildFullscreenOverlay(theme),
              ),
          ],
        );
      }
      if (!_effectiveSpinning) return const SizedBox.shrink();
      // 无界上下文（如 Row/Column 直接子级）无法铺满全屏，退化为普通指示器。
      return LayoutBuilder(
        builder: (context, constraints) {
          final bounded =
              constraints.hasBoundedWidth && constraints.hasBoundedHeight;
          if (!bounded) return _buildIndicatorColumn(theme);
          return SizedBox.expand(
            key: kAntSpinFullscreenKey,
            child: _buildFullscreenOverlay(theme),
          );
        },
      );
    }

    if (inner == null) {
      if (!_effectiveSpinning) return const SizedBox.shrink();
      return _buildIndicatorColumn(theme);
    }

    return Stack(
      children: [
        inner,
        if (_effectiveSpinning) ...[
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

  /// 全屏遮罩：token 遮挡色 + 居中指示器。
  Widget _buildFullscreenOverlay(AntThemeData theme) {
    return Container(
      color: theme.colorBgContainer.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: _buildIndicatorColumn(theme),
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

  /// 构建指示器（自定义 / dot 点阵 / 默认圆环）。
  Widget _buildIndicator(AntThemeData theme) {
    if (widget.indicator != null) {
      return widget.indicator!;
    }
    switch (widget.indicatorType) {
      case AntSpinIndicatorType.dot:
        return _SpinDots(
            size: widget.size.indicatorSize, color: theme.colorPrimary,);
      case AntSpinIndicatorType.circle:
        return _SpinRing(
            size: widget.size.indicatorSize, color: theme.colorPrimary,);
    }
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

// ============================================================
// antd 经典四点旋转点阵指示器
// ============================================================

/// 四点旋转点阵 — 4 个圆点按 90° 相位差的透明度脉冲 + 整体旋转，
/// 视觉对齐 antd React Spin 默认 dot 指示器。
class _SpinDots extends StatefulWidget {
  const _SpinDots({required this.size, required this.color});

  /// 点阵外接方框边长（与 [AntSpinSize.indicatorSize] 一致）。
  final double size;

  final Color color;

  @override
  State<_SpinDots> createState() => _SpinDotsState();
}

class _SpinDotsState extends State<_SpinDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: kAntSpinDotsKey,
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159265,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(4, (i) {
                // 相位差 90°：各点依次明暗，模拟 antd dot 转圈节奏。
                final phase = (_controller.value - i * 0.25) % 1.0;
                final opacity = 0.25 + 0.75 * (1 - phase).abs();
                return Align(
                  alignment: _dotAlignment(i),
                  child: Container(
                    width: widget.size * 0.22,
                    height: widget.size * 0.22,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: opacity),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  /// 四点分布在外接方框四边中点（上下左右），旋转后形成点阵转圈。
  Alignment _dotAlignment(int i) {
    switch (i) {
      case 0:
        return Alignment.topCenter;
      case 1:
        return Alignment.centerRight;
      case 2:
        return Alignment.bottomCenter;
      default:
        return Alignment.centerLeft;
    }
  }
}
