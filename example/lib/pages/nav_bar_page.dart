library;

/// NavBar 导航栏演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '标题居中，底部带分割线'),
          _BasicDemo(),
          _Section(title: '返回箭头', description: 'back: true，点击触发 onBack'),
          _BackDemo(),
          _Section(title: '左侧附加', description: 'backArrow + left 组合'),
          _LeftDemo(),
          _Section(title: '右侧操作', description: 'right 放置操作按钮'),
          _RightDemo(),
          _Section(title: '无边框', description: 'border: false，隐藏底部分割线'),
          _NoBorderDemo(),
          _Section(title: '完整示例', description: '返回 + 标题 + 右侧多操作'),
          _FullDemo(),
          _Section(
            title: 'AntAppBar 别名',
            description: 'Flutter 习惯的 AppBar 形态（title/leading/actions），内部委托 AntNavBar',
          ),
          _AppBarDemo(),
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
    return const AntNavBar(child: Text('页面标题'));
  }
}

class _BackDemo extends StatelessWidget {
  const _BackDemo();

  @override
  Widget build(BuildContext context) {
    return AntNavBar(
      back: true,
      onBack: () => _showSnackbar(context, '点击了返回'),
      child: const Text('带返回'),
    );
  }
}

class _LeftDemo extends StatelessWidget {
  const _LeftDemo();

  @override
  Widget build(BuildContext context) {
    return AntNavBar(
      back: true,
      left: const Text('首页'),
      onBack: () => _showSnackbar(context, '点击了返回箭头'),
      child: const Text('左侧附加'),
    );
  }
}

class _RightDemo extends StatelessWidget {
  const _RightDemo();

  @override
  Widget build(BuildContext context) {
    return AntNavBar(
      right: AntButton(
        type: AntButtonType.text,
        shape: AntButtonShape.circle,
        icon: const Icon(AntIcons.moreOutlined),
        onTap: () => _showSnackbar(context, '点击了更多'),
      ),
      child: const Text('右侧操作'),
    );
  }
}

class _NoBorderDemo extends StatelessWidget {
  const _NoBorderDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const AntNavBar(border: false, child: Text('无边框')),
    );
  }
}

class _FullDemo extends StatelessWidget {
  const _FullDemo();

  @override
  Widget build(BuildContext context) {
    return AntNavBar(
      back: true,
      onBack: () => _showSnackbar(context, '返回'),
      right: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AntButton(
            type: AntButtonType.text,
            shape: AntButtonShape.circle,
            icon: const Icon(AntIcons.searchOutlined),
            onTap: () => _showSnackbar(context, '搜索'),
          ),
          AntButton(
            type: AntButtonType.text,
            shape: AntButtonShape.circle,
            icon: const Icon(AntIcons.moreOutlined),
            onTap: () => _showSnackbar(context, '更多'),
          ),
        ],
      ),
      child: const Text('完整示例'),
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
class _AppBarDemo extends StatelessWidget {
  const _AppBarDemo();

  @override
  Widget build(BuildContext context) {
    return AntAppBar(
      title: const Text('AppBar 标题'),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _showSnackbar(context, '点击了左侧菜单'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSnackbar(context, '点击了搜索'),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () => _showSnackbar(context, '点击了更多'),
        ),
      ],
    );
  }
}
