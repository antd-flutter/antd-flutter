/// AntFloatButton 类型定义 — 与 antd React FloatButton API 对齐
library;

import 'package:flutter/widgets.dart';

/// 悬浮按钮类型。
enum AntFloatButtonType {
  /// 默认类型 — 白底 + 深色图标。
  normal,

  /// 主色类型 — 主色底 + 白色图标。
  primary,
}

/// 悬浮按钮形状。
enum AntFloatButtonShape {
  /// 圆形（默认）。
  circle,

  /// 方形。
  square,
}

/// 悬浮按钮组的展开触发方式。
enum AntFloatButtonGroupTrigger {
  /// 点击触发按钮展开/收起。
  click,

  /// 悬停展开，移开收起。
  hover,
}

/// 悬浮按钮组的列表弹出方位。
enum AntFloatButtonGroupPlacement {
  /// 列表在触发按钮上方（默认）。
  top,

  /// 列表在触发按钮下方。
  bottom,

  /// 列表在触发按钮左侧。
  left,

  /// 列表在触发按钮右侧。
  right,
}

/// 悬浮按钮角标配置 — 对应 antd `FloatButtonBadgeProps`。
class AntFloatButtonBadge {
  const AntFloatButtonBadge({
    this.count,
    this.dot = false,
    this.color,
    this.overflowCount = 99,
  });

  /// 角标数字，为 0 时不显示。
  final int? count;

  /// 是否显示为圆点（优先于 [count]）。
  final bool dot;

  /// 自定义角标颜色（默认 colorError / colorPrimary）。
  final Color? color;

  /// 数字溢出阈值，超过显示 `${overflowCount}+`。
  final int overflowCount;
}