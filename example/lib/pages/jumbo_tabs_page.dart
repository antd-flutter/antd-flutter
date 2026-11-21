library;

/// JumboTabs 大选项卡演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _JumboData {
  const _JumboData({
    required this.key,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.disabled = false,
  });

  final String key;
  final String title;
  final String? description;
  final Widget? descriptionWidget;
  final bool disabled;
}

Widget _jumboTabs({
  Key? key,
  List<_JumboData> items = const [],
  Object? activeKey,
  Object? defaultActiveKey,
  ValueChanged<_JumboData>? onChange,
}) {
  return AntJumboTabs<_JumboData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) => Text(item.title),
    descriptionBuilder: (context, item, index) =>
        item.descriptionWidget ??
        (item.description == null ? null : Text(item.description!)),
    disabledOf: (item) => item.disabled,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
  );
}

class JumboTabsPage extends StatelessWidget {
  const JumboTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '主标题 + 描述，底部指示条'),
          _BasicDemo(),
          _Section(
            title: '自定义描述',
            description: 'description 走默认胶囊样式；descriptionWidget 可放任意内容',
          ),
          _DescDemo(),
          _Section(title: '禁用项', description: 'disabled: true'),
          _DisabledDemo(),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
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
    return _jumboTabs(
      items: const [
        _JumboData(key: 'a', title: '选项一', description: '描述一'),
        _JumboData(key: 'b', title: '选项二', description: '描述二'),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _DescDemo extends StatelessWidget {
  const _DescDemo();

  @override
  Widget build(BuildContext context) {
    return _jumboTabs(
      items: [
        const _JumboData(key: 'a', title: '水果', description: '新鲜水果'),
        const _JumboData(key: 'b', title: '蔬菜', description: '时令蔬菜'),
        _JumboData(
          key: 'c',
          title: '肉禽',
          descriptionWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntdIcon(AntIcons.starOutlined, size: 11),
              const SizedBox(width: 2),
              AntText(text: '优选', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return _jumboTabs(
      items: const [
        _JumboData(key: 'a', title: '可用', description: '正常状态'),
        _JumboData(key: 'b', title: '禁用', description: '不可点击', disabled: true),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
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
        AntText(text: '当前激活: $_activeKey'),
        const SizedBox(height: 8),
        _jumboTabs(
          activeKey: _activeKey,
          items: const [
            _JumboData(key: 'a', title: '选项一', description: '描述一'),
            _JumboData(key: 'b', title: '选项二', description: '描述二'),
            _JumboData(key: 'c', title: '选项三', description: '描述三'),
          ],
          onChange: (item) => setState(() => _activeKey = item.key),
        ),
      ],
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AntText(text: message),
      duration: const Duration(seconds: 1),
    ),
  );
}
