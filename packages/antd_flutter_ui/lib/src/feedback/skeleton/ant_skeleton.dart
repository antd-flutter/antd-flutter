/// AntSkeleton — antd React Skeleton 的 Flutter 实现
///
/// API 与 antd React Skeleton 对齐：
/// - [loading] — 为 true 时显示骨架屏，为 false 时显示 [child]
/// - [active] — 是否显示闪烁动画
/// - [avatar] — 头像占位
/// - [title] — 标题占位
/// - [paragraph] — 段落占位（可配行数）
/// - [round] — 圆角风格
/// - [children] — 自定义骨架元素（设置后替代 avatar/title/paragraph 默认组合）
/// - [child] — 实际内容（loading=false 时展示）
///
/// ```dart
/// AntSkeleton(loading: true, active: true, avatar: AntSkeletonAvatar(), paragraph: AntSkeletonParagraph(rows: 4))
/// AntSkeleton(loading: false, child: Text('实际内容'))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_skeleton_types.dart';
export 'ant_skeleton_types.dart';
import 'package:material_ui/material_ui.dart';

/// 默认段落行数
const int _kDefaultParagraphRows = 3;

// ============================================================
// AntSkeleton
// ============================================================

/// 骨架屏 — 在需要等待加载内容的位置提供一个占位图形组合。
///
/// 对齐 antd React Skeleton 组件。
class AntSkeleton extends StatelessWidget {
  const AntSkeleton({
    super.key,
    this.loading = false,
    this.active = true,
    this.round = false,
    this.avatar,
    this.title,
    this.paragraph,
    this.children,
    this.child,
  });

  /// 为 true 时显示骨架屏，为 false 时显示 [child]。
  final bool loading;

  /// 是否显示闪烁动画。
  final bool active;

  /// 圆角风格。
  final bool round;

  /// 头像占位配置。
  final AntSkeletonAvatar? avatar;

  /// 标题占位配置。
  final AntSkeletonTitle? title;

  /// 段落占位配置。
  final AntSkeletonParagraph? paragraph;

  /// 自定义骨架元素（设置后替代默认 avatar/title/paragraph 组合）。
  final List<Widget>? children;

  /// 实际内容（loading=false 时展示）。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return child != null
          ? SizedBox.shrink(child: child)
          : const SizedBox.shrink();
    }

    final theme = AntTheme.of(context);

    if (children != null && children!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final element in children!) _wrapPulse(context, element)],
      );
    }

    final showAvatar = avatar?.show ?? false;
    final showTitle = title?.show ?? true;
    final showParagraph = paragraph?.show ?? true;
    final rows = paragraph?.rows ?? _kDefaultParagraphRows;

    final barRow = <Widget>[
      if (showTitle)
        _wrapPulse(
          context,
          _SkeletonBar(
            width: title?.width ?? 160,
            height: 16,
            radius: radiusOf(theme),
            color: theme.colorFillSecondary,
          ),
        ),
      if (showParagraph)
        for (var i = 0; i < rows; i++)
          _wrapPulse(
            context,
            _SkeletonBar(
              width: _paragraphRowWidth(i, rows),
              height: 14,
              radius: radiusOf(theme),
              color: theme.colorFillSecondary,
            ),
          ),
    ];

    final textColumn = barRow.isEmpty
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < barRow.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                barRow[i],
              ],
            ],
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAvatar) ...[
          _wrapPulse(
            context,
            _SkeletonAvatarBar(
              size: avatar!.size ?? 40,
              shape: avatar!.shape,
              color: theme.colorFillSecondary,
            ),
          ),
          const SizedBox(width: 16),
        ],
        if (textColumn != null) Expanded(child: textColumn),
      ],
    );
  }

  /// 圆角半径（round 模式使用全圆角胶囊条）。
  double radiusOf(AntThemeData theme) => round ? 999 : theme.borderRadiusSM;

  /// 段落行宽度策略：最后一行缩短，其余行递进变化。
  double _paragraphRowWidth(int index, int rows) {
    if (index == rows - 1 && rows > 1) return 120;
    return 280 - (index % 3) * 20;
  }

  /// active 时包一层闪烁动画容器，否则原样返回。
  Widget _wrapPulse(BuildContext context, Widget element) {
    if (!active) return element;
    return _SkeletonPulse(child: element);
  }
}

/// 骨架屏闪烁动画容器（active=true 时存在）。
class _SkeletonPulse extends StatefulWidget {
  const _SkeletonPulse({required this.child});

  final Widget child;

  @override
  State<_SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<_SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 1,
    end: 0.4,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) =>
          Opacity(opacity: _opacity.value, child: child),
      child: widget.child,
    );
  }
}

/// 骨架屏头像占位。
class _SkeletonAvatarBar extends StatelessWidget {
  const _SkeletonAvatarBar({
    required this.size,
    required this.shape,
    required this.color,
  });

  final double size;
  final AntSkeletonAvatarShape shape;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape == AntSkeletonAvatarShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == AntSkeletonAvatarShape.circle
            ? null
            : BorderRadius.circular(6),
      ),
    );
  }
}

/// 骨架屏通用条形占位。
class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
