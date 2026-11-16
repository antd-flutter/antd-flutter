import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class DescriptionsPage extends StatelessWidget {
  const DescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final items = const [
      AntDescriptionsItem(label: '名称', child: Text('张三')),
      AntDescriptionsItem(label: '手机号', child: Text('138****8888')),
      AntDescriptionsItem(label: '城市', child: Text('杭州')),
      AntDescriptionsItem(label: '邮箱', child: Text('zhangsan@example.com')),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntDescriptions(items: items),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带边框',
            theme: theme,
            child: AntDescriptions(items: items, bordered: true),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Column(
              children: [
                AntDescriptions(
                  items: [
                    AntDescriptionsItem(label: '大号', child: Text('large')),
                  ],
                  size: AntDescriptionsSize.large,
                  bordered: true,
                ),
                SizedBox(height: 12.w),
                AntDescriptions(
                  items: [
                    AntDescriptionsItem(label: '中号', child: Text('middle')),
                  ],
                  size: AntDescriptionsSize.middle,
                  bordered: true,
                ),
                SizedBox(height: 12.w),
                AntDescriptions(
                  items: [
                    AntDescriptionsItem(label: '小号', child: Text('small')),
                  ],
                  size: AntDescriptionsSize.small,
                  bordered: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '跨列 span',
            theme: theme,
            child: AntDescriptions(
              column: 3,
              bordered: true,
              items: [
                AntDescriptionsItem(label: '产品', child: Text('云服务器')),
                AntDescriptionsItem(label: '计费模式', child: Text('预付费')),
                AntDescriptionsItem(label: '自动续费', child: Text('是')),
                AntDescriptionsItem(
                  label: '配置',
                  child: Text('CPU 4 核 / 内存 8G / 磁盘 100G SSD / 带宽 5Mbps'),
                  span: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '垂直布局',
            theme: theme,
            child: AntDescriptions(
              items: items,
              layout: AntDescriptionsLayout.vertical,
              bordered: true,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '标题 + 操作区',
            theme: theme,
            child: AntDescriptions(
              items: [
                AntDescriptionsItem(label: '订单号', child: Text('202405160001')),
                AntDescriptionsItem(label: '状态', child: Text('已支付')),
                AntDescriptionsItem(label: '金额', child: Text('¥299.00')),
                AntDescriptionsItem(label: '支付方式', child: Text('支付宝')),
              ],
              title: Text('订单详情'),
              extra: Text('编辑'),
              bordered: true,
              colon: false,
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
          child,
        ],
      ),
    );
  }
}
