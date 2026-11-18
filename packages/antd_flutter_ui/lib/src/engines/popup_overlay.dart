/// popup_engine 弹层基座 — Overlay 弹出定位 + 边界翻转 + 箭头渲染
///
/// 四大弹层组件（AntTooltip / AntPopover / AntPopconfirm / AntDropdown）共用的
/// 弹层底座：
/// - 位置决策走 [PopupEngine]（方向翻转 + 滑动夹回，算法吸收自 minikin/popover，MIT）
/// - 气泡尺寸实测后一帧校正（首帧按估算，post-frame 回调测量）
/// - 统一出现动画（fade + 朝触发元素方向 scale）
/// - 统一点击空白 / 外部关闭
/// - 统一箭头渲染（Positioned 于气泡边缘，tip 位置由引擎 clamp 防撞圆角）
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'popup_engine.dart';

/// 统一弹层基座。
///
/// 由各弹层组件在 OverlayEntry 中构造：
/// ```dart
/// AntPopupOverlay(
///   targetKey: _childKey,
///   placement: AntPopupPlacement.top,
///   arrow: true,
///   arrowColor: bgColor,
///   arrowKey: const Key('ant_tooltip_arrow'),
///   onDismiss: () => ...,
///   child: bubble,
/// )
/// ```
class AntPopupOverlay extends StatefulWidget {
  const AntPopupOverlay({
    super.key,
    required this.targetKey,
    required this.child,
    this.placement = AntPopupPlacement.bottom,
    this.arrow = false,
    this.arrowColor,
    this.arrowKey,
    this.arrowSize,
    this.gap,
    this.viewportPadding,
    this.onDismiss,
    this.dismissOnTapOutside = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  /// 触发元素的 GlobalKey（用于取全局矩形）。
  final GlobalKey targetKey;

  /// 气泡内容（不含箭头，箭头由基座渲染）。
  final Widget child;

  /// 首选弹出位置（边界放不下自动翻转）。
  final AntPopupPlacement placement;

  /// 是否渲染箭头。
  final bool arrow;

  /// 箭头颜色。
  final Color? arrowColor;

  /// 箭头定位 Key（供组件测试）。
  final Key? arrowKey;

  /// 箭头边长（默认 8 逻辑像素）。
  final double? arrowSize;

  /// 气泡与触发元素间距（默认 6）。
  final double? gap;

  /// 视口内边距（safe area 语义，默认 8）。
  final EdgeInsets? viewportPadding;

  /// 点击空白处回调。
  final VoidCallback? onDismiss;

  /// 是否启用点击气泡外关闭。
  final bool dismissOnTapOutside;

  /// 出现动画时长。
  final Duration animationDuration;

  @override
  State<AntPopupOverlay> createState() => _AntPopupOverlayState();
}

class _AntPopupOverlayState extends State<AntPopupOverlay>
    with SingleTickerProviderStateMixin {
  static const double _defaultArrowSize = 8;
  static const double _defaultGap = 6;

  /// 箭头旋转后突出气泡边缘的一半长度。
  static const double _arrowHalf = 4;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  final GlobalKey _bubbleKey = GlobalKey();
  Size? _bubbleSize;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetBox =
        widget.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null || !targetBox.hasSize) {
      return const SizedBox.expand();
    }
    final targetRect = targetBox.localToGlobal(Offset.zero) & targetBox.size;

    final mediaQuery = MediaQuery.of(context);
    final padding =
        widget.viewportPadding ?? const EdgeInsets.all(PopupEngine.defaultMargin);
    final viewport = _viewportRect(mediaQuery.padding + padding, mediaQuery.size);

    // 气泡尺寸：首帧用估算，post-frame 实测校正
    var bubbleSize = _bubbleSize ?? const Size(240, 80);
    if (_bubbleSize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final box = _bubbleKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null || !box.hasSize) return;
        if (_bubbleSize == null || box.size != _bubbleSize) {
          setState(() => _bubbleSize = box.size);
        }
      });
    }

    final layout = PopupEngine.solve(
      targetRect: targetRect,
      bubbleSize: bubbleSize,
      viewport: viewport,
      placement: widget.placement,
      gap: widget.gap ?? _defaultGap,
      arrowSize: widget.arrow ? (widget.arrowSize ?? _defaultArrowSize) : 0,
      margin: PopupEngine.defaultMargin,
    );

    final arrowLen = widget.arrowSize ?? _defaultArrowSize;

    return Stack(
      children: [
        if (widget.dismissOnTapOutside)
          GestureDetector(
            onTap: widget.onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        Positioned(
          left: layout.offset.dx,
          top: layout.offset.dy,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1).animate(_curve),
                alignment: Alignment(
                  layout.scaleAlignment.dx,
                  layout.scaleAlignment.dy,
                ),
                child: _buildBubbleWithArrow(layout, arrowLen),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubbleWithArrow(AntPopupLayout layout, double arrowLen) {
    final bubble = KeyedSubtree(
      key: _bubbleKey,
      child: widget.child,
    );

    if (!widget.arrow) return bubble;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        bubble,
        // 箭头按方向贴边：top→下缘 / bottom→上缘 / left→右缘 / right→左缘
        _positionedArrow(layout, arrowLen),
      ],
    );
  }

  /// 箭头：贴在气泡朝向触发元素的那条边上，tip 位置由引擎 clamp。
  Widget _positionedArrow(AntPopupLayout layout, double arrowLen) {
    final crossStart = layout.arrowOffset - _arrowHalf;

    final (left, right, top, bottom) = switch (layout.direction) {
      AntPopupDirection.top => (crossStart, null, null, -_arrowHalf),
      AntPopupDirection.bottom => (crossStart, null, -_arrowHalf, null),
      AntPopupDirection.left => (null, -_arrowHalf, crossStart, null),
      AntPopupDirection.right => (-_arrowHalf, null, crossStart, null),
    };

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          key: widget.arrowKey,
          width: arrowLen,
          height: arrowLen,
          decoration: BoxDecoration(
            color: widget.arrowColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// 受控 open 调度 mixin — show/hide 统一延迟到帧末。
///
/// 受控 `open` 切换通常由父级 `setState` 触发，发生在 build 阶段；
/// 直接调用 `Overlay.insert()` 会在 build 阶段 markNeedsBuild 报错，
/// 因此受控开关一律经 [schedulePopupOpen] 延迟到帧末执行。
mixin PopupOpenScheduler<T extends StatefulWidget> on State<T> {
  /// 帧末执行受控开关的 show/hide。
  void schedulePopupOpen({
    required bool open,
    required VoidCallback show,
    required VoidCallback hide,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (open) {
        show();
      } else {
        hide();
      }
    });
  }
}

/// 统一触发区域（点击 + 悬停 + 移动端 hover 降级）。
///
/// 用 [Listener] 而非 [GestureDetector] 检测点击：Listener 不参与手势竞技场，
/// 当触发元素是 AntButton 等自带手势识别的组件时，子组件手势仍正常生效，
/// 同时弹层触发不会被竞技场判负（GestureDetector 会被最内层识别器抢走 tap）。
///
/// 平台适配降级：移动端（Android/iOS/ohos）没有 hover 交互，
/// [hoverEnabled] 在移动端自动降级为点击触发（tap 开、点空白关）；
/// 桌面端 / Web 保持 hover。
class AntPopupTriggerRegion extends StatelessWidget {
  const AntPopupTriggerRegion({
    super.key,
    required this.child,
    this.onTap,
    this.tapEnabled = false,
    this.onHoverEnter,
    this.onHoverExit,
    this.hoverEnabled = false,
  });

  /// 触发元素。
  final Widget child;

  /// 点击（指针抬起）回调。
  final VoidCallback? onTap;

  /// 是否启用点击触发。
  final bool tapEnabled;

  /// 鼠标移入回调（仅 [hoverEnabled] 时接线）。
  final VoidCallback? onHoverEnter;

  /// 鼠标移出回调（仅 [hoverEnabled] 时接线）。
  final VoidCallback? onHoverExit;

  /// 是否启用悬停触发（移动端自动降级为点击）。
  final bool hoverEnabled;

  /// 悬停是否按鼠标交互生效（移动端降级为 false）。
  bool get _hoverActive => hoverEnabled && AntPlatform.isDesktop;

  /// 点击是否生效：click 触发，或移动端 hover 降级为点击。
  bool get _tapActive => tapEnabled || (hoverEnabled && !AntPlatform.isDesktop);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _hoverActive && onHoverEnter != null ? (_) => onHoverEnter!() : null,
      onExit: _hoverActive && onHoverExit != null ? (_) => onHoverExit!() : null,
      child: Listener(
        onPointerUp: _tapActive && onTap != null ? (_) => onTap!() : null,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}

/// 视口矩形：MediaQuery 尺寸扣除 safe area / 额外内边距。
Rect _viewportRect(EdgeInsets insets, Size mediaSize) {
  return Rect.fromLTRB(
    insets.left,
    insets.top,
    mediaSize.width - insets.right,
    mediaSize.height - insets.bottom,
  );
}
