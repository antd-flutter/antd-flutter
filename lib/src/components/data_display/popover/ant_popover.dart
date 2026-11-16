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

import 'dart:math' as math;

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

class _AntPopoverState extends State<AntPopover> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;

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
      if (widget.open!) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
    if (widget.disabled) {
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
    if (!_currentOpen) _setOpen(true);
  }

  void _handleHoverExit() {
    if (widget.disabled) return;
    if (_currentOpen) _setOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: GestureDetector(
        onTap: widget.trigger == AntPopoverTrigger.click ? _handleTap : null,
        child: KeyedSubtree(
          key: _childKey,
          child: widget.child,
        ),
      ),
    );
  }
}

// ============================================================
// _PopoverOverlay — 气泡浮层
// ============================================================

/// 气泡箭头标记 key，便于测试定位箭头。
const Key kAntPopoverArrowKey = ValueKey<String>('AntPopoverArrow');

/// 气泡容器标记 key，便于测试定位气泡。
const Key kAntPopoverBubbleKey = ValueKey<String>('AntPopoverBubble');

class _PopoverOverlay extends StatefulWidget {
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

  @override
  State<_PopoverOverlay> createState() => _PopoverOverlayState();
}

class _PopoverOverlayState extends State<_PopoverOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  final GlobalKey _bubbleKey = GlobalKey();
  double _bubbleHeight = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final mediaSize = MediaQuery.sizeOf(context);
    final gap = 8.w;

    // 获取触发元素位置
    final childCtx = widget.childKey.currentContext;
    if (childCtx == null) return const SizedBox.shrink();
    final childBox = childCtx.findRenderObject() as RenderBox?;
    if (childBox == null || !childBox.hasSize) return const SizedBox.shrink();
    final childPos = childBox.localToGlobal(Offset.zero);
    final childW = childBox.size.width;
    final childH = childBox.size.height;

    // 气泡尺寸（高度首帧估算，后续按实测高度校正）
    final bubbleW = 240.w;
    if (_bubbleHeight <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final bubbleCtx = _bubbleKey.currentContext;
        final bubbleBox = bubbleCtx?.findRenderObject() as RenderBox?;
        if (bubbleBox != null && bubbleBox.hasSize &&
            bubbleBox.size.height != _bubbleHeight) {
          setState(() => _bubbleHeight = bubbleBox.size.height);
        }
      });
      _bubbleHeight = _estimateHeight();
    }
    final bubbleH = _bubbleHeight;

    // 计算浮层位置：
    // - 上/下方弹出用 top/bottom 锚定触发元素边缘，不依赖气泡高度
    // - 侧向居中用实测气泡高度（首帧估算，post-frame 校正）
    final childLeft = childPos.dx;
    final childTop = childPos.dy;
    final childBottom = childPos.dy + childH;
    final childRight = childPos.dx + childW;
    final childCenterX = childPos.dx + childW / 2;
    final childCenterY = childPos.dy + childH / 2;

    double left;
    double? top;
    double? bottom;
    switch (widget.placement) {
      case AntPopoverPlacement.topLeft:
        left = childLeft;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopoverPlacement.topCenter:
        left = childCenterX - bubbleW / 2;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopoverPlacement.topRight:
        left = childRight - bubbleW;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopoverPlacement.bottomLeft:
        left = childLeft;
        top = childBottom + gap;
        break;
      case AntPopoverPlacement.bottomCenter:
        left = childCenterX - bubbleW / 2;
        top = childBottom + gap;
        break;
      case AntPopoverPlacement.bottomRight:
        left = childRight - bubbleW;
        top = childBottom + gap;
        break;
      case AntPopoverPlacement.leftTop:
        left = childLeft - gap - bubbleW;
        top = childTop;
        break;
      case AntPopoverPlacement.leftCenter:
        left = childLeft - gap - bubbleW;
        top = childCenterY - bubbleH / 2;
        break;
      case AntPopoverPlacement.leftBottom:
        left = childLeft - gap - bubbleW;
        bottom = mediaSize.height - childBottom + gap;
        break;
      case AntPopoverPlacement.rightTop:
        left = childRight + gap;
        top = childTop;
        break;
      case AntPopoverPlacement.rightCenter:
        left = childRight + gap;
        top = childCenterY - bubbleH / 2;
        break;
      case AntPopoverPlacement.rightBottom:
        left = childRight + gap;
        bottom = mediaSize.height - childBottom + gap;
        break;
    }

    // 边界保护
    left = left.clamp(8.0, math.max(8.0, mediaSize.width - bubbleW - 8.0));
    if (top != null) {
      top = top.clamp(8.0, math.max(8.0, mediaSize.height - bubbleH - 8.0));
    }

    return Stack(
      children: [
        // 点击空白处关闭（translucent 允许事件穿透到下层触发元素）
        GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: left,
          top: top,
          bottom: bottom,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1).animate(_curve),
                alignment: _scaleAlignment(widget.placement),
                child: _buildBubble(context, theme, bubbleW),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _scaleAlignment(AntPopoverPlacement placement) {
    switch (placement) {
      case AntPopoverPlacement.topLeft:
      case AntPopoverPlacement.topCenter:
      case AntPopoverPlacement.topRight:
        return Alignment.bottomCenter;
      case AntPopoverPlacement.leftTop:
      case AntPopoverPlacement.leftCenter:
      case AntPopoverPlacement.leftBottom:
        return Alignment.centerRight;
      case AntPopoverPlacement.rightTop:
      case AntPopoverPlacement.rightCenter:
      case AntPopoverPlacement.rightBottom:
        return Alignment.centerLeft;
      case AntPopoverPlacement.bottomLeft:
      case AntPopoverPlacement.bottomCenter:
      case AntPopoverPlacement.bottomRight:
        return Alignment.topCenter;
    }
  }

  double _estimateHeight() {
    final contentH = 44.w; // 估算单行内容高度
    final titleH = widget.title != null ? 28.w : 0;
    final padV = widget.overlayStyle?.padding != null
        ? (widget.overlayStyle!.padding as EdgeInsets).vertical
        : 24.w;
    return contentH + titleH + padV;
  }

  Widget _buildBubble(BuildContext context, AntThemeData theme, double width) {
    final overlayStyle = widget.overlayStyle;
    final customColor = overlayStyle?.backgroundColor ?? widget.color;
    final bubbleColor = customColor ?? theme.colorBgContainer;
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
    if (widget.title != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
            child: widget.title!,
          ),
        ),
      );
    }
    children.add(
      DefaultTextStyle(
        style: TextStyle(fontSize: 14.sp, color: fgSecondary),
        child: widget.content,
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

    final bubble = Container(
      width: width,
      padding: padding,
      decoration: bubbleDecoration,
      child: Column(
        key: _bubbleKey,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );

    if (!widget.arrow) {
      return KeyedSubtree(key: kAntPopoverBubbleKey, child: bubble);
    }
    final arrowPos = _arrowPosition(widget.placement, width);
    return Stack(
      key: kAntPopoverBubbleKey,
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        bubble,
        Positioned(
          key: kAntPopoverArrowKey,
          left: arrowPos.left,
          right: arrowPos.right,
          top: arrowPos.top,
          bottom: arrowPos.bottom,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 计算箭头的定位参数（气泡外缘指向触发元素）。
  ({double? left, double? right, double? top, double? bottom})
      _arrowPosition(AntPopoverPlacement placement, double width) {
    const edgeOffset = 4.0;
    const inset = 16.0;
    switch (placement) {
      case AntPopoverPlacement.bottomLeft:
        return (
          left: inset,
          top: -edgeOffset,
          right: null,
          bottom: null,
        );
      case AntPopoverPlacement.bottomCenter:
        return (
          left: width / 2 - 8.w / 2,
          top: -edgeOffset,
          right: null,
          bottom: null,
        );
      case AntPopoverPlacement.bottomRight:
        return (
          left: null,
          top: -edgeOffset,
          right: inset,
          bottom: null,
        );
      case AntPopoverPlacement.topLeft:
        return (
          left: inset,
          top: null,
          right: null,
          bottom: -edgeOffset,
        );
      case AntPopoverPlacement.topCenter:
        return (
          left: width / 2 - 8.w / 2,
          top: null,
          right: null,
          bottom: -edgeOffset,
        );
      case AntPopoverPlacement.topRight:
        return (
          left: null,
          top: null,
          right: inset,
          bottom: -edgeOffset,
        );
      case AntPopoverPlacement.leftTop:
        return (
          left: null,
          top: inset,
          right: -edgeOffset,
          bottom: null,
        );
      case AntPopoverPlacement.leftCenter:
        return (
          left: null,
          top: null,
          right: -edgeOffset,
          bottom: null,
        );
      case AntPopoverPlacement.leftBottom:
        return (
          left: null,
          top: null,
          right: -edgeOffset,
          bottom: inset,
        );
      case AntPopoverPlacement.rightTop:
        return (
          left: -edgeOffset,
          top: inset,
          right: null,
          bottom: null,
        );
      case AntPopoverPlacement.rightCenter:
        return (
          left: -edgeOffset,
          top: null,
          right: null,
          bottom: null,
        );
      case AntPopoverPlacement.rightBottom:
        return (
          left: -edgeOffset,
          top: null,
          right: null,
          bottom: inset,
        );
    }
  }
}
