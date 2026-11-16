/// AntMenu — antd React Menu 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 菜单项列表
/// - [mode] — inline / vertical / horizontal
/// - [theme] — light / dark
/// - [selectedKeys] / [defaultSelectedKeys] — 受控/非受控选中
/// - [openKeys] / [defaultOpenKeys] — 受控/非受控子菜单展开
/// - [onClick] — 点击菜单项回调
/// - [onOpenChange] — 子菜单展开/折叠回调
/// - [inlineCollapsed] — 内嵌模式折叠
/// - [inlineIndent] — 内嵌缩进
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import 'ant_menu_types.dart';

// ============================================================
// AntMenu
// ============================================================

/// 导航菜单 — 为页面和功能提供导航的菜单列表。
///
/// 对齐 antd React Menu 组件，支持内嵌/垂直/水平三种模式、
/// 亮/暗主题、受控/非受控选中与展开、分组与分割线。
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
    this.onOpenChange,
    this.inlineCollapsed = false,
    this.inlineIndent = 24,
  });

  /// 菜单项列表。
  final List<AntMenuItem> items;

  /// 菜单模式。
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

  /// 点击菜单项回调。
  final ValueChanged<String>? onClick;

  /// 子菜单展开/折叠回调。
  final ValueChanged<List<String>>? onOpenChange;

  /// 内嵌模式折叠（仅显示图标）。
  final bool inlineCollapsed;

  /// 内嵌缩进。
  final double inlineIndent;

  @override
  State<AntMenu> createState() => _AntMenuState();
}

class _AntMenuState extends State<AntMenu> {
  late List<String> _internalSelected;
  late List<String> _internalOpen;
  String? _horizontalOpenKey;

  @override
  void initState() {
    super.initState();
    _internalSelected = List.from(widget.defaultSelectedKeys);
    _internalOpen = List.from(widget.defaultOpenKeys);
  }

  List<String> get _currentSelected =>
      widget.selectedKeys ?? _internalSelected;
  List<String> get _currentOpen => widget.openKeys ?? _internalOpen;

  void _handleItemClick(AntMenuItem item) {
    if (item.disabled || item.children.isNotEmpty) return;
    if (widget.mode == AntMenuMode.horizontal) {
      setState(() => _horizontalOpenKey = null);
    }
    if (widget.selectedKeys == null) {
      setState(() => _internalSelected = [item.key]);
    }
    widget.onClick?.call(item.key);
  }

  void _toggleSubMenu(String key) {
    final isOpen = _currentOpen.contains(key);
    final newOpen = isOpen
        ? _currentOpen.where((k) => k != key).toList()
        : [..._currentOpen, key];
    if (widget.openKeys == null) {
      setState(() => _internalOpen = newOpen);
    }
    widget.onOpenChange?.call(newOpen);
  }

  void _handleHorizontalSubClick(String key) {
    setState(() {
      _horizontalOpenKey = _horizontalOpenKey == key ? null : key;
    });
  }

  bool get _isDark => widget.theme == AntMenuTheme.dark;

  Color _bgColor(AntThemeData theme) =>
      _isDark ? const Color(0xFF001529) : theme.colorBgContainer;

  Color _textColor(AntThemeData theme, {bool selected = false}) {
    if (selected) {
      return _isDark ? Colors.white : theme.colorPrimary;
    }
    return _isDark ? Colors.white.withOpacity(0.65) : theme.colorText;
  }

  Color _selectedBgColor(AntThemeData theme) =>
      _isDark ? theme.colorPrimary : theme.colorPrimary.withOpacity(0.06);

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final theme = AntTheme.of(context);

    if (widget.mode == AntMenuMode.horizontal) {
      return _buildHorizontal(context, theme);
    }
    return _buildInline(context, theme);
  }

  // ------------------------------------------------------------
  // 内嵌/垂直模式
  // ------------------------------------------------------------

  Widget _buildInline(BuildContext context, AntThemeData theme) {
    return Container(
      color: _bgColor(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildInlineItems(context, theme, widget.items, 0),
      ),
    );
  }

  List<Widget> _buildInlineItems(
    BuildContext context,
    AntThemeData theme,
    List<AntMenuItem> items,
    int level,
  ) {
    final children = <Widget>[];
    for (final item in items) {
      if (item.type == AntMenuItemType.divider) {
        children.add(Divider(
          height: 1,
          color: _isDark ? Colors.white.withOpacity(0.12) : theme.colorSplit,
        ));
        continue;
      }
      if (item.type == AntMenuItemType.group) {
        children.add(_buildGroupTitle(context, theme, item, level));
        children.addAll(
          _buildInlineItems(context, theme, item.children, level + 1),
        );
        continue;
      }
      children.add(_buildInlineItem(context, theme, item, level));
    }
    return children;
  }

  Widget _buildGroupTitle(
    BuildContext context,
    AntThemeData theme,
    AntMenuItem item,
    int level,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.inlineIndent * level + 16,
        top: 12,
        bottom: 8,
      ),
      child: Text(
        item.label ?? item.key,
        style: TextStyle(
          fontSize: theme.fontSizeSM,
          color: _isDark
              ? Colors.white.withOpacity(0.45)
              : theme.colorTextTertiary,
        ),
      ),
    );
  }

  Widget _buildInlineItem(
    BuildContext context,
    AntThemeData theme,
    AntMenuItem item,
    int level,
  ) {
    final isSelected = _currentSelected.contains(item.key);
    final isSubMenu = item.children.isNotEmpty;
    final isOpen = _currentOpen.contains(item.key);
    final indent = widget.inlineCollapsed ? 0 : widget.inlineIndent * level;

    final labelWidgets = <Widget>[];
    if (item.icon != null) {
      labelWidgets.add(item.icon!);
      labelWidgets.add(const SizedBox(width: 10));
    }
    if (!widget.inlineCollapsed || level > 0) {
      labelWidgets.add(
        Expanded(
          child: item.labelWidget ??
              Text(
                item.label ?? item.key,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: theme.fontSize,
                  color: item.disabled
                      ? (_isDark
                          ? Colors.white.withOpacity(0.25)
                          : theme.colorTextDisabled)
                      : item.danger
                          ? theme.colorError
                          : _textColor(theme, selected: isSelected),
                ),
              ),
        ),
      );
    }
    if (isSubMenu && !widget.inlineCollapsed) {
      labelWidgets.add(
        AnimatedRotation(
          turns: isOpen ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_right,
            size: 14,
            color: _textColor(theme, selected: isSelected),
          ),
        ),
      );
    }

    final itemWidget = GestureDetector(
      onTap: () {
        if (isSubMenu) {
          _toggleSubMenu(item.key);
        } else {
          _handleItemClick(item);
        }
      },
      child: MouseRegion(
        cursor: item.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Container(
          height: 40,
          padding: EdgeInsets.only(
            left: indent + 16,
            right: 16,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? _selectedBgColor(theme) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(children: labelWidgets),
        ),
      ),
    );

    if (!isSubMenu || widget.inlineCollapsed) {
      return itemWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        itemWidget,
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isOpen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildInlineItems(
                    context,
                    theme,
                    item.children,
                    level + 1,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // 水平模式
  // ------------------------------------------------------------

  Widget _buildHorizontal(BuildContext context, AntThemeData theme) {
    final topItems = <Widget>[];
    for (final item in widget.items) {
      if (item.type == AntMenuItemType.divider) {
        topItems.add(VerticalDivider(
          width: 1,
          color: _isDark ? Colors.white.withOpacity(0.12) : theme.colorSplit,
        ));
        continue;
      }
      if (item.type == AntMenuItemType.group) continue;
      topItems.add(_buildHorizontalItem(context, theme, item));
    }

    return Container(
      color: _bgColor(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(children: topItems),
            ),
          ),
          if (_horizontalOpenKey != null)
            _buildHorizontalDropdown(context, theme),
        ],
      ),
    );
  }

  Widget _buildHorizontalItem(
    BuildContext context,
    AntThemeData theme,
    AntMenuItem item,
  ) {
    final isSelected = _currentSelected.contains(item.key);
    final isSubMenu = item.children.isNotEmpty;
    final isOpen = _horizontalOpenKey == item.key;

    final labelWidgets = <Widget>[];
    if (item.icon != null) {
      labelWidgets.add(item.icon!);
      labelWidgets.add(const SizedBox(width: 8));
    }
    labelWidgets.add(
      item.labelWidget ??
          Text(
            item.label ?? item.key,
            style: TextStyle(
              fontSize: theme.fontSize,
              color: item.disabled
                  ? theme.colorTextDisabled
                  : item.danger
                      ? theme.colorError
                      : _textColor(theme, selected: isSelected),
            ),
          ),
    );
    if (isSubMenu) {
      labelWidgets.add(const SizedBox(width: 4));
      labelWidgets.add(
        Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 12,
          color: _textColor(theme, selected: isSelected),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (item.disabled) return;
        if (isSubMenu) {
          _handleHorizontalSubClick(item.key);
        } else {
          setState(() => _horizontalOpenKey = null);
          _handleItemClick(item);
        }
      },
      child: MouseRegion(
        cursor: item.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? theme.colorPrimary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: labelWidgets,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalDropdown(
    BuildContext context,
    AntThemeData theme,
  ) {
    final parent = widget.items
        .where((e) => e.key == _horizontalOpenKey)
        .firstOrNull;
    if (parent == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: _bgColor(theme),
        border: Border(
          top: BorderSide(color: _isDark ? Colors.white.withOpacity(0.12) : theme.colorSplit),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildInlineItems(context, theme, parent.children, 0),
      ),
    );
  }
}