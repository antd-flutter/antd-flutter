import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _CardAction {
  const _CardAction(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;
}

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntCard<Widget>(
              title: const Text('卡片标题'),
              child: Text(
                '卡片内容卡片内容卡片内容卡片内容卡片内容卡片内容',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '无边框',
            theme: theme,
            child: AntCard<Widget>(
              bordered: false,
              title: const Text('卡片标题'),
              child: Text(
                '无边框卡片内容无边框卡片内容无边框卡片内容',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '更多操作',
            theme: theme,
            child: AntCard<Widget>(
              title: const Text('卡片标题'),
              extra: const Text('更多'),
              child: Text(
                '右上角有更多操作链接',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '封面和操作',
            theme: theme,
            child: AntCard<_CardAction>(
              cover: Container(
                color: theme.colorPrimary.withValues(alpha: 0.2),
                child: Icon(
                  AntIcons.pictureOutlined,
                  size: theme.s(48),
                  color: theme.colorPrimary,
                ),
              ),
              coverHeight: theme.s(120),
              title: const Text('带封面的卡片'),
              actions: [
                _CardAction('操作一', () => _showMsg(context, '操作一')),
                _CardAction('操作二', () => _showMsg(context, '操作二')),
              ],
              actionBuilder: (context, action, index) => Text(action.label),
              onActionTap: (action) => action.onTap(),
              child: Text(
                '卡片内容卡片内容',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '小尺寸',
            theme: theme,
            child: AntCard<Widget>(
              size: AntCardSize.small,
              title: const Text('小卡片'),
              child: Text(
                '小尺寸卡片内容',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '加载中',
            theme: theme,
            child: AntCard<Widget>(
              title: const Text('加载中卡片'),
              loading: true,
              child: const Text('实际内容'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '可悬浮',
            theme: theme,
            child: AntCard<Widget>(
              hoverable: true,
              title: const Text('悬浮卡片'),
              child: Text(
                '鼠标悬浮时阴影加深（桌面端效果）',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
