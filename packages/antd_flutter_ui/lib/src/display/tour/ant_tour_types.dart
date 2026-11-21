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
// AntTourStep — 引导步骤
// ============================================================

/// 漫游式引导的单个步骤。
///
/// 对齐 antd React Tour 的 TourStep：[target] 为空时卡片全屏居中，
/// [title] / [description] 为卡片文字内容，
/// [placement] / [mask] / [arrow] 可覆盖 [AntTour] 的同名配置。
class AntTourStep {
  const AntTourStep({
    this.target,
    this.title,
    this.description,
    this.cover,
    this.placement,
    this.mask,
    this.arrow,
  });

  /// 引导卡片指向的目标元素（为空时卡片全屏居中）。
  final GlobalKey? target;

  /// 步骤标题。
  final String? title;

  /// 步骤描述内容。
  final String? description;

  /// 步骤顶部展示的封面（图片或自定义 Widget）。
  final Widget? cover;

  /// 引导卡片位置（覆盖 Tour 级配置）。
  final AntTourPlacement? placement;

  /// 是否显示遮罩（覆盖 Tour 级配置）。
  final bool? mask;

  /// 是否显示箭头（覆盖 Tour 级配置）。
  final bool? arrow;
}
