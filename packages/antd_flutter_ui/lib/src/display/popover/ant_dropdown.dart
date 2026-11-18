/// AntDropdown — antd React Dropdown 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [child] — 触发元素
/// - [items] — 下拉菜单项列表
/// - [trigger] — hover / click
/// - [placement] — bottomLeft / bottomRight / topLeft / topRight
/// - [open] / [onOpenChange] — 受控显示
/// - [onClick] — 点击菜单项回调
/// - [arrow] — 是否显示箭头
/// - [disabled] — 是否禁用
library;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_dropdown_types.dart';

// ============================================================
// AntDropdown
// ============================================================

/// 下拉菜单 — 页面上的菜单导航。
///
/// 对齐 antd React Dropdown 组件，支持悬停/点击触发、
/// 四个方向弹出位置、受控显示、分割线与危险项。
///
/// ```dart
/// AntDropdown(
///   items: [
///     AntDropdownItem(key: '1', label: '菜单项一'),
///     AntDropdownItem(key: '2', label: '菜单项二'),
///   ],
///   child: AntButton(child: Text('下拉菜单')),
/// )
/// ```
class AntDropdown extends StatefulWidget {
  const AntDropdown({
    super.key,
    required this.child,
    this.items = const [],
    this.trigger = AntDropdownTrigger.hover,
    this.placement = AntDropdownPlacement.bottomLeft,
    this.open,
    this.onOpenChange,
    this.onClick,
    this.arrow = false,
    this.disabled = false,
  });

  /// 触发元素。
  final Widget child;

  /// 下拉菜单项列表。
  final List<AntDropdownItem> items;

  /// 触发方式。
  final AntDropdownTrigger trigger;

  /// 弹出位置。
  final AntDropdownPlacement placement;

  /// 受控显示状态。
  final bool? open;

  /// 显示状态变化回调。
  final ValueChanged<bool>? onOpenChange;

  /// 点击菜单项回调。
  final ValueChanged<String>? onClick;

  /// 是否显示箭头。
  final bool arrow;

  /// 是否禁用。
  final bool disabled;

  @override
  State<AntDropdown> createState() => _AntDropdownState();
}

class _AntDropdownState extends State<AntDropdown> with PopupOpenScheduler {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;

  bool get _currentOpen => widget.open ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    if (widget.open == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != null && oldWidget.open != widget.open) {
      // 受控切换可能发生在父级 build 阶段，show/hide 延迟到帧末
      schedulePopupOpen(
        open: widget.open!,
        show: _showOverlay,
        hide: _hideOverlay,
      );
    }
    if (widget.disabled && oldWidget.disabled != widget.disabled) {
      _hideOverlay();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    widget.onOpenChange?.call(value);
    if (widget.open == null) {
      _internalOpen = value;
      if (value) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    if (!mounted || widget.items.isEmpty) return;

    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DropdownOverlay(
        childKey: _childKey,
        items: widget.items,
        placement: widget.placement,
        arrow: widget.arrow,
        themeData: theme,
        onItemClick: (key) {
          widget.onClick?.call(key);
          _setOpen(false);
        },
        onDismiss: () => _setOpen(false),
      ),
    );
    overlay.insert(_overlayEntry!);
    if (mounted) setState(() {});
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  void _handleTap() {
    if (widget.disabled) return;
    _setOpen(!_currentOpen);
  }

  void _handleHoverEnter() {
    if (widget.disabled || widget.trigger != AntDropdownTrigger.hover) return;
    if (!_currentOpen) _setOpen(true);
  }

  void _handleHoverExit() {
    if (widget.disabled || widget.trigger != AntDropdownTrigger.hover) return;
    if (_currentOpen) _setOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    return AntPopupTriggerRegion(
      onTap: _handleTap,
      tapEnabled: widget.trigger == AntDropdownTrigger.click,
      hoverEnabled: widget.trigger == AntDropdownTrigger.hover,
      onHoverEnter: _handleHoverEnter,
      onHoverExit: _handleHoverExit,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// _DropdownOverlay — 下拉浮层（基于统一弹层底座 AntPopupOverlay）
// ============================================================

/// 下拉菜单箭头标记 key。
const Key kAntDropdownArrowKey = ValueKey<String>('AntDropdownArrow');

class _DropdownOverlay extends StatelessWidget {
  const _DropdownOverlay({
    required this.childKey,
    required this.items,
    required this.placement,
    required this.arrow,
    required this.themeData,
    required this.onItemClick,
    required this.onDismiss,
  });

  final GlobalKey childKey;
  final List<AntDropdownItem> items;
  final AntDropdownPlacement placement;
  final bool arrow;
  final AntThemeData themeData;
  final ValueChanged<String> onItemClick;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = themeData;

    return AntPopupOverlay(
      targetKey: childKey,
      placement: AntPopupPlacement.values.byName(placement.name),
      arrow: arrow,
      arrowColor: theme.colorBgContainer,
      arrowKey: arrow ? kAntDropdownArrowKey : null,
      gap: 0,
      onDismiss: onDismiss,
      child: _buildMenuContainer(theme),
    );
  }

  Widget _buildMenuContainer(AntThemeData theme) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          if (item.type == AntDropdownItemType.divider) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Divider(height: 1, color: theme.colorSplit),
            );
          }
          return _buildItem(theme, item);
        }).toList(),
      ),
    );
  }

  Widget _buildItem(AntThemeData theme, AntDropdownItem item) {
    final labelWidgets = <Widget>[];
    if (item.icon != null) {
      labelWidgets.add(Icon(
        item.icon,
        size: 14,
        color: item.disabled
            ? theme.colorTextDisabled
            : item.danger
                ? theme.colorError
                : theme.colorTextSecondary,
      ),);
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
                      : theme.colorText,
            ),
          ),
    );

    return InkWell(
      onTap: item.disabled ? null : () => onItemClick(item.key),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: labelWidgets,
        ),
      ),
    );
  }
}
