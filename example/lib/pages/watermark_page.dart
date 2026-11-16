/// AntWatermark 演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class WatermarkPage extends StatelessWidget {
  const WatermarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础文字水印',
            theme: theme,
            child: AntWatermark(
              content: 'Ant Design',
              child: _DemoContent(theme: theme, height: 200),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '多行水印',
            theme: theme,
            child: AntWatermark(
              content: ['Ant Design', '水印组件'],
              child: _DemoContent(theme: theme, height: 200),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义字号 / 颜色 / 角度',
            theme: theme,
            child: AntWatermark(
              content: '自定义水印',
              fontSize: 24,
              fontColor: theme.colorPrimary,
              rotate: -30,
              child: _DemoContent(theme: theme, height: 200),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义间距',
            theme: theme,
            child: AntWatermark(
              content: '密集水印',
              gapX: 40,
              gapY: 40,
              child: _DemoContent(theme: theme, height: 200),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '覆盖列表内容',
            theme: theme,
            child: AntWatermark(
              content: ['内部资料', '禁止外传'],
              gapX: 60,
              gapY: 60,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.description,
                      color: theme.colorPrimary,
                    ),
                    title: Text(
                      '文档条目 ${index + 1}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorText,
                      ),
                    ),
                    subtitle: Text(
                      '2026-11-16 更新',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorTextSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 演示占位内容。
class _DemoContent extends StatelessWidget {
  const _DemoContent({required this.theme, required this.height});

  final AntThemeData theme;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorFillQuaternary,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
      ),
      child: Center(
        child: Text(
          '这里是覆盖内容\n水印铺满上层且不拦截手势',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorTextSecondary,
            height: 1.6,
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
