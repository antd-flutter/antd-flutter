/// AntCheckList 类型定义
library;

import 'package:flutter/widgets.dart';

/// 复选列表项（旧模型，自 1.x 起推荐直接用
/// `AntCheckList<T>(items: List<T>)` 配合 `labelOf` / `labelBuilder`）。
@Deprecated('不再需要构造列表项模型，直接传 List<T> + labelOf/labelBuilder；本类将在 2.0 移除')
class AntCheckListItem<T> {
  const AntCheckListItem({
    required this.value,
    required this.child,
    this.description,
    this.prefix,
    this.disabled = false,
    this.readOnly = false,
  });

  /// 项的值。
  final T value;

  /// 主内容。
  final Widget child;

  /// 描述文本。
  final Widget? description;

  /// 前缀内容。
  final Widget? prefix;

  /// 是否禁用。
  final bool disabled;

  /// 是否只读。
  final bool readOnly;
}
