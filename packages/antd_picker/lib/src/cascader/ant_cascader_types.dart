/// AntCascader 类型定义
library;

/// 级联选择尺寸
enum AntCascaderSize {
  /// 大尺寸
  large,

  /// 中尺寸（默认）
  middle,

  /// 小尺寸
  small,
}

/// 次级菜单展开触发方式
enum AntCascaderExpandTrigger {
  /// 点击展开
  click,

  /// 悬停展开
  hover,
}

/// 自定义字段名配置
class AntCascaderFieldNames {
  const AntCascaderFieldNames({
    this.label = 'label',
    this.value = 'value',
    this.children = 'children',
  });

  /// 标签字段名
  final String label;

  /// 值字段名
  final String value;

  /// 子节点字段名
  final String children;
}

/// 级联选项
class AntCascaderOption {
  const AntCascaderOption({
    required this.value,
    required this.label,
    this.children,
    this.disabled = false,
  });

  /// 选项值
  final String value;

  /// 选项标签
  final String label;

  /// 子选项
  final List<AntCascaderOption>? children;

  /// 是否禁用
  final bool disabled;

  /// 是否为叶子节点（无子选项）
  bool get isLeaf => children == null || children!.isEmpty;
}