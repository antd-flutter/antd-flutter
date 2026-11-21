/// AntDescriptions 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 描述列表尺寸。
enum AntDescriptionsSize {
  /// 大
  large,

  /// 中（默认）
  middle,

  /// 小
  small,
}

/// 描述列表布局方向。
enum AntDescriptionsLayout {
  /// 水平（默认）
  horizontal,

  /// 垂直
  vertical,
}

/// 描述标签构建器。未提供时回退为 `Text('$item')`。
typedef AntDescriptionsLabelBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 描述内容构建器。
typedef AntDescriptionsContentBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);
