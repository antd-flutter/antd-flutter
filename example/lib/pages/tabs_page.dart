library;

/// Tabs 选项卡演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

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
              child: AntText(text: description!, type: AntTypographyType.secondary),
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
    return AntTabs(
      items: const [
        AntTabsItem(key: '1', label: 'Tab 1', child: Text('Content of Tab Pane 1')),
        AntTabsItem(key: '2', label: 'Tab 2', child: Text('Content of Tab Pane 2')),
        AntTabsItem(key: '3', label: 'Tab 3', child: Text('Content of Tab Pane 3')),
      ],
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
    return AntTabs(
      type: AntTabsType.card,
      items: const [
        AntTabsItem(key: '1', label: 'Tab 1', child: Text('Card content 1')),
        AntTabsItem(key: '2', label: 'Tab 2', child: Text('Card content 2')),
        AntTabsItem(key: '3', label: 'Tab 3', child: Text('Card content 3')),
      ],
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
      (i) => AntTabsItem(
        key: '${i + 1}',
        label: 'Tab ${i + 1}',
        child: Text('Content of Tab ${i + 1}'),
      ),
    );
    return AntTabs(
      type: AntTabsType.editableCard,
      items: items,
      onEdit: (key, action) {
        setState(() {
          if (action == AntTabsEditAction.add) {
            _count++;
          } else if (_count > 1) {
            _count--;
          }
        });
      },
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
          child: AntTabs(
            tabPosition: AntTabPosition.left,
            items: const [
              AntTabsItem(key: '1', label: 'Tab 1', child: Text('Left position content 1')),
              AntTabsItem(key: '2', label: 'Tab 2', child: Text('Left position content 2')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: AntTabs(
            tabPosition: AntTabPosition.bottom,
            items: const [
              AntTabsItem(key: '1', label: 'Tab 1', child: Text('Bottom position content 1')),
              AntTabsItem(key: '2', label: 'Tab 2', child: Text('Bottom position content 2')),
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
        AntTabs(
          size: AntTabsSize.small,
          items: const [
            AntTabsItem(key: '1', label: 'Small Tab 1', child: Text('Small content 1')),
            AntTabsItem(key: '2', label: 'Small Tab 2', child: Text('Small content 2')),
          ],
        ),
        const SizedBox(height: 16),
        AntTabs(
          centered: true,
          items: const [
            AntTabsItem(key: '1', label: 'Centered 1', child: Text('Centered content 1')),
            AntTabsItem(key: '2', label: 'Centered 2', child: Text('Centered content 2')),
          ],
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
    return AntTabs(
      items: const [
        AntTabsItem(
          key: '1',
          label: 'Tab 1',
          icon: AntdIcon(AntIcons.androidOutlined, size: 16),
          child: Text('Content with icon'),
        ),
        AntTabsItem(
          key: '2',
          label: 'Tab 2',
          icon: AntdIcon(AntIcons.appleOutlined, size: 16),
          child: Text('Another content'),
        ),
        AntTabsItem(
          key: '3',
          label: 'Disabled',
          child: Text('Disabled content'),
          disabled: true,
        ),
      ],
    );
  }
}