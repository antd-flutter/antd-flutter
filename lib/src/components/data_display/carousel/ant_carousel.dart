/// AntCarousel — antd React Carousel 的 Flutter 实现
///
/// 基于 [PageView] 的走马灯，API 与 antd React Carousel 对齐：
/// - [children] / [items] — 轮播内容
/// - [autoplay] — 是否自动切换
/// - [autoplayInterval] — 自动切换间隔（默认 3 秒）
/// - [pauseOnHover] — 悬停时暂停自动切换（桌面端）
/// - [loop] — 是否循环（简化实现：自动播到末页后回首/末页跳转）
/// - [dots] — 是否显示指示点
/// - [dotPosition] — 指示点位置（top/bottom/left/right）
/// - [arrows] — 是否显示切换箭头（hover 加深）
/// - [vertical] — 垂直轮播
/// - [defaultCurrent] / [current] — 初始页 / 受控当前页
/// - [onChange] — 页面切换回调
/// - [controller] — 外部控制器（goTo）
///
/// ```dart
/// AntCarousel(children: [Text('1'), Text('2')])
/// AntCarousel(children: [...], autoplay: true)
/// AntCarousel(children: [...], dots: true, dotPosition: AntCarouselDotPosition.left)
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/carousel/ant_carousel_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/carousel/ant_carousel_types.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntCarousel
// ============================================================

/// 走马灯 — 常用于一组图片或卡片轮播。
///
/// 对齐 antd React Carousel 组件。
class AntCarousel extends StatefulWidget {
  const AntCarousel({
    super.key,
    this.children,
    this.items,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
    this.pauseOnHover = false,
    this.loop = false,
    this.dots = true,
    this.dotPosition = AntCarouselDotPosition.bottom,
    this.arrows = false,
    this.vertical = false,
    this.defaultCurrent = 0,
    this.current,
    this.onChange,
    this.controller,
    this.height,
  }) : assert(children != null || items != null, 'children 或 items 必须提供其一');

  /// 轮播内容（Widget 列表）。
  final List<Widget>? children;

  /// 轮播内容（与 [children] 二选一）。
  final List<Widget>? items;

  /// 是否自动切换。
  final bool autoplay;

  /// 自动切换间隔，默认 3 秒（对齐 antd autoplaySpeed 3000）。
  final Duration autoplayInterval;

  /// 悬停时暂停自动切换（桌面端）。
  final bool pauseOnHover;

  /// 是否循环（简化实现：切换到末页后跳回首页，反之亦然）。
  final bool loop;

  /// 是否显示指示点。
  final bool dots;

  /// 指示点位置，默认底部。
  final AntCarouselDotPosition dotPosition;

  /// 是否显示切换箭头（桌面端，hover 时完全不透明）。
  final bool arrows;

  /// 是否垂直轮播。
  final bool vertical;

  /// 初始页索引（非受控）。
  final int defaultCurrent;

  /// 受控当前页索引。
  final int? current;

  /// 页面切换回调。
  final ValueChanged<int>? onChange;

  /// 外部控制器。
  final AntCarouselController? controller;

  /// 轮播区高度（垂直轮播或作为页面容器时建议指定）。
  final double? height;

  List<Widget> get _pages => children ?? items ?? const <Widget>[];

  @override
  State<AntCarousel> createState() => _AntCarouselState();
}

class _AntCarouselState extends State<AntCarousel>
    implements AntCarouselStateApi {
  late PageController _pageController;
  Timer? _autoplayTimer;
  bool _hovered = false;
  bool _disposed = false;
  late int _current;
  int _lastEmitted = -1;

  bool get _isControlled => widget.current != null;

  @override
  void initState() {
    super.initState();
    _current = widget.defaultCurrent;
    _pageController = PageController(
      initialPage: _current,
      keepPage: true,
    );
    widget.controller?.attach(this);
    if (_isControlled) _syncToControlled(widget.current!, animate: false);
    _startAutoplay();
  }

  @override
  void didUpdateWidget(covariant AntCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    if (_isControlled && widget.current != _current) {
      _syncToControlled(widget.current!);
    }
    if (widget.autoplay != oldWidget.autoplay || !_isAutoplaying) {
      _stopAutoplay();
      _startAutoplay();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _stopAutoplay();
    _pageController.dispose();
    super.dispose();
  }

  // ---------- 自动播放 ----------

  bool get _isAutoplaying => _autoplayTimer != null;

  void _startAutoplay() {
    if (!widget.autoplay || _disposed || _isAutoplaying) return;
    if (widget.pauseOnHover && _hovered) return;
    _autoplayTimer = Timer.periodic(widget.autoplayInterval, (_) => _next());
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = null;
  }

  void _next() {
    final pages = widget._pages;
    if (pages.isEmpty) return;
    if (_current >= pages.length - 1) {
      if (widget.loop) {
        _goTo(0);
      }
      return;
    }
    _goTo(_current + 1);
  }

  void _prev() {
    if (_current <= 0) {
      if (widget.loop) {
        _goTo(widget._pages.length - 1);
      }
      return;
    }
    _goTo(_current - 1);
  }

  // ---------- 跳转 ----------

  /// 跳转到指定页（实现 AntCarouselStateApi，供控制器调用）。
  @override
  void goTo(int index, {bool animate = true}) => _goTo(index, animate: animate);

  void _goTo(int index, {bool animate = true}) {
    if (_disposed) return;
    final pages = widget._pages;
    if (pages.isEmpty) return;
    final clamped = index.clamp(0, pages.length - 1);
    if (animate) {
      _pageController.animateToPage(
        clamped,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(clamped);
    }
    if (!_isControlled) {
      setState(() => _current = clamped);
    }
    _emitChange(clamped);
  }

  void _syncToControlled(int value, {bool animate = true}) {
    final clamped = value.clamp(0, widget._pages.length - 1);
    if (animate) {
      _pageController.animateToPage(
        clamped,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(clamped);
    }
    setState(() => _current = clamped);
  }

  // ---------- 交互 ----------

  void _handlePageChanged(int index) {
    if (!_isControlled) {
      setState(() => _current = index);
    }
    _emitChange(index);
  }

  /// 去重后触发 onChange（主动翻页与 PageView 回调可能重复）。
  void _emitChange(int index) {
    if (index == _lastEmitted) return;
    _lastEmitted = index;
    widget.onChange?.call(index);
  }

  bool get _dotsVertical =>
      widget.dotPosition == AntCarouselDotPosition.left ||
      widget.dotPosition == AntCarouselDotPosition.right;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final pages = widget._pages;

    final pageView = PageView(
      controller: _pageController,
      scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal,
      onPageChanged: _handlePageChanged,
      children: pages,
    );

    Widget body = pageView;

    if (widget.pauseOnHover) {
      body = MouseRegion(
        onEnter: (_) {
          _hovered = true;
          _stopAutoplay();
        },
        onExit: (_) {
          _hovered = false;
          _stopAutoplay();
          _startAutoplay();
        },
        child: body,
      );
    }

    final stackChildren = <Widget>[Positioned.fill(child: body)];

    if (widget.dots && pages.isNotEmpty) {
      stackChildren.add(_buildDots(theme));
    }

    if (widget.arrows && pages.length > 1) {
      stackChildren.addAll(_buildArrows(theme));
    }

    return SizedBox(
      height: widget.height,
      child: Stack(children: stackChildren),
    );
  }

  // ---------- 指示点 ----------

  AlignmentGeometry get _dotsAlignment {
    switch (widget.dotPosition) {
      case AntCarouselDotPosition.top:
        return Alignment.topCenter;
      case AntCarouselDotPosition.bottom:
        return Alignment.bottomCenter;
      case AntCarouselDotPosition.left:
        return Alignment.centerLeft;
      case AntCarouselDotPosition.right:
        return Alignment.centerRight;
    }
  }

  EdgeInsets get _dotsPadding {
    switch (widget.dotPosition) {
      case AntCarouselDotPosition.top:
        return EdgeInsets.only(top: 10.w);
      case AntCarouselDotPosition.bottom:
        return EdgeInsets.only(bottom: 10.w);
      case AntCarouselDotPosition.left:
        return EdgeInsets.only(left: 10.w);
      case AntCarouselDotPosition.right:
        return EdgeInsets.only(right: 10.w);
    }
  }

  Widget _buildDots(AntThemeData theme) {
    final pages = widget._pages;
    return Positioned.fill(
      child: Align(
        alignment: _dotsAlignment,
        child: Padding(
          padding: _dotsPadding,
          child: _dotsVertical
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < pages.length; i++)
                      _buildDot(theme, i, vertical: true),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < pages.length; i++)
                      _buildDot(theme, i, vertical: false),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDot(AntThemeData theme, int index, {required bool vertical}) {
    final active = index == _current;
    return Padding(
      padding: vertical
          ? EdgeInsets.symmetric(vertical: 3.w)
          : EdgeInsets.symmetric(horizontal: 3.w),
      child: GestureDetector(
        onTap: () => _goTo(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: vertical ? 6.w : (active ? 20.w : 6.w),
          height: vertical ? (active ? 20.w : 6.w) : 6.w,
          decoration: BoxDecoration(
            color: active
                ? theme.colorPrimary
                : theme.colorText.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(theme.borderRadiusSM),
          ),
        ),
      ),
    );
  }

  // ---------- 箭头 ----------

  List<Widget> _buildArrows(AntThemeData theme) {
    return [
      Positioned.fill(
        child: Align(
          alignment:
              widget.vertical ? Alignment.topCenter : Alignment.centerLeft,
          child: Padding(
            padding: widget.vertical
                ? EdgeInsets.only(top: 12.w)
                : EdgeInsets.only(left: 12.w),
            child: _buildArrow(
              theme,
              icon: widget.vertical
                  ? Icons.keyboard_arrow_up
                  : Icons.chevron_left,
              onTap: _prev,
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment:
              widget.vertical ? Alignment.bottomCenter : Alignment.centerRight,
          child: Padding(
            padding: widget.vertical
                ? EdgeInsets.only(bottom: 12.w)
                : EdgeInsets.only(right: 12.w),
            child: _buildArrow(
              theme,
              icon: widget.vertical
                  ? Icons.keyboard_arrow_down
                  : Icons.chevron_right,
              onTap: _next,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildArrow(
    AntThemeData theme, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: _hovered ? 1 : 0.45,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: theme.colorBgMask.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.sp, color: theme.colorWhite),
        ),
      ),
    );
  }
}
