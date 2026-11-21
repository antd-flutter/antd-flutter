/// AntTreeSelect types — 树选择组件的类型定义
library;

/// 树选择尺寸
enum AntTreeSelectSize {
  /// 大号
  large,

  /// 中号（默认）
  middle,

  /// 小号
  small,
}

/// 树节点数据结构
class AntTreeSelectOption {
  const AntTreeSelectOption({
    required this.value,
    required this.label,
    this.children,
    this.disabled = false,
  });

  /// 节点值
  final String value;

  /// 节点显示文本
  final String label;

  /// 子节点
  final List<AntTreeSelectOption>? children;

  /// 是否禁用
  final bool disabled;

  /// 是否叶子节点（无子节点或子节点为空）
  bool get isLeaf => children == null || children!.isEmpty;
}

/// 自定义字段名（与 antd React fieldNames 对齐）
class AntTreeSelectFieldNames {
  const AntTreeSelectFieldNames({
    this.label = 'label',
    this.value = 'value',
    this.children = 'children',
  });

  /// label 字段名
  final String label;

  /// value 字段名
  final String value;

  /// children 字段名
  final String children;
}