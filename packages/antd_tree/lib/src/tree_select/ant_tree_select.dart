/// AntTreeSelect — antd React TreeSelect 的 Flutter 实现
///
/// API 与 antd React TreeSelect 对齐：
/// - [treeData] — 树节点数据
/// - [value] / [defaultValue] — 受控/非受控值
/// - [onChange] — 值变化回调
/// - [placeholder] / [disabled] / [allowClear] / [size]
/// - [treeDefaultExpandAll] — 默认展开全部节点
/// - [multiple] — 多选模式
///
/// ```dart
/// AntTreeSelect(
///   treeData: [
///     AntTreeSelectOption(value: 'zj', label: '浙江', children: [
///       AntTreeSelectOption(value: 'hz', label: '杭州'),
///     ]),
///   ],
///   onChange: (value) => print(value),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/tree_select/ant_tree_select_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

export 'package:antd_flutter_plus/src/components/data_entry/tree_select/ant_tree_select_types.dart';

// ============================================================
// AntTreeSelect
// ============================================================

/// 树选择组件。
///
/// 类似 Select 的下拉，但选项为树形结构。
class AntTreeSelect extends StatefulWidget {
  const AntTreeSelect({
    super.key,
    this.treeData = const [],
    this.value,
    this.defaultValue,
    this.onChange,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.treeDefaultExpandAll = false,
    this.multiple = false,
    this.size = AntTreeSelectSize.middle,
  });

  /// 树节点数据
  final List<AntTreeSelectOption> treeData;

  /// 受控值（单选 String / 多选 `List<String>`）
  final Object? value;

  /// 非受控默认值
  final Object? defaultValue;

  /// 值变化回调
  final ValueChanged<Object?>? onChange;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 默认展开全部节点
  final bool treeDefaultExpandAll;

  /// 多选模式
  final bool multiple;

  /// 尺寸
  final AntTreeSelectSize size;

  @override
  State<AntTreeSelect> createState() => _AntTreeSelectState();
}

class _AntTreeSelectState extends State<AntTreeSelect> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 已展开的节点值集合
  Set<String> _expandedKeys = {};

  /// 单选内部值
  String? _internalValue;

  /// 多选内部值
  List<String> _internalMultiValue = [];

  String? get _currentSingleValue =>
      widget.value is String ? widget.value as String : _internalValue;

  List<String> get _currentMultiValue {
    if (widget.value is List<String>) return widget.value as List<String>;
    return _internalMultiValue;
  }

  double get _height {
    switch (widget.size) {
      case AntTreeSelectSize.large:
        return 40;
      case AntTreeSelectSize.small:
        return 24;
      case AntTreeSelectSize.middle:
        return 32;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue is String) {
      _internalValue = widget.defaultValue as String;
    } else if (widget.defaultValue is List<String>) {
      _internalMultiValue = List.from(widget.defaultValue as List<String>);
    }
    if (widget.treeDefaultExpandAll) {
      _expandedKeys = _collectAllParentKeys(widget.treeData);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  /// 收集所有有子节点的节点值（用于 expandAll）
  Set<String> _collectAllParentKeys(List<AntTreeSelectOption> nodes) {
    final keys = <String>{};
    for (final node in nodes) {
      if (!node.isLeaf) {
        keys.add(node.value);
        keys.addAll(_collectAllParentKeys(node.children!));
      }
    }
    return keys;
  }

  /// 遍历树查找节点
  AntTreeSelectOption? _findNode(String value, [List<AntTreeSelectOption>? nodes]) {
    final list = nodes ?? widget.treeData;
    for (final node in list) {
      if (node.value == value) return node;
      if (!node.isLeaf) {
        final found = _findNode(value, node.children);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// 获取显示文本
  String get _displayText {
    if (widget.multiple) {
      final values = _currentMultiValue;
      if (values.isEmpty) return '';
      return values.map((v) => _findNode(v)?.label ?? v).join('、');
    }
    final v = _currentSingleValue;
    if (v == null) return '';
    return _findNode(v)?.label ?? v;
  }

  void _showOverlay() {
    if (_open || widget.disabled) return;
    final t = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _TreeSelectOverlay(
        layerLink: _layerLink,
        themeData: t,
        treeData: widget.treeData,
        expandedKeys: _expandedKeys,
        selectedValue: widget.multiple ? null : _currentSingleValue,
        selectedMultiValues: widget.multiple ? _currentMultiValue : null,
        multiple: widget.multiple,
        onSelect: _onSelect,
        onToggleExpand: _onToggleExpand,
        onDismiss: _removeOverlay,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  void _onToggleExpand(String key) {
    setState(() {
      if (_expandedKeys.contains(key)) {
        _expandedKeys.remove(key);
      } else {
        _expandedKeys.add(key);
      }
    });
    _updateOverlay();
  }

  void _onSelect(AntTreeSelectOption option) {
    if (option.disabled) return;
    if (widget.multiple) {
      final values = List<String>.from(_currentMultiValue);
      if (values.contains(option.value)) {
        values.remove(option.value);
      } else {
        values.add(option.value);
      }
      setState(() => _internalMultiValue = values);
      widget.onChange?.call(values);
      _updateOverlay();
    } else {
      setState(() => _internalValue = option.value);
      widget.onChange?.call(option.value);
      _removeOverlay();
    }
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      final t = AntTheme.of(context);
      _overlayEntry!.remove();
      _overlayEntry = OverlayEntry(
        builder: (context) => _TreeSelectOverlay(
          layerLink: _layerLink,
          themeData: t,
          treeData: widget.treeData,
          expandedKeys: _expandedKeys,
          selectedValue: widget.multiple ? null : _currentSingleValue,
          selectedMultiValues: widget.multiple ? _currentMultiValue : null,
          multiple: widget.multiple,
          onSelect: _onSelect,
          onToggleExpand: _onToggleExpand,
          onDismiss: _removeOverlay,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _clear() {
    setState(() {
      if (widget.multiple) {
        _internalMultiValue = [];
      } else {
        _internalValue = null;
      }
    });
    widget.onChange?.call(widget.multiple ? <String>[] : null);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize = widget.size == AntTreeSelectSize.small ? t.fontSizeSM : t.fontSize;
    final hasValue = widget.multiple
        ? _currentMultiValue.isNotEmpty
        : _currentSingleValue != null;
    final showClear = widget.allowClear && hasValue && !widget.disabled;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.disabled ? null : (_open ? _removeOverlay : _showOverlay),
        child: Container(
          height: _height.h,
          padding: EdgeInsets.symmetric(
            horizontal: (widget.size == AntTreeSelectSize.small ? 7 : 12).w,
            vertical: (widget.multiple ? 2 : 0).h,
          ),
          decoration: BoxDecoration(
            color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
            border: Border.all(
              color: _open ? t.colorPrimary : t.colorBorder,
              width: _open ? t.controlOutlineWidth : 1,
            ),
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayText.isNotEmpty ? _displayText : (widget.placeholder ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize.sp,
                    color: _displayText.isNotEmpty
                        ? (widget.disabled ? t.colorTextDisabled : t.colorText)
                        : t.colorTextPlaceholder,
                  ),
                ),
              ),
              if (showClear)
                GestureDetector(
                  onTap: _clear,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Icon(Icons.cancel, size: 14.sp, color: t.colorTextQuaternary),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 14.sp,
                    color: t.colorTextQuaternary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _TreeSelectOverlay — 树形下拉面板
// ============================================================

class _TreeSelectOverlay extends StatelessWidget {
  const _TreeSelectOverlay({
    required this.layerLink,
    required this.themeData,
    required this.treeData,
    required this.expandedKeys,
    required this.selectedValue,
    required this.selectedMultiValues,
    required this.multiple,
    required this.onSelect,
    required this.onToggleExpand,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final AntThemeData themeData;
  final List<AntTreeSelectOption> treeData;
  final Set<String> expandedKeys;
  final String? selectedValue;
  final List<String>? selectedMultiValues;
  final bool multiple;
  final ValueChanged<AntTreeSelectOption> onSelect;
  final ValueChanged<String> onToggleExpand;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = themeData;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          child: CompositedTransformFollower(
            link: layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 4.h),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 256.h,
                  minWidth: 160.w,
                ),
                decoration: BoxDecoration(
                  color: t.colorBgContainer,
                  borderRadius: BorderRadius.circular(t.borderRadiusLG),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildNodes(treeData, 0, t),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNodes(List<AntTreeSelectOption> nodes, int depth, AntThemeData t) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final node in nodes) _buildNode(node, depth, t),
      ],
    );
  }

  Widget _buildNode(AntTreeSelectOption node, int depth, AntThemeData t) {
    final isExpanded = expandedKeys.contains(node.value);
    final isSelected = multiple
        ? (selectedMultiValues?.contains(node.value) ?? false)
        : selectedValue == node.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TreeNodeTile(
          node: node,
          depth: depth,
          isExpanded: isExpanded,
          isSelected: isSelected,
          multiple: multiple,
          fontSize: t.fontSize,
          colorText: t.colorText,
          colorTextDisabled: t.colorTextDisabled,
          colorPrimary: t.colorPrimary,
          colorFillSecondary: t.colorFillSecondary,
          marginSM: t.marginSM,
          onTap: () => onSelect(node),
          onToggle: node.isLeaf ? null : () => onToggleExpand(node.value),
        ),
        if (!node.isLeaf && isExpanded)
          _buildNodes(node.children!, depth + 1, t),
      ],
    );
  }
}

// ============================================================
// _TreeNodeTile — 单个树节点条目
// ============================================================

class _TreeNodeTile extends StatefulWidget {
  const _TreeNodeTile({
    required this.node,
    required this.depth,
    required this.isExpanded,
    required this.isSelected,
    required this.multiple,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorPrimary,
    required this.colorFillSecondary,
    required this.marginSM,
    required this.onTap,
    this.onToggle,
  });

  final AntTreeSelectOption node;
  final int depth;
  final bool isExpanded;
  final bool isSelected;
  final bool multiple;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorPrimary;
  final Color colorFillSecondary;
  final double marginSM;
  final VoidCallback onTap;
  final VoidCallback? onToggle;

  @override
  State<_TreeNodeTile> createState() => _TreeNodeTileState();
}

class _TreeNodeTileState extends State<_TreeNodeTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.node.disabled;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : widget.isSelected
                  ? widget.colorPrimary.withValues(alpha: 0.06)
                  : _isHovered
                      ? widget.colorFillSecondary
                      : null,
          child: Row(
            children: [
              // 缩进
              SizedBox(width: widget.depth * 20.w),
              // 展开/收起箭头
              if (widget.node.isLeaf)
                SizedBox(width: 16.w)
              else
                GestureDetector(
                  onTap: widget.onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Icon(
                      widget.isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 14.sp,
                      color: widget.colorTextDisabled,
                    ),
                  ),
                ),
              // 多选 checkbox
              if (widget.multiple)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Icon(
                    widget.isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 14.sp,
                    color: widget.isSelected
                        ? widget.colorPrimary
                        : widget.colorTextDisabled,
                  ),
                ),
              // 文本
              Expanded(
                child: Text(
                  widget.node.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.fontSize.sp,
                    color: disabled
                        ? widget.colorTextDisabled
                        : widget.isSelected
                            ? widget.colorPrimary
                            : widget.colorText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}