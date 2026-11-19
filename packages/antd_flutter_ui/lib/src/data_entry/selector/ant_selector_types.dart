/// AntSelector 类型定义
library;

import 'package:flutter/widgets.dart';

/// 选择器选项
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