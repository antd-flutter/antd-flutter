/// AntCascader 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 级联尺寸。
enum AntCascaderSize { large, middle, small }

/// 次级菜单展开触发方式。
enum AntCascaderExpandTrigger { click, hover }

/// 从模型取唯一标识。
typedef AntCascaderKeyOf<T> = Object Function(T item);

/// 从模型取子节点；返回 null/空表示叶子。
typedef AntCascaderChildrenOf<T> = List<T> Function(T item);

/// 选项自定义渲染。
typedef AntCascaderLabelBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// 选项禁用判断。
typedef AntCascaderDisabledOf<T> = bool Function(T item);

/// 选择变化回调（值为选中的模型路径）。
typedef AntCascaderOnChange<T> = void Function(List<T> value);

/// 级联选择视图变化回调：`value` 为模型路径，`items` 为逐层选中项
/// （未选择层级为 null）。
typedef AntCascaderViewOnChange<T> = void Function(
  List<T> value,
  List<T?> items,
);
