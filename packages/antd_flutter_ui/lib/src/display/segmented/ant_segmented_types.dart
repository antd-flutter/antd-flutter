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

/// 分段控制器方向。
enum AntSegmentedDirection {
  /// 水平排列（默认）
  horizontal,

  /// 垂直排列（对齐 antd `orientation="vertical"`）
  vertical,
}

/// 分段控制器选项（旧模型，自 1.x 起推荐直接用 `AntSegmented<T>(options: List<T>)`
/// 配合 `labelOf` / `iconBuilder` / `disabledOf`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf/iconBuilder；本类将在 2.0 移除')
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
