/// antd_theme ↔ Flutter Material 主题桥接层。
///
/// 将 [AntThemeData]（antd v6 三层令牌）转换为 Flutter 原生
/// [ThemeData]，使原生 Material 控件「变相」遵循 antd 设计规范。
///
/// 映射表：见 [AntMaterialTheme.toThemeData] 及其私有构建方法，
/// 每个映射均注明 antd 规范出处（Seed / Map / Alias Token）。
library;

import 'package:material_ui/material_ui.dart';

import 'ant_theme_data.dart';

/// 标题字重 — antd Typography 标题统一 600（字体令牌 fontWeightStrong）。
const FontWeight _antHeadingFontWeight = FontWeight.w600;

/// antd 主题 → Flutter Material 主题转换扩展。
extension AntMaterialTheme on AntThemeData {
  /// 转换为 Flutter [ThemeData]。
  ///
  /// [brightness] 缺省时跟随当前 antd 主题的明暗（[AntThemeData.isDark]）；
  /// 显式传入且与当前明暗不一致时，使用同一 [AntThemeData.seed]
  /// 派生对应明暗的 antd 主题后转换（保证亮暗 token 体系正确）。
  ThemeData toThemeData({Brightness? brightness}) {
    final resolvedIsDark =
        brightness == null ? isDark : brightness == Brightness.dark;
    if (resolvedIsDark == isDark) return _buildThemeData();
    return AntThemeData.fromSeed(seed, isDark: resolvedIsDark)
        ._buildThemeData();
  }

  // ============================================================
  // ColorScheme 映射表
  // ============================================================

  ColorScheme _buildColorScheme() {
    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      // Seed Token colorPrimary（antd 默认 #1677ff，暗色 #1668dc）
      primary: colorPrimary,
      // 通用 Token colorTextLightSolid（主色按钮上的白色文字）
      onPrimary: colorTextLightSolid,
      // Map Token color-primary-bg（主色浅背景）
      primaryContainer: colorPrimaryBg,
      // Map Token color-primary-text（主色文本）
      onPrimaryContainer: colorPrimaryText,
      // antd 无独立 secondary，语义最近的是 Seed Token colorInfo
      secondary: colorInfo,
      onSecondary: colorTextLightSolid,
      tertiary: colorInfo,
      onTertiary: colorTextLightSolid,
      // Seed Token colorError（antd 默认 #ff4d4f）
      error: colorError,
      onError: colorTextLightSolid,
      // Alias Token color-error-bg（错误浅背景）
      errorContainer: colorErrorBg,
      // Alias Token color-error-text（错误文本）
      onErrorContainer: colorErrorText,
      // Alias Token colorBgContainer（组件容器背景，antd 默认 #ffffff）
      surface: colorBgContainer,
      // Alias Token colorText（正文文本 rgba(0,0,0,0.88)）
      onSurface: colorText,
      // Alias Token colorTextSecondary（次级文本 rgba(0,0,0,0.65)）
      onSurfaceVariant: colorTextSecondary,
      // Alias Token colorBorder（边框 #d9d9d9）
      outline: colorBorder,
      // Alias Token colorSplit（分割线）
      outlineVariant: colorSplit,
      // Alias Token colorShadow（阴影基色）
      shadow: colorShadow,
      // Alias Token colorBgMask（遮罩 rgba(0,0,0,0.45)）
      scrim: colorBgMask,
      // antd 反色面板（Tooltip 等）使用文本色作为背景
      inverseSurface: colorText,
      onInverseSurface: colorBgContainer,
      inversePrimary: colorPrimaryBg,
      surfaceTint: colorPrimary,
    );
  }

  // ============================================================
  // TextTheme 映射表（antd Typography 排版规范）
  // ============================================================

  TextTheme _buildTextTheme() {
    // antd 标题：Heading 1~5 = 38/30/24/20/16，行高 1.23/1.35/1.4/1.4/1.5
    TextStyle heading({
      required double size,
      required double height,
      Color? color,
    }) =>
        TextStyle(
          fontSize: size,
          height: height,
          fontWeight: _antHeadingFontWeight,
          color: color ?? colorTextHeading,
        );

    return TextTheme(
      // Material display 档在 antd 中无对应规范，取 Heading 1 保守映射
      displayLarge: heading(
        size: fontSizeHeading1,
        height: lineHeightHeading1,
        color: colorText,
      ),
      displayMedium: heading(
        size: fontSizeHeading2,
        height: lineHeightHeading2,
        color: colorText,
      ),
      displaySmall: heading(
        size: fontSizeHeading3,
        height: lineHeightHeading3,
        color: colorText,
      ),
      headlineLarge: heading(size: fontSizeHeading1, height: lineHeightHeading1),
      headlineMedium: heading(
        size: fontSizeHeading2,
        height: lineHeightHeading2,
      ),
      headlineSmall: heading(size: fontSizeHeading3, height: lineHeightHeading3),
      titleLarge: heading(size: fontSizeHeading4, height: lineHeightHeading4),
      titleMedium: heading(size: fontSizeHeading5, height: lineHeightHeading5),
      // antd 正文加粗（fontSize 14 / lineHeight 1.5714 / fontWeightStrong 600）
      titleSmall: TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: FontWeight.w600,
        color: colorTextHeading,
      ),
      // antd 正文：fontSizeLG 16 / lineHeightLG 1.5
      bodyLarge: TextStyle(
        fontSize: fontSizeLG,
        height: lineHeightLG,
        color: colorText,
      ),
      // antd 默认正文：fontSize 14 / lineHeight 1.5714
      bodyMedium: TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        color: colorText,
      ),
      // antd 次要正文：fontSizeSM 12 / lineHeightSM 1.66
      bodySmall: TextStyle(
        fontSize: fontSizeSM,
        height: lineHeightSM,
        color: colorTextSecondary,
      ),
      // antd 按钮文字：fontSize 14 + fontWeightStrong
      labelLarge: TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: _antHeadingFontWeight,
        color: colorText,
      ),
      labelMedium: TextStyle(
        fontSize: fontSizeSM,
        height: lineHeightSM,
        color: colorText,
      ),
      labelSmall: TextStyle(
        fontSize: fontSizeSM,
        height: lineHeightSM,
        color: colorTextSecondary,
      ),
    );
  }

  // ============================================================
  // 组件级主题映射表（antd Button / Card / Input / Dialog 规范）
  // ============================================================

  ThemeData _buildThemeData() {
    // antd Button：高度 controlHeight 32（默认）/ 40（LG），圆角 borderRadius 6
    ButtonStyle baseButtonStyle({
      WidgetStateProperty<Color?>? foreground,
      WidgetStateProperty<Color?>? background,
    }) =>
        ButtonStyle(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: WidgetStatePropertyAll(Size(0, controlHeight)),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: paddingContentHorizontal),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: _buildColorScheme(),
      // Alias Token colorBgLayout（页面背景 #f5f5f5，暗色 #000000）
      scaffoldBackgroundColor: colorBgLayout,
      fontFamily: fontFamily,
      textTheme: _buildTextTheme(),
      iconTheme: IconThemeData(color: colorIcon, size: fontSizeHeading5),
      // antd 主按钮（type="primary"）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButtonStyle(
          foreground: _resolveByDisabled(
            enabled: colorTextLightSolid,
            disabled: colorTextDisabled,
          ),
          background: _resolveByDisabled(
            enabled: colorPrimary,
            disabled: colorBgContainerDisabled,
          ),
        ),
      ),
      // antd 次按钮（默认按钮：白底灰边）
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: baseButtonStyle(
          foreground: _resolveByDisabled(
            enabled: colorText,
            disabled: colorTextDisabled,
          ),
          background: const WidgetStatePropertyAll(Colors.transparent),
        ).copyWith(
          side: WidgetStatePropertyAll(BorderSide(color: colorBorder)),
        ),
      ),
      // antd 链接按钮（type="link"）
      textButtonTheme: TextButtonThemeData(
        style: baseButtonStyle(
          foreground: WidgetStatePropertyAll(colorPrimary),
        ).copyWith(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: paddingXS),
          ),
        ),
      ),
      // antd Card：容器背景 + borderRadiusLG 8 + 无阴影（antd 卡片默认无投影）
      cardTheme: CardThemeData(
        color: colorBgContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLG),
        ),
        margin: EdgeInsets.zero,
      ),
      // antd Input：1px #d9d9d9 边框，聚焦主色 2px，圆角 borderRadius
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorBgContainer,
        hintStyle: TextStyle(
          color: colorTextPlaceholder,
          fontSize: fontSize,
          height: lineHeight,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: paddingSM,
          vertical: (controlHeight - fontSize * lineHeight) / 2,
        ),
        border: _inputBorder(colorBorder, lineWidth),
        enabledBorder: _inputBorder(colorBorder, lineWidth),
        disabledBorder: _inputBorder(colorBorderDisabled, lineWidth),
        focusedBorder: _inputBorder(colorPrimary, lineWidthBold),
        errorBorder: _inputBorder(colorError, lineWidth),
        focusedErrorBorder: _inputBorder(colorError, lineWidthBold),
      ),
      // antd Modal/Dialog：浮层背景 colorBgElevated + borderRadiusLG
      dialogTheme: DialogThemeData(
        backgroundColor: colorBgElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLG),
        ),
        titleTextStyle: TextStyle(
          fontSize: fontSizeHeading5,
          height: lineHeightHeading5,
          fontWeight: _antHeadingFontWeight,
          color: colorTextHeading,
        ),
        contentTextStyle: TextStyle(
          fontSize: fontSize,
          height: lineHeight,
          color: colorText,
        ),
      ),
      // antd Divider：colorSplit 分割线 + lineWidth 线宽
      dividerTheme: DividerThemeData(
        color: colorSplit,
        thickness: lineWidth,
      ),
    );
  }

  /// 按控件禁用态解析颜色：未禁用取 [enabled]，禁用取 [disabled]。
  WidgetStateProperty<Color?> _resolveByDisabled({
    required Color enabled,
    required Color disabled,
  }) =>
      WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? disabled : enabled,
      );

  OutlineInputBorder _inputBorder(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width),
      );
}
