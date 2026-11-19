/// overlay_shell — 模态弹层族统一基座（popup_engine 体系的锚点无关分支）
///
/// [AntPopupOverlay]/[PopupEngine]（popup_engine.dart / popup_overlay.dart）
/// 解决的是「有触发锚点」的气泡类弹层（方向决策 / 边界翻转 / 滑动夹回）；
/// 本文件承接的是**无触发锚点**的模态/浮层族（Dialog / Modal / Drawer /
/// Popup / ActionSheet / Toast 等屏级弹层），沉淀它们重复的手写逻辑：
/// - 遮罩层：淡入淡出 + 点击关闭（含 mask=false 时点击拦截的 translucent 分支）
/// - 动画：统一出现/退出动画（方向滑入或缩放淡入），退出播完再回调移除
/// - 生命周期：`open` 受控驱动（R35），false 时播放退出动画后回调 [AntOverlayShell.onExited]
/// - [AntPopupMotion]：单项出现动画（fade + slide/scale），供轻提示族
///   （Message / Notification）的堆叠项复用
///
/// 各弹层组件只保留面板内容构建，不再各自手写 AnimationController /
/// `_closing` 标记 / 遮罩 GestureDetector，实现弹层基座接入（迁移即改造 R30.2）。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 屏级弹层统一基座。
///
/// 由各弹层组件在 OverlayEntry 中构造：
/// ```dart
/// AntOverlayShell(
///   open: widget.visible,
///   alignment: Alignment.bottomCenter,
///   slideBegin: const Offset(0, 1),
///   onMaskTap: _handleClose,
///   onExited: _removeOverlay,
///   child: panel,
/// )
/// ```
class AntOverlayShell extends StatefulWidget {
  const AntOverlayShell({
    super.key,
    required this.open,
    required this.child,
    this.onExited,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.showMask = true,
    this.maskColor,
    this.maskClosable = true,
    this.interceptWithoutMask = false,
    this.interceptBehavior = HitTestBehavior.translucent,
    this.onMaskTap,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOut,
    this.slideBegin,
    this.scaleFrom = 0.92,
    this.maskKey,
    this.panelKey,
  });

  /// 受控显示状态（false 时播放退出动画，结束后回调 [onExited]）。
  final bool open;

  /// 面板内容。
  final Widget child;

  /// 退出动画播放完毕回调（组件在此移除 OverlayEntry）。
  final VoidCallback? onExited;

  /// 面板在屏内的对齐方式（居中 / 底部 / 四边等）。
  final Alignment alignment;

  /// 面板外边距（如 Modal 偏上展示的顶部留白）。
  final EdgeInsets padding;

  /// 是否渲染遮罩层。
  final bool showMask;

  /// 遮罩颜色（默认 antd 主题 colorBgMask）。
  final Color? maskColor;

  /// 遮罩点击是否触发 [onMaskTap]。
  final bool maskClosable;

  /// 无遮罩时是否仍用拦截层拦截点击（Toast maskClickable=false 语义）。
  final bool interceptWithoutMask;

  /// 拦截层的命中行为（translucent 由 Drawer 使用，opaque 由 Toast 使用）。
  final HitTestBehavior interceptBehavior;

  /// 遮罩（或拦截层）点击回调。
  final VoidCallback? onMaskTap;

  /// 出现/退出动画时长。
  final Duration duration;

  /// 动画曲线。
  final Curve curve;

  /// 方向滑入起始偏移（如底部面板 Offset(0, 1)）；
  /// null 时使用缩放淡入（[scaleFrom]）。
  final Offset? slideBegin;

  /// 缩放淡入的起始缩放（slideBegin 为 null 时生效）。
  final double scaleFrom;

  /// 遮罩定位 Key（供组件测试）。
  final Key? maskKey;

  /// 面板定位 Key（供组件测试）。
  final Key? panelKey;

  @override
  State<AntOverlayShell> createState() => _AntOverlayShellState();
}

class _AntOverlayShellState extends State<AntOverlayShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.duration,
  );

  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    if (widget.open) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AntOverlayShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open == oldWidget.open) return;
    if (widget.open) {
      _controller.forward();
    } else {
      _controller.reverse().whenComplete(() {
        if (mounted && !widget.open) widget.onExited?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Positioned.fill(
      child: Material(
        // transparency 类型不拦截命中（Toast 穿透语义）；模态族的点击
        // 拦截由遮罩/拦截层（GestureDetector）负责
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Stack(
          children: [
            // 遮罩（淡入淡出）；mask=false 时按需保留 translucent 点击拦截层。
            if (widget.showMask)
              Positioned.fill(
                child: FadeTransition(
                  opacity: _curve,
                  child: GestureDetector(
                    key: widget.maskKey,
                    onTap: widget.maskClosable ? widget.onMaskTap : null,
                    behavior: HitTestBehavior.opaque,
                    child: ColoredBox(
                      color: widget.maskColor ?? theme.colorBgMask,
                    ),
                  ),
                ),
              )
            else if (widget.interceptWithoutMask)
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.maskClosable ? widget.onMaskTap : null,
                  behavior: widget.interceptBehavior,
                  child: const SizedBox.expand(),
                ),
              ),
            // 面板（方向滑入或缩放淡入）
            Align(
              alignment: widget.alignment,
              child: Padding(
                padding: widget.padding,
                child: AntPopupMotion(
                  animation: _curve,
                  slideBegin: widget.slideBegin,
                  scaleFrom: widget.slideBegin == null ? widget.scaleFrom : null,
                  child: KeyedSubtree(
                    key: widget.panelKey,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 弹层单项出现动画 — fade + 方向滑入 / 缩放淡入。
///
/// 供 [AntOverlayShell] 内部使用，也供轻提示族（Message / Notification）
/// 堆叠项直接复用，统一各弹层的出现动画实现。
class AntPopupMotion extends StatelessWidget {
  const AntPopupMotion({
    super.key,
    required this.animation,
    required this.child,
    this.slideBegin,
    this.scaleFrom,
  });

  /// 动画进度（通常为 CurvedAnimation）。
  final Animation<double> animation;

  /// 内容。
  final Widget child;

  /// 方向滑入起始偏移；非 null 时优先于 [scaleFrom]。
  final Offset? slideBegin;

  /// 缩放淡入起始缩放。
  final double? scaleFrom;

  @override
  Widget build(BuildContext context) {
    Widget body = FadeTransition(opacity: animation, child: child);
    if (slideBegin != null) {
      body = SlideTransition(
        position:
            Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(animation),
        child: body,
      );
    } else if (scaleFrom != null) {
      body = ScaleTransition(
        scale: Tween<double>(begin: scaleFrom, end: 1).animate(animation),
        child: body,
      );
    }
    return body;
  }
}
