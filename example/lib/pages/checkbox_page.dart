library;

/// Checkbox 复选框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class CheckboxPage extends StatelessWidget {
  const CheckboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '简单的复选框'),
          _BasicDemo(),
          _Section(title: '受控用法', description: 'checked + onChange 联动'),
          _ControlledDemo(),
          _Section(title: '半选状态', description: 'indeterminate: true'),
          _IndeterminateDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(title: '复选框组', description: 'AntCheckboxGroup：options + onChange'),
          _GroupDemo(),
          _Section(title: '纵向排列', description: 'direction: vertical'),
          _VerticalDemo(),
          _Section(title: '整体禁用', description: '组级 disabled'),
          _GroupDisabledDemo(),
          _Section(title: '自定义子项', description: '通过 children 传入 AntCheckbox'),
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
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorText)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!, style: TextStyle(fontSize: 12, color: theme.colorTextTertiary)),
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
      AntCheckbox(child: Text('未选中')),
      AntCheckbox(defaultChecked: true, child: Text('默认选中')),
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
      AntCheckbox(
        checked: _checked,
        onChange: (v) => setState(() => _checked = v),
        child: Text(_checked ? '已选中' : '未选中'),
      ),
    ]);
  }
}

class _IndeterminateDemo extends StatelessWidget {
  const _IndeterminateDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntCheckbox(indeterminate: true, child: Text('半选')),
      AntCheckbox(indeterminate: true, disabled: true, child: Text('半选禁用')),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntCheckbox(disabled: true, child: Text('禁用未选')),
      AntCheckbox(disabled: true, defaultChecked: true, child: Text('禁用已选')),
    ]);
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();
  @override
  Widget build(BuildContext context) {
    return const AntCheckboxGroup<String>(
      defaultValue: ['apple'],
      options: [
        AntCheckboxOption(value: 'apple', label: Text('Apple')),
        AntCheckboxOption(value: 'pear', label: Text('Pear')),
        AntCheckboxOption(value: 'orange', label: Text('Orange')),
      ],
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();
  @override
  Widget build(BuildContext context) {
    return const AntCheckboxGroup<String>(
      direction: AntCheckboxGroupDirection.vertical,
      options: [
        AntCheckboxOption(value: 'a', label: Text('选项 A')),
        AntCheckboxOption(value: 'b', label: Text('选项 B')),
        AntCheckboxOption(value: 'c', label: Text('选项 C')),
      ],
    );
  }
}

class _GroupDisabledDemo extends StatelessWidget {
  const _GroupDisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const AntCheckboxGroup<String>(
      disabled: true,
      defaultValue: ['a'],
      options: [
        AntCheckboxOption(value: 'a', label: Text('选项 A')),
        AntCheckboxOption(value: 'b', label: Text('选项 B')),
        AntCheckboxOption(value: 'c', label: Text('选项 C')),
      ],
    );
  }
}

class _ChildrenDemo extends StatelessWidget {
  const _ChildrenDemo();
  @override
  Widget build(BuildContext context) {
    return const AntCheckboxGroup<String>(
      children: [
        AntCheckbox(value: 'x', child: Text('X')),
        AntCheckbox(value: 'y', child: Text('Y')),
        AntCheckbox(value: 'z', child: Text('Z')),
      ],
    );
  }
}