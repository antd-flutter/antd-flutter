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
// 筛选
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
// 合并单元格
// ============================================================

/// 单元格合并配置（对齐 antd React `onCell` 返回的 rowSpan / colSpan）。
class AntTableCellSpan {
  const AntTableCellSpan({this.rowSpan, this.colSpan});

  /// 纵向合并行数（0 表示该单元格不渲染）。
  final int? rowSpan;

  /// 横向合并列数。
  final int? colSpan;
}

// ============================================================
// 行选择
// ============================================================

/// 行选择复选框属性（对齐 antd `getCheckboxProps`）。
class AntTableRowCheckboxProps {
  const AntTableRowCheckboxProps({this.disabled = false});

  /// 是否禁用该行复选框。
  final bool disabled;
}

/// 自定义选择项（对齐 antd `rowSelection.selections`）。
class AntTableRowSelectionItem {
  const AntTableRowSelectionItem({required this.text, required this.onSelect});

  /// 选择项文本。
  final String text;

  /// 点击回调（参数为全部可选行 key 集合）。
  final ValueChanged<Set<Object>> onSelect;
}

/// 行选择配置（对齐 antd `rowSelection`）。
class AntTableRowSelection {
  const AntTableRowSelection({
    this.selectedRowKeys,
    this.defaultSelectedRowKeys,
    this.onChange,
    this.getCheckboxProps,
    this.selections,
    this.columnWidth = 48,
    this.fixed = false,
    this.checkStrictly = false,
    this.hideSelectAll = false,
  });

  /// 受控选中行 key 集合（非 null 时进入受控模式）。
  final List<Object>? selectedRowKeys;

  /// 非受控初始选中行 key 集合。
  final List<Object>? defaultSelectedRowKeys;

  /// 选中项变化回调。
  final ValueChanged<List<Object>>? onChange;

  /// 行复选框属性（禁用等）。
  final AntTableRowCheckboxProps Function(Map<String, dynamic> record)?
      getCheckboxProps;

  /// 自定义选择项（表头复选框旁出现下拉菜单）。
  final List<AntTableRowSelectionItem>? selections;

  /// 选择列宽度。
  final double columnWidth;

  /// 选择列是否固定在左侧。
  final bool fixed;

  /// 父子行选中是否不关联（antd `checkStrictly`；默认 false 关联）。
  final bool checkStrictly;

  /// 是否隐藏表头全选框。
  final bool hideSelectAll;
}

// ============================================================
// 汇总行
// ============================================================

/// 汇总行单元格。
class AntTableSummaryCell {
  const AntTableSummaryCell({
    required this.columnIndex,
    this.colSpan = 1,
    required this.child,
  });

  /// 对应叶子列下标（按 columns 展开后的叶子顺序）。
  final int columnIndex;

  /// 横向合并列数。
  final int colSpan;

  /// 单元格内容。
  final Widget child;
}

/// 汇总行构建函数（对齐 antd `summary`）。
typedef AntTableSummaryFn = List<AntTableSummaryCell>? Function(
  List<Map<String, dynamic>> data,
);

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

/// 合并单元格配置函数（对齐 antd `column.onCell`）。
typedef AntTableCellSpanFn = AntTableCellSpan? Function(
  Map<String, dynamic> record,
  int rowIndex,
);

/// 排序变化回调。
typedef AntTableSortChangeFn = void Function(
  int leafIndex,
  AntTableSortOrder? order,
);

/// 筛选变化回调。
typedef AntTableFilterChangeFn = void Function(
  int leafIndex,
  List<Object>? filteredValue,
);

/// 展开行变化回调。
typedef AntTableExpandChangeFn = void Function(List<Object> expandedKeys);

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
    this.children,
    this.defaultSortOrder,
    this.sortOrder,
    this.sortDirections = const [
      AntTableSortOrder.ascend,
      AntTableSortOrder.descend,
    ],
    this.sortPriority,
    this.defaultFilteredValue,
    this.filteredValue,
    this.filterMultiple = true,
    this.onCell,
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

  /// 子列（非空时本列为表头分组列，展开为多级表头；叶子列才参与数据渲染）。
  final List<AntTableColumn>? children;

  /// 非受控初始排序方向。
  final AntTableSortOrder? defaultSortOrder;

  /// 受控排序方向（非 null 时排序由外部控制，点击触发
  /// [AntTable.onSortChange]）。
  final AntTableSortOrder? sortOrder;

  /// 点击表头的排序方向循环顺序。
  final List<AntTableSortOrder> sortDirections;

  /// 多列排序优先级（antd `sorter.multiple`；非 null 时参与多列排序链）。
  final int? sortPriority;

  /// 非受控初始筛选值。
  final List<Object>? defaultFilteredValue;

  /// 受控筛选值（非 null 时筛选由外部控制，变更触发
  /// [AntTable.onFilterChange]）。
  final List<Object>? filteredValue;

  /// 筛选面板是否多选（false 时为单选，对齐 antd `filterMultiple`）。
  final bool filterMultiple;

  /// 合并单元格配置（rowSpan / colSpan）。
  final AntTableCellSpanFn? onCell;
}
