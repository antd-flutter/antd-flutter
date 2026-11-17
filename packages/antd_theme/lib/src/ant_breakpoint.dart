/// Ant Design 响应式断点。
///
/// 对应 antd Grid 的断点定义：
/// - xs: ≥480
/// - sm: ≥576
/// - md: ≥768
/// - lg: ≥992
/// - xl: ≥1200
/// - xxl: ≥1600
/// - xxxl: ≥1920
///
/// 断点枚举 [AntBreakpoint] 拆分至 `enum/ant_breakpoint_type.dart`。
///
/// @docImport 'enum/ant_breakpoint_type.dart';
library;

import 'package:flutter/widgets.dart';

import 'enum/ant_breakpoint_type.dart';

/// 断点判断工具。
///
/// ```dart
/// if (AntBreakpoints.isUp(context, AntBreakpoint.md)) {
///   // ≥768 逻辑
/// }
/// ```
class AntBreakpoints {
  AntBreakpoints._();

  /// 屏幕宽度是否 ≥ [bp] 的最小宽度。
  static bool isUp(BuildContext context, AntBreakpoint bp) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= bp.minWidth;
  }

  /// 屏幕宽度是否 < [bp] 的最小宽度。
  static bool isDown(BuildContext context, AntBreakpoint bp) {
    final width = MediaQuery.sizeOf(context).width;
    return width < bp.minWidth;
  }

  /// 屏幕宽度是否在 [min] 和 [max] 之间（含边界）。
  static bool isBetween(
    BuildContext context,
    AntBreakpoint min,
    AntBreakpoint max,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= min.minWidth && width < max.minWidth;
  }
}
