/// AntCapsuleTabs 数据类型 — antd-mobile CapsuleTabs 胶囊选项卡
library;

import 'package:material_ui/material_ui.dart';

/// 标题构建器。未提供时回退为 `Text('$item')`。
typedef AntCapsuleTabsTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 面板内容构建器。
typedef AntCapsuleTabsChildBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);
