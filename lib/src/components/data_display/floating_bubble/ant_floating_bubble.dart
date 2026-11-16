/// AntFloatingBubble — antd-mobile v5 FloatingBubble 的 Flutter 实现
///
/// API 与 antd-mobile 对齐（Flutter 语义化命名）：
/// - [axis] — x / y / both 可拖拽轴向
/// - [initialPos] — 初始位置（相对父容器左上角的逻辑像素偏移，.w 缩放）
/// - [constraint] — 是否约束在父容器边界内（默认 true，屏幕内）
/// - [menu] — 点击展开的菜单项列表（图标 + 文字，弹出列表）
/// - [onClick] — 无菜单时的点击回调 / 拖拽后的点击
/// - [child] — 自定义图标内容
///
/// ```dart
/// AntFloatingBubble(axis: AntFloatingBubbleAxis.both, child: Icon(Icons.edit))
/// AntFloatingBubble(menu: [AntFloatingBubbleMenuAction(label: '菜单', onClick: ...)])
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/floating_bubble/ant_floating_bubble_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/floating_bubble/ant_floating_bubble_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// 内部：尺寸常量（对齐 floating-bubble.less，--size 48px）
// ============================================================

const double _kBubbleSize = 48;
const double _kMenuGap = 8;

/// Ant Design 悬浮气泡。
///
/// 自身渲染为撑满父容器的透明层（Stack/Overlay 内放置，
/// 非 bubble 区域使用 [IgnorePointer] 穿透手势），
/// 气泡按 [initialPos] 定位并支持 [axis] 轴向拖拽，
/// 拖拽范围默认约束在父容器边界内（[constraint]）。
class AntFloatingBubble extends StatefulWidget {
  const AntFloatingBubble({
    super.key,
    this.axis = AntFloatingBubbleAxis.both,
    this.initialPos = Offset.zero,
    this.constraint = true,
    this.menu,
    this.onClick,
    this.child,
    this.backgroundColor,
    this.size,
  });

  /// 可拖拽轴向。
  final AntFloatingBubbleAxis axis;

  /// 初始位置（逻辑像素，内部 .w 缩放）。
  final Offset initialPos;

  /// 是否约束在父容器边界内（默认 true）。
  final bool constraint;

  /// 菜单项列表（非空时点击气泡展开/收起菜单）。
  final List<AntFloatingBubbleMenuAction>? menu;

  /// 气泡点击回调（配置 [menu] 时在展开/收起切换之外仍会触发）。
  final VoidCallback? onClick;

  /// 自定义图标内容。
  final Widget? child;

  /// 自定义背景色（默认主题主色）。
  final Color? backgroundColor;

  /// 气泡尺寸（逻辑像素，默认 48）。
  final double? size;

  @override
  State<AntFloatingBubble> createState() => _AntFloatingBubbleState();
}

class _AntFloatingBubbleState extends State<AntFloatingBubble> {
  late Offset _pos = Offset(widget.initialPos.dx.w, widget.initialPos.dy.w);
  bool _menuOpen = false;

  bool get _draggableX =>
      widget.axis == AntFloatingBubbleAxis.x ||
      widget.axis == AntFloatingBubbleAxis.both;

  bool get _draggableY =>
      widget.axis == AntFloatingBubbleAxis.y ||
      widget.axis == AntFloatingBubbleAxis.both;

  void _handlePanUpdate(DragUpdateDetails d, Size bounds) {
    var dx = _draggableX ? _pos.dx + d.delta.dx : _pos.dx;
    var dy = _draggableY ? _pos.dy + d.delta.dy : _pos.dy;
    if (widget.constraint) {
      final maxX = bounds.width - (widget.size ?? _kBubbleSize).w;
      final maxY = bounds.height - (widget.size ?? _kBubbleSize).w;
      dx = dx.clamp(0.0, maxX < 0 ? 0.0 : maxX);
      dy = dy.clamp(0.0, maxY < 0 ? 0.0 : maxY);
    }
    setState(() => _pos = Offset(dx, dy));
  }

  void _handleTap() {
    if (_hasMenu) {
      setState(() => _menuOpen = !_menuOpen);
    }
    widget.onClick?.call();
  }

  bool get _hasMenu => widget.menu != null && widget.menu!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bubbleSize = (widget.size ?? _kBubbleSize).w;
    final bg = widget.backgroundColor ?? theme.colorPrimary;

    // ---- 菜单列表（弹出列于气泡上方）----
    Widget? menuPanel;
    if (_hasMenu) {
      final actions = widget.menu!;
      menuPanel = IgnorePointer(
        ignoring: !_menuOpen,
        child: AnimatedOpacity(
          opacity: _menuOpen ? 1.0 : 0.0,
          duration: theme.motionDurationMid,
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _menuOpen ? 1.0 : 0.6,
            alignment: Alignment.bottomCenter,
            duration: theme.motionDurationMid,
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) SizedBox(height: _kMenuGap.w),
                  _MenuItem(
                    action: actions[i],
                    theme: theme,
                    onTap: () {
                      actions[i].onClick?.call();
                      setState(() => _menuOpen = false);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    // ---- 气泡 ----
    Widget bubble = AnimatedContainer(
      duration: theme.motionDurationMid,
      width: bubbleSize,
      height: bubbleSize,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: theme.boxShadowSecondary,
      ),
      child: Center(
        child: widget.child ??
            IconTheme.merge(
              data: IconThemeData(size: bubbleSize * 0.45, color: theme.colorWhite),
              child: const Icon(Icons.add),
            ),
      ),
    );

    bubble = GestureDetector(
      onTap: _handleTap,
      onPanUpdate: (d) => _handlePanUpdate(d, _bounds ?? Size.zero),
      behavior: HitTestBehavior.opaque,
      child: bubble,
    );

    // ---- 定位层：撑满父容器，空白区域（无子节点命中）手势自然穿透 ----
    return LayoutBuilder(
        builder: (context, constraints) {
          _bounds = Size(
            constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
            constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
          );
          return SizedBox(
            width: _bounds!.width,
            height: _bounds!.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: _pos.dx,
                  top: _pos.dy,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (menuPanel != null) ...[
                        menuPanel,
                        SizedBox(height: _kMenuGap.w),
                      ],
                      bubble,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
    );
  }

  Size? _bounds;
}

// ============================================================
// 内部：菜单条目
// ============================================================

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.action,
    required this.theme,
    required this.onTap,
  });

  final AntFloatingBubbleMenuAction action;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: theme.colorBgContainer,
          borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
          border: Border.all(color: theme.colorBorderSecondary, width: theme.lineWidth),
          boxShadow: theme.boxShadowSecondary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (action.icon != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: theme.fontSizeIcon,
                  color: theme.colorPrimary,
                ),
                child: action.icon!,
              ),
              SizedBox(width: theme.paddingXXS.w),
            ],
            Text(
              action.label,
              style: TextStyle(
                fontSize: theme.fontSizeSM.sp,
                color: theme.colorText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
