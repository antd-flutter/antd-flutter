/// AntAvatar — antd React Avatar 的 Flutter 实现
///
/// API 与 antd React Avatar 对齐：
/// - [src] — 图片地址
/// - [icon] — 自定义图标
/// - [child] — 文字内容
/// - [shape] — 形状（圆形/方形）
/// - [size] — 尺寸（数值或预设）
/// - [gap] — 文字与边框间距
/// - [draggable] — 图片是否可拖拽
/// - [onError] — 图片加载失败回调
/// - [backgroundColor] — 背景色
///
/// AntAvatarGroup：
/// - [maxCount] — 最大显示数量
/// - [maxStyle] — 剩余数量样式
///
/// ```dart
/// AntAvatar(child: 'A')
/// AntAvatar(src: 'https://example.com/a.png')
/// AntAvatarGroup(maxCount: 3, children: [...])
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_avatar_types.dart';
export 'ant_avatar_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntAvatar
// ============================================================

/// 头像 — 用于用户头像或品牌标识，支持图片、图标和文字。
///
/// 对齐 antd React Avatar 组件。
class AntAvatar extends StatelessWidget {
  const AntAvatar({
    super.key,
    this.src,
    this.icon,
    this.child,
    this.shape = AntAvatarShape.circle,
    this.size,
    this.presetSize,
    this.gap = 4,
    this.draggable = false,
    this.onError,
    this.backgroundColor,
    this.fit,
  });

  /// 图片地址，优先级最高。
  final String? src;

  /// 自定义图标，src 为空时生效。
  final Widget? icon;

  /// 文字内容，src 和 icon 均为空时生效。
  final String? child;

  /// 形状，默认圆形。
  final AntAvatarShape shape;

  /// 自定义像素尺寸。
  final double? size;

  /// 预设尺寸。
  final AntAvatarSize? presetSize;

  /// 文字与边框间距。
  final double gap;

  /// 图片是否可拖拽。
  final bool draggable;

  /// 图片加载失败回调。
  final VoidCallback? onError;

  /// 背景色，默认取主题色。
  final Color? backgroundColor;

  /// 图片填充模式。
  final BoxFit? fit;

  /// 解析实际尺寸。
  double _resolveSize() {
    if (size != null) return size!;
    if (presetSize != null) return antAvatarSizeToPx(presetSize!);
    return antAvatarSizeToPx(AntAvatarSize.standard);
  }

  BorderRadius _resolveBorderRadius(double px) {
    switch (shape) {
      case AntAvatarShape.circle:
        return BorderRadius.circular(px / 2);
      case AntAvatarShape.square:
        return BorderRadius.circular(px * 0.15);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final px = _resolveSize();
    final radius = _resolveBorderRadius(px);
    final bg = backgroundColor ?? theme.colorPrimary;
    const fg = Colors.white;

    Widget content;
    if (src != null) {
      content = ClipRRect(
        borderRadius: radius,
        child: Image.network(
          src!,
          width: px,
          height: px,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            if (onError != null) onError!();
            return _buildFallback(px, bg, fg);
          },
        ),
      );
    } else if (icon != null) {
      content = Container(
        width: px,
        height: px,
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        alignment: Alignment.center,
        child: IconTheme.merge(
          data: IconThemeData(color: fg, size: px * 0.5),
          child: icon!,
        ),
      );
    } else if (child != null && child!.isNotEmpty) {
      final text = child!;
      final fontSize = text.length <= 1 ? px * 0.45 : px * 0.35;
      content = Container(
        width: px,
        height: px,
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: fg,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    } else {
      content = _buildFallback(px, bg, fg);
    }

    return content;
  }

  Widget _buildFallback(double px, Color bg, Color fg) {
    return Container(
      width: px,
      height: px,
      decoration: BoxDecoration(color: bg, borderRadius: _resolveBorderRadius(px)),
      alignment: Alignment.center,
      child: Icon(Icons.person, color: fg, size: px * 0.5),
    );
  }
}

// ============================================================
// AntAvatarGroup
// ============================================================

/// 头像组 — 多个头像堆叠展示，支持最大数量限制。
///
/// 对齐 antd React Avatar.Group 组件。
class AntAvatarGroup extends StatelessWidget {
  const AntAvatarGroup({
    super.key,
    required this.children,
    this.maxCount,
    this.size,
    this.presetSize,
    this.maxStyle,
    this.spacing = -8,
  });

  /// 头像列表。
  final List<AntAvatar> children;

  /// 最大显示数量，超出部分显示 +N。
  final int? maxCount;

  /// 自定义像素尺寸（应用到所有子头像）。
  final double? size;

  /// 预设尺寸（应用到所有子头像）。
  final AntAvatarSize? presetSize;

  /// +N 提示的自定义样式。
  final TextStyle? maxStyle;

  /// 头像间距，负值产生堆叠效果。
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final px = size ?? (presetSize != null ? antAvatarSizeToPx(presetSize!) : null);

    final avatars = <Widget>[];
    final list = children;
    final showCount = maxCount != null && list.length > maxCount!
        ? maxCount! - 1
        : list.length;

    for (var i = 0; i < showCount && i < list.length; i++) {
      final a = list[i];
      avatars.add(
        AntAvatar(
          key: a.key,
          src: a.src,
          icon: a.icon,
          child: a.child,
          shape: a.shape,
          size: px ?? a.size,
          presetSize: px == null ? (a.presetSize ?? presetSize) : null,
          gap: a.gap,
          backgroundColor: a.backgroundColor,
        ),
      );
    }

    if (maxCount != null && list.length > maxCount!) {
      final remaining = list.length - showCount;
      final plusPx = px ?? antAvatarSizeToPx(AntAvatarSize.standard);
      avatars.add(
        Container(
          width: plusPx,
          height: plusPx,
          decoration: BoxDecoration(
            color: theme.colorFillSecondary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '+$remaining',
            style: maxStyle ??
                TextStyle(
                  color: theme.colorText,
                  fontSize: plusPx * 0.35,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      );
    }

    if (spacing < 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < avatars.length; i++)
            if (i == 0)
              avatars[i]
            else
              Transform.translate(
                offset: Offset(spacing * i, 0),
                child: avatars[i],
              ),
        ],
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: 0,
      children: avatars,
    );
  }
}