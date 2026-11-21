import 'package:material_ui/material_ui.dart';

import 'ant_keyboard_theme.dart';

/// 单个键的基础容器（引擎与数字键盘共用）。
///
/// 只负责：尺寸/圆角/描边/按下反馈/hover（桌面）/点击与长按手势，
/// 内容由调用方传入。这样通用键盘与 antd-mobile 数字键盘可以共享同一套
/// 交互语义，同时各自保留自己的布局与配色。
class AntKeyboardKeyView extends StatefulWidget {
  const AntKeyboardKeyView({
    super.key,
    required this.child,
    required this.theme,
    this.background,
    this.pressedBackground,
    this.hoverBackground,
    this.activeBackground,
    this.active = false,
    this.borderRadius,
    this.height,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.semanticLabel,
    this.enabled = true,
    this.showBorder,
    this.showHover,
    this.boxShadow,
  });

  final Widget child;
  final AntKeyboardThemeData theme;
  final Color? background;
  final Color? pressedBackground;
  final Color? hoverBackground;
  final Color? activeBackground;
  final bool active;
  final double? borderRadius;
  final double? height;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final VoidCallback? onLongPress;
  final ValueChanged<Offset>? onLongPressStart;
  final String? semanticLabel;
  final bool enabled;
  final bool? showBorder;
  final bool? showHover;
  final List<BoxShadow>? boxShadow;

  @override
  State<AntKeyboardKeyView> createState() => _AntKeyboardKeyViewState();
}

class _AntKeyboardKeyViewState extends State<AntKeyboardKeyView> {
  bool _pressed = false;
  bool _hovered = false;

  bool get _desktop => widget.theme.desktop;
  bool get _hoverEnabled => widget.showHover ?? _desktop;

  Color? get _background {
    if (widget.active) {
      return widget.activeBackground ??
          widget.hoverBackground ??
          widget.theme.confirmBackgroundColor;
    }
    if (_pressed) {
      return widget.pressedBackground ??
          widget.theme.keyPressedBackgroundColor;
    }
    if (_hovered && _hoverEnabled) {
      return widget.hoverBackground ?? widget.theme.keyHoverBackgroundColor;
    }
    return widget.background ?? widget.theme.keyBackgroundColor;
  }

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final radius =
        widget.borderRadius ?? theme.keyBorderRadius ?? 0;
    final showBorder = widget.showBorder ?? theme.showKeyBorders;
    final borderWidth = theme.keyBorderWidth ?? 0;
    final borderColor = theme.keyBorderColor;

    Widget content = Container(
      height: widget.height,
      padding: widget.padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder && borderWidth > 0 && borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: widget.boxShadow,
      ),
      child: widget.child,
    );

    content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? widget.onTap : null,
      onTapDown: widget.enabled
          ? (_) {
              _setPressed(true);
              widget.onTapDown?.call();
            }
          : null,
      onTapUp: widget.enabled
          ? (_) {
              _setPressed(false);
              widget.onTapUp?.call();
            }
          : null,
      onTapCancel: widget.enabled
          ? () {
              _setPressed(false);
              widget.onTapCancel?.call();
            }
          : null,
      onLongPress: widget.enabled && widget.onLongPress != null
          ? widget.onLongPress
          : null,
      onLongPressStart: widget.enabled && widget.onLongPressStart != null
          ? (details) => widget.onLongPressStart!(details.globalPosition)
          : null,
      child: content,
    );

    if (_desktop) {
      content = MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (!_hoverEnabled) return;
          setState(() => _hovered = true);
        },
        onExit: (_) {
          if (!_hovered) return;
          setState(() => _hovered = false);
        },
        child: content,
      );
    }

    return Semantics(
      container: true,
      button: widget.enabled && (widget.onTap != null || widget.onTapDown != null),
      enabled: widget.enabled,
      label: widget.semanticLabel,
      child: content,
    );
  }
}
