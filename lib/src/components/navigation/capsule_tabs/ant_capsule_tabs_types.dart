/// AntCapsuleTabs 数据类型 — antd-mobile CapsuleTabs 胶囊选项卡
library;

import 'package:flutter/material.dart';

/// 胶囊选项卡项。
class AntCapsuleTabItem {
  const AntCapsuleTabItem({
    required this.key,
    this.title,
    this.titleWidget,
    this.disabled = false,
  });

  /// 唯一标识。
  final String key;

  /// 标题文字。
  final String? title;

  /// 自定义标题 Widget（优先于 [title]）。
  final Widget? titleWidget;

  /// 是否禁用。
  final bool disabled;
}