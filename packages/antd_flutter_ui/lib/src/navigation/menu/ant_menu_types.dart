/// AntMenu 类型定义
library;

import 'package:flutter/widgets.dart';

/// 菜单模式。
enum AntMenuMode {
  /// 垂直模式（子菜单以浮层展开）。
  vertical,

  /// 内嵌模式（子菜单就地展开/折叠）。
  inline,

  /// 水平模式（顶部导航，子菜单以浮层展开）。
  horizontal,
}

/// 菜单主题。
enum AntMenuTheme {
  /// 亮色主题。
  light,

  /// 暗色主题。
  dark,
}

/// 子菜单触发方式。
enum AntMenuTrigger {
  /// 悬浮触发（默认，等同 antd `triggerSubMenuAction: 'hover'`）。
  hover,

  /// 点击触发（等同 antd `triggerSubMenuAction: 'click'`）。
  click,
}

/// 菜单项类型。
enum AntMenuItemType {
  /// 普通菜单项。
  item,

  /// 子菜单（带 children；children 非空时也可省略此类型）。
  submenu,

  /// 分组标题。
  group,

  /// 分割线。
  divider,
}

/// 菜单项。
///
/// 对齐 antd v6 `ItemType`：
/// - `item`：普通项（[children] 为空）
/// - `submenu`：子菜单（[children] 非空，或显式 [type] 为 [AntMenuItemType.submenu]）
/// - `group`：分组标题，[children] 为分组内容
/// - `divider`：分割线（[dashed] 控制虚线）
class AntMenuItem {
  const AntMenuItem({
    required this.key,
    this.label,
    this.labelWidget,
    this.icon,
    this.extra,
    this.title,
    this.children = const <AntMenuItem>[],
    this.disabled = false,
    this.danger = false,
    this.type = AntMenuItemType.item,
    this.dashed = false,
  });

  /// 唯一标识。
  final String key;

  /// 标题文字。与 [labelWidget] 二选一，[labelWidget] 优先。
  final String? label;

  /// 自定义标题组件。优先于 [label]。
  final Widget? labelWidget;

  /// 图标。
  final Widget? icon;

  /// 右侧附加内容（antd `extra`）。
  final Widget? extra;

  /// 悬浮提示文本。为空时折叠态使用 [label]。
  final String? title;

  /// 子菜单项 / 分组内容。
  final List<AntMenuItem> children;

  /// 是否禁用。
  final bool disabled;

  /// 是否危险操作（红色文字）。
  final bool danger;

  /// 菜单项类型。
  final AntMenuItemType type;

  /// 分割线是否为虚线（仅 [AntMenuItemType.divider] 生效）。
  final bool dashed;

  /// 是否为子菜单：显式 submenu 类型，或普通项但带 children。
  bool get isSubMenu =>
      type == AntMenuItemType.submenu ||
      (type == AntMenuItemType.item && children.isNotEmpty);

  /// 是否为分组标题。
  bool get isGroup => type == AntMenuItemType.group;

  /// 是否为分割线。
  bool get isDivider => type == AntMenuItemType.divider;
}
