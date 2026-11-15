/// antd_theme 示例应用。
///
/// 展示 AntTheme/AntThemeData 主题注入、亮暗切换、
/// AntBreakpoint 响应式断点、AntScreenUtilInit 屏幕适配。
library;

import 'package:antd_theme/antd_theme.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

void main() {
  runApp(const AntdThemeExampleApp());
}

class AntdThemeExampleApp extends StatefulWidget {
  const AntdThemeExampleApp({super.key});

  @override
  State<AntdThemeExampleApp> createState() => _AntdThemeExampleAppState();
}

class _AntdThemeExampleAppState extends State<AntdThemeExampleApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeData = _isDark ? AntThemeData.dark() : AntThemeData.light();

    return AntTheme(
      data: themeData,
      child: AntScreenUtilInit(
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'antd_theme Example',
            home: _ExamplePage(
              isDark: _isDark,
              onToggle: () => setState(() => _isDark = !_isDark),
            ),
          );
        },
      ),
    );
  }
}

class _ExamplePage extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ExamplePage({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorBgLayout,
      appBar: AppBar(
        backgroundColor: theme.colorBgContainer,
        title: Text(
          'antd_theme 示例',
          style: TextStyle(color: theme.colorTextHeading),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorIcon,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // ==================== 主题信息卡 ====================
          _ThemeInfoCard(theme: theme, isDark: isDark),
          SizedBox(height: 16.w),

          // ==================== 字号阶梯 ====================
          _SectionTitle('字号阶梯 (Font Tokens)', theme),
          _FontSizeLadder(theme: theme),
          SizedBox(height: 16.w),

          // ==================== 圆角与尺寸 ====================
          _SectionTitle('圆角与尺寸', theme),
          _RadiusAndSizeDemo(theme: theme),
          SizedBox(height: 16.w),

          // ==================== 阴影 ====================
          _SectionTitle('阴影 (BoxShadow)', theme),
          _ShadowDemo(theme: theme),
          SizedBox(height: 16.w),

          // ==================== 动效时长 ====================
          _SectionTitle('动效时长 (Motion)', theme),
          _MotionDemo(theme: theme),
          SizedBox(height: 16.w),

          // ==================== 响应式断点 ====================
          _SectionTitle('响应式断点 (AntBreakpoint)', theme),
          _BreakpointDemo(theme: theme),
          SizedBox(height: 32.w),
        ],
      ),
    );
  }
}

// ============================================================
// 主题信息卡
// ============================================================

class _ThemeInfoCard extends StatelessWidget {
  final AntThemeData theme;
  final bool isDark;

  const _ThemeInfoCard({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: theme.colorPrimary,
                  borderRadius: BorderRadius.circular(theme.borderRadius.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDark ? '暗色主题 (dark)' : '亮色主题 (light)',
                      style: TextStyle(
                        color: theme.colorTextHeading,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'primary: #${theme.colorPrimary.toARGB32().toRadixString(16).substring(2)}',
                      style: TextStyle(
                        color: theme.colorTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.w,
            children: [
              _ColorChip('Primary', theme.colorPrimary, theme),
              _ColorChip('Success', theme.colorSuccess, theme),
              _ColorChip('Warning', theme.colorWarning, theme),
              _ColorChip('Error', theme.colorError, theme),
              _ColorChip('Info', theme.colorInfo, theme),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final AntThemeData theme;

  const _ColorChip(this.label, this.color, this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(theme.borderRadiusXS.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 字号阶梯
// ============================================================

class _FontSizeLadder extends StatelessWidget {
  final AntThemeData theme;

  const _FontSizeLadder({required this.theme});

  @override
  Widget build(BuildContext context) {
    final items = <(String, double)>[
      ('fontSizeSM', theme.fontSizeSM),
      ('fontSize', theme.fontSize),
      ('fontSizeLG', theme.fontSizeLG),
      ('fontSizeXL', theme.fontSizeXL),
      ('fontSizeHeading5', theme.fontSizeHeading5),
      ('fontSizeHeading4', theme.fontSizeHeading4),
      ('fontSizeHeading3', theme.fontSizeHeading3),
      ('fontSizeHeading2', theme.fontSizeHeading2),
      ('fontSizeHeading1', theme.fontSizeHeading1),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          final (label, size) = item;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w),
            child: Row(
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.colorTextTertiary,
                      fontSize: 11.sp,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Text(
                  'Aa 字',
                  style: TextStyle(
                    color: theme.colorText,
                    fontSize: size.sp,
                  ),
                ),
                const Spacer(),
                Text(
                  '${size.toStringAsFixed(0)}px',
                  style: TextStyle(
                    color: theme.colorTextQuaternary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// 圆角与尺寸
// ============================================================

class _RadiusAndSizeDemo extends StatelessWidget {
  final AntThemeData theme;

  const _RadiusAndSizeDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    final radii = <(String, double)>[
      ('XS', theme.borderRadiusXS),
      ('SM', theme.borderRadiusSM),
      ('', theme.borderRadius),
      ('LG', theme.borderRadiusLG),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('圆角',
              style: TextStyle(
                  color: theme.colorTextLabel, fontSize: 12.sp,),),
          SizedBox(height: 8.w),
          Row(
            children: radii.map((item) {
              final (label, r) = item;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Container(
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: theme.colorPrimaryBg,
                          borderRadius: BorderRadius.circular(r.r),
                          border:
                              Border.all(color: theme.colorPrimaryBorder),
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        label.isEmpty ? 'base' : label,
                        style: TextStyle(
                            color: theme.colorTextTertiary, fontSize: 10.sp,),
                      ),
                      Text(
                        r.toStringAsFixed(0),
                        style: TextStyle(
                            color: theme.colorTextQuaternary, fontSize: 9.sp,),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.w),
          Text('尺寸阶梯',
              style: TextStyle(
                  color: theme.colorTextLabel, fontSize: 12.sp,),),
          SizedBox(height: 8.w),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              for (final entry in [
                ('XXS', theme.sizeXXS),
                ('XS', theme.sizeXS),
                ('SM', theme.sizeSM),
                ('', theme.size),
                ('MS', theme.sizeMS),
                ('MD', theme.sizeMD),
                ('LG', theme.sizeLG),
                ('XL', theme.sizeXL),
                ('XXL', theme.sizeXXL),
              ])
                Container(
                  width: entry.$2.w,
                  height: entry.$2.w,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(theme.borderRadiusXS.r),
                    border: Border.all(color: theme.colorPrimaryBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.$1.isEmpty ? 'S' : entry.$1,
                    style: TextStyle(
                        color: theme.colorPrimary, fontSize: 8.sp,),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 阴影演示
// ============================================================

class _ShadowDemo extends StatelessWidget {
  final AntThemeData theme;

  const _ShadowDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    final demos = <(String, List<BoxShadow>)>[
      ('boxShadow', theme.boxShadow),
      ('Secondary', theme.boxShadowSecondary),
      ('Tertiary', theme.boxShadowTertiary),
      ('Card', theme.boxShadowCard),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Wrap(
        spacing: 20.w,
        runSpacing: 16.w,
        children: demos.map((d) {
          final (label, shadow) = d;
          return Column(
            children: [
              Container(
                width: 80.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: theme.colorBgElevated,
                  borderRadius: BorderRadius.circular(theme.borderRadiusSM.r),
                  boxShadow: shadow,
                ),
              ),
              SizedBox(height: 6.w),
              Text(label,
                  style: TextStyle(
                      color: theme.colorTextTertiary, fontSize: 10.sp,),),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// 动效时长
// ============================================================

class _MotionDemo extends StatelessWidget {
  final AntThemeData theme;

  const _MotionDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    final items = <(String, Duration)>[
      ('motionDurationFast', theme.motionDurationFast),
      ('motionDurationMid', theme.motionDurationMid),
      ('motionDurationSlow', theme.motionDurationSlow),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        children: items.map((item) {
          final (label, duration) = item;
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(label,
                style: TextStyle(
                    color: theme.colorTextSecondary,
                    fontSize: 12.sp,
                    fontFamily: 'monospace',),),
            trailing: Text('${duration.inMilliseconds}ms',
                style: TextStyle(
                    color: theme.colorText, fontSize: 13.sp,),),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// 响应式断点
// ============================================================

class _BreakpointDemo extends StatelessWidget {
  final AntThemeData theme;

  const _BreakpointDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    final bp = AntBreakpoint.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前断点: ${bp?.name ?? "无 (宽度 < 480)"}',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            '屏幕宽度: ${width.toStringAsFixed(0)}',
            style: TextStyle(
                color: theme.colorTextSecondary, fontSize: 12.sp,),
          ),
          SizedBox(height: 12.w),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: AntBreakpoint.values.map((b) {
              final active = bp != null && bp >= b;
              return Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: active
                      ? theme.colorPrimaryBg
                      : theme.colorFillQuaternary,
                  borderRadius: BorderRadius.circular(theme.borderRadiusXS.r),
                  border: Border.all(
                    color: active
                        ? theme.colorPrimaryBorder
                        : theme.colorBorderSecondary,
                  ),
                ),
                child: Text(
                  '${b.name} ≥${b.minWidth}',
                  style: TextStyle(
                    color: active
                        ? theme.colorPrimaryText
                        : theme.colorTextTertiary,
                    fontSize: 11.sp,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.w),
          Text(
            'isUp(md): ${AntBreakpoints.isUp(context, AntBreakpoint.md)}  '
            'isDown(lg): ${AntBreakpoints.isDown(context, AntBreakpoint.lg)}',
            style: TextStyle(
                color: theme.colorTextTertiary,
                fontSize: 11.sp,
                fontFamily: 'monospace',),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 区块标题
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String text;
  final AntThemeData theme;

  const _SectionTitle(this.text, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorTextHeading,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}