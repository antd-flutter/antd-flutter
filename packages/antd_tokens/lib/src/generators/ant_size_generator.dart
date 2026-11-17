/// Ant Design 尺寸 令牌生成器。
///
/// 精确移植 antd `themes/shared/genSizeMapToken`。
library;

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
