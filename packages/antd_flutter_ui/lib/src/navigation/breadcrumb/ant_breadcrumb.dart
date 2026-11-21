/// AntBreadcrumb — antd React Breadcrumb 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 面包屑项列表
/// - [separator] — 分隔符（默认 '/'）
/// - [separatorWidget] — 自定义分隔符 Widget（优先于 [separator]）
///
/// 每项为任意用户模型 `T`，通过 [titleBuilder] / [iconBuilder] 渲染；
/// 设置 [onTap] 后除最后一项外均可点击，hover 时文字变主色（对齐 antd），
/// 最后一项为当前页面（不可点击，使用正文色）。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_breadcrumb_types.dart';

// ============================================================
// AntBreadcrumb
// ============================================================

/// 面包屑 — 显示当前页面在系统层级结构中的位置。
///
/// 对齐 antd React Breadcrumb 组件，支持自定义分隔符、图标和点击回调。
///
/// ```dart
/// AntBreadcrumb<Crumb>(
///   items: crumbs,
///   titleBuilder: (context, crumb, index) => Text(crumb.title),
///   onTap: (crumb) => go(crumb.path),
/// )
/// ```
class AntBreadcrumb<T> extends StatelessWidget {
  const AntBreadcrumb({
    super.key,
    this.items = const [],
    this.titleBuilder,
    this.iconBuilder,
    this.onTap,
    this.clickableOf,
    this.separator = '/',
    this.separatorWidget,
  });

  /// 面包屑项列表。最后一项为当前页面。
  final List<T> items;

  /// 标题构建器，未提供时回退为 `Text('$item')`。
  final AntBreadcrumbTitleBuilder<T>? titleBuilder;

  /// 图标构建器，显示在标题左侧。
  final AntBreadcrumbIconBuilder<T>? iconBuilder;

  /// 点击回调。不为 null 时除最后一项外均可点击。
  final ValueChanged<T>? onTap;

  /// 指定某些项是否可点击（仍受最后一项不可点击限制）。
  final bool Function(T item)? clickableOf;

  /// 分隔符文字。默认 '/'。
  final String separator;

  /// 自定义分隔符 Widget。优先于 [separator]。
  final Widget? separatorWidget;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = AntTheme.of(context);
    final children = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      final isLast = i == items.length - 1;
      children.add(_buildItem(context, theme, items[i], i, isLast));
      if (!isLast) {
        children.add(_buildSeparator(theme));
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildItem(
    BuildContext context,
    AntThemeData theme,
    T item,
    int index,
    bool isLast,
  ) {
    final isLink =
        onTap != null && !isLast && (clickableOf?.call(item) ?? true);

    if (!isLink) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: _buildContent(
          context,
          theme,
          item,
          index,
          isLast: isLast,
          isLink: false,
          hovered: false,
        ),
      );
    }

    return _BreadcrumbLink(
      onTap: () => onTap!(item),
      builder: (hovered) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: _buildContent(
          context,
          theme,
          item,
          index,
          isLast: false,
          isLink: true,
          hovered: hovered,
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AntThemeData theme,
    T item,
    int index, {
    required bool isLast,
    required bool isLink,
    required bool hovered,
  }) {
    final color = isLast
        ? theme.colorText
        : (isLink
            ? (hovered ? theme.colorPrimary : theme.colorTextDescription)
            : theme.colorTextTertiary);

    final titleContent = DefaultTextStyle.merge(
      style: TextStyle(fontSize: theme.fontSize, color: color),
      child: titleBuilder?.call(context, item, index) ?? Text('$item'),
    );

    final icon = iconBuilder?.call(context, item);
    if (icon == null) return titleContent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme.merge(
          data: IconThemeData(size: theme.fontSize, color: color),
          child: icon,
        ),
        const SizedBox(width: 4),
        titleContent,
      ],
    );
  }

  Widget _buildSeparator(AntThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: separatorWidget ??
          Text(
            separator,
            style: TextStyle(
              fontSize: theme.fontSize,
              color: theme.colorTextTertiary,
            ),
          ),
    );
  }
}

/// 可点击的面包屑项：hover 时切换主色。
class _BreadcrumbLink extends StatefulWidget {
  const _BreadcrumbLink({required this.onTap, required this.builder});

  final VoidCallback onTap;
  final Widget Function(bool hovered) builder;

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: widget.builder(_hovered),
      ),
    );
  }
}
