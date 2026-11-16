library;

/// Menu 导航菜单演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认 inline 模式，垂直内嵌展示'),
          _BasicDemo(),
          _Section(title: '水平模式', description: 'mode=horizontal，顶部导航栏'),
          _HorizontalDemo(),
          _Section(title: '暗色主题', description: 'theme=dark'),
          _DarkDemo(),
          _Section(title: '折叠模式', description: 'inlineCollapsed=true，仅显示图标'),
          _CollapsedDemo(),
          _Section(title: '分组与分割线', description: 'type=group 分组标题，type=divider 分割线'),
          _GroupDividerDemo(),
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
      padding: const EdgeInsets.only(top: 32, bottom: 16),
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
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 基本用法
// ------------------------------------------------------------

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntMenu(
        defaultSelectedKeys: const ['1'],
        items: const [
          AntMenuItem(key: '1', label: '导航一'),
          AntMenuItem(key: '2', label: '导航二'),
          AntMenuItem(key: 'sub1', label: '子菜单', children: [
            AntMenuItem(key: '3', label: '选项 3'),
            AntMenuItem(key: '4', label: '选项 4'),
          ]),
          AntMenuItem(key: '5', label: '导航三', disabled: true),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 水平模式
// ------------------------------------------------------------

class _HorizontalDemo extends StatelessWidget {
  const _HorizontalDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntMenu(
        mode: AntMenuMode.horizontal,
        defaultSelectedKeys: const ['mail'],
        items: const [
          AntMenuItem(key: 'mail', label: '邮件', icon: Icon(Icons.mail, size: 16)),
          AntMenuItem(key: 'app', label: '应用', icon: Icon(Icons.apps, size: 16)),
          AntMenuItem(key: 'sub1', label: '更多', children: [
            AntMenuItem(key: '1-1', label: '选项 1'),
            AntMenuItem(key: '1-2', label: '选项 2'),
          ]),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 暗色主题
// ------------------------------------------------------------

class _DarkDemo extends StatelessWidget {
  const _DarkDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntMenu(
        theme: AntMenuTheme.dark,
        defaultSelectedKeys: const ['1'],
        items: const [
          AntMenuItem(key: '1', label: '导航一', icon: Icon(Icons.mail, size: 16)),
          AntMenuItem(key: '2', label: '导航二', icon: Icon(Icons.app_settings_alt, size: 16)),
          AntMenuItem(key: 'sub1', label: '子菜单', icon: Icon(Icons.settings, size: 16), children: [
            AntMenuItem(key: '3', label: '选项 3'),
            AntMenuItem(key: '4', label: '选项 4'),
          ]),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 折叠模式
// ------------------------------------------------------------

class _CollapsedDemo extends StatelessWidget {
  const _CollapsedDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntMenu(
        inlineCollapsed: true,
        defaultSelectedKeys: const ['1'],
        items: const [
          AntMenuItem(key: '1', label: '导航一', icon: Icon(Icons.mail, size: 18)),
          AntMenuItem(key: '2', label: '导航二', icon: Icon(Icons.calendar_month, size: 18)),
          AntMenuItem(key: 'sub1', label: '子菜单', icon: Icon(Icons.settings, size: 18), children: [
            AntMenuItem(key: '3', label: '选项 3'),
          ]),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 分组与分割线
// ------------------------------------------------------------

class _GroupDividerDemo extends StatelessWidget {
  const _GroupDividerDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntMenu(
        defaultSelectedKeys: const ['1'],
        items: const [
          AntMenuItem(key: 'grp1', label: '分组一', type: AntMenuItemType.group, children: [
            AntMenuItem(key: '1', label: '选项 1'),
            AntMenuItem(key: '2', label: '选项 2'),
          ]),
          AntMenuItem(key: 'd1', type: AntMenuItemType.divider),
          AntMenuItem(key: 'grp2', label: '分组二', type: AntMenuItemType.group, children: [
            AntMenuItem(key: '3', label: '选项 3'),
            AntMenuItem(key: '4', label: '选项 4'),
          ]),
        ],
      ),
    );
  }
}