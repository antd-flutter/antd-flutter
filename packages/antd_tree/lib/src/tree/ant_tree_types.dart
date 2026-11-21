/// AntTree 对外类型定义。
///
/// 组件已全面泛型化：所有取值都通过 [AntTreeKeyOf] / [AntTreeChildrenOf]
/// 等回调从用户自己的模型 `T` 中读取，不再要求构造旧数据模型。
/// 旧的 [AntTreeNode] 仅为兼容存量代码保留，已标记废弃，组件不再使用。
library;

import 'package:material_ui/material_ui.dart';

/// 从数据项提取唯一 key。
typedef AntTreeKeyOf<T> = Object Function(T item);

/// 构建节点标题。
typedef AntTreeTitleBuilder<T> = Widget Function(BuildContext context, T item);

/// 读取子节点；返回空集合表示叶子。
typedef AntTreeChildrenOf<T> = List<T> Function(T item);

/// 判断节点是否禁用。
typedef AntTreeDisabledOf<T> = bool Function(T item);

/// 判断节点是否显示/响应勾选。
typedef AntTreeCheckableOf<T> = bool Function(T item);

/// 勾选回调。
///
/// 两个集合中的元素均为 [AntTreeKeyOf] 从用户模型上提取的 key。
typedef AntTreeOnCheck = void Function(
  Set<Object> checkedKeys,
  Set<Object> halfCheckedKeys,
);

/// 旧版树节点模型。
///
/// 已废弃：[AntTree] 现在通过 `dataSource` + `keyOf` / `titleBuilder` /
/// `childrenOf` / `disabledOf` 直接消费用户模型。该类型仅为兼容存量引用保留。
@Deprecated(
  'AntTree 已泛型化，请直接使用自己的模型并传入 keyOf/titleBuilder/childrenOf；'
  'AntTreeNode 将在后续大版本移除。',
)
class AntTreeNode {
  const AntTreeNode({
    required this.key,
    required this.title,
    this.children,
    this.disabled = false,
    this.checkable = true,
  });

  /// 唯一标识。
  final String key;

  /// 标题文本。
  final String title;

  /// 子节点。
  final List<AntTreeNode>? children;

  /// 是否禁用。
  final bool disabled;

  /// 是否显示勾选框。
  final bool checkable;

  /// 是否叶子节点。
  bool get isLeaf => children == null || children!.isEmpty;
}
