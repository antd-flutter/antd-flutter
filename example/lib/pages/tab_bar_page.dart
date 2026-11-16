/// TabBar 标签栏演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '图标 + 标题，点击切换'),
          _BasicDemo(),
          _Section(title: '纯文字', description: '无图标，仅标题'),
          _TextOnlyDemo(),
          _Section(title: '圆点角标', description: 'badgeDot: true'),
          _BadgeDotDemo(),
          _Section(title: '文字角标', description: 'badgeText: "8"'),
          _BadgeTextDemo(),
          _Section(title: '激活图标', description: 'activeIcon 切换选中态图标'),
          _ActiveIconDemo(),
          _Section(title: '无边框', description: 'border: false'),
          _NoBorderDemo(),
          _Section(title: '受控模式', description: 'activeKey 由外部控制'),
          _ControlledDemo(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return AntTabBar(
      items: const [
        AntTabBarItem(key: 'home', title: '首页', icon: Icons.home_outlined, activeIcon: Icons.home),
        AntTabBarItem(key: 'find', title: '发现', icon: Icons.explore_outlined, activeIcon: Icons.explore),
        AntTabBarItem(key: 'me', title: '我的', icon: Icons.person_outline, activeIcon: Icons.person),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _TextOnlyDemo extends StatelessWidget {
  const _TextOnlyDemo();

  @override
  Widget build(BuildContext context) {
    return AntTabBar(
      items: const [
        AntTabBarItem(key: 'a', title: '选项一'),
        AntTabBarItem(key: 'b', title: '选项二'),
        AntTabBarItem(key: 'c', title: '选项三'),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _BadgeDotDemo extends StatelessWidget {
  const _BadgeDotDemo();

  @override
  Widget build(BuildContext context) {
    return AntTabBar(
      items: const [
        AntTabBarItem(key: 'home', title: '首页', icon: Icons.home),
        AntTabBarItem(key: 'msg', title: '消息', icon: Icons.message, badgeDot: true),
        AntTabBarItem(key: 'me', title: '我的', icon: Icons.person),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _BadgeTextDemo extends StatelessWidget {
  const _BadgeTextDemo();

  @override
  Widget build(BuildContext context) {
    return AntTabBar(
      items: const [
        AntTabBarItem(key: 'home', title: '首页', icon: Icons.home),
        AntTabBarItem(key: 'cart', title: '购物车', icon: Icons.shopping_cart, badgeText: '8'),
        AntTabBarItem(key: 'me', title: '我的', icon: Icons.person),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _ActiveIconDemo extends StatelessWidget {
  const _ActiveIconDemo();

  @override
  Widget build(BuildContext context) {
    return AntTabBar(
      items: const [
        AntTabBarItem(
          key: 'home',
          title: '首页',
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        AntTabBarItem(
          key: 'star',
          title: '收藏',
          icon: Icons.star_border,
          activeIcon: Icons.star,
        ),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _NoBorderDemo extends StatelessWidget {
  const _NoBorderDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntTabBar(
        border: false,
        items: const [
          AntTabBarItem(key: 'a', title: '选项一'),
          AntTabBarItem(key: 'b', title: '选项二'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String _activeKey = 'a';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('当前激活: $_activeKey'),
        const SizedBox(height: 8),
        AntTabBar(
          activeKey: _activeKey,
          items: const [
            AntTabBarItem(key: 'a', title: '选项一'),
            AntTabBarItem(key: 'b', title: '选项二'),
            AntTabBarItem(key: 'c', title: '选项三'),
          ],
          onChange: (key) => setState(() => _activeKey = key),
        ),
      ],
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}