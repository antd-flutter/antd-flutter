/// AntCheckbox 类型定义
library;

import 'package:flutter/widgets.dart';

/// 复选框选项（旧模型，自 1.x 起推荐直接用
/// `AntCheckboxGroup<T>(options: List<T>)` 配合 `labelOf` / `labelBuilder`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf/labelBuilder；本类将在 2.0 移除')
class AntCheckboxOption<T> {
  const AntCheckboxOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  /// 选项值。
  final T value;

  /// 选项文本。
  final Widget label;

  /// 是否禁用。
  final bool disabled;
}

/// 复选框组排列方向
enum AntCheckboxGroupDirection {
  /// 水平排列
  horizontal,

  /// 垂直排列
  vertical,
}
