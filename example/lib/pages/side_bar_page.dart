/// SideBar 侧边导航栏演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class SideBarPage extends StatelessWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '左侧高亮条 + 白色激活背景'),
          _BasicDemo(),
          _Section(title: '角标', description: '圆点角标与文字角标'),
          _BadgeDemo(),
          _Section(title: '禁用项', description: 'disabled: true 不可点击'),
          _DisabledDemo(),
          _Section(title: '联动内容', description: 'SideBar + 右侧内容区联动切换'),
          _LinkedDemo(),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntSideBar(
        items: const [
          AntSideBarItem(key: 'a', title: '选项一'),
          AntSideBarItem(key: 'b', title: '选项二'),
          AntSideBarItem(key: 'c', title: '选项三'),
          AntSideBarItem(key: 'd', title: '选项四'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntSideBar(
        items: const [
          AntSideBarItem(key: 'a', title: '通知', badgeDot: true),
          AntSideBarItem(key: 'b', title: '消息', badgeText: '9'),
          AntSideBarItem(key: 'c', title: '设置'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntSideBar(
        items: const [
          AntSideBarItem(key: 'a', title: '可用项'),
          AntSideBarItem(key: 'b', title: '禁用项', disabled: true),
          AntSideBarItem(key: 'c', title: '可用项'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _LinkedDemo extends StatefulWidget {
  const _LinkedDemo();

  @override
  State<_LinkedDemo> createState() => _LinkedDemoState();
}

class _LinkedDemoState extends State<_LinkedDemo> {
  String _activeKey = 'a';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: AntSideBar(
              activeKey: _activeKey,
              items: const [
                AntSideBarItem(key: 'a', title: '水果'),
                AntSideBarItem(key: 'b', title: '蔬菜'),
                AntSideBarItem(key: 'c', title: '肉类'),
              ],
              onChange: (key) => setState(() => _activeKey = key),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _contentFor(_activeKey),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _contentFor(String key) {
    switch (key) {
      case 'a':
        return '🍎 水果分类';
      case 'b':
        return '🥬 蔬菜分类';
      case 'c':
        return '🥩 肉类分类';
      default:
        return '';
    }
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}