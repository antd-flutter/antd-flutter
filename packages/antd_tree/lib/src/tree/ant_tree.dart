/// AntTree — antd React Tree 的 Flutter 实现
///
/// API 与 antd React Tree 对齐：
/// - [treeData] — 树节点数据
/// - 展开/收起：[defaultExpandedKeys] / [defaultExpandAll]、受控 [expandedKeys] + [onExpand]
/// - 选中：[selectable]、[selectedKeys] 受控 / [defaultSelectedKeys]、[onSelect]
/// - 复选：[checkable]、[checkedKeys] 受控 / [defaultCheckedKeys]、[onCheck]
///   父子联动（父勾选→子全选、子全选→父勾选、半选态）；[checkStrictly] 严格模式不联动
/// - [showLine] 连接线、[indent] 缩进、节点禁用
///
/// ```dart
/// AntTree(
///   treeData: [
///     AntTreeNode(key: 'zj', title: '浙江', children: [
///       AntTreeNode(key: 'hz', title: '杭州'),
///     ]),
///   ],
///   checkable: true,
///   onCheck: (checkedKeys, halfCheckedKeys) => print(checkedKeys),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'package:antd_tree/src/tree/ant_tree_types.dart';

export 'package:antd_tree/src/tree/ant_tree_types.dart';

/// 勾选回调：[checkedKeys] 全选节点，[halfCheckedKeys] 半选节点。
typedef AntTreeOnCheck = void Function(
  List<String> checkedKeys,
  List<String> halfCheckedKeys,
);

// ============================================================
// AntTree
// ============================================================

/// 树形控件 — 多层次的结构列表。
///
/// 对齐 antd React Tree 组件。
class AntTree extends StatefulWidget {
  const AntTree({
    super.key,
    this.treeData = const [],
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

  /// 树节点数据。
  final List<AntTreeNode> treeData;

  /// 默认展开的节点 key。
  final List<String>? defaultExpandedKeys;

  /// 默认展开全部节点。
  final bool defaultExpandAll;

  /// 受控展开的节点 key。
  final List<String>? expandedKeys;

  /// 展开/收起回调。
  final ValueChanged<List<String>>? onExpand;

  /// 是否可选中。
  final bool selectable;

  /// 默认选中的节点 key。
  final List<String>? defaultSelectedKeys;

  /// 受控选中的节点 key。
  final List<String>? selectedKeys;

  /// 选中回调。
  final ValueChanged<List<String>>? onSelect;

  /// 是否显示复选框。
  final bool checkable;

  /// 默认勾选的节点 key。
  final List<String>? defaultCheckedKeys;

  /// 受控勾选的节点 key。
  final List<String>? checkedKeys;

  /// 勾选回调。
  final AntTreeOnCheck? onCheck;

  /// 严格勾选模式：父子不联动。
  final bool checkStrictly;

  /// 是否显示连接线。
  final bool showLine;

  /// 每级缩进宽度，默认 24。
  final double? indent;

  @override
  State<AntTree> createState() => _AntTreeState();
}

class _AntTreeState extends State<AntTree> {
  Set<String>? _internalExpandedKeys;
  Set<String>? _internalSelectedKeys;
  Set<String>? _internalCheckedKeys;

  /// 收集所有有子节点的 key（用于 defaultExpandAll）。
  Set<String> _collectParentKeys(List<AntTreeNode> nodes) {
    final keys = <String>{};
    for (final node in nodes) {
      if (!node.isLeaf) {
        keys.add(node.key);
        keys.addAll(_collectParentKeys(node.children!));
      }
    }
    return keys;
  }

  /// 收集节点及其全部后代 key。
  Set<String> _collectDescendantKeys(AntTreeNode node) {
    final keys = <String>{node.key};
    for (final child in node.children ?? const <AntTreeNode>[]) {
      keys.addAll(_collectDescendantKeys(child));
    }
    return keys;
  }

  // ---------- 收集祖先 key
  Set<String> _ancestorKeys(String key, [List<AntTreeNode>? nodes]) {
    final ancestors = <String>{};
    void walk(List<AntTreeNode> list, Set<String> path) {
      for (final node in list) {
        if (node.key == key) {
          ancestors.addAll(path);
          return;
        }
        walk(node.children ?? const [], {...path, node.key});
      }
    }

    walk(nodes ?? widget.treeData, <String>{});
    return ancestors;
  }

  // ---------- 展开 ----------

  Set<String> get _expandedKeys {
    if (widget.expandedKeys != null) return widget.expandedKeys!.toSet();
    if (_internalExpandedKeys == null) {
      if (widget.defaultExpandAll) {
        _internalExpandedKeys = _collectParentKeys(widget.treeData);
      } else {
        _internalExpandedKeys = widget.defaultExpandedKeys?.toSet() ?? {};
      }
    }
    return _internalExpandedKeys!;
  }

  void _toggleExpand(AntTreeNode node) {
    if (node.disabled) return;
    if (node.isLeaf) return;
    setState(() {
      final keys = {..._expandedKeys};
      if (keys.contains(node.key)) {
        keys.remove(node.key);
      } else {
        keys.add(node.key);
      }
      if (widget.expandedKeys == null) _internalExpandedKeys = keys;
      widget.onExpand?.call(keys.toList());
    });
  }

  // ---------- 选中 ----------

  Set<String> get _selectedKeys {
    if (widget.selectedKeys != null) return widget.selectedKeys!.toSet();
    _internalSelectedKeys ??= widget.defaultSelectedKeys?.toSet() ?? {};
    return _internalSelectedKeys!;
  }

  void _handleSelect(AntTreeNode node) {
    if (!widget.selectable || node.disabled) return;
    setState(() {
      final keys = {..._selectedKeys};
      if (keys.contains(node.key)) {
        keys.remove(node.key);
      } else {
        keys.add(node.key);
      }
      if (widget.selectedKeys == null) _internalSelectedKeys = keys;
      widget.onSelect?.call(keys.toList());
    });
  }

  // ---------- 勾选 ----------

  Set<String> get _directCheckedKeys {
    if (widget.checkedKeys != null) return widget.checkedKeys!.toSet();
    _internalCheckedKeys ??= widget.defaultCheckedKeys?.toSet() ?? {};
    return _internalCheckedKeys!;
  }

  /// 计算完全勾选集合：直接勾选节点及其全部后代，或子节点全部勾选的父节点。
  Set<String> _resolveCheckedKeys(Set<String> direct) {
    if (widget.checkStrictly) return direct;

    bool isFullyChecked(AntTreeNode node) {
      if (direct.contains(node.key)) return true;
      final children = node.children;
      if (children == null || children.isEmpty) return false;
      return children.every(isFullyChecked);
    }

    final result = <String>{};
    void walk(List<AntTreeNode> nodes) {
      for (final node in nodes) {
        if (isFullyChecked(node)) result.add(node.key);
        walk(node.children ?? const []);
      }
    }

    walk(widget.treeData);
    return result;
  }

  /// 计算半选集合：自身未完全勾选但有后代被勾选。
  Set<String> _resolveHalfCheckedKeys(Set<String> checked) {
    if (widget.checkStrictly) return {};

    final half = <String>{};
    void walk(List<AntTreeNode> nodes) {
      for (final node in nodes) {
        if (checked.contains(node.key)) {
          half.addAll(_ancestorKeys(node.key));
        }
        walk(node.children ?? const []);
      }
    }

    walk(widget.treeData);
    half.removeAll(checked);
    return half;
  }

  void _handleCheck(AntTreeNode node) {
    if (!widget.checkable || node.disabled || !node.checkable) return;
    setState(() {
      final direct = {..._directCheckedKeys};
      final checked = _resolveCheckedKeys(direct);
      if (checked.contains(node.key)) {
        direct.removeAll(_collectDescendantKeys(node));
      } else {
        direct.addAll(_collectDescendantKeys(node));
      }
      if (widget.checkedKeys == null) _internalCheckedKeys = direct;
      widget.onCheck?.call(
        _resolveCheckedKeys(direct).toList(),
        _resolveHalfCheckedKeys(_resolveCheckedKeys(direct)).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final node in widget.treeData)
          _TreeNodeRow(
            node: node,
            tree: widget,
            theme: theme,
            depth: 0,
            expandedKeys: _expandedKeys,
            selectedKeys: _selectedKeys,
            checkedKeys: _resolveCheckedKeys(_directCheckedKeys),
            halfCheckedKeys:
                _resolveHalfCheckedKeys(_resolveCheckedKeys(_directCheckedKeys)),
            indent: widget.indent ?? 24,
            onToggleExpand: _toggleExpand,
            onSelect: _handleSelect,
            onCheck: _handleCheck,
          ),
      ],
    );
  }
}

// ============================================================
// _TreeNodeRow — 单个节点行
// ============================================================

class _TreeNodeRow extends StatelessWidget {
  const _TreeNodeRow({
    required this.node,
    required this.tree,
    required this.theme,
    required this.depth,
    required this.expandedKeys,
    required this.selectedKeys,
    required this.checkedKeys,
    required this.halfCheckedKeys,
    required this.indent,
    required this.onToggleExpand,
    required this.onSelect,
    required this.onCheck,
  });

  final AntTreeNode node;
  final AntTree tree;
  final AntThemeData theme;
  final int depth;
  final Set<String> expandedKeys;
  final Set<String> selectedKeys;
  final Set<String> checkedKeys;
  final Set<String> halfCheckedKeys;
  final double indent;
  final ValueChanged<AntTreeNode> onToggleExpand;
  final ValueChanged<AntTreeNode> onSelect;
  final ValueChanged<AntTreeNode> onCheck;

  bool get _expanded => expandedKeys.contains(node.key);
  bool get _selected => selectedKeys.contains(node.key);
  bool get _checked => checkedKeys.contains(node.key);
  bool get _halfChecked => halfCheckedKeys.contains(node.key);

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final children = <Widget>[];

    // 缩进 / 连接线引导
    for (var i = 0; i < depth; i++) {
      children.add(
        tree.showLine
            ? Container(
                width: indent,
                alignment: Alignment.center,
                child: Container(
                  width: 1,
                  height: 24.w,
                  color: t.colorBorderSecondary,
                ),
              )
            : SizedBox(width: indent),
      );
    }

    // switcher 箭头
    children.add(_buildSwitcher(t));

    // 复选框
    if (tree.checkable && node.checkable) {
      children.add(GestureDetector(
        onTap: () => onCheck(node),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: _buildCheckbox(t),
        ),
      ),);
      children.add(SizedBox(width: 2.w));
    }

    // 标题
    children.add(Expanded(
      child: GestureDetector(
        onTap: () => onSelect(node),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.borderRadiusXS),
            color: _selected
                ? t.colorPrimaryBg
                : (node.disabled ? t.colorBgContainerDisabled : Colors.transparent),
          ),
          child: Text(
            node.title,
            style: TextStyle(
              fontSize: t.fontSize.sp,
              height: 1.5,
              color: node.disabled ? t.colorTextDisabled : t.colorText,
            ),
          ),
        ),
      ),
    ),);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
        // 子节点（展开动画）
        if (!node.isLeaf)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topLeft,
            child: !_expanded
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final child in node.children!)
                        _TreeNodeRow(
                          node: child,
                          tree: tree,
                          theme: theme,
                          depth: depth + 1,
                          expandedKeys: expandedKeys,
                          selectedKeys: selectedKeys,
                          checkedKeys: checkedKeys,
                          halfCheckedKeys: halfCheckedKeys,
                          indent: indent,
                          onToggleExpand: onToggleExpand,
                          onSelect: onSelect,
                          onCheck: onCheck,
                        ),
                    ],
                  ),
          ),
      ],
    );
  }

  /// switcher：展开/收起箭头（带旋转动画）或叶子占位。
  Widget _buildSwitcher(AntThemeData t) {
    if (node.isLeaf) {
      return SizedBox(width: 16.w + 4.w);
    }
    return GestureDetector(
      onTap: () => onToggleExpand(node),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: AnimatedRotation(
          turns: _expanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            tree.showLine
                ? Icons.subdirectory_arrow_right
                : Icons.expand_more,
            size: 14.sp,
            color: node.disabled ? t.colorTextDisabled : t.colorTextQuaternary,
          ),
        ),
      ),
    );
  }

  /// 复选框：全选 / 半选 / 未选。
  Widget _buildCheckbox(AntThemeData t) {
    final color = node.disabled ? t.colorTextDisabled : t.colorPrimary;
    if (_halfChecked) {
      return Icon(Icons.indeterminate_check_box_outlined,
          size: 18.sp, color: color,);
    }
    if (_checked) {
      return Icon(Icons.check_box_outlined, size: 18.sp, color: color);
    }
    return Icon(
      Icons.check_box_outline_blank_outlined,
      size: 18.sp,
      color: node.disabled ? t.colorTextDisabled : t.colorBorder,
    );
  }
}
