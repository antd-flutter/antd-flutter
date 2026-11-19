/// AntMenu 类型定义
library;

import 'package:flutter/widgets.dart';

/// 菜单模式。
enum AntMenuMode {
  /// 内嵌模式（子菜单展开/折叠）。
  inline,

  /// 垂直模式。
  vertical,

  /// 水平模式。
  horizontal,
}

/// 菜单主题。
enum AntMenuTheme {
  /// 亮色主题。
  light,

  /// 暗色主题。
  dark,
}

/// 菜单项类型。
enum AntMenuItemType {
  /// 普通菜单项。
  item,

  /// 分组标题。
  group,

  /// 分割线。
  divider,
}

/// 菜单项。
class AntMenuItem {
  const AntMenuItem({
    required this.key,
    this.label,
    this.labelWidget,
    this.icon,
    this.children = const [],
    this.disabled = false,
    this.danger = false,
    this.type = AntMenuItemType.item,
  });

  /// 唯一标识。
  final String key;

  /// 标题文字。与 [labelWidget] 二选一，[labelWidget] 优先。
  final String? label;

  /// 自定义标题组件。优先于 [label]。
  final Widget? labelWidget;

  /// 图标。
  final Widget? icon;

  /// 子菜单项。非空时该项为子菜单。
  final List<AntMenuItem> children;

  /// 是否禁用。
  final bool disabled;

  /// 是否危险操作（红色文字）。
  final bool danger;

  /// 菜单项类型。
  final AntMenuItemType type;
}