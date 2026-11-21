/// AntCollapse 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 折叠面板尺寸。
enum AntCollapseSize {
  /// 大
  large,

  /// 中（默认）
  middle,

  /// 小
  small,
}

/// 展开图标位置。
enum AntCollapseExpandIconPosition {
  /// 左侧
  left,

  /// 右侧
  right,
}

/// 面板标题构建器。未提供时回退为 `Text('$item')`。
typedef AntCollapseLabelBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 面板内容构建器。
typedef AntCollapseChildBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 面板右侧附加内容构建器。
typedef AntCollapseExtraBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);
