/// AntTypography 类型定义 — 与 antd React Typography API 对齐
library;

import 'package:flutter/widgets.dart';

/// 文本语义类型。
enum AntTypographyType {
  /// 次要文本（colorTextSecondary）
  secondary,

  /// 成功文本（colorSuccessText）
  success,

  /// 警告文本（colorWarningText）
  warning,

  /// 危险文本（colorErrorText）
  danger,
}

/// 标题层级（对应 h1 ~ h5）。
enum AntTitleLevel {
  h1,
  h2,
  h3,
  h4,
  h5,
}

/// 可复制配置 — 对应 antd `CopyConfig`。
class AntCopyConfig {
  const AntCopyConfig({
    this.text,
    this.onCopy,
    this.icon,
    this.tooltips,
  });

  /// 自定义复制文本（默认取子节点纯文本）。
  final String? text;

  /// 复制成功后的回调。
  final VoidCallback? onCopy;

  /// 自定义复制图标。
  final Widget? icon;

  /// 复制按钮的 tooltip 文本（默认 ["复制", "已复制"]）。
  final List<String>? tooltips;
}

/// 省略配置 — 对应 antd `EllipsisConfig`。
class AntEllipsisConfig {
  const AntEllipsisConfig({
    this.rows = 1,
    this.expandable = false,
    this.suffix,
    this.symbol,
    this.expanded = false,
    this.onExpand,
    this.tooltip = false,
  });

  /// 最大显示行数。
  final int rows;

  /// 是否可展开。
  final bool expandable;

  /// 尾部自定义后缀。
  final String? suffix;

  /// 展开按钮的自定义内容（默认 "展开"）。
  final Widget? symbol;

  /// 是否已展开。
  final bool expanded;

  /// 展开/收起时的回调。
  final void Function(bool expanded)? onExpand;

  /// 是否在省略时显示 tooltip 提示完整内容。
  final bool tooltip;
}

/// 可编辑配置 — 对应 antd `EditConfig`。
class AntEditConfig {
  const AntEditConfig({
    this.text,
    this.editing = false,
    this.onStart,
    this.onChange,
    this.onCancel,
  });

  /// 编辑时的初始文本。
  final String? text;

  /// 是否处于编辑态。
  final bool editing;

  /// 开始编辑时的回调。
  final VoidCallback? onStart;

  /// 文本变化时的回调。
  final ValueChanged<String>? onChange;

  /// 取消编辑时的回调。
  final VoidCallback? onCancel;
}