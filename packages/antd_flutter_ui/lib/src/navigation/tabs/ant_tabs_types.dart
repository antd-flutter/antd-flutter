/// AntTabs 类型定义
library;

import 'package:flutter/widgets.dart';

/// 选项卡类型。
enum AntTabsType {
  /// 线条样式（默认）。
  line,

  /// 卡片样式。
  card,

  /// 可编辑卡片样式（支持增删）。
  editableCard,

  /// 外边框分段样式（整组一枚圆角外框，内部以分隔线切分，选中段主色描边）。
  outlined,
}

/// 选项卡尺寸。
enum AntTabsSize {
  /// 大尺寸。
  large,

  /// 默认尺寸。
  normal,

  /// 小尺寸。
  small,
}

/// 选项卡位置。
enum AntTabPosition {
  /// 顶部。
  top,

  /// 底部。
  bottom,

  /// 左侧。
  left,

  /// 右侧。
  right,
}

/// 编辑动作类型。
enum AntTabsEditAction {
  /// 新增。
  add,

  /// 删除。
  remove,
}

/// 选项卡项。
class AntTabsItem {
  const AntTabsItem({
    required this.key,
    this.label,
    this.labelWidget,
    this.child,
    this.icon,
    this.disabled = false,
    this.closable,
  });

  /// 选项卡唯一标识。
  final String key;

  /// 标题文字。与 [labelWidget] 二选一，[labelWidget] 优先。
  final String? label;

  /// 自定义标题组件。优先于 [label]。
  final Widget? labelWidget;

  /// 内容区域。
  final Widget? child;

  /// 自定义图标。
  final Widget? icon;

  /// 是否禁用。
  final bool disabled;

  /// 是否可关闭。null 时由 [AntTabsType] 决定（editableCard 默认可关闭）。
  final bool? closable;
}