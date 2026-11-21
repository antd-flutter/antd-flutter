import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

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
            child: const Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                AntLoading(),
                AntLoading(child: Text('加载中...')),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '尺寸',
            theme: theme,
            child: const Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AntLoading(size: 14),
                AntLoading(size: 18),
                AntLoading(size: 24),
                AntLoading(size: 32),
              ],
            ),
          ),
          _Section(
            title: '颜色',
            theme: theme,
            child: Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AntLoading(color: theme.colorPrimary),
                AntLoading(color: theme.colorSuccess),
                AntLoading(color: theme.colorWarning),
                AntLoading(color: theme.colorError),
                const AntLoading(color: Colors.purple),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '组合内容',
            theme: theme,
            child: Wrap(
              spacing: 32,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AntLoading(
                  size: 20,
                  child: Text(
                    '正在保存...',
                    style: TextStyle(
                      fontSize: theme.fontSize,
                      color: theme.colorText,
                    ),
                  ),
                ),
                AntLoading(
                  size: 20,
                  direction: AntLoadingDirection.column,
                  child: Text(
                    '上传中',
                    style: TextStyle(
                      fontSize: theme.fontSizeSM,
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ),
                AntLoading(
                  size: 24,
                  speed: AntLoadingSpeed.slow,
                  color: theme.colorSuccess,
                  child: Text(
                    '慢速旋转',
                    style: TextStyle(
                      fontSize: theme.fontSizeSM,
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ),
                AntLoading(
                  size: 20,
                  speed: AntLoadingSpeed.fast,
                  child: Text(
                    '快速旋转',
                    style: TextStyle(
                      fontSize: theme.fontSizeSM,
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
