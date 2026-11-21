/// AntSideBar 数据类型 — antd-mobile SideBar 侧边导航栏
library;

import 'package:material_ui/material_ui.dart';

/// 标题构建器。未提供时回退为 `Text('$item')`。
typedef AntSideBarTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);
