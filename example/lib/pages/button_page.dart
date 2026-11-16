library;

/// Button 按钮演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '按钮类型', description: 'type: normal / primary / dashed / link / text'),
          _TypeDemo(),
          _Section(title: '颜色', description: 'color: normal / primary / danger'),
          _ColorDemo(),
          _Section(title: '变体', description: 'variant: solid / filled / outlined / dashed / text'),
          _VariantDemo(),
          _Section(title: '预设色', description: 'color: blue / purple / cyan / green / ...'),
          _PresetColorDemo(),
          _Section(title: '尺寸', description: 'size: large / middle / small'),
          _SizeDemo(),
          _Section(title: '形状', description: 'shape: normal / circle / round'),
          _ShapeDemo(),
          _Section(title: '图标', description: 'icon + iconPlacement'),
          _IconDemo(),
          _Section(title: '加载中', description: 'loading: true'),
          _LoadingDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(title: '幽灵按钮', description: 'ghost: true（用于深色背景）'),
          _GhostDemo(),
          _Section(title: '撑满', description: 'block: true'),
          _BlockDemo(),
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

/// 按钮行容器
class _ButtonRow extends StatelessWidget {
  const _ButtonRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(wrap: true, gap: const AntFlexGap.all(12), children: children);
  }
}

class _TypeDemo extends StatelessWidget {
  const _TypeDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(child: Text('Default')),
      AntButton(type: AntButtonType.primary, child: Text('Primary')),
      AntButton(type: AntButtonType.dashed, child: Text('Dashed')),
      AntButton(type: AntButtonType.link, child: Text('Link')),
      AntButton(type: AntButtonType.text, child: Text('Text')),
    ]);
  }
}

class _ColorDemo extends StatelessWidget {
  const _ColorDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(color: AntButtonColor.normal, child: Text('Default')),
      AntButton(color: AntButtonColor.primary, child: Text('Primary')),
      AntButton(color: AntButtonColor.danger, child: Text('Danger')),
    ]);
  }
}

class _VariantDemo extends StatelessWidget {
  const _VariantDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(color: AntButtonColor.primary, variant: AntButtonVariant.solid, child: Text('Solid')),
      AntButton(color: AntButtonColor.primary, variant: AntButtonVariant.filled, child: Text('Filled')),
      AntButton(color: AntButtonColor.primary, variant: AntButtonVariant.outlined, child: Text('Outlined')),
      AntButton(color: AntButtonColor.primary, variant: AntButtonVariant.dashed, child: Text('Dashed')),
      AntButton(color: AntButtonColor.primary, variant: AntButtonVariant.text, child: Text('Text')),
    ]);
  }
}

class _PresetColorDemo extends StatelessWidget {
  const _PresetColorDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(color: AntButtonColor.blue, child: Text('Blue')),
      AntButton(color: AntButtonColor.purple, child: Text('Purple')),
      AntButton(color: AntButtonColor.cyan, child: Text('Cyan')),
      AntButton(color: AntButtonColor.green, child: Text('Green')),
      AntButton(color: AntButtonColor.magenta, child: Text('Magenta')),
      AntButton(color: AntButtonColor.red, child: Text('Red')),
      AntButton(color: AntButtonColor.orange, child: Text('Orange')),
      AntButton(color: AntButtonColor.volcano, child: Text('Volcano')),
      AntButton(color: AntButtonColor.gold, child: Text('Gold')),
      AntButton(color: AntButtonColor.lime, child: Text('Lime')),
    ]);
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(size: AntButtonSize.large, child: Text('Large')),
      AntButton(size: AntButtonSize.middle, child: Text('Middle')),
      AntButton(size: AntButtonSize.small, child: Text('Small')),
    ]);
  }
}

class _ShapeDemo extends StatelessWidget {
  const _ShapeDemo();
  @override
  Widget build(BuildContext context) {
    return _ButtonRow(children: [
      const AntButton(child: Text('Default')),
      const AntButton(shape: AntButtonShape.circle, child: Text('A')),
      const AntButton(shape: AntButtonShape.round, child: Text('Round')),
      const AntButton(shape: AntButtonShape.square, child: Text('Square')),
      AntButton(
        type: AntButtonType.primary,
        shape: AntButtonShape.circle,
        icon: const Icon(Icons.search, size: 16),
      ),
      const AntButton(
        type: AntButtonType.primary,
        shape: AntButtonShape.round,
        icon: Icon(Icons.download, size: 16),
        child: Text('Download'),
      ),
    ]);
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(type: AntButtonType.primary, icon: Icon(Icons.search, size: 16), child: Text('Search')),
      AntButton(icon: Icon(Icons.search, size: 16), child: Text('Search')),
      AntButton(
        type: AntButtonType.dashed,
        icon: Icon(Icons.download, size: 16),
        child: Text('Download'),
      ),
      AntButton(
        type: AntButtonType.primary,
        icon: Icon(Icons.arrow_forward, size: 16),
        iconPlacement: AntButtonIconPlacement.end,
        child: Text('Next'),
      ),
    ]);
  }
}

class _LoadingDemo extends StatelessWidget {
  const _LoadingDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(type: AntButtonType.primary, loading: true, child: Text('Loading')),
      AntButton(loading: true, child: Text('Loading')),
      AntButton(type: AntButtonType.dashed, loading: true, child: Text('Loading')),
      AntButton(type: AntButtonType.primary, loading: true),
      AntButton(type: AntButtonType.text, loading: true, child: Text('Loading')),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _ButtonRow(children: [
      AntButton(disabled: true, child: Text('Default')),
      AntButton(type: AntButtonType.primary, disabled: true, child: Text('Primary')),
      AntButton(type: AntButtonType.dashed, disabled: true, child: Text('Dashed')),
      AntButton(type: AntButtonType.link, disabled: true, child: Text('Link')),
      AntButton(type: AntButtonType.text, disabled: true, child: Text('Text')),
    ]);
  }
}

class _GhostDemo extends StatelessWidget {
  const _GhostDemo();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const _ButtonRow(children: [
        AntButton(ghost: true, child: Text('Default Ghost')),
        AntButton(type: AntButtonType.primary, ghost: true, child: Text('Primary Ghost')),
        AntButton(type: AntButtonType.dashed, ghost: true, child: Text('Dashed Ghost')),
        AntButton(type: AntButtonType.link, ghost: true, child: Text('Link Ghost')),
      ]),
    );
  }
}

class _BlockDemo extends StatelessWidget {
  const _BlockDemo();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AntButton(block: true, child: Text('Block Default')),
          SizedBox(height: 12),
          AntButton(block: true, type: AntButtonType.primary, child: Text('Block Primary')),
        ],
      ),
    );
  }
}