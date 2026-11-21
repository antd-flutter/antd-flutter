/// AntCard 类型定义
library;

import 'package:flutter/widgets.dart';

/// 卡片尺寸。
enum AntCardSize {
  /// 默认
  standard,

  /// 小号
  small,
}

/// 卡片底部操作构建器。
typedef AntCardActionBuilder<T> = Widget Function(
  BuildContext context,
  T action,
  int index,
);
