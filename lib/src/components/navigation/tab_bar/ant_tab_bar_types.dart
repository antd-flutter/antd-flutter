/// AntTabBar 类型定义 — antd-mobile TabBar 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

// ============================================================
// AntTabBarItem — 底部标签栏项
// ============================================================

/// 底部标签栏项。
///
/// 对齐 antd-mobile TabBar.Item：
/// - [key] — 唯一标识
/// - [title] — 标题文字
/// - [titleWidget] — 自定义标题（优先于 [title]）
/// - [icon] — 图标
/// - [activeIcon] — 激活时图标（默认与 [icon] 相同）
/// - [badgeText] — 文字角标（如 '5'、'99+'）
/// - [badgeDot] — 红点角标
class AntTabBarItem {
  const AntTabBarItem({
    required this.key,
    this.title,
    this.titleWidget,
    this.icon,
    this.activeIcon,
    this.badgeText,
    this.badgeDot = false,
  });

  /// 唯一标识。
  final String key;

  /// 标题文字。
  final String? title;

  /// 自定义标题 Widget（优先于 [title]）。
  final Widget? titleWidget;

  /// 图标。
  final IconData? icon;

  /// 激活时图标（默认与 [icon] 相同）。
  final IconData? activeIcon;

  /// 文字角标（如 '5'、'99+'）。
  final String? badgeText;

  /// 红点角标。
  final bool badgeDot;
}