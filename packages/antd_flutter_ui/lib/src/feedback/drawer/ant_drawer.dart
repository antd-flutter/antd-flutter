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
import 'package:material_ui/material_ui.dart';

import 'ant_drawer_types.dart';
import '../../engines/overlay_shell.dart';
import '../../engines/popup_overlay.dart';

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
    with PopupContentRefresher, PopupOpenScheduler {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      schedulePopupOpen(open: true, show: _showOverlay, hide: () {});
    }
  }

  @override
  void didUpdateWidget(covariant AntDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      schedulePopupOpen(open: widget.open, show: _showOverlay, hide: () {});
    }
    // open 翻转 / 样式内容变化：延迟到帧末原地重建浮层（基座统一调度）；
    // 关闭动画由基座播放，播完回调 _removeOverlay 移除浮层
    refreshPopupContent();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    popupContentEntry = null;
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DrawerOverlay(
        open: widget.open,
        drawer: widget,
        themeData: theme,
        onRemove: _removeOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // 抽屉浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _DrawerOverlay — 基座（AntOverlayShell）+ 边缘面板
// ============================================================

class _DrawerOverlay extends StatelessWidget {
  const _DrawerOverlay({
    required this.open,
    required this.drawer,
    required this.themeData,
    required this.onRemove,
  });

  /// 受控显示状态（false 时基座播放退出动画后回调 [onRemove]）。
  final bool open;

  final AntDrawer drawer;
  final AntThemeData themeData;
  final VoidCallback onRemove;

  bool get _isHorizontal =>
      drawer.placement == AntDrawerPlacement.left ||
      drawer.placement == AntDrawerPlacement.right;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);

    // 面板尺寸（pushOffset 向内收缩）
    final offset = drawer.pushOffset;
    final width = _isHorizontal
        ? (drawer.width - offset).clamp(0.0, mediaSize.width)
        : mediaSize.width;
    final height = _isHorizontal
        ? mediaSize.height
        : (drawer.height - offset).clamp(0.0, mediaSize.height);
    // pushOffset 使面板向内收缩（替代原 Positioned 边缘偏移）
    final inset = EdgeInsets.only(
      left: drawer.placement == AntDrawerPlacement.left ? offset : 0,
      right: drawer.placement == AntDrawerPlacement.right ? offset : 0,
      top: drawer.placement == AntDrawerPlacement.top ? offset : 0,
      bottom: drawer.placement == AntDrawerPlacement.bottom ? offset : 0,
    );

    // 弹层基座：遮罩/拦截层 + 方向滑入动画 + 退出动画后移除浮层
    return AntOverlayShell(
      open: open,
      showMask: drawer.mask,
      // mask=false 时仍按 maskClosable 保留 translucent 点击拦截层
      interceptWithoutMask: !drawer.mask,
      maskClosable: drawer.maskClosable,
      maskKey: kAntDrawerMaskKey,
      onMaskTap: _handleClose,
      alignment: switch (drawer.placement) {
        AntDrawerPlacement.left => Alignment.centerLeft,
        AntDrawerPlacement.right => Alignment.centerRight,
        AntDrawerPlacement.top => Alignment.topCenter,
        AntDrawerPlacement.bottom => Alignment.bottomCenter,
      },
      slideBegin: switch (drawer.placement) {
        AntDrawerPlacement.left => const Offset(-1, 0),
        AntDrawerPlacement.right => const Offset(1, 0),
        AntDrawerPlacement.top => const Offset(0, -1),
        AntDrawerPlacement.bottom => const Offset(0, 1),
      },
      padding: inset,
      duration: kAntDrawerDuration,
      curve: Curves.easeOutCubic,
      onExited: onRemove,
      child: SizedBox(
        key: kAntDrawerPanelKey,
        width: width,
        height: height,
        child: _buildPanel(context),
      ),
    );
  }

  void _handleClose() {
    drawer.onClose?.call();
  }

  Widget _buildPanel(BuildContext context) {
    final theme = themeData;
    // Overlay 内 padding 已被页面 SafeArea 消费，用 viewPadding 取真实安全区，
    // 标题/底部操作区不被状态栏与底部横条遮挡
    final vp = MediaQuery.viewPaddingOf(context);
    return Material(
      color: theme.colorBgContainer,
      elevation: 8,
      shadowColor: theme.colorShadow,
      child: Padding(
        padding: EdgeInsets.only(
          top: vp.top,
          bottom: vp.bottom,
          left: vp.left,
          right: vp.right,
        ),
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
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          key: kAntDrawerCloseKey,
                          onTap: _handleClose,
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
      ),
    );
  }
}
