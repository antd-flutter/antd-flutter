library;

/// AntNotification 演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  void _show(
    BuildContext context, {
    String title = '通知标题',
    String description = '这是一条通知内容',
    AntNotificationType type = AntNotificationType.info,
    Duration duration = const Duration(milliseconds: 4500),
    AntNotificationPlacement placement = AntNotificationPlacement.topRight,
    double? width,
    bool closable = true,
  }) {
    AntNotification.show(
      context,
      title: title,
      description: description,
      type: type,
      duration: duration,
      placement: placement,
      width: width,
      closable: closable,
    );
  }

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
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '信息通知',
                    description: '这是一条信息通知',
                    type: AntNotificationType.info,
                  ),
                  child: const Text('Info'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '成功通知',
                    description: '操作已成功完成',
                    type: AntNotificationType.success,
                  ),
                  child: const Text('Success'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '警告通知',
                    description: '请注意潜在风险',
                    type: AntNotificationType.warning,
                  ),
                  child: const Text('Warning'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '错误通知',
                    description: '操作失败，请重试',
                    type: AntNotificationType.error,
                  ),
                  child: const Text('Error'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义时长',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '3 秒后关闭',
                    description: 'duration: 3s',
                    duration: const Duration(seconds: 3),
                  ),
                  child: const Text('3 秒'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '10 秒后关闭',
                    description: 'duration: 10s',
                    duration: const Duration(seconds: 10),
                  ),
                  child: const Text('10 秒'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '不自动关闭',
                    description: 'duration: 0，需手动关闭',
                    duration: Duration.zero,
                  ),
                  child: const Text('不自动关闭'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '四个位置',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '右上角',
                    placement: AntNotificationPlacement.topRight,
                  ),
                  child: const Text('Top Right'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '左上角',
                    placement: AntNotificationPlacement.topLeft,
                  ),
                  child: const Text('Top Left'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '右下角',
                    placement: AntNotificationPlacement.bottomRight,
                  ),
                  child: const Text('Bottom Right'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '左下角',
                    placement: AntNotificationPlacement.bottomLeft,
                  ),
                  child: const Text('Bottom Left'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '多条堆叠',
            theme: theme,
            child: AntButton(
              onTap: () {
                _show(
                  context,
                  title: '通知 1',
                  description: '第一条通知',
                );
                _show(
                  context,
                  title: '通知 2',
                  description: '第二条通知',
                  type: AntNotificationType.success,
                );
                _show(
                  context,
                  title: '通知 3',
                  description: '第三条通知',
                  type: AntNotificationType.warning,
                );
              },
              child: const Text('弹三条'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可关闭',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '带关闭按钮',
                    description: '点击右上角 × 关闭',
                    closable: true,
                  ),
                  child: const Text('带关闭按钮'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '无关闭按钮',
                    description: 'closable: false',
                    closable: false,
                  ),
                  child: const Text('无关闭按钮'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义宽度',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '窄通知',
                    description: 'width: 260',
                    width: 260,
                  ),
                  child: const Text('260'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    title: '宽通知',
                    description: 'width: 480',
                    width: 480,
                  ),
                  child: const Text('480'),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorTextHeading,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
