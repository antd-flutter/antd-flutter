/// AntFloatButton — Ant Design v6 FloatButton 的 Flutter 实现
///
/// API 与 antd React 版对齐：
/// - [AntFloatButton] — 悬浮按钮（icon / content / type / shape / badge / tooltip）
/// - [AntFloatButtonGroup] — 悬浮按钮组（trigger / placement / shape / closeIcon）
/// - [AntFloatButtonBackTop] — 回到顶部（visibilityHeight / duration）
///
/// 尺寸令牌：floatButtonSize = controlHeightLG，iconSize = fontSizeIcon × 1.5，
/// 内容字号 = fontSizeSM，间距 = paddingXXS。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../../basic/tooltip/ant_tooltip.dart';
import 'ant_float_button_types.dart';

// ============================================================
// 内部：尺寸与颜色解析
// ============================================================

/// 悬浮按钮尺寸解析结果（已含 screenutil 缩放）。
class _FloatButtonMetrics {
  const _FloatButtonMetrics({
    required this.size,
    required this.iconSize,
    required this.contentFontSize,
    required this.borderRadiusCircle,
    required this.borderRadiusSquare,
    required this.gap,
  });

  /// 按钮尺寸（宽 = 高 = controlHeightLG）。
  final double size;

  /// 图标尺寸（fontSizeIcon × 1.5）。
  final double iconSize;

  /// 内容字号（fontSizeSM）。
  final double contentFontSize;

  /// 圆形圆角（= size / 2）。
  final double borderRadiusCircle;

  /// 方形圆角（= borderRadiusLG）。
  final double borderRadiusSquare;

  /// 组内按钮间距（= paddingXXS）。
  final double gap;

  factory _FloatButtonMetrics.of(AntThemeData t) {
    final rawSize = t.controlHeightLG;
    return _FloatButtonMetrics(
      size: rawSize.w,
      iconSize: (t.fontSizeIcon * 1.5).sp,
      contentFontSize: t.fontSizeSM.sp,
      borderRadiusCircle: rawSize.w / 2,
      borderRadiusSquare: t.borderRadiusLG.r,
      gap: t.paddingXXS.w,
    );
  }
}

/// 悬浮按钮某一交互态的颜色对。
class _FloatButtonColors {
  const _FloatButtonColors({required this.background, required this.foreground});
  final Color background;
  final Color foreground;
}

/// 解析悬浮按钮颜色（与 antd float-button/style 对齐）。
/// normal：bg = colorBgContainer，hover = colorFillContent，active = colorFillContentHover。
/// primary：bg = colorPrimary，hover = colorPrimaryHover，active = colorPrimaryActive。
_FloatButtonColors _resolveColors(
  AntFloatButtonType type,
  bool hovered,
  bool pressed,
  AntThemeData t,
) {
  if (type == AntFloatButtonType.primary) {
    if (pressed) {
      return _FloatButtonColors(background: t.colorPrimaryActive, foreground: t.colorWhite);
    }
    if (hovered) {
      return _FloatButtonColors(background: t.colorPrimaryHover, foreground: t.colorWhite);
    }
    return _FloatButtonColors(background: t.colorPrimary, foreground: t.colorWhite);
  }
  if (pressed) {
    return _FloatButtonColors(background: t.colorFillContentHover, foreground: t.colorText);
  }
  if (hovered) {
    return _FloatButtonColors(background: t.colorFillContent, foreground: t.colorText);
  }
  return _FloatButtonColors(background: t.colorBgContainer, foreground: t.colorText);
}

/// 向组内子按钮传递「方形组」上下文 — 子按钮省略自身边框/阴影/圆角。
class _FloatButtonGroupScope extends InheritedWidget {
  const _FloatButtonGroupScope({required this.squareGroup, required super.child});

  final bool squareGroup;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FloatButtonGroupScope>()?.squareGroup ??
      false;

  @override
  bool updateShouldNotify(_FloatButtonGroupScope oldWidget) =>
      squareGroup != oldWidget.squareGroup;
}

// ============================================================
// AntFloatButton
// ============================================================

/// Ant Design 浮动按钮。
///
/// 视觉属性从 [AntThemeData] 令牌实时解析，
/// 与 antd v6 `float-button/style/index.ts` 逐值对齐。
class AntFloatButton extends StatefulWidget {
  const AntFloatButton({
    super.key,
    this.icon,
    this.content,
    this.type = AntFloatButtonType.normal,
    this.shape = AntFloatButtonShape.circle,
    this.href,
    this.disabled = false,
    this.badge,
    this.tooltip,
    this.onClick,
  });

  /// 图标 Widget（与 [content] 二选一，icon 优先）。
  final Widget? icon;

  /// 自定义内容 Widget（icon 为空时使用）。
  final Widget? content;

  /// 按钮类型。
  final AntFloatButtonType type;

  /// 按钮形状。
  final AntFloatButtonShape shape;

  /// 链接地址（API 对齐 antd，Flutter 中建议通过 [onClick] 处理跳转）。
  final String? href;

  /// 禁用状态。
  final bool disabled;

  /// 角标配置。
  final AntFloatButtonBadge? badge;

  /// 提示文字。
  final String? tooltip;

  /// 点击回调。
  final VoidCallback? onClick;

  @override
  State<AntFloatButton> createState() => _AntFloatButtonState();
}

class _AntFloatButtonState extends State<AntFloatButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _onEnter(PointerEnterEvent _) => setState(() => _hovered = true);

  void _onExit(PointerExitEvent _) => setState(() {
    _hovered = false;
    _pressed = false;
  });

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final m = _FloatButtonMetrics.of(theme);
    final inSquareGroup = _FloatButtonGroupScope.of(context);
    final colors = _resolveColors(widget.type, _hovered, _pressed, theme);
    final isCircle = widget.shape == AntFloatButtonShape.circle;

    // ---- 内容 ----
    Widget content;
    if (widget.icon != null) {
      content = IconTheme.merge(
        data: IconThemeData(size: m.iconSize, color: colors.foreground),
        child: widget.icon!,
      );
    } else if (widget.content != null) {
      content = DefaultTextStyle.merge(
        style: TextStyle(fontSize: m.contentFontSize, color: colors.foreground),
        child: widget.content!,
      );
    } else {
      content =
          Icon(AntIcons.fileTextOutlined, size: m.iconSize, color: colors.foreground);
    }

    // ---- 容器 ----
    final borderRadius = inSquareGroup
        ? 0.0
        : (isCircle ? m.borderRadiusCircle : m.borderRadiusSquare);
    final showBorder = !inSquareGroup && !isCircle;
    final showShadow = !inSquareGroup && !widget.disabled;

    Widget button = AnimatedContainer(
      duration: theme.motionDurationMid,
      curve: Curves.easeInOut,
      width: m.size,
      height: m.size,
      decoration: BoxDecoration(
        color: widget.disabled ? theme.colorBgContainerDisabled : colors.background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: theme.colorBorderSecondary, width: theme.lineWidth)
            : null,
        boxShadow: showShadow ? theme.boxShadowSecondary : null,
      ),
      child: Center(child: content),
    );

    if (widget.disabled) {
      button = Opacity(opacity: 0.4, child: button);
    }

    // ---- 角标 ----
    if (widget.badge != null) {
      button = _BadgeDecorator(badge: widget.badge!, theme: theme, child: button);
    }

    // ---- 交互层 ----
    final interactive = !widget.disabled;
    button = MouseRegion(
      onEnter: interactive ? _onEnter : null,
      onExit: interactive ? _onExit : null,
      cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: interactive ? _onTapDown : null,
        onTapUp: interactive ? _onTapUp : null,
        onTapCancel: interactive ? _onTapCancel : null,
        onTap: interactive ? widget.onClick : null,
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );

    // ---- 提示 ----
    if (widget.tooltip != null) {
      button = AntTooltip(tooltip: Text(widget.tooltip!), child: button);
    }

    return button;
  }
}

// ============================================================
// 内部：角标装饰器
// ============================================================

class _BadgeDecorator extends StatelessWidget {
  const _BadgeDecorator({
    required this.badge,
    required this.theme,
    required this.child,
  });

  final AntFloatButtonBadge badge;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final count = badge.count ?? 0;
    if (!badge.dot && count == 0) return child;

    final badgeColor = badge.color ?? theme.colorError;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -2,
          right: -2,
          child: badge.dot
              ? Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorWhite, width: 1),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  constraints: BoxConstraints(minWidth: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8.w),
                    border: Border.all(color: theme.colorWhite, width: 1),
                  ),
                  child: Text(
                    count > badge.overflowCount ? '${badge.overflowCount}+' : '$count',
                    style: TextStyle(fontSize: 10.sp, color: theme.colorWhite, height: 1.4),
                  ),
                ),
        ),
      ],
    );
  }
}

// ============================================================
// AntFloatButtonGroup
// ============================================================

/// Ant Design 浮动按钮组。
///
/// 触发按钮在组的一端，点击/悬停展开子按钮列表。
/// - [trigger]：click（点击展开/收起）/ hover（悬停展开）
/// - [placement]：子按钮列表相对触发按钮的方位
/// - [shape]：circle（独立圆形按钮 + 间距）/ square（连体方形 + 分隔线）
class AntFloatButtonGroup extends StatefulWidget {
  const AntFloatButtonGroup({
    super.key,
    this.trigger = AntFloatButtonGroupTrigger.click,
    this.open,
    this.onOpenChange,
    this.placement = AntFloatButtonGroupPlacement.top,
    this.shape = AntFloatButtonShape.circle,
    this.closeIcon,
    this.children = const [],
  });

  /// 展开触发方式。
  final AntFloatButtonGroupTrigger trigger;

  /// 受控展开状态（为 null 时内部自管理）。
  final bool? open;

  /// 展开状态变化回调。
  final ValueChanged<bool>? onOpenChange;

  /// 子按钮列表弹出方位。
  final AntFloatButtonGroupPlacement placement;

  /// 组形状。
  final AntFloatButtonShape shape;

  /// 展开时触发按钮显示的关闭图标。
  final Widget? closeIcon;

  /// 子按钮列表。
  final List<Widget> children;

  @override
  State<AntFloatButtonGroup> createState() => _AntFloatButtonGroupState();
}

class _AntFloatButtonGroupState extends State<AntFloatButtonGroup> {
  bool _internalOpen = false;

  bool get _open => widget.open ?? _internalOpen;

  void _setOpen(bool value) {
    if (widget.open == null) setState(() => _internalOpen = value);
    widget.onOpenChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final m = _FloatButtonMetrics.of(theme);
    final isVertical = widget.placement == AntFloatButtonGroupPlacement.top ||
        widget.placement == AntFloatButtonGroupPlacement.bottom;
    final isSquare = widget.shape == AntFloatButtonShape.square;

    // ---- 触发按钮 ----
    final triggerIcon = _open
        ? (widget.closeIcon ?? const Icon(AntIcons.closeOutlined))
        : const Icon(AntIcons.ellipsisOutlined);
    final triggerButton = AntFloatButton(
      icon: triggerIcon,
      shape: widget.shape,
      onClick: widget.trigger == AntFloatButtonGroupTrigger.click
          ? () => _setOpen(!_open)
          : null,
    );

    // ---- 组装条目顺序 ----
    final childButtons = _open ? widget.children : const <Widget>[];
    final List<Widget> items;
    switch (widget.placement) {
      case AntFloatButtonGroupPlacement.top:
        items = [...childButtons, triggerButton];
      case AntFloatButtonGroupPlacement.bottom:
        items = [triggerButton, ...childButtons];
      case AntFloatButtonGroupPlacement.left:
        items = [...childButtons, triggerButton];
      case AntFloatButtonGroupPlacement.right:
        items = [triggerButton, ...childButtons];
    }

    // ---- 组容器 ----
    Widget group;
    if (isSquare) {
      group = Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.colorBgContainer,
          borderRadius: BorderRadius.circular(m.borderRadiusSquare),
          border:
              Border.all(color: theme.colorBorderSecondary, width: theme.lineWidth),
          boxShadow: theme.boxShadowSecondary,
        ),
        child: isVertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: _withDividers(items, true, theme),)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: _withDividers(items, false, theme),),
      );
    } else {
      group = isVertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: _withGaps(items, true, m),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: _withGaps(items, false, m),
            );
    }

    // 方形组上下文 — 子按钮省略自身装饰
    if (isSquare) {
      group = _FloatButtonGroupScope(squareGroup: true, child: group);
    }

    // hover 触发：鼠标在整个组上时展开
    if (widget.trigger == AntFloatButtonGroupTrigger.hover) {
      group = MouseRegion(
        onEnter: (_) => _setOpen(true),
        onExit: (_) => _setOpen(false),
        child: group,
      );
    }

    return AnimatedSize(
      duration: theme.motionDurationMid,
      curve: Curves.easeInOut,
      alignment: _expandAlignment(),
      child: group,
    );
  }

  /// 展开动画对齐方向。
  Alignment _expandAlignment() {
    switch (widget.placement) {
      case AntFloatButtonGroupPlacement.top:
        return Alignment.bottomCenter;
      case AntFloatButtonGroupPlacement.bottom:
        return Alignment.topCenter;
      case AntFloatButtonGroupPlacement.left:
        return Alignment.centerRight;
      case AntFloatButtonGroupPlacement.right:
        return Alignment.centerLeft;
    }
  }

  /// 圆形组条目间插入间距。
  List<Widget> _withGaps(List<Widget> items, bool isVertical, _FloatButtonMetrics m) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        result.add(isVertical ? SizedBox(height: m.gap) : SizedBox(width: m.gap));
      }
      result.add(items[i]);
    }
    return result;
  }

  /// 方形组条目间插入分隔线。
  List<Widget> _withDividers(
      List<Widget> items, bool isVertical, AntThemeData theme,) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        result.add(isVertical
            ? Divider(
                height: theme.lineWidth,
                thickness: theme.lineWidth,
                color: theme.colorBorderSecondary,
              )
            : VerticalDivider(
                width: theme.lineWidth,
                thickness: theme.lineWidth,
                color: theme.colorBorderSecondary,
              ),);
      }
      result.add(items[i]);
    }
    return result;
  }
}

// ============================================================
// AntFloatButtonBackTop
// ============================================================

/// Ant Design 回到顶部按钮。
///
/// 监听滚动位置，超过 [visibilityHeight] 时显示；
/// 点击后平滑滚动回顶部。
class AntFloatButtonBackTop extends StatefulWidget {
  const AntFloatButtonBackTop({
    super.key,
    this.visibilityHeight = 400,
    this.duration = const Duration(milliseconds: 450),
    this.onClick,
    this.icon,
    this.type = AntFloatButtonType.normal,
    this.shape = AntFloatButtonShape.circle,
    this.badge,
    this.tooltip,
    this.scrollController,
  });

  /// 滚动超过此偏移量时显示按钮。
  final double visibilityHeight;

  /// 回顶滚动动画时长。
  final Duration duration;

  /// 点击回调（回顶动画之后触发）。
  final VoidCallback? onClick;

  /// 自定义图标（默认 verticalAlignTopOutlined）。
  final Widget? icon;

  /// 按钮类型。
  final AntFloatButtonType type;

  /// 按钮形状。
  final AntFloatButtonShape shape;

  /// 角标配置。
  final AntFloatButtonBadge? badge;

  /// 提示文字。
  final String? tooltip;

  /// 滚动控制器（为 null 时从 [PrimaryScrollController] 解析）。
  final ScrollController? scrollController;

  @override
  State<AntFloatButtonBackTop> createState() => _AntFloatButtonBackTopState();
}

class _AntFloatButtonBackTopState extends State<AntFloatButtonBackTop> {
  bool _visible = false;
  ScrollController? _attached;

  ScrollController? _resolveController() {
    return widget.scrollController ?? PrimaryScrollController.maybeOf(context);
  }

  void _onScroll() {
    final controller = _attached;
    if (controller == null || !controller.hasClients) return;
    final shouldShow = controller.position.pixels > widget.visibilityHeight;
    if (shouldShow != _visible) setState(() => _visible = shouldShow);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _resolveController();
    if (controller != _attached) {
      _attached?.removeListener(_onScroll);
      _attached = controller;
      _attached?.addListener(_onScroll);
      _onScroll();
    }
  }

  @override
  void dispose() {
    _attached?.removeListener(_onScroll);
    super.dispose();
  }

  void _backToTop() {
    final controller = _attached;
    if (controller != null && controller.hasClients) {
      controller.animateTo(0, duration: widget.duration, curve: Curves.easeInOutCirc);
    }
    widget.onClick?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return IgnorePointer(
      ignoring: !_visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: theme.motionDurationMid,
        curve: Curves.easeInOut,
        child: AntFloatButton(
          icon: widget.icon ?? const Icon(AntIcons.verticalAlignTopOutlined),
          type: widget.type,
          shape: widget.shape,
          badge: widget.badge,
          tooltip: widget.tooltip,
          onClick: _backToTop,
        ),
      ),
    );
  }
}