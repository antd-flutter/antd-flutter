/// AntDescriptions 类型定义
library;

import 'package:flutter/material.dart';

/// 描述列表尺寸。
enum AntDescriptionsSize {
  /// 大
  large,

  /// 中（默认）
  middle,

  /// 小
  small,
}

/// 描述列表布局方向。
enum AntDescriptionsLayout {
  /// 水平（默认）
  horizontal,

  /// 垂直
  vertical,
}

/// 描述列表的每一项。
///
/// 对齐 antd React Descriptions `items` 中的 item。
class AntDescriptionsItem {
  const AntDescriptionsItem({
    this.label,
    this.child,
    this.span = 1,
  });

  /// 内容的描述标签。
  final String? label;

  /// 内容。
  final Widget? child;

  /// 占用的列数。
  final int span;
}
