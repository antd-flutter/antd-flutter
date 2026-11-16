/// Masonry 瀑布流演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class MasonryPage extends StatelessWidget {
  const MasonryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '不同高度的卡片按贪心算法分配到最矮列'),
          _BasicDemo(),
          _Section(title: '列数', description: 'columns 控制列数，默认 3 列'),
          _ColumnsDemo(),
          _Section(title: '间距', description: 'gutter 列间距，verticalGutter 行间距'),
          _GutterDemo(),
          _Section(title: '响应式列数', description: 'responsiveColumns 根据容器宽度自动选择列数'),
          _ResponsiveDemo(),
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

/// 瀑布流卡片占位
Widget _card(String label, double height, Color color) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: Alignment.center,
    child: Text(label, style: TextStyle(color: color)),
  );
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return AntMasonry(
      columns: 3,
      gutter: 12,
      verticalGutter: 12,
      children: [
        AntMasonryItem(height: 120, child: _card('A · 120', 120, Colors.blue)),
        AntMasonryItem(height: 180, child: _card('B · 180', 180, Colors.green)),
        AntMasonryItem(height: 90, child: _card('C · 90', 90, Colors.orange)),
        AntMasonryItem(height: 150, child: _card('D · 150', 150, Colors.purple)),
        AntMasonryItem(height: 110, child: _card('E · 110', 110, Colors.teal)),
        AntMasonryItem(height: 200, child: _card('F · 200', 200, Colors.pink)),
      ],
    );
  }
}

class _ColumnsDemo extends StatelessWidget {
  const _ColumnsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('2 列'),
        ),
        AntMasonry(
          columns: 2,
          gutter: 12,
          verticalGutter: 12,
          children: [
            AntMasonryItem(height: 100, child: _card('A', 100, Colors.blue)),
            AntMasonryItem(height: 140, child: _card('B', 140, Colors.green)),
            AntMasonryItem(height: 80, child: _card('C', 80, Colors.orange)),
            AntMasonryItem(height: 120, child: _card('D', 120, Colors.purple)),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 8),
          child: Text('4 列'),
        ),
        AntMasonry(
          columns: 4,
          gutter: 12,
          verticalGutter: 12,
          children: [
            AntMasonryItem(height: 100, child: _card('A', 100, Colors.blue)),
            AntMasonryItem(height: 140, child: _card('B', 140, Colors.green)),
            AntMasonryItem(height: 80, child: _card('C', 80, Colors.orange)),
            AntMasonryItem(height: 120, child: _card('D', 120, Colors.purple)),
            AntMasonryItem(height: 90, child: _card('E', 90, Colors.teal)),
            AntMasonryItem(height: 160, child: _card('F', 160, Colors.pink)),
            AntMasonryItem(height: 110, child: _card('G', 110, Colors.indigo)),
            AntMasonryItem(height: 130, child: _card('H', 130, Colors.brown)),
          ],
        ),
      ],
    );
  }
}

class _GutterDemo extends StatelessWidget {
  const _GutterDemo();

  @override
  Widget build(BuildContext context) {
    return AntMasonry(
      columns: 3,
      gutter: 24,
      verticalGutter: 24,
      children: [
        AntMasonryItem(height: 100, child: _card('A', 100, Colors.blue)),
        AntMasonryItem(height: 130, child: _card('B', 130, Colors.green)),
        AntMasonryItem(height: 90, child: _card('C', 90, Colors.orange)),
        AntMasonryItem(height: 110, child: _card('D', 110, Colors.purple)),
        AntMasonryItem(height: 150, child: _card('E', 150, Colors.teal)),
        AntMasonryItem(height: 100, child: _card('F', 100, Colors.pink)),
      ],
    );
  }
}

class _ResponsiveDemo extends StatelessWidget {
  const _ResponsiveDemo();

  @override
  Widget build(BuildContext context) {
    return AntMasonry(
      responsiveColumns: const AntMasonryResponsive(
        xs: 1,
        sm: 2,
        md: 3,
        lg: 4,
        xl: 5,
      ),
      gutter: 12,
      verticalGutter: 12,
      children: [
        AntMasonryItem(height: 100, child: _card('A', 100, Colors.blue)),
        AntMasonryItem(height: 130, child: _card('B', 130, Colors.green)),
        AntMasonryItem(height: 90, child: _card('C', 90, Colors.orange)),
        AntMasonryItem(height: 110, child: _card('D', 110, Colors.purple)),
        AntMasonryItem(height: 150, child: _card('E', 150, Colors.teal)),
        AntMasonryItem(height: 100, child: _card('F', 100, Colors.pink)),
        AntMasonryItem(height: 120, child: _card('G', 120, Colors.indigo)),
        AntMasonryItem(height: 80, child: _card('H', 80, Colors.brown)),
        AntMasonryItem(height: 140, child: _card('I', 140, Colors.cyan)),
        AntMasonryItem(height: 110, child: _card('J', 110, Colors.lime)),
      ],
    );
  }
}