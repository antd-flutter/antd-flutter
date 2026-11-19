/// AntBreadcrumb 类型定义
library;

import 'package:flutter/widgets.dart';

/// 面包屑项。
class AntBreadcrumbItem {
  const AntBreadcrumbItem({
    this.title,
    this.titleWidget,
    this.icon,
    this.onClick,
  });

  /// 标题文字。
  final String? title;

  /// 标题自定义 Widget。优先于 [title]。
  final Widget? titleWidget;

  /// 图标，显示在标题左侧。
  final Widget? icon;

  /// 点击回调。不为 null 时该项可点击。
  final VoidCallback? onClick;
}