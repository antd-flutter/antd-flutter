/// AntBreadcrumb — antd React Breadcrumb 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 面包屑项列表
/// - [separator] — 分隔符（默认 '/'）
/// - [separatorWidget] — 自定义分隔符 Widget（优先于 [separator]）
///
/// 每项（AntBreadcrumbItem）支持 title / titleWidget / icon / onClick。
/// 有 onClick 的项可点击（hover 变色），最后一项为当前页面（不可点击样式）。
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
    final titleContent = item.titleWidget ??
        Text(
          item.title ?? '',
          style: TextStyle(
            fontSize: theme.fontSize,
            color: isLast
                ? theme.colorText
                : (item.onClick != null
                    ? theme.colorTextSecondary
                    : theme.colorTextTertiary),
          ),
        );

    final content = item.icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: theme.fontSize,
                  color: isLast
                      ? theme.colorText
                      : theme.colorTextSecondary,
                ),
                child: item.icon!,
              ),
              const SizedBox(width: 4),
              titleContent,
            ],
          )
        : titleContent;

    if (item.onClick != null && !isLast) {
      return InkWell(
        onTap: item.onClick,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: content,
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