/// Ant Design 主题数据。
///
/// 从 [AntSeedToken] 生成完整的主题令牌集，
/// 对应 antd Seed → Map → Alias 三层令牌推导链。
library;

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import 'package:antd_tokens/antd_tokens.dart';

/// Ant Design 主题数据 — 完整令牌集。
///
/// 包含 antd `AliasToken` 的全部字段，以 Flutter 原生类型提供。
class AntThemeData {
  AntThemeData._({
    required this.seed,
    required this.colors,
    required this.isDark,
    required this.font,
    required this.radius,
    required this.sizes,
    required this.controlHeights,
    required this.motion,
    required this.shadows,
    required this.screen,
  });

  /// 种子令牌（原始输入）。
  final AntSeedToken seed;

  /// 颜色令牌集。
  final AntColorTokens colors;

  /// 是否暗色主题。
  final bool isDark;

  /// 字体令牌。
  final AntFontTokens font;

  /// 圆角令牌。
  final AntRadiusTokens radius;

  /// 尺寸令牌。
  final AntSizeTokens sizes;

  /// 控件高度令牌。
  final AntControlHeightTokens controlHeights;

  /// 动效令牌。
  final AntMotionTokens motion;

  /// 阴影令牌。
  final AntShadowTokens shadows;

  /// 屏幕断点令牌。
  final AntScreenTokens screen;

  // ============================================================
  // 便捷颜色访问器（转发到 colors）
  // ============================================================

  Color get colorPrimary => colors.colorPrimary;
  Color get colorSuccess => colors.colorSuccess;
  Color get colorWarning => colors.colorWarning;
  Color get colorError => colors.colorError;
  Color get colorInfo => colors.colorInfo;
  Color get colorLink => colors.colorLink;
  Color get colorText => colors.colorText;
  Color get colorTextSecondary => colors.colorTextSecondary;
  Color get colorTextTertiary => colors.colorTextTertiary;
  Color get colorTextQuaternary => colors.colorTextQuaternary;
  Color get colorTextHeading => colors.colorTextHeading;
  Color get colorTextLabel => colors.colorTextLabel;
  Color get colorTextDescription => colors.colorTextDescription;
  Color get colorTextLightSolid => colors.colorTextLightSolid;
  Color get colorTextPlaceholder => colors.colorTextPlaceholder;
  Color get colorTextDisabled => colors.colorTextDisabled;
  Color get colorHighlight => colors.colorHighlight;
  Color get colorIcon => colors.colorIcon;
  Color get colorIconHover => colors.colorIconHover;
  Color get colorBgBase => colors.colorBgBase;
  Color get colorBgContainer => colors.colorBgContainer;
  Color get colorBgElevated => colors.colorBgElevated;
  Color get colorBgLayout => colors.colorBgLayout;
  Color get colorBgSpotlight => colors.colorBgSpotlight;
  Color get colorBgBlur => colors.colorBgBlur;
  Color get colorBgMask => colors.colorBgMask;
  Color get colorBgContainerDisabled => colors.colorBgContainerDisabled;
  Color get colorBgSolid => colors.colorBgSolid;
  Color get colorBgSolidHover => colors.colorBgSolidHover;
  Color get colorBgSolidActive => colors.colorBgSolidActive;
  Color get colorBgTextHover => colors.colorBgTextHover;
  Color get colorBgTextActive => colors.colorBgTextActive;
  Color get colorBorder => colors.colorBorder;
  Color get colorBorderSecondary => colors.colorBorderSecondary;
  Color get colorBorderDisabled => colors.colorBorderDisabled;
  Color get colorBorderBg => colors.colorBorderBg;
  Color get colorSplit => colors.colorSplit;
  Color get colorFill => colors.colorFill;
  Color get colorFillSecondary => colors.colorFillSecondary;
  Color get colorFillTertiary => colors.colorFillTertiary;
  Color get colorFillQuaternary => colors.colorFillQuaternary;
  Color get colorFillContent => colors.colorFillContent;
  Color get colorFillContentHover => colors.colorFillContentHover;
  Color get colorFillAlter => colors.colorFillAlter;
  Color get colorWhite => colors.colorWhite;
  Color get colorShadow => colors.colorShadow;
  Color get colorPrimaryBg => colors.colorPrimaryBg;
  Color get colorPrimaryBgHover => colors.colorPrimaryBgHover;
  Color get colorPrimaryBorder => colors.colorPrimaryBorder;
  Color get colorPrimaryBorderHover => colors.colorPrimaryBorderHover;
  Color get colorPrimaryHover => colors.colorPrimaryHover;
  Color get colorPrimaryActive => colors.colorPrimaryActive;
  Color get colorPrimaryTextHover => colors.colorPrimaryTextHover;
  Color get colorPrimaryText => colors.colorPrimaryText;
  Color get colorPrimaryTextActive => colors.colorPrimaryTextActive;
  Color get colorSuccessBg => colors.colorSuccessBg;
  Color get colorSuccessBgHover => colors.colorSuccessBgHover;
  Color get colorSuccessBorder => colors.colorSuccessBorder;
  Color get colorSuccessBorderHover => colors.colorSuccessBorderHover;
  Color get colorSuccessHover => colors.colorSuccessHover;
  Color get colorSuccessActive => colors.colorSuccessActive;
  Color get colorSuccessTextHover => colors.colorSuccessTextHover;
  Color get colorSuccessText => colors.colorSuccessText;
  Color get colorSuccessTextActive => colors.colorSuccessTextActive;
  Color get colorWarningBg => colors.colorWarningBg;
  Color get colorWarningBgHover => colors.colorWarningBgHover;
  Color get colorWarningBorder => colors.colorWarningBorder;
  Color get colorWarningBorderHover => colors.colorWarningBorderHover;
  Color get colorWarningHover => colors.colorWarningHover;
  Color get colorWarningActive => colors.colorWarningActive;
  Color get colorWarningTextHover => colors.colorWarningTextHover;
  Color get colorWarningText => colors.colorWarningText;
  Color get colorWarningTextActive => colors.colorWarningTextActive;
  Color get colorErrorBg => colors.colorErrorBg;
  Color get colorErrorBgHover => colors.colorErrorBgHover;
  Color get colorErrorBgActive => colors.colorErrorBgActive;
  Color get colorErrorBorder => colors.colorErrorBorder;
  Color get colorErrorBorderHover => colors.colorErrorBorderHover;
  Color get colorErrorHover => colors.colorErrorHover;
  Color get colorErrorActive => colors.colorErrorActive;
  Color get colorErrorTextHover => colors.colorErrorTextHover;
  Color get colorErrorText => colors.colorErrorText;
  Color get colorErrorTextActive => colors.colorErrorTextActive;
  Color get colorErrorOutline => colors.colorErrorOutline;
  Color get colorWarningOutline => colors.colorWarningOutline;
  Color get colorErrorAffix => colors.colorErrorAffix;
  Color get colorWarningAffix => colors.colorWarningAffix;
  Color get colorInfoBg => colors.colorInfoBg;
  Color get colorInfoBgHover => colors.colorInfoBgHover;
  Color get colorInfoBorder => colors.colorInfoBorder;
  Color get colorInfoBorderHover => colors.colorInfoBorderHover;
  Color get colorInfoHover => colors.colorInfoHover;
  Color get colorInfoActive => colors.colorInfoActive;
  Color get colorInfoTextHover => colors.colorInfoTextHover;
  Color get colorInfoText => colors.colorInfoText;
  Color get colorInfoTextActive => colors.colorInfoTextActive;
  Color get colorLinkHover => colors.colorLinkHover;
  Color get colorLinkActive => colors.colorLinkActive;
  Color get controlOutline => colors.controlOutline;
  Color get controlTmpOutline => colors.controlTmpOutline;
  Color get controlItemBgHover => colors.controlItemBgHover;
  Color get controlItemBgActive => colors.controlItemBgActive;
  Color get controlItemBgActiveHover => colors.controlItemBgActiveHover;
  Color get controlItemBgActiveDisabled => colors.controlItemBgActiveDisabled;

  // ============================================================
  // 字体便捷访问器
  // ============================================================

  String get fontFamily => seed.fontFamily;
  String get fontFamilyCode => seed.fontFamilyCode;
  double get fontSize => font.fontSize;
  double get fontSizeSM => font.fontSizeSM;
  double get fontSizeLG => font.fontSizeLG;
  double get fontSizeXL => font.fontSizeXL;
  double get fontSizeHeading1 => font.fontSizeHeading1;
  double get fontSizeHeading2 => font.fontSizeHeading2;
  double get fontSizeHeading3 => font.fontSizeHeading3;
  double get fontSizeHeading4 => font.fontSizeHeading4;
  double get fontSizeHeading5 => font.fontSizeHeading5;
  double get fontSizeIcon => font.fontSizeIcon;
  double get lineHeight => font.lineHeight;
  double get lineHeightSM => font.lineHeightSM;
  double get lineHeightLG => font.lineHeightLG;
  double get fontHeight => font.fontHeight;
  double get fontHeightSM => font.fontHeightSM;
  double get fontHeightLG => font.fontHeightLG;
  double get lineHeightHeading1 => font.lineHeightHeading1;
  double get lineHeightHeading2 => font.lineHeightHeading2;
  double get lineHeightHeading3 => font.lineHeightHeading3;
  double get lineHeightHeading4 => font.lineHeightHeading4;
  double get lineHeightHeading5 => font.lineHeightHeading5;
  int get fontWeightStrong => font.fontWeightStrong;

  // ============================================================
  // 圆角便捷访问器
  // ============================================================

  double get borderRadius => radius.borderRadius;
  double get borderRadiusXS => radius.borderRadiusXS;
  double get borderRadiusSM => radius.borderRadiusSM;
  double get borderRadiusLG => radius.borderRadiusLG;
  double get borderRadiusOuter => radius.borderRadiusOuter;

  // ============================================================
  // 尺寸便捷访问器
  // ============================================================

  double get sizeXXS => sizes.sizeXXS;
  double get sizeXS => sizes.sizeXS;
  double get sizeSM => sizes.sizeSM;
  double get size => sizes.size;
  double get sizeMS => sizes.sizeMS;
  double get sizeMD => sizes.sizeMD;
  double get sizeLG => sizes.sizeLG;
  double get sizeXL => sizes.sizeXL;
  double get sizeXXL => sizes.sizeXXL;
  double get sizePopupArrow => seed.sizePopupArrow;

  // ============================================================
  // 控件高度便捷访问器
  // ============================================================

  double get controlHeight => seed.controlHeight;
  double get controlHeightSM => controlHeights.controlHeightSM;
  double get controlHeightXS => controlHeights.controlHeightXS;
  double get controlHeightLG => controlHeights.controlHeightLG;
  double get controlInteractiveSize => controlHeights.controlInteractiveSize;

  // ============================================================
  // 间距便捷访问器（Alias 层）
  // ============================================================

  double get paddingXXS => sizes.sizeXXS;
  double get paddingXS => sizes.sizeXS;
  double get paddingSM => sizes.sizeSM;
  double get padding => sizes.size;
  double get paddingMD => sizes.sizeMD;
  double get paddingLG => sizes.sizeLG;
  double get paddingXL => sizes.sizeXL;
  double get paddingContentHorizontalLG => sizes.sizeLG;
  double get paddingContentVerticalLG => sizes.sizeMS;
  double get paddingContentHorizontal => sizes.sizeMS;
  double get paddingContentVertical => sizes.sizeSM;
  double get paddingContentHorizontalSM => sizes.size;
  double get paddingContentVerticalSM => sizes.sizeXS;
  double get controlPaddingHorizontal => 12;
  double get controlPaddingHorizontalSM => 8;

  double get marginXXS => sizes.sizeXXS;
  double get marginXS => sizes.sizeXS;
  double get marginSM => sizes.sizeSM;
  double get margin => sizes.size;
  double get marginMD => sizes.sizeMD;
  double get marginLG => sizes.sizeLG;
  double get marginXL => sizes.sizeXL;
  double get marginXXL => sizes.sizeXXL;

  // ============================================================
  // 线宽便捷访问器
  // ============================================================

  double get lineWidth => seed.lineWidth;
  double get lineWidthBold => seed.lineWidth + 1;
  double get lineWidthFocus => seed.focusOutline ? seed.lineWidth * 3 : 0;
  double get controlOutlineWidth => seed.lineWidth * 2;
  String get lineType => seed.lineType;

  // ============================================================
  // 动效便捷访问器
  // ============================================================

  Duration get motionDurationFast => motion.fast;
  Duration get motionDurationMid => motion.mid;
  Duration get motionDurationSlow => motion.slow;
  Curve get motionEaseOutCirc => motion.easeOutCirc;
  Curve get motionEaseInOutCirc => motion.easeInOutCirc;
  Curve get motionEaseOut => motion.easeOut;
  Curve get motionEaseInOut => motion.easeInOut;
  Curve get motionEaseOutBack => motion.easeOutBack;
  Curve get motionEaseInBack => motion.easeInBack;
  Curve get motionEaseInQuint => motion.easeInQuint;
  Curve get motionEaseOutQuint => motion.easeOutQuint;

  // ============================================================
  // 阴影便捷访问器
  // ============================================================

  List<BoxShadow> get boxShadow => shadows.boxShadow;
  List<BoxShadow> get boxShadowSecondary => shadows.boxShadowSecondary;
  List<BoxShadow> get boxShadowTertiary => shadows.boxShadowTertiary;
  List<BoxShadow> get boxShadowPopoverArrow => shadows.boxShadowPopoverArrow;
  List<BoxShadow> get boxShadowCard => shadows.boxShadowCard;
  List<BoxShadow> get boxShadowDrawerRight => shadows.boxShadowDrawerRight;
  List<BoxShadow> get boxShadowDrawerLeft => shadows.boxShadowDrawerLeft;
  List<BoxShadow> get boxShadowDrawerUp => shadows.boxShadowDrawerUp;
  List<BoxShadow> get boxShadowDrawerDown => shadows.boxShadowDrawerDown;
  List<BoxShadow> get boxShadowTabsOverflowLeft => shadows.boxShadowTabsOverflowLeft;
  List<BoxShadow> get boxShadowTabsOverflowRight => shadows.boxShadowTabsOverflowRight;
  List<BoxShadow> get boxShadowTabsOverflowTop => shadows.boxShadowTabsOverflowTop;
  List<BoxShadow> get boxShadowTabsOverflowBottom => shadows.boxShadowTabsOverflowBottom;

  // ============================================================
  // Z-Index / 透明度
  // ============================================================

  int get zIndexBase => seed.zIndexBase;
  int get zIndexPopupBase => seed.zIndexPopupBase;
  double get opacityLoading => 0.65;
  double get opacityImage => seed.opacityImage;

  // ============================================================
  // 屏幕断点便捷访问器
  // ============================================================

  int get screenXS => screen.xs;
  int get screenXSMin => screen.xsMin;
  int get screenXSMax => screen.xsMax;
  int get screenSM => screen.sm;
  int get screenSMMin => screen.smMin;
  int get screenSMMax => screen.smMax;
  int get screenMD => screen.md;
  int get screenMDMin => screen.mdMin;
  int get screenMDMax => screen.mdMax;
  int get screenLG => screen.lg;
  int get screenLGMin => screen.lgMin;
  int get screenLGMax => screen.lgMax;
  int get screenXL => screen.xl;
  int get screenXLMin => screen.xlMin;
  int get screenXLMax => screen.xlMax;
  int get screenXXL => screen.xxl;
  int get screenXXLMin => screen.xxlMin;
  int get screenXXLMax => screen.xxlMax;
  int get screenXXXL => screen.xxxl;
  int get screenXXXLMin => screen.xxxlMin;

  // ============================================================
  // Factory
  // ============================================================

  /// 从种子生成亮色主题。
  factory AntThemeData.light([AntSeedToken? seed]) {
    return AntThemeData._fromSeed(seed ?? const AntSeedToken(), isDark: false);
  }

  /// 从种子生成暗色主题。
  factory AntThemeData.dark([AntSeedToken? seed]) {
    return AntThemeData._fromSeed(
      seed ?? AntSeedToken.dark(),
      isDark: true,
    );
  }

  /// 从种子生成主题（自动判断亮/暗）。
  factory AntThemeData.fromSeed(AntSeedToken seed, {bool isDark = false}) {
    return AntThemeData._fromSeed(seed, isDark: isDark);
  }

  factory AntThemeData._fromSeed(AntSeedToken seed, {required bool isDark}) {
    // ---- 颜色 ----
    final colors = isDark
        ? AntColorTokens.dark(seed)
        : AntColorTokens.light(seed);

    // ---- 字体 ----
    final fontMap = antGenFontMapToken(seed.fontSize);
    final font = AntFontTokens(
      fontSizeSM: fontMap.fontSizeSM,
      fontSize: fontMap.fontSize,
      fontSizeLG: fontMap.fontSizeLG,
      fontSizeXL: fontMap.fontSizeXL,
      fontSizeHeading1: fontMap.fontSizeHeading1,
      fontSizeHeading2: fontMap.fontSizeHeading2,
      fontSizeHeading3: fontMap.fontSizeHeading3,
      fontSizeHeading4: fontMap.fontSizeHeading4,
      fontSizeHeading5: fontMap.fontSizeHeading5,
      lineHeight: fontMap.lineHeight,
      lineHeightLG: fontMap.lineHeightLG,
      lineHeightSM: fontMap.lineHeightSM,
      fontHeight: fontMap.fontHeight,
      fontHeightLG: fontMap.fontHeightLG,
      fontHeightSM: fontMap.fontHeightSM,
      lineHeightHeading1: fontMap.lineHeightHeading1,
      lineHeightHeading2: fontMap.lineHeightHeading2,
      lineHeightHeading3: fontMap.lineHeightHeading3,
      lineHeightHeading4: fontMap.lineHeightHeading4,
      lineHeightHeading5: fontMap.lineHeightHeading5,
      fontSizeIcon: fontMap.fontSizeSM,
      fontWeightStrong: 600,
    );

    // ---- 圆角 ----
    final radiusMap = antGenRadius(seed.borderRadius);
    final radius = AntRadiusTokens(
      borderRadius: radiusMap.borderRadius,
      borderRadiusXS: radiusMap.borderRadiusXS,
      borderRadiusSM: radiusMap.borderRadiusSM,
      borderRadiusLG: radiusMap.borderRadiusLG,
      borderRadiusOuter: radiusMap.borderRadiusOuter,
    );

    // ---- 尺寸 ----
    final sizeMap = antGenSizeMapToken(
      sizeUnit: seed.sizeUnit,
      sizeStep: seed.sizeStep,
    );
    final sizes = AntSizeTokens(
      sizeXXS: sizeMap.sizeXXS,
      sizeXS: sizeMap.sizeXS,
      sizeSM: sizeMap.sizeSM,
      size: sizeMap.size,
      sizeMS: sizeMap.sizeMS,
      sizeMD: sizeMap.sizeMD,
      sizeLG: sizeMap.sizeLG,
      sizeXL: sizeMap.sizeXL,
      sizeXXL: sizeMap.sizeXXL,
    );

    // ---- 控件高度 ----
    final heightMap = antGenControlHeight(seed.controlHeight);
    final controlHeights = AntControlHeightTokens(
      controlHeightSM: heightMap.controlHeightSM,
      controlHeightXS: heightMap.controlHeightXS,
      controlHeightLG: heightMap.controlHeightLG,
      controlInteractiveSize: seed.controlHeight / 2,
    );

    // ---- 动效 ----
    final motionMap = antGenMotionDuration(
      motionUnit: seed.motionUnit,
      motionBase: seed.motionBase,
      motion: seed.motion,
    );
    final motion = AntMotionTokens(
      fast: Duration(milliseconds: (motionMap.fast * 1000).round()),
      mid: Duration(milliseconds: (motionMap.mid * 1000).round()),
      slow: Duration(milliseconds: (motionMap.slow * 1000).round()),
      easeOutCirc: _parseCubicBezier(seed.motionEaseOutCirc),
      easeInOutCirc: _parseCubicBezier(seed.motionEaseInOutCirc),
      easeOut: _parseCubicBezier(seed.motionEaseOut),
      easeInOut: _parseCubicBezier(seed.motionEaseInOut),
      easeOutBack: _parseCubicBezier(seed.motionEaseOutBack),
      easeInBack: _parseCubicBezier(seed.motionEaseInBack),
      easeInQuint: _parseCubicBezier(seed.motionEaseInQuint),
      easeOutQuint: _parseCubicBezier(seed.motionEaseOutQuint),
    );

    // ---- 阴影 ----
    final shadows = AntShadowTokens.generate(colors.css.colorShadow);

    // ---- 屏幕 ----
    const screen = AntScreenTokens._defaults();

    return AntThemeData._(
      seed: seed,
      colors: colors,
      isDark: isDark,
      font: font,
      radius: radius,
      sizes: sizes,
      controlHeights: controlHeights,
      motion: motion,
      shadows: shadows,
      screen: screen,
    );
  }

  /// 解析 CSS cubic-bezier 为 Flutter [Curve]。
  static Curve _parseCubicBezier(String css) {
    final match = RegExp(r'cubic-bezier\(([^)]+)\)').firstMatch(css);
    if (match == null) return Curves.ease;
    final parts = match.group(1)!.split(',').map((s) => double.parse(s.trim())).toList();
    if (parts.length != 4) return Curves.ease;
    return Cubic(parts[0], parts[1], parts[2], parts[3]);
  }
}

// ============================================================
// 子令牌类
// ============================================================

/// 字体令牌。
class AntFontTokens {
  final double fontSizeSM;
  final double fontSize;
  final double fontSizeLG;
  final double fontSizeXL;
  final double fontSizeHeading1;
  final double fontSizeHeading2;
  final double fontSizeHeading3;
  final double fontSizeHeading4;
  final double fontSizeHeading5;
  final double lineHeight;
  final double lineHeightLG;
  final double lineHeightSM;
  final double fontHeight;
  final double fontHeightLG;
  final double fontHeightSM;
  final double lineHeightHeading1;
  final double lineHeightHeading2;
  final double lineHeightHeading3;
  final double lineHeightHeading4;
  final double lineHeightHeading5;
  final double fontSizeIcon;
  final int fontWeightStrong;

  const AntFontTokens({
    required this.fontSizeSM,
    required this.fontSize,
    required this.fontSizeLG,
    required this.fontSizeXL,
    required this.fontSizeHeading1,
    required this.fontSizeHeading2,
    required this.fontSizeHeading3,
    required this.fontSizeHeading4,
    required this.fontSizeHeading5,
    required this.lineHeight,
    required this.lineHeightLG,
    required this.lineHeightSM,
    required this.fontHeight,
    required this.fontHeightLG,
    required this.fontHeightSM,
    required this.lineHeightHeading1,
    required this.lineHeightHeading2,
    required this.lineHeightHeading3,
    required this.lineHeightHeading4,
    required this.lineHeightHeading5,
    required this.fontSizeIcon,
    required this.fontWeightStrong,
  });
}

/// 圆角令牌。
class AntRadiusTokens {
  final double borderRadius;
  final double borderRadiusXS;
  final double borderRadiusSM;
  final double borderRadiusLG;
  final double borderRadiusOuter;

  const AntRadiusTokens({
    required this.borderRadius,
    required this.borderRadiusXS,
    required this.borderRadiusSM,
    required this.borderRadiusLG,
    required this.borderRadiusOuter,
  });
}

/// 尺寸令牌。
class AntSizeTokens {
  final double sizeXXS;
  final double sizeXS;
  final double sizeSM;
  final double size;
  final double sizeMS;
  final double sizeMD;
  final double sizeLG;
  final double sizeXL;
  final double sizeXXL;

  const AntSizeTokens({
    required this.sizeXXS,
    required this.sizeXS,
    required this.sizeSM,
    required this.size,
    required this.sizeMS,
    required this.sizeMD,
    required this.sizeLG,
    required this.sizeXL,
    required this.sizeXXL,
  });
}

/// 控件高度令牌。
class AntControlHeightTokens {
  final double controlHeightSM;
  final double controlHeightXS;
  final double controlHeightLG;
  final double controlInteractiveSize;

  const AntControlHeightTokens({
    required this.controlHeightSM,
    required this.controlHeightXS,
    required this.controlHeightLG,
    required this.controlInteractiveSize,
  });
}

/// 动效令牌。
class AntMotionTokens {
  final Duration fast;
  final Duration mid;
  final Duration slow;
  final Curve easeOutCirc;
  final Curve easeInOutCirc;
  final Curve easeOut;
  final Curve easeInOut;
  final Curve easeOutBack;
  final Curve easeInBack;
  final Curve easeInQuint;
  final Curve easeOutQuint;

  const AntMotionTokens({
    required this.fast,
    required this.mid,
    required this.slow,
    required this.easeOutCirc,
    required this.easeInOutCirc,
    required this.easeOut,
    required this.easeInOut,
    required this.easeOutBack,
    required this.easeInBack,
    required this.easeInQuint,
    required this.easeOutQuint,
  });
}

/// 屏幕断点令牌。
class AntScreenTokens {
  final int xs;
  final int xsMin;
  final int xsMax;
  final int sm;
  final int smMin;
  final int smMax;
  final int md;
  final int mdMin;
  final int mdMax;
  final int lg;
  final int lgMin;
  final int lgMax;
  final int xl;
  final int xlMin;
  final int xlMax;
  final int xxl;
  final int xxlMin;
  final int xxlMax;
  final int xxxl;
  final int xxxlMin;

  const AntScreenTokens({
    this.xs = 480,
    this.xsMin = 480,
    this.xsMax = 575,
    this.sm = 576,
    this.smMin = 576,
    this.smMax = 767,
    this.md = 768,
    this.mdMin = 768,
    this.mdMax = 991,
    this.lg = 992,
    this.lgMin = 992,
    this.lgMax = 1199,
    this.xl = 1200,
    this.xlMin = 1200,
    this.xlMax = 1599,
    this.xxl = 1600,
    this.xxlMin = 1600,
    this.xxlMax = 1919,
    this.xxxl = 1920,
    this.xxxlMin = 1920,
  });

  const AntScreenTokens._defaults()
      : xs = 480,
        xsMin = 480,
        xsMax = 575,
        sm = 576,
        smMin = 576,
        smMax = 767,
        md = 768,
        mdMin = 768,
        mdMax = 991,
        lg = 992,
        lgMin = 992,
        lgMax = 1199,
        xl = 1200,
        xlMin = 1200,
        xlMax = 1599,
        xxl = 1600,
        xxlMin = 1600,
        xxlMax = 1919,
        xxxl = 1920,
        xxxlMin = 1920;
}