library;

/// Dropdown 下拉菜单演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class DropdownPage extends StatelessWidget {
  const DropdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认悬停触发，移出后关闭'),
          _BasicDemo(),
          _Section(title: '点击触发', description: 'trigger=click，点击打开/关闭'),
          _ClickDemo(),
          _Section(title: '弹出位置', description: 'placement 四个方向'),
          _PlacementDemo(),
          _Section(title: '带箭头', description: 'arrow=true 显示小箭头'),
          _ArrowDemo(),
          _Section(title: '菜单项样式', description: '分割线 / 禁用 / 危险项'),
          _ItemStyleDemo(),
          _Section(title: '受控模式', description: 'open + onOpenChange 外部控制'),
          _ControlledDemo(),
          _Section(title: 'Controller 模式', description: 'controller.show/hide 程序化控制，无需外部 state'),
          _ControllerDemo(),
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
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(text: title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(text: description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
        ],
      ),
    );
  }
}

const _basicItems = [
  AntDropdownItem(key: '1', label: '菜单项一'),
  AntDropdownItem(key: '2', label: '菜单项二'),
  AntDropdownItem(key: '3', label: '菜单项三'),
];

// ------------------------------------------------------------
// 基本用法
// ------------------------------------------------------------

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return AntDropdown(
      items: _basicItems,
      onClick: (key) => debugPrint('点击了 $key'),
      child: AntButton(child: const AntText(text: '悬停我')),
    );
  }
}

// ------------------------------------------------------------
// 点击触发
// ------------------------------------------------------------

class _ClickDemo extends StatelessWidget {
  const _ClickDemo();

  @override
  Widget build(BuildContext context) {
    return AntDropdown(
      items: _basicItems,
      trigger: AntDropdownTrigger.click,
      onClick: (key) => debugPrint('点击了 $key'),
      child: AntButton(child: const AntText(text: '点击我')),
    );
  }
}

// ------------------------------------------------------------
// 弹出位置
// ------------------------------------------------------------

class _PlacementDemo extends StatelessWidget {
  const _PlacementDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        AntDropdown(
          items: _basicItems,
          placement: AntDropdownPlacement.bottomLeft,
          child: AntButton(child: const AntText(text: 'bottomLeft')),
        ),
        AntDropdown(
          items: _basicItems,
          placement: AntDropdownPlacement.bottomRight,
          child: AntButton(child: const AntText(text: 'bottomRight')),
        ),
        AntDropdown(
          items: _basicItems,
          placement: AntDropdownPlacement.topLeft,
          child: AntButton(child: const AntText(text: 'topLeft')),
        ),
        AntDropdown(
          items: _basicItems,
          placement: AntDropdownPlacement.topRight,
          child: AntButton(child: const AntText(text: 'topRight')),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// 带箭头
// ------------------------------------------------------------

class _ArrowDemo extends StatelessWidget {
  const _ArrowDemo();

  @override
  Widget build(BuildContext context) {
    return AntDropdown(
      items: _basicItems,
      arrow: true,
      child: AntButton(child: const AntText(text: '带箭头')),
    );
  }
}

// ------------------------------------------------------------
// 菜单项样式
// ------------------------------------------------------------

class _ItemStyleDemo extends StatelessWidget {
  const _ItemStyleDemo();

  @override
  Widget build(BuildContext context) {
    return AntDropdown(
      trigger: AntDropdownTrigger.click,
      items: const [
        AntDropdownItem(key: 'edit', label: '编辑'),
        AntDropdownItem(key: 'copy', label: '复制'),
        AntDropdownItem(type: AntDropdownItemType.divider, key: 'd1'),
        AntDropdownItem(key: 'locked', label: '已锁定项', disabled: true),
        AntDropdownItem(type: AntDropdownItemType.divider, key: 'd2'),
        AntDropdownItem(key: 'delete', label: '删除', danger: true),
      ],
      onClick: (key) => debugPrint('点击了 $key'),
      child: AntButton(child: const AntText(text: '更多操作')),
    );
  }
}

// ------------------------------------------------------------
// 受控模式
// ------------------------------------------------------------

// ------------------------------------------------------------
// Controller 模式（R35.2）
// ------------------------------------------------------------

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  final AntDropdownController _controller = AntDropdownController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AntDropdown(
          items: _basicItems,
          controller: _controller,
          onClick: (key) => debugPrint('点击了 $key'),
          child: AntButton(child: const AntText(text: 'Controller 下拉')),
        ),
        const SizedBox(width: 16),
        AntButton(
          child: const AntText(text: 'show'),
          onTap: () => _controller.show(),
        ),
        const SizedBox(width: 12),
        AntButton(
          child: const AntText(text: 'hide'),
          onTap: () => _controller.hide(),
        ),
      ],
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AntDropdown(
          items: _basicItems,
          open: _open,
          onOpenChange: (v) => setState(() => _open = v),
          onClick: (key) => debugPrint('点击了 $key'),
          child: AntButton(child: const AntText(text: '受控下拉')),
        ),
        const SizedBox(width: 16),
        AntButton(
          child: AntText(text: _open ? '关闭' : '打开'),
          onTap: () => setState(() => _open = !_open),
        ),
      ],
    );
  }
}