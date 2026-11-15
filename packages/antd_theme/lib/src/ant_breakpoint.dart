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
library;

import 'package:flutter/widgets.dart';

/// Ant Design 响应式断点枚举。
///
/// 与 antd `Grid` 的 `Breakpoint` 一致，值从小到大排列。
enum AntBreakpoint {
  /// 超小屏（≥480）
  xs(480),

  /// 小屏（≥576）
  sm(576),

  /// 中屏（≥768）
  md(768),

  /// 大屏（≥992）
  lg(992),

  /// 超大屏（≥1200）
  xl(1200),

  /// 特大屏（≥1600）
  xxl(1600),

  /// 巨屏（≥1920）
  xxxl(1920);

  /// 断点最小宽度（逻辑像素）。
  final int minWidth;

  const AntBreakpoint(this.minWidth);

  /// 从屏幕宽度解析当前命中的最大断点。
  ///
  /// 返回宽度满足 `minWidth` 的最大断点；若宽度小于 480 返回 null。
  static AntBreakpoint? fromWidth(double width) {
    assert(width >= 0, 'width must be non-negative');
    AntBreakpoint? result;
    for (final bp in AntBreakpoint.values) {
      if (width >= bp.minWidth) {
        result = bp;
      }
    }
    return result;
  }

  /// 从 [BuildContext] 解析当前断点（基于窗口宽度）。
  static AntBreakpoint? of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return fromWidth(width);
  }

  /// 当前断点是否 ≥ [other]。
  bool operator >=(AntBreakpoint other) => index >= other.index;

  /// 当前断点是否 ≤ [other]。
  bool operator <=(AntBreakpoint other) => index <= other.index;

  /// 当前断点是否 > [other]。
  bool operator >(AntBreakpoint other) => index > other.index;

  /// 当前断点是否 < [other]。
  bool operator <(AntBreakpoint other) => index < other.index;
}

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