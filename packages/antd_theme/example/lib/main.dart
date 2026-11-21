/// antd_theme 示例应用。
///
/// 展示 AntTheme/AntThemeData 主题注入、亮暗切换、
/// AntBreakpoint 响应式断点。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'antd_theme Example',
        home: _ExamplePage(
          isDark: _isDark,
          onToggle: () => setState(() => _isDark = !_isDark),
        ),
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
              isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined,
              color: theme.colorIcon,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(theme.s(16)),
        children: [
          // ==================== 主题信息卡 ====================
          _ThemeInfoCard(theme: theme, isDark: isDark),
          SizedBox(height: theme.s(16)),

          // ==================== 字号阶梯 ====================
          _SectionTitle('字号阶梯 (Font Tokens)', theme),
          _FontSizeLadder(theme: theme),
          SizedBox(height: theme.s(16)),

          // ==================== 圆角与尺寸 ====================
          _SectionTitle('圆角与尺寸', theme),
          _RadiusAndSizeDemo(theme: theme),
          SizedBox(height: theme.s(16)),

          // ==================== 阴影 ====================
          _SectionTitle('阴影 (BoxShadow)', theme),
          _ShadowDemo(theme: theme),
          SizedBox(height: theme.s(16)),

          // ==================== 动效时长 ====================
          _SectionTitle('动效时长 (Motion)', theme),
          _MotionDemo(theme: theme),
          SizedBox(height: theme.s(16)),

          // ==================== 响应式断点 ====================
          _SectionTitle('响应式断点 (AntBreakpoint)', theme),
          _BreakpointDemo(theme: theme),
          SizedBox(height: theme.s(32)),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: theme.s(40),
                height: theme.s(40),
                decoration: BoxDecoration(
                  color: theme.colorPrimary,
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                ),
              ),
              SizedBox(width: theme.s(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDark ? '暗色主题 (dark)' : '亮色主题 (light)',
                      style: TextStyle(
                        color: theme.colorTextHeading,
                        fontSize: theme.s(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'primary: #${theme.colorPrimary.toARGB32().toRadixString(16).substring(2)}',
                      style: TextStyle(
                        color: theme.colorTextSecondary,
                        fontSize: theme.s(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: theme.s(12)),
          Wrap(
            spacing: theme.s(8),
            runSpacing: theme.s(4),
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
      padding: EdgeInsets.symmetric(horizontal: theme.s(8), vertical: theme.s(4)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(theme.borderRadiusXS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: theme.s(10),
            height: theme.s(10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: theme.s(4)),
          Text(
            label,
            style: TextStyle(color: color, fontSize: theme.s(11)),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          final (label, size) = item;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: theme.s(4)),
            child: Row(
              children: [
                SizedBox(
                  width: theme.s(140),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.colorTextTertiary,
                      fontSize: theme.s(11),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Text(
                  'Aa 字',
                  style: TextStyle(
                    color: theme.colorText,
                    fontSize: size,
                  ),
                ),
                const Spacer(),
                Text(
                  '${size.toStringAsFixed(0)}px',
                  style: TextStyle(
                    color: theme.colorTextQuaternary,
                    fontSize: theme.s(11),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '圆角',
            style: TextStyle(
              color: theme.colorTextLabel,
              fontSize: theme.s(12),
            ),
          ),
          SizedBox(height: theme.s(8)),
          Row(
            children: radii.map((item) {
              final (label, r) = item;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.s(4)),
                  child: Column(
                    children: [
                      Container(
                        height: theme.s(40),
                        decoration: BoxDecoration(
                          color: theme.colorPrimaryBg,
                          borderRadius: BorderRadius.circular(r),
                          border: Border.all(color: theme.colorPrimaryBorder),
                        ),
                      ),
                      SizedBox(height: theme.s(4)),
                      Text(
                        label.isEmpty ? 'base' : label,
                        style: TextStyle(
                          color: theme.colorTextTertiary,
                          fontSize: theme.s(10),
                        ),
                      ),
                      Text(
                        r.toStringAsFixed(0),
                        style: TextStyle(
                          color: theme.colorTextQuaternary,
                          fontSize: theme.s(9),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: theme.s(12)),
          Text(
            '尺寸阶梯',
            style: TextStyle(
              color: theme.colorTextLabel,
              fontSize: theme.s(12),
            ),
          ),
          SizedBox(height: theme.s(8)),
          Wrap(
            spacing: theme.s(8),
            runSpacing: theme.s(8),
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
                  width: entry.$2,
                  height: entry.$2,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(theme.borderRadiusXS),
                    border: Border.all(color: theme.colorPrimaryBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.$1.isEmpty ? 'S' : entry.$1,
                    style: TextStyle(
                      color: theme.colorPrimary,
                      fontSize: theme.s(8),
                    ),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Wrap(
        spacing: theme.s(20),
        runSpacing: theme.s(16),
        children: demos.map((d) {
          final (label, shadow) = d;
          return Column(
            children: [
              Container(
                width: theme.s(80),
                height: theme.s(48),
                decoration: BoxDecoration(
                  color: theme.colorBgElevated,
                  borderRadius: BorderRadius.circular(theme.borderRadiusSM),
                  boxShadow: shadow,
                ),
              ),
              SizedBox(height: theme.s(6)),
              Text(
                label,
                style: TextStyle(
                  color: theme.colorTextTertiary,
                  fontSize: theme.s(10),
                ),
              ),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        children: items.map((item) {
          final (label, duration) = item;
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              label,
              style: TextStyle(
                color: theme.colorTextSecondary,
                fontSize: theme.s(12),
                fontFamily: 'monospace',
              ),
            ),
            trailing: Text(
              '${duration.inMilliseconds}ms',
              style: TextStyle(
                color: theme.colorText,
                fontSize: theme.s(13),
              ),
            ),
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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前断点: ${bp?.name ?? "无 (宽度 < 480)"}',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: theme.s(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: theme.s(4)),
          Text(
            '屏幕宽度: ${width.toStringAsFixed(0)}',
            style: TextStyle(
              color: theme.colorTextSecondary,
              fontSize: theme.s(12),
            ),
          ),
          SizedBox(height: theme.s(12)),
          Wrap(
            spacing: theme.s(8),
            runSpacing: theme.s(8),
            children: AntBreakpoint.values.map((b) {
              final active = bp != null && bp >= b;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: theme.s(10), vertical: theme.s(4)),
                decoration: BoxDecoration(
                  color:
                      active ? theme.colorPrimaryBg : theme.colorFillQuaternary,
                  borderRadius: BorderRadius.circular(theme.borderRadiusXS),
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
                    fontSize: theme.s(11),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: theme.s(12)),
          Text(
            'isUp(md): ${AntBreakpoints.isUp(context, AntBreakpoint.md)}  '
            'isDown(lg): ${AntBreakpoints.isDown(context, AntBreakpoint.lg)}',
            style: TextStyle(
              color: theme.colorTextTertiary,
              fontSize: theme.s(11),
              fontFamily: 'monospace',
            ),
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
      padding: EdgeInsets.only(bottom: theme.s(8)),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorTextHeading,
          fontSize: theme.s(14),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
