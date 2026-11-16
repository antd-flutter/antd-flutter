/// Select 选择器演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Section(title: '基础用法', description: '单选下拉选择器'),
            _BasicDemo(),
            _Section(title: '多选', description: 'mode: multiple'),
            _MultipleDemo(),
            _Section(title: '搜索', description: 'showSearch: true'),
            _SearchDemo(),
            _Section(title: '清除', description: 'allowClear: true'),
            _ClearDemo(),
            _Section(title: '加载中', description: 'loading: true'),
            _LoadingDemo(),
            _Section(title: '尺寸', description: 'size: large / middle / small'),
            _SizeDemo(),
            _Section(title: '禁用', description: 'disabled: true'),
            _DisabledDemo(),
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

const _options = [
  AntSelectOption(value: 'a', label: '选项一'),
  AntSelectOption(value: 'b', label: '选项二'),
  AntSelectOption(value: 'c', label: '选项三'),
  AntSelectOption(value: 'd', label: '选项四'),
];

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntSelect<String>(
          options: _options,
          placeholder: '请选择',
          onChange: (v) => debugPrint('selected: $v'),
        ),
      ),
    ]);
  }
}

class _MultipleDemo extends StatelessWidget {
  const _MultipleDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 260,
        child: AntSelect<String>(
          mode: AntSelectMode.multiple,
          options: _options,
          placeholder: '多选',
          onChange: (v) => debugPrint('selected: $v'),
        ),
      ),
    ]);
  }
}

class _SearchDemo extends StatelessWidget {
  const _SearchDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntSelect<String>(
          options: _options,
          showSearch: true,
          placeholder: '搜索选择',
        ),
      ),
    ]);
  }
}

class _ClearDemo extends StatelessWidget {
  const _ClearDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntSelect<String>(
          options: _options,
          defaultValue: 'a',
          allowClear: true,
        ),
      ),
    ]);
  }
}

class _LoadingDemo extends StatelessWidget {
  const _LoadingDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntSelect<String>(
          options: const [],
          loading: true,
          placeholder: '加载中',
        ),
      ),
    ]);
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 180,
        child: AntSelect<String>(options: _options, size: AntSelectSize.large, placeholder: '大号'),
      ),
      SizedBox(
        width: 180,
        child: AntSelect<String>(options: _options, size: AntSelectSize.middle, placeholder: '中号'),
      ),
      SizedBox(
        width: 180,
        child: AntSelect<String>(options: _options, size: AntSelectSize.small, placeholder: '小号'),
      ),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntSelect<String>(options: _options, disabled: true, placeholder: '禁用'),
      ),
    ]);
  }
}