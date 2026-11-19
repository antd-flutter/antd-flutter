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

import 'package:antd_flutter_plus/src/components/data_display/floating_panel/ant_floating_panel_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/floating_panel/ant_floating_panel_types.dart';
import 'package:material_ui/material_ui.dart';

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

        // 初始停在最低锚点。
        _height ??= minHeight;
        final double height =
            _height!.clamp(minHeight, maxHeight);

        void notifyHeight(double value) {
          if (baseHeight <= 0) return;
          widget.onHeightChange?.call(value / baseHeight);
        }

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
                              notifyHeight(_height!);
                            });
                          },
                          onVerticalDragEnd: (DragEndDetails details) {
                            final double target =
                                _nearestAnchorHeight(_height!, anchorHeights);
                            setState(() {
                              _dragging = false;
                              _height = target;
                            });
                            notifyHeight(target);
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
