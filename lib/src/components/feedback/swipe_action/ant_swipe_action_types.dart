/// AntSwipeAction 类型定义 — 对齐 antd-mobile SwipeAction 的配置项
library;

import 'package:material_ui/material_ui.dart';

/// 滑动操作按钮配置。
///
/// 对齐 antd-mobile SwipeAction 的 action 项：
/// ```ts
/// { text, color, onClick, disabled }
/// ```
class AntSwipeActionItem {
  const AntSwipeActionItem({
    required this.text,
    this.color,
    this.onPressed,
    this.disabled = false,
  });

  /// 按钮文案。
  final String text;

  /// 按钮背景色（默认主色；危险操作用 [AntThemeData.colorError]）。
  final Color? color;

  /// 点击回调。
  final VoidCallback? onPressed;

  /// 是否禁用（禁用后点击不触发回调）。
  final bool disabled;
}
