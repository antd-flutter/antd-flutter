library;

/// Anchor 锚点演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AnchorPage extends StatelessWidget {
  const AnchorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '联动滚动', description: '点击锚点平滑滚动到对应区块；滚动内容时锚点自动切换高亮'),
          _LinkedDemo(),
          _Section(title: '基本用法', description: '默认垂直方向，点击切换激活项'),
          _BasicDemo(),
          _Section(title: '嵌套子链接', description: 'children 子链接自动缩进'),
          _NestedDemo(),
          _Section(title: '水平方向', description: 'direction=horizontal'),
          _HorizontalDemo(),
          _Section(title: '受控模式', description: '外部 controller 控制激活项'),
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
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorText)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: TextStyle(fontSize: 12, color: theme.colorTextTertiary)),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 基本用法
// ------------------------------------------------------------

class _LinkedDemo extends StatefulWidget {
  const _LinkedDemo();

  @override
  State<_LinkedDemo> createState() => _LinkedDemoState();
}

class _LinkedDemoState extends State<_LinkedDemo> {
  static const _sections = [
    ('intro', '介绍', 'Anchor 用于在长页面中定位到指定区块，常与侧边导航配合。'),
    ('usage', '使用方式', '传入 scrollController 与 targetKeys 后，点击锚点会滚动到对应区块。'),
    ('api', 'API', '常用参数：items、scrollController、targetKeys、topOffset、autoScroll。'),
    ('faq', '常见问题', '区块超出视口时会自动滚动；滚动页面时锚点高亮会跟随更新。'),
  ];

  final _scrollController = ScrollController();
  final _anchorController = AntAnchorController();
  final Map<String, GlobalKey> _targetKeys = {
    for (final section in _sections) section.$1: GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    _anchorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SizedBox(
      height: 320,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorSplit),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AntAnchor(
              controller: _anchorController,
              scrollController: _scrollController,
              targetKeys: _targetKeys,
              items: [
                for (final section in _sections)
                  AntAnchorItem(key: section.$1, title: section.$2),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorSplit),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    for (var i = 0; i < _sections.length; i++)
                      Container(
                        key: _targetKeys[_sections[i].$1],
                        height: 240,
                        margin: EdgeInsets.only(bottom: i == _sections.length - 1 ? 0 : 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: i.isEven ? theme.colorFillAlter : theme.colorFillQuaternary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _sections[i].$2,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _sections[i].$3,
                              style: TextStyle(fontSize: 13, color: theme.colorTextSecondary),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
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
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntAnchor(
        items: [
          AntAnchorItem(key: 'part-1', title: 'Part 1'),
          AntAnchorItem(key: 'part-2', title: 'Part 2'),
          AntAnchorItem(key: 'part-3', title: 'Part 3'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 嵌套子链接
// ------------------------------------------------------------

class _NestedDemo extends StatelessWidget {
  const _NestedDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntAnchor(
        items: [
          AntAnchorItem(key: 'part-1', title: 'Part 1', children: [
            AntAnchorItem(key: 'part-1-1', title: 'Sub 1-1'),
            AntAnchorItem(key: 'part-1-2', title: 'Sub 1-2'),
          ]),
          AntAnchorItem(key: 'part-2', title: 'Part 2', children: [
            AntAnchorItem(key: 'part-2-1', title: 'Sub 2-1'),
          ]),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 水平方向
// ------------------------------------------------------------

class _HorizontalDemo extends StatelessWidget {
  const _HorizontalDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntAnchor(
        direction: AntAnchorDirection.horizontal,
        items: [
          AntAnchorItem(key: 'a', title: '锚点 A'),
          AntAnchorItem(key: 'b', title: '锚点 B'),
          AntAnchorItem(key: 'c', title: '锚点 C'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 受控模式
// ------------------------------------------------------------

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  final _controller = AntAnchorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntAnchor(
            controller: _controller,
            items: const [
              AntAnchorItem(key: 'x', title: '受控项 X'),
              AntAnchorItem(key: 'y', title: '受控项 Y'),
              AntAnchorItem(key: 'z', title: '受控项 Z'),
            ],
          ),
        ),
        const SizedBox(width: 16),
        AntButton(
          child: const Text('激活 Y'),
          onTap: () => _controller.setActive('y'),
        ),
      ],
    );
  }
}