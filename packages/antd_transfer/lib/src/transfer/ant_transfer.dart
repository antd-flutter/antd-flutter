/// AntTransfer — antd React Transfer 的 Flutter 泛型实现
///
/// 双栏穿梭选择组件，直接消费用户模型 `T`，通过 [keyOf] / [titleBuilder] /
/// [descriptionOf] / [childrenOf] / [disabledOf] 读取数据，不再要求构造
/// `AntTransferItem`。
///
/// 对齐 antd React Transfer 组件，支持：
/// - `dataSource` / `targetKeys` / `selectedKeys`
/// - `onChange` / `onSelectChange`
/// - `titles` / `operations` / `disabled` / `showSearch` / `oneWay`
/// - 树形模式：提供 [childrenOf] 时自动按树渲染（对齐 antd TreeTransfer
///   语义：树模式由数据驱动，无需显式开关），支持父子勾选联动、半选、
///   禁用子树联动、树形穿梭与搜索过滤
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_transfer_types.dart';

export 'ant_transfer_types.dart';

/// 穿梭框（泛型数据源）。
class AntTransfer<T> extends StatefulWidget {
  const AntTransfer({
    super.key,
    required this.dataSource,
    required this.keyOf,
    this.titleBuilder,
    this.descriptionOf,
    this.childrenOf,
    this.disabledOf,
    this.searchTextOf,
    this.targetKeys,
    this.defaultTargetKeys = const <Object>[],
    this.selectedKeys,
    this.defaultSelectedKeys = const <Object>[],
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

  /// 数据源，包含全部数据项（提供 [childrenOf] 且返回非空时为树形模式）。
  final List<T> dataSource;

  /// 从数据项提取唯一 key；所有受控值与回调都使用该 key。
  final AntTransferKeyOf<T> keyOf;

  /// 行标题构建器；缺省使用 [searchTextOf]（再缺省 `toString`）。
  final AntTransferTitleBuilder<T>? titleBuilder;

  /// 行描述文本；返回 null 时不展示描述。
  final AntTransferDescriptionOf<T>? descriptionOf;

  /// 读取子节点；返回空集合表示叶子。
  final AntTransferChildrenOf<T>? childrenOf;

  /// 判断数据项是否禁用；树形模式下会向下传递到整个子树。
  final AntTransferDisabledOf<T>? disabledOf;

  /// 默认搜索使用的纯文本；缺省 `item is String ? item : '$item'`。
  ///
  /// 自定义搜索可用 [filterOption] 完全接管。
  final AntTransferSearchTextOf<T>? searchTextOf;

  /// 受控：右侧面板项的 key 列表。
  final List<Object>? targetKeys;

  /// 非受控：右侧面板项的 key 列表初始值。
  final List<Object> defaultTargetKeys;

  /// 受控：已选中项的 key 列表（树模式下仅包含叶子节点 key）。
  final List<Object>? selectedKeys;

  /// 非受控：已选中项的 key 列表初始值。
  final List<Object> defaultSelectedKeys;

  /// 项在两面板间移动后的回调。
  ///
  /// 参数依次为：移动后的 targetKeys、移动方向、被移动的 key；key 均由
  /// [keyOf] 从模型 `T` 提取，可用 `keyOf` 反查模型。
  final AntTransferOnChange? onChange;

  /// 选中项变化时的回调。
  ///
  /// 参数依次为：源面板选中 key、目标面板选中 key。
  final AntTransferOnSelectChange? onSelectChange;

  /// 左右面板标题，默认 ['Source', 'Target']。
  final List<String> titles;

  /// 中间操作按钮文案，默认 ['', '']（使用箭头图标）。
  final List<String> operations;

  /// 是否整体禁用。
  final bool disabled;

  /// 是否显示搜索框。
  final bool showSearch;

  /// 是否为单向模式（仅可移至右侧，不可移回）。
  final bool oneWay;

  /// 自定义搜索过滤函数，返回 true 表示保留。
  final bool Function(String inputValue, T item)? filterOption;

  /// 列表区域高度。
  final double? height;

  /// 树形模式：是否默认展开全部节点，默认 false。
  final bool defaultExpandAll;

  @override
  State<AntTransfer<T>> createState() => _AntTransferState<T>();
}

class _AntTransferState<T> extends State<AntTransfer<T>> {
  late List<Object> _targetKeys;
  late List<Object> _sourceSelectedKeys;
  late List<Object> _targetSelectedKeys;
  late Set<Object> _expandedKeys;
  String _sourceSearchText = '';
  String _targetSearchText = '';

  @override
  void initState() {
    super.initState();
    _targetKeys = List<Object>.from(
      widget.targetKeys ?? widget.defaultTargetKeys,
    );
    _sourceSelectedKeys = <Object>[];
    _targetSelectedKeys = <Object>[];
    for (final key in widget.defaultSelectedKeys) {
      if (_targetKeys.contains(key)) {
        _targetSelectedKeys.add(key);
      } else {
        _sourceSelectedKeys.add(key);
      }
    }
    _expandedKeys = widget.defaultExpandAll
        ? _collectParentKeys(widget.dataSource).toSet()
        : <Object>{};
  }

  @override
  void didUpdateWidget(covariant AntTransfer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetKeys != null) {
      final newKeys = widget.targetKeys!;
      if (!_listEquals(_targetKeys, newKeys)) {
        _targetKeys = List<Object>.from(newKeys);
      }
    }
    if (widget.selectedKeys != null) {
      final newSelected = widget.selectedKeys!;
      final newSource =
          newSelected.where((key) => !_targetKeys.contains(key)).toList();
      final newTarget =
          newSelected.where((key) => _targetKeys.contains(key)).toList();
      if (!_listEquals(_sourceSelectedKeys, newSource)) {
        _sourceSelectedKeys = newSource;
      }
      if (!_listEquals(_targetSelectedKeys, newTarget)) {
        _targetSelectedKeys = newTarget;
      }
    }
  }

  bool _listEquals(List<Object> a, List<Object> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // ---------------- 泛型数据访问 ----------------

  List<T> _childrenOf(T item) {
    final childrenOf = widget.childrenOf;
    if (childrenOf == null) return const <Never>[];
    return childrenOf(item);
  }

  bool _isDisabled(T item) => widget.disabledOf?.call(item) ?? false;

  String _searchTextOf(T item) {
    final searchTextOf = widget.searchTextOf;
    if (searchTextOf != null) return searchTextOf(item);
    return item is String ? item : '$item';
  }

  String? _descriptionOf(T item) => widget.descriptionOf?.call(item);

  Widget _titleOf(BuildContext context, T item) {
    final titleBuilder = widget.titleBuilder;
    if (titleBuilder != null) return titleBuilder(context, item);
    return Text(
      _searchTextOf(item),
      style: TextStyle(
        fontSize: AntTheme.of(context).fontSizeSM,
      ),
    );
  }

  // ---------------- 树形工具方法 ----------------

  /// 收集树中所有带 children 的节点 key。
  List<Object> _collectParentKeys(List<T> items) {
    final keys = <Object>[];
    for (final item in items) {
      final children = _childrenOf(item);
      if (children.isNotEmpty) {
        keys.add(widget.keyOf(item));
        keys.addAll(_collectParentKeys(children));
      }
    }
    return keys;
  }

  /// 按 key 查找节点。
  T? _findNode(List<T> items, Object key) {
    for (final item in items) {
      if (widget.keyOf(item) == key) return item;
      final found = _findNode(_childrenOf(item), key);
      if (found != null) return found;
    }
    return null;
  }

  /// 收集节点下可选（在指定侧且自身/祖先未禁用）的叶子 key。
  List<Object> _collectSelectableLeafKeys(
    T node,
    bool Function(Object key) inSide,
  ) {
    final keys = <Object>[];
    void walk(T item, bool ancestorDisabled) {
      final disabled = ancestorDisabled || _isDisabled(item);
      final children = _childrenOf(item);
      final key = widget.keyOf(item);
      if (children.isNotEmpty) {
        for (final child in children) {
          walk(child, disabled);
        }
      } else if (inSide(key) && !disabled) {
        keys.add(key);
      }
    }

    walk(node, false);
    return keys;
  }

  List<Object> get _currentTargetKeys => widget.targetKeys ?? _targetKeys;

  bool _isInSource(Object key) => !_currentTargetKeys.contains(key);

  bool _isInTarget(Object key) => _currentTargetKeys.contains(key);

  List<T> get _sourceItems => widget.dataSource
      .where((item) => _isInSource(widget.keyOf(item)))
      .toList();

  List<T> get _targetItems => widget.dataSource
      .where((item) => _isInTarget(widget.keyOf(item)))
      .toList();

  /// 节点自身是否命中搜索（自定义 filterOption 或默认文本匹配）。
  bool _nodeSelfMatches(T item, String searchText) {
    final filter = widget.filterOption;
    if (filter != null) {
      return filter(searchText, item);
    }
    final lower = searchText.toLowerCase();
    if (_searchTextOf(item).toLowerCase().contains(lower)) return true;
    final description = _descriptionOf(item);
    if (description != null && description.toLowerCase().contains(lower)) {
      return true;
    }
    return false;
  }

  /// 构建面板可见行（树剪枝：仅保留本侧节点；搜索时保留命中节点及其父链）。
  List<_TransferRow<T>> _buildRows(
    List<T> tree,
    String searchText,
    bool Function(Object key) inSide,
  ) {
    return _buildRowsRecursive(tree, 0, false, searchText, inSide);
  }

  List<_TransferRow<T>> _buildRowsRecursive(
    List<T> items,
    int depth,
    bool ancestorDisabled,
    String searchText,
    bool Function(Object key) inSide,
  ) {
    final rows = <_TransferRow<T>>[];
    final searching = searchText.isNotEmpty;
    for (final item in items) {
      final disabled = ancestorDisabled || _isDisabled(item);
      final children = _childrenOf(item);
      final childRows = children.isNotEmpty
          ? _buildRowsRecursive(
              children,
              depth + 1,
              disabled,
              searchText,
              inSide,
            )
          : <_TransferRow<T>>[];
      final key = widget.keyOf(item);
      final side = inSide(key);
      // 非本侧且无可保留子级 → 剪枝
      if (!side && childRows.isEmpty) continue;
      // 搜索过滤：自身命中或子级仍有保留节点（父链展示）
      if (searching &&
          !_nodeSelfMatches(item, searchText) &&
          childRows.isEmpty) {
        continue;
      }
      // 搜索时强制展开命中的父链，便于查看匹配子节点
      final expanded = searching || _expandedKeys.contains(key);
      rows.add(
        _TransferRow<T>(
          item: item,
          depth: depth,
          hasChildren: children.isNotEmpty,
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

  /// 统计一侧叶子节点总数（计数含子级）。
  int _countLeaves(List<T> items) {
    var count = 0;
    for (final item in items) {
      final children = _childrenOf(item);
      if (children.isNotEmpty) {
        count += _countLeaves(children);
      } else {
        count += 1;
      }
    }
    return count;
  }

  List<_TransferRow<T>> get _sourceRows => _buildRows(
        widget.dataSource,
        _sourceSearchText,
        _isInSource,
      );

  List<_TransferRow<T>> get _targetRows => _buildRows(
        widget.dataSource,
        _targetSearchText,
        _isInTarget,
      );

  /// 计算父级行的勾选状态（含半选）。
  ({bool checked, bool indeterminate}) _parentCheckState(
    T node,
    List<Object> selectedKeys,
    bool Function(Object key) inSide,
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

  /// 切换勾选（叶子切换自身；父级联动其全部可选子叶）。
  void _toggleRow({
    required bool isSource,
    required Object key,
  }) {
    final inSide = isSource ? _isInSource : _isInTarget;
    final current = isSource ? _sourceSelectedKeys : _targetSelectedKeys;
    final node = _findNode(widget.dataSource, key);
    final hasChildren = node != null && _childrenOf(node).isNotEmpty;

    List<Object> keys;
    bool select;
    if (hasChildren) {
      keys = _collectSelectableLeafKeys(node, inSide);
      select = keys.isNotEmpty && !keys.every(current.contains);
    } else {
      keys = <Object>[key];
      select = !current.contains(key);
    }
    if (keys.isEmpty) return;

    final newSelected = select
        ? <Object>{...current, ...keys}.toList()
        : current.where((candidate) => !keys.contains(candidate)).toList();

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
      List<Object>.from(_sourceSelectedKeys),
      List<Object>.from(_targetSelectedKeys),
    );
  }

  /// 全选/清空一侧（对可见可选叶子生效）。
  void _toggleAll({
    required bool isSource,
    required bool checked,
  }) {
    final rows = isSource ? _sourceRows : _targetRows;
    final keys = rows
        .where((row) => row.inSide && !row.hasChildren && !row.disabled)
        .map((row) => widget.keyOf(row.item))
        .toList();
    final newSelected = checked ? keys : <Object>[];
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        isSource ? newSelected : _targetSelectedKeys,
        isSource ? _targetSelectedKeys : newSelected,
      );
      return;
    }
    setState(() {
      if (isSource) {
        _sourceSelectedKeys = List<Object>.from(newSelected);
      } else {
        _targetSelectedKeys = List<Object>.from(newSelected);
      }
    });
    widget.onSelectChange?.call(
      List<Object>.from(_sourceSelectedKeys),
      List<Object>.from(_targetSelectedKeys),
    );
  }

  void _toggleExpand(Object key) {
    setState(() {
      if (!_expandedKeys.add(key)) {
        _expandedKeys.remove(key);
      }
    });
  }

  // ---------------- 穿梭逻辑 ----------------

  void _moveToTarget() {
    final moveKeys = _sourceSelectedKeys
        .where((key) => !_currentTargetKeys.contains(key))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys = [..._currentTargetKeys, ...moveKeys];
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _sourceSelectedKeys = <Object>[];
      });
    } else {
      setState(() {
        _sourceSelectedKeys = <Object>[];
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
        .where((key) => _currentTargetKeys.contains(key))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys =
        _currentTargetKeys.where((key) => !moveKeys.contains(key)).toList();
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _targetSelectedKeys = <Object>[];
      });
    } else {
      setState(() {
        _targetSelectedKeys = <Object>[];
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
    final panelHeight = widget.height ?? t.s(240);

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _TransferPanel<T>(
              title: widget.titles.isNotEmpty ? widget.titles.first : 'Source',
              rows: _sourceRows,
              totalCount: _countLeaves(_sourceItems),
              selectedKeys: _sourceSelectedKeys,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              keyOf: widget.keyOf,
              titleOf: _titleOf,
              descriptionOf: _descriptionOf,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _sourceSearchText = text)
                  : null,
              onToggleItem: (key) => _toggleRow(isSource: true, key: key),
              onToggleAll: (checked) =>
                  _toggleAll(isSource: true, checked: checked),
              onToggleExpand: _toggleExpand,
              parentCheckState: (node) => _parentCheckState(
                node,
                _sourceSelectedKeys,
                _isInSource,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.s(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: panelHeight / 2 - t.s(32)),
                _OperationButton(
                  icon: widget.operations.isNotEmpty &&
                          widget.operations[0].isNotEmpty
                      ? null
                      : AntIcons.doubleRightOutlined,
                  label: widget.operations.isNotEmpty &&
                          widget.operations[0].isNotEmpty
                      ? widget.operations[0]
                      : null,
                  enabled: !widget.disabled && _sourceSelectedKeys.isNotEmpty,
                  onTap: _moveToTarget,
                  theme: t,
                ),
                SizedBox(height: t.s(8)),
                if (!widget.oneWay)
                  _OperationButton(
                    icon: widget.operations.length > 1 &&
                            widget.operations[1].isNotEmpty
                        ? null
                        : AntIcons.doubleLeftOutlined,
                    label: widget.operations.length > 1 &&
                            widget.operations[1].isNotEmpty
                        ? widget.operations[1]
                        : null,
                    enabled: !widget.disabled && _targetSelectedKeys.isNotEmpty,
                    onTap: _moveToSource,
                    theme: t,
                  ),
              ],
            ),
          ),
          Expanded(
            child: _TransferPanel<T>(
              title: widget.titles.length > 1 ? widget.titles[1] : 'Target',
              rows: _targetRows,
              totalCount: _countLeaves(_targetItems),
              selectedKeys: _targetSelectedKeys,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              keyOf: widget.keyOf,
              titleOf: _titleOf,
              descriptionOf: _descriptionOf,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _targetSearchText = text)
                  : null,
              onToggleItem: (key) => _toggleRow(isSource: false, key: key),
              onToggleAll: (checked) =>
                  _toggleAll(isSource: false, checked: checked),
              onToggleExpand: _toggleExpand,
              parentCheckState: (node) => _parentCheckState(
                node,
                _targetSelectedKeys,
                _isInTarget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 面板中的一行（树形模式含层级与展开信息）。
class _TransferRow<T> {
  const _TransferRow({
    required this.item,
    required this.depth,
    required this.hasChildren,
    required this.expanded,
    required this.inSide,
    required this.forceExpanded,
    required this.disabled,
  });

  final T item;
  final int depth;
  final bool hasChildren;
  final bool expanded;
  final bool inSide;
  final bool forceExpanded;

  /// 有效禁用（自身或祖先禁用）。
  final bool disabled;
}

/// 单个穿梭面板。
class _TransferPanel<T> extends StatelessWidget {
  const _TransferPanel({
    required this.title,
    required this.rows,
    required this.totalCount,
    required this.selectedKeys,
    required this.showSearch,
    required this.disabled,
    required this.height,
    required this.theme,
    required this.keyOf,
    required this.titleOf,
    required this.descriptionOf,
    this.onSearch,
    required this.onToggleItem,
    required this.onToggleAll,
    required this.onToggleExpand,
    required this.parentCheckState,
  });

  final String title;
  final List<_TransferRow<T>> rows;
  final int totalCount;
  final List<Object> selectedKeys;
  final bool showSearch;
  final bool disabled;
  final double height;
  final AntThemeData theme;
  final Object Function(T item) keyOf;
  final Widget Function(BuildContext context, T item) titleOf;
  final String? Function(T item) descriptionOf;
  final ValueChanged<String>? onSearch;
  final void Function(Object key) onToggleItem;
  final void Function(bool checked) onToggleAll;
  final void Function(Object key) onToggleExpand;
  final ({bool checked, bool indeterminate}) Function(T node) parentCheckState;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final allChecked = _isAllChecked(rows, selectedKeys);
    final hasSelectable = rows.any(
      (row) => row.inSide && !row.hasChildren && !row.disabled,
    );
    final selectedCount = selectedKeys.length;

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: t.colorSplit),
        borderRadius: BorderRadius.circular(t.borderRadius),
      ),
      child: Column(
        children: [
          // 标题栏 + 全选
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.s(12),
              vertical: t.s(8),
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
                SizedBox(width: t.s(8)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: t.fontSizeSM,
                      color: t.colorText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '$selectedCount/$totalCount',
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color: t.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 搜索框
          if (showSearch)
            Padding(
              padding: EdgeInsets.all(t.s(8)),
              child: SizedBox(
                height: t.controlHeightSM,
                child: TextField(
                  enabled: !disabled,
                  onChanged: onSearch,
                  style: TextStyle(fontSize: t.fontSizeSM),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: t.s(8),
                      vertical: 0,
                    ),
                    prefixIcon: Icon(
                      AntIcons.searchOutlined,
                      size: t.s(16),
                      color: t.colorTextTertiary,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: t.fontSizeSM,
                      color: t.colorTextPlaceholder,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.borderRadius),
                      borderSide: BorderSide(color: t.colorBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.borderRadius),
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
                        fontSize: t.fontSizeSM,
                        color: t.colorTextQuaternary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return _TransferRowTile<T>(
                        row: row,
                        treeMode:
                            rows.any((candidate) => candidate.hasChildren),
                        selectedKeys: selectedKeys,
                        disabled: disabled,
                        theme: t,
                        keyOf: keyOf,
                        titleOf: titleOf,
                        descriptionOf: descriptionOf,
                        onTap: () => onToggleItem(keyOf(row.item)),
                        onToggleExpand: () => onToggleExpand(keyOf(row.item)),
                        parentCheckState: parentCheckState,
                      );
                    },
                  ),
          ),
          // 底部
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.s(12),
              vertical: t.s(6),
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: t.colorSplit)),
            ),
            child: Row(
              children: [
                Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
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
    List<_TransferRow<T>> rows,
    List<Object> selectedKeys,
  ) {
    final leafRows = rows
        .where((row) => row.inSide && !row.hasChildren && !row.disabled)
        .toList();
    if (leafRows.isEmpty) return false;
    return leafRows.every((row) => selectedKeys.contains(keyOf(row.item)));
  }
}

/// 数据项行（扁平与树形共用：树形含缩进、展开箭头与父子联动勾选）。
class _TransferRowTile<T> extends StatelessWidget {
  const _TransferRowTile({
    required this.row,
    required this.treeMode,
    required this.selectedKeys,
    required this.disabled,
    required this.theme,
    required this.keyOf,
    required this.titleOf,
    required this.descriptionOf,
    required this.onTap,
    required this.onToggleExpand,
    required this.parentCheckState,
  });

  final _TransferRow<T> row;

  /// 是否为树形数据：树形行需要为展开箭头预留占位，扁平列表不预留，
  /// 这样扁平项的复选框才能与表头全选框左对齐（antd 行为）。
  final bool treeMode;
  final List<Object> selectedKeys;
  final bool disabled;
  final AntThemeData theme;
  final Object Function(T item) keyOf;
  final Widget Function(BuildContext context, T item) titleOf;
  final String? Function(T item) descriptionOf;
  final VoidCallback onTap;
  final VoidCallback onToggleExpand;
  final ({bool checked, bool indeterminate}) Function(T node) parentCheckState;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final item = row.item;
    final key = keyOf(item);
    final isDisabled = disabled || row.disabled;
    bool checked;
    var indeterminate = false;
    if (row.hasChildren) {
      final state = parentCheckState(item);
      checked = state.checked;
      indeterminate = state.indeterminate;
    } else {
      checked = selectedKeys.contains(key);
    }
    final description = descriptionOf(item);
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.s(12),
          vertical: t.s(8),
        ),
        child: Row(
          children: [
            // 展开箭头占位（含层级缩进）
            SizedBox(width: row.depth * t.s(16)),
            if (row.hasChildren)
              GestureDetector(
                onTap: onToggleExpand,
                child: Padding(
                  padding: EdgeInsets.only(right: t.s(4)),
                  child: Icon(
                    row.expanded
                        ? AntIcons.downOutlined
                        : AntIcons.rightOutlined,
                    size: t.s(16),
                    color: t.colorTextSecondary,
                  ),
                ),
              )
            else if (treeMode)
              SizedBox(width: t.s(20)),
            AntCheckbox(
              checked: checked,
              indeterminate: indeterminate,
              disabled: isDisabled,
              onChange: isDisabled ? null : (_) => onTap(),
              child: const SizedBox.shrink(),
            ),
            SizedBox(width: t.s(8)),
            Expanded(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: isDisabled ? t.colorTextDisabled : t.colorText,
                ),
                child: titleOf(context, item),
              ),
            ),
            if (description != null)
              Text(
                description,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorTextTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 中间操作按钮。
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
        width: t.s(32),
        height: t.s(32),
        decoration: BoxDecoration(
          color: enabled ? t.colorPrimary : t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Center(
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color: enabled ? Colors.white : t.colorTextDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Icon(
                  icon,
                  size: t.s(18),
                  color: enabled ? Colors.white : t.colorTextDisabled,
                ),
        ),
      ),
    );
  }
}
