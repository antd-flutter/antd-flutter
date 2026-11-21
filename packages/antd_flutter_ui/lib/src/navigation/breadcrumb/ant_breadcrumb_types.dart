/// AntBreadcrumb 类型定义
library;

import 'package:flutter/widgets.dart';

/// 面包屑标题构建器。未提供时回退为 `Text('$item')`。
typedef AntBreadcrumbTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 面包屑图标构建器。返回 null 时不展示图标。
typedef AntBreadcrumbIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);
