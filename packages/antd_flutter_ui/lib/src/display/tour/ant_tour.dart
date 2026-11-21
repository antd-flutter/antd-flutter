/// AntTour — antd React Tour（漫游式引导）的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [steps] — 引导步骤集合
/// - [open] — 受控打开
/// - [current] — 受控当前步索引（非空时由外部控制）
/// - [mask] — 是否显示挖孔遮罩
/// - [arrow] — 是否显示箭头
/// - [maskClosable] — 点击遮罩是否可关闭
/// - [onStepChange] / [onFinish] / [onClose] — 步骤与关闭回调
///
/// ```dart
/// AntTour<TourStepModel>(
///   open: true,
///   steps: steps,
///   targetOf: (step) => step.key,
///   titleBuilder: (context, step, index) => Text(step.title),
///   descriptionBuilder: (context, step, index) => Text(step.description),
/// )
/// ```
///
/// R30.1 机制参考：[tutorial_coach_mark](https://pub.dev/packages/tutorial_coach_mark)
/// （MIT License）—— 挖孔遮罩 + 步骤引导流 + 内容自适应定位的实现思路，
/// 本组件为自绘实现，未引入三方依赖。
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../basic/button/ant_button.dart';
import '../../basic/button/ant_button_types.dart';
import 'ant_tour_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 遮罩标记 key，便于测试定位挖孔遮罩。
const Key kAntTourMaskKey = ValueKey<String>('AntTourMask');

/// 引导卡片标记 key，便于测试定位卡片。
const Key kAntTourCardKey = ValueKey<String>('AntTourCard');

/// 箭头标记 key，便于测试定位箭头。
const Key kAntTourArrowKey = ValueKey<String>('AntTourArrow');

/// 上一步按钮标记 key。
const Key kAntTourPrevButtonKey = ValueKey<String>('AntTourPrevButton');

/// 下一步/完成按钮标记 key。
const Key kAntTourNextButtonKey = ValueKey<String>('AntTourNextButton');

/// 跳过按钮标记 key。
const Key kAntTourSkipButtonKey = ValueKey<String>('AntTourSkipButton');

/// 上一步按钮文案。
const String kAntTourPrevLabel = '上一步';

/// 下一步按钮文案。
const String kAntTourNextLabel = '下一步';

/// 完成按钮文案。
const String kAntTourFinishLabel = '完成';

/// 跳过按钮文案。
const String kAntTourSkipLabel = '跳过';

// ============================================================
// AntTour
// ============================================================

/// 漫游式引导 — 分步引导用户了解产品功能的气泡卡片组件。
///
/// 对齐 antd React Tour 组件：支持 target 元素锚定、遮罩镂空高亮、
/// 多步导航（上一步/下一步/完成/跳过）、受控 open 与 current、
/// 每步独立 placement / mask / arrow 配置。
class AntTour<T> extends StatefulWidget {
  const AntTour({
    super.key,
    required this.steps,
    this.targetOf,
    this.titleBuilder,
    this.descriptionBuilder,
    this.coverBuilder,
    this.placementOf,
    this.maskOf,
    this.arrowOf,
    this.open = false,
    this.current,
    this.placement = AntTourPlacement.bottomCenter,
    this.mask = true,
    this.arrow = true,
    this.maskClosable = false,
    this.skipConfirm = false,
    this.skipConfirmTitle,
    this.stepTransitionDuration = const Duration(milliseconds: 300),
    this.adaptivePosition = true,
    this.onStepChange,
    this.onFinish,
    this.onClose,
  });

  /// 引导步骤集合（任意用户模型）。
  final List<T> steps;

  /// 目标元素提取器。
  final AntTourTargetOf<T>? targetOf;

  /// 步骤标题构建器。
  final AntTourTitleBuilder<T>? titleBuilder;

  /// 步骤描述构建器。
  final AntTourDescriptionBuilder<T>? descriptionBuilder;

  /// 步骤封面构建器。
  final AntTourCoverBuilder<T>? coverBuilder;

  /// 步骤位置提取器。
  final AntTourPlacementOf<T>? placementOf;

  /// 步骤遮罩开关提取器。
  final AntTourMaskOf<T>? maskOf;

  /// 步骤箭头开关提取器。
  final AntTourArrowOf<T>? arrowOf;

  /// 受控打开状态。
  final bool open;

  /// 受控当前步索引（非空时由外部控制步进）。
  final int? current;

  /// 默认引导卡片位置。
  final AntTourPlacement placement;

  /// 是否显示挖孔遮罩。
  final bool mask;

  /// 是否显示箭头。
  final bool arrow;

  /// 点击遮罩是否可关闭引导。
  final bool maskClosable;

  /// 跳过前是否弹出确认弹窗（参考 tutorial_coach_mark 的 onSkip 确认机制）。
  ///
  /// 为 true 时点击「跳过」先展示确认对话框，确认后才触发 [onClose]。
  /// 默认 false，保持既有行为。
  final bool skipConfirm;

  /// 跳过确认弹窗标题（[skipConfirm] 为 true 时生效）。
  final String? skipConfirmTitle;

  /// 步骤间过渡动画时长（挖孔位移 + 卡片重入场）。
  ///
  /// 参考 tutorial_coach_mark 的 focusAnimationDuration，默认 300ms。
  /// 传 [Duration.zero] 关闭步骤间过渡动画。
  final Duration stepTransitionDuration;

  /// 内容定位自适应翻转（参考 tutorial_coach_mark 的内容避让机制）。
  ///
  /// 为 true（默认）时，目标一侧空间不足会把卡片翻到另一侧
  /// （空间更大的一侧），左右都放不下时回退到目标下方 / 屏幕居中，
  /// 避免卡片遮住目标或出屏；为 false 时保持请求的 placement 不翻转。
  final bool adaptivePosition;

  /// 步骤变化回调（current 为当前步索引）。
  final ValueChanged<int>? onStepChange;

  /// 引导完成（最后一步点击完成）回调。
  final VoidCallback? onFinish;

  /// 引导关闭（跳过 / 点击遮罩关闭）回调。
  final VoidCallback? onClose;

  @override
  State<AntTour<T>> createState() => _AntTourState<T>();
}

class _AntTourState<T> extends State<AntTour<T>> {
  OverlayEntry? _overlayEntry;
  int _internalIndex = 0;

  int get _effectiveIndex =>
      (widget.current ?? _internalIndex).clamp(0, widget.steps.length - 1);

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntTour<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
      } else {
        _hideOverlay();
      }
      return;
    }
    // 步骤/样式/受控索引变化时刷新已打开的浮层（延迟到帧末避免 build 期 markNeedsBuild）
    if (_overlayEntry != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _overlayEntry != null) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || widget.steps.isEmpty) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _TourOverlay<T>(
        tour: widget,
        themeData: theme,
        stepIndex: _effectiveIndex,
        onPrev: _goPrev,
        onNext: _goNext,
        onSkip: _handleSkip,
        onMaskTap: _handleMaskTap,
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  void _goPrev() {
    final target = _effectiveIndex - 1;
    if (target < 0) return;
    _moveTo(target);
  }

  void _goNext() {
    if (_effectiveIndex >= widget.steps.length - 1) {
      widget.onFinish?.call();
      _hideOverlay();
      return;
    }
    _moveTo(_effectiveIndex + 1);
  }

  void _moveTo(int index) {
    if (widget.current == null) {
      _internalIndex = index;
      setState(() {});
    }
    widget.onStepChange?.call(index);
    _overlayEntry?.markNeedsBuild();
  }

  /// 跳过（[skipConfirm] 为 true 时先弹确认框，参考 tutorial_coach_mark）。
  Future<void> _handleSkip() async {
    if (widget.skipConfirm && mounted && context.mounted) {
      // 引导浮层位于根 Overlay 顶端，会挡住后弹的对话框路由，
      // 确认期间先移除浮层，取消时再恢复。
      final entry = _overlayEntry;
      if (entry != null) {
        entry.remove();
        _overlayEntry = null;
      }
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(widget.skipConfirmTitle ?? '确定要结束引导吗？'),
          actions: [
            AntButton(
              type: AntButtonType.text,
              onTap: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            AntButton(
              type: AntButtonType.text,
              onTap: () => Navigator.of(dialogContext).pop(true),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      if (!mounted || entry == null) return;
      if (confirmed != true) {
        // 取消 → 恢复引导浮层
        _overlayEntry = entry;
        Overlay.of(context, rootOverlay: true).insert(entry);
        return;
      }
    }
    if (!mounted) return;
    widget.onClose?.call();
    _hideOverlay();
  }

  void _handleMaskTap() {
    if (!widget.maskClosable) return;
    widget.onClose?.call();
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    // 引导浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _TourOverlay — 引导浮层（遮罩 + 高亮 + 卡片）
// ============================================================

class _TourOverlay<T> extends StatelessWidget {
  const _TourOverlay({
    required this.tour,
    required this.themeData,
    required this.stepIndex,
    required this.onPrev,
    required this.onNext,
    required this.onSkip,
    required this.onMaskTap,
  });

  final AntTour<T> tour;
  final AntThemeData themeData;
  final int stepIndex;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onMaskTap;

  @override
  Widget build(BuildContext context) {
    final step = tour.steps[stepIndex];
    final mediaSize = MediaQuery.sizeOf(context);
    final targetRect = _resolveTargetRect(tour.targetOf?.call(step));
    final showMask = tour.maskOf?.call(step) ?? tour.mask;
    final showArrow = tour.arrowOf?.call(step) ?? tour.arrow;
    final placement = tour.placementOf?.call(step) ?? tour.placement;
    final title = tour.titleBuilder?.call(context, step, stepIndex);
    final description = tour.descriptionBuilder?.call(context, step, stepIndex);
    final cover = tour.coverBuilder?.call(context, step);
    final effectivePlacement =
        targetRect == null ? AntTourPlacement.center : placement;

    final gap = themeData.s(12);
    final holeRect = targetRect?.deflate(-gap);
    final transition = tour.stepTransitionDuration;

    return Stack(
      children: [
        // 挖孔遮罩（拦截点击事件；mask=false 时无遮罩层）。
        // 挖孔区域用 TweenAnimationBuilder 在步骤切换时平滑位移（R30.1）。
        Positioned.fill(
          child: GestureDetector(
            onTap: onMaskTap,
            behavior: HitTestBehavior.opaque,
            child: showMask && holeRect != null
                ? TweenAnimationBuilder<Rect?>(
                    tween: RectTween(begin: holeRect, end: holeRect),
                    duration: transition,
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedRect, _) => CustomPaint(
                      key: kAntTourMaskKey,
                      painter: _TourMaskPainter(
                        holeRect: animatedRect ?? holeRect,
                        radius: themeData.borderRadiusLG,
                        color: themeData.colorBgMask,
                      ),
                    ),
                  )
                : showMask
                    ? ColoredBox(
                        key: kAntTourMaskKey,
                        color: themeData.colorBgMask,
                      )
                    : const SizedBox.expand(),
          ),
        ),
        // 高亮描边
        if (targetRect != null)
          Positioned(
            left: targetRect.left - gap,
            top: targetRect.top - gap,
            child: Container(
              width: targetRect.width + gap * 2,
              height: targetRect.height + gap * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(themeData.borderRadiusLG),
                border: Border.all(
                  color: themeData.colorPrimary,
                  width: themeData.lineWidth,
                ),
              ),
            ),
          ),
        // 引导卡片
        _TourCard<T>(
          tour: tour,
          themeData: themeData,
          title: title,
          description: description,
          cover: cover,
          stepIndex: stepIndex,
          targetRect: targetRect,
          placement: effectivePlacement,
          showArrow: showArrow && targetRect != null,
          gap: gap,
          mediaSize: mediaSize,
          onPrev: onPrev,
          onNext: onNext,
          onSkip: onSkip,
        ),
      ],
    );
  }

  Rect? _resolveTargetRect(GlobalKey? targetKey) {
    if (targetKey == null) return null;
    final ctx = targetKey.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final pos = box.localToGlobal(Offset.zero);
    return pos & box.size;
  }
}

// ============================================================
// _TourMaskPainter — 挖孔遮罩画笔
// ============================================================

/// 全屏遮罩 + 圆角矩形镂空的画笔。
class _TourMaskPainter extends CustomPainter {
  const _TourMaskPainter({
    required this.holeRect,
    required this.radius,
    required this.color,
  });

  /// 镂空区域（已含间距）。
  final Rect holeRect;

  /// 镂空圆角。
  final double radius;

  /// 遮罩颜色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(holeRect, Radius.circular(radius)),
      );
    canvas.drawPath(
      // 抗锯齿保证挖孔边缘圆角平滑（R30.1 参考 tutorial_coach_mark）。
      Path.combine(PathOperation.difference, full, hole),
      Paint()
        ..color = color
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _TourMaskPainter oldDelegate) {
    return oldDelegate.holeRect != holeRect ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}

// ============================================================
// _TourCard — 引导卡片（动画 + 定位 + 内容）
// ============================================================

/// 引导卡片解析后的定位与生效位置（含自适应翻转结果）。
typedef _TourCardPos = ({
  double left,
  double? top,
  double? bottom,
  AntTourPlacement placement,
});

class _TourCard<T> extends StatefulWidget {
  const _TourCard({
    required this.tour,
    required this.themeData,
    required this.title,
    required this.description,
    required this.cover,
    required this.stepIndex,
    required this.targetRect,
    required this.placement,
    required this.showArrow,
    required this.gap,
    required this.mediaSize,
    required this.onPrev,
    required this.onNext,
    required this.onSkip,
  });

  final AntTour<T> tour;
  final AntThemeData themeData;
  final Widget? title;
  final Widget? description;
  final Widget? cover;
  final int stepIndex;
  final Rect? targetRect;
  final AntTourPlacement placement;
  final bool showArrow;
  final double gap;
  final Size mediaSize;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<_TourCard<T>> createState() => _TourCardState<T>();
}

class _TourCardState<T> extends State<_TourCard<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.tour.stepTransitionDuration == Duration.zero
        ? const Duration(milliseconds: 200)
        : widget.tour.stepTransitionDuration,
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  final GlobalKey _cardKey = GlobalKey();
  double _cardHeight = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _TourCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 步骤切换时重放入场动画（R30.1 参考 tutorial_coach_mark 的步骤过渡）。
    if (widget.stepIndex != oldWidget.stepIndex &&
        widget.tour.stepTransitionDuration > Duration.zero) {
      _controller.forward(from: 0);
    }
  }

  _TourCardPos _resolvePosition(double cardW, double cardH) {
    final mediaH = widget.mediaSize.height;
    final mediaW = widget.mediaSize.width;
    final rect = widget.targetRect;
    final gap = widget.gap;
    final adaptive = widget.tour.adaptivePosition;

    // 无 target / center — 全屏居中
    if (rect == null || widget.placement == AntTourPlacement.center) {
      return (
        left: (mediaW - cardW) / 2,
        top: (mediaH - cardH) / 2,
        bottom: null,
        placement: AntTourPlacement.center,
      );
    }

    final left = rect.left;
    final top = rect.top;
    final bottom = rect.bottom;
    final right = rect.right;
    final centerX = rect.center.dx;
    final centerY = rect.center.dy;

    double posLeft;
    double? posTop;
    double? posBottom;
    AntTourPlacement effective = widget.placement;
    switch (widget.placement) {
      case AntTourPlacement.topLeft:
      case AntTourPlacement.topCenter:
      case AntTourPlacement.topRight:
        posBottom = mediaH - top + gap;
        posLeft = switch (widget.placement) {
          AntTourPlacement.topLeft => left,
          AntTourPlacement.topRight => right - cardW,
          _ => centerX - cardW / 2,
        };
        break;
      case AntTourPlacement.bottomLeft:
      case AntTourPlacement.bottomCenter:
      case AntTourPlacement.bottomRight:
        posTop = bottom + gap;
        posLeft = switch (widget.placement) {
          AntTourPlacement.bottomLeft => left,
          AntTourPlacement.bottomRight => right - cardW,
          _ => centerX - cardW / 2,
        };
        break;
      case AntTourPlacement.leftTop:
      case AntTourPlacement.leftCenter:
      case AntTourPlacement.leftBottom:
        posLeft = left - gap - cardW;
        posTop = switch (widget.placement) {
          AntTourPlacement.leftTop => top,
          AntTourPlacement.leftBottom => bottom - cardH,
          _ => centerY - cardH / 2,
        };
        break;
      case AntTourPlacement.rightTop:
      case AntTourPlacement.rightCenter:
      case AntTourPlacement.rightBottom:
        posLeft = right + gap;
        posTop = switch (widget.placement) {
          AntTourPlacement.rightTop => top,
          AntTourPlacement.rightBottom => bottom - cardH,
          _ => centerY - cardH / 2,
        };
        break;
      case AntTourPlacement.center:
        posLeft = (mediaW - cardW) / 2;
        posTop = (mediaH - cardH) / 2;
        break;
    }

    // 边界保护
    posLeft = posLeft.clamp(8.0, math.max(8.0, mediaW - cardW - 8.0));
    if (posTop != null) {
      posTop = posTop.clamp(8.0, math.max(8.0, mediaH - cardH - 8.0));
    }
    if (posBottom != null) {
      posBottom = math.max(8.0, posBottom);
    }

    // 自适应翻转（R30.1 参考 tutorial_coach_mark 的内容定位避让）：
    // 请求侧空间不足时翻到空间更大的另一侧；两侧都放不下时回退
    // 到目标下方，最后回退屏幕居中，保证箭头始终指向挖孔方向。
    final spaceAbove = top - gap;
    final spaceBelow = mediaH - (bottom + gap);
    final spaceLeft = left - gap;
    final spaceRight = mediaW - (right + gap);
    final verticalFit = cardH + 8.0;
    final horizontalFit = cardW + 8.0;

    if (adaptive) {
      final isTop = switch (effective) {
        AntTourPlacement.topLeft ||
        AntTourPlacement.topCenter ||
        AntTourPlacement.topRight =>
          true,
        _ => false,
      };
      final isBottom = switch (effective) {
        AntTourPlacement.bottomLeft ||
        AntTourPlacement.bottomCenter ||
        AntTourPlacement.bottomRight =>
          true,
        _ => false,
      };
      final isLeft = switch (effective) {
        AntTourPlacement.leftTop ||
        AntTourPlacement.leftCenter ||
        AntTourPlacement.leftBottom =>
          true,
        _ => false,
      };
      final isRight = switch (effective) {
        AntTourPlacement.rightTop ||
        AntTourPlacement.rightCenter ||
        AntTourPlacement.rightBottom =>
          true,
        _ => false,
      };

      if (isTop && spaceAbove < verticalFit) {
        // 上方放不下 → 翻到下方；下方也放不下 → 屏幕居中
        if (spaceBelow >= verticalFit) {
          effective = switch (effective) {
            AntTourPlacement.topLeft => AntTourPlacement.bottomLeft,
            AntTourPlacement.topRight => AntTourPlacement.bottomRight,
            _ => AntTourPlacement.bottomCenter,
          };
          posTop = bottom + gap;
          posTop = posTop.clamp(8.0, math.max(8.0, mediaH - cardH - 8.0));
          posBottom = null;
        } else {
          effective = AntTourPlacement.center;
          posLeft = (mediaW - cardW) / 2;
          posTop = (mediaH - cardH) / 2;
          posBottom = null;
        }
        return (
          left: posLeft,
          top: posTop,
          bottom: posBottom,
          placement: effective
        );
      }
      if (isBottom && spaceBelow < verticalFit) {
        // 下方放不下 → 上方够则翻上去，否则屏幕居中
        if (spaceAbove >= verticalFit) {
          effective = switch (effective) {
            AntTourPlacement.bottomLeft => AntTourPlacement.topLeft,
            AntTourPlacement.bottomRight => AntTourPlacement.topRight,
            _ => AntTourPlacement.topCenter,
          };
          posBottom = mediaH - top + gap;
          posBottom = math.max(8.0, posBottom);
          posTop = null;
        } else {
          effective = AntTourPlacement.center;
          posLeft = (mediaW - cardW) / 2;
          posTop = (mediaH - cardH) / 2;
          posBottom = null;
        }
        return (
          left: posLeft,
          top: posTop,
          bottom: posBottom,
          placement: effective
        );
      }
      if (isLeft && spaceLeft < horizontalFit) {
        // 左侧放不下 → 翻到右侧；右侧也放不下 → 退到目标下方
        if (spaceRight >= horizontalFit) {
          effective = switch (effective) {
            AntTourPlacement.leftTop => AntTourPlacement.rightTop,
            AntTourPlacement.leftBottom => AntTourPlacement.rightBottom,
            _ => AntTourPlacement.rightCenter,
          };
          posLeft = right + gap;
          posLeft = posLeft.clamp(8.0, math.max(8.0, mediaW - cardW - 8.0));
        } else if (spaceBelow >= verticalFit) {
          effective = AntTourPlacement.bottomCenter;
          posLeft = centerX - cardW / 2;
          posLeft = posLeft.clamp(8.0, math.max(8.0, mediaW - cardW - 8.0));
          posTop = bottom + gap;
          posTop = posTop.clamp(8.0, math.max(8.0, mediaH - cardH - 8.0));
          posBottom = null;
        } else {
          effective = AntTourPlacement.center;
          posLeft = (mediaW - cardW) / 2;
          posTop = (mediaH - cardH) / 2;
          posBottom = null;
        }
        return (
          left: posLeft,
          top: posTop,
          bottom: posBottom,
          placement: effective
        );
      }
      if (isRight && spaceRight < horizontalFit) {
        // 右侧放不下 → 翻到左侧；左侧也放不下 → 退到目标下方
        if (spaceLeft >= horizontalFit) {
          effective = switch (effective) {
            AntTourPlacement.rightTop => AntTourPlacement.leftTop,
            AntTourPlacement.rightBottom => AntTourPlacement.leftBottom,
            _ => AntTourPlacement.leftCenter,
          };
          posLeft = left - gap - cardW;
          posLeft = posLeft.clamp(8.0, math.max(8.0, mediaW - cardW - 8.0));
        } else if (spaceBelow >= verticalFit) {
          effective = AntTourPlacement.bottomCenter;
          posLeft = centerX - cardW / 2;
          posLeft = posLeft.clamp(8.0, math.max(8.0, mediaW - cardW - 8.0));
          posTop = bottom + gap;
          posTop = posTop.clamp(8.0, math.max(8.0, mediaH - cardH - 8.0));
          posBottom = null;
        } else {
          effective = AntTourPlacement.center;
          posLeft = (mediaW - cardW) / 2;
          posTop = (mediaH - cardH) / 2;
          posBottom = null;
        }
        return (
          left: posLeft,
          top: posTop,
          bottom: posBottom,
          placement: effective
        );
      }
    }

    return (
      left: posLeft,
      top: posTop,
      bottom: posBottom,
      placement: effective,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final cardW = theme.s(280);
    if (_cardHeight <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = _cardKey.currentContext;
        final box = ctx?.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize && box.size.height != _cardHeight) {
          setState(() => _cardHeight = box.size.height);
        }
      });
      _cardHeight = theme.s(180); // 首帧估算
    }
    final pos = _resolvePosition(cardW, _cardHeight);

    final isLast = widget.stepIndex == widget.tour.steps.length - 1;
    final isFirst = widget.stepIndex == 0;

    final card = Container(
      key: _cardKey,
      width: cardW,
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.15),
            blurRadius: theme.s(16),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.cover != null)
            Padding(
              padding: EdgeInsets.only(bottom: theme.s(8)),
              child: DefaultTextStyle.merge(
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
                child: widget.cover!,
              ),
            ),
          if (widget.title != null)
            DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: theme.s(16),
                fontWeight: FontWeight.w600,
                color: theme.colorTextHeading,
              ),
              child: widget.title!,
            ),
          if (widget.description != null)
            Padding(
              padding: EdgeInsets.only(top: theme.s(8)),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: theme.s(14),
                  color: theme.colorTextSecondary,
                ),
                child: widget.description!,
              ),
            ),
          SizedBox(height: theme.s(16)),
          // 底部：步骤指示 + 操作按钮
          Row(
            children: [
              Text(
                '${widget.stepIndex + 1} / ${widget.tour.steps.length}',
                style: TextStyle(
                  fontSize: theme.s(14),
                  color: theme.colorTextSecondary,
                ),
              ),
              const Spacer(),
              AntButton(
                key: kAntTourSkipButtonKey,
                type: AntButtonType.text,
                size: AntButtonSize.small,
                onTap: widget.onSkip,
                child: Text(
                  kAntTourSkipLabel,
                  style: TextStyle(
                    fontSize: theme.s(14),
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
              if (!isFirst)
                AntButton(
                  key: kAntTourPrevButtonKey,
                  type: AntButtonType.text,
                  size: AntButtonSize.small,
                  onTap: widget.onPrev,
                  child: Text(
                    kAntTourPrevLabel,
                    style: TextStyle(
                      fontSize: theme.s(14),
                      color: theme.colorText,
                    ),
                  ),
                ),
              SizedBox(width: theme.s(8)),
              AntButton(
                key: kAntTourNextButtonKey,
                type: AntButtonType.primary,
                size: AntButtonSize.small,
                onTap: widget.onNext,
                child: Text(isLast ? kAntTourFinishLabel : kAntTourNextLabel),
              ),
            ],
          ),
        ],
      ),
    );

    return Positioned(
      left: pos.left,
      top: pos.top,
      bottom: pos.bottom,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(_curve),
            alignment: Alignment.topCenter,
            child: Stack(
              key: kAntTourCardKey,
              clipBehavior: Clip.none,
              children: [
                card,
                // 箭头指向目标元素：边随实际生效位置（翻转后），
                // tip 落在挖孔中心线上（clamp 不出卡片边界）
                if (widget.showArrow &&
                    pos.placement != AntTourPlacement.center)
                  Positioned(
                    key: kAntTourArrowKey,
                    left: _arrowLeft(cardW, pos),
                    top: _arrowTop(pos),
                    right: _arrowRight(pos),
                    bottom: _arrowBottom(pos),
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: theme.s(10),
                        height: theme.s(10),
                        decoration: BoxDecoration(
                          color: theme.colorBgContainer,
                          borderRadius: BorderRadius.circular(theme.s(2)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 箭头定位：按生效 placement 选择卡片边，指向挖孔 ──

  /// 卡片是否在目标上方（箭头贴卡片底边向下指挖孔）。
  bool _isTopPlacement(AntTourPlacement placement) => switch (placement) {
        AntTourPlacement.topLeft ||
        AntTourPlacement.topCenter ||
        AntTourPlacement.topRight =>
          true,
        _ => false,
      };

  /// 卡片是否在目标左侧（箭头贴卡片右边缘向右指挖孔）。
  bool _isLeftPlacement(AntTourPlacement placement) => switch (placement) {
        AntTourPlacement.leftTop ||
        AntTourPlacement.leftCenter ||
        AntTourPlacement.leftBottom =>
          true,
        _ => false,
      };

  /// 卡片是否在目标右侧（箭头贴卡片左边缘向左指挖孔）。
  bool _isRightPlacement(AntTourPlacement placement) => switch (placement) {
        AntTourPlacement.rightTop ||
        AntTourPlacement.rightCenter ||
        AntTourPlacement.rightBottom =>
          true,
        _ => false,
      };

  /// 箭头垂直位置：
  /// - 卡片在目标下方 → 箭头贴卡片顶边外侧（向上指）
  /// - 卡片在目标上方 → 箭头贴卡片底边外侧（向下指）
  /// - 左右 placement → 箭头对齐挖孔中心 y（clamp 在卡片内）
  double? _arrowTop(_TourCardPos pos) {
    if (_isTopPlacement(pos.placement)) return null;
    if (_isLeftPlacement(pos.placement) || _isRightPlacement(pos.placement)) {
      return _arrowCenterYInCard(pos) - widget.themeData.s(5);
    }
    return -widget.themeData.s(5);
  }

  double? _arrowBottom(_TourCardPos pos) {
    return _isTopPlacement(pos.placement) ? -widget.themeData.s(5) : null;
  }

  double? _arrowRight(_TourCardPos pos) {
    // 卡片在目标左侧 → 箭头贴卡片右边缘外侧（向右指）
    return _isLeftPlacement(pos.placement) ? -widget.themeData.s(5) : null;
  }

  /// 箭头水平位置：
  /// - 卡片在目标右侧 → 箭头贴卡片左边缘（left: -widget.themeData.s(5)）
  /// - 卡片在目标左侧 → left 置 null（由 right: -widget.themeData.s(5) 锚定右边缘）
  /// - 其余 → 对齐挖孔中心 x（clamp 不出卡片边界）
  double? _arrowLeft(double cardW, _TourCardPos pos) {
    if (_isLeftPlacement(pos.placement)) return null;
    if (_isRightPlacement(pos.placement)) return -widget.themeData.s(5);
    final rect = widget.targetRect;
    if (rect == null) return cardW / 2 - widget.themeData.s(5);
    final centerInCard = rect.center.dx - pos.left;
    return centerInCard.clamp(12.0, cardW - 12.0) - widget.themeData.s(5);
  }

  /// 挖孔中心 y 相对卡片顶部的偏移（clamp 在卡片内）。
  double _arrowCenterYInCard(_TourCardPos pos) {
    final rect = widget.targetRect;
    if (rect == null) return _cardHeight / 2 - widget.themeData.s(5);
    final cardTop =
        pos.top ?? widget.mediaSize.height - (pos.bottom ?? 0) - _cardHeight;
    final centerInCard = rect.center.dy - cardTop;
    return centerInCard.clamp(12.0, math.max(12.0, _cardHeight - 12.0));
  }
}
