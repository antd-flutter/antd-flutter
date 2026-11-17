/// AntTooltip — antd React Tooltip 的 Flutter 实现
///
/// API 与 antd React Tooltip 对齐：
/// - [child] — 触发元素
/// - [tooltip] — 气泡内容（Widget）
/// - [placement] — 12 个弹出方向（top/bottom/left/right 及变体）
/// - [open] / [defaultOpen] — 受控 / 非受控显示
/// - [color] — 自定义气泡背景色
/// - [overlayStyle] — 气泡容器装饰样式
/// - [arrow] — 是否显示箭头
/// - [mouseEnterDelay] / [mouseLeaveDelay] — 桌面 hover 延迟
/// - [trigger] — hover / click / focus（默认按平台自动选择）
///
/// 交互约定：桌面端 hover 触发，移动端点击 / 长按触发
/// （通过 [AntPlatform] 判断，鸿蒙按 `Platform.operatingSystem == 'ohos'` 走移动端分支）。
///
/// ```dart
/// AntTooltip(
///   tooltip: const Text('提示文案'),
///   child: const Text('鼠标移上来'),
/// )
/// ```
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_tooltip_types.dart';

// ============================================================
// 常量
// ============================================================

/// 默认气泡背景色（antd tooltip 默认深色）。
const Color _defaultTooltipBg = Color(0xE6141414);

/// 气泡圆角（antd tooltip borderRadius 8）。
const double _tooltipRadius = 8;

/// 箭头边长。
double get _arrowSize => 8.r;

/// 气泡与触发元素的间距。
double get _tooltipGap => 6.r;

/// 气泡内容 Key（供测试定位）。
const Key _tooltipContentKey = Key('ant_tooltip_content');

/// 箭头 Key（供测试定位）。
const Key _tooltipArrowKey = Key('ant_tooltip_arrow');

// ============================================================
// AntTooltip
// ============================================================

/// 文字提示 — 简单的文字提示气泡。
///
/// 对齐 antd React Tooltip 组件：鼠标移入 / 聚焦 / 点击时显示气泡提示，
/// 支持 12 个弹出方向、受控显示、自定义颜色与箭头。
class AntTooltip extends StatefulWidget {
  const AntTooltip({
    super.key,
    required this.child,
    required this.tooltip,
    this.placement = AntTooltipPlacement.top,
    this.trigger,
    this.open,
    this.defaultOpen = false,
    this.onOpenChange,
    this.color,
    this.overlayStyle,
    this.arrow = true,
    this.mouseEnterDelay = const Duration(milliseconds: 100),
    this.mouseLeaveDelay = const Duration(milliseconds: 100),
  });

  /// 触发元素。
  final Widget child;

  /// 气泡内容提示（Widget）。
  final Widget tooltip;

  /// 弹出位置，默认 [AntTooltipPlacement.top]。
  final AntTooltipPlacement placement;

  /// 触发方式。为 null 时按平台自动选择（桌面 hover / 移动端 click）。
  final AntTooltipTrigger? trigger;

  /// 受控显示状态。非 null 时为受控模式。
  final bool? open;

  /// 非受控模式下的默认显示状态。
  final bool defaultOpen;

  /// 显示状态变化回调。
  final ValueChanged<bool>? onOpenChange;

  /// 自定义气泡背景色（文字自动取反白）。
  final Color? color;

  /// 气泡容器装饰样式（提供时覆盖默认 decoration）。
  final BoxDecoration? overlayStyle;

  /// 是否显示箭头。
  final bool arrow;

  /// 桌面端鼠标移入延迟。
  final Duration mouseEnterDelay;

  /// 桌面端鼠标移出延迟。
  final Duration mouseLeaveDelay;

  /// 实际生效的触发方式。
  AntTooltipTrigger get effectiveTrigger =>
      trigger ??
      (AntPlatform.isDesktop ? AntTooltipTrigger.hover : AntTooltipTrigger.click);

  @override
  State<AntTooltip> createState() => _AntTooltipState();
}

class _AntTooltipState extends State<AntTooltip> {
  final GlobalKey _childKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  FocusNode? _focusNode;
  Timer? _enterTimer;
  Timer? _leaveTimer;

  bool get _currentOpen => widget.open ?? _internalOpen;

  /// 焦点触发模式下使用的 FocusNode（懒创建）。
  FocusNode get _effectiveFocusNode => _focusNode ??= FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.defaultOpen && widget.open == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    } else if (widget.open == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != null && oldWidget.open != widget.open) {
      if (widget.open!) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
  }

  @override
  void dispose() {
    _enterTimer?.cancel();
    _leaveTimer?.cancel();
    _focusNode?.dispose();
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

  // ---- 显示 / 隐藏 ----

  void _showOverlay() {
    _enterTimer?.cancel();
    _leaveTimer?.cancel();
    if (_overlayEntry != null) return;
    if (!mounted) return;

    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        layerLink: _layerLink,
        content: widget.tooltip,
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
    _enterTimer?.cancel();
    _leaveTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  // ---- 事件处理 ----

  void _handleHoverEnter() {
    if (_currentOpen) return;
    _leaveTimer?.cancel();
    if (widget.mouseEnterDelay <= Duration.zero) {
      _setOpen(true);
    } else {
      _enterTimer?.cancel();
      _enterTimer = Timer(widget.mouseEnterDelay, () {
        if (mounted) _setOpen(true);
      });
    }
  }

  void _handleHoverExit() {
    if (!_currentOpen) return;
    _enterTimer?.cancel();
    if (widget.mouseLeaveDelay <= Duration.zero) {
      _setOpen(false);
    } else {
      _leaveTimer?.cancel();
      _leaveTimer = Timer(widget.mouseLeaveDelay, () {
        if (mounted) _setOpen(false);
      });
    }
  }

  void _handleTap() => _setOpen(!_currentOpen);

  void _handleLongPress() {
    if (!_currentOpen) _setOpen(true);
  }

  void _handleFocusChange(bool focused) {
    if (focused) {
      if (!_currentOpen) _setOpen(true);
    } else {
      if (_currentOpen) _setOpen(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trigger = widget.effectiveTrigger;

    Widget result = CompositedTransformTarget(
      link: _layerLink,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );

    // 点击 / 长按（移动端主交互，click 触发时全平台生效）；焦点触发时点击请求焦点
    result = GestureDetector(
      onTap: trigger == AntTooltipTrigger.click
          ? _handleTap
          : trigger == AntTooltipTrigger.focus
              ? () => _effectiveFocusNode.requestFocus()
              : null,
      onLongPress:
          trigger == AntTooltipTrigger.click && AntPlatform.isMobile
              ? _handleLongPress
              : null,
      child: result,
    );

    // 焦点触发
    if (trigger == AntTooltipTrigger.focus) {
      result = Focus(
        focusNode: _effectiveFocusNode,
        onFocusChange: _handleFocusChange,
        child: result,
      );
    }

    // 悬停触发（桌面端）
    result = MouseRegion(
      onEnter: trigger == AntTooltipTrigger.hover ? (_) => _handleHoverEnter() : null,
      onExit: trigger == AntTooltipTrigger.hover ? (_) => _handleHoverExit() : null,
      child: result,
    );

    return result;
  }
}

// ============================================================
// _TooltipOverlay — 气泡浮层（Overlay + 自定义 position，带出现动画）
// ============================================================

class _TooltipOverlay extends StatefulWidget {
  const _TooltipOverlay({
    required this.layerLink,
    required this.content,
    required this.placement,
    required this.arrow,
    required this.color,
    required this.overlayStyle,
    required this.themeData,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final Widget content;
  final AntTooltipPlacement placement;
  final bool arrow;
  final Color? color;
  final BoxDecoration? overlayStyle;
  final AntThemeData themeData;
  final VoidCallback onDismiss;

  @override
  State<_TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<_TooltipOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ---- 位置锚点 ----

  bool get _isVertical {
    return switch (widget.placement) {
      AntTooltipPlacement.top ||
      AntTooltipPlacement.topLeft ||
      AntTooltipPlacement.topRight ||
      AntTooltipPlacement.bottom ||
      AntTooltipPlacement.bottomLeft ||
      AntTooltipPlacement.bottomRight =>
        true,
      _ => false,
    };
  }

  /// 是否朝向触发元素（气泡在上方 / 左侧）。
  bool get _isBefore {
    return switch (widget.placement) {
      AntTooltipPlacement.top ||
      AntTooltipPlacement.topLeft ||
      AntTooltipPlacement.topRight ||
      AntTooltipPlacement.left ||
      AntTooltipPlacement.leftTop ||
      AntTooltipPlacement.leftBottom =>
        true,
      _ => false,
    };
  }

  /// 触发元素上的锚点（跟随 placement 的主方向与对齐）。
  Alignment get _targetAnchor {
    final (vertical, align, before) = _anchors;
    if (vertical) {
      return switch ((before, align)) {
        (true, 0) => Alignment.topCenter,
        (true, -1) => Alignment.topLeft,
        (true, 1) => Alignment.topRight,
        (false, 0) => Alignment.bottomCenter,
        (false, -1) => Alignment.bottomLeft,
        _ => Alignment.bottomRight,
      };
    }
    return switch ((before, align)) {
      (true, 0) => Alignment.centerLeft,
      (true, -1) => Alignment.topLeft,
      (true, 1) => Alignment.bottomLeft,
      (false, 0) => Alignment.centerRight,
      (false, -1) => Alignment.topRight,
      _ => Alignment.bottomRight,
    };
  }

  /// 气泡上的锚点（与触发元素锚点相对）。
  Alignment get _followerAnchor {
    final (vertical, align, before) = _anchors;
    if (vertical) {
      return switch ((before, align)) {
        (true, 0) => Alignment.bottomCenter,
        (true, -1) => Alignment.bottomLeft,
        (true, 1) => Alignment.bottomRight,
        (false, 0) => Alignment.topCenter,
        (false, -1) => Alignment.topLeft,
        _ => Alignment.topRight,
      };
    }
    return switch ((before, align)) {
      (true, 0) => Alignment.centerRight,
      (true, -1) => Alignment.topRight,
      (true, 1) => Alignment.bottomRight,
      (false, 0) => Alignment.centerLeft,
      (false, -1) => Alignment.topLeft,
      _ => Alignment.bottomLeft,
    };
  }

  /// (是否垂直方向, 对齐：-1 起始 / 0 居中 / 1 末尾, 是否朝向触发元素)
  (bool, int, bool) get _anchors {
    final vertical = _isVertical;
    final before = _isBefore;
    final align = switch (widget.placement) {
      AntTooltipPlacement.top ||
      AntTooltipPlacement.bottom ||
      AntTooltipPlacement.left ||
      AntTooltipPlacement.right =>
        0,
      AntTooltipPlacement.topLeft ||
      AntTooltipPlacement.bottomLeft ||
      AntTooltipPlacement.leftTop ||
      AntTooltipPlacement.rightTop =>
        -1,
      _ => 1,
    };
    return (vertical, align, before);
  }

  /// 气泡与触发元素之间的间距偏移。
  Offset get _gapOffset {
    final gap = _tooltipGap + (widget.arrow ? _arrowSize * 0.7 : 0);
    return switch (widget.placement) {
      AntTooltipPlacement.top ||
      AntTooltipPlacement.topLeft ||
      AntTooltipPlacement.topRight =>
        Offset(0, -gap),
      AntTooltipPlacement.bottom ||
      AntTooltipPlacement.bottomLeft ||
      AntTooltipPlacement.bottomRight =>
        Offset(0, gap),
      AntTooltipPlacement.left ||
      AntTooltipPlacement.leftTop ||
      AntTooltipPlacement.leftBottom =>
        Offset(-gap, 0),
      _ => Offset(gap, 0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;

    return Stack(
      children: [
        // 点击空白处关闭（translucent 允许 hover 事件穿透到下层 MouseRegion）
        GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            alignment: _isVertical
                ? (_isBefore ? Alignment.bottomCenter : Alignment.topCenter)
                : (_isBefore ? Alignment.centerRight : Alignment.centerLeft),
            child: CompositedTransformFollower(
              link: widget.layerLink,
              targetAnchor: _targetAnchor,
              followerAnchor: _followerAnchor,
              offset: _gapOffset,
              showWhenUnlinked: false,
              child: TapRegion(
                onTapOutside: (_) => widget.onDismiss(),
                child: Material(
                  color: Colors.transparent,
                  child: _buildBubble(theme),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(AntThemeData theme) {
    final bgColor = widget.color ?? _defaultTooltipBg;
    final decoration = widget.overlayStyle ??
        BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(_tooltipRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

    return Container(
      key: _tooltipContentKey,
      decoration: decoration,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 气泡内容
          Container(
            constraints: BoxConstraints(maxWidth: 250.w),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: theme.fontSize,
                color: widget.color == null
                    ? Colors.white
                    : bgColor.computeLuminance() > 0.5
                        ? const Color(0xFF141414)
                        : Colors.white,
              ),
              child: widget.content,
            ),
          ),
          // 箭头
          if (widget.arrow) _buildArrow(bgColor, decoration),
        ],
      ),
    );
  }

  Widget _buildArrow(Color bgColor, BoxDecoration decoration) {
    final rotation = switch (widget.placement) {
      AntTooltipPlacement.top ||
      AntTooltipPlacement.topLeft ||
      AntTooltipPlacement.topRight =>
        math.pi / 4, // 指向上方
      AntTooltipPlacement.bottom ||
      AntTooltipPlacement.bottomLeft ||
      AntTooltipPlacement.bottomRight =>
        -math.pi / 4, // 指向下方
      AntTooltipPlacement.left ||
      AntTooltipPlacement.leftTop ||
      AntTooltipPlacement.leftBottom =>
        math.pi / 4, // 指向左侧
      _ => -math.pi / 4, // 指向右侧
    };

    final offset = switch (widget.placement) {
      AntTooltipPlacement.top => const Alignment(0, -1.6),
      AntTooltipPlacement.topLeft => const Alignment(-0.8, -1.6),
      AntTooltipPlacement.topRight => const Alignment(0.8, -1.6),
      AntTooltipPlacement.bottom => const Alignment(0, 1.6),
      AntTooltipPlacement.bottomLeft => const Alignment(-0.8, 1.6),
      AntTooltipPlacement.bottomRight => const Alignment(0.8, 1.6),
      AntTooltipPlacement.left => const Alignment(-1.6, 0),
      AntTooltipPlacement.leftTop => const Alignment(-1.6, -0.8),
      AntTooltipPlacement.leftBottom => const Alignment(-1.6, 0.8),
      AntTooltipPlacement.right => const Alignment(1.6, 0),
      AntTooltipPlacement.rightTop => const Alignment(1.6, -0.8),
      AntTooltipPlacement.rightBottom => const Alignment(1.6, 0.8),
    };

    return Positioned.fill(
      child: Align(
        alignment: offset,
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            key: _tooltipArrowKey,
            width: _arrowSize,
            height: _arrowSize,
            decoration: BoxDecoration(
              color: widget.overlayStyle?.color ?? bgColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
      ),
    );
  }
}
