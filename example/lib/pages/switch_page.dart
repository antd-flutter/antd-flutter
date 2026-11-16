library;

/// Switch 开关演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SwitchPage extends StatelessWidget {
  const SwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '简单的开关'),
          _BasicDemo(),
          _Section(title: '受控用法', description: 'checked + onChange 联动'),
          _ControlledDemo(),
          _Section(title: '尺寸', description: 'size: middle / small'),
          _SizeDemo(),
          _Section(title: '文案', description: 'checkedChildren / unCheckedChildren'),
          _TextDemo(),
          _Section(title: '加载中', description: 'loading: true'),
          _LoadingDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
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
      AntSwitch(),
      AntSwitch(defaultChecked: true),
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
      AntSwitch(
        checked: _checked,
        onChange: (v) => setState(() => _checked = v),
      ),
    ]);
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntSwitch(defaultChecked: true),
      AntSwitch(defaultChecked: true, size: AntSwitchSize.small),
    ]);
  }
}

class _TextDemo extends StatelessWidget {
  const _TextDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntSwitch(
        defaultChecked: true,
        checkedChildren: Text('开'),
        unCheckedChildren: Text('关'),
      ),
      AntSwitch(
        defaultChecked: true,
        checkedChildren: Icon(Icons.check, size: 12, color: Colors.white),
        unCheckedChildren: Icon(Icons.close, size: 12, color: Colors.white),
      ),
    ]);
  }
}

class _LoadingDemo extends StatelessWidget {
  const _LoadingDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntSwitch(loading: true, defaultChecked: true),
      AntSwitch(loading: true),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntSwitch(disabled: true),
      AntSwitch(disabled: true, defaultChecked: true),
    ]);
  }
}