/// AntPopconfirm — antd React Popconfirm（气泡确认框）的 Flutter 实现
///
/// API 与 antd v6 对齐：
/// - [child] — 触发元素
/// - [title] — 确认框标题（默认文案「确定吗？」）
/// - [description] — 补充描述
/// - [okText] / [cancelText] — 确认/取消按钮文案
/// - [onConfirm] / [onCancel] — 确认/取消回调（点击后自动关闭）
/// - [okButtonProps] / [cancelButtonProps] — 按钮属性（简化）
/// - [placement] — 弹出位置（参考 Popover 九方向）
/// - [icon] — 自定义图标（默认问号）
/// - [open] — 受控显示状态
/// - [disabled] — 是否禁用弹出
///
/// ```dart
/// AntPopconfirm(
///   title: '删除这条记录吗？',
///   onConfirm: () {},
///   child: AntButton(child: Text('删除')),
/// )
/// ```
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import '../../general/button/ant_button.dart';
import '../../general/button/ant_button_types.dart';
import 'ant_popconfirm_types.dart';

// ============================================================
// 测试定位 Key 与默认文案
// ============================================================

/// 气泡容器标记 key，便于测试定位气泡。
const Key kAntPopconfirmBubbleKey = ValueKey<String>('AntPopconfirmBubble');

/// 确认按钮标记 key。
const Key kAntPopconfirmOkButtonKey = ValueKey<String>('AntPopconfirmOk');

/// 取消按钮标记 key。
const Key kAntPopconfirmCancelButtonKey = ValueKey<String>(
  'AntPopconfirmCancel',
);

/// 默认标题文案。
const String kAntPopconfirmDefaultTitle = '确定吗？';

/// 默认确认按钮文案。
const String kAntPopconfirmDefaultOkText = '确定';

/// 默认取消按钮文案。
const String kAntPopconfirmDefaultCancelText = '取消';

// ============================================================
// AntPopconfirm
// ============================================================

/// 气泡确认框 — 点击元素时弹出的确认气泡，包含确认/取消按钮。
///
/// 对齐 antd React Popconfirm 组件：支持标题/描述、九/十二方向弹出位置、
/// 自定义按钮文案与图标、受控 open、disabled 禁用。
/// 点击确认或取消后气泡自动关闭。
class AntPopconfirm extends StatefulWidget {
  const AntPopconfirm({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.okText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.okButtonProps,
    this.cancelButtonProps,
    this.placement = AntPopconfirmPlacement.bottomLeft,
    this.icon,
    this.open,
    this.onOpenChange,
    this.disabled = false,
    this.overlayStyle,
  });

  /// 触发元素。
  final Widget child;

  /// 确认框标题（为空时使用默认文案「确定吗？」）。
  final String? title;

  /// 补充描述。
  final String? description;

  /// 确认按钮文案（默认「确定」）。
  final String? okText;

  /// 取消按钮文案（默认「取消」）。
  final String? cancelText;

  /// 确认回调（点击后自动关闭）。
  final VoidCallback? onConfirm;

  /// 取消回调（点击后自动关闭）。
  final VoidCallback? onCancel;

  /// 确认按钮附加属性（简化：仅支持 onTap 覆盖前的额外回调语义由 onConfirm 承担）。
  final AntPopconfirmButtonProps? okButtonProps;

  /// 取消按钮附加属性。
  final AntPopconfirmButtonProps? cancelButtonProps;

  /// 弹出位置。
  final AntPopconfirmPlacement placement;

  /// 自定义图标（默认问号图标，主色）。
  final Widget? icon;

  /// 受控显示状态（非空时进入受控模式）。
  final bool? open;

  /// 显示状态变化回调。
  final AntPopconfirmOpenChange? onOpenChange;

  /// 是否禁用弹出。
  final bool disabled;

  /// 浮层自定义样式。
  final AntPopconfirmOverlayStyle? overlayStyle;

  @override
  State<AntPopconfirm> createState() => _AntPopconfirmState();
}

/// 气泡确认框按钮附加属性（简化版 buttonProps）。
class AntPopconfirmButtonProps {
  const AntPopconfirmButtonProps({this.disabled = false});

  /// 是否禁用该按钮。
  final bool disabled;
}

/// 显示状态变化回调签名。
typedef AntPopconfirmOpenChange = void Function(bool open);

class _AntPopconfirmState extends State<AntPopconfirm> {
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
  void didUpdateWidget(covariant AntPopconfirm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != null && oldWidget.open != widget.open) {
      if (widget.open!) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
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
    if (value) {
      widget.onOpenChange?.call(true);
      if (widget.open == null) _showOverlay();
    } else {
      widget.onOpenChange?.call(false);
      if (widget.open == null) _hideOverlay();
    }
    _internalOpen = value;
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || widget.disabled) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _PopconfirmOverlay(
        childKey: _childKey,
        title: widget.title ?? kAntPopconfirmDefaultTitle,
        description: widget.description,
        okText: widget.okText ?? kAntPopconfirmDefaultOkText,
        cancelText: widget.cancelText ?? kAntPopconfirmDefaultCancelText,
        okDisabled: widget.okButtonProps?.disabled ?? false,
        cancelDisabled: widget.cancelButtonProps?.disabled ?? false,
        placement: widget.placement,
        icon: widget.icon,
        overlayStyle: widget.overlayStyle,
        themeData: theme,
        onConfirm: () {
          widget.onConfirm?.call();
          _setOpen(false);
        },
        onCancel: () {
          widget.onCancel?.call();
          _setOpen(false);
        },
        onDismiss: () => _setOpen(false),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  void _handleTap() {
    if (widget.disabled) return;
    if (_currentOpen) {
      _setOpen(false);
    } else {
      _setOpen(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// _PopconfirmOverlay — 气泡浮层
// ============================================================

class _PopconfirmOverlay extends StatefulWidget {
  const _PopconfirmOverlay({
    required this.childKey,
    required this.title,
    required this.description,
    required this.okText,
    required this.cancelText,
    required this.okDisabled,
    required this.cancelDisabled,
    required this.placement,
    required this.icon,
    required this.overlayStyle,
    required this.themeData,
    required this.onConfirm,
    required this.onCancel,
    required this.onDismiss,
  });

  final GlobalKey childKey;
  final String title;
  final String? description;
  final String okText;
  final String cancelText;
  final bool okDisabled;
  final bool cancelDisabled;
  final AntPopconfirmPlacement placement;
  final Widget? icon;
  final AntPopconfirmOverlayStyle? overlayStyle;
  final AntThemeData themeData;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onDismiss;

  @override
  State<_PopconfirmOverlay> createState() => _PopconfirmOverlayState();
}

class _PopconfirmOverlayState extends State<_PopconfirmOverlay>
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

    // 触发元素位置
    final childCtx = widget.childKey.currentContext;
    if (childCtx == null) return const SizedBox.shrink();
    final childBox = childCtx.findRenderObject() as RenderBox?;
    if (childBox == null || !childBox.hasSize) return const SizedBox.shrink();
    final childPos = childBox.localToGlobal(Offset.zero);
    final childW = childBox.size.width;
    final childH = childBox.size.height;

    // 气泡尺寸（高度首帧估算，post-frame 校正）
    final bubbleW = 240.w;
    if (_bubbleHeight <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = _bubbleKey.currentContext;
        final box = ctx?.findRenderObject() as RenderBox?;
        if (box != null &&
            box.hasSize &&
            box.size.height != _bubbleHeight) {
          setState(() => _bubbleHeight = box.size.height);
        }
      });
      _bubbleHeight = _estimateHeight();
    }
    final bubbleH = _bubbleHeight;

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
      case AntPopconfirmPlacement.topLeft:
        left = childLeft;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopconfirmPlacement.topCenter:
        left = childCenterX - bubbleW / 2;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopconfirmPlacement.topRight:
        left = childRight - bubbleW;
        bottom = mediaSize.height - childTop + gap;
        break;
      case AntPopconfirmPlacement.bottomLeft:
        left = childLeft;
        top = childBottom + gap;
        break;
      case AntPopconfirmPlacement.bottomCenter:
        left = childCenterX - bubbleW / 2;
        top = childBottom + gap;
        break;
      case AntPopconfirmPlacement.bottomRight:
        left = childRight - bubbleW;
        top = childBottom + gap;
        break;
      case AntPopconfirmPlacement.leftTop:
        left = childLeft - gap - bubbleW;
        top = childTop;
        break;
      case AntPopconfirmPlacement.leftCenter:
        left = childLeft - gap - bubbleW;
        top = childCenterY - bubbleH / 2;
        break;
      case AntPopconfirmPlacement.leftBottom:
        left = childLeft - gap - bubbleW;
        bottom = mediaSize.height - childBottom + gap;
        break;
      case AntPopconfirmPlacement.rightTop:
        left = childRight + gap;
        top = childTop;
        break;
      case AntPopconfirmPlacement.rightCenter:
        left = childRight + gap;
        top = childCenterY - bubbleH / 2;
        break;
      case AntPopconfirmPlacement.rightBottom:
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
        // 点击气泡外空白处关闭（translucent 允许事件穿透触发元素）
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
                child: _buildBubble(theme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _scaleAlignment(AntPopconfirmPlacement placement) {
    switch (placement) {
      case AntPopconfirmPlacement.topLeft:
      case AntPopconfirmPlacement.topCenter:
      case AntPopconfirmPlacement.topRight:
        return Alignment.bottomCenter;
      case AntPopconfirmPlacement.leftTop:
      case AntPopconfirmPlacement.leftCenter:
      case AntPopconfirmPlacement.leftBottom:
        return Alignment.centerRight;
      case AntPopconfirmPlacement.rightTop:
      case AntPopconfirmPlacement.rightCenter:
      case AntPopconfirmPlacement.rightBottom:
        return Alignment.centerLeft;
      case AntPopconfirmPlacement.bottomLeft:
      case AntPopconfirmPlacement.bottomCenter:
      case AntPopconfirmPlacement.bottomRight:
        return Alignment.topCenter;
    }
  }

  double _estimateHeight() {
    final titleH = 24.w;
    final descH = widget.description != null ? 36.w : 0;
    final actionsH = 36.w;
    final padV = 12.w * 2;
    return titleH + descH + actionsH + padV;
  }

  Widget _buildBubble(AntThemeData theme) {
    final style = widget.overlayStyle;
    final bubbleColor = style?.backgroundColor ?? theme.colorBgContainer;
    final radius = style?.borderRadius ??
        BorderRadius.circular(theme.borderRadiusLG.r);
    final padding = style?.padding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w);

    final bubble = Container(
      width: 240.w,
      padding: padding,
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: radius,
        border: style?.border,
        boxShadow: style?.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12.r,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Column(
        key: _bubbleKey,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行：图标 + 标题
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: widget.icon!,
                )
              else
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Icon(
                    Icons.help_outline,
                    size: 16.sp,
                    color: theme.colorPrimary,
                  ),
                ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorTextHeading,
                  ),
                ),
              ),
            ],
          ),
          if (widget.description != null)
            Padding(
              padding: EdgeInsets.only(top: 4.w, left: 24.w),
              child: Text(
                widget.description!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorTextSecondary,
                ),
              ),
            ),
          SizedBox(height: 10.w),
          // 操作按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AntButton(
                key: kAntPopconfirmCancelButtonKey,
                type: AntButtonType.normal,
                size: AntButtonSize.small,
                disabled: widget.cancelDisabled,
                onTap: widget.onCancel,
                child: Text(widget.cancelText),
              ),
              SizedBox(width: 8.w),
              AntButton(
                key: kAntPopconfirmOkButtonKey,
                type: AntButtonType.primary,
                size: AntButtonSize.small,
                disabled: widget.okDisabled,
                onTap: widget.onConfirm,
                child: Text(widget.okText),
              ),
            ],
          ),
        ],
      ),
    );

    return KeyedSubtree(key: kAntPopconfirmBubbleKey, child: bubble);
  }
}
