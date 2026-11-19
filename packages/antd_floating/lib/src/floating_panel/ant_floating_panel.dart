/// AntFloatingPanel — antd-mobile FloatingPanel 的 Flutter 实现
///
/// API 与 antd-mobile v5 FloatingPanel 对齐：
/// - [anchors] — 锚点高度比例列表（0~1，相对基准高度，升序），默认 [0.6, 0.8, 1]
/// - [handleHeight] — 拖拽把手区域高度
/// - [handle] — 自定义把手 Widget
/// - [contentHeight] — 内容基准总高度（不传时使用父容器高度）
/// - [onHeightChange] — 高度变化回调（比例 0~1）
///
/// 初始停在最低锚点；把手拖拽时面板平滑跟随，松手后带动画吸附到最近锚点；
/// 内容区可自行滚动。
///
/// ```dart
/// AntFloatingPanel(child: ListView(...))
/// AntFloatingPanel(anchors: [0.3, 0.6, 1], onHeightChange: (p) {})
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_floating/src/floating_panel/ant_floating_panel_types.dart';
export 'package:antd_floating/src/floating_panel/ant_floating_panel_types.dart';
import 'package:material_ui/material_ui.dart';

part 'ant_floating_panel_controller.dart';

/// 默认锚点（最低 / 中间 / 最高）。
const List<double> _kDefaultAnchors = <double>[0.6, 0.8, 1.0];

/// 默认把手区域高度（逻辑像素）。
const double _kDefaultHandleHeight = 28;

/// 面板顶部圆角（逻辑像素）。
const double _kPanelBorderRadius = 16;

/// 默认把手横条宽高（逻辑像素）。
const double _kHandleBarWidth = 36;
const double _kHandleBarHeight = 4;

/// 吸附动画时长。
const Duration _kSnapDuration = Duration(milliseconds: 250);

/// 组件内部 Key，便于测试定位。
const Key kAntFloatingPanelKey = Key('ant_floating_panel');
const Key kAntFloatingPanelHandleKey = Key('ant_floating_panel_handle');
const Key kAntFloatingPanelContentKey = Key('ant_floating_panel_content');

/// 浮动面板 — 可拖拽的底部浮动面板，在锚点间平滑移动并动画吸附。
///
/// 对齐 antd-mobile v5 FloatingPanel 组件。
class AntFloatingPanel extends StatefulWidget {
  const AntFloatingPanel({
    super.key,
    this.anchors = _kDefaultAnchors,
    this.handleHeight = _kDefaultHandleHeight,
    this.handle,
    this.contentHeight,
    this.onHeightChange,
    this.controller,
    required this.child,
  });

  /// 锚点高度比例列表（0~1，相对基准高度，需升序）。
  ///
  /// 默认 [0.6, 0.8, 1]，与 antd-mobile 语义一致：面板最高点占比为 1。
  final List<double> anchors;

  /// 拖拽把手区域高度（逻辑像素）。
  final double handleHeight;

  /// 自定义把手 Widget；不传时渲染居中横条。
  final Widget? handle;

  /// 内容基准总高度（逻辑像素）；不传时使用父容器高度。
  ///
  /// 决定锚点比例的基准与面板最大可见高度，内容区可滚动范围由内容自身决定。
  final double? contentHeight;

  /// 高度变化回调，参数为当前高度比例（0~1）。
  final AntFloatingPanelHeightChange? onHeightChange;

  /// 程序化控制器（R35）：吸附到锚点/展开/收起/重置，高度比例经其监听读取。
  final AntFloatingPanelController? controller;

  /// 面板内容。
  final Widget child;

  @override
  State<AntFloatingPanel> createState() => _AntFloatingPanelState();
}

class _AntFloatingPanelState extends State<AntFloatingPanel> {
  /// 当前面板可见高度（逻辑像素），null 表示尚未初始化（停在最低锚点）。
  double? _height;

  /// 是否处于拖拽过程中（拖拽时不做隐式动画，松手后动画吸附）。
  bool _dragging = false;

  /// 最近一次布局计算的锚点像素高度（升序）与基准高度（供 Controller 使用）。
  List<double> _anchorHeights = <double>[];
  double _baseHeight = 0;

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  @override
  void didUpdateWidget(covariant AntFloatingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      _attachController();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  void _attachController() {
    final AntFloatingPanelController? controller = widget.controller;
    if (controller != null) {
      controller._attach(_AntFloatingPanelDelegate(this));
    }
  }

  /// 面板高度变化统一出口：回调外部 + 同步 Controller。
  void _emitHeight(double pixelHeight) {
    if (_baseHeight <= 0) return;
    widget.onHeightChange?.call(pixelHeight / _baseHeight);
    widget.controller?._notifyHeight(pixelHeight / _baseHeight);
  }

  /// 吸附到升序锚点列表的指定像素高度（动画过渡，拖拽态复位）。
  void _snapToHeight(double target) {
    setState(() {
      _dragging = false;
      _height = target;
    });
    _emitHeight(target);
  }

  double _nearestAnchorHeight(double height, List<double> anchorHeights) {
    double nearest = anchorHeights.first;
    double minDiff = (height - nearest).abs();
    for (final double anchor in anchorHeights.skip(1)) {
      final double diff = (height - anchor).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = anchor;
      }
    }
    return nearest;
  }

  @override
  Widget build(BuildContext context) {
    final AntThemeData theme = AntTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double parentHeight = constraints.maxHeight;
        // 基准高度：内容总高度（不超过父容器）或父容器高度。
        final double baseHeight = widget.contentHeight != null
            ? widget.contentHeight!.clamp(0, parentHeight)
            : parentHeight;
        final List<double> anchors = widget.anchors.isEmpty
            ? _kDefaultAnchors
            : widget.anchors;
        final List<double> anchorHeights = anchors
            .map((double a) => (a.clamp(0, 1) * baseHeight))
            .toList()
          ..sort();
        final double minHeight = anchorHeights.first;
        final double maxHeight = anchorHeights.last;

        // 缓存布局结果，供 Controller 程序化操作使用。
        _anchorHeights = anchorHeights;
        _baseHeight = baseHeight;

        // 初始停在最低锚点。
        _height ??= minHeight;
        final double height =
            _height!.clamp(minHeight, maxHeight);

        final Widget handleNode = widget.handle ??
            Center(
              child: Container(
                width: _kHandleBarWidth.w,
                height: _kHandleBarHeight.w,
                decoration: BoxDecoration(
                  color: theme.colorBorder,
                  borderRadius: BorderRadius.circular(_kHandleBarHeight.w / 2),
                ),
              ),
            );

        return SizedBox(
          key: kAntFloatingPanelKey,
          width: constraints.maxWidth,
          height: parentHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: _dragging ? Duration.zero : _kSnapDuration,
                  curve: Curves.easeOutCubic,
                  height: height,
                  decoration: BoxDecoration(
                    color: theme.colorBgContainer,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_kPanelBorderRadius.r),
                    ),
                    boxShadow: theme.boxShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_kPanelBorderRadius.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // 把手：拖拽在锚点间平滑移动，松手动画吸附最近锚点。
                        GestureDetector(
                          key: kAntFloatingPanelHandleKey,
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragUpdate: (DragUpdateDetails details) {
                            setState(() {
                              _dragging = true;
                              _height = (_height! - details.delta.dy)
                                  .clamp(minHeight, maxHeight);
                            });
                            _emitHeight(_height!);
                          },
                          onVerticalDragEnd: (DragEndDetails details) {
                            _snapToHeight(
                              _nearestAnchorHeight(_height!, anchorHeights),
                            );
                          },
                          onVerticalDragCancel: () {
                            setState(() => _dragging = false);
                          },
                          child: SizedBox(
                            height: widget.handleHeight.w,
                            width: double.infinity,
                            child: handleNode,
                          ),
                        ),
                        // 内容区：高度随面板变化，内容可自行滚动。
                        Expanded(
                          child: SizedBox(
                            key: kAntFloatingPanelContentKey,
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// [AntFloatingPanelController] 委托实现：面板挂接期间承接程序化操作。
class _AntFloatingPanelDelegate
    implements AntFloatingPanelControllerDelegate {
  _AntFloatingPanelDelegate(this._state);

  final _AntFloatingPanelState _state;

  @override
  void snapToAnchorAt(int index) {
    if (_state._anchorHeights.isEmpty) return;
    final int clamped =
        index.clamp(0, _state._anchorHeights.length - 1);
    _state._snapToHeight(_state._anchorHeights[clamped]);
  }

  @override
  void expand() => snapToAnchorAt(_state._anchorHeights.length - 1);

  @override
  void collapse() => snapToAnchorAt(0);

  @override
  void resetToInitial() => snapToAnchorAt(0);
}
