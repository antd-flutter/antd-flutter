/// DatePicker 日期选择框演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class DatePickerPage extends StatelessWidget {
  const DatePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AntNavBar(title: 'DatePicker 日期选择框', back: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Section(title: '基础用法', description: '点击弹出日历面板选择日期'),
            _BasicDemo(),
            _Section(title: '默认值', description: 'defaultValue 预填日期'),
            _DefaultValueDemo(),
            _Section(title: '清除', description: 'allowClear: true'),
            _ClearDemo(),
            _Section(title: '尺寸', description: 'size: large / middle / small'),
            _SizeDemo(),
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
      SizedBox(
        width: 220,
        child: AntDatePicker(
          placeholder: '请选择日期',
          onChange: (d) => debugPrint('date: $d'),
        ),
      ),
    ]);
  }
}

class _DefaultValueDemo extends StatelessWidget {
  const _DefaultValueDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 220,
        child: AntDatePicker(
          defaultValue: DateTime(2024, 6, 1),
          onChange: (d) => debugPrint('date: $d'),
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
        width: 220,
        child: AntDatePicker(
          defaultValue: DateTime(2024, 6, 1),
          allowClear: true,
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
        width: 200,
        child: AntDatePicker(size: AntDatePickerSize.large, placeholder: '大号'),
      ),
      SizedBox(
        width: 200,
        child: AntDatePicker(size: AntDatePickerSize.middle, placeholder: '中号'),
      ),
      SizedBox(
        width: 200,
        child: AntDatePicker(size: AntDatePickerSize.small, placeholder: '小号'),
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
        width: 220,
        child: AntDatePicker(disabled: true, placeholder: '禁用'),
      ),
    ]);
  }
}