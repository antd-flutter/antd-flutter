/// IndexBar 索引栏演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class IndexBarPage extends StatelessWidget {
  const IndexBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '右侧索引条，点击/滑动切换，中央显示气泡'),
          _BasicDemo(),
          _Section(title: '自定义标题', description: 'title 区分分组标题与索引字母'),
          _TitleDemo(),
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
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntIndexBar(
        items: const [
          AntIndexBarItem(
            key: 'A',
            child: ListTile(title: Text('阿强')),
          ),
          AntIndexBarItem(
            key: 'B',
            child: ListTile(title: Text('Bob')),
          ),
          AntIndexBarItem(
            key: 'C',
            child: ListTile(title: Text('Charlie')),
          ),
          AntIndexBarItem(
            key: 'D',
            child: ListTile(title: Text('Dave')),
          ),
          AntIndexBarItem(
            key: 'E',
            child: ListTile(title: Text('Eve')),
          ),
        ],
        onChange: (key) => _showSnackbar(context, '跳转到: $key'),
      ),
    );
  }
}

class _TitleDemo extends StatelessWidget {
  const _TitleDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntIndexBar(
        items: const [
          AntIndexBarItem(
            key: '1',
            title: '热门城市',
            child: ListTile(title: Text('北京')),
          ),
          AntIndexBarItem(
            key: '2',
            title: '推荐城市',
            child: ListTile(title: Text('上海')),
          ),
          AntIndexBarItem(
            key: '3',
            title: '更多城市',
            child: ListTile(title: Text('广州')),
          ),
        ],
        onChange: (key) => _showSnackbar(context, '跳转到: $key'),
      ),
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}