/// AntPopup — antd-mobile Popup（移动端弹出层）的 Flutter 实现
///
/// API 对齐 antd-mobile v5 Popup：
/// - [AntPopup.visible] — 受控显示
/// - [AntPopup.position] — bottom/top/left/right 四方向（默认 bottom）
/// - [AntPopup.body] — 内容
/// - [AntPopup.showCloseIcon] — 关闭图标
/// - [AntPopup.onClose] — 关闭回调
/// - [AntPopup.destroyOnClose] — 关闭后销毁内容（简化实现）
/// - [AntPopup.maskClosable] — 点击遮罩关闭（默认 true）
///
/// ```dart
/// AntPopup(visible: true, position: AntPopupPosition.bottom, body: Text('内容'));
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_popup_types.dart';
import 'dart:math' as math;

import '../../engines/overlay_shell.dart';
import '../../engines/popup_overlay.dart';
export 'ant_popup_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 遮罩标记 key，便于测试定位。
const Key kAntPopupMaskKey = ValueKey<String>('AntPopupMask');

/// 弹出面板标记 key。
const Key kAntPopupPanelKey = ValueKey<String>('AntPopupPanel');

// ============================================================
// AntPopup
// ============================================================

/// 弹出层 — 从四方向滑出的浮层面板，常用于半屏内容展示。
///
/// 对齐 antd-mobile v5 Popup 组件：受控 [visible]、四方向滑入
/// （SlideTransition + 遮罩淡入）、关闭图标、遮罩点击关闭。
class AntPopup extends StatefulWidget {
  const AntPopup({
    super.key,
    this.visible = false,
    this.position = AntPopupPosition.bottom,
    this.body,
    this.showCloseIcon = false,
    this.onClose,
    this.destroyOnClose = false,
    this.maskClosable = true,
    this.handle = false,
    this.borderRadius,
    this.backgroundColor,
  });

  /// 受控显示状态。
  final bool visible;

  /// 弹出方向（默认底部弹出）。
  final AntPopupPosition position;

  /// 面板内容。
  final Widget? body;

  /// 是否显示关闭图标。
  final bool showCloseIcon;

  /// 关闭回调（点击关闭图标或遮罩时触发）。
  final VoidCallback? onClose;

  /// 关闭后是否销毁内容（简化实现：隐藏时不保留内容）。
  final bool destroyOnClose;

  /// 点击遮罩是否关闭（默认 true）。
  final bool maskClosable;

  /// 是否显示拖拽把手（占位属性，当前简化实现不渲染把手）。
  final bool handle;

  /// 自定义面板圆角（覆盖方向默认圆角）。
  final double? borderRadius;

  /// 自定义面板背景色（默认 colorBgContainer）。
  final Color? backgroundColor;

  /// 函数式弹出一个临时弹出层（关闭动画结束后自动移除）。
  ///
  /// ```dart
  /// AntPopup.show(
  ///   context,
  ///   position: AntPopupPosition.bottom,
  ///   body: const Text('内容'),
  ///   showCloseIcon: true,
  /// );
  /// ```
  static void show(
    BuildContext context, {
    AntPopupPosition position = AntPopupPosition.bottom,
    Widget? body,
    bool showCloseIcon = false,
    bool maskClosable = true,
    double? borderRadius,
    Color? backgroundColor,
    VoidCallback? onClose,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final theme = AntTheme.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _PopupOverlay(
        open: true,
        position: position,
        body: body,
        showCloseIcon: showCloseIcon,
        maskClosable: maskClosable,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        themeData: theme,
        onClose: onClose,
        onRemove: entry.remove,
      ),
    );
    overlay.insert(entry);
  }

  @override
  State<AntPopup> createState() => _AntPopupState();
}

class _AntPopupState extends State<AntPopup>
    with PopupContentRefresher, PopupOpenScheduler {
  OverlayEntry? _overlayEntry;
  bool _bodyBuilt = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      schedulePopupOpen(open: true, show: _showOverlay, hide: () {});
      _bodyBuilt = true;
    }
  }

  @override
  void didUpdateWidget(covariant AntPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) _bodyBuilt = true;
      schedulePopupOpen(open: widget.visible, show: _showOverlay, hide: () {});
    }
    // visible 翻转 / 内容变化：延迟到帧末原地重建浮层（基座统一调度）
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
      builder: (context) => _PopupOverlay(
        open: widget.visible,
        position: widget.position,
        body: _bodyBuilt ? widget.body : null,
        showCloseIcon: widget.showCloseIcon,
        maskClosable: widget.maskClosable,
        handle: widget.handle,
        borderRadius: widget.borderRadius,
        backgroundColor: widget.backgroundColor,
        themeData: theme,
        onClose: widget.onClose,
        onRemove: _hideOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (widget.destroyOnClose) _bodyBuilt = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 弹出层浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _PopupOverlay — 基座（AntOverlayShell）+ 方向滑入面板
// ============================================================

class _PopupOverlay extends StatefulWidget {
  const _PopupOverlay({
    required this.open,
    required this.position,
    required this.themeData,
    this.body,
    this.showCloseIcon = false,
    this.maskClosable = true,
    this.handle = false,
    this.borderRadius,
    this.backgroundColor,
    this.onClose,
    this.onRemove,
  });

  /// 初始/受控显示状态。
  final bool open;

  final AntPopupPosition position;
  final Widget? body;
  final bool showCloseIcon;
  final bool maskClosable;
  final bool handle;
  final double? borderRadius;
  final Color? backgroundColor;
  final AntThemeData themeData;

  /// 关闭回调（点击关闭图标或遮罩时触发）。
  final VoidCallback? onClose;

  /// 退出动画播放完毕后的浮层移除回调。
  final VoidCallback? onRemove;

  @override
  State<_PopupOverlay> createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<_PopupOverlay> {
  /// 内部 open 镜像：受控跟随 [AntPopup.visible]，内部关闭（关闭图标/遮罩）
  /// 时立即翻 false，由基座播放退出动画后回调 [widget.onRemove]。
  late bool _open = widget.open;
  bool _closing = false;

  @override
  void didUpdateWidget(covariant _PopupOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open && !_closing) {
      _open = widget.open;
    }
  }

  /// 内部关闭：翻 open=false，退出动画交给基座统一播放。
  void _handleClose() {
    if (_closing) return;
    _closing = true;
    widget.onClose?.call();
    setState(() => _open = false);
  }

  /// 各方向默认圆角（朝向屏幕内容的边）。
  BorderRadius get _defaultBorderRadius {
    final radius = (widget.borderRadius ?? widget.themeData.borderRadiusLG).r;
    switch (widget.position) {
      case AntPopupPosition.bottom:
        return BorderRadius.vertical(top: Radius.circular(radius));
      case AntPopupPosition.top:
        return BorderRadius.vertical(bottom: Radius.circular(radius));
      case AntPopupPosition.left:
        return BorderRadius.horizontal(right: Radius.circular(radius));
      case AntPopupPosition.right:
        return BorderRadius.horizontal(left: Radius.circular(radius));
    }
  }

  /// 面板尺寸约束。
  BoxConstraints _panelConstraints(Size screen) {
    // 桌面端视口：宽度按 kAntMobileOverlayDefaultMaxWidth 封顶（水平方向居中）；
    // 移动端保持原生语义（纵向上全宽贴边、横向 0.7 屏宽）
    if (antIsDesktopViewport(context)) {
      switch (widget.position) {
        case AntPopupPosition.bottom:
        case AntPopupPosition.top:
          return BoxConstraints(
            maxWidth: kAntMobileOverlayDefaultMaxWidth,
            maxHeight: screen.height * kAntPopupVerticalMaxHeightFactor,
          );
        case AntPopupPosition.left:
        case AntPopupPosition.right:
          return BoxConstraints(
            minHeight: screen.height,
            maxWidth: math.min(
              screen.width * kAntPopupSideWidthFactor,
              kAntMobileOverlayDefaultMaxWidth,
            ),
          );
      }
    }
    switch (widget.position) {
      case AntPopupPosition.bottom:
      case AntPopupPosition.top:
        return BoxConstraints(
          minWidth: screen.width,
          maxHeight: screen.height * kAntPopupVerticalMaxHeightFactor,
        );
      case AntPopupPosition.left:
      case AntPopupPosition.right:
        return BoxConstraints(
          minHeight: screen.height,
          maxWidth: screen.width * kAntPopupSideWidthFactor,
        );
    }
  }

  /// 面板在 Stack 中的对齐方式。
  Alignment get _alignment {
    switch (widget.position) {
      case AntPopupPosition.bottom:
        return Alignment.bottomCenter;
      case AntPopupPosition.top:
        return Alignment.topCenter;
      case AntPopupPosition.left:
        return Alignment.centerLeft;
      case AntPopupPosition.right:
        return Alignment.centerRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final screen = MediaQuery.of(context).size;
    final vertical = widget.position == AntPopupPosition.bottom ||
        widget.position == AntPopupPosition.top;

    Widget panel = Container(
      key: kAntPopupPanelKey,
      constraints: _panelConstraints(screen),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorBgContainer,
        borderRadius: _defaultBorderRadius,
      ),
      child: Column(
        mainAxisSize: vertical ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.handle)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.w),
              child: Center(
                child: Container(
                  width: 36.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: theme.colorBorder,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
          if (widget.showCloseIcon)
            Align(
              alignment: Alignment.topRight,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  key: kAntPopupCloseKey,
                  onTap: _handleClose,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(
                      Icons.close,
                      size: 18.w,
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
              child: widget.body ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );

    // 弹层基座：遮罩淡入淡出 + 方向滑入动画 + 退出动画后移除浮层
    return AntOverlayShell(
      // R37 热键基座：打开状态下按 Esc 关闭（触发动作同遮罩点击）
      escToClose: true,
      open: _open,
      alignment: _alignment,
      slideBegin: _slideBegin,
      maskKey: kAntPopupMaskKey,
      onMaskTap: widget.maskClosable ? _handleClose : null,
      maskClosable: true,
      duration: kAntPopupAnimationDuration,
      onExited: widget.onRemove,
      child: panel,
    );
  }

  /// 各方向的滑入起始偏移。
  Offset get _slideBegin {
    switch (widget.position) {
      case AntPopupPosition.bottom:
        return const Offset(0, 1);
      case AntPopupPosition.top:
        return const Offset(0, -1);
      case AntPopupPosition.left:
        return const Offset(-1, 0);
      case AntPopupPosition.right:
        return const Offset(1, 0);
    }
  }
}
