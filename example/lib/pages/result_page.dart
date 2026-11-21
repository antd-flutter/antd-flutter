import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Success 成功',
            theme: theme,
            child: const AntResult(
              status: AntResultStatus.success,
              title: '操作成功',
              subTitle: '申请提交成功，预计 1-3 个工作日内完成审核',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'Error 错误',
            theme: theme,
            child: const AntResult(
              status: AntResultStatus.error,
              title: '提交失败',
              subTitle: '请检查网络后重试',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'Warning 警告',
            theme: theme,
            child: const AntResult(
              status: AntResultStatus.warning,
              title: '操作存在风险',
              subTitle: '当前操作可能影响线上数据，请谨慎操作',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'Info 信息',
            theme: theme,
            child: const AntResult(
              status: AntResultStatus.info,
              title: '你的账户即将到期',
              subTitle: '到期后部分功能将不可用',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '404 页面不存在',
            theme: theme,
            child: const AntResult(
              status: AntResultStatus.notFound,
              title: '404',
              subTitle: '抱歉，您访问的页面不存在',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义 extra 操作区',
            theme: theme,
            child: AntResult(
              status: AntResultStatus.error,
              title: '无权访问',
              subTitle: '请联系管理员开通权限',
              extra: Wrap(
                spacing: theme.s(8),
                children: [
                  AntButton(child: const Text('返回首页'), onTap: () {}),
                  AntButton(
                    type: AntButtonType.primary,
                    child: const Text('重新登录'),
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
          Center(child: child),
        ],
      ),
    );
  }
}
