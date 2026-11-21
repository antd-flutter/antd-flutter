/// AntDropdown 类型定义 — antd React Dropdown 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

// ============================================================
// AntDropdownTrigger — 触发方式
// ============================================================

/// 下拉菜单触发方式。
enum AntDropdownTrigger {
  /// 悬停触发。
  hover,

  /// 点击触发。
  click,
}

// ============================================================
// AntDropdownPlacement — 弹出位置
// ============================================================

/// 下拉菜单弹出位置。
enum AntDropdownPlacement {
  /// 左下方弹出（默认）。
  bottomLeft,

  /// 右下方弹出。
  bottomRight,

  /// 左上方弹出。
  topLeft,

  /// 右上方弹出。
  topRight,
}

// ============================================================
// AntDropdownItemType — 菜单项类型
// ============================================================

/// 下拉菜单项类型。
enum AntDropdownItemType {
  /// 普通菜单项。
  item,

  /// 分割线。
  divider,
}

// ============================================================
// AntDropdownItem — 下拉菜单项
// ============================================================

/// 下拉菜单项。
///
/// 对齐 antd React Dropdown 的 menu.items 中的菜单项：
/// - [key] — 唯一标识
/// - [label] — 文字标签
/// - [labelWidget] — 自定义标签 Widget（优先于 [label]）
/// - [icon] — 图标
/// - [disabled] — 是否禁用
/// - [danger] — 是否危险项（红色文字）
/// - [type] — 项类型（item / divider）
class AntDropdownItem {
  const AntDropdownItem({
    required this.key,
    this.label,
    this.labelWidget,
    this.icon,
    this.disabled = false,
    this.danger = false,
    this.type = AntDropdownItemType.item,
  });

  /// 唯一标识。
  final String key;

  /// 文字标签。
  final String? label;

  /// 自定义标签 Widget（优先于 [label]）。
  final Widget? labelWidget;

  /// 图标。
  final IconData? icon;

  /// 是否禁用。
  final bool disabled;

  /// 是否危险项（红色文字）。
  final bool danger;

  /// 项类型。
  final AntDropdownItemType type;
}