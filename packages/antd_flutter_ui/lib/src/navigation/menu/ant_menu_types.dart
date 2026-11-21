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

/// 菜单标题构建器。未提供时回退为 `Text('$item')`（`T` 为 String 时即纯文本）。
typedef AntMenuLabelBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// 菜单图标构建器。返回 null 时不展示图标。
typedef AntMenuIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);

/// 菜单右侧附加内容构建器。返回 null 时不展示。
typedef AntMenuExtraBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);

/// 折叠态 Tooltip 标题提取器。
typedef AntMenuTooltipTitleOf<T> = String? Function(T item);
