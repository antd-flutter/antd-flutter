/// Ant Design 动效时长 令牌生成器。
///
/// 精确移植 antd `themes/shared/genCommonMapToken 动效部分`。
library;

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
