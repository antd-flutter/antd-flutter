import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

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
            child: Row(
              children: [
                AntBadge(
                  count: 5,
                  child: AntButton(child: const Text('消息')),
                ),
                SizedBox(width: 32.w),
                AntBadge(
                  dot: true,
                  child: Icon(Icons.notifications, size: 24.w, color: theme.colorText),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '独立使用',
            theme: theme,
            child: Wrap(
              spacing: 16.w,
              runSpacing: 16.w,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AntBadge(count: 10),
                AntBadge(count: 0, showZero: true),
                AntBadge(count: 100),
                AntBadge(dot: true),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '溢出',
            theme: theme,
            child: Row(
              children: [
                AntBadge(count: 99),
                SizedBox(width: 16.w),
                AntBadge(count: 100),
                SizedBox(width: 16.w),
                AntBadge(count: 200, overflowCount: 199),
                SizedBox(width: 16.w),
                AntBadge(count: 1000, overflowCount: 999),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '状态点',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntBadge(status: AntBadgeStatus.success, text: '成功'),
                SizedBox(height: 8.w),
                AntBadge(status: AntBadgeStatus.processing, text: '处理中'),
                SizedBox(height: 8.w),
                AntBadge(status: AntBadgeStatus.standard, text: '默认'),
                SizedBox(height: 8.w),
                AntBadge(status: AntBadgeStatus.error, text: '错误'),
                SizedBox(height: 8.w),
                AntBadge(status: AntBadgeStatus.warning, text: '警告'),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义颜色',
            theme: theme,
            child: Row(
              children: [
                AntBadge(count: 5, color: Colors.blue, child: const Text('蓝色')),
                SizedBox(width: 32.w),
                AntBadge(count: 5, color: Colors.green, child: const Text('绿色')),
                SizedBox(width: 32.w),
                AntBadge(dot: true, color: Colors.purple, child: const Text('紫色')),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '偏移',
            theme: theme,
            child: Row(
              children: [
                AntBadge(
                  count: 5,
                  offset: [10, -5],
                  child: Icon(Icons.notifications, size: 24.w, color: theme.colorText),
                ),
                SizedBox(width: 32.w),
                AntBadge(
                  count: 5,
                  offset: [-10, 10],
                  child: Icon(Icons.email, size: 24.w, color: theme.colorText),
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
          child,
        ],
      ),
    );
  }
}