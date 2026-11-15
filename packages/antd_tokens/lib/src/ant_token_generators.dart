/// Ant Design Token 派生算法。
///
/// 精确移植 antd `themes/shared/` 下的生成函数：
/// - `genFontSizes` / `genFontMapToken`
/// - `genRadius`
/// - `genSizeMapToken`
/// - `genControlHeight`
/// - `genCommonMapToken`
library;

import 'dart:math' as math;

// ============================================================
// genFontSizes — 字号阶梯算法
// ============================================================

/// 字号-行高对。
class AntFontSizePair {
  final double size;
  final double lineHeight;
  const AntFontSizePair(this.size, this.lineHeight);
}

/// 计算行高。
///
/// 与 antd `getLineHeight` 一致: `(fontSize + 8) / fontSize`。
double antGetLineHeight(double fontSize) => (fontSize + 8) / fontSize;

/// 生成 10 阶字号表。
///
/// 与 antd `genFontSizes` 一致:
/// - `size = base * e^(i/5)`，`i = index - 1`
/// - `index > 1` 时 floor，否则 ceil
/// - 再 `floor(intSize / 2) * 2` 取偶
/// - `fontSizes[1] = base`（index=1，即数组第 2 位）
List<AntFontSizePair> antGenFontSizes(double base) {
  final fontSizes = List<AntFontSizePair>.generate(10, (index) {
    final i = index - 1;
    final baseSize = base * math.exp(i / 5);
    final intSize = index > 1 ? baseSize.floor() : baseSize.ceil();

    // 取偶
    final evenSize = (intSize / 2).floor() * 2;
    return AntFontSizePair(evenSize.toDouble(), antGetLineHeight(evenSize.toDouble()));
  });

  // fontSizes[1] = base
  fontSizes[1] = AntFontSizePair(base, antGetLineHeight(base));

  return fontSizes;
}

// ============================================================
// genFontMapToken — 字号映射令牌
// ============================================================

/// 字号映射令牌。
class AntFontMapToken {
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

  const AntFontMapToken({
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
  });
}

/// 从基准字号生成字号映射令牌。
AntFontMapToken antGenFontMapToken(double fontSize) {
  final pairs = antGenFontSizes(fontSize);
  final fontSizes = pairs.map((p) => p.size).toList();
  final lineHeights = pairs.map((p) => p.lineHeight).toList();

  final fontSizeMD = fontSizes[1];
  final fontSizeSM = fontSizes[0];
  final fontSizeLG = fontSizes[2];
  final lineHeight = lineHeights[1];
  final lineHeightSM = lineHeights[0];
  final lineHeightLG = lineHeights[2];

  return AntFontMapToken(
    fontSizeSM: fontSizeSM,
    fontSize: fontSizeMD,
    fontSizeLG: fontSizeLG,
    fontSizeXL: fontSizes[3],
    fontSizeHeading1: fontSizes[6],
    fontSizeHeading2: fontSizes[5],
    fontSizeHeading3: fontSizes[4],
    fontSizeHeading4: fontSizes[3],
    fontSizeHeading5: fontSizes[2],
    lineHeight: lineHeight,
    lineHeightLG: lineHeightLG,
    lineHeightSM: lineHeightSM,
    fontHeight: (lineHeight * fontSizeMD).roundToDouble(),
    fontHeightLG: (lineHeightLG * fontSizeLG).roundToDouble(),
    fontHeightSM: (lineHeightSM * fontSizeSM).roundToDouble(),
    lineHeightHeading1: lineHeights[6],
    lineHeightHeading2: lineHeights[5],
    lineHeightHeading3: lineHeights[4],
    lineHeightHeading4: lineHeights[3],
    lineHeightHeading5: lineHeights[2],
  );
}

// ============================================================
// genRadius — 圆角阶梯算法
// ============================================================

/// 圆角令牌。
class AntRadiusToken {
  /// 基础圆角。
  final double borderRadius;

  /// XS 圆角。
  final double borderRadiusXS;

  /// SM 圆角。
  final double borderRadiusSM;

  /// LG 圆角。
  final double borderRadiusLG;

  /// 外部圆角。
  final double borderRadiusOuter;

  const AntRadiusToken({
    required this.borderRadius,
    required this.borderRadiusXS,
    required this.borderRadiusSM,
    required this.borderRadiusLG,
    required this.borderRadiusOuter,
  });
}

/// 从圆角基数生成圆角令牌。
///
/// 与 antd `genRadius` 一致。
AntRadiusToken antGenRadius(double radiusBase) {
  var radiusLG = radiusBase;
  var radiusSM = radiusBase;
  var radiusXS = radiusBase;
  var radiusOuter = radiusBase;

  // radiusLG
  if (radiusBase < 6 && radiusBase >= 5) {
    radiusLG = radiusBase + 1;
  } else if (radiusBase < 16 && radiusBase >= 6) {
    radiusLG = radiusBase + 2;
  } else if (radiusBase >= 16) {
    radiusLG = 16;
  }

  // radiusSM
  if (radiusBase < 7 && radiusBase >= 5) {
    radiusSM = 4;
  } else if (radiusBase < 8 && radiusBase >= 7) {
    radiusSM = 5;
  } else if (radiusBase < 14 && radiusBase >= 8) {
    radiusSM = 6;
  } else if (radiusBase < 16 && radiusBase >= 14) {
    radiusSM = 7;
  } else if (radiusBase >= 16) {
    radiusSM = 8;
  }

  // radiusXS
  if (radiusBase < 6 && radiusBase >= 2) {
    radiusXS = 1;
  } else if (radiusBase >= 6) {
    radiusXS = 2;
  }

  // radiusOuter
  if (radiusBase > 4 && radiusBase < 8) {
    radiusOuter = 4;
  } else if (radiusBase >= 8) {
    radiusOuter = 6;
  }

  return AntRadiusToken(
    borderRadius: radiusBase,
    borderRadiusXS: radiusXS,
    borderRadiusSM: radiusSM,
    borderRadiusLG: radiusLG,
    borderRadiusOuter: radiusOuter,
  );
}

// ============================================================
// genSizeMapToken — 尺寸映射令牌
// ============================================================

/// 尺寸映射令牌。
class AntSizeMapToken {
  final double sizeXXL;
  final double sizeXL;
  final double sizeLG;
  final double sizeMD;
  final double sizeMS;
  final double size;
  final double sizeSM;
  final double sizeXS;
  final double sizeXXS;

  const AntSizeMapToken({
    required this.sizeXXL,
    required this.sizeXL,
    required this.sizeLG,
    required this.sizeMD,
    required this.sizeMS,
    required this.size,
    required this.sizeSM,
    required this.sizeXS,
    required this.sizeXXS,
  });
}

/// 从种子生成尺寸映射令牌。
AntSizeMapToken antGenSizeMapToken({
  required double sizeUnit,
  required double sizeStep,
}) {
  return AntSizeMapToken(
    sizeXXL: sizeUnit * (sizeStep + 8), // 48
    sizeXL: sizeUnit * (sizeStep + 4), // 32
    sizeLG: sizeUnit * (sizeStep + 2), // 24
    sizeMD: sizeUnit * (sizeStep + 1), // 20
    sizeMS: sizeUnit * sizeStep, // 16
    size: sizeUnit * sizeStep, // 16
    sizeSM: sizeUnit * (sizeStep - 1), // 12
    sizeXS: sizeUnit * (sizeStep - 2), // 8
    sizeXXS: sizeUnit * (sizeStep - 3), // 4
  );
}

// ============================================================
// genControlHeight — 控件高度令牌
// ============================================================

/// 控件高度令牌。
class AntControlHeightToken {
  final double controlHeightSM;
  final double controlHeightXS;
  final double controlHeightLG;

  const AntControlHeightToken({
    required this.controlHeightSM,
    required this.controlHeightXS,
    required this.controlHeightLG,
  });
}

/// 从基准控件高度生成高度令牌。
AntControlHeightToken antGenControlHeight(double controlHeight) {
  return AntControlHeightToken(
    controlHeightSM: controlHeight * 0.75,
    controlHeightXS: controlHeight * 0.5,
    controlHeightLG: controlHeight * 1.25,
  );
}

// ============================================================
// genCommonMapToken — 通用映射令牌（动效 + 线宽 + 圆角）
// ============================================================

/// 动效时长令牌。
class AntMotionDurationToken {
  /// 快速动效时长（秒）。
  final double fast;

  /// 中速动效时长（秒）。
  final double mid;

  /// 慢速动效时长（秒）。
  final double slow;

  const AntMotionDurationToken({
    required this.fast,
    required this.mid,
    required this.slow,
  });
}

/// 从种子生成动效时长令牌。
AntMotionDurationToken antGenMotionDuration({
  required double motionUnit,
  required double motionBase,
  required bool motion,
}) {
  if (!motion) {
    return const AntMotionDurationToken(fast: 0, mid: 0, slow: 0);
  }
  double fmt(double v) => double.parse(v.toStringAsFixed(1));
  return AntMotionDurationToken(
    fast: fmt(motionBase + motionUnit),
    mid: fmt(motionBase + motionUnit * 2),
    slow: fmt(motionBase + motionUnit * 3),
  );
}