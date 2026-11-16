library;

/// 官网首页 — antd 风格：宽屏左侧分组导航 + 右侧内容区，窄屏抽屉导航
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
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
    final content = _selected == null
        ? _buildOverview(theme)
        : ComponentPage(snakeName: _selected!.snakeName);

    if (isWide) {
      return Scaffold(
        body: AntLayout(
          sider: AntLayoutSider(
            theme: AntLayoutSiderTheme.light,
            width: 260,
            child: _buildSidebarContent(theme),
          ),
          header: AntLayoutHeader(
            child: Text(
              _selected?.label ?? 'Ant Design v6 · Flutter 实现',
              style: theme.textTheme.titleMedium,
            ),
          ),
          content: AntLayoutContent(child: content),
        ),
      );
    }

    // 窄屏：抽屉导航模式，AntNavBar 左侧菜单按钮打开抽屉
    return Scaffold(
      drawer: Drawer(child: _buildSidebarContent(theme, closeOnTap: true)),
      body: Builder(
        builder: (scaffoldContext) => Column(
          children: [
            AntNavBar(
              child: Text(_selected?.label ?? 'antd-flutter'),
              back: false,
              left: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              ),
            ),
            Expanded(child: AntLayoutContent(child: content)),
          ],
        ),
      ),
    );
  }

  /// 左侧导航栏内容 — 分组标题 + 组件列表
  /// [closeOnTap] 为 true 时点击项后自动关闭抽屉
  Widget _buildSidebarContent(ThemeData theme, {bool closeOnTap = false}) {
    return AntFlex(
      vertical: true,
      children: [
        // Logo 区
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.centerLeft,
          child: AntFlex(
            gap: const AntFlexGap.all(10),
            children: [
              Icon(Icons.widgets_outlined,
                  color: theme.colorScheme.primary, size: 28),
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
        AntDivider(spacing: 1, color: theme.dividerColor),
        // 导航列表
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final group in navGroups) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 4),
                  child: Text(
                    group.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final item in group.items)
                  _buildNavItem(theme, item, closeOnTap: closeOnTap),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 单个导航项
  Widget _buildNavItem(ThemeData theme, NavItem item,
      {bool closeOnTap = false}) {
    final selected = _selected == item;
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _selected = item);
          if (closeOnTap) Navigator.of(context).pop();
        },
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

  /// 未选中组件时的总览页
  Widget _buildOverview(ThemeData theme) {
    final count =
        navGroups.fold<int>(0, (sum, g) => sum + g.items.length);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AntSpace(
          direction: AntSpaceDirection.vertical,
          size: const AntSpaceSize.large(),
          children: [
            Icon(
              Icons.palette_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            AntSpace(
              direction: AntSpaceDirection.vertical,
              size: const AntSpaceSize.small(),
              children: [
                Text(
                  'antd-flutter',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Ant Design v6 设计规范的 Flutter 组件库',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            Text(
              '共 ${navGroups.length} 大分类 · $count 个组件规划中',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}