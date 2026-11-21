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

/// 时间标签构建器。返回 null 时不展示标签列。
typedef AntTimelineLabelBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 内容构建器。返回 null 时内容为空。
typedef AntTimelineContentBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 自定义节点构建器。返回 null 时使用默认圆点。
typedef AntTimelineDotBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);
