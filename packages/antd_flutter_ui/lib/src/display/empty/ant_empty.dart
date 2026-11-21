/// AntEmpty — antd React Empty 的 Flutter 实现
///
/// API 与 antd React Empty 对齐：
/// - [description] — 描述文字
/// - [image] — 图片样式预设
/// - [imageWidget] — 自定义图片 Widget
/// - [child] — 底部额外内容
///
/// ```dart
/// AntEmpty(description: '暂无数据')
/// AntEmpty(description: '自定义', imageWidget: Icon(AntIcons.inboxOutlined))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_empty_types.dart';
export 'ant_empty_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntEmpty
// ============================================================

/// 空状态 — 空状态时的展示占位图。
///
/// 对齐 antd React Empty 组件。
class AntEmpty extends StatelessWidget {
  const AntEmpty({
    super.key,
    this.description = '暂无数据',
    this.image = AntEmptyImage.standard,
    this.imageWidget,
    this.child,
  });

  /// 描述文字。
  final String? description;

  /// 图片样式预设。
  final AntEmptyImage image;

  /// 自定义图片 Widget（优先级高于 [image]）。
  final Widget? imageWidget;

  /// 底部额外内容。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    Widget imageContent;
    if (imageWidget != null) {
      imageContent = imageWidget!;
    } else {
      imageContent = _buildDefaultImage(theme);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imageContent,
        SizedBox(height: theme.s(8)),
        if (description != null)
          Text(
            description!,
            style: TextStyle(
              fontSize: theme.fontSize,
              color: theme.colorTextDisabled,
            ),
          ),
        if (child != null) ...[
          SizedBox(height: theme.s(16)),
          child!,
        ],
      ],
    );
  }

  Widget _buildDefaultImage(AntThemeData theme) {
    switch (image) {
      case AntEmptyImage.standard:
        return SizedBox(
          width: theme.s(64),
          height: theme.s(41),
          child: CustomPaint(
            painter: _EmptyPainter(
              borderColor: theme.colorSplit,
              fillColor: theme.colorFillSecondary,
              iconColor: theme.colorTextQuaternary,
            ),
          ),
        );
      case AntEmptyImage.simple:
        return Container(
          width: theme.s(64),
          height: theme.s(41),
          decoration: BoxDecoration(
            color: theme.colorFillSecondary,
            borderRadius: BorderRadius.circular(theme.borderRadius),
          ),
          child: Icon(
            AntIcons.inboxOutlined,
            size: theme.s(24),
            color: theme.colorTextQuaternary,
          ),
        );
    }
  }
}

/// 空状态默认插画绘制器。
class _EmptyPainter extends CustomPainter {
  _EmptyPainter({
    required this.borderColor,
    required this.fillColor,
    required this.iconColor,
  });

  final Color borderColor;
  final Color fillColor;
  final Color iconColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, h * 0.25, w, h * 0.75);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(w * 0.05));

    // 底部容器
    canvas.drawRRect(rrect, Paint()..color = fillColor);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // 中间空白区域
    final innerRect = Rect.fromLTWH(
      w * 0.15,
      h * 0.15,
      w * 0.7,
      h * 0.35,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(w * 0.03)),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // 底部两个小点
    final dotPaint = Paint()..color = borderColor;
    canvas.drawCircle(Offset(w * 0.3, h * 0.85), 2, dotPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.85), 2, dotPaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.85), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _EmptyPainter old) =>
      borderColor != old.borderColor ||
      fillColor != old.fillColor ||
      iconColor != old.iconColor;
}