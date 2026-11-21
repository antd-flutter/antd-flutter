library;

/// TabBar 标签栏演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _TabBarData {
  const _TabBarData({
    required this.key,
    this.title,
    this.icon,
    this.activeIcon,
    this.badgeText,
    this.badgeDot = false,
  });

  final String key;
  final String? title;
  final IconData? icon;
  final IconData? activeIcon;
  final String? badgeText;
  final bool badgeDot;
}

Widget _tabBar({
  Key? key,
  List<_TabBarData> items = const [],
  Object? activeKey,
  Object? defaultActiveKey,
  bool border = true,
  bool safeArea = false,
  ValueChanged<_TabBarData>? onChange,
}) {
  return AntTabBar<_TabBarData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) => Text(item.title ?? item.key),
    iconBuilder: (context, item) => item.icon == null ? null : Icon(item.icon),
    activeIconBuilder: (context, item) =>
        item.activeIcon == null ? null : Icon(item.activeIcon),
    badgeTextOf: (item) => item.badgeText,
    badgeDotOf: (item) => item.badgeDot,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    border: border,
    safeArea: safeArea,
    onChange: onChange,
  );
}

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '图标 + 标题，点击切换'),
          _BasicDemo(),
          _Section(title: '纯文字', description: '无图标，仅标题'),
          _TextOnlyDemo(),
          _Section(title: '圆点角标', description: 'badgeDot: true'),
          _BadgeDotDemo(),
          _Section(title: '文字角标', description: 'badgeText: "8"'),
          _BadgeTextDemo(),
          _Section(title: '激活图标', description: 'activeIcon 切换选中态图标'),
          _ActiveIconDemo(),
          _Section(title: '无边框', description: 'border: false'),
          _NoBorderDemo(),
          _Section(title: '受控模式', description: 'activeKey 由外部控制'),
          _ControlledDemo(),
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
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntTitle(title, level: AntTitleLevel.h4),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                type: AntTypographyType.secondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return _tabBar(
      items: const [
        _TabBarData(
          key: 'home',
          title: '首页',
          icon: AntIcons.homeOutlined,
          activeIcon: AntIcons.homeOutlined,
        ),
        _TabBarData(
          key: 'find',
          title: '发现',
          icon: AntIcons.compassOutlined,
          activeIcon: AntIcons.compassOutlined,
        ),
        _TabBarData(
          key: 'me',
          title: '我的',
          icon: AntIcons.userOutlined,
          activeIcon: AntIcons.userOutlined,
        ),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _TextOnlyDemo extends StatelessWidget {
  const _TextOnlyDemo();

  @override
  Widget build(BuildContext context) {
    return _tabBar(
      items: const [
        _TabBarData(key: 'a', title: '选项一'),
        _TabBarData(key: 'b', title: '选项二'),
        _TabBarData(key: 'c', title: '选项三'),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _BadgeDotDemo extends StatelessWidget {
  const _BadgeDotDemo();

  @override
  Widget build(BuildContext context) {
    return _tabBar(
      items: const [
        _TabBarData(key: 'home', title: '首页', icon: AntIcons.homeOutlined),
        _TabBarData(
          key: 'msg',
          title: '消息',
          icon: AntIcons.messageOutlined,
          badgeDot: true,
        ),
        _TabBarData(key: 'me', title: '我的', icon: AntIcons.userOutlined),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _BadgeTextDemo extends StatelessWidget {
  const _BadgeTextDemo();

  @override
  Widget build(BuildContext context) {
    return _tabBar(
      items: const [
        _TabBarData(key: 'home', title: '首页', icon: AntIcons.homeOutlined),
        _TabBarData(
          key: 'cart',
          title: '购物车',
          icon: AntIcons.shoppingOutlined,
          badgeText: '8',
        ),
        _TabBarData(key: 'me', title: '我的', icon: AntIcons.userOutlined),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _ActiveIconDemo extends StatelessWidget {
  const _ActiveIconDemo();

  @override
  Widget build(BuildContext context) {
    return _tabBar(
      items: const [
        _TabBarData(
          key: 'home',
          title: '首页',
          icon: AntIcons.homeOutlined,
          activeIcon: AntIcons.homeOutlined,
        ),
        _TabBarData(
          key: 'star',
          title: '收藏',
          icon: AntIcons.starOutlined,
          activeIcon: AntIcons.starOutlined,
        ),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _NoBorderDemo extends StatelessWidget {
  const _NoBorderDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _tabBar(
        border: false,
        items: const [
          _TabBarData(key: 'a', title: '选项一'),
          _TabBarData(key: 'b', title: '选项二'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String _activeKey = 'a';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('当前激活: $_activeKey'),
        const SizedBox(height: 8),
        _tabBar(
          activeKey: _activeKey,
          items: const [
            _TabBarData(key: 'a', title: '选项一'),
            _TabBarData(key: 'b', title: '选项二'),
            _TabBarData(key: 'c', title: '选项三'),
          ],
          onChange: (item) => setState(() => _activeKey = item.key),
        ),
      ],
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
