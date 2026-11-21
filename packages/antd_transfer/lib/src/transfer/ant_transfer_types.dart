/// AntTransfer 类型定义
library;

/// 穿梭框数据项
///
/// 传入 [children] 即为树形（TreeTransfer）模式；不传则保持扁平列表模式。
class AntTransferItem {
  const AntTransferItem({
    required this.key,
    required this.title,
    this.description,
    this.disabled = false,
    this.children,
  });

  /// 项唯一标识
  final String key;

  /// 标题
  final String title;

  /// 描述文本
  final String? description;

  /// 是否禁用（树模式下禁用会向下传递到整个子树）
  final bool disabled;

  /// 子级数据（树形模式）；为 null 或空列表时该项为叶子节点
  final List<AntTransferItem>? children;

  /// 是否包含子级（children 非空）
  bool get hasChildren => children != null && children!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntTransferItem &&
          key == other.key &&
          title == other.title &&
          description == other.description &&
          disabled == other.disabled &&
          _listEquals(children, other.children);

  static bool _listEquals(List<AntTransferItem>? a, List<AntTransferItem>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        key,
        title,
        description,
        disabled,
        children == null ? null : Object.hashAll(children!),
      );
}

/// 穿梭方向
enum AntTransferDirection {
  /// 移至右侧
  right,

  /// 移至左侧
  left,
}
