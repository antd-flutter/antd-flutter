/// AntTable — antd React Table 的 Flutter 实现
///
/// API 与 antd React Table 对齐（核心 + 高级能力）：
/// - [AntTable.columns] — 列定义（排序 / 筛选 / 固定 / 渲染 / 省略 / 分组 / 合并）
/// - [AntTable.dataSource] — 行数据（`Map<String, dynamic>` 列表，支持 `children` 树形数据）
/// - [AntTable.rowKey] — 行 key 提取函数（默认取 `id`，缺省用下标）
/// - 排序 — sorter 列点击表头 升序 → 降序 → 取消；支持受控
///   [AntTableColumn.sortOrder]、初始 [AntTableColumn.defaultSortOrder]、
///   多列排序 [AntTableColumn.sortPriority]
/// - 筛选 — filters 列表头弹出多选/单选筛选菜单（确定 / 重置）；支持受控
///   [AntTableColumn.filteredValue] / 初始 [AntTableColumn.defaultFilteredValue]
/// - 固定列 — fixed left/right 横向滚动吸边（shadow 分隔）
/// - 固定表头 — scrollY 时表头固定、表体纵向滚动
/// - 虚拟滚动 — scrollY 且行数 > 50 时 `ListView.builder` 懒加载
/// - 合并单元格 — [AntTableColumn.onCell]（rowSpan / colSpan）
/// - 树形数据 — record `children` 缩进 + 展开穿梭，与行选择联动
/// - 行选择 — [AntTableRowSelection]（全选 / 半选 / getCheckboxProps /
///   selections 自定义 / 与树数据联动）
/// - 展开行 — [AntTable.expandedRowRender]
/// - 汇总行 — [AntTable.summary]（含固定列对齐）
/// - 表头分组 — [AntTableColumn.children] 多级表头
/// - pagination — 分页（页码 / 上一页 / 下一页）
/// - size / bordered / loading / empty
///
/// ```dart
/// AntTable(
///   columns: [AntTableColumn(title: '姓名', dataIndex: 'name')],
///   dataSource: [{'name': '张三'}],
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_table_types.dart';

export 'ant_table_types.dart';

// ============================================================
// 常量
// ============================================================

/// 虚拟滚动懒加载阈值（行数）
const int _kVirtualThreshold = 50;

/// 未指定宽度列的默认宽度（设计稿逻辑像素）
const double _kDefaultColumnWidth = 120;

/// 固定列分隔阴影宽度（设计稿逻辑像素）
const double _kFixedShadowWidth = 12;

/// 选择列默认宽度（设计稿逻辑像素）
const double _kDefaultSelectionWidth = 48;

/// 树形数据缩进步长（设计稿逻辑像素）
const double _kTreeIndentStep = 16;

/// 展开图标尺寸（设计稿逻辑像素）
const double _kExpandIconSize = 14;

// ============================================================
// 列结构（叶子列 + 表头节点）
// ============================================================

/// 叶子列（columns 展开后的数据列，leafIndex 为全局叶子序号）
class _LeafColumn {
  const _LeafColumn({
    required this.column,
    required this.leafIndex,
    required this.depth,
    this.inheritedFixed,
  });

  final AntTableColumn column;
  final int leafIndex;
  final int depth;

  /// 从祖先分组列继承的固定方向（分组列 fixed 作用于其全部叶子列）
  final AntTableFixed? inheritedFixed;

  AntTableFixed? get fixed => column.fixed ?? inheritedFixed;
}

/// 表头节点（分组列或叶子列，用于多级表头递归渲染）
class _HeaderNode {
  const _HeaderNode({
    required this.column,
    required this.depth,
    required this.children,
    required this.subtreeLeaves,
    this.leaf,
  });

  final AntTableColumn column;
  final int depth;
  final List<_HeaderNode> children;

  /// 本节点覆盖的叶子列（含嵌套后代）
  final List<_LeafColumn> subtreeLeaves;

  /// 叶子列（分组列为 null）
  final _LeafColumn? leaf;

  bool get isGroup => children.isNotEmpty;
}

// ============================================================
// AntTable
// ============================================================

/// 表格 — 展示行列数据。
///
/// 对齐 antd React Table 组件核心 + 高级 API。
class AntTable extends StatefulWidget {
  const AntTable({
    super.key,
    required this.columns,
    required this.dataSource,
    this.rowKey,
    this.scrollX,
    this.scrollY,
    this.pagination = false,
    this.pageSize = 10,
    this.size = AntTableSize.middle,
    this.bordered = false,
    this.loading = false,
    this.empty,
    this.rowSelection,
    this.expandedRowRender,
    this.defaultExpandAllRows = false,
    this.expandedRowKeys,
    this.onExpandedRowsChange,
    this.expandRowByClick = false,
    this.summary,
    this.onSortChange,
    this.onFilterChange,
    this.onPageChange,
  });

  /// 列定义。
  final List<AntTableColumn> columns;

  /// 数据源（行记录为 `Map<String, dynamic>`，支持 `children` 树形数据）。
  final List<Map<String, dynamic>> dataSource;

  /// 行 key 提取函数（默认取 `id` 字段，缺省用行下标）。
  final AntTableRowKeyFn? rowKey;

  /// 横向滚动内容宽度（大于可用宽度时出现横向滚动，固定列吸边）。
  final double? scrollX;

  /// 纵向滚动区域高度；行数超过阈值时启用虚拟滚动懒加载。
  final double? scrollY;

  /// 是否分页。
  final bool pagination;

  /// 每页行数。
  final int pageSize;

  /// 表格尺寸。
  final AntTableSize size;

  /// 是否显示边框。
  final bool bordered;

  /// 是否显示加载遮罩。
  final bool loading;

  /// 空数据占位（默认展示「暂无数据」）。
  final Widget? empty;

  /// 行选择配置。
  final AntTableRowSelection? rowSelection;

  /// 展开行内容构建（非 null 时行首叶子列出现展开图标）。
  final Widget? Function(Map<String, dynamic> record, int index)?
      expandedRowRender;

  /// 是否默认展开全部树形行。
  final bool defaultExpandAllRows;

  /// 受控展开行 key 集合（非 null 时展开由外部控制）。
  final List<Object>? expandedRowKeys;

  /// 展开行变化回调。
  final AntTableExpandChangeFn? onExpandedRowsChange;

  /// 点击行时切换展开态。
  final bool expandRowByClick;

  /// 汇总行构建（对齐 antd `summary`）。
  final AntTableSummaryFn? summary;

  /// 排序变化回调（leafIndex 为叶子列序号，order 为 null 表示取消排序）。
  final AntTableSortChangeFn? onSortChange;

  /// 筛选变化回调（filteredValue 为 null 表示已重置）。
  final AntTableFilterChangeFn? onFilterChange;

  /// 分页变化回调。
  final void Function(int page, int pageSize)? onPageChange;

  @override
  State<AntTable> createState() => _AntTableState();
}

class _AntTableState extends State<AntTable> {
  /// 各叶子列排序方向（非受控；受控列以 [AntTableColumn.sortOrder] 为准）
  Map<int, AntTableSortOrder> _sortStates = {};

  /// 各叶子列已选筛选项（叶子列序号 → 值集合；非受控）
  final Map<int, Set<Object>> _filterSelected = {};

  /// 当前页码（从 1 开始）
  int _currentPage = 1;

  /// 非受控选中行 key 集合
  Set<Object> _selectedKeys = {};

  /// 非受控展开行 key 集合（树形 + expandedRowRender 共用）
  Set<Object> _expandedKeys = {};

  /// 横向滚动控制器（表头与各行共享同一控制器，监听同步位移）
  late final ScrollController _hController = ScrollController();

  /// 横向滚动同步标志（防止递归）
  bool _syncingH = false;

  /// 筛选弹层
  OverlayEntry? _filterOverlay;

  /// 各列筛选图标的 LayerLink
  final Map<int, LayerLink> _filterLinks = {};

  /// 选择列下拉菜单的 LayerLink
  final LayerLink _selectionLink = LayerLink();

  /// 选择项下拉弹层
  OverlayEntry? _selectionOverlay;

  @override
  void initState() {
    super.initState();
    _initExpandState();
    _initSortState();
    _initFilterState();
    _initSelectionState();
    _hController.addListener(_onHScroll);
  }

  @override
  void didUpdateWidget(covariant AntTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.columns, widget.columns)) {
      _initSortState();
      _initFilterState();
    }
    if (!identical(oldWidget.dataSource, widget.dataSource)) {
      _initExpandState();
    }
  }

  @override
  void dispose() {
    _removeFilterOverlay();
    _removeSelectionOverlay();
    _hController.dispose();
    super.dispose();
  }

  void _initExpandState() {
    _expandedKeys = {...?widget.expandedRowKeys};
    if (widget.defaultExpandAllRows) {
      _expandedKeys.addAll(_allTreeKeys(widget.dataSource));
    }
  }

  void _initSortState() {
    final states = <int, AntTableSortOrder>{};
    for (final leaf in _leaves) {
      final initial = leaf.column.sortOrder ?? leaf.column.defaultSortOrder;
      if (initial != null && leaf.column.sortOrder == null) {
        states[leaf.leafIndex] = initial;
      }
    }
    _sortStates = states;
  }

  void _initFilterState() {
    for (final leaf in _leaves) {
      if (_filterSelected.containsKey(leaf.leafIndex)) continue;
      final initial =
          leaf.column.filteredValue ?? leaf.column.defaultFilteredValue;
      if (initial != null && leaf.column.filteredValue == null) {
        _filterSelected[leaf.leafIndex] = Set<Object>.from(initial);
      }
    }
  }

  void _initSelectionState() {
    _selectedKeys = {...?widget.rowSelection?.defaultSelectedRowKeys};
  }

  // ------------------------------------------------------------
  // 横向滚动同步
  // ------------------------------------------------------------

  /// 表头与各行滚动区共享同一控制器，任一位置滚动时同步其余位置
  void _onHScroll() {
    if (_syncingH) return;
    _syncingH = true;
    final positions = _hController.positions.toList();
    if (positions.isNotEmpty) {
      final offset = positions.first.pixels;
      for (final pos in positions) {
        final target = offset.clamp(0.0, pos.maxScrollExtent);
        if (pos.pixels != target) pos.jumpTo(target);
      }
    }
    _syncingH = false;
  }

  // ------------------------------------------------------------
  // 列结构
  // ------------------------------------------------------------

  /// 列树（表头节点，叶子列序号全局递增）
  List<_HeaderNode> get _headerTree {
    var counter = 0;
    _HeaderNode buildNode(
      AntTableColumn column,
      int depth,
      AntTableFixed? inheritedFixed,
    ) {
      final children = column.children;
      if (children == null || children.isEmpty) {
        final leaf = _LeafColumn(
          column: column,
          leafIndex: counter++,
          depth: depth,
          inheritedFixed: inheritedFixed,
        );
        return _HeaderNode(
          column: column,
          depth: depth,
          children: const [],
          subtreeLeaves: [leaf],
          leaf: leaf,
        );
      }
      final childNodes = [
        for (final child in children)
          buildNode(child, depth + 1, column.fixed ?? inheritedFixed),
      ];
      return _HeaderNode(
        column: column,
        depth: depth,
        children: childNodes,
        subtreeLeaves: [
          for (final node in childNodes) ...node.subtreeLeaves,
        ],
      );
    }

    return [for (final c in widget.columns) buildNode(c, 0, null)];
  }

  /// 叶子列（按 columns 顺序展开 children）
  List<_LeafColumn> get _leaves => [
        for (final node in _headerTree) ...node.subtreeLeaves,
      ];

  /// 表头最大层级数（1 = 单级表头）
  int get _headerDepth {
    var depth = 1;
    for (final node in _headerTree) {
      int walk(_HeaderNode n) {
        if (!n.isGroup) return n.depth + 1;
        var maxDepth = n.depth + 1;
        for (final child in n.children) {
          final childDepth = walk(child);
          maxDepth = maxDepth > childDepth ? maxDepth : childDepth;
        }
        return maxDepth;
      }

      final nodeDepth = walk(node);
      depth = depth > nodeDepth ? depth : nodeDepth;
    }
    return depth;
  }

  // ------------------------------------------------------------
  // 数据处理：筛选 → 排序 → 分页（递归支持树形数据）
  // ------------------------------------------------------------

  Object? _rowKeyOf(Map<String, dynamic> record, int index) =>
      widget.rowKey?.call(record) ?? record['id'] ?? index;

  List<Map<String, dynamic>>? _childrenOf(Map<String, dynamic> record) {
    final children = record['children'];
    if (children is List && children.isNotEmpty) {
      return children.cast<Map<String, dynamic>>();
    }
    return null;
  }

  _LeafColumn? _leafOf(int leafIndex) =>
      leafIndex >= 0 && leafIndex < _leaves.length ? _leaves[leafIndex] : null;

  /// 当前生效的排序方向（受控优先）
  AntTableSortOrder? _effectiveOrder(_LeafColumn leaf) =>
      leaf.column.sortOrder ?? _sortStates[leaf.leafIndex];

  /// 当前生效的筛选值（受控优先）
  Set<Object>? _effectiveFilter(_LeafColumn leaf) {
    final controlled = leaf.column.filteredValue;
    if (controlled != null) return Set<Object>.from(controlled);
    return _filterSelected[leaf.leafIndex];
  }

  /// 应用筛选与排序后的全量行（分页前，children 递归处理）
  List<Map<String, dynamic>> get _processedRows {
    var rows = List<Map<String, dynamic>>.from(widget.dataSource);

    // 筛选（保留命中行或含命中后代的父行）
    for (final leaf in _leaves) {
      final selected = _effectiveFilter(leaf);
      final onFilter = leaf.column.onFilter;
      if (onFilter == null || selected == null || selected.isEmpty) continue;
      rows = _filterRows(rows, selected, onFilter);
    }

    // 排序（单列 / 多列 sortPriority 链 / 自定义比较器）
    final sortedLeaves = [
      for (final leaf in _leaves)
        if (_effectiveOrder(leaf) != null && leaf.column.sorter != null) leaf,
    ]..sort((a, b) {
        final pa = a.column.sortPriority;
        final pb = b.column.sortPriority;
        if (pa != null && pb != null) return pa.compareTo(pb);
        if (pa != null) return -1;
        if (pb != null) return 1;
        return a.leafIndex.compareTo(b.leafIndex);
      });

    if (sortedLeaves.isNotEmpty) {
      int compare(Map<String, dynamic> a, Map<String, dynamic> b) {
        for (final leaf in sortedLeaves) {
          final result = leaf.column.sorter!(a, b);
          if (result != 0) {
            return _effectiveOrder(leaf) == AntTableSortOrder.descend
                ? -result
                : result;
          }
        }
        return 0;
      }

      rows = _sortRows(List<Map<String, dynamic>>.from(rows), compare);
    }

    return rows;
  }

  List<Map<String, dynamic>> _filterRows(
    List<Map<String, dynamic>> rows,
    Set<Object> selected,
    AntTableFilterFn onFilter,
  ) {
    return [
      for (final record in rows)
        if (_keepFiltered(record, selected, onFilter)) record,
    ];
  }

  bool _keepFiltered(
    Map<String, dynamic> record,
    Set<Object> selected,
    AntTableFilterFn onFilter,
  ) {
    final children = _childrenOf(record);
    var childrenKept = const <Map<String, dynamic>>[];
    if (children != null) {
      childrenKept = _filterRows(children, selected, onFilter);
    }
    if (childrenKept.isNotEmpty) {
      record['children'] = childrenKept;
      return true;
    }
    return selected.any((v) => onFilter(v, record));
  }

  List<Map<String, dynamic>> _sortRows(
    List<Map<String, dynamic>> rows,
    int Function(Map<String, dynamic>, Map<String, dynamic>) compare,
  ) {
    final sorted = [
      for (final record in rows)
        Map<String, dynamic>.from(record)
          ..['children'] = _childrenOf(record) == null
              ? null
              : _sortRows(
                  List<Map<String, dynamic>>.from(
                    _childrenOf(record)!,
                  ),
                  compare,
                ),
    ]..sort(compare);
    return sorted;
  }

  /// 展平后的展示行（树形行按展开态穿插 children）
  List<_DisplayRow> get _displayRows {
    final rows = _processedRows;
    final paged = _pageRows(rows);
    final result = <_DisplayRow>[];
    void flatten(List<Map<String, dynamic>> records, int depth) {
      for (var i = 0; i < records.length; i++) {
        final record = records[i];
        result.add(_DisplayRow(record: record, depth: depth, index: i));
        if (_isExpanded(_rowKeyOf(record, i))) {
          final children = _childrenOf(record);
          if (children != null) flatten(children, depth + 1);
        }
      }
    }

    flatten(paged, 0);
    return result;
  }

  List<Map<String, dynamic>> _pageRows(List<Map<String, dynamic>> rows) {
    if (!widget.pagination || rows.length <= widget.pageSize) return rows;
    final page = _currentPage.clamp(1, _pageCountOf(rows.length));
    final start = (page - 1) * widget.pageSize;
    return rows.skip(start).take(widget.pageSize).toList();
  }

  int _pageCountOf(int length) =>
      (length / widget.pageSize).ceil().clamp(1, 1 << 31);

  int get _pageCount => _pageCountOf(_processedRows.length);

  // ------------------------------------------------------------
  // 展开态（树形 + expandedRowRender）
  // ------------------------------------------------------------

  Set<Object> get _expandedState => widget.expandedRowKeys != null
      ? Set<Object>.from(widget.expandedRowKeys!)
      : _expandedKeys;

  bool _isExpanded(Object? key) => key != null && _expandedState.contains(key);

  void _toggleExpand(Object? key) {
    if (key == null) return;
    final next = Set<Object>.from(_expandedState);
    if (!next.remove(key)) next.add(key);
    _setExpanded(next);
  }

  void _setExpanded(Set<Object> next) {
    setState(() => _expandedKeys = next);
    widget.onExpandedRowsChange?.call(next.toList());
  }

  Set<Object> _allTreeKeys(List<Map<String, dynamic>> rows) {
    final keys = <Object>{};
    void walk(List<Map<String, dynamic>> records) {
      for (var i = 0; i < records.length; i++) {
        final key = _rowKeyOf(records[i], i);
        if (key != null) keys.add(key);
        final children = _childrenOf(records[i]);
        if (children != null) walk(children);
      }
    }

    walk(rows);
    return keys;
  }

  /// 行的后代 key 集合（行选择父子联动用）
  Set<Object> _descendantKeys(Map<String, dynamic> record) {
    final keys = <Object>{};
    void walk(List<Map<String, dynamic>> records, int baseIndex) {
      for (var i = 0; i < records.length; i++) {
        final key = _rowKeyOf(records[i], baseIndex + i);
        if (key != null) keys.add(key);
        final children = _childrenOf(records[i]);
        if (children != null) walk(children, baseIndex + i);
      }
    }

    final children = _childrenOf(record);
    if (children != null) walk(children, 0);
    return keys;
  }

  // ------------------------------------------------------------
  // 行选择
  // ------------------------------------------------------------

  AntTableRowSelection? get _selection => widget.rowSelection;

  Set<Object> get _selectedState => _selection?.selectedRowKeys != null
      ? Set<Object>.from(_selection!.selectedRowKeys!)
      : _selectedKeys;

  bool _isRowDisabled(Map<String, dynamic> record) =>
      _selection?.getCheckboxProps?.call(record).disabled ?? false;

  /// 行是否选中（父子关联模式：全部后代选中即视为选中）
  bool _isRowChecked(Map<String, dynamic> record) {
    final key = _rowKeyOf(record, 0);
    if (key == null || !_selectedState.contains(key)) {
      if (_selection?.checkStrictly ?? false) return false;
      final children = _childrenOf(record);
      if (children != null) {
        final descendants = _descendantKeys(record);
        return descendants.isNotEmpty &&
            descendants.every(_selectedState.contains);
      }
      return false;
    }
    return true;
  }

  /// 行是否半选（部分后代选中）
  bool _isRowIndeterminate(Map<String, dynamic> record) {
    if (_selection?.checkStrictly ?? false) return false;
    if (_isRowChecked(record)) return false;
    final children = _childrenOf(record);
    if (children == null) return false;
    final descendants = _descendantKeys(record);
    return descendants.any(_selectedState.contains);
  }

  /// 全部可选（未禁用）行 key
  Set<Object> get _selectableKeys {
    final keys = <Object>{};
    void walk(List<Map<String, dynamic>> records) {
      for (var i = 0; i < records.length; i++) {
        final record = records[i];
        final key = _rowKeyOf(record, i);
        if (key != null && !_isRowDisabled(record)) keys.add(key);
        final children = _childrenOf(record);
        if (children != null) walk(children);
      }
    }

    walk(_processedRows);
    return keys;
  }

  void _setSelected(Set<Object> next) {
    setState(() => _selectedKeys = next);
    _selection?.onChange?.call(next.toList());
  }

  void _toggleRowSelection(Map<String, dynamic> record) {
    if (record.isEmpty || _isRowDisabled(record)) return;
    final key = _rowKeyOf(record, 0);
    if (key == null) return;
    final next = Set<Object>.from(_selectedState);
    final checked = _isRowChecked(record);
    final strictly = _selection?.checkStrictly ?? false;
    final affected =
        strictly ? <Object>{key} : {key, ..._descendantKeys(record)};
    if (checked) {
      next.removeAll(affected);
    } else {
      for (final k in affected) {
        final target = _findRecord(k);
        if (target == null || !_isRowDisabled(target)) next.add(k);
      }
    }
    _setSelected(next);
  }

  Map<String, dynamic>? _findRecord(Object key) {
    Map<String, dynamic>? find(List<Map<String, dynamic>> records) {
      for (var i = 0; i < records.length; i++) {
        if (_rowKeyOf(records[i], i) == key) return records[i];
        final children = _childrenOf(records[i]);
        if (children != null) {
          final found = find(children);
          if (found != null) return found;
        }
      }
      return null;
    }

    return find(widget.dataSource);
  }

  bool get _allSelected {
    final selectable = _selectableKeys;
    if (selectable.isEmpty) return false;
    return selectable.every(_selectedState.contains);
  }

  bool get _someSelected {
    final selectable = _selectableKeys;
    return selectable.any(_selectedState.contains) && !_allSelected;
  }

  void _toggleSelectAll() {
    final next = Set<Object>.from(_selectedState);
    final selectable = _selectableKeys;
    if (_allSelected) {
      next.removeAll(selectable);
    } else {
      next.addAll(selectable);
    }
    _setSelected(next);
  }

  // ------------------------------------------------------------
  // 排序交互
  // ------------------------------------------------------------

  void _handleSortTap(int leafIndex) {
    final leaf = _leafOf(leafIndex);
    if (leaf == null) return;
    final controlled = leaf.column.sortOrder != null;
    final current = _effectiveOrder(leaf);
    final directions = leaf.column.sortDirections.isEmpty
        ? const [AntTableSortOrder.ascend, AntTableSortOrder.descend]
        : leaf.column.sortDirections;

    AntTableSortOrder? next;
    if (current == null) {
      next = directions.first;
    } else {
      final idx = directions.indexOf(current);
      next =
          idx >= 0 && idx + 1 < directions.length ? directions[idx + 1] : null;
    }

    if (!controlled) {
      setState(() {
        // 单列排序：清除其他列排序态；多列排序（sortPriority）保留
        if (leaf.column.sortPriority == null) {
          _sortStates = <int, AntTableSortOrder>{};
        } else {
          _sortStates = Map<int, AntTableSortOrder>.from(_sortStates)
            ..remove(leafIndex);
        }
        if (next != null) _sortStates[leafIndex] = next;
      });
    }
    widget.onSortChange?.call(leafIndex, next);
  }

  // ------------------------------------------------------------
  // 筛选交互
  // ------------------------------------------------------------

  void _toggleFilterOverlay(int leafIndex, AntThemeData theme) {
    if (_filterOverlay != null) {
      _removeFilterOverlay();
      return;
    }
    _showFilterOverlay(leafIndex, theme);
  }

  void _showFilterOverlay(int leafIndex, AntThemeData theme) {
    final link = _filterLinks.putIfAbsent(leafIndex, () => LayerLink());
    final leaf = _leafOf(leafIndex);
    if (leaf == null) return;
    final entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 点击空白处关闭
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeFilterOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: link,
              showWhenUnlinked: false,
              // 右对齐打开，避免靠近屏幕右缘时面板越界
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: Offset(0, 4.w),
              child: _FilterPanel(
                theme: theme,
                items: leaf.column.filters ?? const [],
                initialSelected: _effectiveFilter(leaf) ?? <Object>{},
                multiple: leaf.column.filterMultiple,
                onConfirm: (selected) {
                  _applyFilter(leafIndex, leaf, selected);
                  _removeFilterOverlay();
                },
                onReset: () {
                  _applyFilter(leafIndex, leaf, const <Object>{});
                  _removeFilterOverlay();
                },
              ),
            ),
          ],
        );
      },
    );
    _filterOverlay = entry;
    Overlay.of(context).insert(entry);
  }

  void _applyFilter(int leafIndex, _LeafColumn leaf, Set<Object> selected) {
    final controlled = leaf.column.filteredValue != null;
    if (!controlled) {
      setState(() {
        if (selected.isEmpty) {
          _filterSelected.remove(leafIndex);
        } else {
          _filterSelected[leafIndex] = selected;
        }
        _currentPage = 1;
      });
    } else {
      _currentPage = 1;
    }
    widget.onFilterChange?.call(
      leafIndex,
      selected.isEmpty ? null : selected.toList(),
    );
  }

  void _removeFilterOverlay() {
    _filterOverlay?.remove();
    _filterOverlay = null;
  }

  // ------------------------------------------------------------
  // 自定义选择项下拉
  // ------------------------------------------------------------

  void _toggleSelectionOverlay(AntThemeData theme) {
    if (_selectionOverlay != null) {
      _removeSelectionOverlay();
      return;
    }
    final selections = _selection?.selections;
    if (selections == null || selections.isEmpty) return;
    final entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeSelectionOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _selectionLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: Offset(0, 4.w),
              child: Material(
                color: theme.colorBgContainer,
                elevation: 6,
                shadowColor: theme.colorText.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(theme.borderRadiusLG),
                child: Container(
                  width: 120.w,
                  padding: EdgeInsets.symmetric(vertical: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG),
                    border: Border.all(color: theme.colorSplit),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in selections)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _removeSelectionOverlay();
                            item.onSelect(_selectableKeys);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.w,
                            ),
                            child: Text(
                              item.text,
                              style: TextStyle(
                                fontSize: theme.fontSizeSM,
                                color: theme.colorText,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    _selectionOverlay = entry;
    Overlay.of(context).insert(entry);
  }

  void _removeSelectionOverlay() {
    _selectionOverlay?.remove();
    _selectionOverlay = null;
  }

  // ------------------------------------------------------------
  // 尺寸令牌
  // ------------------------------------------------------------

  double get _cellPaddingV {
    switch (widget.size) {
      case AntTableSize.large:
        return 16;
      case AntTableSize.middle:
        return 12;
      case AntTableSize.small:
        return 8;
    }
  }

  double get _cellFontSize {
    switch (widget.size) {
      case AntTableSize.large:
        return 16;
      case AntTableSize.middle:
      case AntTableSize.small:
        return 14;
    }
  }

  /// 表头单行高度（固定高度保证多级表头纵向对齐）
  double get _headerRowHeight => (_cellPaddingV * 2 + _cellFontSize * 1.5).w;

  double _columnWidth(AntTableColumn column) =>
      (column.width ?? _kDefaultColumnWidth).w;

  bool get _hasScrollX => widget.scrollX != null;

  /// 是否存在可展开内容（树形数据或 expandedRowRender）
  bool get _hasExpandable =>
      widget.expandedRowRender != null ||
      widget.dataSource.any((r) => _childrenOf(r) != null);

  // ============================================================
  // build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final rows = _displayRows;
    final summaryCells = widget.summary?.call(_processedRows);

    final table = Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: widget.bordered ? Border.all(color: theme.colorSplit) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          if (rows.isEmpty) _buildEmpty(theme) else _buildBody(theme, rows),
          if (summaryCells != null && summaryCells.isNotEmpty)
            _buildSummary(theme, summaryCells),
          if (widget.pagination &&
              _processedRows.length > widget.pageSize &&
              rows.isNotEmpty)
            _buildPagination(theme),
        ],
      ),
    );

    if (!widget.loading) return table;

    // 加载遮罩
    return Stack(
      children: [
        table,
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            color: theme.colorBgContainer.withValues(alpha: 0.45),
            child: CircularProgressIndicator(
              color: theme.colorPrimary,
              strokeWidth: 3.w,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // 分段骨架（固定列拆分：selection? | left | middle(scroll) | right）
  // ------------------------------------------------------------

  List<_LeafColumn> get _leftLeaves => [
        for (final leaf in _leaves)
          if (leaf.fixed == AntTableFixed.left) leaf,
      ];

  List<_LeafColumn> get _rightLeaves => [
        for (final leaf in _leaves)
          if (leaf.fixed == AntTableFixed.right) leaf,
      ];

  List<_LeafColumn> get _middleLeaves => [
        for (final leaf in _leaves)
          if (leaf.fixed == null) leaf,
      ];

  List<_HeaderNode> _topNodesOf(AntTableFixed? fixed) => [
        for (final node in _headerTree)
          if (node.subtreeLeaves.first.fixed == fixed) node,
      ];

  double get _middleWidth {
    var width = 0.0;
    for (final leaf in _middleLeaves) {
      width += _columnWidth(leaf.column);
    }
    return width;
  }

  /// 表头（固定表头：表体 scrollY 滚动时表头不随之滚动）
  Widget _buildHeader(AntThemeData theme) {
    return Container(
      key: const ValueKey('ant_table_header'),
      color: theme.colorFillQuaternary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selection != null) _buildSelectionHeaderCell(theme),
          ..._headerSegmentCells(theme, _topNodesOf(AntTableFixed.left)),
          if (_topNodesOf(AntTableFixed.left).isNotEmpty && _hasScrollX)
            _buildShadow(theme, isLeft: true),
          Expanded(
            child: _hasScrollX
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _hController,
                    child: SizedBox(
                      width: _middleWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _headerSegmentCells(
                          theme,
                          _topNodesOf(null),
                        ),
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _headerSegmentCells(theme, _topNodesOf(null)),
                  ),
          ),
          if (_topNodesOf(AntTableFixed.right).isNotEmpty && _hasScrollX)
            _buildShadow(theme, isLeft: false),
          ..._headerSegmentCells(theme, _topNodesOf(AntTableFixed.right)),
        ],
      ),
    );
  }

  /// 表头分段单元格列表（顶层列 → 递归多级表头）
  List<Widget> _headerSegmentCells(
    AntThemeData theme,
    List<_HeaderNode> nodes,
  ) {
    final cells = <Widget>[];
    for (final node in nodes) {
      final cell = _buildHeaderNodeCell(theme, node);
      final subtree = node.subtreeLeaves;
      final allWidth = subtree.every((l) => l.column.width != null);
      if (allWidth || _hasScrollX) {
        cells.add(
          SizedBox(
            width: subtree.fold<double>(
              0,
              (w, l) => w + _columnWidth(l.column),
            ),
            child: cell,
          ),
        );
      } else {
        cells.add(Expanded(child: cell));
      }
    }
    return cells;
  }

  /// 表头节点单元格（分组列：标题 + 子列递归；叶子列：标题 + 排序/筛选）
  Widget _buildHeaderNodeCell(AntThemeData theme, _HeaderNode node) {
    if (!node.isGroup) {
      return _buildHeaderLeafCell(theme, node.leaf!);
    }

    Widget title = _cellText(
      theme,
      node.column.title,
      color: theme.colorText,
      fontWeight: FontWeight.w600,
    );
    if (node.column.align == AntTableAlign.center) {
      title = Center(child: title);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _headerRowHeight,
          child: Center(heightFactor: 1, child: title),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _headerSegmentCells(theme, node.children),
        ),
      ],
    );
  }

  /// 表体 / 汇总行骨架：selection 列 + 左固定 | 滚动中段 | 右固定
  Widget _buildBodySkeletonRow(
    AntThemeData theme, {
    required Widget Function(_LeafColumn leaf, int colSpan) cellBuilder,
    Set<int>? hiddenLeaves,
    Map<String, dynamic>? record,
    required bool isSelectionRow,
    int Function(int leafIndex)? colSpanResolver,
  }) {
    final children = <Widget>[
      // 选择列（始终吸左）
      if (_selection != null && isSelectionRow)
        _buildSelectionBodyCell(theme, record ?? const {}),

      // 固定在左侧的列
      ..._leafSegmentCells(
        _leftLeaves,
        cellBuilder,
        hiddenLeaves: hiddenLeaves,
        colSpanResolver: colSpanResolver,
      ),
      if (_leftLeaves.isNotEmpty && _hasScrollX)
        _buildShadow(theme, isLeft: true),

      // 中间可横向滚动区域
      Expanded(
        child: _hasScrollX
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _hController,
                child: SizedBox(
                  width: _middleWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _leafSegmentCells(
                      _middleLeaves,
                      cellBuilder,
                      hiddenLeaves: hiddenLeaves,
                      colSpanResolver: colSpanResolver,
                    ),
                  ),
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _leafSegmentCells(
                  _middleLeaves,
                  cellBuilder,
                  hiddenLeaves: hiddenLeaves,
                  colSpanResolver: colSpanResolver,
                ),
              ),
      ),

      // 右侧固定列分隔阴影
      if (_rightLeaves.isNotEmpty && _hasScrollX)
        _buildShadow(theme, isLeft: false),
      // 固定在右侧的列
      ..._leafSegmentCells(
        _rightLeaves,
        cellBuilder,
        hiddenLeaves: hiddenLeaves,
        colSpanResolver: colSpanResolver,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  /// 单个分段（一组叶子列）的单元格列表，处理 colSpan 合并消费
  List<Widget> _leafSegmentCells(
    List<_LeafColumn> leaves,
    Widget Function(_LeafColumn leaf, int colSpan) cellBuilder, {
    Set<int>? hiddenLeaves,
    int Function(int leafIndex)? colSpanResolver,
  }) {
    final cells = <Widget>[];
    final consumed = <int>{};
    for (var pos = 0; pos < leaves.length; pos++) {
      final leaf = leaves[pos];
      if (consumed.contains(leaf.leafIndex)) continue;
      if (hiddenLeaves?.contains(leaf.leafIndex) ?? false) {
        // 被 rowSpan 合并覆盖的列不渲染
        continue;
      }

      final colSpan = colSpanResolver?.call(leaf.leafIndex) ??
          (leaf.column.onCell != null
              ? (leaf
                      .column
                      .onCell!(
                    _spanRecord ?? const {},
                    _spanRowIndex,
                  )
                      ?.colSpan ??
                  1)
              : 1);

      // colSpan 在分段内消费后续叶子列
      var effective = 1;
      var widthSum = _columnWidth(leaf.column);
      var allWidth = leaf.column.width != null;
      while (effective < colSpan && pos + effective < leaves.length) {
        final next = leaves[pos + effective];
        consumed.add(next.leafIndex);
        widthSum += _columnWidth(next.column);
        allWidth = allWidth && next.column.width != null;
        effective++;
      }

      final cell = cellBuilder(leaf, effective);
      if (allWidth || _hasScrollX) {
        cells.add(SizedBox(width: widthSum, child: cell));
      } else {
        cells.add(Expanded(child: cell));
      }
    }
    return cells;
  }

  /// colSpan 计算上下文（骨架构建期的临时上下文）
  Map<String, dynamic>? _spanRecord;
  int _spanRowIndex = 0;

  // ------------------------------------------------------------
  // 表体
  // ------------------------------------------------------------

  Widget _buildBody(AntThemeData theme, List<_DisplayRow> rows) {
    final spans = _computeRowSpans(rows);

    Widget rowWidget(int index) {
      final row = rows[index];
      final record = row.record;
      final key = _rowKeyOf(record, index);

      _spanRecord = record;
      _spanRowIndex = index;
      final rowContent = _buildBodySkeletonRow(
        theme,
        record: record,
        isSelectionRow: true,
        hiddenLeaves: spans.hidden[index],
        cellBuilder: (leaf, colSpan) =>
            _buildBodyCell(theme, leaf, row, colSpan),
      );
      _spanRecord = null;

      Widget content = rowContent;
      if (_hasExpandable) {
        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.expandRowByClick ? () => _toggleExpand(key) : null,
          child: rowContent,
        );
      }

      return Container(
        key: ValueKey<Object?>('ant_table_row_${_rowKeyOf(record, index)}'),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.colorSplit)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            if (_isExpanded(key) && widget.expandedRowRender != null)
              _buildExpandedContent(theme, record, index),
          ],
        ),
      );
    }

    // 虚拟滚动：scrollY 且行数超阈值 → ListView.builder 懒加载
    if (widget.scrollY != null) {
      if (rows.length > _kVirtualThreshold) {
        return SizedBox(
          height: widget.scrollY!.w,
          child: ListView.builder(
            itemCount: rows.length,
            findChildIndexCallback: (key) {
              final recordKey = (key as ValueKey<Object?>).value;
              for (var i = 0; i < rows.length; i++) {
                if (_rowKeyOf(rows[i].record, i) == recordKey) return i;
              }
              return null;
            },
            itemBuilder: (context, index) => rowWidget(index),
          ),
        );
      }
      return SizedBox(
        height: widget.scrollY!.w,
        child: ListView(
          children: [for (var i = 0; i < rows.length; i++) rowWidget(i)],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (var i = 0; i < rows.length; i++) rowWidget(i)],
    );
  }

  /// 展开行内容区
  Widget _buildExpandedContent(
    AntThemeData theme,
    Map<String, dynamic> record,
    int index,
  ) {
    final content = widget.expandedRowRender?.call(record, index);
    if (content == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      color: theme.colorFillQuaternary.withValues(alpha: 0.35),
      child: KeyedSubtree(
        key: ValueKey('ant_table_expanded_$index'),
        child: content,
      ),
    );
  }

  /// 计算合并单元格的隐藏格与 rowSpan 值
  _RowSpanInfo _computeRowSpans(List<_DisplayRow> rows) {
    final hidden = <int, Set<int>>{};
    final pending = <int, int>{}; // leafIndex → 剩余隐藏行数

    for (var r = 0; r < rows.length; r++) {
      final record = rows[r].record;
      final rowHidden = <int>{};
      for (final leaf in _leaves) {
        final onCell = leaf.column.onCell;
        if (onCell == null) continue;
        final pendingLeft = pending[leaf.leafIndex];
        if (pendingLeft != null && pendingLeft > 0) {
          rowHidden.add(leaf.leafIndex);
          pending[leaf.leafIndex] = pendingLeft - 1;
          continue;
        }
        final span = onCell(record, r);
        if (span == null) continue;
        final rowSpan = span.rowSpan ?? 1;
        if (rowSpan == 0) rowHidden.add(leaf.leafIndex);
        if (rowSpan > 1) {
          pending[leaf.leafIndex] = rowSpan - 1;
        }
      }
      if (rowHidden.isNotEmpty) hidden[r] = rowHidden;
    }
    return _RowSpanInfo(hidden: hidden);
  }

  // ------------------------------------------------------------
  // 单元格
  // ------------------------------------------------------------

  Widget _buildBodyCell(
    AntThemeData theme,
    _LeafColumn leaf,
    _DisplayRow row,
    int colSpan,
  ) {
    final column = leaf.column;
    final record = row.record;
    final isTreeParent = _childrenOf(record) != null;
    final isFirstLeaf = leaf.leafIndex == _leaves.first.leafIndex;
    final key = _rowKeyOf(record, row.index);

    final value = column.dataIndex == null ? null : record[column.dataIndex];
    Widget content = column.render?.call(value, record, row.index) ??
        _cellText(
          theme,
          value?.toString() ?? '',
          color: theme.colorText,
        );

    // 树形缩进 + 展开图标 / expandedRowRender 展开图标（内联行首叶子列）
    if (isFirstLeaf && _hasExpandable) {
      content = Row(
        children: [
          SizedBox(width: row.depth * _kTreeIndentStep.w),
          _ExpandIcon(
            theme: theme,
            rowKey: key,
            expanded: _isExpanded(key),
            visible: isTreeParent || widget.expandedRowRender != null,
            onTap: () => _toggleExpand(key),
          ),
          Expanded(child: content),
        ],
      );
    } else if (isFirstLeaf && row.depth > 0) {
      content = Row(
        children: [
          SizedBox(width: row.depth * _kTreeIndentStep.w),
          Expanded(child: content),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: _cellPaddingV.w,
      ),
      decoration: BoxDecoration(
        border: widget.bordered
            ? Border(right: BorderSide(color: theme.colorSplit))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: content)],
      ),
    );
  }

  Widget _cellText(
    AntThemeData theme,
    String text, {
    required Color color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
        fontSize: _cellFontSize.sp,
        color: color,
        fontWeight: fontWeight,
        height: 1.5,
      ),
    );
  }

  // ------------------------------------------------------------
  // 表头叶子单元格（标题 + 排序 + 筛选 + 层级填充）
  // ------------------------------------------------------------

  Widget _buildHeaderLeafCell(AntThemeData theme, _LeafColumn leaf) {
    final column = leaf.column;
    final fillerRows = (_headerDepth - 1 - leaf.depth).clamp(0, 1 << 31);

    Widget title = _cellText(
      theme,
      column.title,
      color: theme.colorText,
      fontWeight: FontWeight.w600,
    );

    final align = column.align;
    if (align == AntTableAlign.center) {
      title = Center(child: title);
    } else if (align == AntTableAlign.right) {
      title = Align(alignment: Alignment.centerRight, child: title);
    }

    Widget cell = SizedBox(
      height: _headerRowHeight,
      child: Center(heightFactor: 1, child: title),
    );

    // 排序：整格可点击
    if (column.sorter != null) {
      cell = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleSortTap(leaf.leafIndex),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: cell),
            _buildSortIcons(theme, leaf),
          ],
        ),
      );
    }

    // 筛选：标题旁筛选图标
    if (column.filters != null && column.filters!.isNotEmpty) {
      cell = Row(
        children: [
          Expanded(child: cell),
          _buildFilterIcon(theme, leaf),
        ],
      );
    }

    // 多级表头：叶子列未到底时向下填充
    if (fillerRows > 0) {
      cell = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cell,
          SizedBox(height: fillerRows * _headerRowHeight),
        ],
      );
    }
    return cell;
  }

  /// 排序图标（升 / 降两枚，激活态主题色着色）
  Widget _buildSortIcons(AntThemeData theme, _LeafColumn leaf) {
    final order = _effectiveOrder(leaf);
    final activeColor = theme.colorPrimary;
    final inactiveColor = theme.colorTextQuaternary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.arrow_upward,
          size: 12.w,
          color:
              order == AntTableSortOrder.ascend ? activeColor : inactiveColor,
        ),
        Icon(
          Icons.arrow_downward,
          size: 12.w,
          color:
              order == AntTableSortOrder.descend ? activeColor : inactiveColor,
        ),
      ],
    );
  }

  /// 筛选图标（点击弹出筛选菜单）
  Widget _buildFilterIcon(AntThemeData theme, _LeafColumn leaf) {
    final link = _filterLinks.putIfAbsent(leaf.leafIndex, () => LayerLink());
    final active = _effectiveFilter(leaf)?.isNotEmpty ?? false;
    return CompositedTransformTarget(
      link: link,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleFilterOverlay(leaf.leafIndex, theme),
        child: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Icon(
            Icons.filter_alt_outlined,
            size: 14.w,
            color: active ? theme.colorPrimary : theme.colorTextQuaternary,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 选择列
  // ------------------------------------------------------------

  Widget _buildSelectionHeaderCell(AntThemeData theme) {
    final selection = _selection!;
    final showMenu =
        selection.selections != null && selection.selections!.isNotEmpty;
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!selection.hideSelectAll)
          _TableCheckbox(
            key: const ValueKey('ant_table_checkbox_header'),
            theme: theme,
            checked: _allSelected,
            indeterminate: _someSelected,
            onTap: _toggleSelectAll,
          ),
        if (showMenu)
          CompositedTransformTarget(
            link: _selectionLink,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _toggleSelectionOverlay(theme),
              child: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 14.w,
                  color: theme.colorTextSecondary,
                ),
              ),
            ),
          ),
      ],
    );
    return SizedBox(
      key: const ValueKey('ant_table_th_selection'),
      width: _selectionWidth.w,
      height: _headerRowHeight,
      child: Center(child: content),
    );
  }

  Widget _buildSelectionBodyCell(
    AntThemeData theme,
    Map<String, dynamic> record,
  ) {
    return SizedBox(
      key: const ValueKey('ant_table_td_selection'),
      width: _selectionWidth.w,
      child: Center(
        child: _TableCheckbox(
          key: ValueKey('ant_table_checkbox_row_${_rowKeyOf(record, 0)}'),
          theme: theme,
          checked: _isRowChecked(record),
          indeterminate: _isRowIndeterminate(record),
          onTap: () => _toggleRowSelection(record),
        ),
      ),
    );
  }

  double get _selectionWidth {
    final width = _selection?.columnWidth ?? _kDefaultSelectionWidth;
    return width > 0 ? width : _kDefaultSelectionWidth;
  }

  // ------------------------------------------------------------
  // 汇总行
  // ------------------------------------------------------------

  Widget _buildSummary(
    AntThemeData theme,
    List<AntTableSummaryCell> cells,
  ) {
    final cellByIndex = {for (final c in cells) c.columnIndex: c};
    return Container(
      key: const ValueKey('ant_table_summary'),
      decoration: BoxDecoration(
        color: theme.colorFillQuaternary.withValues(alpha: 0.35),
        border: Border(top: BorderSide(color: theme.colorSplit)),
      ),
      child: _buildBodySkeletonRow(
        theme,
        isSelectionRow: false,
        cellBuilder: (leaf, colSpan) {
          final cell = cellByIndex[leaf.leafIndex];
          if (cell == null) return const SizedBox.shrink();
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: _cellPaddingV.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: cell.child)],
            ),
          );
        },
        colSpanResolver: (leafIndex) => cellByIndex[leafIndex]?.colSpan ?? 1,
      ),
    );
  }

  // ------------------------------------------------------------
  // 固定列分隔阴影
  // ------------------------------------------------------------

  Widget _buildShadow(AntThemeData theme, {required bool isLeft}) {
    final color = theme.colorText.withValues(alpha: 0.08);
    return Container(
      width: _kFixedShadowWidth.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 空数据占位
  // ------------------------------------------------------------

  Widget _buildEmpty(AntThemeData theme) {
    if (widget.empty != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.w),
        child: Center(child: widget.empty!),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48.w,
            color: theme.colorTextQuaternary,
          ),
          SizedBox(height: 8.w),
          Text(
            '暂无数据',
            style: TextStyle(
              fontSize: _cellFontSize.sp,
              color: theme.colorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 分页
  // ------------------------------------------------------------

  Widget _buildPagination(AntThemeData theme) {
    final pageCount = _pageCount;
    final page = _currentPage.clamp(1, pageCount);

    Widget pageButton(int n) {
      final isCurrent = n == page;
      return GestureDetector(
        onTap: () {
          setState(() => _currentPage = n);
          widget.onPageChange?.call(n, widget.pageSize);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          key: ValueKey('ant_table_page_$n'),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
          decoration: BoxDecoration(
            color: isCurrent ? theme.colorPrimaryBg : Colors.transparent,
            borderRadius: BorderRadius.circular(theme.borderRadiusXS),
          ),
          child: Text(
            '$n',
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: isCurrent ? theme.colorPrimary : theme.colorText,
            ),
          ),
        ),
      );
    }

    Widget arrowButton(
      IconData icon, {
      required bool disabled,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Icon(
            icon,
            size: 16.w,
            color: disabled ? theme.colorTextQuaternary : theme.colorText,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorSplit)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          arrowButton(
            Icons.chevron_left,
            disabled: page <= 1,
            onTap: () {
              setState(() => _currentPage = page - 1);
              widget.onPageChange?.call(page - 1, widget.pageSize);
            },
          ),
          for (var n = 1; n <= pageCount; n++) pageButton(n),
          arrowButton(
            Icons.chevron_right,
            disabled: page >= pageCount,
            onTap: () {
              setState(() => _currentPage = page + 1);
              widget.onPageChange?.call(page + 1, widget.pageSize);
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 辅助类型
// ============================================================

class _DisplayRow {
  const _DisplayRow({
    required this.record,
    required this.depth,
    required this.index,
  });

  final Map<String, dynamic> record;
  final int depth;
  final int index;
}

class _RowSpanInfo {
  const _RowSpanInfo({required this.hidden});

  /// 行下标 → 被上方 rowSpan 合并覆盖（不渲染）的叶子列下标
  final Map<int, Set<int>> hidden;
}

// ============================================================
// _ExpandIcon — 树形 / 展开行图标
// ============================================================

class _ExpandIcon extends StatelessWidget {
  const _ExpandIcon({
    required this.theme,
    required this.rowKey,
    required this.expanded,
    required this.visible,
    required this.onTap,
  });

  final AntThemeData theme;
  final Object? rowKey;
  final bool expanded;
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return GestureDetector(
      key: ValueKey('ant_table_expand_${rowKey ?? ''}_$expanded'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 6.w),
        child: Icon(
          expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
          size: _kExpandIconSize.w,
          color: theme.colorTextSecondary,
        ),
      ),
    );
  }
}

// ============================================================
// _TableCheckbox — 表格行选择复选框（token 自绘）
// ============================================================

class _TableCheckbox extends StatelessWidget {
  const _TableCheckbox({
    super.key,
    required this.theme,
    required this.checked,
    required this.indeterminate,
    required this.onTap,
  });

  final AntThemeData theme;
  final bool checked;
  final bool indeterminate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const size = 16.0;
    final borderColor =
        checked || indeterminate ? theme.colorPrimary : theme.colorBorder;
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: checked || indeterminate ? theme.colorPrimary : null,
          border: Border.all(color: borderColor, width: 1.w),
          borderRadius: BorderRadius.circular(theme.borderRadiusXS),
        ),
        child: checked || indeterminate
            ? Icon(
                indeterminate ? Icons.remove : Icons.check,
                size: size.w * 0.75,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

// ============================================================
// _FilterPanel — 筛选菜单面板
// ============================================================

class _FilterPanel extends StatefulWidget {
  const _FilterPanel({
    required this.theme,
    required this.items,
    required this.initialSelected,
    required this.multiple,
    required this.onConfirm,
    required this.onReset,
  });

  final AntThemeData theme;
  final List<AntTableFilterItem> items;
  final Set<Object> initialSelected;
  final bool multiple;
  final ValueChanged<Set<Object>> onConfirm;
  final VoidCallback onReset;

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  late final Set<Object> _selected = {...widget.initialSelected};

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Material(
      color: theme.colorBgContainer,
      elevation: 6,
      shadowColor: theme.colorText.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.borderRadiusLG),
          border: Border.all(color: theme.colorSplit),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in widget.items)
              GestureDetector(
                key: ValueKey('ant_table_filter_option_${item.value}'),
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  if (!widget.multiple) {
                    // 单选模式
                    _selected
                      ..clear()
                      ..add(item.value);
                    return;
                  }
                  if (!_selected.remove(item.value)) {
                    _selected.add(item.value);
                  }
                }),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      Icon(
                        widget.multiple
                            ? (_selected.contains(item.value)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank)
                            : (_selected.contains(item.value)
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                        size: 16.w,
                        color: _selected.contains(item.value)
                            ? theme.colorPrimary
                            : theme.colorBorder,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: theme.fontSizeSM,
                            color: theme.colorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Divider(color: theme.colorSplit, height: 16.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filterAction(
                    theme,
                    '重置',
                    widget.onReset,
                    semanticKey: 'ant_table_filter_reset',
                  ),
                  _filterAction(
                    theme,
                    '确定',
                    () => widget.onConfirm(Set<Object>.from(_selected)),
                    highlight: true,
                    semanticKey: 'ant_table_filter_confirm',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterAction(
    AntThemeData theme,
    String label,
    VoidCallback onTap, {
    bool highlight = false,
    String? semanticKey,
  }) {
    final color = highlight ? theme.colorPrimary : theme.colorTextSecondary;
    return GestureDetector(
      key: semanticKey == null ? null : ValueKey(semanticKey),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: theme.fontSizeSM,
          color: color,
          fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
