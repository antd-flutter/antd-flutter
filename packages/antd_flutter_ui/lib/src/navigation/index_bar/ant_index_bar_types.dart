/// AntIndexBar 数据类型 — antd-mobile IndexBar 索引栏
library;

import 'package:material_ui/material_ui.dart';

/// 分组标题构建器。未提供时回退为 `Text('$item')`。
typedef AntIndexBarTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 右侧索引字母构建器。未提供时取索引 key 的首字符。
typedef AntIndexBarBriefBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);

/// 分组内容构建器。
typedef AntIndexBarChildBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);
