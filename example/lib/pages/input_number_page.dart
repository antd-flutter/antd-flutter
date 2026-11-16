library;

/// InputNumber 数字输入框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class InputNumberPage extends StatelessWidget {
  const InputNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '通过点击或键盘输入数值'),
          _BasicDemo(),
          _Section(title: '三种尺寸', description: 'size: large / middle / small'),
          _SizeDemo(),
          _Section(title: '上下限', description: 'min / max 限制输入范围'),
          _LimitDemo(),
          _Section(title: '步长与精度', description: 'step / precision'),
          _StepDemo(),
          _Section(title: '步进按钮模式', description: 'controls: upDown / up / down / none'),
          _ControlsDemo(),
          _Section(title: '前置和后置标签', description: 'addonBefore / addonAfter'),
          _AddonDemo(),
          _Section(title: '校验状态', description: 'status: error / warning'),
          _StatusDemo(),
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

/// 输入框行容器
class _Row extends StatelessWidget {
  const _Row({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(wrap: true, gap: const AntFlexGap.all(12), children: children);
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return const AntInputNumber(defaultValue: 1);
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(size: AntInputSize.large, defaultValue: 1),
      AntInputNumber(size: AntInputSize.middle, defaultValue: 1),
      AntInputNumber(size: AntInputSize.small, defaultValue: 1),
    ]);
  }
}

class _LimitDemo extends StatelessWidget {
  const _LimitDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(min: 0, max: 10, defaultValue: 3),
      AntInputNumber(min: -10, max: 10, defaultValue: 0, step: 2),
    ]);
  }
}

class _StepDemo extends StatelessWidget {
  const _StepDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(step: 0.1, defaultValue: 1.0),
      AntInputNumber(step: 10, defaultValue: 100),
      AntInputNumber(precision: 2, step: 0.01, defaultValue: 3.14),
    ]);
  }
}

class _ControlsDemo extends StatelessWidget {
  const _ControlsDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(controls: AntInputNumberControls.upDown, defaultValue: 1),
      AntInputNumber(controls: AntInputNumberControls.up, defaultValue: 1),
      AntInputNumber(controls: AntInputNumberControls.down, defaultValue: 1),
      AntInputNumber(controls: AntInputNumberControls.none, defaultValue: 1),
    ]);
  }
}

class _AddonDemo extends StatelessWidget {
  const _AddonDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(addonBefore: Text('+'), defaultValue: 100),
      AntInputNumber(addonAfter: Text('元'), defaultValue: 100),
      AntInputNumber(addonBefore: Text('价格'), addonAfter: Text('¥'), defaultValue: 50),
    ]);
  }
}

class _StatusDemo extends StatelessWidget {
  const _StatusDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(status: AntInputStatus.error, defaultValue: 1),
      AntInputNumber(status: AntInputStatus.warning, defaultValue: 1),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _Row(children: [
      AntInputNumber(disabled: true, defaultValue: 1),
      AntInputNumber(disabled: true, controls: AntInputNumberControls.none, defaultValue: 5),
    ]);
  }
}