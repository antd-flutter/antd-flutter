/// AntNoticeBar — antd-mobile NoticeBar 通告栏的 Flutter 实现
///
/// API 与 antd-mobile 对齐：
/// - [content] — 公告内容（超长自动横向滚动）
/// - [color] — 语义颜色（normal/alert/error/info/success）
/// - [closeable] / [closeIcon] / [onClose] — 可关闭通告栏
/// - [icon] — 左侧图标（默认喇叭）
/// - [extra] — 右侧额外操作区
/// - [wrap] — 多行展示（关闭滚动）
/// - [shape] — 形状（rectangular/neutral/rounded）
/// - [bordered] — 边框模式（block/full/none）
/// - [delay] / [speed] — 滚动延迟与速度
///
/// 尺寸令牌：height = controlHeightLG，fontSize = fontSize，
/// iconSize = fontSizeIcon × 1.5，padding = paddingSM/paddingXS。
library;

import 'dart:async';

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_notice_bar_types.dart';

// ============================================================
// 内部：尺寸与颜色解析
// ============================================================

/// 通告栏尺寸解析结果（已含 screenutil 缩放）。
class _NoticeBarMetrics {
  const _NoticeBarMetrics({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.closeIconSize,
    required this.closeHitSize,
    required this.horizontalPadding,
    required this.wrapVerticalPadding,
    required this.iconGap,
    required this.rightGap,
    required this.borderWidth,
    required this.neutralRadius,
    required this.roundedRadius,
  });

  /// 整体高度（= controlHeightLG = 40）。
  final double height;

  /// 文字字号（= fontSize = 14）。
  final double fontSize;

  /// 左侧图标尺寸（= fontSizeIcon × 1.5 = 18）。
  final double iconSize;

  /// 关闭图标尺寸（= fontSizeIcon × 1.5 = 18）。
  final double closeIconSize;

  /// 关闭按钮点击区域（24 × 24）。
  final double closeHitSize;

  /// 水平内边距（= paddingSM = 12）。
  final double horizontalPadding;

  /// wrap 模式垂直内边距（= paddingXS = 8）。
  final double wrapVerticalPadding;

  /// 左侧图标与内容间距（= paddingXS = 8）。
  final double iconGap;

  /// 右侧区域与内容间距（= paddingSM = 12）。
  final double rightGap;

  /// 边框宽度（= lineWidth = 1）。
  final double borderWidth;

  /// neutral 形状圆角（= borderRadiusSM = 4）。
  final double neutralRadius;

  /// rounded 形状圆角（= height / 2，胶囊形）。
  final double roundedRadius;

  factory _NoticeBarMetrics.of(AntThemeData t) {
    final rawHeight = t.controlHeightLG;
    return _NoticeBarMetrics(
      height: rawHeight.w,
      fontSize: t.fontSize.sp,
      iconSize: (t.fontSizeIcon * 1.5).sp,
      closeIconSize: (t.fontSizeIcon * 1.5).sp,
      closeHitSize: (t.fontSizeIcon * 2).w,
      horizontalPadding: t.paddingSM.w,
      wrapVerticalPadding: t.paddingXS.w,
      iconGap: t.paddingXS.w,
      rightGap: t.paddingSM.w,
      borderWidth: t.lineWidth.w,
      neutralRadius: t.borderRadiusSM.r,
      roundedRadius: rawHeight.w / 2,
    );
  }
}

/// 通告栏某一语义类型的颜色组。
class _NoticeBarColors {
  const _NoticeBarColors({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;
}

/// 解析通告栏颜色（与 antd-mobile notice-bar 样式对齐）。
_NoticeBarColors _resolveColors(AntNoticeBarColor color, AntThemeData t) {
  switch (color) {
    case AntNoticeBarColor.normal:
      return _NoticeBarColors(
        background: t.colorFillContent,
        text: t.colorWhite,
        border: t.colorFillContent,
      );
    case AntNoticeBarColor.alert:
      return _NoticeBarColors(
        background: t.colorWarningBg,
        text: t.colorWarning,
        border: t.colorWarningBorder,
      );
    case AntNoticeBarColor.error:
      return _NoticeBarColors(
        background: t.colorError,
        text: t.colorWhite,
        border: t.colorErrorBorder,
      );
    case AntNoticeBarColor.info:
      return _NoticeBarColors(
        background: t.colorInfoBg,
        text: t.colorPrimary,
        border: t.colorInfoBorder,
      );
    case AntNoticeBarColor.success:
      return _NoticeBarColors(
        background: t.colorSuccessBg,
        text: t.colorSuccess,
        border: t.colorSuccessBorder,
      );
  }
}

// ============================================================
// AntNoticeBar
// ============================================================

/// 通告栏 — 展示一组消息通知。
///
/// 适用于当前页面内信息的通知，是一种较醒目的页面内通知方式。
/// 超长内容自动横向滚动（[delay] 后开始，[speed] 控制速度）。
///
/// ```dart
/// AntNoticeBar(content: '这是一条通告信息')
/// ```
class AntNoticeBar extends StatefulWidget {
  const AntNoticeBar({
    super.key,
    this.content = '',
    this.contentWidget,
    this.color = AntNoticeBarColor.normal,
    this.delay = 2000,
    this.speed = 50,
    this.closeable = false,
    this.closeIcon,
    this.onClose,
    this.onClick,
    this.extra,
    this.icon,
    this.wrap = false,
    this.shape = AntNoticeBarShape.rectangular,
    this.bordered = AntNoticeBarBorder.block,
  });

  /// 公告文本内容。超长时自动横向滚动（除非 [wrap] 或 [contentWidget]）。
  final String content;

  /// 自定义内容 Widget。提供时优先于 [content]，且不启用滚动。
  final Widget? contentWidget;

  /// 语义颜色类型。
  final AntNoticeBarColor color;

  /// 开始滚动的延迟，单位毫秒。
  final int delay;

  /// 滚动速度，单位 px/s。
  final double speed;

  /// 是否可关闭。
  final bool closeable;

  /// 自定义关闭按钮图标。
  final Widget? closeIcon;

  /// 关闭时的回调。
  final VoidCallback? onClose;

  /// 点击事件。
  final VoidCallback? onClick;

  /// 额外操作区域，显示在关闭按钮左侧。
  final Widget? extra;

  /// 左侧图标，默认为喇叭图标。
  /// 传 [SizedBox.shrink] 可隐藏。
  final Widget? icon;

  /// 是否多行展示（关闭滚动）。
  final bool wrap;

  /// 形状。
  final AntNoticeBarShape shape;

  /// 边框模式。
  final AntNoticeBarBorder bordered;

  @override
  State<AntNoticeBar> createState() => _AntNoticeBarState();
}

class _AntNoticeBarState extends State<AntNoticeBar> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final theme = AntTheme.of(context);
    final metrics = _NoticeBarMetrics.of(theme);
    final colors = _resolveColors(widget.color, theme);

    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        height: widget.wrap ? null : metrics.height,
        padding: widget.wrap
            ? EdgeInsets.symmetric(
                horizontal: metrics.horizontalPadding,
                vertical: metrics.wrapVerticalPadding,
              )
            : EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
        decoration: _buildDecoration(metrics, colors),
        child: Row(
          children: [
            _buildIcon(metrics, colors),
            Expanded(
              child: _buildContent(metrics, colors),
            ),
            if (widget.extra != null || widget.closeable)
              _buildRightArea(metrics, colors),
          ],
        ),
      ),
    );
  }

  /// 构建左侧图标区域。
  Widget _buildIcon(_NoticeBarMetrics metrics, _NoticeBarColors colors) {
    final iconWidget = widget.icon ?? const Icon(AntIcons.soundOutlined);
    return Padding(
      padding: EdgeInsets.only(right: metrics.iconGap),
      child: IconTheme(
        data: IconThemeData(color: colors.text, size: metrics.iconSize),
        child: iconWidget,
      ),
    );
  }

  /// 构建内容区域。
  Widget _buildContent(_NoticeBarMetrics metrics, _NoticeBarColors colors) {
    if (widget.contentWidget != null) {
      return DefaultTextStyle(
        style: TextStyle(color: colors.text, fontSize: metrics.fontSize),
        child: widget.contentWidget!,
      );
    }
    return _ScrollingText(
      text: widget.content,
      style: TextStyle(color: colors.text, fontSize: metrics.fontSize),
      speed: widget.speed,
      delay: widget.delay,
      wrap: widget.wrap,
    );
  }

  /// 构建右侧区域（extra + 关闭按钮）。
  Widget _buildRightArea(_NoticeBarMetrics metrics, _NoticeBarColors colors) {
    return Padding(
      padding: EdgeInsets.only(left: metrics.rightGap),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.extra != null)
            DefaultTextStyle(
              style: TextStyle(color: colors.text, fontSize: metrics.fontSize),
              child: widget.extra!,
            ),
          if (widget.closeable)
            GestureDetector(
              onTap: _handleClose,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: metrics.closeHitSize,
                height: metrics.closeHitSize,
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: colors.text,
                      size: metrics.closeIconSize,
                    ),
                    child:
                        widget.closeIcon ?? const Icon(AntIcons.closeOutlined),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleClose() {
    setState(() => _visible = false);
    widget.onClose?.call();
  }

  /// 构建装饰（背景 + 边框 + 圆角）。
  ///
  /// 圆角形状（neutral/rounded）与仅上下边框（block）组合时，
  /// 因 Flutter BoxDecoration 要求非均匀边框不能配圆角，
  /// 统一使用全边框保证视觉一致。
  BoxDecoration _buildDecoration(
    _NoticeBarMetrics metrics,
    _NoticeBarColors colors,
  ) {
    final borderRadius = _buildBorderRadius(metrics);

    Border? border;
    if (widget.bordered != AntNoticeBarBorder.none) {
      final side = BorderSide(
        color: colors.border,
        width: metrics.borderWidth,
      );
      if (borderRadius != null) {
        border = Border.fromBorderSide(side);
      } else {
        switch (widget.bordered) {
          case AntNoticeBarBorder.block:
            border = Border(top: side, bottom: side);
          case AntNoticeBarBorder.full:
            border = Border.fromBorderSide(side);
          case AntNoticeBarBorder.none:
            border = null;
        }
      }
    }

    return BoxDecoration(
      color: colors.background,
      border: border,
      borderRadius: borderRadius,
    );
  }

  BorderRadius? _buildBorderRadius(_NoticeBarMetrics metrics) {
    switch (widget.shape) {
      case AntNoticeBarShape.rectangular:
        return null;
      case AntNoticeBarShape.neutral:
        return BorderRadius.circular(metrics.neutralRadius);
      case AntNoticeBarShape.rounded:
        return BorderRadius.circular(metrics.roundedRadius);
    }
  }
}

// ============================================================
// 内部：滚动文本
// ============================================================

/// 超长文本横向滚动（跑马灯）。
///
/// 滚动逻辑与 antd-mobile 对齐：
/// 1. 延迟 [delay] 后测量文本宽度，若超出容器则启动滚动。
/// 2. 首轮：从 0 滚动到 -textWidth（文本从左滚出）。
/// 3. 后续：从 containerWidth 滚动到 -textWidth（文本从右进入再滚出）。
/// 4. 线性匀速，速度 = [speed] px/s。
class _ScrollingText extends StatefulWidget {
  const _ScrollingText({
    required this.text,
    required this.style,
    required this.speed,
    required this.delay,
    required this.wrap,
  });

  final String text;
  final TextStyle style;
  final double speed;
  final int delay;
  final bool wrap;

  @override
  State<_ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<_ScrollingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  /// 文本自然宽度（px）。
  double _textWidth = 0;

  /// 容器宽度（px）。
  double _containerWidth = 0;

  /// 是否需要滚动。
  bool _needsScroll = false;

  /// 是否首轮滚动。
  bool _isFirstLoop = true;

  /// 当前位移插值。
  Tween<double> _tween = ConstantTween(0.0);

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onAnimationStatus);
    _scheduleStart();
  }

  @override
  void didUpdateWidget(covariant _ScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.speed != widget.speed ||
        oldWidget.delay != widget.delay ||
        oldWidget.wrap != widget.wrap) {
      _resetAndSchedule();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _resetAndSchedule() {
    _controller.stop();
    _delayTimer?.cancel();
    if (mounted) {
      setState(() {
        _needsScroll = false;
        _isFirstLoop = true;
        _tween = ConstantTween(0.0);
      });
    }
    _scheduleStart();
  }

  void _scheduleStart() {
    if (widget.wrap) return;
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(milliseconds: widget.delay), _measureAndStart);
  }

  /// 测量文本与容器宽度，超出时启动滚动。
  void _measureAndStart() {
    if (!mounted || widget.wrap) return;

    final tw = _measureTextWidth();
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final cw = renderBox.size.width;

    if (tw <= cw) return;

    _textWidth = tw;
    _containerWidth = cw;
    if (mounted) {
      setState(() => _needsScroll = true);
    }
    _startScroll();
  }

  double _measureTextWidth() {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    painter.layout(maxWidth: double.infinity);
    final width = painter.size.width;
    painter.dispose();
    return width;
  }

  void _startScroll() {
    if (_isFirstLoop) {
      _tween = Tween(begin: 0.0, end: -_textWidth);
      _controller.duration = Duration(
        milliseconds: (_textWidth / widget.speed * 1000).round(),
      );
      _isFirstLoop = false;
    } else {
      _tween = Tween(begin: _containerWidth, end: -_textWidth);
      _controller.duration = Duration(
        milliseconds:
            ((_containerWidth + _textWidth) / widget.speed * 1000).round(),
      );
    }
    _controller.forward(from: 0);
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _needsScroll && mounted) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        _containerWidth = renderBox.size.width;
      }
      _startScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.wrap) {
      return Text(widget.text, style: widget.style);
    }

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_tween.evaluate(_controller), 0),
            child: child,
          );
        },
        child: Text(
          widget.text,
          style: widget.style,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}