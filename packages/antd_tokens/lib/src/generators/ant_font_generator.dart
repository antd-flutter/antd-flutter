/// Ant Design 字体令牌生成器。
///
/// 精确移植 antd `themes/shared/genFontSizes` 与 `genFontMapToken`，
/// 从基准字号派生 10 阶字号阶梯与字号映射令牌。
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
