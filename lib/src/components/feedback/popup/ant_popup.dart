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

class _AntPopupState extends State<AntPopup> {
  OverlayEntry? _overlayEntry;
  bool _bodyBuilt = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      _bodyBuilt = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _bodyBuilt = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
      } else {
        if (widget.destroyOnClose) _bodyBuilt = false;
        _hideOverlay();
      }
      return;
    }
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
    if (_overlayEntry != null || !mounted) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _PopupOverlay(
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
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 弹出层浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _PopupOverlay — 遮罩 + 方向滑入面板
// ============================================================

class _PopupOverlay extends StatefulWidget {
  const _PopupOverlay({
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

  /// 受控 AntPopup 的移除浮层回调。
  final VoidCallback? onRemove;

  @override
  State<_PopupOverlay> createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<_PopupOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntPopupAnimationDuration,
    reverseDuration: kAntPopupAnimationDuration,
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  bool _closing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (_closing) return;
    _closing = true;
    widget.onClose?.call();
    _controller.reverse().whenComplete(() {
      widget.onRemove?.call();
    });
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

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // 遮罩（淡入）
            Positioned.fill(
              child: FadeTransition(
                opacity: _curve,
                child: GestureDetector(
                  key: kAntPopupMaskKey,
                  onTap: () {
                    if (!widget.maskClosable) return;
                    _handleClose();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: ColoredBox(color: theme.colorBgMask),
                ),
              ),
            ),
            // 面板（方向滑入）
            Align(
              alignment: _alignment,
              child: SlideTransition(
                position: Tween<Offset>(begin: _slideBegin, end: Offset.zero)
                    .animate(_curve),
                child: panel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
