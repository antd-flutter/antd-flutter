/// 官网首页 — antd 风格：左侧分组导航 + 右侧内容区
library;

import 'package:flutter/material.dart';

import '../data/nav_data.dart';
import 'component_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NavItem? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    return Scaffold(
      body: Row(
        children: [
          // 左侧导航栏
          _buildSidebar(theme),
          // 分割线
          VerticalDivider(width: 1, color: theme.dividerColor),
          // 右侧内容区
          Expanded(child: _buildContent(theme, isWide)),
        ],
      ),
    );
  }

  /// 左侧导航栏 — 分组标题 + 组件列表
  Widget _buildSidebar(ThemeData theme) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          // Logo 区
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.widgets_outlined,
                    color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'antd-flutter',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          // 导航列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final group in navGroups) ...[
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24, 16, 16, 4),
                    child: Text(
                      group.title,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  for (final item in group.items)
                    _buildNavItem(theme, item),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 单个导航项
  Widget _buildNavItem(ThemeData theme, NavItem item) {
    final selected = _selected == item;
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selected = item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  /// 右侧内容区
  Widget _buildContent(ThemeData theme, bool isWide) {
    final selected = _selected;
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶栏
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Text(
              selected?.label ?? 'Ant Design v6 · Flutter 实现',
              style: theme.textTheme.titleMedium,
            ),
          ),
          // 内容
          Expanded(
            child: selected == null
                ? _buildOverview(theme)
                : ComponentPage(title: selected.label),
          ),
        ],
      ),
    );
  }

  /// 未选中组件时的总览页
  Widget _buildOverview(ThemeData theme) {
    final count =
        navGroups.fold<int>(0, (sum, g) => sum + g.items.length);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.palette_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'antd-flutter',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ant Design v6 设计规范的 Flutter 组件库',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '共 ${navGroups.length} 大分类 · $count 个组件规划中',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}