import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntCard(
              title: const Text('卡片标题'),
              child: Text(
                '卡片内容卡片内容卡片内容卡片内容卡片内容卡片内容',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无边框',
            theme: theme,
            child: AntCard(
              bordered: false,
              title: const Text('卡片标题'),
              child: Text(
                '无边框卡片内容无边框卡片内容无边框卡片内容',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '更多操作',
            theme: theme,
            child: AntCard(
              title: const Text('卡片标题'),
              extra: const Text('更多'),
              child: Text(
                '右上角有更多操作链接',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '封面和操作',
            theme: theme,
            child: AntCard(
              cover: AntCardCover(
                height: 120.w,
                child: Container(
                  color: theme.colorPrimary.withValues(alpha: 0.2),
                  child: Icon(Icons.image, size: 48.w, color: theme.colorPrimary),
                ),
              ),
              title: const Text('带封面的卡片'),
              actions: [
                AntCardAction(
                  child: const Text('操作一'),
                  onTap: () => _showMsg(context, '操作一'),
                ),
                AntCardAction(
                  child: const Text('操作二'),
                  onTap: () => _showMsg(context, '操作二'),
                ),
              ],
              child: Text(
                '卡片内容卡片内容',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '小尺寸',
            theme: theme,
            child: AntCard(
              size: AntCardSize.small,
              title: const Text('小卡片'),
              child: Text(
                '小尺寸卡片内容',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '加载中',
            theme: theme,
            child: AntCard(
              title: const Text('加载中卡片'),
              loading: true,
              child: const Text('实际内容'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可悬浮',
            theme: theme,
            child: AntCard(
              hoverable: true,
              title: const Text('悬浮卡片'),
              child: Text(
                '鼠标悬浮时阴影加深（桌面端效果）',
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}