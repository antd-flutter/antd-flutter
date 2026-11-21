/// AntPagination 类型定义
library;

import 'package:flutter/widgets.dart';

/// 分页尺寸。
enum AntPaginationSize {
  /// 默认尺寸。
  normal,

  /// 小尺寸。
  small,
}

/// 页码项内容构建器。渲染在既有的页码按钮容器内，[active] 表示当前页。
typedef AntPaginationPageItemBuilder = Widget Function(
  BuildContext context,
  int page,
  bool active,
);

/// 总条数构建器，替换默认的「共 N 条」文案。
typedef AntPaginationTotalBuilder = Widget Function(
  BuildContext context,
  int total,
);
