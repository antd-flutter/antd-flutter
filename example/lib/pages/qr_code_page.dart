import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  bool _expired = true;
  int _refreshCount = 0;

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
            child: const AntQRCode(value: 'https://example.com'),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义尺寸',
            theme: theme,
            child: Row(
              children: [
                const AntQRCode(value: 'size-100', size: 100),
                SizedBox(width: 24.w),
                const AntQRCode(value: 'size-160', size: 160),
                SizedBox(width: 24.w),
                const AntQRCode(value: 'size-200', size: 200),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '纠错等级',
            theme: theme,
            child: Row(
              children: [
                Column(
                  children: [
                    const AntQRCode(value: 'L', size: 100, errorLevel: AntQRCodeErrorLevel.l),
                    SizedBox(height: 8.w),
                    const Text('L'),
                  ],
                ),
                SizedBox(width: 24.w),
                Column(
                  children: [
                    const AntQRCode(value: 'M', size: 100, errorLevel: AntQRCodeErrorLevel.m),
                    SizedBox(height: 8.w),
                    const Text('M'),
                  ],
                ),
                SizedBox(width: 24.w),
                Column(
                  children: [
                    const AntQRCode(value: 'Q', size: 100, errorLevel: AntQRCodeErrorLevel.q),
                    SizedBox(height: 8.w),
                    const Text('Q'),
                  ],
                ),
                SizedBox(width: 24.w),
                Column(
                  children: [
                    const AntQRCode(value: 'H', size: 100, errorLevel: AntQRCodeErrorLevel.h),
                    SizedBox(height: 8.w),
                    const Text('H'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义颜色',
            theme: theme,
            child: Row(
              children: [
                const AntQRCode(
                  value: 'color-red',
                  color: Colors.red,
                  bgColor: Color(0xFFFFF5F5),
                ),
                SizedBox(width: 24.w),
                const AntQRCode(
                  value: 'color-green',
                  color: Colors.green,
                  bgColor: Color(0xFFF6FFED),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无边框',
            theme: theme,
            child: const AntQRCode(value: 'no-border', bordered: false),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '过期与刷新（点击覆盖层刷新，已刷新 $_refreshCount 次）',
            theme: theme,
            child: _expired
                ? AntQRCode(
                    value: 'expired-$_refreshCount',
                    status: AntQRCodeStatus.expired,
                    onRefresh: () {
                      setState(() => _refreshCount++);
                    },
                  )
                : AntQRCode(value: 'fresh-$_refreshCount'),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '已扫描',
            theme: theme,
            child: const AntQRCode(
              value: 'scanned',
              status: AntQRCodeStatus.scanned,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带图标',
            theme: theme,
            child: const AntQRCode(value: 'with-icon', icon: true),
          ),
          SizedBox(height: 16.w),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => setState(() => _expired = !_expired),
              child: const Text('切换过期/正常状态'),
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
