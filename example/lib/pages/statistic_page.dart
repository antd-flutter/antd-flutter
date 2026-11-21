import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

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
                const AntStatistic(title: '活跃用户', value: 112893),
                SizedBox(width: theme.s(48)),
                const AntStatistic(title: '商品总量', value: 9280),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '千分位与小数',
            theme: theme,
            child: Row(
              children: [
                const AntStatistic(title: '营收', value: 11289300),
                SizedBox(width: theme.s(48)),
                const AntStatistic(title: '转化率', value: 3.14159, precision: 2),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '前缀和后缀',
            theme: theme,
            child: Row(
              children: [
                const AntStatistic(
                  title: '金额',
                  value: 112893,
                  prefix: Text('¥'),
                ),
                SizedBox(width: theme.s(48)),
                const AntStatistic(title: '距离', value: 88, suffix: Text('km')),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '倒计时',
            theme: theme,
            child: Row(
              children: [
                const AntStatisticCountdown(
                  title: '倒计时',
                  value: Duration(hours: 1, minutes: 30, seconds: 45),
                ),
                SizedBox(width: theme.s(48)),
                const AntStatisticCountdown(
                  title: '天数倒计时',
                  value: Duration(days: 2, hours: 3, minutes: 4, seconds: 5),
                  format: 'DD天HH:mm:ss',
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义样式',
            theme: theme,
            child: Row(
              children: [
                AntStatistic(
                  title: '增长',
                  value: 112893,
                  valueStyle: TextStyle(
                    fontSize: theme.s(24),
                    fontWeight: FontWeight.w600,
                    color: theme.colorSuccess,
                  ),
                ),
                SizedBox(width: theme.s(48)),
                AntStatistic(
                  title: '下降',
                  value: -893,
                  valueStyle: TextStyle(
                    fontSize: theme.s(24),
                    fontWeight: FontWeight.w600,
                    color: theme.colorError,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '加载中',
            theme: theme,
            child: Row(
              children: [
                const AntStatistic(title: '加载中', value: 112893, loading: true),
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
