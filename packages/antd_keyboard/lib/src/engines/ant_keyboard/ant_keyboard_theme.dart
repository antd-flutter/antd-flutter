/// AntKeyboardThemeData — 通用屏上键盘主题（token 化，仿 flutter_onscreen_keyboard
/// `OnscreenKeyboardThemeData` 设计，MIT，完全仿造改造不引依赖）
///
/// - 默认从 [AntThemeData] 派生（亮/暗自适应，见 [AntKeyboardThemeData.resolve]）
/// - 支持自定义覆盖任意 token
/// - `desktop` 密度：桌面端键宽键高适配鼠标点击，键距更大
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

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
    this.desktop = false,
  });

  /// 键盘表面（容器底色），null 时取主题 colorBgContainer
  final Color? surfaceColor;

  /// 文本键背景
  final Color? keyBackgroundColor;

  /// 文本键前景（文字色）
  final Color? keyForegroundColor;

  /// 文本键按压态背景
  final Color? keyPressedBackgroundColor;

  /// 文本键悬停态背景（桌面端鼠标交互）
  final Color? keyHoverBackgroundColor;

  /// 动作键（退格/空格/收起等）背景
  final Color? actionKeyBackgroundColor;

  /// 动作键前景
  final Color? actionKeyForegroundColor;

  /// 动作键按压态背景
  final Color? actionKeyPressedBackgroundColor;

  /// 确认键背景
  final Color? confirmBackgroundColor;

  /// 确认键前景
  final Color? confirmForegroundColor;

  /// 键圆角
  final double? keyBorderRadius;

  /// 键高
  final double? keyHeight;

  /// 键水平/垂直间距
  final double? keySpacing;

  /// 键盘内边距
  final double? sectionPadding;

  /// 键文字字号
  final double? fontSize;

  /// 动作键图标尺寸
  final double? iconSize;

  /// 桌面密度（键高更大、间距更宽、启用悬停反馈）
  final bool desktop;

  /// 复制并覆盖（仅覆盖非 null 字段）
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
      actionKeyPressedBackgroundColor: actionKeyPressedBackgroundColor ??
          this.actionKeyPressedBackgroundColor,
      confirmBackgroundColor: confirmBackgroundColor ?? this.confirmBackgroundColor,
      confirmForegroundColor: confirmForegroundColor ?? this.confirmForegroundColor,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keyHeight: keyHeight ?? this.keyHeight,
      keySpacing: keySpacing ?? this.keySpacing,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      fontSize: fontSize ?? this.fontSize,
      iconSize: iconSize ?? this.iconSize,
      desktop: desktop ?? this.desktop,
    );
  }

  /// 从 antd 主题 token 派生默认主题（亮/暗自适应 + 桌面密度）
  factory AntKeyboardThemeData.resolve(
    AntThemeData t, {
    bool desktop = false,
  }) {
    final dark = t.isDark;
    return AntKeyboardThemeData(
      surfaceColor: dark ? t.colorBgContainer : t.colorFillQuaternary,
      keyBackgroundColor: dark ? t.colorFillSecondary : t.colorBgContainer,
      keyForegroundColor: t.colorText,
      keyPressedBackgroundColor: dark
          ? t.colorFill
          : t.colorFillSecondary,
      keyHoverBackgroundColor: dark ? t.colorFill : t.colorFillSecondary,
      actionKeyBackgroundColor: dark ? t.colorFill : t.colorFillTertiary,
      actionKeyForegroundColor: t.colorTextSecondary,
      actionKeyPressedBackgroundColor: t.colorFillSecondary,
      confirmBackgroundColor: t.colorPrimary,
      confirmForegroundColor: Colors.white,
      keyBorderRadius: t.borderRadiusSM.w,
      keyHeight: desktop ? 48.0 : 44.0,
      keySpacing: desktop ? 8.0 : 5.0,
      sectionPadding: t.marginXS.w,
      fontSize: t.fontSizeLG.sp,
      iconSize: 22.w,
      desktop: desktop,
    );
  }

  /// 合并覆盖（this 非 null 字段优先）
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
      actionKeyPressedBackgroundColor: other.actionKeyPressedBackgroundColor ??
          actionKeyPressedBackgroundColor,
      confirmBackgroundColor: other.confirmBackgroundColor ?? confirmBackgroundColor,
      confirmForegroundColor: other.confirmForegroundColor ?? confirmForegroundColor,
      keyBorderRadius: other.keyBorderRadius ?? keyBorderRadius,
      keyHeight: other.keyHeight ?? keyHeight,
      keySpacing: other.keySpacing ?? keySpacing,
      sectionPadding: other.sectionPadding ?? sectionPadding,
      fontSize: other.fontSize ?? fontSize,
      iconSize: other.iconSize ?? iconSize,
      desktop: other.desktop,
    );
  }
}
