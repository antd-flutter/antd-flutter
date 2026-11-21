library;

/// SideBar 侧边导航栏演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _SideBarData {
  const _SideBarData({
    required this.key,
    required this.title,
    this.badgeText,
    this.badgeDot = false,
    this.disabled = false,
  });

  final String key;
  final String title;
  final String? badgeText;
  final bool badgeDot;
  final bool disabled;
}

Widget _sideBar({
  Key? key,
  List<_SideBarData> items = const [],
  Object? activeKey,
  Object? defaultActiveKey,
  ValueChanged<_SideBarData>? onChange,
}) {
  return AntSideBar<_SideBarData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) => Text(item.title),
    badgeTextOf: (item) => item.badgeText,
    badgeDotOf: (item) => item.badgeDot,
    disabledOf: (item) => item.disabled,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
  );
}

class SideBarPage extends StatelessWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '左侧高亮条 + 白色激活背景'),
          _BasicDemo(),
          _Section(title: '角标', description: '圆点角标与文字角标'),
          _BadgeDemo(),
          _Section(title: '禁用项', description: 'disabled: true 不可点击'),
          _DisabledDemo(),
          _Section(title: '联动内容', description: 'SideBar + 右侧内容区联动切换'),
          _LinkedDemo(),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _sideBar(
        items: const [
          _SideBarData(key: 'a', title: '选项一'),
          _SideBarData(key: 'b', title: '选项二'),
          _SideBarData(key: 'c', title: '选项三'),
          _SideBarData(key: 'd', title: '选项四'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _sideBar(
        items: const [
          _SideBarData(key: 'a', title: '通知', badgeDot: true),
          _SideBarData(key: 'b', title: '消息', badgeText: '9'),
          _SideBarData(key: 'c', title: '设置'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _sideBar(
        items: const [
          _SideBarData(key: 'a', title: '可用项'),
          _SideBarData(key: 'b', title: '禁用项', disabled: true),
          _SideBarData(key: 'c', title: '可用项'),
        ],
        onChange: (key) => _showSnackbar(context, '切换到: $key'),
      ),
    );
  }
}

class _LinkedDemo extends StatefulWidget {
  const _LinkedDemo();

  @override
  State<_LinkedDemo> createState() => _LinkedDemoState();
}

class _LinkedDemoState extends State<_LinkedDemo> {
  String _activeKey = 'a';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: _sideBar(
              activeKey: _activeKey,
              items: const [
                _SideBarData(key: 'a', title: '水果'),
                _SideBarData(key: 'b', title: '蔬菜'),
                _SideBarData(key: 'c', title: '肉类'),
              ],
              onChange: (item) => setState(() => _activeKey = item.key),
            ),
          ),
          Expanded(
            child: Center(child: AntText(text: _contentFor(_activeKey))),
          ),
        ],
      ),
    );
  }

  String _contentFor(String key) {
    switch (key) {
      case 'a':
        return '🍎 水果分类';
      case 'b':
        return '🥬 蔬菜分类';
      case 'c':
        return '🥩 肉类分类';
      default:
        return '';
    }
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
