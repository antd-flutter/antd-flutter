import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '四种类型',
            theme: theme,
            child: Column(
              children: [
                const AntAlert(message: '成功提示', type: AntAlertType.success),
                SizedBox(height: 8.w),
                const AntAlert(message: '信息提示', type: AntAlertType.info),
                SizedBox(height: 8.w),
                const AntAlert(message: '警告提示', type: AntAlertType.warning),
                SizedBox(height: 8.w),
                const AntAlert(message: '错误提示', type: AntAlertType.error),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可关闭的警告提示',
            theme: theme,
            child: Column(
              children: [
                AntAlert(
                  message: '可关闭的提示',
                  type: AntAlertType.info,
                  closable: true,
                  onClose: () => _showMsg(context, '提示已关闭'),
                ),
                SizedBox(height: 8.w),
                AntAlert(
                  message: '带描述的可关闭提示',
                  type: AntAlertType.warning,
                  closable: true,
                  description: '关闭后会触发 onClose 回调',
                  onClose: () => _showMsg(context, '警告已关闭'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '图标与描述',
            theme: theme,
            child: Column(
              children: [
                AntAlert(
                  message: '成功提示',
                  type: AntAlertType.success,
                  showIcon: true,
                  description: '带图标的成功提示，包含详细描述信息。',
                ),
                SizedBox(height: 8.w),
                AntAlert(
                  message: '错误提示',
                  type: AntAlertType.error,
                  showIcon: true,
                  description: '带图标的错误提示，包含详细描述信息。',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义图标',
            theme: theme,
            child: Column(
              children: [
                AntAlert(
                  message: '自定义图标提示',
                  type: AntAlertType.info,
                  showIcon: true,
                  icon: Icon(AntIcons.bulbOutlined),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '操作区',
            theme: theme,
            child: Column(
              children: [
                AntAlert(
                  message: '需要你进行确认的操作',
                  type: AntAlertType.info,
                  showIcon: true,
                  action: AntButton(
                    type: AntButtonType.link,
                    size: AntButtonSize.small,
                    onTap: () => _showMsg(context, '已接受'),
                    child: const Text('接受'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '顶部公告 banner',
            theme: theme,
            child: Column(
              children: [
                AntAlert(
                  message: '系统将于今晚 22:00 进行维护',
                  type: AntAlertType.warning,
                  banner: true,
                ),
                SizedBox(height: 8.w),
                AntAlert(
                  message: '欢迎使用新版组件库',
                  type: AntAlertType.info,
                  banner: true,
                ),
              ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: theme.fontSizeLG,
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        SizedBox(height: 8.w),
        child,
      ],
    );
  }
}
