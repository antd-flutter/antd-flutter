library;

/// AutoCenter 自动居中演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class AutoCenterPage extends StatelessWidget {
  const AutoCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本居中', description: '内容在可用空间中水平垂直居中'),
          _BasicDemo(),
          _Section(title: '弹性布局居中', description: 'expanded=true 时在 Column 中占据剩余空间并居中'),
          _ExpandedDemo(),
          _Section(title: '页面级布局', description: '导航栏 + 居中内容 + 底部栏的典型布局'),
          _PageLayoutDemo(),
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
    final theme = Theme.of(context);
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntAutoCenter(
        child: AntSpace(
          direction: AntSpaceDirection.vertical,
          align: AntSpaceAlign.center,
          children: [
            Icon(Icons.center_focus_strong, size: 48),
            Text('居中内容'),
          ],
        ),
      ),
    );
  }
}

class _ExpandedDemo extends StatelessWidget {
  const _ExpandedDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('顶部区域'),
          ),
          AntAutoCenter(
            expanded: true,
            child: AntSpace(
              direction: AntSpaceDirection.vertical,
              align: AntSpaceAlign.center,
              children: [
                Icon(Icons.vertical_align_center, size: 48),
                Text('占据剩余空间并居中'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('底部区域'),
          ),
        ],
      ),
    );
  }
}

class _PageLayoutDemo extends StatelessWidget {
  const _PageLayoutDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.primaryContainer,
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 20),
                const SizedBox(width: 8),
                Text('NavBar 导航栏', style: theme.textTheme.titleSmall),
              ],
            ),
          ),
          const AntAutoCenter(
            expanded: true,
            child: AntSpace(
              direction: AntSpaceDirection.vertical,
              align: AntSpaceAlign.center,
              size: AntSpaceSize.middle(),
              children: [
                Icon(Icons.phone_iphone, size: 64),
                Text('页面主内容', style: TextStyle(fontSize: 18)),
                Text('在导航栏与底部栏之间自动居中',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.secondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.home_outlined),
                Icon(Icons.search),
                Icon(Icons.person_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}