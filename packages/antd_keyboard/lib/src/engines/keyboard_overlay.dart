import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'input_platform.dart';

/// 键盘浮层停靠位置。
enum AntKeyboardOverlayAlignment {
  /// 贴底（默认，移动端键盘形态）。
  bottom,

  /// 贴顶（搜索栏等场景）。
  top,
}

/// 通用键盘浮层控制器：把任意键盘组件停靠到根 [Overlay] 上。
///
/// 吸收参考库的 overlay 承载方式，并补上原实现缺失的能力：
/// - [alignTop] 真正生效（旧实现字段恒为 false，参数被吞）；
/// - 入场/退场滑动动画，退场动画结束后才移除 OverlayEntry；
/// - 可选的遮罩与点击遮罩关闭；
/// - 桌面端浮层留边 + 圆角/阴影（键盘自身主题负责），移动端贴底；
/// - Esc 关闭（桌面物理键盘），再次打开后重新注册监听。
class AntKeyboardOverlayController {
  OverlayEntry? _entry;
  ValueNotifier<bool>? _visible;
  Widget? _lastKeyboard;
  VoidCallback? _lastDismiss;
  bool _alignTop = false;
  Color? _barrierColor;
  bool _dismissOnTapOutside = false;
  Duration _animationDuration = Duration.zero;
  bool _disposed = false;

  /// 当前是否显示（退场动画期间即为 false）。
  bool get showing => _entry != null && (_visible?.value ?? false);

  /// 当前是否贴顶。
  bool get alignTop => _alignTop;

  bool _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != LogicalKeyboardKey.escape) return false;
    if (!showing) return false;
    hide();
    return true;
  }

  /// 显示键盘。
  ///
  /// [onDismiss] 在 `hide()` / Esc / 点击遮罩时触发一次。
  void show(
    BuildContext context,
    Widget keyboard, {
    VoidCallback? onDismiss,
    bool alignTop = false,
    AntKeyboardOverlayAlignment? alignment,
    Color? barrierColor,
    bool dismissOnTapOutside = false,
    Duration animationDuration = Duration.zero,
  }) {
    if (_disposed) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    if (_entry != null) _removeEntry();
    HardwareKeyboard.instance.addHandler(_handleKey);

    final top = alignment == AntKeyboardOverlayAlignment.top || alignTop;
    _lastKeyboard = keyboard;
    _lastDismiss = onDismiss;
    _alignTop = top;
    _barrierColor = barrierColor;
    _dismissOnTapOutside = dismissOnTapOutside;
    _animationDuration = animationDuration;
    final visible = ValueNotifier<bool>(true);
    _visible = visible;

    final entry = OverlayEntry(
      builder: (context) => _AntKeyboardOverlayDock(
        keyboard: keyboard,
        alignTop: top,
        visible: visible,
        barrierColor: barrierColor,
        dismissOnTapOutside: dismissOnTapOutside,
        duration: animationDuration,
        onDismiss: hide,
        onClosed: _removeEntry,
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  /// 收起键盘（触发 dismiss，并播放退场动画）。
  void hide() {
    final entry = _entry;
    if (entry == null) return;
    final visible = _visible;
    final dismiss = _lastDismiss;
    _lastDismiss = null;
    HardwareKeyboard.instance.removeHandler(_handleKey);
    if (visible != null && visible.value) {
      visible.value = false;
    } else {
      _removeEntry();
    }
    dismiss?.call();
  }

  /// 立即移除（不播动画）。
  void _removeEntry() {
    final entry = _entry;
    _entry = null;
    final visible = _visible;
    _visible = null;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
    if (visible != null) {
      // entry.remove() 后的一帧内 dock 才会 dispose，等它注销监听后再释放。
      WidgetsBinding.instance.addPostFrameCallback((_) => visible.dispose());
    }
  }

  /// 切换贴顶/贴底，保持键盘与 dismiss 绑定不变。
  void realign(BuildContext context, {required bool alignTop}) {
    final keyboard = _lastKeyboard;
    if (keyboard == null) return;
    final dismiss = _lastDismiss;
    hide();
    show(
      context,
      keyboard,
      onDismiss: dismiss,
      alignTop: alignTop,
      barrierColor: _barrierColor,
      dismissOnTapOutside: _dismissOnTapOutside,
      animationDuration: _animationDuration,
    );
  }

  /// 当前环境是否可插入 Overlay。
  static bool isOverlayAvailable(BuildContext context) =>
      Overlay.maybeOf(context, rootOverlay: true) != null;

  /// 释放：移除浮层与 Esc 监听。
  void dispose() {
    _disposed = true;
    HardwareKeyboard.instance.removeHandler(_handleKey);
    _lastKeyboard = null;
    _lastDismiss = null;
    if (_entry != null) _removeEntry();
  }
}

class _AntKeyboardOverlayDock extends StatefulWidget {
  const _AntKeyboardOverlayDock({
    required this.keyboard,
    required this.alignTop,
    required this.visible,
    required this.barrierColor,
    required this.dismissOnTapOutside,
    required this.duration,
    required this.onDismiss,
    required this.onClosed,
  });

  final Widget keyboard;
  final bool alignTop;
  final ValueNotifier<bool> visible;
  final Color? barrierColor;
  final bool dismissOnTapOutside;
  final Duration duration;
  final VoidCallback onDismiss;
  final VoidCallback onClosed;

  @override
  State<_AntKeyboardOverlayDock> createState() =>
      _AntKeyboardOverlayDockState();
}

class _AntKeyboardOverlayDockState extends State<_AntKeyboardOverlayDock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: Offset(0, widget.alignTop ? -1 : 1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    widget.visible.addListener(_onVisibilityChanged);
    _controller.forward();
  }

  void _onVisibilityChanged() {
    if (widget.visible.value) return;
    if (widget.duration == Duration.zero) {
      widget.onClosed();
      return;
    }
    if (_controller.isDismissed) {
      widget.onClosed();
      return;
    }
    _controller.reverse().whenComplete(() {
      if (mounted) widget.onClosed();
    });
  }

  @override
  void dispose() {
    widget.visible.removeListener(_onVisibilityChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktopInputPlatform();
    final keyboard = Padding(
      padding: desktop
          ? EdgeInsets.fromLTRB(AntTheme.of(context).s(24), 0, AntTheme.of(context).s(24), AntTheme.of(context).s(24))
          : EdgeInsets.zero,
      child: widget.keyboard,
    );
    final dock = Align(
      alignment:
          widget.alignTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: widget.duration == Duration.zero
          ? keyboard
          : SlideTransition(
              position: _offset,
              child: FadeTransition(opacity: _fade, child: keyboard),
            ),
    );

    final children = <Widget>[];
    if (widget.barrierColor != null) {
      children.add(
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.dismissOnTapOutside ? widget.onDismiss : null,
            child: ColoredBox(color: widget.barrierColor!),
          ),
        ),
      );
    }
    children.add(dock);
    return Stack(children: children);
  }
}
