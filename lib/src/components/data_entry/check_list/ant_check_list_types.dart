/// AntCheckList 类型定义
library;

import 'package:flutter/widgets.dart';

/// 复选列表项
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