/// AntErrorBlock — antd-mobile v5 ErrorBlock 的 Flutter 实现
///
/// API 与 antd-mobile v5 ErrorBlock 对齐：
/// - [AntErrorBlock.status] — 错误块状态（default/empty/disconnected/busy），决定默认插图与文案
/// - [AntErrorBlock.title] — 主标题（缺省按 status 使用默认文案）
/// - [AntErrorBlock.description] — 描述文案（缺省按 status 使用默认文案）
/// - [AntErrorBlock.image] — 自定义插图（覆盖默认自绘插画）
/// - [AntErrorBlock.children] — 操作区（如按钮组）
///
/// ```dart
/// AntErrorBlock(status: AntErrorBlockStatus.empty)
/// AntErrorBlock(
///   status: AntErrorBlockStatus.disconnected,
///   title: '网络不给力',
///   children: AntButton(child: Text('点击刷新'), onTap: () {}),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_error_block_types.dart';
export 'ant_error_block_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntErrorBlock
// ============================================================

/// 错误块 — 用于页面局部出现错误/空数据时的占位提示。
///
/// 对齐 antd-mobile v5 ErrorBlock 组件。
class AntErrorBlock extends StatelessWidget {
  const AntErrorBlock({
    super.key,
    this.status = AntErrorBlockStatus.defaultStatus,
    this.title,
    this.description,
    this.image,
    this.children,
  });

  /// 插图组件 Key（便于测试定位自绘插画）。
  static const Key illustrationKey = Key('ant_error_block_illustration');

  /// 错误块状态（决定默认插图与文案）。
  final AntErrorBlockStatus status;

  /// 主标题（缺省按 status 展示默认文案）。
  final String? title;

  /// 描述文案（缺省按 status 展示默认文案）。
  final String? description;

  /// 自定义插图（覆盖默认自绘插画）。
  final Widget? image;

  /// 操作区（如按钮组）。
  final Widget? children;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image ??
            CustomPaint(
              key: AntErrorBlock.illustrationKey,
              size: const Size(100, 100),
              painter: _ErrorBlockIllustration(status: status, theme: theme),
            ),
        const SizedBox(height: 12),
        Text(
          title ?? status.defaultTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description ?? status.defaultDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: theme.fontSize,
            color: theme.colorTextSecondary,
          ),
        ),
        if (children != null) ...[
          const SizedBox(height: 16),
          children!,
        ],
      ],
    );
  }
}

// ============================================================
// 自绘简化插画
// ============================================================

/// 按 status 自绘的简化插画（不依赖网络图片）。
class _ErrorBlockIllustration extends CustomPainter {
  const _ErrorBlockIllustration({required this.status, required this.theme});

  final AntErrorBlockStatus status;
  final AntThemeData theme;

  /// 主填充色（浅灰底）。
  Color get _fill => theme.colorBgLayout;

  /// 主线条色（次级文本色）。
  Color get _line => theme.colorTextSecondary;

  /// 高亮色（主题色点缀）。
  Color get _accent => theme.colorPrimary;

  @override
  void paint(Canvas canvas, Size size) {
    switch (status) {
      case AntErrorBlockStatus.defaultStatus:
        _paintSadFace(canvas, size);
      case AntErrorBlockStatus.empty:
        _paintEmptyBox(canvas, size);
      case AntErrorBlockStatus.disconnected:
        _paintDisconnected(canvas, size);
      case AntErrorBlockStatus.busy:
        _paintBusyClock(canvas, size);
    }
  }

  /// default — 简约页面卡片上的愁容。
  void _paintSadFace(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.72,
      height: size.height * 0.82,
    );
    final card = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(card, Paint()..color = _fill);
    canvas.drawRRect(
      card,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = _line,
    );
    // 双眼
    final eyePaint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = _line;
    canvas.drawLine(Offset(rect.left + 22, rect.top + 26),
        Offset(rect.left + 30, rect.top + 32), eyePaint,);
    canvas.drawLine(Offset(rect.right - 30, rect.top + 26),
        Offset(rect.right - 22, rect.top + 32), eyePaint,);
    // 下弯嘴
    final mouthPath = Path()
      ..moveTo(rect.left + 22, rect.top + 52)
      ..quadraticBezierTo(rect.left + 36, rect.top + 42, rect.left + 50, rect.top + 52);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = _line,
    );
  }

  /// empty — 开盖空盒子。
  void _paintEmptyBox(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final boxTop = size.height * 0.42;
    final boxW = size.width * 0.66;
    final boxH = size.height * 0.4;
    final boxRect = Rect.fromLTWH(cx - boxW / 2, boxTop, boxW, boxH);
    // 盒身
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(4)),
      Paint()..color = _fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(4)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = _line,
    );
    // 开盖的两翼
    final lidPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = _line;
    canvas.drawLine(Offset(cx - boxW / 2, boxTop),
        Offset(cx - boxW / 2 - 14, boxTop - 16), lidPaint,);
    canvas.drawLine(Offset(cx + boxW / 2, boxTop),
        Offset(cx + boxW / 2 + 14, boxTop - 16), lidPaint,);
    // 内部虚位提示点
    canvas.drawCircle(
      Offset(cx, boxTop + boxH / 2),
      4,
      Paint()..color = _accent.withValues(alpha: 0.6),
    );
  }

  /// disconnected — 断网云朵与斜杠。
  void _paintDisconnected(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.44;
    final cloudPaint = Paint()..color = _fill;
    final cloudLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _line;
    final r = size.width * 0.16;
    final circles = <Offset>[
      Offset(cx - r * 1.4, cy + r * 0.3),
      Offset(cx, cy - r * 0.4),
      Offset(cx + r * 1.4, cy + r * 0.3),
    ];
    for (final c in circles) {
      canvas.drawCircle(c, r, cloudPaint);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, cy + r * 0.4),
          width: r * 4.2,
          height: r * 1.6,
        ),
        Radius.circular(r),
      ),
      cloudPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, cy + r * 0.4),
          width: r * 4.2,
          height: r * 1.6,
        ),
        Radius.circular(r),
      ),
      cloudLine,
    );
    // 断开斜杠
    canvas.drawLine(
      Offset(cx - r * 2, cy - r * 1.6),
      Offset(cx + r * 2, cy + r * 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = _accent,
    );
  }

  /// busy — 时钟（等待/繁忙）。
  void _paintBusyClock(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width * 0.36;
    canvas.drawCircle(center, r, Paint()..color = _fill);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = _line,
    );
    // 表针
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - r * 0.6),
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = _line,
    );
    canvas.drawLine(
      center,
      Offset(center.dx + r * 0.5, center.dy + r * 0.2),
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = _accent,
    );
  }

  @override
  bool shouldRepaint(covariant _ErrorBlockIllustration oldDelegate) =>
      oldDelegate.status != status || oldDelegate.theme != theme;
}
