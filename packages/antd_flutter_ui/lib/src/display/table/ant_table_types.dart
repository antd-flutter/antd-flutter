/// AntTable 类型定义
library;

import 'package:flutter/widgets.dart';

// ============================================================
// 枚举
// ============================================================

/// 表格尺寸。
enum AntTableSize {
  /// 大尺寸
  large,

  /// 中尺寸（默认）
  middle,

  /// 小尺寸
  small,
}

/// 排序方向。
enum AntTableSortOrder {
  /// 升序
  ascend,

  /// 降序
  descend,
}

/// 固定列方向。
enum AntTableFixed {
  /// 固定在左侧
  left,

  /// 固定在右侧
  right,
}

/// 单元格对齐方式。
enum AntTableAlign {
  /// 左对齐（默认）
  left,

  /// 居中
  center,

  /// 右对齐
  right,
}

// ============================================================
// 筛选项
// ============================================================

/// 列筛选项。
///
/// 对齐 antd React `Column.filters` 项结构。
class AntTableFilterItem {
  const AntTableFilterItem({required this.text, required this.value});

  /// 筛选项展示文本。
  final String text;

  /// 筛选项值（传给 [AntTableColumn.onFilter]）。
  final Object value;
}

// ============================================================
// 列定义
// ============================================================

/// 列比较函数。
typedef AntTableSorter = int Function(
  Map<String, dynamic> a,
  Map<String, dynamic> b,
);

/// 列过滤函数。
typedef AntTableFilterFn = bool Function(
  Object value,
  Map<String, dynamic> record,
);

/// 单元格自定义渲染。
typedef AntTableRenderFn = Widget? Function(
  Object? value,
  Map<String, dynamic> record,
  int index,
);

/// 行 key 提取函数。
typedef AntTableRowKeyFn = Object? Function(Map<String, dynamic> record);

/// 列定义。
///
/// 对齐 antd React Table `ColumnType` 核心 API。
class AntTableColumn {
  const AntTableColumn({
    required this.title,
    this.dataIndex,
    this.width,
    this.fixed,
    this.align = AntTableAlign.left,
    this.sorter,
    this.filters,
    this.onFilter,
    this.render,
    this.ellipsis = false,
  });

  /// 列头文本。
  final String title;

  /// 列数据在记录中的字段名。
  final String? dataIndex;

  /// 列宽（设计稿逻辑像素，内部按 `.w` 缩放；不传则弹性分配）。
  final double? width;

  /// 固定列方向。
  final AntTableFixed? fixed;

  /// 对齐方式。
  final AntTableAlign align;

  /// 排序比较函数，传入后表头可点击排序（升序 → 降序 → 取消）。
  final AntTableSorter? sorter;

  /// 筛选项列表，传入后表头出现筛选图标。
  final List<AntTableFilterItem>? filters;

  /// 过滤判定函数。
  final AntTableFilterFn? onFilter;

  /// 自定义单元格渲染。
  final AntTableRenderFn? render;

  /// 超出宽度是否省略（单行 + ellipsis 截断）。
  final bool ellipsis;
}
