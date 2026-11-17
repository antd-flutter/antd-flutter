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
///
/// 由 [antGenFontSizes] 生成，对应 antd 字号阶梯中的单项。
class AntFontSizePair {
  /// 字号（逻辑像素），恒为偶数（除 [antGenFontSizes] 中回填的基准字号外）。
  final double size;

  /// 推荐行高，按 `(size + 8) / size` 计算。
  final double lineHeight;
  const AntFontSizePair(this.size, this.lineHeight);
}

/// Computes the line height for a font size.
///
/// 与 antd `getLineHeight` 一致：`(fontSize + 8) / fontSize`。
///
/// ```dart
/// antGetLineHeight(14); // 22 / 14 ≈ 1.5714
/// ```
double antGetLineHeight(double fontSize) => (fontSize + 8) / fontSize;

/// Generates the 10-step font size ladder from a base size.
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

/// 字号映射令牌，对应 antd Map Token 的字体部分（`genFontMapToken`）。
///
/// 由 [antGenFontMapToken] 从基准字号派生，包含组件字号、
/// 标题字号、行高与 fontHeight 三组映射。
class AntFontMapToken {
  /// 小号组件字号（阶梯 index 0）。
  final double fontSizeSM;
  /// 默认组件字号（等于基准字号）。
  final double fontSize;

  /// 大号组件字号（阶梯 index 2）。
  final double fontSizeLG;
  /// 特大号组件字号（阶梯 index 3）。
  final double fontSizeXL;
  /// 标题 1 字号（阶梯 index 6，最大）。
  final double fontSizeHeading1;
  /// 标题 2 字号（阶梯 index 5）。
  final double fontSizeHeading2;
  /// 标题 3 字号（阶梯 index 4）。
  final double fontSizeHeading3;
  /// 标题 4 字号（阶梯 index 3）。
  final double fontSizeHeading4;
  /// 标题 5 字号（阶梯 index 2）。
  final double fontSizeHeading5;

  /// 默认行高（对应 [AntFontSizePair.lineHeight] index 1）。
  final double lineHeight;

  /// 大号文本行高（阶梯 index 2）。
  final double lineHeightLG;
  /// 小号文本行高（阶梯 index 0）。
  final double lineHeightSM;

  /// 默认 fontHeight（`lineHeight * fontSize` 四舍五入取整）。
  final double fontHeight;

  /// 大号 fontHeight。
  final double fontHeightLG;
  /// 小号 fontHeight。
  final double fontHeightSM;

  /// 标题 1 行高。
  final double lineHeightHeading1;
  /// 标题 2 行高。
  final double lineHeightHeading2;
  /// 标题 3 行高。
  final double lineHeightHeading3;
  /// 标题 4 行高。
  final double lineHeightHeading4;
  /// 标题 5 行高。
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

/// Generates the font map token from a base font size.
///
/// 对应 antd `genFontMapToken`：先经 [antGenFontSizes] 生成阶梯，
/// 再按固定索引映射为组件字号 / 标题字号 / 行高 / fontHeight。
///
/// ```dart
/// final font = antGenFontMapToken(14);
/// font.fontSize;        // 14
/// font.fontSizeHeading1; // 38
/// ```
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

/// 圆角令牌，对应 antd Map Token 的圆角部分（`genRadius`）。
///
/// 由 [antGenRadius] 从圆角基数派生各档位圆角。
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

/// Generates the radius token ladder from a base radius.
///
/// 与 antd `genRadius` 一致：按基数所在区间分别推导
/// XS/SM/LG/Outer 各档位（如基数 6 → LG 8、SM 6、XS 2、Outer 4）。
///
/// ```dart
/// final radius = antGenRadius(6);
/// radius.borderRadiusLG; // 8
/// ```
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

/// 尺寸映射令牌，对应 antd Map Token 的尺寸部分（`genSizeMapToken`）。
///
/// 由 [antGenSizeMapToken] 从 `sizeUnit × sizeStep` 派生 XXS…XXL 间距阶梯。
class AntSizeMapToken {
  /// 特大间距（`unit × (step + 8)`，默认 48）。
  final double sizeXXL;
  /// 超大间距（`unit × (step + 4)`，默认 32）。
  final double sizeXL;
  /// 大间距（`unit × (step + 2)`，默认 24）。
  final double sizeLG;
  /// 中间距（`unit × (step + 1)`，默认 20）。
  final double sizeMD;
  /// 中小间距（`unit × step`，默认 16）。
  final double sizeMS;
  /// 默认间距（`unit × step`，默认 16）。
  final double size;

  /// 小间距（`unit × (step - 1)`，默认 12）。
  final double sizeSM;
  /// 特小间距（`unit × (step - 2)`，默认 8）。
  final double sizeXS;
  /// 极小间距（`unit × (step - 3)`，默认 4）。
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

/// Generates the size map token from seed size values.
///
/// 对应 antd `genSizeMapToken`，公式为 `sizeUnit * (sizeStep ± n)`。
///
/// ```dart
/// final size = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
/// size.sizeXXL; // 48
/// size.sizeXXS; // 4
/// ```
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

/// 控件高度令牌，对应 antd Map Token 的控件高度部分（`genControlHeight`）。
///
/// 由 [antGenControlHeight] 从基准高度按比例派生。
class AntControlHeightToken {
  /// 小号控件高度（基准 × 0.75）。
  final double controlHeightSM;

  /// 特小号控件高度（基准 × 0.5）。
  final double controlHeightXS;

  /// 大号控件高度（基准 × 1.25）。
  final double controlHeightLG;

  const AntControlHeightToken({
    required this.controlHeightSM,
    required this.controlHeightXS,
    required this.controlHeightLG,
  });
}

/// Generates control height variants from a base height.
///
/// 对应 antd `genControlHeight`：SM = 0.75 ×、XS = 0.5 ×、LG = 1.25 ×。
///
/// ```dart
/// final h = antGenControlHeight(32);
/// h.controlHeightLG; // 40
/// ```
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

/// 动效时长令牌，对应 antd Map Token 的 `motionDuration*` 系列。
///
/// 由 [antGenMotionDuration] 从 `motionBase + motionUnit × n` 派生。
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

/// Generates motion duration tokens from seed motion values.
///
/// 对应 antd `genCommonMapToken` 中的动效部分：
/// fast = base + unit、mid = base + 2 × unit、slow = base + 3 × unit，
/// 结果保留一位小数；`motion` 为 `false` 时全部归零。
///
/// ```dart
/// final m = antGenMotionDuration(motionUnit: 0.1, motionBase: 0, motion: true);
/// m.mid; // 0.2
/// ```
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