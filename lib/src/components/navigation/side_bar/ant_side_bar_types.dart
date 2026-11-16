/// AntSideBar 数据类型 — antd-mobile SideBar 侧边导航栏
library;

import 'package:flutter/material.dart';

/// 侧边导航栏项。
class AntSideBarItem {
  const AntSideBarItem({
    required this.key,
    this.title,
    this.titleWidget,
    this.badgeText,
    this.badgeDot = false,
    this.disabled = false,
  });

  /// 唯一标识。
  final String key;

  /// 标题文字。
  final String? title;

  /// 自定义标题 Widget（优先于 [title]）。
  final Widget? titleWidget;

  /// 文字角标。
  final String? badgeText;

  /// 圆点角标。
  final bool badgeDot;

  /// 是否禁用。
  final bool disabled;
}