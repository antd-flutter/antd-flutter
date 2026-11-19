/// AntCollapse 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 折叠面板尺寸。
enum AntCollapseSize {
  /// 大
  large,

  /// 中（默认）
  middle,

  /// 小
  small,
}

/// 展开图标位置。
enum AntCollapseExpandIconPosition {
  /// 左侧
  left,

  /// 右侧
  right,
}

/// 折叠面板。
class AntCollapsePanel {
  const AntCollapsePanel({
    this.key,
    required this.label,
    this.child,
    this.extra,
    this.disabled = false,
    this.forceRender = false,
  });

  /// 面板唯一标识（不传时使用 [label] 作为标识）。
  final String? key;

  /// 面板标题。
  final String label;

  /// 面板内容。
  final Widget? child;

  /// 面板右侧附加内容。
  final Widget? extra;

  /// 是否禁用。
  final bool disabled;

  /// 是否强制渲染内容（未展开也渲染，懒加载时传 true）。
  final bool forceRender;
}
