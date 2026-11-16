/// Icon 图标演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class IconPage extends StatelessWidget {
  const IconPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: 'AntdIcon + AntIcons（Outlined 线框风格，TTF 字体渲染）'),
          _OutlinedDemo(),
          _Section(title: '实心图标', description: 'AntIcons *Filled 系列'),
          _FilledDemo(),
          _Section(title: '双色图标', description: 'AntIconsTwotone 系列（SVG 渲染，默认 #333 + #E6E6E6）'),
          _TwoToneDemo(),
          _Section(title: '自定义双色', description: 'twoToneColor 指定主色，次色自动提亮生成'),
          _TwoToneColorDemo(),
          _Section(title: '图标尺寸', description: 'size: 16 / 24 / 32 / 48 / 64'),
          _SizeDemo(),
          _Section(title: '图标颜色', description: 'color: 主题色 / 预设色（仅 TTF 模式生效）'),
          _ColorDemo(),
          _Section(title: '图标按钮', description: '图标与 AntButton 组合使用'),
          _IconButtonDemo(),
          _Section(title: '旋转动画', description: 'AntIcons.loadingOutlined 配合 AnimationController'),
          _SpinDemo(),
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

/// 图标网格容器
class _IconGrid extends StatelessWidget {
  const _IconGrid({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(wrap: true, gap: const AntFlexGap.all(16), children: children);
  }
}

/// 单个图标展示单元（图标 + 名称）
class _IconCell extends StatelessWidget {
  const _IconCell({required this.icon, required this.label});
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

/// Outlined 线框图标
class _OutlinedDemo extends StatelessWidget {
  const _OutlinedDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      _IconCell(icon: AntdIcon(AntIcons.homeOutlined), label: 'home'),
      _IconCell(icon: AntdIcon(AntIcons.userOutlined), label: 'user'),
      _IconCell(icon: AntdIcon(AntIcons.searchOutlined), label: 'search'),
      _IconCell(icon: AntdIcon(AntIcons.settingOutlined), label: 'setting'),
      _IconCell(icon: AntdIcon(AntIcons.bellOutlined), label: 'bell'),
      _IconCell(icon: AntdIcon(AntIcons.heartOutlined), label: 'heart'),
      _IconCell(icon: AntdIcon(AntIcons.starOutlined), label: 'star'),
      _IconCell(icon: AntdIcon(AntIcons.smileOutlined), label: 'smile'),
      _IconCell(icon: AntdIcon(AntIcons.checkOutlined), label: 'check'),
      _IconCell(icon: AntdIcon(AntIcons.calendarOutlined), label: 'calendar'),
      _IconCell(icon: AntdIcon(AntIcons.cameraOutlined), label: 'camera'),
      _IconCell(icon: AntdIcon(AntIcons.cloudOutlined), label: 'cloud'),
      _IconCell(icon: AntdIcon(AntIcons.fireOutlined), label: 'fire'),
      _IconCell(icon: AntdIcon(AntIcons.giftOutlined), label: 'gift'),
      _IconCell(icon: AntdIcon(AntIcons.lockOutlined), label: 'lock'),
      _IconCell(icon: AntdIcon(AntIcons.mailOutlined), label: 'mail'),
      _IconCell(icon: AntdIcon(AntIcons.phoneOutlined), label: 'phone'),
      _IconCell(icon: AntdIcon(AntIcons.rocketOutlined), label: 'rocket'),
      _IconCell(icon: AntdIcon(AntIcons.thunderboltOutlined), label: 'thunderbolt'),
      _IconCell(icon: AntdIcon(AntIcons.trophyOutlined), label: 'trophy'),
    ]);
  }
}

/// Filled 实心图标
class _FilledDemo extends StatelessWidget {
  const _FilledDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      _IconCell(icon: AntdIcon(AntIcons.homeFilled), label: 'home'),
      _IconCell(icon: AntdIcon(AntIcons.contactsFilled), label: 'contacts'),
      _IconCell(icon: AntdIcon(AntIcons.heartFilled), label: 'heart'),
      _IconCell(icon: AntdIcon(AntIcons.starFilled), label: 'star'),
      _IconCell(icon: AntdIcon(AntIcons.smileFilled), label: 'smile'),
      _IconCell(icon: AntdIcon(AntIcons.bellFilled), label: 'bell'),
      _IconCell(icon: AntdIcon(AntIcons.fireFilled), label: 'fire'),
      _IconCell(icon: AntdIcon(AntIcons.lockFilled), label: 'lock'),
      _IconCell(icon: AntdIcon(AntIcons.mailFilled), label: 'mail'),
      _IconCell(icon: AntdIcon(AntIcons.phoneFilled), label: 'phone'),
      _IconCell(icon: AntdIcon(AntIcons.cameraFilled), label: 'camera'),
      _IconCell(icon: AntdIcon(AntIcons.calendarFilled), label: 'calendar'),
      _IconCell(icon: AntdIcon(AntIcons.likeFilled), label: 'like'),
      _IconCell(icon: AntdIcon(AntIcons.messageFilled), label: 'message'),
      _IconCell(icon: AntdIcon(AntIcons.rocketFilled), label: 'rocket'),
      _IconCell(icon: AntdIcon(AntIcons.settingFilled), label: 'setting'),
      _IconCell(icon: AntdIcon(AntIcons.thunderboltFilled), label: 'thunderbolt'),
      _IconCell(icon: AntdIcon(AntIcons.trophyFilled), label: 'trophy'),
      _IconCell(icon: AntdIcon(AntIcons.checkCircleFilled), label: 'check-circle'),
      _IconCell(icon: AntdIcon(AntIcons.environmentFilled), label: 'environment'),
    ]);
  }
}

/// TwoTone 双色图标（默认色）
class _TwoToneDemo extends StatelessWidget {
  const _TwoToneDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      _IconCell(icon: AntdIcon(AntIconsTwotone.checkCircleTwoTone), label: 'check-circle'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.alertTwoTone), label: 'alert'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.bellTwoTone), label: 'bell'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.bookTwoTone), label: 'book'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.bugTwoTone), label: 'bug'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.buildTwoTone), label: 'build'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.bulbTwoTone), label: 'bulb'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.calendarTwoTone), label: 'calendar'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.cameraTwoTone), label: 'camera'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.carTwoTone), label: 'car'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.apiTwoTone), label: 'api'),
      _IconCell(icon: AntdIcon(AntIconsTwotone.bankTwoTone), label: 'bank'),
    ]);
  }
}

/// TwoTone 自定义主色
class _TwoToneColorDemo extends StatelessWidget {
  const _TwoToneColorDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFF1677FF)),
        label: 'blue',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFFF5222D)),
        label: 'red',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFF52C41A)),
        label: 'green',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFFFAAD14)),
        label: 'gold',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFF722ED1)),
        label: 'purple',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Color(0xFF13C2C2)),
        label: 'cyan',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.checkCircleTwoTone, twoToneColor: Color(0xFF52C41A)),
        label: 'check-green',
      ),
      _IconCell(
        icon: AntdIcon(AntIconsTwotone.alertTwoTone, twoToneColor: Color(0xFFFAAD14)),
        label: 'alert-gold',
      ),
    ]);
  }
}

/// 尺寸演示
class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      AntdIcon(AntIcons.starFilled, size: 16),
      AntdIcon(AntIcons.starFilled, size: 24),
      AntdIcon(AntIcons.starFilled, size: 32),
      AntdIcon(AntIcons.starFilled, size: 48),
      AntdIcon(AntIcons.starFilled, size: 64),
    ]);
  }
}

/// 颜色演示
class _ColorDemo extends StatelessWidget {
  const _ColorDemo();
  @override
  Widget build(BuildContext context) {
    return const _IconGrid(children: [
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFF1677FF)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFFF5222D)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFF52C41A)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFFFAAD14)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFF722ED1)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFF13C2C2)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFFEB2F96)),
      AntdIcon(AntIcons.heartFilled, size: 32, color: Color(0xFFFA8C16)),
    ]);
  }
}

/// 图标按钮
class _IconButtonDemo extends StatelessWidget {
  const _IconButtonDemo();
  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.all(12),
      children: const [
        AntButton(type: AntButtonType.primary, icon: AntdIcon(AntIcons.searchOutlined, size: 16), child: Text('Search')),
        AntButton(icon: AntdIcon(AntIcons.downloadOutlined, size: 16), child: Text('Download')),
        AntButton(type: AntButtonType.dashed, icon: AntdIcon(AntIcons.cloudDownloadOutlined, size: 16), child: Text('Cloud')),
        AntButton(type: AntButtonType.primary, icon: AntdIcon(AntIcons.plusOutlined, size: 16)),
        AntButton(type: AntButtonType.text, icon: AntdIcon(AntIcons.editOutlined, size: 16), child: Text('Edit')),
        AntButton(type: AntButtonType.primary, danger: true, icon: AntdIcon(AntIcons.deleteOutlined, size: 16), child: Text('Delete')),
      ],
    );
  }
}

/// 旋转动画演示
class _SpinDemo extends StatelessWidget {
  const _SpinDemo();
  @override
  Widget build(BuildContext context) {
    return const _SpinIcon();
  }
}

class _SpinIcon extends StatefulWidget {
  const _SpinIcon();

  @override
  State<_SpinIcon> createState() => _SpinIconState();
}

class _SpinIconState extends State<_SpinIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 24),
      children: [
        RotationTransition(
          turns: _controller,
          child: const AntdIcon(AntIcons.loadingOutlined, size: 32),
        ),
        RotationTransition(
          turns: _controller,
          child: const AntdIcon(AntIcons.syncOutlined, size: 32, color: Color(0xFF1677FF)),
        ),
      ],
    );
  }
}