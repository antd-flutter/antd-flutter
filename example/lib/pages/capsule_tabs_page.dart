library;

/// CapsuleTabs 胶囊选项卡演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class CapsuleTabsPage extends StatelessWidget {
  const CapsuleTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '灰色容器 + 白色激活胶囊'),
          _BasicDemo(),
          _Section(title: '三项切换', description: '多个胶囊项'),
          _MultiDemo(),
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
          Text(title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
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
    return AntCapsuleTabs(
      items: const [
        AntCapsuleTabItem(key: 'a', title: '选项一'),
        AntCapsuleTabItem(key: 'b', title: '选项二'),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _MultiDemo extends StatelessWidget {
  const _MultiDemo();

  @override
  Widget build(BuildContext context) {
    return AntCapsuleTabs(
      items: const [
        AntCapsuleTabItem(key: 'a', title: '全部'),
        AntCapsuleTabItem(key: 'b', title: '待付款'),
        AntCapsuleTabItem(key: 'c', title: '待发货'),
        AntCapsuleTabItem(key: 'd', title: '已完成'),
      ],
      onChange: (key) => _showSnackbar(context, '切换到: $key'),
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return AntCapsuleTabs(
      items: const [
        AntCapsuleTabItem(key: 'a', title: '可用'),
        AntCapsuleTabItem(key: 'b', title: '禁用', disabled: true),
        AntCapsuleTabItem(key: 'c', title: '可用'),
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
        Text('当前激活: $_activeKey'),
        const SizedBox(height: 8),
        AntCapsuleTabs(
          activeKey: _activeKey,
          items: const [
            AntCapsuleTabItem(key: 'a', title: '选项一'),
            AntCapsuleTabItem(key: 'b', title: '选项二'),
            AntCapsuleTabItem(key: 'c', title: '选项三'),
          ],
          onChange: (key) => setState(() => _activeKey = key),
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