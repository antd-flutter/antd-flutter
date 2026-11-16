/// AntTable — antd React Table 的 Flutter 实现
///
/// API 与 antd React Table 对齐（核心能力）：
/// - [columns] — 列定义（排序 / 筛选 / 固定 / 渲染 / 省略）
/// - [dataSource] — 行数据（`Map<String, dynamic>` 列表）
/// - [rowKey] — 行 key 提取函数（默认取 `id`，缺省用下标）
/// - 排序 — sorter 列点击表头 升序 → 降序 → 取消
/// - 筛选 — filters 列表头弹出多选筛选菜单（确定 / 重置）
/// - 固定列 — fixed left/right 横向滚动吸边（shadow 分隔）
/// - 虚拟滚动 — scrollY 且行数 > 50 时 `ListView.builder` 懒加载
/// - pagination — 简版分页（页码 / 上一页 / 下一页）
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

// ============================================================
// AntTable
// ============================================================

/// 表格 — 展示行列数据。
///
/// 对齐 antd React Table 组件核心 API。
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
  });

  /// 列定义。
  final List<AntTableColumn> columns;

  /// 数据源（行记录为 `Map<String, dynamic>`）。
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

  @override
  State<AntTable> createState() => _AntTableState();
}

class _AntTableState extends State<AntTable> {
  /// 当前排序列下标（-1 表示无）
  int _sortColumnIndex = -1;

  /// 当前排序方向（null 表示取消排序）
  AntTableSortOrder? _sortOrder;

  /// 各列已选筛选项（列下标 → 值集合）
  final Map<int, Set<Object>> _filterSelected = {};

  /// 当前页码（从 1 开始）
  int _currentPage = 1;

  /// 横向滚动控制器（表头与各行共享同一控制器，监听同步位移）
  late final ScrollController _hController = ScrollController();

  /// 横向滚动同步标志（防止递归）
  bool _syncingH = false;

  /// 筛选弹层
  OverlayEntry? _filterOverlay;

  /// 各列筛选图标的 LayerLink
  final Map<int, LayerLink> _filterLinks = {};

  @override
  void initState() {
    super.initState();
    _hController.addListener(_onHScroll);
  }

  @override
  void dispose() {
    _removeFilterOverlay();
    _hController.dispose();
    super.dispose();
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
  // 数据处理：筛选 → 排序 → 分页
  // ------------------------------------------------------------

  /// 应用筛选与排序后的全量行（分页前）
  List<Map<String, dynamic>> get _processedRows {
    var rows = List<Map<String, dynamic>>.from(widget.dataSource);

    // 筛选
    for (var i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      final selected = _filterSelected[i];
      if (column.onFilter != null && selected != null && selected.isNotEmpty) {
        rows = rows
            .where((record) => selected.any((v) => column.onFilter!(v, record)))
            .toList();
      }
    }

    // 排序
    if (_sortColumnIndex >= 0 && _sortOrder != null) {
      final sorter = widget.columns[_sortColumnIndex].sorter;
      if (sorter != null) {
        rows.sort(sorter);
        if (_sortOrder == AntTableSortOrder.descend) {
          rows = rows.reversed.toList();
        }
      }
    }

    return rows;
  }

  /// 当前页展示的行（分页后）
  List<Map<String, dynamic>> get _displayRows {
    final rows = _processedRows;
    if (!widget.pagination || rows.length <= widget.pageSize) return rows;
    final start = (_currentPage - 1) * widget.pageSize;
    return rows.skip(start).take(widget.pageSize).toList();
  }

  int get _pageCount =>
      (_processedRows.length / widget.pageSize).ceil().clamp(1, 1 << 31);

  Object? _rowKeyOf(Map<String, dynamic> record, int index) =>
      widget.rowKey?.call(record) ?? record['id'] ?? index;

  // ------------------------------------------------------------
  // 排序交互
  // ------------------------------------------------------------

  void _handleSortTap(int columnIndex) {
    setState(() {
      if (_sortColumnIndex != columnIndex) {
        // 切换到新列：从升序开始
        _sortColumnIndex = columnIndex;
        _sortOrder = AntTableSortOrder.ascend;
        return;
      }
      // 同一列：升序 → 降序 → 取消
      switch (_sortOrder) {
        case null:
        case AntTableSortOrder.descend:
          _sortOrder = null;
          _sortColumnIndex = -1;
        case AntTableSortOrder.ascend:
          _sortOrder = AntTableSortOrder.descend;
      }
    });
  }

  // ------------------------------------------------------------
  // 筛选交互
  // ------------------------------------------------------------

  void _toggleFilterOverlay(int columnIndex, AntThemeData theme) {
    if (_filterOverlay != null) {
      _removeFilterOverlay();
      return;
    }
    _showFilterOverlay(columnIndex, theme);
  }

  void _showFilterOverlay(int columnIndex, AntThemeData theme) {
    final link =
        _filterLinks.putIfAbsent(columnIndex, () => LayerLink());
    final column = widget.columns[columnIndex];
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
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: Offset(0, 4.w),
              child: _FilterPanel(
                theme: theme,
                items: column.filters ?? const [],
                initialSelected: _filterSelected[columnIndex] ?? <Object>{},
                onConfirm: (selected) {
                  setState(() {
                    if (selected.isEmpty) {
                      _filterSelected.remove(columnIndex);
                    } else {
                      _filterSelected[columnIndex] = selected;
                    }
                    _currentPage = 1;
                  });
                  _removeFilterOverlay();
                },
                onReset: () {
                  setState(() {
                    _filterSelected.remove(columnIndex);
                    _currentPage = 1;
                  });
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

  void _removeFilterOverlay() {
    _filterOverlay?.remove();
    _filterOverlay = null;
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

  double _columnWidth(AntTableColumn column) =>
      (column.width ?? _kDefaultColumnWidth).w;

  bool get _hasScrollX => widget.scrollX != null;

  List<int> get _leftFixedIndexes => _fixedIndexes(AntTableFixed.left);

  List<int> get _rightFixedIndexes => _fixedIndexes(AntTableFixed.right);

  List<int> _fixedIndexes(AntTableFixed fixed) => [
        for (var i = 0; i < widget.columns.length; i++)
          if (widget.columns[i].fixed == fixed) i,
      ];

  /// 中间可滚动区域包含的列下标
  List<int> get _middleIndexes => [
        for (var i = 0; i < widget.columns.length; i++)
          if (widget.columns[i].fixed == null) i,
      ];

  double get _middleWidth {
    var total = 0.0;
    for (final i in _middleIndexes) {
      total += _columnWidth(widget.columns[i]);
    }
    return total;
  }

  // ============================================================
  // build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final rows = _displayRows;

    final table = Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: widget.bordered
            ? Border.all(color: theme.colorSplit)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          if (rows.isEmpty) _buildEmpty(theme) else _buildBody(theme, rows),
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
  // 表头
  // ------------------------------------------------------------

  Widget _buildHeader(AntThemeData theme) {
    return Container(
      color: theme.colorFillQuaternary,
      child: _buildRowCells(
        theme,
        rowIndex: -1,
        isHeader: true,
      ),
    );
  }

  // ------------------------------------------------------------
  // 表体
  // ------------------------------------------------------------

  Widget _buildBody(AntThemeData theme, List<Map<String, dynamic>> rows) {
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
                if (_rowKeyOf(rows[i], i) == recordKey) return i;
              }
              return null;
            },
            itemBuilder: (context, index) {
              final record = rows[index];
              return _buildWrappedRow(
                theme,
                record,
                index,
                key: ValueKey<Object?>(_rowKeyOf(record, index)),
              );
            },
          ),
        );
      }
      return SizedBox(
        height: widget.scrollY!.w,
        child: ListView(
          children: [
            for (var i = 0; i < rows.length; i++)
              _buildWrappedRow(theme, rows[i], i),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < rows.length; i++)
          _buildWrappedRow(theme, rows[i], i),
      ],
    );
  }

  Widget _buildWrappedRow(
    AntThemeData theme,
    Map<String, dynamic> record,
    int index, {
    Key? key,
  }) {
    return Container(
      key: ValueKey<Object?>('ant_table_row_${_rowKeyOf(record, index)}'),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorSplit)),
      ),
      child: _buildRowCells(theme, rowIndex: index, record: record),
    );
  }

  // ------------------------------------------------------------
  // 行 / 表头单元格骨架（固定列拆分：left | middle(scroll) | right）
  // ------------------------------------------------------------

  Widget _buildRowCells(
    AntThemeData theme, {
    required int rowIndex,
    Map<String, dynamic>? record,
    bool isHeader = false,
  }) {
    final left = _leftFixedIndexes;
    final right = _rightFixedIndexes;
    final middle = _middleIndexes;

    final children = <Widget>[
      // 固定在左侧的列（固定宽度，不参与滚动）
      for (final i in left)
        SizedBox(
          width: _columnWidth(widget.columns[i]),
          child: _buildCell(theme, i, rowIndex, record, isHeader),
        ),
      // 左侧固定列分隔阴影
      if (left.isNotEmpty && _hasScrollX) _buildShadow(theme, isLeft: true),

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
                    children: [
                      for (final i in middle)
                        SizedBox(
                          width: _columnWidth(widget.columns[i]),
                          child: _buildCell(
                            theme,
                            i,
                            rowIndex,
                            record,
                            isHeader,
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final i in middle)
                    widget.columns[i].width != null
                        ? SizedBox(
                            width: _columnWidth(widget.columns[i]),
                            child: _buildCell(
                              theme,
                              i,
                              rowIndex,
                              record,
                              isHeader,
                            ),
                          )
                        : Expanded(
                            child: _buildCell(
                              theme,
                              i,
                              rowIndex,
                              record,
                              isHeader,
                            ),
                          ),
                ],
              ),
      ),

      // 右侧固定列分隔阴影
      if (right.isNotEmpty && _hasScrollX) _buildShadow(theme, isLeft: false),
      // 固定在右侧的列（固定宽度，不参与滚动）
      for (final i in right)
        SizedBox(
          width: _columnWidth(widget.columns[i]),
          child: _buildCell(theme, i, rowIndex, record, isHeader),
        ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  /// 固定列与滚动区之间的分隔阴影
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
  // 单元格
  // ------------------------------------------------------------

  Widget _buildCell(
    AntThemeData theme,
    int columnIndex,
    int rowIndex,
    Map<String, dynamic>? record,
    bool isHeader,
  ) {
    final column = widget.columns[columnIndex];

    Widget content;
    if (isHeader) {
      content = _buildHeaderCell(theme, columnIndex, column);
    } else {
      final value = column.dataIndex == null
          ? null
          : record![column.dataIndex];
      content = column.render?.call(value, record ?? const {}, rowIndex) ??
          _cellText(
            theme,
            value?.toString() ?? '',
            color: theme.colorText,
          );
    }

    return Container(
      key: isHeader ? ValueKey('ant_table_th_$columnIndex') : null,
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
        children: [
          Expanded(child: content),
        ],
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

  /// 表头单元格内容（标题 + 排序图标 + 筛选图标）
  Widget _buildHeaderCell(AntThemeData theme, int columnIndex, AntTableColumn column) {
    Widget title = _cellText(
      theme,
      column.title,
      color: theme.colorText,
      fontWeight: FontWeight.w600,
    );

    // 对齐
    final align = column.align;
    if (align == AntTableAlign.center) {
      title = Center(child: title);
    } else if (align == AntTableAlign.right) {
      title = Align(
        alignment: Alignment.centerRight,
        child: title,
      );
    }

    Widget cell = title;

    // 排序：整格可点击
    if (column.sorter != null) {
      cell = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleSortTap(columnIndex),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: cell),
            _buildSortIcons(theme, columnIndex),
          ],
        ),
      );
    }

    // 筛选：标题旁筛选图标
    if (column.filters != null && column.filters!.isNotEmpty) {
      cell = Row(
        children: [
          Expanded(child: cell),
          _buildFilterIcon(theme, columnIndex),
        ],
      );
    }

    return cell;
  }

  /// 排序图标（升 / 降两枚，激活态主题色着色）
  Widget _buildSortIcons(AntThemeData theme, int columnIndex) {
    final active = _sortColumnIndex == columnIndex && _sortOrder != null;
    final activeColor = theme.colorPrimary;
    final inactiveColor = theme.colorTextQuaternary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.arrow_upward,
          size: 12.w,
          color: active && _sortOrder == AntTableSortOrder.ascend
              ? activeColor
              : inactiveColor,
        ),
        Icon(
          Icons.arrow_downward,
          size: 12.w,
          color: active && _sortOrder == AntTableSortOrder.descend
              ? activeColor
              : inactiveColor,
        ),
      ],
    );
  }

  /// 筛选图标（点击弹出筛选菜单）
  Widget _buildFilterIcon(AntThemeData theme, int columnIndex) {
    final link = _filterLinks.putIfAbsent(columnIndex, () => LayerLink());
    final active = _filterSelected[columnIndex]?.isNotEmpty ?? false;
    return CompositedTransformTarget(
      link: link,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleFilterOverlay(columnIndex, theme),
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
        onTap: () => setState(() => _currentPage = n),
        behavior: HitTestBehavior.opaque,
        child: Container(
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

    Widget arrowButton(IconData icon, {required bool disabled, required VoidCallback onTap}) {
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
            onTap: () => setState(() => _currentPage = page - 1),
          ),
          for (var n = 1; n <= pageCount; n++) pageButton(n),
          arrowButton(
            Icons.chevron_right,
            disabled: page >= pageCount,
            onTap: () => setState(() => _currentPage = page + 1),
          ),
        ],
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
    required this.onConfirm,
    required this.onReset,
  });

  final AntThemeData theme;
  final List<AntTableFilterItem> items;
  final Set<Object> initialSelected;
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
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    setState(() {
                      if (!_selected.remove(item.value)) {
                        _selected.add(item.value);
                      }
                    }),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      Icon(
                        _selected.contains(item.value)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
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
                  _filterAction(theme, '重置', widget.onReset),
                  _filterAction(
                    theme,
                    '确定',
                    () => widget.onConfirm(Set<Object>.from(_selected)),
                    highlight: true,
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
  }) {
    final color = highlight ? theme.colorPrimary : theme.colorTextSecondary;
    return GestureDetector(
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
