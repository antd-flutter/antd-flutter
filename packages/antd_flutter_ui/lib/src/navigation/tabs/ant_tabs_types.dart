/// AntTabs 类型定义
library;

import 'package:flutter/widgets.dart';

/// 选项卡类型。
enum AntTabsType {
  /// 线条样式（默认）。
  line,

  /// 卡片样式。
  card,

  /// 可编辑卡片样式（支持增删）。
  editableCard,

  /// 外边框分段样式（整组一枚圆角外框，内部以分隔线切分，选中段主色描边）。
  outlined,
}

/// 选项卡尺寸。
enum AntTabsSize {
  /// 大尺寸。
  large,

  /// 默认尺寸。
  normal,

  /// 小尺寸。
  small,
}

/// 选项卡位置。
enum AntTabPosition {
  /// 顶部。
  top,

  /// 底部。
  bottom,

  /// 左侧。
  left,

  /// 右侧。
  right,
}

/// 编辑动作类型。
enum AntTabsEditAction {
  /// 新增。
  add,

  /// 删除。
  remove,
}

/// 选项卡标题构建器。未提供时回退为 `Text('$item')`。
typedef AntTabsLabelBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 选项卡内容构建器。
typedef AntTabsChildBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 选项卡图标构建器。
typedef AntTabsIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);
