/// AntDrawer — antd React Drawer（抽屉）的 Flutter 实现
///
/// API 与 antd v6 对齐：
/// - [open] — 受控显示状态
/// - [placement] — 滑出方向（left / right / top / bottom）
/// - [width] / [height] — 面板尺寸
/// - [title] — 标题区
/// - [closable] — 右上角关闭按钮
/// - [onClose] — 关闭回调（点击关闭按钮 / 遮罩时触发）
/// - [footer] — 底部操作区
/// - [mask] — 是否显示遮罩
/// - [maskClosable] — 点击遮罩是否关闭
/// - [child] — 内容区（可滚动）
/// - [pushOffset] — 多层抽屉时的堆叠偏移（简化实现，仅做单层偏移）
///
/// ```dart
/// AntDrawer(
///   open: true,
///   title: 'Basic Drawer',
///   child: Text('内容'),
///   onClose: () {},
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import 'ant_drawer_types.dart';

// ============================================================
// 测试定位 Key 与常量
// ============================================================

/// 抽屉面板标记 key，便于测试定位面板。
const Key kAntDrawerPanelKey = ValueKey<String>('AntDrawerPanel');

/// 遮罩标记 key，便于测试定位遮罩。
const Key kAntDrawerMaskKey = ValueKey<String>('AntDrawerMask');

/// 右上角关闭按钮标记 key。
const Key kAntDrawerCloseKey = ValueKey<String>('AntDrawerClose');

/// 底部操作区标记 key。
const Key kAntDrawerFooterKey = ValueKey<String>('AntDrawerFooter');

/// 抽屉滑入/滑出动画时长。
const Duration kAntDrawerDuration = Duration(milliseconds: 300);

// ============================================================
// AntDrawer
// ============================================================

/// 抽屉 — 从屏幕边缘滑出的浮层面板。
///
/// 对齐 antd React Drawer 组件：支持四方向滑入、滑入/滑出动画、
/// 遮罩淡入淡出、受控 open、标题/关闭按钮/底部操作区、
/// 内容滚动与遮罩配置。关闭动画播放完毕后才移除浮层。
class AntDrawer extends StatefulWidget {
  const AntDrawer({
    super.key,
    required this.open,
    required this.child,
    this.placement = AntDrawerPlacement.right,
    this.width = 378,
    this.height = 378,
    this.title,
    this.closable = true,
    this.onClose,
    this.footer,
    this.mask = true,
    this.maskClosable = true,
    this.pushOffset = 0,
  });

  /// 受控显示状态。
  final bool open;

  /// 内容区（超出时自动滚动）。
  final Widget child;

  /// 滑出方向。
  final AntDrawerPlacement placement;

  /// 面板宽度（left / right 方向生效）。
  final double width;

  /// 面板高度（top / bottom 方向生效）。
  final double height;

  /// 标题区。
  final Widget? title;

  /// 是否显示右上角关闭按钮。
  final bool closable;

  /// 关闭回调（关闭按钮 / 遮罩点击触发，外部应将 open 置为 false）。
  final VoidCallback? onClose;

  /// 底部操作区。
  final Widget? footer;

  /// 是否显示遮罩。
  final bool mask;

  /// 点击遮罩是否关闭抽屉。
  final bool maskClosable;

  /// 多层抽屉堆叠偏移（向内收缩的像素数，简化实现）。
  final double pushOffset;

  @override
  State<AntDrawer> createState() => _AntDrawerState();
}

class _AntDrawerState extends State<AntDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntDrawerDuration,
  );

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
    _controller.addStatusListener(_handleStatus);
  }

  @override
  void didUpdateWidget(covariant AntDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
      } else {
        _controller.reverse();
      }
      return;
    }
    // 样式/内容变化时刷新已打开的浮层（延迟到帧末避免 build 期 markNeedsBuild）
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
    _controller.removeStatusListener(_handleStatus);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller.dispose();
    super.dispose();
  }

  /// 动画结束后按需移除浮层：关闭动画播放完才移除 Overlay。
  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !widget.open) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;
    _controller.forward();
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DrawerOverlay(
        drawer: widget,
        themeData: theme,
        animation: CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
        onClose: _handleClose,
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleClose() {
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    // 抽屉浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _DrawerOverlay — 遮罩 + 面板浮层
// ============================================================

class _DrawerOverlay extends StatelessWidget {
  const _DrawerOverlay({
    required this.drawer,
    required this.themeData,
    required this.animation,
    required this.onClose,
  });

  final AntDrawer drawer;
  final AntThemeData themeData;
  final Animation<double> animation;
  final VoidCallback onClose;

  bool get _isHorizontal =>
      drawer.placement == AntDrawerPlacement.left ||
      drawer.placement == AntDrawerPlacement.right;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);

    // 面板锚定位置（pushOffset 向内收缩）
    final offset = drawer.pushOffset;
    Positioned panel;
    if (_isHorizontal) {
      final width = (drawer.width - offset).clamp(
        0.0,
        mediaSize.width,
      );
      panel = Positioned(
        key: kAntDrawerPanelKey,
        left: drawer.placement == AntDrawerPlacement.left ? offset : null,
        right: drawer.placement == AntDrawerPlacement.right ? offset : null,
        top: 0,
        bottom: 0,
        width: width,
        child: _buildSlide(_buildPanel()),
      );
    } else {
      final height = (drawer.height - offset).clamp(
        0.0,
        mediaSize.height,
      );
      panel = Positioned(
        key: kAntDrawerPanelKey,
        top: drawer.placement == AntDrawerPlacement.top ? offset : null,
        bottom: drawer.placement == AntDrawerPlacement.bottom ? offset : null,
        left: 0,
        right: 0,
        height: height,
        child: _buildSlide(_buildPanel()),
      );
    }

    return Stack(
      children: [
        // 遮罩（淡入淡出；mask=false 时无遮罩层）
        if (drawer.mask)
          Positioned.fill(
            child: GestureDetector(
              key: kAntDrawerMaskKey,
              onTap: drawer.maskClosable ? onClose : null,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: animation,
                child: ColoredBox(color: themeData.colorBgMask),
              ),
            ),
          )
        else
          Positioned.fill(
            child: GestureDetector(
              onTap: drawer.maskClosable ? onClose : null,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
        // 面板（按方向滑入）
        panel,
      ],
    );
  }

  /// 按滑出方向生成面板滑入动画。
  Widget _buildSlide(Widget child) {
    final begin = switch (drawer.placement) {
      AntDrawerPlacement.right => const Offset(1, 0),
      AntDrawerPlacement.left => const Offset(-1, 0),
      AntDrawerPlacement.top => const Offset(0, -1),
      AntDrawerPlacement.bottom => const Offset(0, 1),
    };
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
        animation,
      ),
      child: child,
    );
  }

  Widget _buildPanel() {
    final theme = themeData;
    return Material(
      color: theme.colorBgContainer,
      elevation: 8,
      shadowColor: theme.colorShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          if (drawer.title != null || drawer.closable)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorTextHeading,
                      ),
                      child: drawer.title ?? const SizedBox.shrink(),
                    ),
                  ),
                  if (drawer.closable)
                    GestureDetector(
                      key: kAntDrawerCloseKey,
                      onTap: onClose,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: theme.colorTextSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Divider(height: 1, color: theme.colorBorderSecondary),
          // 内容区（可滚动）
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
                child: drawer.child,
              ),
            ),
          ),
          // 底部操作区
          if (drawer.footer != null) ...[
            Divider(height: 1, color: theme.colorBorderSecondary),
            Container(
              key: kAntDrawerFooterKey,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 14.sp, color: theme.colorText),
                child: drawer.footer!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
