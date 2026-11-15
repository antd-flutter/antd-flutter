/// Ant Design 颜色令牌。
///
/// 从种子令牌生成完整的颜色令牌集（亮色 / 暗色），
/// 对应 antd `genColorMapToken` + `generateNeutralColorPalettes` + `alias.ts` 颜色部分。
library;

import 'dart:ui';

import 'package:antd_color/antd_color.dart';
import 'ant_seed_token.dart';

// ============================================================
// 颜色算法（亮/暗主题）
// ============================================================

/// 设置透明度并输出 rgba 字符串。
String _getAlphaColor(String baseColor, double alpha) {
  return AntFastColor.of(baseColor).setA(alpha).toRgbString();
}

/// 实色调整：亮色主题 darken，暗色主题 lighten。
String _getSolidColorLight(String baseColor, double brightness) {
  return AntFastColor.of(baseColor).darken(brightness).toHexString();
}

String _getSolidColorDark(String baseColor, double brightness) {
  return AntFastColor.of(baseColor).lighten(brightness).toHexString();
}

/// 在背景色上寻找最小 alpha 使前景色呈现效果（antd util/getAlphaColor）。
String _getAlphaColorOnBg(String frontColor, String backgroundColor) {
  final front = AntFastColor.of(frontColor);
  final fRgb = front.toRgb();
  if (front.a < 1) return frontColor;

  final bRgb = AntFastColor.of(backgroundColor).toRgb();

  for (var fA = 0.01; fA <= 1; fA += 0.01) {
    final r = ((fRgb.r - bRgb.r * (1 - fA)) / fA).round();
    final g = ((fRgb.g - bRgb.g * (1 - fA)) / fA).round();
    final b = ((fRgb.b - bRgb.b * (1 - fA)) / fA).round();
    if (r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255) {
      return AntFastColor.fromRgb(r, g, b, (fA * 100).round() / 100)
          .toRgbString();
    }
  }

  // fallback
  return AntFastColor.fromRgb(fRgb.r, fRgb.g, fRgb.b, 1).toRgbString();
}

// ============================================================
// 色板映射（antd ColorMap 1-10）
// ============================================================

/// 亮色主题色板映射: {1..7}=colors[0..6], {8,9,10}=colors[4,5,6]。
List<String> _mapLight(List<String> colors) => [
      colors[0], colors[1], colors[2], colors[3], colors[4],
      colors[5], colors[6], colors[4], colors[5], colors[6],
    ];

/// 暗色主题色板映射: {1..4}=colors[0..3], {5}=colors[6], {6}=colors[5],
/// {7}=colors[4], {8,9,10}=colors[6,5,4]。
List<String> _mapDark(List<String> colors) => [
      colors[0], colors[1], colors[2], colors[3],
      colors[6], colors[5], colors[4],
      colors[6], colors[5], colors[4],
    ];

// ============================================================
// AntColorTokens — 完整颜色令牌集
// ============================================================

/// Ant Design 颜色令牌集。
///
/// 包含 antd MapToken + AliasToken 中的全部颜色字段，
/// 以 Flutter [Color] 形式提供，同时保留 CSS 字符串用于调试。
class AntColorTokens {
  AntColorTokens._({
    required this.css,
    required this.isDark,
  });

  /// CSS 原始字符串令牌（调试用）。
  final AntColorTokensCss css;

  /// 是否暗色主题。
  final bool isDark;

  // ==================== 基色 ====================

  Color get colorBgBase => antParseColor(css.colorBgBase);
  Color get colorTextBase => antParseColor(css.colorTextBase);
  Color get colorWhite => antParseColor(css.colorWhite);
  Color get colorShadow => antParseColor(css.colorShadow);
  Color get colorBgMask => antParseColor(css.colorBgMask);

  // ==================== 文字 ====================

  Color get colorText => antParseColor(css.colorText);
  Color get colorTextSecondary => antParseColor(css.colorTextSecondary);
  Color get colorTextTertiary => antParseColor(css.colorTextTertiary);
  Color get colorTextQuaternary => antParseColor(css.colorTextQuaternary);

  Color get colorTextHeading => antParseColor(css.colorTextHeading);
  Color get colorTextLabel => antParseColor(css.colorTextLabel);
  Color get colorTextDescription => antParseColor(css.colorTextDescription);
  Color get colorTextLightSolid => antParseColor(css.colorTextLightSolid);
  Color get colorTextPlaceholder => antParseColor(css.colorTextPlaceholder);
  Color get colorTextDisabled => antParseColor(css.colorTextDisabled);
  Color get colorHighlight => antParseColor(css.colorHighlight);
  Color get colorIcon => antParseColor(css.colorIcon);
  Color get colorIconHover => antParseColor(css.colorIconHover);

  // ==================== 填充 ====================

  Color get colorFill => antParseColor(css.colorFill);
  Color get colorFillSecondary => antParseColor(css.colorFillSecondary);
  Color get colorFillTertiary => antParseColor(css.colorFillTertiary);
  Color get colorFillQuaternary => antParseColor(css.colorFillQuaternary);
  Color get colorFillContent => antParseColor(css.colorFillContent);
  Color get colorFillContentHover => antParseColor(css.colorFillContentHover);
  Color get colorFillAlter => antParseColor(css.colorFillAlter);

  // ==================== 背景 ====================

  Color get colorBgContainer => antParseColor(css.colorBgContainer);
  Color get colorBgElevated => antParseColor(css.colorBgElevated);
  Color get colorBgLayout => antParseColor(css.colorBgLayout);
  Color get colorBgSpotlight => antParseColor(css.colorBgSpotlight);
  Color get colorBgBlur => antParseColor(css.colorBgBlur);
  Color get colorBgContainerDisabled => antParseColor(css.colorBgContainerDisabled);
  Color get colorBgSolid => antParseColor(css.colorBgSolid);
  Color get colorBgSolidHover => antParseColor(css.colorBgSolidHover);
  Color get colorBgSolidActive => antParseColor(css.colorBgSolidActive);
  Color get colorBgTextHover => antParseColor(css.colorBgTextHover);
  Color get colorBgTextActive => antParseColor(css.colorBgTextActive);

  // ==================== 边框 ====================

  Color get colorBorder => antParseColor(css.colorBorder);
  Color get colorBorderSecondary => antParseColor(css.colorBorderSecondary);
  Color get colorBorderDisabled => antParseColor(css.colorBorderDisabled);
  Color get colorBorderBg => antParseColor(css.colorBorderBg);
  Color get colorSplit => antParseColor(css.colorSplit);

  // ==================== Primary ====================

  Color get colorPrimary => antParseColor(css.colorPrimary);
  Color get colorPrimaryBg => antParseColor(css.colorPrimaryBg);
  Color get colorPrimaryBgHover => antParseColor(css.colorPrimaryBgHover);
  Color get colorPrimaryBorder => antParseColor(css.colorPrimaryBorder);
  Color get colorPrimaryBorderHover => antParseColor(css.colorPrimaryBorderHover);
  Color get colorPrimaryHover => antParseColor(css.colorPrimaryHover);
  Color get colorPrimaryActive => antParseColor(css.colorPrimaryActive);
  Color get colorPrimaryTextHover => antParseColor(css.colorPrimaryTextHover);
  Color get colorPrimaryText => antParseColor(css.colorPrimaryText);
  Color get colorPrimaryTextActive => antParseColor(css.colorPrimaryTextActive);

  // ==================== Success ====================

  Color get colorSuccess => antParseColor(css.colorSuccess);
  Color get colorSuccessBg => antParseColor(css.colorSuccessBg);
  Color get colorSuccessBgHover => antParseColor(css.colorSuccessBgHover);
  Color get colorSuccessBorder => antParseColor(css.colorSuccessBorder);
  Color get colorSuccessBorderHover => antParseColor(css.colorSuccessBorderHover);
  Color get colorSuccessHover => antParseColor(css.colorSuccessHover);
  Color get colorSuccessActive => antParseColor(css.colorSuccessActive);
  Color get colorSuccessTextHover => antParseColor(css.colorSuccessTextHover);
  Color get colorSuccessText => antParseColor(css.colorSuccessText);
  Color get colorSuccessTextActive => antParseColor(css.colorSuccessTextActive);

  // ==================== Warning ====================

  Color get colorWarning => antParseColor(css.colorWarning);
  Color get colorWarningBg => antParseColor(css.colorWarningBg);
  Color get colorWarningBgHover => antParseColor(css.colorWarningBgHover);
  Color get colorWarningBorder => antParseColor(css.colorWarningBorder);
  Color get colorWarningBorderHover => antParseColor(css.colorWarningBorderHover);
  Color get colorWarningHover => antParseColor(css.colorWarningHover);
  Color get colorWarningActive => antParseColor(css.colorWarningActive);
  Color get colorWarningTextHover => antParseColor(css.colorWarningTextHover);
  Color get colorWarningText => antParseColor(css.colorWarningText);
  Color get colorWarningTextActive => antParseColor(css.colorWarningTextActive);

  // ==================== Error ====================

  Color get colorError => antParseColor(css.colorError);
  Color get colorErrorBg => antParseColor(css.colorErrorBg);
  Color get colorErrorBgHover => antParseColor(css.colorErrorBgHover);
  Color get colorErrorBgHoverFilled => antParseColor(css.colorErrorBgHoverFilled);
  Color get colorErrorBgActive => antParseColor(css.colorErrorBgActive);
  Color get colorErrorBorder => antParseColor(css.colorErrorBorder);
  Color get colorErrorBorderHover => antParseColor(css.colorErrorBorderHover);
  Color get colorErrorHover => antParseColor(css.colorErrorHover);
  Color get colorErrorActive => antParseColor(css.colorErrorActive);
  Color get colorErrorTextHover => antParseColor(css.colorErrorTextHover);
  Color get colorErrorText => antParseColor(css.colorErrorText);
  Color get colorErrorTextActive => antParseColor(css.colorErrorTextActive);
  Color get colorErrorOutline => antParseColor(css.colorErrorOutline);
  Color get colorErrorAffix => antParseColor(css.colorErrorAffix);

  // ==================== Info ====================

  Color get colorInfo => antParseColor(css.colorInfo);
  Color get colorInfoBg => antParseColor(css.colorInfoBg);
  Color get colorInfoBgHover => antParseColor(css.colorInfoBgHover);
  Color get colorInfoBorder => antParseColor(css.colorInfoBorder);
  Color get colorInfoBorderHover => antParseColor(css.colorInfoBorderHover);
  Color get colorInfoHover => antParseColor(css.colorInfoHover);
  Color get colorInfoActive => antParseColor(css.colorInfoActive);
  Color get colorInfoTextHover => antParseColor(css.colorInfoTextHover);
  Color get colorInfoText => antParseColor(css.colorInfoText);
  Color get colorInfoTextActive => antParseColor(css.colorInfoTextActive);

  // ==================== Link ====================

  Color get colorLink => antParseColor(css.colorLink);
  Color get colorLinkHover => antParseColor(css.colorLinkHover);
  Color get colorLinkActive => antParseColor(css.colorLinkActive);

  // ==================== Control ====================

  Color get controlOutline => antParseColor(css.controlOutline);
  Color get controlTmpOutline => antParseColor(css.controlTmpOutline);
  Color get controlItemBgHover => antParseColor(css.controlItemBgHover);
  Color get controlItemBgActive => antParseColor(css.controlItemBgActive);
  Color get controlItemBgActiveHover => antParseColor(css.controlItemBgActiveHover);
  Color get controlItemBgActiveDisabled => antParseColor(css.controlItemBgActiveDisabled);
  Color get colorWarningOutline => antParseColor(css.colorWarningOutline);
  Color get colorWarningAffix => antParseColor(css.colorWarningAffix);

  // ==================== Factory ====================

  /// 从种子生成亮色主题颜色令牌。
  factory AntColorTokens.light(AntSeedToken seed) {
    return AntColorTokens._generate(seed, isDark: false);
  }

  /// 从种子生成暗色主题颜色令牌。
  factory AntColorTokens.dark(AntSeedToken seed) {
    return AntColorTokens._generate(seed, isDark: true);
  }

  factory AntColorTokens._generate(AntSeedToken seed, {required bool isDark}) {
    // ---- 基色 ----
    final colorBgBase = seed.colorBgBase.isNotEmpty
        ? seed.colorBgBase
        : (isDark ? '#000' : '#fff');
    final colorTextBase = seed.colorTextBase.isNotEmpty
        ? seed.colorTextBase
        : (isDark ? '#fff' : '#000');
    final colorShadow = seed.colorShadow.isNotEmpty
        ? seed.colorShadow
        : (isDark ? 'rgba(255, 255, 255, 0.2)' : '#000');

    // ---- 色板 ----
    List<String> genPalette(String baseColor) {
      final raw = antGeneratePalette(
        baseColor,
        AntPaletteOptions(theme: isDark ? 'dark' : 'default'),
      );
      return isDark ? _mapDark(raw) : _mapLight(raw);
    }

    final primary = genPalette(seed.colorPrimary);
    final success = genPalette(seed.colorSuccess);
    final warning = genPalette(seed.colorWarning);
    final error = genPalette(seed.colorError);
    final info = genPalette(seed.colorInfo);
    final linkSeed = seed.colorLink.isNotEmpty ? seed.colorLink : seed.colorInfo;
    final link = genPalette(linkSeed);

    // ---- 中性色算法 ----
    String alpha(String base, double a) => _getAlphaColor(base, a);
    String solid(String base, double b) =>
        isDark ? _getSolidColorDark(base, b) : _getSolidColorLight(base, b);

    // ---- 错误色特殊 ----
    final errorBgHoverFilled = AntFastColor.of(error[1])
        .mix(AntFastColor.of(error[3]), 50)
        .toHexString();

    // ---- 构建 CSS 令牌 ----
    final css = AntColorTokensCss(
      // 基色
      colorBgBase: colorBgBase,
      colorTextBase: colorTextBase,
      colorWhite: '#fff',
      colorShadow: colorShadow,
      colorBgMask: AntFastColor.of('#000').setA(0.45).toRgbString(),

      // 文字
      colorText: alpha(colorTextBase, isDark ? 0.85 : 0.88),
      colorTextSecondary: alpha(colorTextBase, 0.65),
      colorTextTertiary: alpha(colorTextBase, 0.45),
      colorTextQuaternary: alpha(colorTextBase, 0.25),

      // 填充
      colorFill: alpha(colorTextBase, isDark ? 0.18 : 0.15),
      colorFillSecondary: alpha(colorTextBase, isDark ? 0.12 : 0.06),
      colorFillTertiary: alpha(colorTextBase, isDark ? 0.08 : 0.04),
      colorFillQuaternary: alpha(colorTextBase, isDark ? 0.04 : 0.02),

      // 实底背景
      colorBgSolid: alpha(colorTextBase, isDark ? 0.95 : 1),
      colorBgSolidHover: alpha(colorTextBase, isDark ? 1 : 0.75),
      colorBgSolidActive: alpha(colorTextBase, isDark ? 0.9 : 0.95),

      // 背景
      colorBgLayout: solid(colorBgBase, isDark ? 0 : 4),
      colorBgContainer: solid(colorBgBase, isDark ? 8 : 0),
      colorBgElevated: solid(colorBgBase, isDark ? 12 : 0),
      colorBgSpotlight: isDark
          ? solid(colorBgBase, 26)
          : alpha(colorTextBase, 0.85),
      colorBgBlur: isDark ? alpha(colorTextBase, 0.04) : 'transparent',

      // 边框
      colorBorder: solid(colorBgBase, isDark ? 26 : 15),
      colorBorderDisabled: solid(colorBgBase, isDark ? 26 : 15),
      colorBorderSecondary: solid(colorBgBase, isDark ? 19 : 6),

      // Primary
      colorPrimaryBg: primary[0],
      colorPrimaryBgHover: primary[1],
      colorPrimaryBorder: primary[2],
      colorPrimaryBorderHover: primary[3],
      colorPrimaryHover: primary[4],
      colorPrimary: primary[5],
      colorPrimaryActive: primary[6],
      colorPrimaryTextHover: primary[7],
      colorPrimaryText: primary[8],
      colorPrimaryTextActive: primary[9],

      // Success
      colorSuccessBg: success[0],
      colorSuccessBgHover: success[1],
      colorSuccessBorder: success[2],
      colorSuccessBorderHover: success[3],
      colorSuccessHover: success[3],
      colorSuccess: success[5],
      colorSuccessActive: success[6],
      colorSuccessTextHover: success[7],
      colorSuccessText: success[8],
      colorSuccessTextActive: success[9],

      // Error
      colorErrorBg: error[0],
      colorErrorBgHover: error[1],
      colorErrorBgHoverFilled: errorBgHoverFilled,
      colorErrorBgActive: error[2],
      colorErrorBorder: error[2],
      colorErrorBorderHover: error[3],
      colorErrorHover: error[4],
      colorError: error[5],
      colorErrorActive: error[6],
      colorErrorTextHover: error[7],
      colorErrorText: error[8],
      colorErrorTextActive: error[9],

      // Warning
      colorWarningBg: warning[0],
      colorWarningBgHover: warning[1],
      colorWarningBorder: warning[2],
      colorWarningBorderHover: warning[3],
      colorWarningHover: warning[3],
      colorWarning: warning[5],
      colorWarningActive: warning[6],
      colorWarningTextHover: warning[7],
      colorWarningText: warning[8],
      colorWarningTextActive: warning[9],

      // Info
      colorInfoBg: info[0],
      colorInfoBgHover: info[1],
      colorInfoBorder: info[2],
      colorInfoBorderHover: info[3],
      colorInfoHover: info[3],
      colorInfo: info[5],
      colorInfoActive: info[6],
      colorInfoTextHover: info[7],
      colorInfoText: info[8],
      colorInfoTextActive: info[9],

      // Link
      colorLinkHover: link[3],
      colorLink: link[5],
      colorLinkActive: link[6],
    );

    // ---- 暗色主题覆盖 ----
    // colorPrimaryBg = colorPrimaryBorder, colorPrimaryBgHover = colorPrimaryBorderHover
    final mergedCss = isDark
        ? css.copyWith(
            colorPrimaryBg: css.colorPrimaryBorder,
            colorPrimaryBgHover: css.colorPrimaryBorderHover,
          )
        : css;

    // ---- 别名令牌 ----
    final aliasCss = _generateAlias(mergedCss);

    return AntColorTokens._(css: aliasCss, isDark: isDark);
  }

  static AntColorTokensCss _generateAlias(AntColorTokensCss map) {
    return map.copyWith(
      // Background
      colorFillContent: map.colorFillSecondary,
      colorFillContentHover: map.colorFill,
      colorFillAlter: map.colorFillQuaternary,
      colorBgContainerDisabled: map.colorFillTertiary,

      // Split
      colorBorderBg: map.colorBgContainer,
      colorSplit: _getAlphaColorOnBg(map.colorBorderSecondary, map.colorBgContainer),

      // Text
      colorTextPlaceholder: map.colorTextQuaternary,
      colorTextDisabled: map.colorTextQuaternary,
      colorTextHeading: map.colorText,
      colorTextLabel: map.colorTextSecondary,
      colorTextDescription: map.colorTextTertiary,
      colorTextLightSolid: map.colorWhite,
      colorHighlight: map.colorError,
      colorBgTextHover: map.colorFillSecondary,
      colorBgTextActive: map.colorFill,

      colorIcon: map.colorTextTertiary,
      colorIconHover: map.colorText,

      colorErrorOutline: _getAlphaColorOnBg(map.colorErrorBg, map.colorBgContainer),
      colorWarningOutline: _getAlphaColorOnBg(map.colorWarningBg, map.colorBgContainer),
      colorErrorAffix: map.colorError,
      colorWarningAffix: map.colorWarning,

      // Control
      controlItemBgHover: map.colorFillTertiary,
      controlItemBgActive: map.colorPrimaryBg,
      controlItemBgActiveHover: map.colorPrimaryBgHover,
      controlItemBgActiveDisabled: map.colorFill,
      controlTmpOutline: map.colorFillQuaternary,
      controlOutline: _getAlphaColorOnBg(map.colorPrimaryBg, map.colorBgContainer),
    );
  }
}

// ============================================================
// AntColorTokensCss — CSS 字符串形式的颜色令牌
// ============================================================

/// CSS 字符串形式的颜色令牌（原始值，调试与导出用）。
class AntColorTokensCss {
  // 基色
  final String colorBgBase;
  final String colorTextBase;
  final String colorWhite;
  final String colorShadow;
  final String colorBgMask;

  // 文字
  final String colorText;
  final String colorTextSecondary;
  final String colorTextTertiary;
  final String colorTextQuaternary;
  final String colorTextHeading;
  final String colorTextLabel;
  final String colorTextDescription;
  final String colorTextLightSolid;
  final String colorTextPlaceholder;
  final String colorTextDisabled;
  final String colorHighlight;
  final String colorIcon;
  final String colorIconHover;

  // 填充
  final String colorFill;
  final String colorFillSecondary;
  final String colorFillTertiary;
  final String colorFillQuaternary;
  final String colorFillContent;
  final String colorFillContentHover;
  final String colorFillAlter;

  // 背景
  final String colorBgContainer;
  final String colorBgElevated;
  final String colorBgLayout;
  final String colorBgSpotlight;
  final String colorBgBlur;
  final String colorBgContainerDisabled;
  final String colorBgSolid;
  final String colorBgSolidHover;
  final String colorBgSolidActive;
  final String colorBgTextHover;
  final String colorBgTextActive;

  // 边框
  final String colorBorder;
  final String colorBorderSecondary;
  final String colorBorderDisabled;
  final String colorBorderBg;
  final String colorSplit;

  // Primary
  final String colorPrimary;
  final String colorPrimaryBg;
  final String colorPrimaryBgHover;
  final String colorPrimaryBorder;
  final String colorPrimaryBorderHover;
  final String colorPrimaryHover;
  final String colorPrimaryActive;
  final String colorPrimaryTextHover;
  final String colorPrimaryText;
  final String colorPrimaryTextActive;

  // Success
  final String colorSuccess;
  final String colorSuccessBg;
  final String colorSuccessBgHover;
  final String colorSuccessBorder;
  final String colorSuccessBorderHover;
  final String colorSuccessHover;
  final String colorSuccessActive;
  final String colorSuccessTextHover;
  final String colorSuccessText;
  final String colorSuccessTextActive;

  // Error
  final String colorError;
  final String colorErrorBg;
  final String colorErrorBgHover;
  final String colorErrorBgHoverFilled;
  final String colorErrorBgActive;
  final String colorErrorBorder;
  final String colorErrorBorderHover;
  final String colorErrorHover;
  final String colorErrorActive;
  final String colorErrorTextHover;
  final String colorErrorText;
  final String colorErrorTextActive;
  final String colorErrorOutline;
  final String colorErrorAffix;

  // Warning
  final String colorWarning;
  final String colorWarningBg;
  final String colorWarningBgHover;
  final String colorWarningBorder;
  final String colorWarningBorderHover;
  final String colorWarningHover;
  final String colorWarningActive;
  final String colorWarningTextHover;
  final String colorWarningText;
  final String colorWarningTextActive;
  final String colorWarningOutline;
  final String colorWarningAffix;

  // Info
  final String colorInfo;
  final String colorInfoBg;
  final String colorInfoBgHover;
  final String colorInfoBorder;
  final String colorInfoBorderHover;
  final String colorInfoHover;
  final String colorInfoActive;
  final String colorInfoTextHover;
  final String colorInfoText;
  final String colorInfoTextActive;

  // Link
  final String colorLink;
  final String colorLinkHover;
  final String colorLinkActive;

  // Control
  final String controlOutline;
  final String controlTmpOutline;
  final String controlItemBgHover;
  final String controlItemBgActive;
  final String controlItemBgActiveHover;
  final String controlItemBgActiveDisabled;

  const AntColorTokensCss({
    required this.colorBgBase,
    required this.colorTextBase,
    required this.colorWhite,
    required this.colorShadow,
    required this.colorBgMask,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextTertiary,
    required this.colorTextQuaternary,
    this.colorTextHeading = '',
    this.colorTextLabel = '',
    this.colorTextDescription = '',
    this.colorTextLightSolid = '',
    this.colorTextPlaceholder = '',
    this.colorTextDisabled = '',
    this.colorHighlight = '',
    this.colorIcon = '',
    this.colorIconHover = '',
    required this.colorFill,
    required this.colorFillSecondary,
    required this.colorFillTertiary,
    required this.colorFillQuaternary,
    this.colorFillContent = '',
    this.colorFillContentHover = '',
    this.colorFillAlter = '',
    required this.colorBgContainer,
    required this.colorBgElevated,
    required this.colorBgLayout,
    required this.colorBgSpotlight,
    required this.colorBgBlur,
    this.colorBgContainerDisabled = '',
    required this.colorBgSolid,
    required this.colorBgSolidHover,
    required this.colorBgSolidActive,
    this.colorBgTextHover = '',
    this.colorBgTextActive = '',
    required this.colorBorder,
    required this.colorBorderSecondary,
    required this.colorBorderDisabled,
    this.colorBorderBg = '',
    this.colorSplit = '',
    required this.colorPrimary,
    required this.colorPrimaryBg,
    required this.colorPrimaryBgHover,
    required this.colorPrimaryBorder,
    required this.colorPrimaryBorderHover,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorPrimaryTextHover,
    required this.colorPrimaryText,
    required this.colorPrimaryTextActive,
    required this.colorSuccess,
    required this.colorSuccessBg,
    required this.colorSuccessBgHover,
    required this.colorSuccessBorder,
    required this.colorSuccessBorderHover,
    required this.colorSuccessHover,
    required this.colorSuccessActive,
    required this.colorSuccessTextHover,
    required this.colorSuccessText,
    required this.colorSuccessTextActive,
    required this.colorError,
    required this.colorErrorBg,
    required this.colorErrorBgHover,
    required this.colorErrorBgHoverFilled,
    required this.colorErrorBgActive,
    required this.colorErrorBorder,
    required this.colorErrorBorderHover,
    required this.colorErrorHover,
    required this.colorErrorActive,
    required this.colorErrorTextHover,
    required this.colorErrorText,
    required this.colorErrorTextActive,
    this.colorErrorOutline = '',
    this.colorErrorAffix = '',
    required this.colorWarning,
    required this.colorWarningBg,
    required this.colorWarningBgHover,
    required this.colorWarningBorder,
    required this.colorWarningBorderHover,
    required this.colorWarningHover,
    required this.colorWarningActive,
    required this.colorWarningTextHover,
    required this.colorWarningText,
    required this.colorWarningTextActive,
    this.colorWarningOutline = '',
    this.colorWarningAffix = '',
    required this.colorInfo,
    required this.colorInfoBg,
    required this.colorInfoBgHover,
    required this.colorInfoBorder,
    required this.colorInfoBorderHover,
    required this.colorInfoHover,
    required this.colorInfoActive,
    required this.colorInfoTextHover,
    required this.colorInfoText,
    required this.colorInfoTextActive,
    required this.colorLink,
    required this.colorLinkHover,
    required this.colorLinkActive,
    this.controlOutline = '',
    this.controlTmpOutline = '',
    this.controlItemBgHover = '',
    this.controlItemBgActive = '',
    this.controlItemBgActiveHover = '',
    this.controlItemBgActiveDisabled = '',
  });

  AntColorTokensCss copyWith({
    String? colorPrimaryBg,
    String? colorPrimaryBgHover,
    String? colorFillContent,
    String? colorFillContentHover,
    String? colorFillAlter,
    String? colorBgContainerDisabled,
    String? colorBorderBg,
    String? colorSplit,
    String? colorTextPlaceholder,
    String? colorTextDisabled,
    String? colorTextHeading,
    String? colorTextLabel,
    String? colorTextDescription,
    String? colorTextLightSolid,
    String? colorHighlight,
    String? colorBgTextHover,
    String? colorBgTextActive,
    String? colorIcon,
    String? colorIconHover,
    String? colorErrorOutline,
    String? colorWarningOutline,
    String? colorErrorAffix,
    String? colorWarningAffix,
    String? controlItemBgHover,
    String? controlItemBgActive,
    String? controlItemBgActiveHover,
    String? controlItemBgActiveDisabled,
    String? controlTmpOutline,
    String? controlOutline,
  }) {
    return AntColorTokensCss(
      colorBgBase: colorBgBase,
      colorTextBase: colorTextBase,
      colorWhite: colorWhite,
      colorShadow: colorShadow,
      colorBgMask: colorBgMask,
      colorText: colorText,
      colorTextSecondary: colorTextSecondary,
      colorTextTertiary: colorTextTertiary,
      colorTextQuaternary: colorTextQuaternary,
      colorTextHeading: colorTextHeading ?? this.colorTextHeading,
      colorTextLabel: colorTextLabel ?? this.colorTextLabel,
      colorTextDescription: colorTextDescription ?? this.colorTextDescription,
      colorTextLightSolid: colorTextLightSolid ?? this.colorTextLightSolid,
      colorTextPlaceholder: colorTextPlaceholder ?? this.colorTextPlaceholder,
      colorTextDisabled: colorTextDisabled ?? this.colorTextDisabled,
      colorHighlight: colorHighlight ?? this.colorHighlight,
      colorIcon: colorIcon ?? this.colorIcon,
      colorIconHover: colorIconHover ?? this.colorIconHover,
      colorFill: colorFill,
      colorFillSecondary: colorFillSecondary,
      colorFillTertiary: colorFillTertiary,
      colorFillQuaternary: colorFillQuaternary,
      colorFillContent: colorFillContent ?? this.colorFillContent,
      colorFillContentHover: colorFillContentHover ?? this.colorFillContentHover,
      colorFillAlter: colorFillAlter ?? this.colorFillAlter,
      colorBgContainer: colorBgContainer,
      colorBgElevated: colorBgElevated,
      colorBgLayout: colorBgLayout,
      colorBgSpotlight: colorBgSpotlight,
      colorBgBlur: colorBgBlur,
      colorBgContainerDisabled: colorBgContainerDisabled ?? this.colorBgContainerDisabled,
      colorBgSolid: colorBgSolid,
      colorBgSolidHover: colorBgSolidHover,
      colorBgSolidActive: colorBgSolidActive,
      colorBgTextHover: colorBgTextHover ?? this.colorBgTextHover,
      colorBgTextActive: colorBgTextActive ?? this.colorBgTextActive,
      colorBorder: colorBorder,
      colorBorderSecondary: colorBorderSecondary,
      colorBorderDisabled: colorBorderDisabled,
      colorBorderBg: colorBorderBg ?? this.colorBorderBg,
      colorSplit: colorSplit ?? this.colorSplit,
      colorPrimary: colorPrimary,
      colorPrimaryBg: colorPrimaryBg ?? this.colorPrimaryBg,
      colorPrimaryBgHover: colorPrimaryBgHover ?? this.colorPrimaryBgHover,
      colorPrimaryBorder: colorPrimaryBorder,
      colorPrimaryBorderHover: colorPrimaryBorderHover,
      colorPrimaryHover: colorPrimaryHover,
      colorPrimaryActive: colorPrimaryActive,
      colorPrimaryTextHover: colorPrimaryTextHover,
      colorPrimaryText: colorPrimaryText,
      colorPrimaryTextActive: colorPrimaryTextActive,
      colorSuccess: colorSuccess,
      colorSuccessBg: colorSuccessBg,
      colorSuccessBgHover: colorSuccessBgHover,
      colorSuccessBorder: colorSuccessBorder,
      colorSuccessBorderHover: colorSuccessBorderHover,
      colorSuccessHover: colorSuccessHover,
      colorSuccessActive: colorSuccessActive,
      colorSuccessTextHover: colorSuccessTextHover,
      colorSuccessText: colorSuccessText,
      colorSuccessTextActive: colorSuccessTextActive,
      colorError: colorError,
      colorErrorBg: colorErrorBg,
      colorErrorBgHover: colorErrorBgHover,
      colorErrorBgHoverFilled: colorErrorBgHoverFilled,
      colorErrorBgActive: colorErrorBgActive,
      colorErrorBorder: colorErrorBorder,
      colorErrorBorderHover: colorErrorBorderHover,
      colorErrorHover: colorErrorHover,
      colorErrorActive: colorErrorActive,
      colorErrorTextHover: colorErrorTextHover,
      colorErrorText: colorErrorText,
      colorErrorTextActive: colorErrorTextActive,
      colorErrorOutline: colorErrorOutline ?? this.colorErrorOutline,
      colorErrorAffix: colorErrorAffix ?? this.colorErrorAffix,
      colorWarning: colorWarning,
      colorWarningBg: colorWarningBg,
      colorWarningBgHover: colorWarningBgHover,
      colorWarningBorder: colorWarningBorder,
      colorWarningBorderHover: colorWarningBorderHover,
      colorWarningHover: colorWarningHover,
      colorWarningActive: colorWarningActive,
      colorWarningTextHover: colorWarningTextHover,
      colorWarningText: colorWarningText,
      colorWarningTextActive: colorWarningTextActive,
      colorWarningOutline: colorWarningOutline ?? this.colorWarningOutline,
      colorWarningAffix: colorWarningAffix ?? this.colorWarningAffix,
      colorInfo: colorInfo,
      colorInfoBg: colorInfoBg,
      colorInfoBgHover: colorInfoBgHover,
      colorInfoBorder: colorInfoBorder,
      colorInfoBorderHover: colorInfoBorderHover,
      colorInfoHover: colorInfoHover,
      colorInfoActive: colorInfoActive,
      colorInfoTextHover: colorInfoTextHover,
      colorInfoText: colorInfoText,
      colorInfoTextActive: colorInfoTextActive,
      colorLink: colorLink,
      colorLinkHover: colorLinkHover,
      colorLinkActive: colorLinkActive,
      controlOutline: controlOutline ?? this.controlOutline,
      controlTmpOutline: controlTmpOutline ?? this.controlTmpOutline,
      controlItemBgHover: controlItemBgHover ?? this.controlItemBgHover,
      controlItemBgActive: controlItemBgActive ?? this.controlItemBgActive,
      controlItemBgActiveHover: controlItemBgActiveHover ?? this.controlItemBgActiveHover,
      controlItemBgActiveDisabled: controlItemBgActiveDisabled ?? this.controlItemBgActiveDisabled,
    );
  }
}