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

import 'dart:async';

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_dropdown_types.dart';

// ============================================================
// AntDropdownController — 程序化控制（R35.2）
// ============================================================

/// Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现）。
abstract interface class AntDropdownControlDelegate {
  /// 程序化显示下拉菜单。
  void controllerShow();

  /// 程序化隐藏下拉菜单。
  void controllerHide();

  /// 当前是否处于打开状态。
  bool get controllerIsOpen;
}

/// [AntDropdown] 的程序化控制器（R35.2 受控操作 Controller 化）。
///
/// Flutter 惯例模式（参考 [ScrollController] / EasyRefreshController）：
/// 组件挂载时自动 [attach]，卸载时自动 [detach]；使用方无需
/// GlobalKey 或自维护 bool state + setState，直接调用
/// [show] / [hide] 即可。
class AntDropdownController {
  AntDropdownControlDelegate? _delegate;

  /// 是否已绑定到挂载的 [AntDropdown]。
  bool get isAttached => _delegate != null;

  /// 绑定 State（组件 initState 时自动调用，一般无需手动调用）。
  void attach(AntDropdownControlDelegate delegate) {
    _delegate = delegate;
  }

  /// 解绑 State（组件 dispose 时自动调用，一般无需手动调用）。
  void detach() {
    _delegate = null;
  }

  /// 显示下拉菜单。未挂载时 debug 断言（ScrollController 风格），release 静默忽略。
  void show() {
    final delegate = _delegate;
    if (delegate == null) {
      assert(
        false,
        'AntDropdownController.show() 调用时未挂载 AntDropdown：'
        '请确认该 controller 已通过 controller 参数传入在树上的 AntDropdown',
      );
      return;
    }
    delegate.controllerShow();
  }

  /// 隐藏下拉菜单。未挂载时 debug 断言，release 静默忽略。
  void hide() {
    final delegate = _delegate;
    if (delegate == null) {
      assert(
        false,
        'AntDropdownController.hide() 调用时未挂载 AntDropdown：'
        '请确认该 controller 已通过 controller 参数传入在树上的 AntDropdown',
      );
      return;
    }
    delegate.controllerHide();
  }
}

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
    this.controller,
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

  /// 程序化控制器（可选）。传入后可通过 [AntDropdownController.show] /
  /// [AntDropdownController.hide] 控制下拉菜单，无需 GlobalKey 或外部 state。
  final AntDropdownController? controller;

  /// 点击菜单项回调。
  final ValueChanged<String>? onClick;

  /// 是否显示箭头。
  final bool arrow;

  /// 是否禁用。
  final bool disabled;

  @override
  State<AntDropdown> createState() => _AntDropdownState();
}

class _AntDropdownState extends State<AntDropdown>
    with PopupOpenScheduler
    implements AntDropdownControlDelegate {
  /// 平台适配：移动端 hover 降级为点击。
  /// 按当前 trigger 解析并缓存（平台恒定，避免重建期反复读取导致接线抖动）。
  AntDropdownTrigger? _resolvedTrigger;
  bool _hoverEffective = false;
  bool _tapEffective = false;

  void _resolveTrigger() {
    if (_resolvedTrigger == widget.trigger) return;
    _resolvedTrigger = widget.trigger;
    _hoverEffective =
        widget.trigger == AntDropdownTrigger.hover && AntPlatform.isDesktop;
    _tapEffective = widget.trigger == AntDropdownTrigger.click ||
        (widget.trigger == AntDropdownTrigger.hover && !AntPlatform.isDesktop);
  }

  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;

  /// 联合 hover 判定状态（触发元素 / 气泡 是否有指针停留）。
  bool _insideTrigger = false;
  bool _insideBubble = false;
  Timer? _hoverCloseTimer;

  bool get _currentOpen => widget.open ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    if (widget.open == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(this);
    }
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
    widget.controller?.detach();
    _hoverCloseTimer?.cancel();
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
        onBubbleHoverEnter:
            _hoverEffective ? _handleBubbleHoverEnter : null,
        onBubbleHoverExit: _hoverEffective ? _handleBubbleHoverExit : null,
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

  // ---- Controller 程序化控制（R35.2）----

  @override
  bool get controllerIsOpen => _currentOpen;

  @override
  void controllerShow() {
    if (!mounted) return;
    // setState 调度一帧，保证帧末回调一定会执行（controller 可能在无帧待渲染时被调用）
    setState(() {
      _internalOpen = true;
    });
    widget.onOpenChange?.call(true);
    // 受控切换可能发生在父级 build 阶段，show 延迟到帧末
    schedulePopupOpen(open: true, show: _showOverlay, hide: _hideOverlay);
  }

  @override
  void controllerHide() {
    if (!mounted) return;
    setState(() {
      _internalOpen = false;
    });
    widget.onOpenChange?.call(false);
    schedulePopupOpen(open: false, show: _showOverlay, hide: _hideOverlay);
  }

  void _handleTap() {
    if (widget.disabled) return;
    _setOpen(!_currentOpen);
  }

  void _handleHoverEnter() {
    if (widget.disabled || widget.trigger != AntDropdownTrigger.hover) return;
    _insideTrigger = true;
    _cancelHoverCloseTimer();
    if (!_currentOpen) _setOpen(true);
  }

  void _handleHoverExit() {
    if (widget.disabled || widget.trigger != AntDropdownTrigger.hover) return;
    _insideTrigger = false;
    _scheduleHoverClose();
  }

  /// 联合 hover 判定——鼠标进入气泡：保持打开（不误关）。
  void _handleBubbleHoverEnter() {
    _insideBubble = true;
    _cancelHoverCloseTimer();
  }

  /// 联合 hover 判定——鼠标离开气泡：与触发元素退出共同决定关闭。
  void _handleBubbleHoverExit() {
    _insideBubble = false;
    _scheduleHoverClose();
  }

  /// 触发元素与气泡都已离开才启动关闭（短缓冲容忍区域间跳转的
  /// exit/enter 乱序）。
  void _scheduleHoverClose() {
    if (_insideTrigger || _insideBubble) return;
    if (!_currentOpen) return;
    _hoverCloseTimer?.cancel();
    _hoverCloseTimer = Timer(const Duration(milliseconds: 100), () {
      _hoverCloseTimer = null;
      if (mounted && _currentOpen && !_insideTrigger && !_insideBubble) {
        _setOpen(false);
      }
    });
  }

  void _cancelHoverCloseTimer() {
    _hoverCloseTimer?.cancel();
    _hoverCloseTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    _resolveTrigger();
    return AntPopupTriggerRegion(
      onTap: _handleTap,
      tapEnabled: _tapEffective,
      hoverEnabled: _hoverEffective,
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
    this.onBubbleHoverEnter,
    this.onBubbleHoverExit,
  });

  final GlobalKey childKey;
  final List<AntDropdownItem> items;
  final AntDropdownPlacement placement;
  final bool arrow;
  final AntThemeData themeData;
  final ValueChanged<String> onItemClick;
  final VoidCallback onDismiss;
  final VoidCallback? onBubbleHoverEnter;
  final VoidCallback? onBubbleHoverExit;

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
      onBubbleHoverEnter: onBubbleHoverEnter,
      onBubbleHoverExit: onBubbleHoverExit,
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
