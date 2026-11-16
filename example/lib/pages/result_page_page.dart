import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ResultPagePage extends StatelessWidget {
  const ResultPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Success 成功',
            theme: theme,
            child: const AntResultPage(
              status: AntResultPageStatus.success,
              title: '操作成功',
              subTitle: '订单已提交，等待商家发货',
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Error 错误',
            theme: theme,
            child: const AntResultPage(
              status: AntResultPageStatus.error,
              title: '提交失败',
              subTitle: '服务器开小差了，请稍后重试',
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Warning 警告',
            theme: theme,
            child: const AntResultPage(
              status: AntResultPageStatus.warning,
              title: '操作存在风险',
              subTitle: '当前操作可能影响线上数据，请谨慎操作',
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Info 信息',
            theme: theme,
            child: const AntResultPage(
              status: AntResultPageStatus.info,
              title: '你的账户即将到期',
              subTitle: '到期后部分功能将不可用',
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Waiting 等待',
            theme: theme,
            child: const AntResultPage(
              status: AntResultPageStatus.waiting,
              title: '审核中',
              subTitle: '预计 1-3 个工作日内完成审核',
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带 description 明细与按钮',
            theme: theme,
            child: AntResultPage(
              status: AntResultPageStatus.success,
              title: '支付成功',
              subTitle: '订单支付已完成',
              description: const [
                Text('订单号：20240101'),
                Text('支付方式：支付宝'),
                Text('支付金额：￥199.00'),
              ],
              buttons: [
                AntButton(
                  child: const Text('查看订单'),
                  onTap: () {},
                ),
                AntButton(
                  type: AntButtonType.primary,
                  child: const Text('继续购物'),
                  onTap: () {},
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
          Center(child: child),
        ],
      ),
    );
  }
}
