/// AntTabBar 类型定义 — antd-mobile TabBar 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

/// 标题构建器。未提供时回退为 `Text('$item')`。
typedef AntTabBarTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 图标构建器。
typedef AntTabBarIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);

/// 激活态图标构建器。未提供时复用普通图标。
typedef AntTabBarActiveIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);
