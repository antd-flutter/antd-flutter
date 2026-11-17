/// AntCard — antd React Card 的 Flutter 实现
///
/// API 与 antd React Card 对齐：
/// - [title] — 标题
/// - [extra] — 右上角操作区
/// - [child] — 内容
/// - [cover] — 封面
/// - [actions] — 底部操作列表
/// - [bordered] — 是否有边框
/// - [hoverable] — 是否可悬浮
/// - [size] — 尺寸
/// - [loading] — 加载中
///
/// ```dart
/// AntCard(
///   title: '标题',
///   child: Text('内容'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_card_types.dart';
export 'ant_card_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntCard
// ============================================================

/// 卡片 — 通用卡片容器。
///
/// 对齐 antd React Card 组件。
class AntCard extends StatefulWidget {
  const AntCard({
    super.key,
    this.title,
    this.extra,
    required this.child,
    this.cover,
    this.actions,
    this.bordered = true,
    this.hoverable = false,
    this.size = AntCardSize.standard,
    this.loading = false,
    this.onTap,
  });

  /// 卡片标题。
  final Widget? title;

  /// 右上角操作区。
  final Widget? extra;

  /// 卡片内容。
  final Widget child;

  /// 封面图。
  final AntCardCover? cover;

  /// 底部操作列表。
  final List<AntCardAction>? actions;

  /// 是否有边框。
  final bool bordered;

  /// 是否可悬浮（悬浮时阴影加深）。
  final bool hoverable;

  /// 尺寸。
  final AntCardSize size;

  /// 是否加载中。
  final bool loading;

  /// 点击回调。
  final VoidCallback? onTap;

  @override
  State<AntCard> createState() => _AntCardState();
}

class _AntCardState extends State<AntCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final isSmall = widget.size == AntCardSize.small;
    final headerPadding = isSmall
        ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w)
        : EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w);
    final bodyPadding = isSmall
        ? EdgeInsets.all(12.w)
        : EdgeInsets.all(24.w);

    final hasHeader = widget.title != null || widget.extra != null;

    Widget content = Container(
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: widget.bordered
            ? Border.all(color: theme.colorSplit, width: 1)
            : null,
        boxShadow: widget.hoverable && _hovering
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 封面
          if (widget.cover != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(theme.borderRadiusLG),
              ),
              child: SizedBox(
                height: widget.cover!.height,
                width: double.infinity,
                child: widget.cover!.child,
              ),
            ),
          // 标题栏
          if (hasHeader)
            Padding(
              padding: headerPadding,
              child: Row(
                children: [
                  if (widget.title != null)
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: theme.fontSizeLG,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                      child: widget.title!,
                    ),
                  const Spacer(),
                  if (widget.extra != null)
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: theme.fontSizeSM,
                        color: theme.colorPrimary,
                      ),
                      child: widget.extra!,
                    ),
                ],
              ),
            ),
          // 分割线
          if (hasHeader && widget.bordered)
            Divider(height: 1, thickness: 1, color: theme.colorSplit),
          // 内容
          if (widget.loading)
            Padding(
              padding: bodyPadding,
              child: _buildSkeleton(theme),
            )
          else
            Padding(
              padding: bodyPadding,
              child: widget.child,
            ),
          // 操作栏
          if (widget.actions != null && widget.actions!.isNotEmpty) ...[
            Divider(height: 1, thickness: 1, color: theme.colorSplit),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              child: Row(
                children: [
                  for (var i = 0; i < widget.actions!.length; i++) ...[
                    if (i > 0)
                      SizedBox(width: 8.w),
                    Expanded(
                      child: InkWell(
                        onTap: widget.actions![i].onTap,
                        borderRadius: BorderRadius.circular(theme.borderRadiusSM),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.w),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              fontSize: theme.fontSizeSM,
                              color: theme.colorTextSecondary,
                            ),
                            textAlign: TextAlign.center,
                            child: widget.actions![i].child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );

    if (widget.hoverable) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: content,
      );
    }

    if (widget.onTap != null) {
      content = InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        child: content,
      );
    }

    return content;
  }

  Widget _buildSkeleton(AntThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: theme.colorFillSecondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 12.w),
        Container(
          width: double.infinity,
          height: 14.w,
          decoration: BoxDecoration(
            color: theme.colorFillSecondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8.w),
        Container(
          width: 200.w,
          height: 14.w,
          decoration: BoxDecoration(
            color: theme.colorFillSecondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}