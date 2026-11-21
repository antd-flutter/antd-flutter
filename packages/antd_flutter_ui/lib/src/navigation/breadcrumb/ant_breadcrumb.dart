/// AntBreadcrumb — antd React Breadcrumb 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 面包屑项列表
/// - [separator] — 分隔符（默认 '/'）
/// - [separatorWidget] — 自定义分隔符 Widget（优先于 [separator]）
///
/// 每项（AntBreadcrumbItem）支持 title / titleWidget / icon / onClick。
/// 有 onClick 的项可点击，hover 时文字变主色（对齐 antd），最后一项为当前
/// 页面（不可点击，使用正文色）。
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
/// AntBreadcrumb(items: [
///   AntBreadcrumbItem(title: 'Home', onClick: () => goHome()),
///   AntBreadcrumbItem(title: 'List', onClick: () => goList()),
///   AntBreadcrumbItem(title: 'App'), // 当前页面
/// ])
/// ```
class AntBreadcrumb extends StatelessWidget {
  const AntBreadcrumb({
    super.key,
    this.items = const [],
    this.separator = '/',
    this.separatorWidget,
  });

  /// 面包屑项列表。最后一项为当前页面。
  final List<AntBreadcrumbItem> items;

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
      children.add(_buildItem(context, theme, items[i], isLast));
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
    AntBreadcrumbItem item,
    bool isLast,
  ) {
    final isLink = item.onClick != null && !isLast;

    if (!isLink) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: _buildContent(theme, item, isLast: isLast, hovered: false),
      );
    }

    return _BreadcrumbLink(
      onTap: item.onClick!,
      builder: (hovered) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: _buildContent(theme, item, isLast: false, hovered: hovered),
      ),
    );
  }

  Widget _buildContent(
    AntThemeData theme,
    AntBreadcrumbItem item, {
    required bool isLast,
    required bool hovered,
  }) {
    final color = isLast
        ? theme.colorText
        : (item.onClick != null
            ? (hovered ? theme.colorPrimary : theme.colorTextDescription)
            : theme.colorTextTertiary);

    final titleContent = item.titleWidget ??
        Text(
          item.title ?? '',
          style: TextStyle(fontSize: theme.fontSize, color: color),
        );

    if (item.icon == null) return titleContent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme.merge(
          data: IconThemeData(size: theme.fontSize, color: color),
          child: item.icon!,
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
