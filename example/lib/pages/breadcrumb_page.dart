library;

/// Breadcrumb 面包屑演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _BreadcrumbData {
  const _BreadcrumbData({required this.title, this.icon, this.onClick});

  final String title;
  final Widget? icon;
  final VoidCallback? onClick;
}

Widget _breadcrumb({
  Key? key,
  List<_BreadcrumbData> items = const [],
  String separator = '/',
  Widget? separatorWidget,
  ValueChanged<_BreadcrumbData>? onTap,
}) {
  return AntBreadcrumb<_BreadcrumbData>(
    key: key,
    items: items,
    titleBuilder: (context, item, index) => Text(item.title),
    iconBuilder: (context, item) => item.icon,
    clickableOf: (item) => item.onClick != null,
    onTap: onTap ?? (item) => item.onClick?.call(),
    separator: separator,
    separatorWidget: separatorWidget,
  );
}

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
          _Section(
            title: '图标分隔符',
            description: 'separatorWidget 指定 Widget 分隔符',
          ),
          _IconSeparatorDemo(),
          _Section(title: '带图标', description: '每项可设置 icon'),
          _IconDemo(),
          _Section(title: '联动导航', description: '常见用法：面包屑由当前页面栈生成，点击上级项回退到对应页面'),
          _LinkedDemo(),
          _Section(title: '可点击', description: '设置 onClick 的项可点击跳转，hover 变主色'),
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
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: TextStyle(fontSize: 12, color: theme.colorTextTertiary),
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
    return _breadcrumb(
      items: [
        _BreadcrumbData(title: '首页'),
        _BreadcrumbData(title: '组件'),
        _BreadcrumbData(title: '导航'),
        _BreadcrumbData(title: '面包屑'),
      ],
    );
  }
}

class _CustomSeparatorDemo extends StatelessWidget {
  const _CustomSeparatorDemo();

  @override
  Widget build(BuildContext context) {
    return _breadcrumb(
      separator: '>',
      items: [
        _BreadcrumbData(title: '首页'),
        _BreadcrumbData(title: '应用中心'),
        _BreadcrumbData(title: '应用列表'),
      ],
    );
  }
}

class _IconSeparatorDemo extends StatelessWidget {
  const _IconSeparatorDemo();

  @override
  Widget build(BuildContext context) {
    return _breadcrumb(
      separatorWidget: const Icon(AntIcons.rightOutlined, size: 10),
      items: const [
        _BreadcrumbData(title: '首页'),
        _BreadcrumbData(title: '设置'),
        _BreadcrumbData(title: '个人资料'),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  @override
  Widget build(BuildContext context) {
    return _breadcrumb(
      items: [
        _BreadcrumbData(
          title: '首页',
          icon: Icon(AntIcons.homeOutlined, size: 14),
        ),
        _BreadcrumbData(
          title: '用户',
          icon: Icon(AntIcons.userOutlined, size: 14),
        ),
        _BreadcrumbData(
          title: '详情',
          icon: Icon(AntIcons.fileOutlined, size: 14),
        ),
      ],
    );
  }
}

class _LinkedDemo extends StatefulWidget {
  const _LinkedDemo();

  @override
  State<_LinkedDemo> createState() => _LinkedDemoState();
}

class _LinkedDemoState extends State<_LinkedDemo> {
  static const _pages = [
    ('首页', '欢迎页：展示概览数据与快捷入口。'),
    ('商品管理', '列表页：管理商品上下架、价格与库存。'),
    ('商品详情', '详情页：编辑单个商品的名称、规格与描述。'),
  ];

  int _level = 2;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _breadcrumb(
          items: [
            for (var i = 0; i <= _level; i++)
              _BreadcrumbData(
                title: _pages[i].$1,
                onClick: i < _level ? () => setState(() => _level = i) : null,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorFillAlter,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _pages[_level].$1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _pages[_level].$2,
                style: TextStyle(fontSize: 13, color: theme.colorTextSecondary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  if (_level > 0)
                    AntButton(
                      size: AntButtonSize.small,
                      onTap: () => setState(() => _level -= 1),
                      child: const Text('返回上一级'),
                    ),
                  if (_level < _pages.length - 1)
                    AntButton(
                      type: AntButtonType.primary,
                      size: AntButtonSize.small,
                      onTap: () => setState(() => _level += 1),
                      child: const Text('进入下一级'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClickableDemo extends StatelessWidget {
  const _ClickableDemo();

  @override
  Widget build(BuildContext context) {
    return _breadcrumb(
      items: [
        _BreadcrumbData(
          title: '首页',
          onClick: () => _showToast(context, '点击了首页'),
        ),
        _BreadcrumbData(
          title: '列表',
          onClick: () => _showToast(context, '点击了列表'),
        ),
        const _BreadcrumbData(title: '详情页'),
      ],
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }
}
