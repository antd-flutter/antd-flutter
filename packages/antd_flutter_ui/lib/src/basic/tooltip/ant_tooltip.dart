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

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
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
      // 受控开关可能发生在父级 build 阶段（setState 联动），
      // Overlay.insert 需要延迟到帧末执行，否则触发
      // 「markNeedsBuild called during build」异常
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.open!) {
          _showOverlay();
        } else {
          _hideOverlay();
        }
      });
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
        childKey: _childKey,
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
    // 快速移动：指针可能在 mouseEnterDelay 窗口内移出（此时气泡尚未打开），
    // 必须取消 pending 的 enter 计时器，否则延迟到期后气泡弹出且再无 exit 事件关闭
    _enterTimer?.cancel();
    _enterTimer = null;
    if (!_currentOpen) return;
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

    Widget result = KeyedSubtree(
      key: _childKey,
      child: widget.child,
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
// _TooltipOverlay — 气泡浮层（基于统一弹层底座 AntPopupOverlay）
// ============================================================

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.childKey,
    required this.content,
    required this.placement,
    required this.arrow,
    required this.color,
    required this.overlayStyle,
    required this.themeData,
    required this.onDismiss,
  });

  final GlobalKey childKey;
  final Widget content;
  final AntTooltipPlacement placement;
  final bool arrow;
  final Color? color;
  final BoxDecoration? overlayStyle;
  final AntThemeData themeData;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? _defaultTooltipBg;
    final decoration = overlayStyle ??
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

    return AntPopupOverlay(
      targetKey: childKey,
      placement: AntPopupPlacement.values.byName(placement.name),
      arrow: arrow,
      arrowColor: overlayStyle?.color ?? bgColor,
      arrowKey: arrow ? _tooltipArrowKey : null,
      gap: _tooltipGap,
      arrowSize: _arrowSize,
      onDismiss: onDismiss,
      child: _buildBubble(bgColor, decoration),
    );
  }
  Widget _buildBubble(Color bgColor, BoxDecoration decoration) {
    return Container(
      key: _tooltipContentKey,
      decoration: decoration,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
      child: Container(
        constraints: BoxConstraints(maxWidth: 250.w),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: themeData.fontSize,
            color: color == null
                ? Colors.white
                : bgColor.computeLuminance() > 0.5
                    ? const Color(0xFF141414)
                    : Colors.white,
          ),
          child: content,
        ),
      ),
    );
  }
}
