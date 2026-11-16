/// AntTree 类型定义
library;

/// 树节点数据。
class AntTreeNode {
  const AntTreeNode({
    required this.key,
    required this.title,
    this.children,
    this.disabled = false,
    this.checkable = true,
  });

  /// 节点唯一标识。
  final String key;

  /// 节点显示文本。
  final String title;

  /// 子节点。
  final List<AntTreeNode>? children;

  /// 是否禁用（不可选中/不可勾选/不可展开）。
  final bool disabled;

  /// 是否显示复选框（仅 checkable 开启时生效）。
  final bool checkable;

  /// 是否叶子节点。
  bool get isLeaf => children == null || children!.isEmpty;
}
