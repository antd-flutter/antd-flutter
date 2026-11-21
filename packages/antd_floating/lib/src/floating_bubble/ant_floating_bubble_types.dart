/// AntFloatingBubble 类型定义。
library;

import 'package:material_ui/material_ui.dart';

/// 悬浮气泡可拖拽轴向。
enum AntFloatingBubbleAxis {
  /// 仅水平方向拖拽。
  x,

  /// 仅垂直方向拖拽。
  y,

  /// 任意方向拖拽（默认）。
  both,
}

/// 悬浮气泡可吸附的父容器边缘。
enum AntFloatingBubbleEdge {
  /// 左边缘。
  left,

  /// 右边缘。
  right,
}

/// 悬浮气泡菜单项（点击按钮展开的动作条目）。
class AntFloatingBubbleMenuAction {
  const AntFloatingBubbleMenuAction({
    required this.label,
    this.icon,
    this.onClick,
  });

  /// 菜单文字。
  final String label;

  /// 菜单图标（可空）。
  final Widget? icon;

  /// 点击回调。
  final VoidCallback? onClick;
}
