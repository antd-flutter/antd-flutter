/// AntTransfer 类型定义
library;

/// 穿梭框数据项
class AntTransferItem {
  const AntTransferItem({
    required this.key,
    required this.title,
    this.description,
    this.disabled = false,
  });

  /// 项唯一标识
  final String key;

  /// 标题
  final String title;

  /// 描述文本
  final String? description;

  /// 是否禁用
  final bool disabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntTransferItem &&
          key == other.key &&
          title == other.title &&
          description == other.description &&
          disabled == other.disabled;

  @override
  int get hashCode =>
      Object.hash(key, title, description, disabled);
}

/// 穿梭方向
enum AntTransferDirection {
  /// 移至右侧
  right,

  /// 移至左侧
  left,
}