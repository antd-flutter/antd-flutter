import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntApp 全局上下文演示页
class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('App 全局上下文')),
      body: AntApp(
        message: const AntAppMessageConfig(closable: false),
        modal: const AntAppModalConfig(okText: '确定', cancelText: '取消'),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: '基础包裹',
                theme: theme,
                child: const Text(
                  'AntApp 包裹根部后，任意位置可通过 '
                  'AntApp.of(context) 获取全局 API，'
                  '无需依赖页面 context 弹出反馈。',
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '经 App 调用 message',
                theme: theme,
                child: Builder(
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AntButton(
                          child: const Text('普通提示'),
                          onTap: () =>
                              AntApp.of(context)
                                  .messageShow(const Text('这是一条普通提示')),
                        ),
                        SizedBox(height: 8.w),
                        AntButton(
                          child: const Text('成功提示'),
                          onTap: () => AntApp.of(context).messageShow(
                            const Text('操作成功'),
                            type: AntAppMessageType.success,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '经 App 调用 notification',
                theme: theme,
                child: Builder(
                  builder: (context) {
                    return AntButton(
                      child: const Text('弹出通知'),
                      onTap: () => AntApp.of(context).notificationShow(
                        '这是一条来自 AntApp 的通知',
                        title: '通知提醒',
                        type: AntAppMessageType.info,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '经 App 弹 modal',
                theme: theme,
                child: Builder(
                  builder: (context) {
                    return AntButton(
                      child: const Text('弹出确认框'),
                      onTap: () async {
                        final app = AntApp.of(context);
                        final ok = await app.modal(
                          title: '删除确认',
                          content: const Text('确定要删除这条记录吗？'),
                        );
                        if (ok == true) {
                          app.messageShow(
                            const Text('已删除'),
                            type: AntAppMessageType.success,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '说明',
                theme: theme,
                child: const Text(
                  '使用方式：创建 GlobalKey<NavigatorState>，'
                  '同时传给 AntApp 与 MaterialApp；'
                  '之后 message / notification / modal 均可'
                  '通过 AntApp.of(context) 调用。',
                ),
              ),
            ],
          ),
        ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Column(
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
      ),
    );
  }
}
