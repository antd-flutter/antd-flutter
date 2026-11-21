/// AntJumboTabs 数据类型 — antd-mobile JumboTabs 大选项卡
library;

import 'package:material_ui/material_ui.dart';

/// 主标题构建器。未提供时回退为 `Text('$item')`。
typedef AntJumboTabsTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 描述构建器（套用胶囊底）。
typedef AntJumboTabsDescriptionBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);
