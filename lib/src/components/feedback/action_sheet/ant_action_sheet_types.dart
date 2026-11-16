/// AntActionSheet 类型定义 — antd-mobile ActionSheet 的 Flutter 实现
library;

import 'package:flutter/material.dart';

/// 动作面板选项。
///
/// 对齐 antd-mobile ActionSheet 的 action 配置。
class ActionSheetAction {
  const ActionSheetAction({
    required this.text,
    this.key,
    this.description,
    this.disabled = false,
    this.danger = false,
    this.onClick,
  });

  /// 标题文案。
  final String text;

  /// 选项唯一标识。
  final Key? key;

  /// 二级描述文案（显示在标题下方）。
  final String? description;

  /// 是否禁用（灰显且不可点击）。
  final bool disabled;

  /// 是否为危险操作（红色文字）。
  final bool danger;

  /// 点击回调。
  final ValueChanged<ActionSheetAction>? onClick;
}
