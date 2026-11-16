/// AntSteps 类型定义
library;

import 'package:flutter/widgets.dart';

/// 步骤条排列方向。
enum AntStepsDirection {
  /// 水平排列。
  horizontal,

  /// 垂直排列。
  vertical,
}

/// 步骤状态。
enum AntStepsStatus {
  /// 等待中。
  wait,

  /// 进行中。
  process,

  /// 已完成。
  finish,

  /// 错误。
  error,
}

/// 步骤条尺寸。
enum AntStepsSize {
  /// 默认尺寸。
  normal,

  /// 小尺寸。
  small,
}

/// 步骤项。
class AntStepsItem {
  const AntStepsItem({
    this.title,
    this.description,
    this.icon,
    this.status,
    this.disabled,
  });

  /// 标题。
  final String? title;

  /// 描述文字。
  final String? description;

  /// 自定义图标。优先于自动生成的圆圈内容。
  final Widget? icon;

  /// 自定义状态。覆盖自动计算的状态。
  final AntStepsStatus? status;

  /// 是否禁用点击。
  final bool? disabled;
}