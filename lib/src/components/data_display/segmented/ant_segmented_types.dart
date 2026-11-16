/// AntSegmented 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 分段控制器尺寸。
enum AntSegmentedSize {
  /// 小
  small,

  /// 中（默认）
  middle,

  /// 大
  large,
}

/// 分段控制器形状。
enum AntSegmentedShape {
  /// 圆角（默认）
  rounded,

  /// 胶囊形
  round,
}

/// 分段控制器选项。
///
/// [value] 缺省时取 [label]，[label] 缺省时取 [value]（icon-only 场景）。
class AntSegmentedItem {
  const AntSegmentedItem({
    this.label,
    this.icon,
    this.value,
    this.disabled = false,
  });

  /// 选项文案。
  final String? label;

  /// 前置图标（icon-only 时可不传 label）。
  final Widget? icon;

  /// 选项值（缺省取 [label]）。
  final String? value;

  /// 是否禁用该项。
  final bool disabled;
}
