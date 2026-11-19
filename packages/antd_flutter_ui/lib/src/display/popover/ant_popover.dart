/// AntPopover — antd React Popover 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [child] — 触发元素
/// - [title] — 气泡标题
/// - [content] — 气泡内容
/// - [trigger] — hover / click
/// - [placement] — 九方向弹出位置
/// - [open] / [defaultOpen] / [onOpenChange] — 受控/非受控显示
/// - [color] — 自定义背景色
/// - [arrow] — 是否显示箭头
/// - [overlayStyle] — 浮层自定义样式
///
/// ```dart
/// AntPopover(
///   title: const Text('标题'),
///   content: const Text('气泡内容'),
///   child: AntButton(child: Text('触发')),
/// )
/// ```
library;

import 'dart:async';

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_popover_types.dart';

// ============================================================
// AntPopover
// ============================================================

/// 气泡卡片 — 点击/悬停元素时弹出的卡片式浮层。
///
/// 对齐 antd React Popover 组件，用于展示富文本内容，
/// 支持标题区、九方向弹出位置、受控显示、自定义背景色与箭头。
class AntPopover extends StatefulWidget {
  const AntPopover({
    super.key,
    required this.child,
    required this.content,
    this.title,
    this.trigger = AntPopoverTrigger.hover,
    this.placement = AntPopoverPlacement.bottomLeft,
    this.open,
    this.defaultOpen = false,
    this.onOpenChange,
    this.color,
    this.arrow = false,
    this.overlayStyle,
    this.disabled = false,
  });

  /// 触发元素。
  final Widget child;

  /// 气泡内容。
  final Widget content;

  /// 气泡标题区。
  final Widget? title;

  /// 触发方式。
  final AntPopoverTrigger trigger;

  /// 弹出位置。
  final AntPopoverPlacement placement;

  /// 受控显示状态（非空时进入受控模式）。
  final bool? open;

  /// 非受控默认显示状态。
  final bool defaultOpen;

  /// 显示状态变化回调。
  final ValueChanged<bool>? onOpenChange;

  /// 自定义气泡背景色（文字自动反白）。
  final Color? color;

  /// 是否显示箭头。
  final bool arrow;

  /// 浮层自定义样式。
  final AntPopoverOverlayStyle? overlayStyle;

  /// 是否禁用。
  final bool disabled;

  @override
  State<AntPopover> createState() => _AntPopoverState();
}

class _AntPopoverState extends State<AntPopover> with PopupOpenScheduler {
  /// 平台适配：移动端 hover 降级为点击。
  /// 按当前 trigger 解析并缓存（平台恒定，避免重建期反复读取导致接线抖动）。
  AntPopoverTrigger? _resolvedTrigger;
  bool _hoverEffective = false;
  bool _tapEffective = false;

  void _resolveTrigger() {
    if (_resolvedTrigger == widget.trigger) return;
    _resolvedTrigger = widget.trigger;
    _hoverEffective =
        widget.trigger == AntPopoverTrigger.hover && AntPlatform.isDesktop;
    _tapEffective = widget.trigger == AntPopoverTrigger.click ||
        (widget.trigger == AntPopoverTrigger.hover && !AntPlatform.isDesktop);
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
    if (widget.defaultOpen || widget.open == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != null && oldWidget.open != widget.open) {
      // 受控切换可能发生在父级 build 阶段，show/hide 延迟到帧末
      schedulePopupOpen(
        open: widget.open!,
        show: _showOverlay,
        hide: _hideOverlay,
      );
    }
    if (widget.disabled) {
      _hideOverlay();
    }
  }

  @override
  void dispose() {
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
    if (_overlayEntry != null || !mounted || widget.disabled) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _PopoverOverlay(
        childKey: _childKey,
        content: widget.content,
        title: widget.title,
        placement: widget.placement,
        arrow: widget.arrow,
        color: widget.color,
        overlayStyle: widget.overlayStyle,
        themeData: theme,
        onDismiss: () => _setOpen(false),
        onBubbleHoverEnter:
            _hoverEffective ? _handleBubbleHoverEnter : null,
        onBubbleHoverExit: _hoverEffective ? _handleBubbleHoverExit : null,
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
    if (widget.disabled) return;
    _insideTrigger = true;
    _cancelHoverCloseTimer();
    if (!_currentOpen) _setOpen(true);
  }

  void _handleHoverExit() {
    if (widget.disabled) return;
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
  /// exit/enter 乱序，气泡内按钮等交互不受影响）。
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
// _PopoverOverlay — 气泡浮层（基于统一弹层底座 AntPopupOverlay）
// ============================================================

/// 气泡箭头标记 key，便于测试定位箭头。
const Key kAntPopoverArrowKey = ValueKey<String>('AntPopoverArrow');

/// 气泡容器标记 key，便于测试定位气泡。
const Key kAntPopoverBubbleKey = ValueKey<String>('AntPopoverBubble');

class _PopoverOverlay extends StatelessWidget {
  const _PopoverOverlay({
    required this.childKey,
    required this.content,
    required this.title,
    required this.placement,
    required this.arrow,
    required this.color,
    required this.overlayStyle,
    required this.themeData,
    required this.onDismiss,
    this.onBubbleHoverEnter,
    this.onBubbleHoverExit,
  });

  final GlobalKey childKey;
  final Widget content;
  final Widget? title;
  final AntPopoverPlacement placement;
  final bool arrow;
  final Color? color;
  final AntPopoverOverlayStyle? overlayStyle;
  final AntThemeData themeData;
  final VoidCallback onDismiss;
  final VoidCallback? onBubbleHoverEnter;
  final VoidCallback? onBubbleHoverExit;

  @override
  Widget build(BuildContext context) {
    final overlayStyle = this.overlayStyle;
    final customColor = overlayStyle?.backgroundColor ?? color;
    final bubbleColor = customColor ?? themeData.colorBgContainer;

    return AntPopupOverlay(
      targetKey: childKey,
      placement: _mapPlacement(placement),
      arrow: arrow,
      arrowColor: bubbleColor,
      arrowKey: arrow ? kAntPopoverArrowKey : null,
      gap: 8.w,
      onDismiss: onDismiss,
      onBubbleHoverEnter: onBubbleHoverEnter,
      onBubbleHoverExit: onBubbleHoverExit,
      child: _buildBubble(context, bubbleColor),
    );
  }

  Widget _buildBubble(BuildContext context, Color bubbleColor) {
    final theme = themeData;
    final overlayStyle = this.overlayStyle;
    final customColor = overlayStyle?.backgroundColor ?? color;
    // 自定义背景色时文字反白
    final fgColor = customColor != null ? Colors.white : theme.colorText;
    final fgSecondary = customColor != null
        ? Colors.white.withValues(alpha: 0.75)
        : theme.colorTextSecondary;
    final radius = overlayStyle?.borderRadius ??
        BorderRadius.circular(theme.borderRadiusLG.r);
    final padding = overlayStyle?.padding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w);

    final children = <Widget>[];
    if (title != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
            child: title!,
          ),
        ),
      );
    }
    children.add(
      DefaultTextStyle(
        style: TextStyle(fontSize: 14.sp, color: fgSecondary),
        child: content,
      ),
    );

    final bubbleDecoration = BoxDecoration(
      color: bubbleColor,
      borderRadius: radius,
      border: overlayStyle?.border,
      boxShadow: overlayStyle?.boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
    );

    return KeyedSubtree(
      key: kAntPopoverBubbleKey,
      child: Container(
        width: 240.w,
        padding: padding,
        decoration: bubbleDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

/// AntPopoverPlacement（topCenter/leftCenter 等九变体）→ 引擎统一 12 方向。
AntPopupPlacement _mapPlacement(AntPopoverPlacement placement) =>
    switch (placement) {
      AntPopoverPlacement.topLeft => AntPopupPlacement.topLeft,
      AntPopoverPlacement.topCenter => AntPopupPlacement.top,
      AntPopoverPlacement.topRight => AntPopupPlacement.topRight,
      AntPopoverPlacement.bottomLeft => AntPopupPlacement.bottomLeft,
      AntPopoverPlacement.bottomCenter => AntPopupPlacement.bottom,
      AntPopoverPlacement.bottomRight => AntPopupPlacement.bottomRight,
      AntPopoverPlacement.leftTop => AntPopupPlacement.leftTop,
      AntPopoverPlacement.leftCenter => AntPopupPlacement.left,
      AntPopoverPlacement.leftBottom => AntPopupPlacement.leftBottom,
      AntPopoverPlacement.rightTop => AntPopupPlacement.rightTop,
      AntPopoverPlacement.rightCenter => AntPopupPlacement.right,
      AntPopoverPlacement.rightBottom => AntPopupPlacement.rightBottom,
    };
