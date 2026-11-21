/// AntMenu — antd React Menu 的 Flutter 实现
///
/// 对齐 antd v6：`vertical` / `inline` / `horizontal` 三种模式、
/// 亮/暗主题、分组/分割线/危险项/附加内容、受控/非受控选中与展开、
/// 多选、悬浮或点击展开子菜单、内嵌折叠（浮层子菜单）、
/// 水平溢出折叠、键盘导航。
///
/// ```dart
/// AntMenu(
///   items: [
///     AntMenuItem(key: '1', label: '菜单项一'),
///     AntMenuItem(key: 'sub1', label: '子菜单', children: [
///       AntMenuItem(key: '1-1', label: '子项 1'),
///     ]),
///   ],
/// )
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, LogicalKeyboardKey;
import 'package:material_ui/material_ui.dart';

import '../../basic/tooltip/ant_tooltip.dart';
import '../../basic/tooltip/ant_tooltip_types.dart';
import '../../engines/popup_engine.dart' show AntPopupPlacement;
import '../../engines/popup_overlay.dart';
import 'ant_menu_types.dart';

/// 水平溢出折叠子菜单的保留 key。
const String _kOverflowKey = '__ant_menu_overflow__';

// ============================================================
// AntMenu
// ============================================================

/// 导航菜单 — 为页面和功能提供导航的菜单列表。
class AntMenu extends StatefulWidget {
  const AntMenu({
    super.key,
    this.items = const [],
    this.mode = AntMenuMode.inline,
    this.theme = AntMenuTheme.light,
    this.selectedKeys,
    this.defaultSelectedKeys = const [],
    this.openKeys,
    this.defaultOpenKeys = const [],
    this.onClick,
    this.onItemClick,
    this.onSelect,
    this.onDeselect,
    this.onSelectedKeysChange,
    this.onOpenChange,
    this.selectable = true,
    this.multiple = false,
    this.triggerSubMenuAction = AntMenuTrigger.hover,
    this.subMenuOpenDelay = const Duration(milliseconds: 100),
    this.subMenuCloseDelay = const Duration(milliseconds: 100),
    this.inlineCollapsed = false,
    this.inlineIndent = 24,
    this.expandIcon,
    this.overflowedIndicator,
    this.disabled = false,
    this.tooltip = true,
  });

  /// 菜单项列表。
  final List<AntMenuItem> items;

  /// 菜单模式。默认 [AntMenuMode.inline]（antd 默认 vertical，此处保持兼容）。
  final AntMenuMode mode;

  /// 主题。
  final AntMenuTheme theme;

  /// 受控选中 key 列表。
  final List<String>? selectedKeys;

  /// 非受控默认选中 key 列表。
  final List<String> defaultSelectedKeys;

  /// 受控展开子菜单 key 列表。
  final List<String>? openKeys;

  /// 非受控默认展开子菜单 key 列表。
  final List<String> defaultOpenKeys;

  /// 点击菜单项回调（兼容旧 API，仅回传 key）。
  final ValueChanged<String>? onClick;

  /// 点击菜单项回调（回传完整菜单项）。
  final ValueChanged<AntMenuItem>? onItemClick;

  /// 选中回调（多选时每次加入选中集合都会触发）。
  final ValueChanged<AntMenuItem>? onSelect;

  /// 取消选中回调（仅 [multiple] 下生效）。
  final ValueChanged<AntMenuItem>? onDeselect;

  /// 选中集合变化回调（多选时回传完整集合）。
  final ValueChanged<List<String>>? onSelectedKeysChange;

  /// 子菜单展开/折叠回调。
  final ValueChanged<List<String>>? onOpenChange;

  /// 是否可选中（默认 true）。为 false 时点击仅触发 onClick。
  final bool selectable;

  /// 是否多选（需 [selectable] 为 true）。
  final bool multiple;

  /// 子菜单触发方式（默认悬浮；内嵌模式始终点击展开）。
  final AntMenuTrigger triggerSubMenuAction;

  /// 悬浮展开延迟。
  final Duration subMenuOpenDelay;

  /// 悬浮收起延迟。
  final Duration subMenuCloseDelay;

  /// 内嵌模式折叠（仅显示图标，子菜单以浮层展开）。
  final bool inlineCollapsed;

  /// 内嵌缩进（每级）。
  final double inlineIndent;

  /// 自定义展开箭头。
  final Widget? expandIcon;

  /// 水平模式溢出时的折叠图标（默认 `···`）。
  final Widget? overflowedIndicator;

  /// 是否禁用整个菜单。
  final bool disabled;

  /// 折叠态（[inlineCollapsed]）下是否用 Tooltip 展示标题。
  final bool tooltip;

  @override
  State<AntMenu> createState() => _AntMenuState();
}

class _AntMenuState extends State<AntMenu> {
  late Set<String> _selected;
  late Set<String> _open;

  /// 当前浮层子菜单链（父 → 子，按层级顺序）。
  final List<String> _popupChain = [];

  /// 浮层 OverlayEntry（key → entry）。
  final Map<String, OverlayEntry> _popupEntries = {};

  /// 子菜单标题的 GlobalKey（浮层锚点）。
  final Map<String, GlobalKey> _titleKeys = {};

  /// 当前渲染树内的 key → item / keyPath。
  final Map<String, AntMenuItem> _itemsByKey = {};
  final Map<String, List<String>> _keyPaths = {};

  final FocusNode _focusNode = FocusNode(debugLabel: 'AntMenu');

  Timer? _hoverOpenTimer;
  Timer? _hoverCloseTimer;

  String? _hoverKey;
  String? _activeKey;

  /// 水平溢出子菜单（每次 build 重建）。
  AntMenuItem? _overflowItem;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultSelectedKeys.toSet();
    _open = widget.defaultOpenKeys.toSet();
  }

  @override
  void didUpdateWidget(covariant AntMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode ||
        widget.inlineCollapsed != oldWidget.inlineCollapsed) {
      _closePopups(notify: false);
    }
  }

  @override
  void dispose() {
    _hoverOpenTimer?.cancel();
    _hoverCloseTimer?.cancel();
    _removeAllPopupEntries();
    _focusNode.dispose();
    super.dispose();
  }

  // ==========================================================
  // 状态
  // ==========================================================

  Set<String> get _effectiveSelected =>
      widget.selectedKeys?.toSet() ?? _selected;

  Set<String> get _effectiveOpen => widget.openKeys?.toSet() ?? _open;

  bool _isSelected(String key) => _effectiveSelected.contains(key);

  /// 子项中是否存在被选中项（用于让父级 submenu 标题变主色）。
  bool _containsSelected(AntMenuItem item) {
    for (final child in item.children) {
      if (_isSelected(child.key) || _containsSelected(child)) return true;
    }
    return false;
  }

  bool _isOpen(AntMenuItem item) => _effectiveOpen.contains(item.key);

  bool get _isLight => widget.theme == AntMenuTheme.light;

  Color get _bg => _isLight ? theme.colorBgContainer : const Color(0xFF001529);

  Color get _subMenuBg =>
      _isLight ? theme.colorFillAlter : const Color(0xFF000C17);

  Color get _popupBg => _isLight ? theme.colorBgElevated : const Color(0xFF001529);

  Color get _textColor => _isLight ? theme.colorText : Colors.white70;

  Color get _selectedTextColor =>
      _isLight ? theme.colorPrimary : Colors.white;

  Color get _selectedBg =>
      _isLight ? theme.controlItemBgActive : theme.colorPrimary;

  Color get _hoverBg => _isLight ? theme.colorBgTextHover : Colors.transparent;

  AntThemeData get theme => AntTheme.of(context);

  /// 是否处于浮层模式（vertical / horizontal / 折叠态 inline）。
  bool get _isPopupMode => widget.mode != AntMenuMode.inline;

  /// 内嵌折叠态（仅 inline + inlineCollapsed）。
  bool get _isCollapsed =>
      widget.mode == AntMenuMode.inline && widget.inlineCollapsed;

  void _setSelected(Set<String> next) {
    if (widget.selectedKeys == null) {
      setState(() => _selected = next);
    }
    widget.onSelectedKeysChange?.call(next.toList());
    _rebuildPopups();
  }

  void _selectItem(AntMenuItem item) {
    if (widget.disabled || item.disabled) return;
    _focusNode.requestFocus();
    _activeKey = item.key;
    final wasSelected = _effectiveSelected.contains(item.key);
    if (widget.selectable) {
      final next = {..._effectiveSelected};
      if (widget.multiple) {
        if (!next.remove(item.key)) {
          next.add(item.key);
        }
      } else {
        next
          ..clear()
          ..add(item.key);
      }
      _setSelected(next);
      if (widget.multiple && wasSelected) {
        widget.onDeselect?.call(item);
      } else {
        widget.onSelect?.call(item);
      }
    }
    widget.onClick?.call(item.key);
    widget.onItemClick?.call(item);
    if (!widget.multiple) _closePopups();
  }

  void _setOpen(Set<String> next) {
    final prev = _effectiveOpen.toList()..sort();
    if (widget.openKeys == null) {
      setState(() => _open = next);
    }
    final value = next.toList();
    if (!_listEquals(prev, value.toList()..sort())) {
      widget.onOpenChange?.call(value);
    }
    _rebuildPopups();
  }

  void _toggleSubmenu(AntMenuItem item) {
    if (widget.disabled || item.disabled) return;
    _focusNode.requestFocus();
    final isOpen = _isOpen(item);
    if (widget.mode == AntMenuMode.inline && !widget.inlineCollapsed) {
      final next = {..._effectiveOpen};
      if (isOpen) {
        next.remove(item.key);
      } else {
        next.add(item.key);
      }
      _setOpen(next);
      return;
    }
    if (isOpen) {
      final next = {..._effectiveOpen}..remove(item.key);
      _setOpen(next);
      _closePopupsFrom(item.key);
    } else {
      _setOpen({..._effectiveOpen, item.key});
      _openPopup(item);
    }
  }

  // ==========================================================
  // 悬浮
  // ==========================================================

  void _handleHoverEnter(AntMenuItem item) {
    if (widget.disabled || item.disabled) return;
    _hoverCloseTimer?.cancel();
    if (_hoverKey != item.key) {
      setState(() => _hoverKey = item.key);
    }
    if (!item.isSubMenu) return;
    if (widget.mode == AntMenuMode.inline && !widget.inlineCollapsed) return;
    if (widget.triggerSubMenuAction != AntMenuTrigger.hover) return;
    if (_isOpen(item)) return;
    _hoverOpenTimer?.cancel();
    _hoverOpenTimer = Timer(widget.subMenuOpenDelay, () {
      if (!mounted || !_isOpenable(item)) return;
      _setOpen({..._effectiveOpen, item.key});
      _openPopup(item);
    });
  }

  void _handleHoverExit(AntMenuItem item) {
    if (_hoverKey == item.key) {
      setState(() => _hoverKey = null);
    }
    if (!item.isSubMenu) return;
    if (widget.triggerSubMenuAction != AntMenuTrigger.hover) return;
    _hoverOpenTimer?.cancel();
    _scheduleClosePopups();
  }

  bool _isOpenable(AntMenuItem item) => item.isSubMenu && !item.disabled;

  void _scheduleClosePopups() {
    if (_popupChain.isEmpty) return;
    _hoverCloseTimer?.cancel();
    _hoverCloseTimer = Timer(widget.subMenuCloseDelay, () {
      if (mounted) _closePopups();
    });
  }

  // ==========================================================
  // 浮层
  // ==========================================================

  bool _isRootKey(String key) {
    final path = _keyPaths[key];
    return path == null || path.length <= 1;
  }

  void _openPopup(AntMenuItem item) {
    if (!mounted) return;
    final path = _keyPaths[item.key] ?? [item.key];
    // 父级链：根级子菜单只保留自身；嵌套保留父链。
    final parentChain = path.length > 1
        ? path.sublist(0, path.length - 1)
        : const <String>[];
    _popupChain
      ..clear()
      ..addAll([
        for (final key in parentChain)
          if (_itemsByKey[key]?.isSubMenu ?? false) key,
        item.key,
      ]);
    _syncPopupEntries();
  }

  void _closePopupsFrom(String key) {
    final index = _popupChain.indexOf(key);
    if (index < 0) return;
    _popupChain.removeRange(index, _popupChain.length);
    _syncPopupEntries();
  }

  void _closePopups({bool notify = true}) {
    _hoverOpenTimer?.cancel();
    _hoverCloseTimer?.cancel();
    if (_popupChain.isNotEmpty) {
      _popupChain.clear();
      _syncPopupEntries();
    }
    if (!notify) return;
    if (_isPopupMode) {
      final next = {..._effectiveOpen}
        ..removeWhere((key) => _itemsByKey[key]?.isSubMenu ?? false);
      if (next.length != _effectiveOpen.length) _setOpen(next);
    }
  }

  void _removeAllPopupEntries() {
    for (final entry in _popupEntries.values) {
      entry.remove();
    }
    _popupEntries.clear();
  }

  void _syncPopupEntries() {
    // 移除不在链上的 entry
    for (final key in _popupEntries.keys.toList()) {
      if (!_popupChain.contains(key)) {
        _popupEntries.remove(key)?.remove();
      }
    }
    // 为链上的每个 key 创建 entry（锚点尚未布局时下一帧重试）
    for (final key in _popupChain) {
      if (_popupEntries.containsKey(key)) {
        _popupEntries[key]!.markNeedsBuild();
        continue;
      }
      final item = _itemsByKey[key];
      final anchor = _titleKeys[key];
      if (item == null || anchor == null) continue;
      if (anchor.currentContext == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _popupChain.contains(key)) _syncPopupEntries();
        });
        continue;
      }
      final entry = OverlayEntry(builder: (_) => _buildPopupOverlay(item));
      Overlay.of(context, rootOverlay: true).insert(entry);
      _popupEntries[key] = entry;
    }
  }

  void _rebuildPopups() {
    for (final entry in _popupEntries.values) {
      entry.markNeedsBuild();
    }
  }

  Widget _buildPopupOverlay(AntMenuItem item) {
    final anchor = _titleKeys[item.key]!;
    final isHorizontalRoot =
        widget.mode == AntMenuMode.horizontal && _isRootKey(item.key);
    return AntPopupOverlay(
      targetKey: anchor,
      placement:
          isHorizontalRoot ? AntPopupPlacement.bottomLeft : AntPopupPlacement.rightTop,
      arrow: false,
      gap: isHorizontalRoot ? 4 : 8,
      onDismiss: _closePopups,
      onBubbleHoverEnter: _hoverCloseTimer?.cancel,
      onBubbleHoverExit: _scheduleClosePopups,
      child: _buildPopupPanel(item),
    );
  }

  Widget _buildPopupPanel(AntMenuItem parent) {
    final maxHeight = MediaQuery.sizeOf(context).height - 100;
    return Container(
      constraints: BoxConstraints(
        minWidth: 160,
        maxWidth: 320,
        maxHeight: maxHeight < 120 ? 120 : maxHeight,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _popupBg,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        boxShadow: theme.boxShadowSecondary,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildItemWidgets(parent.children, level: 0, inPopup: true),
        ),
      ),
    );
  }

  // ==========================================================
  // 构建
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    _indexItems(widget.items);
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final body = switch (widget.mode) {
      AntMenuMode.horizontal => _buildHorizontal(),
      AntMenuMode.vertical => _buildVerticalCollapsedRoot(inline: false),
      AntMenuMode.inline => _buildVerticalCollapsedRoot(inline: true),
    };

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: body,
    );
  }

  void _indexItems(List<AntMenuItem> items, [List<String> parent = const []]) {
    _itemsByKey.clear();
    _keyPaths.clear();
    _overflowItem = null;
    void walk(List<AntMenuItem> list, List<String> path) {
      for (final item in list) {
        if (item.isDivider) continue;
        _itemsByKey[item.key] = item;
        _keyPaths[item.key] = [...path, item.key];
        _titleKeys.putIfAbsent(item.key, GlobalKey.new);
        walk(item.children, [...path, item.key]);
      }
    }

    walk(items, parent);
  }

  // ---- 垂直 / 内嵌 ----

  Widget _buildVerticalCollapsedRoot({required bool inline}) {
    final collapsed = inline && widget.inlineCollapsed;
    return Container(
      color: _bg,
      child: Container(
        width: collapsed ? 80 : null,
        constraints: collapsed
            ? const BoxConstraints(minWidth: 80, maxWidth: 80)
            : null,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: theme.colorSplit)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildItemWidgets(widget.items, level: 0, inPopup: false),
        ),
      ),
    );
  }

  // ---- 水平 ----

  Widget _buildHorizontal() {
    return Container(
      color: _bg,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colorSplit)),
        ),
        height: 46,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final entries = widget.items
                .where((item) => !item.isGroup && !item.isDivider)
                .toList();
            final widths = entries.map(_horizontalItemWidth).toList();
            final maxWidth = constraints.maxWidth;
            var visible = entries.length;
            final total = widths.fold<double>(0, (a, b) => a + b);
            if (total > maxWidth && entries.isNotEmpty) {
              var acc = 0.0;
              visible = 0;
              for (var i = 0; i < entries.length; i++) {
                if (acc + widths[i] + 40 > maxWidth) break;
                acc += widths[i];
                visible = i + 1;
              }
            }
            final hidden = entries.skip(visible).toList();
            if (hidden.isNotEmpty) {
              _overflowItem = AntMenuItem(
                key: _kOverflowKey,
                label: '更多',
                children: hidden,
                type: AntMenuItemType.submenu,
              );
              _itemsByKey[_kOverflowKey] = _overflowItem!;
              _titleKeys.putIfAbsent(_kOverflowKey, GlobalKey.new);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in entries.take(visible))
                  _buildItemWidget(item, level: 0, inPopup: false, horizontal: true),
                if (hidden.isNotEmpty) _buildOverflowIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }

  double _horizontalItemWidth(AntMenuItem item) {
    var width = 32.0;
    if (item.icon != null) width += 14 + 10;
    final label = item.label;
    if (label != null && label.isNotEmpty) {
      width += _measureText(label, 14);
    } else if (item.labelWidget != null) {
      width += 60;
    }
    if (item.extra != null) width += 32;
    if (item.isSubMenu) width += 10;
    return width;
  }

  double _measureText(String text, double fontSize) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }

  Widget _buildOverflowIndicator() {
    final item = _overflowItem!;
    final open = _popupChain.contains(_kOverflowKey);
    final hovered = _hoverKey == _kOverflowKey;
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(item),
      onExit: (_) => _handleHoverExit(item),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _focusNode.requestFocus();
          if (open) {
            _closePopups();
          } else {
            _openPopup(item);
          }
        },
        child: Container(
          key: _titleKeys[_kOverflowKey],
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: hovered || open ? theme.colorBgTextHover : null,
          child: Center(
            child: widget.overflowedIndicator ??
                Icon(
                  Icons.more_horiz,
                  size: 16,
                  color: _textColor,
                ),
          ),
        ),
      ),
    );
  }

  // ---- 列表 ----

  List<Widget> _buildItemWidgets(
    List<AntMenuItem> items, {
    required int level,
    required bool inPopup,
    bool horizontal = false,
    double extraIndent = 0,
  }) {
    return [
      for (final item in items)
        _buildItemWidget(
          item,
          level: level,
          inPopup: inPopup,
          horizontal: horizontal,
          extraIndent: extraIndent,
        ),
    ];
  }

  Widget _buildItemWidget(
    AntMenuItem item, {
    required int level,
    required bool inPopup,
    bool horizontal = false,
    double extraIndent = 0,
  }) {
    if (item.isDivider) return _buildDivider(item);
    if (item.isGroup) return _buildGroup(item, level, inPopup, extraIndent);
    if (item.isSubMenu) {
      return _buildSubmenu(item, level, inPopup, horizontal, extraIndent);
    }
    return _buildLeaf(item, level, inPopup, horizontal, extraIndent);
  }

  /// 菜单项左内边距：inline 按层级缩进（根级 = inlineIndent），其余模式固定 16。
  double _leftPadding(int level, {required bool inPopup, double extraIndent = 0}) {
    if (inPopup) return 16 + extraIndent;
    if (widget.mode == AntMenuMode.inline) {
      return (level + 1) * widget.inlineIndent + extraIndent;
    }
    return 16 + extraIndent;
  }

  Widget _buildDivider(AntMenuItem item) {
    if (item.dashed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CustomPaint(
          painter: _DashedLinePainter(color: theme.colorSplit),
          child: const SizedBox(height: 1, width: double.infinity),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorSplit,
      ),
    );
  }

  Widget _buildGroup(
    AntMenuItem item,
    int level,
    bool inPopup,
    double extraIndent,
  ) {
    final collapsed = _isCollapsed;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!collapsed)
          Padding(
            padding: EdgeInsets.only(
              left: 16 + level * widget.inlineIndent,
              right: 16,
              top: 8,
            ),
            child: Text(
              item.label ?? '',
              style: TextStyle(fontSize: 14, color: theme.colorTextDescription),
            ),
          ),
        ..._buildItemWidgets(
          item.children,
          level: level,
          inPopup: inPopup,
          extraIndent: extraIndent + 12,
        ),
      ],
    );
  }

  Widget _buildLeaf(
    AntMenuItem item,
    int level,
    bool inPopup,
    bool horizontal,
    double extraIndent,
  ) {
    final selected = _isSelected(item.key);
    final hovered = _hoverKey == item.key;
    final active = _activeKey == item.key;
    final disabled = widget.disabled || item.disabled;
    final color = disabled
        ? theme.colorTextDisabled
        : item.danger
            ? theme.colorError
            : selected
                ? _selectedTextColor
                : _textColor;

    final bg = horizontal
        ? (selected && !_isLight ? theme.colorPrimary : Colors.transparent)
        : selected
            ? _selectedBg
            : (hovered || active ? _hoverBg : Colors.transparent);

    final collapsed = _isCollapsed;

    Widget content;
    if (collapsed) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.icon != null)
            IconTheme(
              data: IconThemeData(size: 16, color: color),
              child: item.icon!,
            )
          else if (item.label != null)
            Text(
              item.label!.characters.first,
              style: TextStyle(fontSize: 14, color: color),
            ),
        ],
      );
    } else {
      content = Row(
        mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (item.icon != null) ...[
            IconTheme(
              data: IconThemeData(size: 14, color: color),
              child: item.icon!,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: item.labelWidget ??
                Text(
                  item.label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: color),
                ),
          ),
          if (item.extra != null) ...[
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(fontSize: 14, color: theme.colorTextDescription),
              child: item.extra!,
            ),
          ],
        ],
      );
    }

    Widget tile = Container(
      key: ValueKey<String>('ant_menu_item_${item.key}'),
      height: horizontal ? 46 : 40,
      margin: horizontal
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: horizontal
          ? const EdgeInsets.symmetric(horizontal: 16)
          : collapsed
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  left: _leftPadding(level, inPopup: inPopup, extraIndent: extraIndent),
                  right: 16,
                ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(
          horizontal ? 0 : (inPopup ? 4 : 8),
        ),
        border: horizontal
            ? Border(
                bottom: BorderSide(
                  color: selected ? theme.colorPrimary : Colors.transparent,
                  width: 2,
                ),
              )
            : null,
      ),
      child: content,
    );

    if (collapsed && (item.title ?? item.label) != null && widget.tooltip) {
      tile = AntTooltip(
        tooltip: Text(
          item.title ?? item.label!,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        placement: AntTooltipPlacement.right,
        child: tile,
      );
    }

    return _InteractiveMenuItem(
      onTap: disabled ? null : () => _selectItem(item),
      onHoverEnter: () => _handleHoverEnter(item),
      onHoverExit: () => _handleHoverExit(item),
      child: tile,
    );
  }

  Widget _buildSubmenu(
    AntMenuItem item,
    int level,
    bool inPopup,
    bool horizontal,
    double extraIndent,
  ) {
    final collapsed = _isCollapsed;
    final inlineMode = widget.mode == AntMenuMode.inline &&
        !widget.inlineCollapsed &&
        !inPopup;
    final open = _isOpen(item);
    final selected = _isSelected(item.key) || _containsSelected(item);
    final hovered = _hoverKey == item.key;
    final active = _activeKey == item.key;
    final disabled = widget.disabled || item.disabled;
    final color = disabled
        ? theme.colorTextDisabled
        : item.danger
            ? theme.colorError
            : selected
                ? _selectedTextColor
                : _textColor;

    final bg = horizontal
        ? (selected && !_isLight ? theme.colorPrimary : Colors.transparent)
        : selected
            ? _selectedBg
            : (hovered || active ? _hoverBg : Colors.transparent);

    Widget arrow = widget.expandIcon ??
        AnimatedRotation(
          turns: open ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_right,
            size: 10,
            color: disabled
                ? theme.colorTextDisabled
                : selected
                    ? _selectedTextColor
                    : theme.colorTextDescription,
          ),
        );

    Widget content;
    if (collapsed) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.icon != null)
            IconTheme(
              data: IconThemeData(size: 16, color: color),
              child: item.icon!,
            )
          else if (item.label != null)
            Text(
              item.label!.characters.first,
              style: TextStyle(fontSize: 14, color: color),
            ),
        ],
      );
    } else {
      content = Row(
        mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (item.icon != null) ...[
            IconTheme(
              data: IconThemeData(size: 14, color: color),
              child: item.icon!,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: item.labelWidget ??
                Text(
                  item.label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: color),
                ),
          ),
          if (item.extra != null) ...[
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(fontSize: 14, color: theme.colorTextDescription),
              child: item.extra!,
            ),
          ],
          if (!horizontal) ...[
            const SizedBox(width: 8),
            arrow,
          ],
        ],
      );
    }

    Widget title = Container(
      key: _titleKeys[item.key],
      height: horizontal ? 46 : 40,
      margin: horizontal
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(
          horizontal ? 0 : (inPopup ? 4 : 8),
        ),
        border: horizontal
            ? Border(
                bottom: BorderSide(
                  color: (selected || hovered || open)
                      ? theme.colorPrimary
                      : Colors.transparent,
                  width: 2,
                ),
              )
            : null,
      ),
      padding: horizontal
          ? const EdgeInsets.symmetric(horizontal: 16)
          : collapsed
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  left: _leftPadding(level, inPopup: inPopup, extraIndent: extraIndent),
                  right: 34,
                ),
      child: content,
    );

    if (collapsed && (item.title ?? item.label) != null && widget.tooltip) {
      title = AntTooltip(
        tooltip: Text(
          item.title ?? item.label!,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        placement: AntTooltipPlacement.right,
        child: title,
      );
    }

    final titleWidget = _InteractiveMenuItem(
      onTap: disabled ? null : () => _toggleSubmenu(item),
      onHoverEnter: () => _handleHoverEnter(item),
      onHoverExit: () => _handleHoverExit(item),
      child: title,
    );

    if (!inlineMode) return titleWidget;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        titleWidget,
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: open
                ? Container(
                    color: _subMenuBg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildItemWidgets(
                        item.children,
                        level: level + 1,
                        inPopup: false,
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 键盘
  // ==========================================================

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final navigable = _navigableKeys();
    if (navigable.isEmpty) return KeyEventResult.ignored;
    final index = _activeKey == null ? -1 : navigable.indexOf(_activeKey!);

    if (key == LogicalKeyboardKey.arrowDown) {
      final next = index < 0 ? 0 : (index + 1) % navigable.length;
      setState(() => _activeKey = navigable[next]);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      final next =
          index < 0 ? navigable.length - 1 : (index - 1 + navigable.length) % navigable.length;
      setState(() => _activeKey = navigable[next]);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.numpadEnter) {
      final active = _activeKey == null ? null : _itemsByKey[_activeKey!];
      if (active == null) return KeyEventResult.ignored;
      if (active.isSubMenu) {
        _toggleSubmenu(active);
      } else {
        _selectItem(active);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      setState(() => _activeKey = navigable.first);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      setState(() => _activeKey = navigable.last);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      final active = _activeKey == null ? null : _itemsByKey[_activeKey!];
      if (active == null || !active.isSubMenu) return KeyEventResult.ignored;
      if (!_isOpen(active)) _toggleSubmenu(active);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      if (_popupChain.isNotEmpty) {
        _closePopups();
        return KeyEventResult.handled;
      }
      final openInline = _effectiveOpen.where((k) {
        final item = _itemsByKey[k];
        return item != null && !_isPopupMode && _isOpen(item);
      }).toList();
      if (openInline.isNotEmpty) {
        _setOpen({..._effectiveOpen}..remove(openInline.last));
        setState(() => _activeKey = openInline.last);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_popupChain.isNotEmpty) {
        _closePopups();
        return KeyEventResult.handled;
      }
      final openInline = _effectiveOpen.where((k) {
        final item = _itemsByKey[k];
        return item != null && !_isPopupMode;
      }).toList();
      if (openInline.isNotEmpty) {
        _setOpen({..._effectiveOpen}..remove(openInline.last));
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  List<String> _navigableKeys() {
    final collapsed = _isCollapsed;
    final keys = <String>[];
    void walk(List<AntMenuItem> items) {
      for (final item in items) {
        if (item.isDivider || item.isGroup) {
          if (item.isGroup) walk(item.children);
          continue;
        }
        if (widget.disabled || item.disabled) continue;
        keys.add(item.key);
        if (item.isSubMenu &&
            widget.mode == AntMenuMode.inline &&
            !collapsed &&
            _isOpen(item)) {
          walk(item.children);
        }
      }
    }

    walk(widget.items);
    return keys;
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ============================================================
// 内部：可交互菜单项（悬浮 / 点击）
// ============================================================

class _InteractiveMenuItem extends StatefulWidget {
  const _InteractiveMenuItem({
    required this.child,
    this.onTap,
    this.onHoverEnter,
    this.onHoverExit,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onHoverEnter;
  final VoidCallback? onHoverExit;

  @override
  State<_InteractiveMenuItem> createState() => _InteractiveMenuItemState();
}

class _InteractiveMenuItemState extends State<_InteractiveMenuItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverEnter?.call(),
      onExit: (_) => widget.onHoverExit?.call(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}

/// 虚线分割线（antd `MenuDivider[type=dashed]`）。
class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 4.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0.0, size.width), size.height / 2),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
