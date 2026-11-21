library;

/// Tabs 选项卡演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _TabData {
  const _TabData({
    required this.key,
    this.label,
    this.child,
    this.icon,
    this.disabled = false,
  });

  final String key;
  final String? label;
  final Widget? child;
  final Widget? icon;
  final bool disabled;
}

Widget _tabs({
  Key? key,
  List<_TabData> items = const [],
  Object? activeKey,
  Object? defaultActiveKey,
  AntTabsType type = AntTabsType.line,
  AntTabsSize size = AntTabsSize.normal,
  AntTabPosition tabPosition = AntTabPosition.top,
  bool centered = false,
  bool animated = true,
  double? tabBarGutter,
  Widget? addIcon,
  ValueChanged<_TabData>? onChange,
  void Function(_TabData? item, AntTabsEditAction action)? onEdit,
}) {
  return AntTabs<_TabData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    labelBuilder: (context, item, index) => Text(item.label ?? item.key),
    childBuilder: (context, item, index) => item.child,
    iconBuilder: (context, item) => item.icon,
    disabledOf: (item) => item.disabled,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    type: type,
    size: size,
    tabPosition: tabPosition,
    centered: centered,
    animated: animated,
    tabBarGutter: tabBarGutter,
    addIcon: addIcon,
    onChange: onChange,
    onEdit: onEdit,
  );
}

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认 line 样式，点击切换'),
          _BasicDemo(),
          _Section(title: '卡片样式', description: 'type=card，标签以卡片形式展示'),
          _CardDemo(),
          _Section(
            title: '外边框分段',
            description: 'type=outlined，整组一枚圆角外框、内部等分，选中段主色描边',
          ),
          _OutlinedDemo(),
          _Section(title: '可编辑卡片', description: 'type=editableCard，支持增删选项卡'),
          _EditableDemo(),
          _Section(title: '位置', description: 'tabPosition=left/right/bottom'),
          _PositionDemo(),
          _Section(title: '尺寸与居中', description: 'size=small/large，centered 居中'),
          _SizeDemo(),
          _Section(title: '带图标与禁用', description: 'icon 自定义图标，disabled 禁用标签'),
          _IconDisabledDemo(),
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
      padding: const EdgeInsets.only(top: 32, bottom: 16),
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

// ------------------------------------------------------------
// 基本用法
// ------------------------------------------------------------

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    // material_ui AntTabs 内部含 Expanded（垂直内容区），在无界高度
    // （SingleChildScrollView）下会溢出抛异常，demo 页加有界高度约束。
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: _tabs(
        items: [
          _TabData(
            key: '1',
            label: 'Tab 1',
            child: Text('Content of Tab Pane 1'),
          ),
          _TabData(
            key: '2',
            label: 'Tab 2',
            child: Text('Content of Tab Pane 2'),
          ),
          _TabData(
            key: '3',
            label: 'Tab 3',
            child: Text('Content of Tab Pane 3'),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 卡片样式
// ------------------------------------------------------------

class _CardDemo extends StatelessWidget {
  const _CardDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: _tabs(
        type: AntTabsType.card,
        items: [
          _TabData(key: '1', label: 'Tab 1', child: Text('Card content 1')),
          _TabData(key: '2', label: 'Tab 2', child: Text('Card content 2')),
          _TabData(key: '3', label: 'Tab 3', child: Text('Card content 3')),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 外边框分段
// ------------------------------------------------------------

class _OutlinedDemo extends StatelessWidget {
  const _OutlinedDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: _tabs(
        type: AntTabsType.outlined,
        size: AntTabsSize.small,
        items: [
          _TabData(
            key: 's',
            label: 'Small',
            child: Text('Small size tab content'),
          ),
          _TabData(
            key: 'm',
            label: 'Medium',
            child: Text('Medium size tab content'),
          ),
          _TabData(
            key: 'l',
            label: 'Large',
            child: Text('Large size tab content'),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 可编辑卡片
// ------------------------------------------------------------

class _EditableDemo extends StatefulWidget {
  const _EditableDemo();

  @override
  State<_EditableDemo> createState() => _EditableDemoState();
}

class _EditableDemoState extends State<_EditableDemo> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      _count,
      (i) => _TabData(
        key: '${i + 1}',
        label: 'Tab ${i + 1}',
        child: Text('Content of Tab ${i + 1}'),
      ),
    );
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: _tabs(
        type: AntTabsType.editableCard,
        items: items,
        onEdit: (_, action) {
          setState(() {
            if (action == AntTabsEditAction.add) {
              _count++;
            } else if (_count > 1) {
              _count--;
            }
          });
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// 位置
// ------------------------------------------------------------

class _PositionDemo extends StatelessWidget {
  const _PositionDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: _tabs(
            tabPosition: AntTabPosition.left,
            items: const [
              _TabData(
                key: '1',
                label: 'Tab 1',
                child: Text('Left position content 1'),
              ),
              _TabData(
                key: '2',
                label: 'Tab 2',
                child: Text('Left position content 2'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _tabs(
            tabPosition: AntTabPosition.bottom,
            items: const [
              _TabData(
                key: '1',
                label: 'Tab 1',
                child: Text('Bottom position content 1'),
              ),
              _TabData(
                key: '2',
                label: 'Tab 2',
                child: Text('Bottom position content 2'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// 尺寸与居中
// ------------------------------------------------------------

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: _tabs(
            size: AntTabsSize.small,
            items: const [
              _TabData(
                key: '1',
                label: 'Small Tab 1',
                child: Text('Small content 1'),
              ),
              _TabData(
                key: '2',
                label: 'Small Tab 2',
                child: Text('Small content 2'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: _tabs(
            centered: true,
            items: const [
              _TabData(
                key: '1',
                label: 'Centered 1',
                child: Text('Centered content 1'),
              ),
              _TabData(
                key: '2',
                label: 'Centered 2',
                child: Text('Centered content 2'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// 带图标与禁用
// ------------------------------------------------------------

class _IconDisabledDemo extends StatelessWidget {
  const _IconDisabledDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: _tabs(
        items: const [
          _TabData(
            key: '1',
            label: 'Tab 1',
            icon: AntdIcon(AntIcons.androidOutlined, size: 16),
            child: Text('Content with icon'),
          ),
          _TabData(
            key: '2',
            label: 'Tab 2',
            icon: AntdIcon(AntIcons.appleOutlined, size: 16),
            child: Text('Another content'),
          ),
          _TabData(
            key: '3',
            label: 'Disabled',
            child: Text('Disabled content'),
            disabled: true,
          ),
        ],
      ),
    );
  }
}
