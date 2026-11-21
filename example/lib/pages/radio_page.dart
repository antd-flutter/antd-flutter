library;

/// Radio 单选框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

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
          _Section(
            title: '单选组',
            description: 'AntRadioGroup：options + onChange',
          ),
          _GroupDemo(),
          _Section(title: '按钮风格', description: 'optionType: button'),
          _ButtonDemo(),
          _Section(title: '实色按钮', description: 'buttonStyle: solid'),
          _SolidDemo(),
          _Section(title: '纵向排列', description: 'direction: vertical'),
          _VerticalDemo(),
          _Section(title: '整体禁用', description: '组级 disabled'),
          _GroupDisabledDemo(),
          _Section(
            title: '自定义子项',
            description: '通过 children 传入 AntRadio / AntRadioButton',
          ),
          _ChildrenDemo(),
          _Section(
            title: '自定义模型',
            description: 'options 直接传业务模型，labelOf / disabledOf 取文案与禁用态',
          ),
          _ModelDemo(),
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
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
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
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.all(24),
      children: children,
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(
      children: [
        AntRadio(child: Text('未选中')),
        AntRadio(defaultChecked: true, child: Text('默认选中')),
      ],
    );
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
    return _Row(
      children: [
        AntRadio(
          checked: _checked,
          onChange: (v) => setState(() => _checked = v),
          child: Text(_checked ? '已选中' : '未选中'),
        ),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(
      children: [
        AntRadio(disabled: true, child: Text('禁用未选')),
        AntRadio(disabled: true, defaultChecked: true, child: Text('禁用已选')),
      ],
    );
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();
  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<String>(
      defaultValue: 'apple',
      options: const ['apple', 'pear', 'orange'],
      labelOf: _capitalize,
    );
  }
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<String>(
      defaultValue: 'a',
      optionType: AntRadioGroupOptionType.button,
      options: const ['a', 'b', 'c', 'd'],
      labelOf: _upperOf,
    );
  }
}

class _SolidDemo extends StatelessWidget {
  const _SolidDemo();
  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<String>(
      defaultValue: 'a',
      optionType: AntRadioGroupOptionType.button,
      buttonStyle: AntRadioButtonStyle.solid,
      options: const ['a', 'b', 'c', 'd'],
      labelOf: _upperOf,
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();
  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<String>(
      direction: AntRadioGroupDirection.vertical,
      options: const ['a', 'b', 'c'],
      labelOf: (value) => '选项 ${value.toUpperCase()}',
    );
  }
}

class _GroupDisabledDemo extends StatelessWidget {
  const _GroupDisabledDemo();
  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<String>(
      disabled: true,
      defaultValue: 'a',
      options: const ['a', 'b', 'c'],
      labelOf: (value) => '选项 ${value.toUpperCase()}',
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

String _capitalize(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

String _upperOf(String value) => value.toUpperCase();

/// 自定义模型：水果（带禁用态的业务数据）。
class _Fruit {
  const _Fruit(this.id, this.name, {this.disabled = false});

  final String id;
  final String name;
  final bool disabled;
}

const _fruits = [
  _Fruit('apple', '苹果'),
  _Fruit('pear', '梨'),
  _Fruit('orange', '橙子（缺货）', disabled: true),
];

class _ModelDemo extends StatelessWidget {
  const _ModelDemo();

  @override
  Widget build(BuildContext context) {
    return AntRadioGroup<_Fruit>(
      defaultValue: _fruits.first,
      options: _fruits,
      labelOf: (fruit) => fruit.name,
      disabledOf: (fruit) => fruit.disabled,
      onChange: (fruit) => debugPrint('radio onChanged: ${fruit?.id}'),
    );
  }
}
