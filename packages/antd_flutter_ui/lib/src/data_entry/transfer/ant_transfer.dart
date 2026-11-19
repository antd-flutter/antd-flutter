/// AntTransfer 穿梭框
///
/// 双栏穿梭选择组件，将数据项在左右面板间移动。
///
/// 对齐 antd React Transfer 组件，支持：
/// - [dataSource] / [targetKeys] / [selectedKeys]
/// - [onChange] / [onSelectChange]
/// - [titles] / [operations] / [disabled] / [showSearch] / [oneWay]
/// - 树形模式（TreeTransfer）：数据项携带 [AntTransferItem.children] 时
///   自动按树渲染（对齐 antd TreeTransfer 语义：树模式由数据驱动，无需显式开关），
///   支持父子勾选联动、半选、禁用子树联动、树形穿梭与搜索过滤
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

export 'ant_transfer_types.dart';

/// 穿梭框
class AntTransfer extends StatefulWidget {
  const AntTransfer({
    super.key,
    required this.dataSource,
    this.targetKeys,
    this.defaultTargetKeys = const [],
    this.selectedKeys,
    this.defaultSelectedKeys = const [],
    this.onChange,
    this.onSelectChange,
    this.titles = const ['Source', 'Target'],
    this.operations = const ['', ''],
    this.disabled = false,
    this.showSearch = false,
    this.oneWay = false,
    this.filterOption,
    this.height,
    this.defaultExpandAll = false,
  });

  /// 数据源，包含全部数据项（含 children 时为树形模式）
  final List<AntTransferItem> dataSource;

  /// 受控：右侧面板项的 key 列表
  final List<String>? targetKeys;

  /// 非受控：右侧面板项的 key 列表初始值
  final List<String> defaultTargetKeys;

  /// 受控：已选中项的 key 列表（树模式下仅包含叶子节点 key）
  final List<String>? selectedKeys;

  /// 非受控：已选中项的 key 列表初始值
  final List<String> defaultSelectedKeys;

  /// 项在两面板间移动后的回调
  /// 参数依次为：移动后的 targetKeys、移动方向、被移动的 keys
  final void Function(List<String> targetKeys, AntTransferDirection direction, List<String> moveKeys)?
      onChange;

  /// 选中项变化时的回调
  /// 参数依次为：源面板选中 keys、目标面板选中 keys
  final void Function(List<String> sourceSelectedKeys, List<String> targetSelectedKeys)?
      onSelectChange;

  /// 左右面板标题，默认 ['Source', 'Target']
  final List<String> titles;

  /// 中间操作按钮文案，默认 ['', '']（使用箭头图标）
  final List<String> operations;

  /// 是否整体禁用
  final bool disabled;

  /// 是否显示搜索框
  final bool showSearch;

  /// 是否为单向模式（仅可移至右侧，不可移回）
  final bool oneWay;

  /// 自定义搜索过滤函数，返回 true 表示保留
  final bool Function(String inputValue, AntTransferItem item)? filterOption;

  /// 列表区域高度
  final double? height;

  /// 树形模式：是否默认展开全部节点，默认 false
  final bool defaultExpandAll;

  @override
  State<AntTransfer> createState() => _AntTransferState();
}

class _AntTransferState extends State<AntTransfer> {
  late List<String> _targetKeys;
  late List<String> _sourceSelectedKeys;
  late List<String> _targetSelectedKeys;
  late Set<String> _expandedKeys;
  String _sourceSearchText = '';
  String _targetSearchText = '';

  @override
  void initState() {
    super.initState();
    _targetKeys = List<String>.from(
      widget.targetKeys ?? widget.defaultTargetKeys,
    );
    _sourceSelectedKeys = <String>[];
    _targetSelectedKeys = <String>[];
    // 初始选中状态由 defaultSelectedKeys 分配到对应面板
    for (final key in widget.defaultSelectedKeys) {
      if (_targetKeys.contains(key)) {
        _targetSelectedKeys.add(key);
      } else {
        _sourceSelectedKeys.add(key);
      }
    }
    _expandedKeys = widget.defaultExpandAll
        ? _collectParentKeys(widget.dataSource).toSet()
        : <String>{};
  }

  @override
  void didUpdateWidget(AntTransfer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetKeys != null) {
      final newKeys = widget.targetKeys!;
      if (!_listEquals(_targetKeys, newKeys)) {
        _targetKeys = List<String>.from(newKeys);
      }
    }
    if (widget.selectedKeys != null) {
      final newSelected = widget.selectedKeys!;
      final newSource = newSelected.where((k) => !_targetKeys.contains(k)).toList();
      final newTarget = newSelected.where((k) => _targetKeys.contains(k)).toList();
      if (!_listEquals(_sourceSelectedKeys, newSource)) {
        _sourceSelectedKeys = newSource;
      }
      if (!_listEquals(_targetSelectedKeys, newTarget)) {
        _targetSelectedKeys = newTarget;
      }
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // ---------------- 树形工具方法 ----------------

  /// 收集树中所有带 children 的节点 key
  static List<String> _collectParentKeys(List<AntTransferItem> items) {
    final keys = <String>[];
    for (final item in items) {
      if (item.hasChildren) {
        keys.add(item.key);
        keys.addAll(_collectParentKeys(item.children!));
      }
    }
    return keys;
  }

  /// 按 key 查找节点
  static AntTransferItem? _findNode(List<AntTransferItem> items, String key) {
    for (final item in items) {
      if (item.key == key) return item;
      if (item.children != null) {
        final found = _findNode(item.children!, key);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// 收集节点下可选（在指定侧且自身/祖先未禁用）的叶子 key
  List<String> _collectSelectableLeafKeys(
    AntTransferItem node,
    bool Function(String key) inSide,
  ) {
    final keys = <String>[];
    void walk(AntTransferItem item, bool ancestorDisabled) {
      final disabled = ancestorDisabled || item.disabled;
      if (item.hasChildren) {
        for (final child in item.children!) {
          walk(child, disabled);
        }
      } else if (inSide(item.key) && !disabled) {
        keys.add(item.key);
      }
    }

    walk(node, false);
    return keys;
  }

  List<String> get _currentTargetKeys => widget.targetKeys ?? _targetKeys;

  bool _isInSource(String key) => !_currentTargetKeys.contains(key);

  bool _isInTarget(String key) => _currentTargetKeys.contains(key);

  List<String> get _currentSourceSelectedKeys => _sourceSelectedKeys;

  List<String> get _currentTargetSelectedKeys => _targetSelectedKeys;

  List<AntTransferItem> get _sourceItems => widget.dataSource
      .where((item) => _isInSource(item.key))
      .toList();

  List<AntTransferItem> get _targetItems => widget.dataSource
      .where((item) => _isInTarget(item.key))
      .toList();

  /// 节点自身是否命中搜索（自定义 filterOption 或默认 title/description 匹配）
  bool _nodeSelfMatches(AntTransferItem item, String searchText) {
    final filter = widget.filterOption;
    if (filter != null) {
      return filter(searchText, item);
    }
    final lower = searchText.toLowerCase();
    if (item.title.toLowerCase().contains(lower)) return true;
    if (item.description != null &&
        item.description!.toLowerCase().contains(lower)) {
      return true;
    }
    return false;
  }

  /// 构建面板可见行（树剪枝：仅保留本侧节点；搜索时保留命中节点及其父链）
  List<_TransferRow> _buildRows(
    List<AntTransferItem> tree,
    String searchText,
    bool Function(String key) inSide,
  ) {
    return _buildRowsRecursive(tree, 0, false, searchText, inSide);
  }

  List<_TransferRow> _buildRowsRecursive(
    List<AntTransferItem> items,
    int depth,
    bool ancestorDisabled,
    String searchText,
    bool Function(String key) inSide,
  ) {
    final rows = <_TransferRow>[];
    final searching = searchText.isNotEmpty;
    for (final item in items) {
      final disabled = ancestorDisabled || item.disabled;
      final childRows = item.hasChildren
          ? _buildRowsRecursive(
              item.children!,
              depth + 1,
              disabled,
              searchText,
              inSide,
            )
          : <_TransferRow>[];
      final side = inSide(item.key);
      // 非本侧且无可保留子级 → 剪枝
      if (!side && childRows.isEmpty) continue;
      // 搜索过滤：自身命中或子级仍有保留节点（父链展示）
      if (searching &&
          !_nodeSelfMatches(item, searchText) &&
          childRows.isEmpty) {
        continue;
      }
      // 搜索时强制展开命中的父链，便于查看匹配子节点
      final expanded = searching || _expandedKeys.contains(item.key);
      rows.add(
        _TransferRow(
          item: item,
          depth: depth,
          hasChildren: item.hasChildren,
          expanded: expanded,
          inSide: side,
          disabled: disabled,
          forceExpanded: searching,
        ),
      );
      if (expanded) rows.addAll(childRows);
    }
    return rows;
  }

  /// 统计一侧叶子节点总数（计数含子级）
  int _countLeaves(List<AntTransferItem> items) {
    var count = 0;
    for (final item in items) {
      if (item.hasChildren) {
        count += _countLeaves(item.children!);
      } else {
        count += 1;
      }
    }
    return count;
  }

  List<_TransferRow> get _sourceRows => _buildRows(
        widget.dataSource,
        _sourceSearchText,
        _isInSource,
      );

  List<_TransferRow> get _targetRows => _buildRows(
        widget.dataSource,
        _targetSearchText,
        _isInTarget,
      );

  /// 计算父级行的勾选状态（含半选）
  ({bool checked, bool indeterminate}) _parentCheckState(
    AntTransferItem node,
    List<String> selectedKeys,
    bool Function(String key) inSide,
  ) {
    final keys = _collectSelectableLeafKeys(node, inSide);
    if (keys.isEmpty) return (checked: false, indeterminate: false);
    final selectedCount = keys.where(selectedKeys.contains).length;
    return (
      checked: selectedCount == keys.length,
      indeterminate: selectedCount > 0 && selectedCount < keys.length,
    );
  }

  // ---------------- 勾选逻辑 ----------------

  /// 切换勾选（叶子切换自身；父级联动其全部可选子叶）
  void _toggleRow({
    required bool isSource,
    required String key,
  }) {
    final inSide = isSource ? _isInSource : _isInTarget;
    final current = isSource
        ? _currentSourceSelectedKeys
        : _currentTargetSelectedKeys;
    final node = _findNode(widget.dataSource, key);
    final hasChildren = node != null && node.hasChildren;

    List<String> keys;
    bool select;
    if (hasChildren) {
      keys = _collectSelectableLeafKeys(node, inSide);
      select = keys.isNotEmpty && !keys.every(current.contains);
    } else {
      keys = [key];
      select = !current.contains(key);
    }
    if (keys.isEmpty) return;

    final newSelected = select
        ? {...current, ...keys}.toList()
        : current.where((k) => !keys.contains(k)).toList();

    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        isSource ? newSelected : _targetSelectedKeys,
        isSource ? _targetSelectedKeys : newSelected,
      );
      return;
    }
    setState(() {
      if (isSource) {
        _sourceSelectedKeys = newSelected;
      } else {
        _targetSelectedKeys = newSelected;
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  /// 全选/清空一侧（对可见可选叶子生效）
  void _toggleAll({
    required bool isSource,
    required bool checked,
  }) {
    final rows = isSource ? _sourceRows : _targetRows;
    final keys = rows
        .where(
          (r) => r.inSide && !r.hasChildren && !r.disabled,
        )
        .map((r) => r.item.key)
        .toList();
    final newSelected = checked ? keys : <String>[];
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        isSource ? newSelected : _targetSelectedKeys,
        isSource ? _targetSelectedKeys : newSelected,
      );
      return;
    }
    setState(() {
      if (isSource) {
        _sourceSelectedKeys = List<String>.from(newSelected);
      } else {
        _targetSelectedKeys = List<String>.from(newSelected);
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  void _toggleExpand(String key) {
    setState(() {
      if (!_expandedKeys.add(key)) {
        _expandedKeys.remove(key);
      }
    });
  }

  // ---------------- 穿梭逻辑 ----------------

  void _moveToTarget() {
    final moveKeys = _sourceSelectedKeys
        .where((k) => !_currentTargetKeys.contains(k))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys = [..._currentTargetKeys, ...moveKeys];
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _sourceSelectedKeys = [];
      });
    } else {
      setState(() {
        _sourceSelectedKeys = [];
      });
    }
    widget.onChange?.call(
      newTargetKeys,
      AntTransferDirection.right,
      moveKeys,
    );
  }

  void _moveToSource() {
    if (widget.oneWay) return;
    final moveKeys = _targetSelectedKeys
        .where((k) => _currentTargetKeys.contains(k))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys = _currentTargetKeys
        .where((k) => !moveKeys.contains(k))
        .toList();
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _targetSelectedKeys = [];
      });
    } else {
      setState(() {
        _targetSelectedKeys = [];
      });
    }
    widget.onChange?.call(
      newTargetKeys,
      AntTransferDirection.left,
      moveKeys,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final panelHeight = widget.height ?? 240.h;

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _TransferPanel(
              title: widget.titles.isNotEmpty ? widget.titles.first : 'Source',
              rows: _sourceRows,
              totalCount: _countLeaves(_sourceItems),
              selectedKeys: _currentSourceSelectedKeys,
              searchText: _sourceSearchText,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _sourceSearchText = text)
                  : null,
              onToggleItem: (key) => _toggleRow(isSource: true, key: key),
              onToggleAll: (checked) =>
                  _toggleAll(isSource: true, checked: checked),
              onToggleExpand: _toggleExpand,
              parentCheckState: (node) => _parentCheckState(
                node,
                _currentSourceSelectedKeys,
                _isInSource,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: panelHeight / 2 - 32.h),
                _OperationButton(
                  icon: widget.operations.isNotEmpty && widget.operations[0].isNotEmpty
                      ? null
                      : Icons.keyboard_double_arrow_right,
                  label: widget.operations.isNotEmpty && widget.operations[0].isNotEmpty
                      ? widget.operations[0]
                      : null,
                  enabled: !widget.disabled && _sourceSelectedKeys.isNotEmpty,
                  onTap: _moveToTarget,
                  theme: t,
                ),
                SizedBox(height: 8.h),
                if (!widget.oneWay) ...[
                  _OperationButton(
                    icon: widget.operations.length > 1 && widget.operations[1].isNotEmpty
                        ? null
                        : Icons.keyboard_double_arrow_left,
                    label: widget.operations.length > 1 && widget.operations[1].isNotEmpty
                        ? widget.operations[1]
                        : null,
                    enabled: !widget.disabled && _targetSelectedKeys.isNotEmpty,
                    onTap: _moveToSource,
                    theme: t,
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _TransferPanel(
              title: widget.titles.length > 1 ? widget.titles[1] : 'Target',
              rows: _targetRows,
              totalCount: _countLeaves(_targetItems),
              selectedKeys: _currentTargetSelectedKeys,
              searchText: _targetSearchText,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _targetSearchText = text)
                  : null,
              onToggleItem: (key) => _toggleRow(isSource: false, key: key),
              onToggleAll: (checked) =>
                  _toggleAll(isSource: false, checked: checked),
              onToggleExpand: _toggleExpand,
              parentCheckState: (node) => _parentCheckState(
                node,
                _currentTargetSelectedKeys,
                _isInTarget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 面板中的一行（树形模式含层级与展开信息）
class _TransferRow {
  const _TransferRow({
    required this.item,
    required this.depth,
    required this.hasChildren,
    required this.expanded,
    required this.inSide,
    required this.forceExpanded,
    required this.disabled,
  });

  final AntTransferItem item;
  final int depth;
  final bool hasChildren;
  final bool expanded;
  final bool inSide;
  final bool forceExpanded;

  /// 有效禁用（自身或祖先禁用）
  final bool disabled;
}

/// 单个穿梭面板
class _TransferPanel extends StatelessWidget {
  const _TransferPanel({
    required this.title,
    required this.rows,
    required this.totalCount,
    required this.selectedKeys,
    required this.searchText,
    required this.showSearch,
    required this.disabled,
    required this.height,
    required this.theme,
    this.onSearch,
    required this.onToggleItem,
    required this.onToggleAll,
    required this.onToggleExpand,
    required this.parentCheckState,
  });

  final String title;
  final List<_TransferRow> rows;
  final int totalCount;
  final List<String> selectedKeys;
  final String searchText;
  final bool showSearch;
  final bool disabled;
  final double height;
  final AntThemeData theme;
  final ValueChanged<String>? onSearch;
  final void Function(String key) onToggleItem;
  final void Function(bool checked) onToggleAll;
  final void Function(String key) onToggleExpand;
  final ({bool checked, bool indeterminate}) Function(AntTransferItem node)
      parentCheckState;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final allChecked = _isAllChecked(rows, selectedKeys);
    final hasSelectable = rows.any(
      (r) => r.inSide && !r.hasChildren && !r.disabled,
    );
    final selectedCount = selectedKeys.length;

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: t.colorSplit),
        borderRadius: BorderRadius.circular(t.borderRadius.r),
      ),
      child: Column(
        children: [
          // 标题栏 + 全选
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: t.colorSplit)),
            ),
            child: Row(
              children: [
                AntCheckbox(
                  checked: allChecked,
                  indeterminate:
                      !allChecked && selectedCount > 0 && hasSelectable,
                  disabled: disabled || !hasSelectable,
                  onChange: onToggleAll,
                  child: const SizedBox.shrink(),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: t.fontSizeSM.sp,
                      color: t.colorText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '$selectedCount/$totalCount',
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: t.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 搜索框
          if (showSearch)
            Padding(
              padding: EdgeInsets.all(8.w),
              child: SizedBox(
                height: t.controlHeightSM.h,
                child: TextField(
                  enabled: !disabled,
                  onChanged: onSearch,
                  style: TextStyle(fontSize: t.fontSizeSM.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 0,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 16.r,
                      color: t.colorTextTertiary,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: t.fontSizeSM.sp,
                      color: t.colorTextPlaceholder,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(t.borderRadius.r),
                      borderSide: BorderSide(color: t.colorBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(t.borderRadius.r),
                      borderSide: BorderSide(
                        color: t.colorPrimary,
                        width: t.controlOutlineWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // 列表区域
          Expanded(
            child: rows.isEmpty
                ? Center(
                    child: Text(
                      'No data',
                      style: TextStyle(
                        fontSize: t.fontSizeSM.sp,
                        color: t.colorTextQuaternary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return _TransferRowTile(
                        row: row,
                        selectedKeys: selectedKeys,
                        disabled: disabled,
                        theme: t,
                        onTap: () => onToggleItem(row.item.key),
                        onToggleExpand: () => onToggleExpand(row.item.key),
                        parentCheckState: parentCheckState,
                      );
                    },
                  ),
          ),
          // 底部
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: t.colorSplit)),
            ),
            child: Row(
              children: [
                Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: t.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isAllChecked(
    List<_TransferRow> rows,
    List<String> selectedKeys,
  ) {
    final leafRows = rows
        .where((r) => r.inSide && !r.hasChildren && !r.disabled)
        .toList();
    if (leafRows.isEmpty) return false;
    return leafRows.every((r) => selectedKeys.contains(r.item.key));
  }
}

/// 数据项行（扁平与树形共用：树形含缩进、展开箭头与父子联动勾选）
class _TransferRowTile extends StatelessWidget {
  const _TransferRowTile({
    required this.row,
    required this.selectedKeys,
    required this.disabled,
    required this.theme,
    required this.onTap,
    required this.onToggleExpand,
    required this.parentCheckState,
  });

  final _TransferRow row;
  final List<String> selectedKeys;
  final bool disabled;
  final AntThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onToggleExpand;
  final ({bool checked, bool indeterminate}) Function(AntTransferItem node)
      parentCheckState;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final item = row.item;
    final isDisabled = disabled || row.disabled;
    var checked = false;
    var indeterminate = false;
    if (row.hasChildren) {
      final state = parentCheckState(item);
      checked = state.checked;
      indeterminate = state.indeterminate;
    } else {
      checked = selectedKeys.contains(item.key);
    }
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        child: Row(
          children: [
            // 展开箭头占位（含层级缩进）
            SizedBox(
              width: row.depth * 16.w,
            ),
            if (row.hasChildren)
              GestureDetector(
                onTap: onToggleExpand,
                child: Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Icon(
                    row.expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 16.r,
                    color: t.colorTextSecondary,
                  ),
                ),
              )
            else
              SizedBox(width: 20.w),
            AntCheckbox(
              checked: checked,
              indeterminate: indeterminate,
              disabled: isDisabled,
              onChange: isDisabled ? null : (_) => onTap(),
              child: const SizedBox.shrink(),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: isDisabled ? t.colorTextDisabled : t.colorText,
                ),
              ),
            ),
            if (item.description != null)
              Text(
                item.description!,
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: t.colorTextTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 中间操作按钮
class _OperationButton extends StatelessWidget {
  const _OperationButton({
    this.icon,
    this.label,
    required this.enabled,
    required this.onTap,
    required this.theme,
  });

  final IconData? icon;
  final String? label;
  final bool enabled;
  final VoidCallback onTap;
  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: enabled ? t.colorPrimary : t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius.r),
        ),
        child: Center(
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: enabled ? Colors.white : t.colorTextDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Icon(
                  icon,
                  size: 18.r,
                  color: enabled ? Colors.white : t.colorTextDisabled,
                ),
        ),
      ),
    );
  }
}
