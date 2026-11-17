/// Ant Design 圆角 令牌生成器。
///
/// 精确移植 antd `themes/shared/genRadius`。
library;

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
/// 区间阈值请勿调整，否则会破坏与 antd 的一致性。
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
