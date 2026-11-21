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
/// 下拉弹层承载于 antd_flutter_ui 统一弹层基座 [AntPopupOverlay]：
/// 方向决策（下方放不下自动翻转上方）、滑动夹回、镂空遮挡（触发元素
/// 不误关）、fade+scale 出现动画均由基座统一承担；面板内容渲染不变。
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

import 'dart:math' as math;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_tree/src/tree_select/ant_tree_select_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'package:antd_tree/src/tree_select/ant_tree_select_types.dart';

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
    this.height,
    this.width,
    this.dropdownHeight,
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

  /// 触发器自定义高度（逻辑像素），设置后覆盖 [size] 对应高度。
  final double? height;

  /// 触发器自定义宽度（逻辑像素）。默认 null：宽度随内容自适应，
  /// 父级为紧约束（如 Expanded / 定宽容器）时随父级。
  final double? width;

  /// 下拉面板最大高度（逻辑像素）。默认 null：取 min(256, 视口高度一半)，
  /// 超出后面板内部滚动（SingleChildScrollView）。
  final double? dropdownHeight;

  @override
  State<AntTreeSelect> createState() => _AntTreeSelectState();
}

class _AntTreeSelectState extends State<AntTreeSelect>
    with PopupContentRefresher<AntTreeSelect> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用）。
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前主题（组件 context 下实时捕获，overlay builder 经字段重读；
  /// AntTheme 在页面内时 overlay 条目的 context 不可达该继承链）。
  AntThemeData _themeData = AntThemeData.light();

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

  @override
  void didUpdateWidget(covariant AntTreeSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    // treeDefaultExpandAll + treeData 变化：展开键随新数据重算
    if (widget.treeDefaultExpandAll && widget.treeData != oldWidget.treeData) {
      _expandedKeys = _collectAllParentKeys(widget.treeData);
    }
    // 弹层打开时数据/值更新：原地重建面板（受控 value 选中态、treeData
    // 新节点实时反映；不重建会显示陈旧内容）
    if (_open &&
        (widget.treeData != oldWidget.treeData ||
            widget.value != oldWidget.value ||
            widget.treeDefaultExpandAll != oldWidget.treeDefaultExpandAll ||
            widget.multiple != oldWidget.multiple)) {
      _updateOverlay();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 主题变化（含暗色切换）：刷新字段；弹层开着时原地重建面板跟随新 token。
    final t = AntTheme.of(context);
    if (t != _themeData) {
      _themeData = t;
      if (_open) _updateOverlay();
    }
  }

  void _showOverlay() {
    if (_open || widget.disabled) return;
    _themeData = AntTheme.of(context);
    _insertOverlay();
    if (mounted) setState(() => _open = true);
  }

  /// 构造弹层 OverlayEntry：承载层换为统一弹层基座 [AntPopupOverlay]
  /// （方向决策/边界翻转/滑动夹回/镂空遮挡/fade+scale 动画），面板内容不变。
  void _insertOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _TreeSelectOverlay(
        triggerKey: _triggerKey,
        themeData: _themeData,
        treeData: widget.treeData,
        expandedKeys: _expandedKeys,
        selectedValue: widget.multiple ? null : _currentSingleValue,
        selectedMultiValues: widget.multiple ? _currentMultiValue : null,
        multiple: widget.multiple,
        onSelect: _onSelect,
        onToggleExpand: _onToggleExpand,
        onDismiss: _removeOverlay,
        dropdownHeight: widget.dropdownHeight,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    if (_open && mounted) setState(() => _open = false);
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
      // 原地重建（基座 PopupContentRefresher 沉淀的统一更新方式）：
      // 不移除重挂——避免 fade+scale 动画重放（闪烁）、内部滚动位置丢失、
      // 基座首帧估算尺寸导致的跳位；Element 复用后勾选/展开状态平滑过渡。
      refreshPopupContent();
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

    return KeyedSubtree(
      key: _triggerKey,
      child: GestureDetector(
        onTap: widget.disabled ? null : (_open ? _removeOverlay : _showOverlay),
        child: Container(
          height: (widget.height ?? _height).h,
          width: widget.width?.w,
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
          // 宽度自适应内容（对齐 antd Select 触发器 inline-block 语义）：
          // 不再被宽松约束撑满整行，由占位/已选文字决定宽度；
          // 长文字仍走省略号，父级给紧约束（如 Row 内 Expanded）时依旧随父。
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
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
                    child: Icon(AntIcons.closeCircleFilled, size: 14.sp, color: t.colorTextQuaternary),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    _open ? AntIcons.upOutlined : AntIcons.downOutlined,
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
    required this.triggerKey,
    required this.themeData,
    required this.treeData,
    required this.expandedKeys,
    required this.selectedValue,
    required this.selectedMultiValues,
    required this.multiple,
    required this.onSelect,
    required this.onToggleExpand,
    required this.onDismiss,
    required this.dropdownHeight,
  });

  /// 触发元素 GlobalKey（弹层基座定位）。
  final GlobalKey triggerKey;
  final AntThemeData themeData;
  final List<AntTreeSelectOption> treeData;
  final Set<String> expandedKeys;
  final String? selectedValue;
  final List<String>? selectedMultiValues;
  final bool multiple;
  final ValueChanged<AntTreeSelectOption> onSelect;
  final ValueChanged<String> onToggleExpand;
  final VoidCallback onDismiss;

  /// 面板最大高度配置（透传自 AntTreeSelect.dropdownHeight）。
  final double? dropdownHeight;

  @override
  Widget build(BuildContext context) {
    // 主题经组件侧捕获（themeData 字段），markNeedsBuild 原地重建时重读最新值；
    // 不在 overlay context 里读 AntTheme.of——AntTheme 在页面内时不可达（回退 light）。
    final t = themeData;

    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转到上方
    // （方向决策/滑动夹回/镂空遮挡由基座承担）；无箭头（antd Select 语义）。
    return AntPopupOverlay(
      targetKey: triggerKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(context, t),
    );
  }

  /// 下拉面板最大高度：显式配置优先；否则 256 与视口可用高度的一半取小，
  /// 避免小屏超屏；面板内 SingleChildScrollView 负责超出后的内部滚动。
  double _panelMaxHeight(BuildContext context) {
    if (dropdownHeight != null) return dropdownHeight!.h;
    final screenH = MediaQuery.sizeOf(context).height;
    return math.min(256.h, screenH / 2);
  }

  /// 下拉面板（内容渲染逻辑不变；宽度对齐触发元素，不小于 160，
  /// 基座 Stack 为宽松宽度约束，需定宽以保证面板内 Expanded 正常布局）。
  Widget _buildPanel(BuildContext context, AntThemeData t) {
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth =
        (triggerBox != null && triggerBox.hasSize) ? triggerBox.size.width : 0.0;
    final panelWidth = triggerWidth > 160.w ? triggerWidth : 160.w;
    return Container(
      key: const Key('ant_tree_select_panel'),
      width: panelWidth,
      constraints: BoxConstraints(
        maxHeight: _panelMaxHeight(context),
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
                          ? AntIcons.downOutlined
                          : AntIcons.rightOutlined,
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
                        ? AntIcons.checkSquareFilled
                        : AntIcons.borderOutlined,
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