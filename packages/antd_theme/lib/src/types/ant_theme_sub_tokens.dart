/// AntThemeData 子令牌数据类。
///
/// 字体 / 圆角 / 尺寸 / 控件高度 / 动效 / 屏幕断点六组纯数据令牌，
/// 由 [AntThemeData]（`../ant_theme_data.dart`）从 antd Map Token 派生后持有。
///
/// @docImport '../ant_theme_data.dart';
library;

import 'package:flutter/animation.dart';

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
}

