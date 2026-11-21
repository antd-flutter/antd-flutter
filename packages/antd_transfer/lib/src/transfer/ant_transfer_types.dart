/// AntTransfer 类型定义。
library;

import 'package:material_ui/material_ui.dart';

/// 从数据项提取唯一 key。
typedef AntTransferKeyOf<T> = Object Function(T item);

/// 行标题构建器。
typedef AntTransferTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// 读取行描述文本（返回 null 表示无描述）。
typedef AntTransferDescriptionOf<T> = String? Function(T item);

/// 读取子节点；返回空集合表示叶子。
typedef AntTransferChildrenOf<T> = List<T> Function(T item);

/// 判断数据项是否禁用（树形模式下会向下传递到整个子树）。
typedef AntTransferDisabledOf<T> = bool Function(T item);

/// 默认搜索使用的纯文本。
typedef AntTransferSearchTextOf<T> = String Function(T item);

/// 穿梭完成回调。
///
/// [targetKeys] / [moveKeys] 中的 key 均由 [AntTransferKeyOf] 从用户模型提取。
typedef AntTransferOnChange = void Function(
  List<Object> targetKeys,
  AntTransferDirection direction,
  List<Object> moveKeys,
);

/// 选中项变化回调，参数为源面板/目标面板的选中 key。
typedef AntTransferOnSelectChange = void Function(
  List<Object> sourceSelectedKeys,
  List<Object> targetSelectedKeys,
);

/// 旧版穿梭框数据项。
///
/// 已废弃：[AntTransfer] 现在直接消费用户模型 `T`，通过 `keyOf` /
/// `titleBuilder` / `descriptionOf` / `childrenOf` / `disabledOf` 读取数据。
@Deprecated(
  'AntTransfer 已泛型化，请直接使用自己的模型并传入 keyOf/titleBuilder/'
  'descriptionOf/childrenOf；AntTransferItem 将在后续大版本移除。',
)
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
