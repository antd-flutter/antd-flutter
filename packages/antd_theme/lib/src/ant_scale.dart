import 'package:flutter/widgets.dart';

import 'ant_platform.dart';

/// 统一缩放因子 —— 所有设计尺寸乘以该因子。
///
/// 设计值（antd 的 14 / 40 / 16 / 8 等）是 1.0 倍下的逻辑像素；
/// 需要整体放大/缩小时只改 [factor]，控件内的 `t.s(12)` 与
/// 主题 token（fontSize / controlHeight / borderRadius / size*）
/// 全部随之变化。
///
/// ```dart
/// AntTheme(data: AntThemeData.light(scale: const AntScale(1.15)), child: ...)
/// // 或按设备自动推导
/// AntTheme(data: AntThemeData.light(scale: AntScale.auto(context)), child: ...)
/// ```
@immutable
class AntScale {
  const AntScale(this.factor) : assert(factor > 0, 'factor must be > 0');

  /// 缩放倍数，1.0 = 设计值原样。
  final double factor;

  /// 不缩放。
  static const AntScale none = AntScale(1);

  /// 按设备短边自动推导（仅移动端生效）。
  ///
  /// - 基准 [base]：短边 / base 得到因子；
  /// - [min]/[max]：夹取范围，避免小屏过小、大屏过大；
  /// - 桌面（macOS/Windows/Linux/Web 桌面）恒为 [none]。
  factory AntScale.auto(
    BuildContext context, {
    double base = 375,
    double min = 0.9,
    double max = 1.2,
  }) {
    if (AntPlatform.isDesktop) return none;
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    if (!shortest.isFinite || shortest <= 0) return none;
    return AntScale((shortest / base).clamp(min, max));
  }

  /// 设计值 → 实际值（组件内唯一入口）。
  double call(num designValue) => designValue * factor;

  AntScale copyWith({double? factor}) => AntScale(factor ?? this.factor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AntScale && other.factor == factor;

  @override
  int get hashCode => factor.hashCode;

  @override
  String toString() => 'AntScale($factor)';
}
