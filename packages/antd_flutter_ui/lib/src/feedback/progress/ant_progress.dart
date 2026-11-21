/// AntProgress — antd React Progress 的 Flutter 实现
///
/// API 与 antd React Progress 对齐：
/// - [type] — line / circle
/// - [percent] — 百分比 0~100
/// - [size] — line 模式轨道粗细 / circle 模式整体尺寸
/// - [strokeWidth] — circle 模式圆弧粗细
/// - [strokeColor] — 自定义进度条颜色
/// - [trailColor] — 轨道颜色
/// - [showInfo] — 是否显示百分比文字
/// - [status] — 状态色 normal/success/exception/active
/// - [strokeLinecap] — circle 模式线帽形状
/// - [format] — 自定义百分比文字
///
/// ```dart
/// AntProgress(percent: 30)
/// AntProgress(percent: 70, status: AntProgressStatus.exception)
/// AntProgress(percent: 75, type: AntProgressType.circle)
/// ```
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';

import 'ant_progress_types.dart';
export 'ant_progress_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntProgress
// ============================================================

/// 进度条 — 展示操作的当前进度。
///
/// 对齐 antd React Progress 组件。
class AntProgress extends StatefulWidget {
  const AntProgress({
    super.key,
    this.type = AntProgressType.line,
    this.percent = 0,
    this.size,
    this.strokeWidth,
    this.strokeColor,
    this.trailColor,
    this.showInfo = true,
    this.status = AntProgressStatus.normal,
    this.strokeLinecap = StrokeCap.round,
    this.format,
  });

  /// 进度条类型。
  final AntProgressType type;

  /// 百分比 0~100。
  final double percent;

  /// line 模式：轨道粗细；circle 模式：整体尺寸（直径）。
  final double? size;

  /// circle 模式圆弧粗细。
  final double? strokeWidth;

  /// 自定义进度条颜色。
  final Color? strokeColor;

  /// 轨道颜色。
  final Color? trailColor;

  /// 是否显示百分比文字。
  final bool showInfo;

  /// 状态色。
  final AntProgressStatus status;

  /// circle 模式线帽形状。
  final StrokeCap strokeLinecap;

  /// 自定义百分比文字。
  final String Function(double percent)? format;

  @override
  State<AntProgress> createState() => _AntProgressState();
}

class _AntProgressState extends State<AntProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _displayPercent = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _setupAnimation();
  }

  @override
  void didUpdateWidget(covariant AntProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _setupAnimation();
    }
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _displayPercent,
      end: widget.percent.clamp(0.0, 100.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AntThemeData get _theme => AntTheme.of(context);

  Color get _strokeColor {
    if (widget.strokeColor != null) return widget.strokeColor!;
    switch (widget.status) {
      case AntProgressStatus.normal:
      case AntProgressStatus.active:
        return _theme.colorPrimary;
      case AntProgressStatus.success:
        return _theme.colorSuccess;
      case AntProgressStatus.exception:
        return _theme.colorError;
    }
  }

  Color get _trailColor =>
      widget.trailColor ??
      (widget.status == AntProgressStatus.exception
          ? _theme.colorErrorBg
          : widget.status == AntProgressStatus.success
              ? _theme.colorSuccessBg
              : _theme.colorFillQuaternary);

  String _formatText(double percent) {
    if (widget.format != null) return widget.format!(percent);
    if (widget.status == AntProgressStatus.success) return '已完成';
    if (widget.status == AntProgressStatus.exception) return '加载失败';
    return '${percent.round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        _displayPercent = _animation.value;
        return widget.type == AntProgressType.circle
            ? _buildCircle(theme)
            : _buildLine(theme);
      },
    );
  }

  // ------------------------------------------------------------
  // line 模式
  // ------------------------------------------------------------
  Widget _buildLine(AntThemeData theme) {
    final strokeWidth = widget.size ?? 8.w;
    final percent = _displayPercent.clamp(0.0, 100.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: strokeWidth,
            decoration: BoxDecoration(
              color: _trailColor,
              borderRadius: BorderRadius.circular(strokeWidth / 2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: _strokeColor,
                  borderRadius: BorderRadius.circular(strokeWidth / 2),
                ),
              ),
            ),
          ),
        ),
        if (widget.showInfo) ...[
          SizedBox(width: 8.w),
          Text(
            _formatText(percent),
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: widget.status == AntProgressStatus.exception
                  ? theme.colorError
                  : widget.status == AntProgressStatus.success
                      ? theme.colorSuccess
                      : theme.colorText,
            ),
          ),
        ],
      ],
    );
  }

  // ------------------------------------------------------------
  // circle 模式
  // ------------------------------------------------------------
  Widget _buildCircle(AntThemeData theme) {
    final diameter = widget.size ?? 120.w;
    final arcWidth = widget.strokeWidth ?? 6.w;
    final percent = _displayPercent.clamp(0.0, 100.0);

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(diameter),
            painter: _CircleProgressPainter(
              percent: percent / 100,
              strokeWidth: arcWidth,
              strokeColor: _strokeColor,
              trailColor: _trailColor,
              strokeLinecap: widget.strokeLinecap,
            ),
          ),
          if (widget.showInfo)
            Text(
              _formatText(percent),
              style: TextStyle(
                fontSize: diameter * 0.2,
                color: theme.colorTextHeading,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// 圆形进度 Painter
// ============================================================

class _CircleProgressPainter extends CustomPainter {
  _CircleProgressPainter({
    required this.percent,
    required this.strokeWidth,
    required this.strokeColor,
    required this.trailColor,
    required this.strokeLinecap,
  });

  final double percent;
  final double strokeWidth;
  final Color strokeColor;
  final Color trailColor;
  final StrokeCap strokeLinecap;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeInset = strokeWidth / 2;
    final radius = math.min(size.width, size.height) / 2 - strokeInset;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeLinecap
      ..color = trailColor;
    canvas.drawArc(rect, 0, math.pi * 2, false, trailPaint);

    if (percent > 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeLinecap
        ..color = strokeColor;
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * percent, false, paint);
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) =>
      oldDelegate.percent != percent ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.strokeColor != strokeColor ||
      oldDelegate.trailColor != trailColor ||
      oldDelegate.strokeLinecap != strokeLinecap;
}
