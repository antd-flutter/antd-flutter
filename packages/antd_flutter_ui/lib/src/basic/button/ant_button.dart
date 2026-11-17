/// AntButton — Ant Design v6 Button 的 Flutter 实现
///
/// API 与 antd React 版对齐（PascalCase Widget + camelCase 参数）：
/// - [type]：按钮类型（normal/primary/dashed/link/text）
/// - [color]：颜色语义（可覆盖 type 映射的默认色）
/// - [variant]：变体（可覆盖 type 映射的默认变体）
/// - [danger]：危险按钮（强制 color=danger）
/// - [ghost]：幽灵按钮（透明背景）
/// - [shape]：形状（normal/circle/round/square）
/// - [size]：尺寸（large/middle/small）
/// - [block]：撑满父容器宽度
/// - [icon]：图标 Widget
/// - [iconPlacement]：图标位置（start/end）
/// - [loading]：加载中（显示旋转指示器，替换图标）
/// - [disabled]：禁用
/// - [onTap]：点击回调
/// - [child]：内容（通常为文字）
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_button_size_resolver.dart';
import 'ant_button_style.dart';
import 'ant_button_types.dart';
import 'ant_button_variant_resolver.dart';

/// Ant Design Button 组件。
///
/// 颜色矩阵、尺寸形状均从 [AntThemeData] 令牌实时解析，
/// 与 antd v6 `button/style/variant.ts` + `token.ts` 逐值对齐。
class AntButton extends StatefulWidget {
  const AntButton({
    super.key,
    this.type = AntButtonType.normal,
    this.color,
    this.variant,
    this.danger = false,
    this.ghost = false,
    this.shape = AntButtonShape.normal,
    this.size = AntButtonSize.middle,
    this.block = false,
    this.icon,
    this.iconPlacement = AntButtonIconPlacement.start,
    this.loading = false,
    this.disabled = false,
    this.onTap,
    this.child,
  });

  /// 按钮类型，映射到默认的 color + variant 组合。
  final AntButtonType type;

  /// 显式颜色语义，覆盖 type 映射的默认色。
  final AntButtonColor? color;

  /// 显式变体，覆盖 type 映射的默认变体。
  final AntButtonVariant? variant;

  /// 危险按钮，强制 color = danger。
  final bool danger;

  /// 幽灵按钮，背景透明。
  final bool ghost;

  /// 按钮形状。
  final AntButtonShape shape;

  /// 按钮尺寸。
  final AntButtonSize size;

  /// 撑满父容器宽度。
  final bool block;

  /// 图标 Widget（加载中时被旋转指示器替换）。
  final Widget? icon;

  /// 图标位置（文字前/后）。
  final AntButtonIconPlacement iconPlacement;

  /// 加载中状态。
  final bool loading;

  /// 禁用状态。
  final bool disabled;

  /// 点击回调。
  final VoidCallback? onTap;

  /// 按钮内容（通常为文字）。
  final Widget? child;

  @override
  State<AntButton> createState() => _AntButtonState();
}

class _AntButtonState extends State<AntButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _onEnter(PointerEnterEvent _) => setState(() => _hovered = true);

  void _onExit(PointerExitEvent _) => setState(() {
        _hovered = false;
        _pressed = false;
      });

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);

  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);

  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    // ---- 1. 解析 variant（type → color+variant，danger/ghost 覆盖）----
    final resolved = resolveButtonVariant(
      type: widget.type,
      color: widget.color,
      variant: widget.variant,
      danger: widget.danger,
      ghost: widget.ghost,
    );

    // ---- 2. 解析颜色矩阵（四态）----
    final style = resolveButtonStyle(
      color: resolved.color,
      variant: resolved.variant,
      ghost: widget.ghost,
      theme: theme,
    );

    // ---- 3. 解析尺寸 + 形状 ----
    final iconOnly = widget.child == null;
    final sizeStyle = resolveButtonSize(
      size: widget.size,
      shape: widget.shape,
      iconOnly: iconOnly,
      block: widget.block,
      theme: theme,
    );

    // ---- 4. 选取当前视觉态 ----
    final AntButtonVisualState visual;
    if (widget.disabled) {
      visual = style.disabled;
    } else if (_pressed) {
      visual = style.active;
    } else if (_hovered) {
      visual = style.hover;
    } else {
      visual = style.normal;
    }

    // ---- 5. 构建内容行 ----
    final content = _buildContent(sizeStyle, visual.textColor, theme);

    // ---- 6. 容器约束 ----
    final lineWidth = theme.lineWidth;
    final isDashed = resolved.variant == AntButtonVariant.dashed;

    // ---- 7. 组装 ----
    Widget button = AnimatedContainer(
      duration: theme.motionDurationMid,
      curve: Curves.easeInOut,
      height: sizeStyle.height,
      padding: EdgeInsets.symmetric(horizontal: sizeStyle.paddingInline),
      decoration: BoxDecoration(
        color: visual.background,
        // dashed 用 CustomPaint 绘制虚线边框，此处用透明边框占位保持布局一致
        border: Border.all(
          color: isDashed ? const Color(0x00000000) : visual.borderColor,
          width: lineWidth,
        ),
        borderRadius: BorderRadius.circular(sizeStyle.borderRadius),
        boxShadow: visual.shadow,
      ),
      child: content,
    );

    // 宽度约束
    if (sizeStyle.width != null) {
      button = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: sizeStyle.width == double.infinity ? 0 : sizeStyle.width!,
          maxWidth: sizeStyle.width == double.infinity
              ? double.infinity
              : sizeStyle.width!,
        ),
        child: button,
      );
    }

    // dashed 虚线边框覆盖绘制
    if (isDashed) {
      button = CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: visual.borderColor,
          lineWidth: lineWidth,
          borderRadius: sizeStyle.borderRadius,
        ),
        child: button,
      );
    }

    // loading 透明度（antd: opacityLoading = 0.65）
    if (widget.loading) {
      button = Opacity(opacity: theme.opacityLoading, child: button);
    }

    // 交互层
    final interactive = !widget.disabled;
    button = MouseRegion(
      onEnter: interactive ? _onEnter : null,
      onExit: interactive ? _onExit : null,
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : (widget.loading
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click),
      child: GestureDetector(
        onTapDown: interactive ? _onTapDown : null,
        onTapUp: interactive ? _onTapUp : null,
        onTapCancel: interactive ? _onTapCancel : null,
        onTap: interactive ? widget.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );

    return button;
  }

  /// 构建内容行（图标 + 间距 + 文字）。
  Widget _buildContent(
    AntButtonSizeStyle sizeStyle,
    Color textColor,
    AntThemeData theme,
  ) {
    final hasContent = widget.child != null;

    // 图标位 Widget（loading 时替换为旋转指示器）
    Widget? iconWidget;
    if (widget.loading) {
      iconWidget = _LoadingIcon(
        size: sizeStyle.fontSize,
        color: textColor,
      );
    } else if (widget.icon != null) {
      iconWidget = IconTheme.merge(
        data: IconThemeData(color: textColor, size: sizeStyle.fontSize),
        child: widget.icon!,
      );
    }

    // 内容 Widget（继承文字色/字号/字重）
    Widget? contentWidget;
    if (hasContent) {
      contentWidget = DefaultTextStyle.merge(
        style: TextStyle(
          color: textColor,
          fontSize: sizeStyle.fontSize,
          fontWeight: FontWeight.w400, // antd: fontWeight = 400
        ),
        child: widget.child!,
      );
    }

    // 按图标位置组装
    final List<Widget> children;
    if (widget.iconPlacement == AntButtonIconPlacement.start) {
      children = [
        if (iconWidget != null) iconWidget,
        if (iconWidget != null && contentWidget != null)
          SizedBox(width: sizeStyle.iconGap),
        if (contentWidget != null) contentWidget,
      ];
    } else {
      children = [
        if (contentWidget != null) contentWidget,
        if (contentWidget != null && iconWidget != null)
          SizedBox(width: sizeStyle.iconGap),
        if (iconWidget != null) iconWidget,
      ];
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

/// 加载旋转指示器（替代 antd LoadingOutlined）。
class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: math.max(size * 0.12, 1.5),
        color: color,
      ),
    );
  }
}

/// 虚线边框绘制器（用于 dashed 变体）。
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.lineWidth,
    required this.borderRadius,
  });

  final Color color;
  final double lineWidth;
  final double borderRadius;

  static const double _dashLength = 4;
  static const double _gapLength = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(lineWidth / 2),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashed = _dashPath(path);
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final len = math.min(_dashLength, metric.length - distance);
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        distance += _dashLength + _gapLength;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      color != old.color ||
      lineWidth != old.lineWidth ||
      borderRadius != old.borderRadius;
}
