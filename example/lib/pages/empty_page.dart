import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

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
            child: const AntEmpty(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义描述',
            theme: theme,
            child: const AntEmpty(description: '没有找到相关结果'),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '简单样式',
            theme: theme,
            child: const AntEmpty(
              description: '简单空状态',
              image: AntEmptyImage.simple,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义图片',
            theme: theme,
            child: AntEmpty(
              description: '自定义图标',
              imageWidget: AntdIcon(
                AntIcons.searchOutlined,
                size: 64.w,
                color: theme.colorTextQuaternary,
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无描述',
            theme: theme,
            child: const AntEmpty(description: null),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带操作按钮',
            theme: theme,
            child: AntEmpty(
              description: '暂无数据，点击刷新',
              child: AntButton(
                type: AntButtonType.primary,
                size: AntButtonSize.small,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: AntText(text: '刷新中...')),
                  );
                },
                child: const AntText(text: '刷新'),
              ),
            ),
          ),
        ],
      ),
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
          AntText(text: 
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          Center(child: child),
        ],
      ),
    );
  }
}