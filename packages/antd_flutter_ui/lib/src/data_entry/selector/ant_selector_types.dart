/// AntSelector 类型定义
library;

import 'package:flutter/widgets.dart';

/// 选择器选项（旧模型，自 1.x 起推荐直接用 `AntSelector<T>(options: List<T>)`
/// 配合 `labelOf` / `labelBuilder` / `descriptionOf`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf/labelBuilder；本类将在 2.0 移除')
class AntSelectorOption<T> {
  const AntSelectorOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
  });

  /// 选项值。
  final T value;

  /// 选项标签。
  final Widget label;

  /// 描述文本。
  final Widget? description;

  /// 是否禁用。
  final bool disabled;
}
