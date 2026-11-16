/// Rate 评分演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class RatePage extends StatelessWidget {
  const RatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AntNavBar(title: 'Rate 评分', back: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Section(title: '基础用法', description: '点击星星选择评分'),
            _BasicDemo(),
            _Section(title: '半星', description: 'allowHalf: true'),
            _HalfDemo(),
            _Section(title: '自定义数量', description: 'count 控制星星总数'),
            _CountDemo(),
            _Section(title: '清除', description: 'allowClear: true 再次点击清空'),
            _ClearDemo(),
            _Section(title: '自定义图标', description: 'character 使用自定义 IconData'),
            _CharacterDemo(),
            _Section(title: '禁用', description: 'disabled: true'),
            _DisabledDemo(),
          ],
        ),
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
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(wrap: true, gap: const AntFlexGap.all(24), children: children);
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(onChange: (v) => debugPrint('rate: $v')),
    ]);
  }
}

class _HalfDemo extends StatelessWidget {
  const _HalfDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(allowHalf: true, defaultValue: 2.5, onChange: (v) => debugPrint('rate: $v')),
    ]);
  }
}

class _CountDemo extends StatelessWidget {
  const _CountDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(count: 10, defaultValue: 6),
    ]);
  }
}

class _ClearDemo extends StatelessWidget {
  const _ClearDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(allowClear: true, defaultValue: 3),
    ]);
  }
}

class _CharacterDemo extends StatelessWidget {
  const _CharacterDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(character: Icons.favorite, defaultValue: 3),
      AntRate(character: Icons.sentiment_satisfied, defaultValue: 4),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRate(disabled: true, defaultValue: 3),
    ]);
  }
}