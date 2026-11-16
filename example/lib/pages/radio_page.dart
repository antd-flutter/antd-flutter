/// Radio 单选框演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class RadioPage extends StatelessWidget {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '简单的单选框'),
          _BasicDemo(),
          _Section(title: '受控用法', description: 'checked + onChange 联动'),
          _ControlledDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(title: '单选组', description: 'AntRadioGroup：options + onChange'),
          _GroupDemo(),
          _Section(title: '按钮风格', description: 'optionType: button'),
          _ButtonDemo(),
          _Section(title: '实色按钮', description: 'buttonStyle: solid'),
          _SolidDemo(),
          _Section(title: '纵向排列', description: 'direction: vertical'),
          _VerticalDemo(),
          _Section(title: '整体禁用', description: '组级 disabled'),
          _GroupDisabledDemo(),
          _Section(title: '自定义子项', description: '通过 children 传入 AntRadio / AntRadioButton'),
          _ChildrenDemo(),
        ],
      ),
    );
  }
}

/// 演示区块标题
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

/// 行容器
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
    return const _Row(children: [
      AntRadio(child: Text('未选中')),
      AntRadio(defaultChecked: true, child: Text('默认选中')),
    ]);
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      AntRadio(
        checked: _checked,
        onChange: (v) => setState(() => _checked = v),
        child: Text(_checked ? '已选中' : '未选中'),
      ),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntRadio(disabled: true, child: Text('禁用未选')),
      AntRadio(disabled: true, defaultChecked: true, child: Text('禁用已选')),
    ]);
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      defaultValue: 'apple',
      options: [
        AntRadioOption(value: 'apple', label: Text('Apple')),
        AntRadioOption(value: 'pear', label: Text('Pear')),
        AntRadioOption(value: 'orange', label: Text('Orange')),
      ],
    );
  }
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      defaultValue: 'a',
      optionType: AntRadioGroupOptionType.button,
      options: [
        AntRadioOption(value: 'a', label: Text('A')),
        AntRadioOption(value: 'b', label: Text('B')),
        AntRadioOption(value: 'c', label: Text('C')),
        AntRadioOption(value: 'd', label: Text('D')),
      ],
    );
  }
}

class _SolidDemo extends StatelessWidget {
  const _SolidDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      defaultValue: 'a',
      optionType: AntRadioGroupOptionType.button,
      buttonStyle: AntRadioButtonStyle.solid,
      options: [
        AntRadioOption(value: 'a', label: Text('A')),
        AntRadioOption(value: 'b', label: Text('B')),
        AntRadioOption(value: 'c', label: Text('C')),
        AntRadioOption(value: 'd', label: Text('D')),
      ],
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      direction: AntRadioGroupDirection.vertical,
      options: [
        AntRadioOption(value: 'a', label: Text('选项 A')),
        AntRadioOption(value: 'b', label: Text('选项 B')),
        AntRadioOption(value: 'c', label: Text('选项 C')),
      ],
    );
  }
}

class _GroupDisabledDemo extends StatelessWidget {
  const _GroupDisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      disabled: true,
      defaultValue: 'a',
      options: [
        AntRadioOption(value: 'a', label: Text('选项 A')),
        AntRadioOption(value: 'b', label: Text('选项 B')),
        AntRadioOption(value: 'c', label: Text('选项 C')),
      ],
    );
  }
}

class _ChildrenDemo extends StatelessWidget {
  const _ChildrenDemo();
  @override
  Widget build(BuildContext context) {
    return const AntRadioGroup<String>(
      defaultValue: 'a',
      children: [
        AntRadio(value: 'a', child: Text('A')),
        AntRadio(value: 'b', child: Text('B')),
        AntRadioButton(value: 'c', child: Text('C')),
        AntRadioButton(value: 'd', child: Text('D')),
      ],
    );
  }
}