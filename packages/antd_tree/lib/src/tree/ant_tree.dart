/// Ant Design 风格树形控件（泛型数据源）。
///
/// 用户直接传入自己的模型列表 `List<T>`，通过 `keyOf` / `titleBuilder` /
/// `childrenOf` / `disabledOf` / `checkableOf` 描述如何读写模型，组件不再
/// 要求构造任何专用节点类。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_tree_types.dart';

export 'ant_tree_types.dart';

/// 树形控件。
///
/// ```dart
/// AntTree<Category>(
///   dataSource: categories,
///   keyOf: (c) => c.id,
///   titleBuilder: (_, c) => Text(c.name),
///   childrenOf: (c) => c.children,
///   checkable: true,
///   checkedKeys: checked,
///   onCheck: (keys, half) {},
/// );
/// ```
class AntTree<T> extends StatefulWidget {
  const AntTree({
    super.key,
    required this.dataSource,
    this.keyOf,
    this.titleBuilder,
    this.childrenOf,
    this.disabledOf,
    this.checkableOf,
    this.defaultExpandedKeys,
    this.defaultExpandAll = false,
    this.expandedKeys,
    this.onExpand,
    this.selectable = true,
    this.defaultSelectedKeys,
    this.selectedKeys,
    this.onSelect,
    this.checkable = false,
    this.defaultCheckedKeys,
    this.checkedKeys,
    this.onCheck,
    this.checkStrictly = false,
    this.showLine = false,
    this.indent,
  });

  /// 数据源（树形结构由 [childrenOf] 描述；为 null 时视为扁平列表）。
  final List<T> dataSource;

  /// 从数据项提取唯一 key；缺省使用按 DFS 顺序生成的稳定序号。
  final AntTreeKeyOf<T>? keyOf;

  /// 节点标题构建器；缺省回退为 `Text('$item')`。
  final AntTreeTitleBuilder<T>? titleBuilder;

  /// 子节点读取器；缺省视为叶子。
  final AntTreeChildrenOf<T>? childrenOf;

  /// 禁用判断；缺省全部可用。
  final AntTreeDisabledOf<T>? disabledOf;

  /// 可勾选判断；缺省全部可勾选。
  final AntTreeCheckableOf<T>? checkableOf;

  /// 非受控默认展开的 key 集合。
  final Set<Object>? defaultExpandedKeys;

  /// 是否默认展开全部父节点。
  final bool defaultExpandAll;

  /// 受控展开 key 集合；非 null 时展开状态由外部驱动。
  final Set<Object>? expandedKeys;

  /// 展开状态变化回调（参数为 keyOf 提取的 key）。
  final ValueChanged<Set<Object>>? onExpand;

  /// 标题是否可选中。
  final bool selectable;

  /// 非受控默认选中的 key 集合。
  final Set<Object>? defaultSelectedKeys;

  /// 受控选中 key 集合。
  final Set<Object>? selectedKeys;

  /// 选中状态变化回调。
  final ValueChanged<Set<Object>>? onSelect;

  /// 是否显示勾选框。
  final bool checkable;

  /// 非受控默认勾选的 key 集合。
  final Set<Object>? defaultCheckedKeys;

  /// 受控勾选 key 集合。
  final Set<Object>? checkedKeys;

  /// 勾选状态变化回调。
  final AntTreeOnCheck? onCheck;

  /// 父子勾选是否不联动。
  final bool checkStrictly;

  /// 是否显示连接线。
  final bool showLine;

  /// 每级缩进宽度；缺省 24。
  final double? indent;

  @override
  State<AntTree<T>> createState() => _AntTreeState<T>();
}

class _AntTreeState<T> extends State<AntTree<T>> {
  Set<Object>? _internalExpandedKeys;
  Set<Object>? _internalSelectedKeys;
  Set<Object>? _internalCheckedKeys;

  /// 缺省 key：整棵树按 DFS 顺序生成，避免展开/折叠导致 key 漂移。
  Map<T, Object> _defaultKeyMap = Map<T, Object>.identity();
  List<T>? _defaultKeySource;
  AntTreeChildrenOf<T>? _defaultKeyChildrenOf;
  int _defaultKeySeq = 0;

  @override
  void initState() {
    super.initState();
    _internalExpandedKeys = widget.defaultExpandedKeys == null
        ? null
        : <Object>{...widget.defaultExpandedKeys!};
    _internalSelectedKeys = widget.defaultSelectedKeys == null
        ? null
        : <Object>{...widget.defaultSelectedKeys!};
    _internalCheckedKeys = widget.defaultCheckedKeys == null
        ? null
        : <Object>{...widget.defaultCheckedKeys!};
    _ensureDefaultKeys();
    if (widget.expandedKeys == null && widget.defaultExpandAll) {
      _internalExpandedKeys = _collectParentKeys();
    }
  }

  @override
  void didUpdateWidget(covariant AntTree<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyOf != oldWidget.keyOf ||
        !identical(widget.dataSource, oldWidget.dataSource) ||
        widget.childrenOf != oldWidget.childrenOf) {
      _defaultKeySource = null;
    }
    _ensureDefaultKeys();
  }

  // ----------------------------------------------------------
  // 模型读取
  // ----------------------------------------------------------

  void _ensureDefaultKeys() {
    if (widget.keyOf != null) return;
    if (identical(_defaultKeySource, widget.dataSource) &&
        _defaultKeyChildrenOf == widget.childrenOf) {
      return;
    }
    _defaultKeySource = widget.dataSource;
    _defaultKeyChildrenOf = widget.childrenOf;
    _defaultKeyMap = Map<T, Object>.identity();
    _defaultKeySeq = 0;

    void walk(List<T> items) {
      for (final item in items) {
        if (!_defaultKeyMap.containsKey(item)) {
          _defaultKeyMap[item] = _defaultKeySeq++;
        }
        walk(_childrenOf(item));
      }
    }

    walk(widget.dataSource);
  }

  Object _keyOf(T item) {
    final keyOf = widget.keyOf;
    if (keyOf != null) return keyOf(item);
    _ensureDefaultKeys();
    return _defaultKeyMap[item] ?? _defaultKeyMap.length;
  }

  List<T> _childrenOf(T item) {
    final childrenOf = widget.childrenOf;
    if (childrenOf == null) return const <Never>[];
    return childrenOf(item);
  }

  bool _disabledOf(T item) => widget.disabledOf?.call(item) ?? false;

  bool _checkableOf(T item) => widget.checkableOf?.call(item) ?? true;

  Widget _titleOf(BuildContext context, T item) {
    final builder = widget.titleBuilder;
    if (builder != null) return builder(context, item);
    return Text(
      item is String ? item : '$item',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // ----------------------------------------------------------
  // 展开
  // ----------------------------------------------------------

  Set<Object> get _expandedKeys =>
      widget.expandedKeys ?? _internalExpandedKeys ?? const <Object>{};

  Set<Object> _collectParentKeys() {
    final keys = <Object>{};
    void walk(List<T> items) {
      for (final item in items) {
        final children = _childrenOf(item);
        if (children.isEmpty) continue;
        keys.add(_keyOf(item));
        walk(children);
      }
    }

    walk(widget.dataSource);
    return keys;
  }

  void _toggleExpand(T item) {
    if (_disabledOf(item)) return;
    if (_childrenOf(item).isEmpty) return;
    final key = _keyOf(item);
    final next = <Object>{..._expandedKeys};
    if (!next.remove(key)) next.add(key);
    if (widget.expandedKeys == null) {
      setState(() => _internalExpandedKeys = next);
    }
    widget.onExpand?.call(next);
  }

  // ----------------------------------------------------------
  // 选中
  // ----------------------------------------------------------

  Set<Object> get _selectedKeys =>
      widget.selectedKeys ?? _internalSelectedKeys ?? const <Object>{};

  void _handleSelect(T item) {
    if (!widget.selectable || _disabledOf(item)) return;
    final key = _keyOf(item);
    final next = <Object>{..._selectedKeys};
    if (!next.remove(key)) next.add(key);
    if (widget.selectedKeys == null) {
      setState(() => _internalSelectedKeys = next);
    }
    widget.onSelect?.call(next);
  }

  // ----------------------------------------------------------
  // 勾选
  // ----------------------------------------------------------

  Set<Object> get _directCheckedKeys =>
      widget.checkedKeys ?? _internalCheckedKeys ?? const <Object>{};

  Set<Object> _resolveCheckedKeys() {
    if (widget.checkStrictly) return <Object>{..._directCheckedKeys};
    final direct = _directCheckedKeys;
    final result = <Object>{};

    bool visit(T item) {
      final key = _keyOf(item);
      final children = _childrenOf(item);
      var allChildrenChecked = children.isNotEmpty;
      for (final child in children) {
        if (!visit(child)) allChildrenChecked = false;
      }
      final self =
          _checkableOf(item) && (direct.contains(key) || allChildrenChecked);
      if (self) result.add(key);
      return self;
    }

    for (final item in widget.dataSource) {
      visit(item);
    }
    return result;
  }

  Set<Object> _resolveHalfCheckedKeys(Set<Object> checked) {
    if (widget.checkStrictly) return const <Object>{};
    final half = <Object>{};

    bool hasCheckedDescendant(T item) {
      for (final child in _childrenOf(item)) {
        if (checked.contains(_keyOf(child)) || hasCheckedDescendant(child)) {
          return true;
        }
      }
      return false;
    }

    void walk(List<T> items) {
      for (final item in items) {
        final key = _keyOf(item);
        if (_checkableOf(item) &&
            !checked.contains(key) &&
            hasCheckedDescendant(item)) {
          half.add(key);
        }
        walk(_childrenOf(item));
      }
    }

    walk(widget.dataSource);
    return half;
  }

  Set<Object> _collectDescendantKeys(T item) {
    final keys = <Object>{};
    void walk(List<T> items) {
      for (final child in items) {
        keys.add(_keyOf(child));
        walk(_childrenOf(child));
      }
    }

    walk(_childrenOf(item));
    return keys;
  }

  Set<Object> _ancestorKeys(T item) {
    final ancestors = <Object>{};

    bool walk(T node, Set<Object> path) {
      if (identical(node, item) || node == item) {
        ancestors.addAll(path);
        return true;
      }
      final nextPath = <Object>{...path, _keyOf(node)};
      for (final child in _childrenOf(node)) {
        if (walk(child, nextPath)) return true;
      }
      return false;
    }

    for (final root in widget.dataSource) {
      if (walk(root, const <Object>{})) break;
    }
    return ancestors;
  }

  void _handleCheck(T item) {
    if (!widget.checkable || _disabledOf(item) || !_checkableOf(item)) return;
    final key = _keyOf(item);
    final direct = <Object>{..._directCheckedKeys};

    if (widget.checkStrictly) {
      if (!direct.remove(key)) direct.add(key);
      if (widget.checkedKeys == null) {
        setState(() => _internalCheckedKeys = direct);
      }
      widget.onCheck?.call(direct, const <Object>{});
      return;
    }

    final currentlyChecked = _resolveCheckedKeys().contains(key);
    // 祖先不再强制全选，否则取消单个子项后父级仍会把它补回来。
    for (final ancestor in _ancestorKeys(item)) {
      direct.remove(ancestor);
    }
    if (currentlyChecked) {
      direct.remove(key);
      direct.removeAll(_collectDescendantKeys(item));
    } else {
      direct.add(key);
      direct.addAll(_collectDescendantKeys(item));
    }

    if (widget.checkedKeys == null) {
      setState(() => _internalCheckedKeys = direct);
    }
    final checked = _resolveCheckedKeys();
    widget.onCheck?.call(checked, _resolveHalfCheckedKeys(checked));
  }

  // ----------------------------------------------------------
  // 构建
  // ----------------------------------------------------------

  double get _indentWidth => (widget.indent ?? 24).w;

  @override
  Widget build(BuildContext context) {
    _ensureDefaultKeys();
    final theme = AntTheme.of(context);
    final checked = _resolveCheckedKeys();
    final half = _resolveHalfCheckedKeys(checked);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in widget.dataSource)
          _buildNode(item, 0, theme, checked, half),
      ],
    );
  }

  Widget _buildNode(
    T item,
    int depth,
    AntThemeData theme,
    Set<Object> checked,
    Set<Object> half,
  ) {
    final children = _childrenOf(item);
    final key = _keyOf(item);
    final expanded = _expandedKeys.contains(key);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TreeNodeRow<T>(
          tree: widget,
          item: item,
          depth: depth,
          expanded: expanded,
          selected: _selectedKeys.contains(key),
          checked: checked.contains(key),
          halfChecked: half.contains(key),
          indentWidth: _indentWidth,
          title: _titleOf(context, item),
          onToggle: () => _toggleExpand(item),
          onSelect: () => _handleSelect(item),
          onCheck: () => _handleCheck(item),
        ),
        if (children.isNotEmpty)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final child in children)
                        _buildNode(child, depth + 1, theme, checked, half),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
      ],
    );
  }
}

/// 单行节点。
class _TreeNodeRow<T> extends StatelessWidget {
  const _TreeNodeRow({
    required this.tree,
    required this.item,
    required this.depth,
    required this.expanded,
    required this.selected,
    required this.checked,
    required this.halfChecked,
    required this.indentWidth,
    required this.title,
    required this.onToggle,
    required this.onSelect,
    required this.onCheck,
  });

  final AntTree<T> tree;
  final T item;
  final int depth;
  final bool expanded;
  final bool selected;
  final bool checked;
  final bool halfChecked;
  final double indentWidth;
  final Widget title;
  final VoidCallback onToggle;
  final VoidCallback onSelect;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final disabled = tree.disabledOf?.call(item) ?? false;
    final checkable = tree.checkableOf?.call(item) ?? true;
    final hasChildren = (tree.childrenOf?.call(item) ?? const []).isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < depth; i++)
          SizedBox(
            width: indentWidth,
            height: 24.h,
            child: tree.showLine
                ? Center(
                    child: Container(
                      width: 1,
                      height: 24.h,
                      color: theme.colorBorderSecondary,
                    ),
                  )
                : null,
          ),
        // 展开/收起
        if (!hasChildren)
          SizedBox(width: 20.w, height: 24.h)
        else
          GestureDetector(
            onTap: disabled ? null : onToggle,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 20.w,
              height: 24.h,
              child: Center(
                child: AnimatedRotation(
                  turns: expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    tree.showLine
                        ? AntIcons.enterOutlined
                        : AntIcons.downOutlined,
                    size: 14.sp,
                    color: disabled
                        ? theme.colorTextDisabled
                        : theme.colorTextQuaternary,
                  ),
                ),
              ),
            ),
          ),
        // 勾选框
        if (tree.checkable && checkable)
          GestureDetector(
            onTap: disabled ? null : onCheck,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Icon(
                halfChecked
                    ? AntIcons.minusSquareFilled
                    : checked
                        ? AntIcons.checkSquareOutlined
                        : AntIcons.borderOutlined,
                size: 18.sp,
                color: disabled
                    ? theme.colorTextDisabled
                    : halfChecked || checked
                        ? theme.colorPrimary
                        : theme.colorTextQuaternary,
              ),
            ),
          ),
        // 标题
        Expanded(
          child: GestureDetector(
            onTap: tree.selectable && !disabled ? onSelect : null,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
              decoration: BoxDecoration(
                color: selected
                    ? theme.colorPrimaryBg
                    : disabled
                        ? theme.colorBgContainerDisabled
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(theme.borderRadiusXS),
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: theme.fontSize.sp,
                  height: 1.5,
                  color: disabled ? theme.colorTextDisabled : theme.colorText,
                ),
                child: title,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
