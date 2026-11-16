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
/// AntTour(
///   open: true,
///   steps: [
///     AntTourStep(target: key, title: '标题', description: '描述'),
///   ],
/// )
/// ```
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import '../../general/button/ant_button.dart';
import '../../general/button/ant_button_types.dart';
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
class AntTour extends StatefulWidget {
  const AntTour({
    super.key,
    required this.steps,
    this.open = false,
    this.current,
    this.placement = AntTourPlacement.bottomCenter,
    this.mask = true,
    this.arrow = true,
    this.maskClosable = false,
    this.onStepChange,
    this.onFinish,
    this.onClose,
  });

  /// 引导步骤集合。
  final List<AntTourStep> steps;

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

  /// 步骤变化回调（current 为当前步索引）。
  final ValueChanged<int>? onStepChange;

  /// 引导完成（最后一步点击完成）回调。
  final VoidCallback? onFinish;

  /// 引导关闭（跳过 / 点击遮罩关闭）回调。
  final VoidCallback? onClose;

  @override
  State<AntTour> createState() => _AntTourState();
}

class _AntTourState extends State<AntTour> {
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
  void didUpdateWidget(covariant AntTour oldWidget) {
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
      builder: (context) => _TourOverlay(
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

  void _handleSkip() {
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

class _TourOverlay extends StatelessWidget {
  const _TourOverlay({
    required this.tour,
    required this.themeData,
    required this.stepIndex,
    required this.onPrev,
    required this.onNext,
    required this.onSkip,
    required this.onMaskTap,
  });

  final AntTour tour;
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
    final targetRect = _resolveTargetRect(step);
    final showMask = step.mask ?? tour.mask;
    final showArrow = step.arrow ?? tour.arrow;
    final placement = step.placement ?? tour.placement;
    final effectivePlacement =
        targetRect == null ? AntTourPlacement.center : placement;

    final gap = 12.w;

    return Stack(
      children: [
        // 挖孔遮罩（拦截点击事件；mask=false 时无遮罩层）
        Positioned.fill(
          child: GestureDetector(
            onTap: onMaskTap,
            behavior: HitTestBehavior.opaque,
            child: showMask && targetRect != null
                ? CustomPaint(
                    key: kAntTourMaskKey,
                    painter: _TourMaskPainter(
                      holeRect: targetRect.deflate(-gap),
                      radius: themeData.borderRadiusLG.r,
                      color: themeData.colorBgMask,
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
                borderRadius: BorderRadius.circular(themeData.borderRadiusLG.r),
                border: Border.all(
                  color: themeData.colorPrimary,
                  width: themeData.lineWidth,
                ),
              ),
            ),
          ),
        // 引导卡片
        _TourCard(
          tour: tour,
          themeData: themeData,
          step: step,
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

  Rect? _resolveTargetRect(AntTourStep step) {
    final targetKey = step.target;
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
      Path.combine(PathOperation.difference, full, hole),
      Paint()..color = color,
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

class _TourCard extends StatefulWidget {
  const _TourCard({
    required this.tour,
    required this.themeData,
    required this.step,
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

  final AntTour tour;
  final AntThemeData themeData;
  final AntTourStep step;
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
  State<_TourCard> createState() => _TourCardState();
}

class _TourCardState extends State<_TourCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
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

  ({double left, double? top, double? bottom}) _resolvePosition(
    double cardW,
    double cardH,
  ) {
    final mediaH = widget.mediaSize.height;
    final mediaW = widget.mediaSize.width;
    final rect = widget.targetRect;
    final gap = widget.gap;

    // 无 target / center — 全屏居中
    if (rect == null || widget.placement == AntTourPlacement.center) {
      return (
        left: (mediaW - cardW) / 2,
        top: (mediaH - cardH) / 2,
        bottom: null,
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
    return (left: posLeft, top: posTop, bottom: posBottom);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final cardW = 280.w;
    if (_cardHeight <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = _cardKey.currentContext;
        final box = ctx?.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize && box.size.height != _cardHeight) {
          setState(() => _cardHeight = box.size.height);
        }
      });
      _cardHeight = 180.w; // 首帧估算
    }
    final pos = _resolvePosition(cardW, _cardHeight);

    final isLast = widget.stepIndex == widget.tour.steps.length - 1;
    final isFirst = widget.stepIndex == 0;

    final card = Container(
      key: _cardKey,
      width: cardW,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.15),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.step.cover != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.w),
              child: widget.step.cover!,
            ),
          if (widget.step.title != null)
            Text(
              widget.step.title!,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorTextHeading,
              ),
            ),
          if (widget.step.description != null)
            Padding(
              padding: EdgeInsets.only(top: 8.w),
              child: Text(
                widget.step.description!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorTextSecondary,
                ),
              ),
            ),
          SizedBox(height: 16.w),
          // 底部：步骤指示 + 操作按钮
          Row(
            children: [
              Text(
                '${widget.stepIndex + 1} / ${widget.tour.steps.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorTextSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                key: kAntTourSkipButtonKey,
                onPressed: widget.onSkip,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size(32.w, 32.w),
                ),
                child: Text(
                  kAntTourSkipLabel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
              if (!isFirst)
                TextButton(
                  key: kAntTourPrevButtonKey,
                  onPressed: widget.onPrev,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size(32.w, 32.w),
                  ),
                  child: Text(
                    kAntTourPrevLabel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorText,
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
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
                // 箭头指向目标元素
                if (widget.showArrow)
                  Positioned(
                    key: kAntTourArrowKey,
                    left: _arrowLeft(cardW),
                    top: _arrowTop,
                    bottom: _arrowBottom,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: theme.colorBgContainer,
                          borderRadius: BorderRadius.circular(2.r),
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

  /// 是否上方 placement（箭头在卡片底部外缘）。
  bool get _isTopPlacement => switch (widget.placement) {
        AntTourPlacement.topLeft ||
        AntTourPlacement.topCenter ||
        AntTourPlacement.topRight =>
          true,
        _ => false,
      };

  /// 箭头垂直位置：上方 placement 时贴卡片底部外侧，其余贴顶部外侧。
  double? get _arrowTop => _isTopPlacement ? null : -5.w;

  double? get _arrowBottom => _isTopPlacement ? -5.w : null;

  /// 箭头水平位置：对齐目标元素中心（越界时收敛到卡片边缘内）。
  double _arrowLeft(double cardW) {
    final rect = widget.targetRect;
    if (rect == null) return cardW / 2 - 5.w;
    final cardLeft = _resolvePosition(cardW, _cardHeight).left;
    final centerInCard = rect.center.dx - cardLeft;
    return centerInCard.clamp(12.0, cardW - 12.0) - 5.w;
  }
}
