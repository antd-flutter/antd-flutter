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

/// 步骤标题构建器。未提供时回退为 `Text('$item')`。
typedef AntStepsTitleBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 步骤描述构建器。返回 null 时不展示描述。
typedef AntStepsDescriptionBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);

/// 步骤自定义图标构建器。优先于自动生成的圆圈内容。
typedef AntStepsIconBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
  int index,
);
