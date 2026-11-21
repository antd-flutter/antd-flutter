import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

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
            child: Row(
              children: [
                AntBadge(count: 5, child: AntButton(child: const Text('消息'))),
                SizedBox(width: theme.s(32)),
                AntBadge(
                  dot: true,
                  child: Icon(
                    AntIcons.notificationOutlined,
                    size: theme.s(24),
                    color: theme.colorText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '独立使用',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AntBadge(count: 10),
                AntBadge(count: 0, showZero: true),
                AntBadge(count: 100),
                AntBadge(dot: true),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '溢出',
            theme: theme,
            child: Row(
              children: [
                AntBadge(count: 99),
                SizedBox(width: theme.s(16)),
                AntBadge(count: 100),
                SizedBox(width: theme.s(16)),
                AntBadge(count: 200, overflowCount: 199),
                SizedBox(width: theme.s(16)),
                AntBadge(count: 1000, overflowCount: 999),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '状态点',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntBadge(status: AntBadgeStatus.success, text: '成功'),
                SizedBox(height: theme.s(8)),
                AntBadge(status: AntBadgeStatus.processing, text: '处理中'),
                SizedBox(height: theme.s(8)),
                AntBadge(status: AntBadgeStatus.standard, text: '默认'),
                SizedBox(height: theme.s(8)),
                AntBadge(status: AntBadgeStatus.error, text: '错误'),
                SizedBox(height: theme.s(8)),
                AntBadge(status: AntBadgeStatus.warning, text: '警告'),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义颜色',
            theme: theme,
            child: Row(
              children: [
                AntBadge(count: 5, color: Colors.blue, child: const Text('蓝色')),
                SizedBox(width: theme.s(32)),
                AntBadge(
                  count: 5,
                  color: Colors.green,
                  child: const Text('绿色'),
                ),
                SizedBox(width: theme.s(32)),
                AntBadge(
                  dot: true,
                  color: Colors.purple,
                  child: const Text('紫色'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '偏移',
            theme: theme,
            child: Row(
              children: [
                AntBadge(
                  count: 5,
                  offset: [10, -5],
                  child: Icon(
                    AntIcons.notificationOutlined,
                    size: theme.s(24),
                    color: theme.colorText,
                  ),
                ),
                SizedBox(width: theme.s(32)),
                AntBadge(
                  count: 5,
                  offset: [-10, 10],
                  child: Icon(
                    AntIcons.mailOutlined,
                    size: theme.s(24),
                    color: theme.colorText,
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
