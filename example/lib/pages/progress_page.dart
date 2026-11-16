import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '线形基础',
            theme: theme,
            child: Column(
              children: const [
                AntProgress(percent: 30),
                SizedBox(height: 12),
                AntProgress(percent: 60),
                SizedBox(height: 12),
                AntProgress(percent: 90),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '状态色',
            theme: theme,
            child: Column(
              children: const [
                AntProgress(percent: 70, status: AntProgressStatus.active),
                SizedBox(height: 12),
                AntProgress(percent: 100, status: AntProgressStatus.success),
                SizedBox(height: 12),
                AntProgress(percent: 45, status: AntProgressStatus.exception),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义颜色与粗细',
            theme: theme,
            child: Column(
              children: const [
                AntProgress(percent: 60, strokeColor: Colors.purple, size: 12),
                SizedBox(height: 12),
                AntProgress(percent: 40, strokeColor: Colors.teal, size: 16),
                SizedBox(height: 12),
                AntProgress(percent: 80, strokeColor: Colors.orange, size: 6),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '不显示百分比文字',
            theme: theme,
            child: Column(
              children: const [
                AntProgress(percent: 55, showInfo: false),
                SizedBox(height: 12),
                AntProgress(percent: 25, showInfo: false, size: 4),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '圆形基础',
            theme: theme,
            child: Wrap(
              spacing: 24.w,
              runSpacing: 12.w,
              children: const [
                AntProgress(percent: 30, type: AntProgressType.circle),
                AntProgress(percent: 70, type: AntProgressType.circle),
                AntProgress(
                  percent: 100,
                  type: AntProgressType.circle,
                  status: AntProgressStatus.success,
                ),
                AntProgress(
                  percent: 50,
                  type: AntProgressType.circle,
                  status: AntProgressStatus.exception,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '圆形自定义',
            theme: theme,
            child: Wrap(
              spacing: 24.w,
              runSpacing: 12.w,
              children: [
                AntProgress(
                  percent: 75,
                  type: AntProgressType.circle,
                  strokeColor: Colors.purple,
                  strokeWidth: 10,
                ),
                AntProgress(
                  percent: 45,
                  type: AntProgressType.circle,
                  format: (p) => '剩余${100 - p.round()}%',
                ),
                AntProgress(
                  percent: 85,
                  type: AntProgressType.circle,
                  strokeLinecap: StrokeCap.butt,
                  strokeColor: Colors.teal,
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
