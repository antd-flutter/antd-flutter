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