/// AntTreeSelect 对外类型定义。
///
/// 组件已泛型化：标签、子节点、禁用状态都通过回调从用户模型 `T` 读取。
/// 旧的 [AntTreeSelectOption] 仅为兼容存量代码保留，已标记废弃。
library;

import 'package:material_ui/material_ui.dart';

/// 从数据项提取唯一 key/value。
typedef AntTreeSelectKeyOf<T> = Object Function(T item);

/// 触发器展示用的纯文本标签。
typedef AntTreeSelectLabelOf<T> = String Function(T item);

/// 下拉行标题构建器。
typedef AntTreeSelectTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// 读取子节点；返回空集合表示叶子。
typedef AntTreeSelectChildrenOf<T> = List<T> Function(T item);

/// 判断节点是否禁用。
typedef AntTreeSelectDisabledOf<T> = bool Function(T item);

/// 旧版树选择选项模型。
///
/// 已废弃：[AntTreeSelect] 现在通过 `dataSource` + `keyOf` / `labelOf` /
/// `titleBuilder` / `childrenOf` / `disabledOf` 直接消费用户模型。
@Deprecated(
  'AntTreeSelect 已泛型化，请直接使用自己的模型并传入 keyOf/labelOf/'
  'titleBuilder/childrenOf；AntTreeSelectOption 将在后续大版本移除。',
)
class AntTreeSelectOption {
  const AntTreeSelectOption({
    required this.value,
    required this.label,
    this.children,
    this.disabled = false,
  });

  /// 选项值。
  final String value;

  /// 选项文本。
  final String label;

  /// 子选项。
  final List<AntTreeSelectOption>? children;

  /// 是否禁用。
  final bool disabled;

  /// 是否叶子。
  bool get isLeaf => children == null || children!.isEmpty;
}

/// 自定义字段名（历史类型，组件泛型化后不再使用）。
@Deprecated('AntTreeSelect 已泛型化，请使用 keyOf/labelOf/childrenOf 回调。')
class AntTreeSelectFieldNames {
  const AntTreeSelectFieldNames({
    this.label = 'label',
    this.value = 'value',
    this.children = 'children',
  });

  /// 标签字段名。
  final String label;

  /// 值字段名。
  final String value;

  /// 子节点字段名。
  final String children;
}

/// 选择器尺寸。
enum AntTreeSelectSize {
  /// 大。
  large,

  /// 中。
  middle,

  /// 小。
  small,
}
