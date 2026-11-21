/// AntTour 类型定义 — antd React Tour 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

// ============================================================
// AntTourPlacement — 引导卡片位置
// ============================================================

/// 引导卡片相对于目标元素的位置（对齐 antd v6 Tour placement）。
///
/// - 居中：[center]（无 target 时也使用居中）
/// - 上：[topLeft] / [topCenter] / [topRight]
/// - 下：[bottomLeft] / [bottomCenter] / [bottomRight]
/// - 左：[leftTop] / [leftCenter] / [leftBottom]
/// - 右：[rightTop] / [rightCenter] / [rightBottom]
enum AntTourPlacement {
  /// 屏幕居中（无 target 时默认）。
  center,

  /// 上方，左对齐。
  topLeft,

  /// 上方，水平居中。
  topCenter,

  /// 上方，右对齐。
  topRight,

  /// 下方，左对齐。
  bottomLeft,

  /// 下方，水平居中（默认）。
  bottomCenter,

  /// 下方，右对齐。
  bottomRight,

  /// 左侧，顶部对齐。
  leftTop,

  /// 左侧，垂直居中。
  leftCenter,

  /// 左侧，底部对齐。
  leftBottom,

  /// 右侧，顶部对齐。
  rightTop,

  /// 右侧，垂直居中。
  rightCenter,

  /// 右侧，底部对齐。
  rightBottom,
}

// ============================================================
// 构建器
// ============================================================

/// 步骤目标元素提取器（用于挖孔定位，返回 null 时卡片居中）。
typedef AntTourTargetOf<T> = GlobalKey? Function(T step);

/// 步骤标题构建器（返回 null 时不展示标题）。
typedef AntTourTitleBuilder<T> = Widget? Function(
  BuildContext context,
  T step,
  int index,
);

/// 步骤描述构建器（返回 null 时不展示描述）。
typedef AntTourDescriptionBuilder<T> = Widget? Function(
  BuildContext context,
  T step,
  int index,
);

/// 步骤封面构建器（返回 null 时不展示封面）。
typedef AntTourCoverBuilder<T> = Widget? Function(
  BuildContext context,
  T step,
);

/// 步骤位置提取器（覆盖 Tour 级 placement）。
typedef AntTourPlacementOf<T> = AntTourPlacement? Function(T step);

/// 步骤是否显示遮罩提取器（覆盖 Tour 级 mask）。
typedef AntTourMaskOf<T> = bool? Function(T step);

/// 步骤是否显示箭头提取器（覆盖 Tour 级 arrow）。
typedef AntTourArrowOf<T> = bool? Function(T step);
