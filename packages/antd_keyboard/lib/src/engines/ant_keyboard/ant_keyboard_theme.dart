import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// AntKeyboard 主题数据。
///
/// 采用与 `flutter_onscreen_keyboard` 相同的「键级主题」思路：所有键共用一份
/// 主题，通过 `desktop` 切换桌面 / 移动两套形态（仓库 R38 双端规则）：
///
/// - 移动端：对齐 antd-mobile v5（白色键面、1px 描边、4 圆角、48 高）；
/// - 桌面端：对齐 antd v6（`colorBgElevated` 浮层、`colorFillSecondary` 键面、
///   6 圆角、`boxShadowSecondary` 阴影、hover 反馈）。
///
/// 尺寸一律走仓库约定 `theme.s(...)`（宽高/间距/描边/字号/圆角统一缩放因子），
/// 颜色一律取自 [AntThemeData] 令牌，不硬编码。
@immutable
class AntKeyboardThemeData {
  const AntKeyboardThemeData({
    this.surfaceColor,
    this.keyBackgroundColor,
    this.keyForegroundColor,
    this.keyPressedBackgroundColor,
    this.keyHoverBackgroundColor,
    this.actionKeyBackgroundColor,
    this.actionKeyForegroundColor,
    this.actionKeyPressedBackgroundColor,
    this.confirmBackgroundColor,
    this.confirmForegroundColor,
    this.keyBorderRadius,
    this.keyHeight,
    this.keySpacing,
    this.sectionPadding,
    this.fontSize,
    this.iconSize,
    this.keyBorderColor,
    this.keyBorderWidth,
    this.boxShadow,
    this.surfaceBorderColor,
    this.surfaceBorderRadius,
    this.showKeyBorders = true,
    this.headerHeight,
    this.headerBackgroundColor,
    this.titleColor,
    this.titleFontSize,
    this.confirmFontSize,
    this.desktop = false,
  });

  /// 键盘面板底色。
  final Color? surfaceColor;

  /// 文本键底色。
  final Color? keyBackgroundColor;

  /// 文本键前景色。
  final Color? keyForegroundColor;

  /// 文本键按下底色。
  final Color? keyPressedBackgroundColor;

  /// 文本键 hover 底色（桌面）。
  final Color? keyHoverBackgroundColor;

  /// 动作键底色（shift / caps / backspace / 自定义键等）。
  final Color? actionKeyBackgroundColor;

  /// 动作键前景色。
  final Color? actionKeyForegroundColor;

  /// 动作键按下底色。
  final Color? actionKeyPressedBackgroundColor;

  /// 确认键底色。
  final Color? confirmBackgroundColor;

  /// 确认键前景色。
  final Color? confirmForegroundColor;

  /// 键圆角。
  final double? keyBorderRadius;

  /// 键高度。
  final double? keyHeight;

  /// 键间距。
  final double? keySpacing;

  /// 面板内边距。
  final double? sectionPadding;

  /// 键字号。
  final double? fontSize;

  /// 动作图标尺寸。
  final double? iconSize;

  /// 键描边颜色。
  final Color? keyBorderColor;

  /// 键描边宽度。
  final double? keyBorderWidth;

  /// 面板阴影（桌面）。
  final List<BoxShadow>? boxShadow;

  /// 面板描边颜色。
  final Color? surfaceBorderColor;

  /// 面板圆角。
  final double? surfaceBorderRadius;

  /// 是否绘制键描边（antd-mobile 数字键盘为 true，桌面浮层也为 true）。
  final bool showKeyBorders;

  /// 头部高度（标题 / 关闭按钮区）。
  final double? headerHeight;

  /// 头部底色。
  final Color? headerBackgroundColor;

  /// 标题颜色。
  final Color? titleColor;

  /// 标题字号。
  final double? titleFontSize;

  /// 确认键字号。
  final double? confirmFontSize;

  /// 是否桌面形态（由调用方显式指定，默认跟随平台）。
  final bool desktop;

  AntKeyboardThemeData copyWith({
    Color? surfaceColor,
    Color? keyBackgroundColor,
    Color? keyForegroundColor,
    Color? keyPressedBackgroundColor,
    Color? keyHoverBackgroundColor,
    Color? actionKeyBackgroundColor,
    Color? actionKeyForegroundColor,
    Color? actionKeyPressedBackgroundColor,
    Color? confirmBackgroundColor,
    Color? confirmForegroundColor,
    double? keyBorderRadius,
    double? keyHeight,
    double? keySpacing,
    double? sectionPadding,
    double? fontSize,
    double? iconSize,
    Color? keyBorderColor,
    double? keyBorderWidth,
    List<BoxShadow>? boxShadow,
    Color? surfaceBorderColor,
    double? surfaceBorderRadius,
    bool? showKeyBorders,
    double? headerHeight,
    Color? headerBackgroundColor,
    Color? titleColor,
    double? titleFontSize,
    double? confirmFontSize,
    bool? desktop,
  }) {
    return AntKeyboardThemeData(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      keyBackgroundColor: keyBackgroundColor ?? this.keyBackgroundColor,
      keyForegroundColor: keyForegroundColor ?? this.keyForegroundColor,
      keyPressedBackgroundColor:
          keyPressedBackgroundColor ?? this.keyPressedBackgroundColor,
      keyHoverBackgroundColor:
          keyHoverBackgroundColor ?? this.keyHoverBackgroundColor,
      actionKeyBackgroundColor:
          actionKeyBackgroundColor ?? this.actionKeyBackgroundColor,
      actionKeyForegroundColor:
          actionKeyForegroundColor ?? this.actionKeyForegroundColor,
      actionKeyPressedBackgroundColor:
          actionKeyPressedBackgroundColor ?? this.actionKeyPressedBackgroundColor,
      confirmBackgroundColor:
          confirmBackgroundColor ?? this.confirmBackgroundColor,
      confirmForegroundColor:
          confirmForegroundColor ?? this.confirmForegroundColor,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keyHeight: keyHeight ?? this.keyHeight,
      keySpacing: keySpacing ?? this.keySpacing,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      fontSize: fontSize ?? this.fontSize,
      iconSize: iconSize ?? this.iconSize,
      keyBorderColor: keyBorderColor ?? this.keyBorderColor,
      keyBorderWidth: keyBorderWidth ?? this.keyBorderWidth,
      boxShadow: boxShadow ?? this.boxShadow,
      surfaceBorderColor: surfaceBorderColor ?? this.surfaceBorderColor,
      surfaceBorderRadius: surfaceBorderRadius ?? this.surfaceBorderRadius,
      showKeyBorders: showKeyBorders ?? this.showKeyBorders,
      headerHeight: headerHeight ?? this.headerHeight,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      titleColor: titleColor ?? this.titleColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      confirmFontSize: confirmFontSize ?? this.confirmFontSize,
      desktop: desktop ?? this.desktop,
    );
  }

  /// 从 [AntThemeData] 派生：移动端对齐 antd-mobile v5，桌面端对齐 antd v6。
  factory AntKeyboardThemeData.resolve(
    AntThemeData t, {
    bool desktop = false,
  }) {
    if (desktop) {
      return AntKeyboardThemeData(
        surfaceColor: t.colorBgElevated,
        keyBackgroundColor: t.colorFillSecondary,
        keyForegroundColor: t.colorText,
        keyPressedBackgroundColor: t.colorFill,
        keyHoverBackgroundColor: t.colorFillTertiary,
        actionKeyBackgroundColor: t.colorFillTertiary,
        actionKeyForegroundColor: t.colorTextSecondary,
        actionKeyPressedBackgroundColor: t.colorFillSecondary,
        confirmBackgroundColor: t.colorPrimary,
        confirmForegroundColor: t.colorTextLightSolid,
        keyBorderRadius: t.borderRadius,
        keyHeight: t.s(56),
        keySpacing: t.s(6),
        sectionPadding: t.s(12),
        fontSize: t.fontSizeLG,
        iconSize: t.s(20),
        keyBorderColor: t.colorBorder,
        keyBorderWidth: t.s(1),
        boxShadow: t.boxShadowSecondary,
        surfaceBorderColor: t.colorBorderSecondary,
        surfaceBorderRadius: t.borderRadiusLG,
        headerHeight: t.s(40),
        headerBackgroundColor: t.colorBgElevated,
        titleColor: t.colorTextSecondary,
        titleFontSize: t.fontSizeSM,
        confirmFontSize: t.fontSizeLG,
        desktop: true,
      );
    }
    return AntKeyboardThemeData(
      surfaceColor: t.colorBgContainer,
      keyBackgroundColor:
          t.isDark ? t.colorFillSecondary : t.colorBgContainer,
      keyForegroundColor: t.colorText,
      keyPressedBackgroundColor:
          t.isDark ? t.colorFill : t.colorFillSecondary,
      keyHoverBackgroundColor: t.colorFillSecondary,
      actionKeyBackgroundColor:
          t.isDark ? t.colorFill : t.colorFillTertiary,
      actionKeyForegroundColor: t.colorText,
      actionKeyPressedBackgroundColor:
          t.isDark ? t.colorFillTertiary : t.colorFill,
      confirmBackgroundColor: t.colorPrimary,
      confirmForegroundColor: t.colorTextLightSolid,
      keyBorderRadius: t.borderRadiusSM,
      keyHeight: t.s(48),
      keySpacing: t.s(6),
      sectionPadding: t.s(8),
      fontSize: t.fontSizeLG,
      iconSize: t.s(22),
      keyBorderColor: t.colorBorder,
      keyBorderWidth: t.s(1),
      surfaceBorderColor: t.colorBorder,
      surfaceBorderRadius: 0,
      headerHeight: t.s(34),
      headerBackgroundColor: t.colorBgContainer,
      titleColor: t.colorTextSecondary,
      titleFontSize: t.fontSizeSM,
      confirmFontSize: t.fontSizeLG,
      desktop: false,
    );
  }

  /// 合并主题覆盖：`other` 的非空字段优先。
  AntKeyboardThemeData merge(AntKeyboardThemeData? other) {
    if (other == null) return this;
    return AntKeyboardThemeData(
      surfaceColor: other.surfaceColor ?? surfaceColor,
      keyBackgroundColor: other.keyBackgroundColor ?? keyBackgroundColor,
      keyForegroundColor: other.keyForegroundColor ?? keyForegroundColor,
      keyPressedBackgroundColor:
          other.keyPressedBackgroundColor ?? keyPressedBackgroundColor,
      keyHoverBackgroundColor:
          other.keyHoverBackgroundColor ?? keyHoverBackgroundColor,
      actionKeyBackgroundColor:
          other.actionKeyBackgroundColor ?? actionKeyBackgroundColor,
      actionKeyForegroundColor:
          other.actionKeyForegroundColor ?? actionKeyForegroundColor,
      actionKeyPressedBackgroundColor:
          other.actionKeyPressedBackgroundColor ?? actionKeyPressedBackgroundColor,
      confirmBackgroundColor:
          other.confirmBackgroundColor ?? confirmBackgroundColor,
      confirmForegroundColor:
          other.confirmForegroundColor ?? confirmForegroundColor,
      keyBorderRadius: other.keyBorderRadius ?? keyBorderRadius,
      keyHeight: other.keyHeight ?? keyHeight,
      keySpacing: other.keySpacing ?? keySpacing,
      sectionPadding: other.sectionPadding ?? sectionPadding,
      fontSize: other.fontSize ?? fontSize,
      iconSize: other.iconSize ?? iconSize,
      keyBorderColor: other.keyBorderColor ?? keyBorderColor,
      keyBorderWidth: other.keyBorderWidth ?? keyBorderWidth,
      boxShadow: other.boxShadow ?? boxShadow,
      surfaceBorderColor: other.surfaceBorderColor ?? surfaceBorderColor,
      surfaceBorderRadius: other.surfaceBorderRadius ?? surfaceBorderRadius,
      showKeyBorders: other.showKeyBorders,
      headerHeight: other.headerHeight ?? headerHeight,
      headerBackgroundColor:
          other.headerBackgroundColor ?? headerBackgroundColor,
      titleColor: other.titleColor ?? titleColor,
      titleFontSize: other.titleFontSize ?? titleFontSize,
      confirmFontSize: other.confirmFontSize ?? confirmFontSize,
      desktop: other.desktop,
    );
  }
}
