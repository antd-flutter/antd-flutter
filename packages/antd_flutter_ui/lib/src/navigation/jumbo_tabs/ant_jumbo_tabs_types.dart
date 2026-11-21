/// AntJumboTabs 数据类型 — antd-mobile JumboTabs 大选项卡
library;

import 'package:material_ui/material_ui.dart';

/// 大选项卡项。
class AntJumboTabItem {
  const AntJumboTabItem({
    required this.key,
    this.title,
    this.titleWidget,
    this.description,
    this.descriptionWidget,
    this.disabled = false,
  });

  /// 唯一标识。
  final String key;

  /// 主标题。
  final String? title;

  /// 自定义主标题 Widget（优先于 [title]）。
  final Widget? titleWidget;

  /// 描述文字（标题下方胶囊小字）。
  final String? description;

  /// 自定义描述 Widget（优先于 [description]，仍套用 antd 的胶囊底）。
  final Widget? descriptionWidget;

  /// 是否禁用。
  final bool disabled;
}