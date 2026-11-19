/// AntTimeline 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 时间轴模式。
enum AntTimelineMode {
  /// 节点靠左（默认）
  left,

  /// 节点靠右
  right,

  /// 轴线居中，左右交替
  alternate,
}

/// 时间轴节点颜色预设。
enum AntTimelineColor {
  /// 蓝色（主题色）
  blue,

  /// 红色
  red,

  /// 绿色
  green,

  /// 灰色
  gray,
}

/// 时间轴的每一项。
///
/// 对齐 antd React Timeline `items` 中的 item。
class AntTimelineItem {
  const AntTimelineItem({
    this.label,
    this.content,
    this.color,
    this.customDot,
    this.dotColor,
    this.disabled = false,
    this.onTap,
  });

  /// 时间标签（独立于内容的标签列）。
  final String? label;

  /// 内容。
  final Widget? content;

  /// 节点颜色预设。
  final AntTimelineColor? color;

  /// 自定义节点。
  final Widget? customDot;

  /// 自定义节点颜色（customDot 为空时生效）。
  final Color? dotColor;

  /// 是否禁用。
  final bool disabled;

  /// 点击回调（disabled 时不可触发）。
  final VoidCallback? onTap;
}
