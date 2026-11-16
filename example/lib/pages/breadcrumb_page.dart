library;

/// Breadcrumb 面包屑演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class BreadcrumbPage extends StatelessWidget {
  const BreadcrumbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认分隔符为 "/"，最后一项为当前页面'),
          _BasicDemo(),
          _Section(title: '自定义分隔符', description: 'separator 指定文字分隔符'),
          _CustomSeparatorDemo(),
          _Section(title: '图标分隔符', description: 'separatorWidget 指定 Widget 分隔符'),
          _IconSeparatorDemo(),
          _Section(title: '带图标', description: '每项可设置 icon'),
          _IconDemo(),
          _Section(title: '可点击', description: '设置 onClick 的项可点击跳转'),
          _ClickableDemo(),
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
    return const AntBreadcrumb(items: [
      AntBreadcrumbItem(title: '首页'),
      AntBreadcrumbItem(title: '组件'),
      AntBreadcrumbItem(title: '导航'),
      AntBreadcrumbItem(title: '面包屑'),
    ]);
  }
}

class _CustomSeparatorDemo extends StatelessWidget {
  const _CustomSeparatorDemo();

  @override
  Widget build(BuildContext context) {
    return const AntBreadcrumb(
      separator: '>',
      items: [
        AntBreadcrumbItem(title: '首页'),
        AntBreadcrumbItem(title: '应用中心'),
        AntBreadcrumbItem(title: '应用列表'),
      ],
    );
  }
}

class _IconSeparatorDemo extends StatelessWidget {
  const _IconSeparatorDemo();

  @override
  Widget build(BuildContext context) {
    return AntBreadcrumb(
      separatorWidget: const Icon(Icons.arrow_forward_ios, size: 10),
      items: const [
        AntBreadcrumbItem(title: '首页'),
        AntBreadcrumbItem(title: '设置'),
        AntBreadcrumbItem(title: '个人资料'),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  @override
  Widget build(BuildContext context) {
    return const AntBreadcrumb(items: [
      AntBreadcrumbItem(
        title: '首页',
        icon: Icon(Icons.home_outlined, size: 14),
      ),
      AntBreadcrumbItem(
        title: '用户',
        icon: Icon(Icons.person_outline, size: 14),
      ),
      AntBreadcrumbItem(
        title: '详情',
        icon: Icon(Icons.description_outlined, size: 14),
      ),
    ]);
  }
}

class _ClickableDemo extends StatelessWidget {
  const _ClickableDemo();

  @override
  Widget build(BuildContext context) {
    return AntBreadcrumb(items: [
      AntBreadcrumbItem(
        title: '首页',
        onClick: () => _showToast(context, '点击了首页'),
      ),
      AntBreadcrumbItem(
        title: '列表',
        onClick: () => _showToast(context, '点击了列表'),
      ),
      const AntBreadcrumbItem(title: '详情页'),
    ]);
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }
}