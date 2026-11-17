/// Ant Design 控件高度 令牌生成器。
///
/// 精确移植 antd `themes/shared/genControlHeight`。
library;

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
