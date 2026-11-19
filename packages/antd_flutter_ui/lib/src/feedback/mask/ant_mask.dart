/// AntMask — antd-mobile v5 Mask（背景遮罩）的 Flutter 实现
///
/// API 与 antd-mobile Mask 对齐：
/// - [AntMask.visible] — 是否显示遮罩（受控）
/// - [AntMask.opacity] — 遮罩透明度，默认 0.5
/// - [AntMask.color] — 遮罩颜色，默认黑色
/// - [AntMask.onAction] — 点击遮罩回调
/// - [AntMask.destroyOnClose] — 关闭时销毁上层内容
/// - [AntMask.child] — 遮罩上层自定义内容（如 loading 组合）
/// - [AntMask.fullScreen] — 是否全屏铺满（默认 true）
///
/// 点击遮罩触发 [AntMask.onAction]，带淡入淡出动画。
///
/// ```dart
/// AntMask(
///   visible: _visible,
///   opacity: 0.5,
///   onAction: () => setState(() => _visible = false),
///   child: const Center(child: CircularProgressIndicator()),
/// )
/// ```
library;

import 'package:material_ui/material_ui.dart';

export 'ant_mask_types.dart';

// ============================================================
// 测试定位 Key 与默认常量
// ============================================================

/// 遮罩层标记 key，便于测试定位。
const Key kAntMaskKey = ValueKey<String>('AntMask');

/// 遮罩淡入/淡出动画时长。
const Duration kAntMaskAnimationDuration = Duration(milliseconds: 200);

/// 默认遮罩透明度。
const double kAntMaskDefaultOpacity = 0.5;

/// 默认遮罩颜色。
const Color kAntMaskDefaultColor = Colors.black;

// ============================================================
// AntMask
// ============================================================

/// 背景遮罩 — 全屏黑色半透明遮罩，常用于加载中、内容浮层背景。
///
/// 对齐 antd-mobile Mask：受控显隐（[visible]）、透明度与颜色可配、
/// 点击遮罩触发 [onAction]、上层可通过 [child] 叠加自定义内容。
class AntMask extends StatefulWidget {
  const AntMask({
    super.key,
    required this.visible,
    this.opacity = kAntMaskDefaultOpacity,
    this.color = kAntMaskDefaultColor,
    this.onAction,
    this.destroyOnClose = false,
    this.forceRender = false,
    this.child,
    this.fullScreen = true,
  });

  /// 是否显示遮罩（受控属性）。
  final bool visible;

  /// 遮罩透明度，默认 0.5。
  final double opacity;

  /// 遮罩颜色，默认黑色。
  final Color color;

  /// 点击遮罩时回调。
  final VoidCallback? onAction;

  /// 关闭时是否销毁上层内容（true 时隐藏后不保留 child 状态）。
  final bool destroyOnClose;

  /// 未显示时是否也渲染（简化实现：true 时隐藏但仍挂载）。
  final bool forceRender;

  /// 遮罩上层自定义内容（如 loading 组合）。
  final Widget? child;

  /// 是否全屏铺满，默认 true；false 时只覆盖父级区域。
  final bool fullScreen;

  @override
  State<AntMask> createState() => _AntMaskState();
}

class _AntMaskState extends State<AntMask> {
  /// 是否曾显示过（配合 destroyOnClose 控制内容销毁时机）。
  bool _everVisible = false;

  @override
  void initState() {
    super.initState();
    _everVisible = widget.visible;
  }

  @override
  void didUpdateWidget(covariant AntMask oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible) _everVisible = true;
  }

  /// 遮罩区域是否可点击触发 onAction。
  bool get _actionEnabled =>
      widget.visible && widget.onAction != null;

  @override
  Widget build(BuildContext context) {
    // 未显示且需销毁 / 未曾显示且非 forceRender：直接不挂载。
    final keepMounted = widget.forceRender ||
        (widget.destroyOnClose ? widget.visible : _everVisible);
    if (!keepMounted) return const SizedBox.shrink();

    final effectiveOpacity = widget.visible ? widget.opacity : 0.0;

    Widget mask = Positioned.fill(
      child: IgnorePointer(
        ignoring: !widget.visible,
        child: GestureDetector(
          key: kAntMaskKey,
          onTap: _actionEnabled ? widget.onAction : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            duration: kAntMaskAnimationDuration,
            opacity: effectiveOpacity,
            child: ColoredBox(color: widget.color),
          ),
        ),
      ),
    );

    final child = widget.child;
    return Stack(
      fit: StackFit.expand,
      children: [
        mask,
        if (child != null)
          Positioned.fill(
            child: IgnorePointer(
              // 上层内容区域保持可点击。
              ignoring: false,
              child: AnimatedOpacity(
                duration: kAntMaskAnimationDuration,
                opacity: widget.visible ? 1.0 : 0.0,
                child: child,
              ),
            ),
          ),
      ],
    );
  }
}
