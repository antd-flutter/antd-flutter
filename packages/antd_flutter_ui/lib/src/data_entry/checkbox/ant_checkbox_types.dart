/// AntCheckbox 类型定义
library;

import 'package:flutter/widgets.dart';

/// 复选框选项
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