import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ErrorBlockPage extends StatelessWidget {
  const ErrorBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Default 默认',
            theme: theme,
            child: const AntErrorBlock(
              status: AntErrorBlockStatus.defaultStatus,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Empty 暂无数据',
            theme: theme,
            child: const AntErrorBlock(status: AntErrorBlockStatus.empty),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Disconnected 断网',
            theme: theme,
            child: const AntErrorBlock(
              status: AntErrorBlockStatus.disconnected,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Busy 系统繁忙',
            theme: theme,
            child: const AntErrorBlock(status: AntErrorBlockStatus.busy),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义 children 操作区',
            theme: theme,
            child: AntErrorBlock(
              status: AntErrorBlockStatus.disconnected,
              title: '网络不给力',
              description: '请检查网络设置后重试',
              children: Wrap(
                spacing: 8.w,
                children: [
                  AntButton(
                    child: const AntText(text: '点击刷新'),
                    onTap: () {},
                  ),
                  AntButton(
                    type: AntButtonType.primary,
                    child: const AntText(text: '检查网络设置'),
                    onTap: () {},
                  ),
                ],
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
