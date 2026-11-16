import 'package:antd_flutter_plus/antd_flutter_plus.dart';
// 注：组件 export 行追加到 antd_flutter_plus.dart 后可改回 barrel 导入
import 'package:material_ui/material_ui.dart';

class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法（默认文案）',
            theme: theme,
            child: const AntFooter(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义文案',
            theme: theme,
            child: const AntFooter(content: '自定义底部文案'),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '点击回调（返回顶部）',
            theme: theme,
            child: AntFooter(
              onClick: () => _showMsg(context, '点击返回顶部'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义内容',
            theme: theme,
            child: AntFooter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vertical_align_top, size: 14.w),
                  SizedBox(width: 4.w),
                  Text(
                    '回到顶部',
                    style: TextStyle(
                      fontSize: theme.fontSizeSM,
                      color: theme.colorTextQuaternary,
                    ),
                  ),
                ],
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
