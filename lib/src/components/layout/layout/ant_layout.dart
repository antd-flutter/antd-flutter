/// AntLayout — antd React Layout 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [AntLayout] — 布局容器，组合 Sider / Header / Content / Footer
/// - [AntLayoutSider] — 侧边栏（支持折叠、断点响应、深/浅主题）
/// - [AntLayoutHeader] — 顶部区域（高度 64）
/// - [AntLayoutContent] — 内容区域（flex 自动填充）
/// - [AntLayoutFooter] — 底部区域（padding 24×50）
///
/// 尺寸令牌：headerHeight = 64，siderWidth = 200，siderCollapsedWidth = 80。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import 'ant_layout_types.dart';

/// 深色侧边栏背景色（antd dark sider token）。
const Color _kSiderDarkBg = Color(0xFF001529);

/// 深色侧边栏触发器背景色（antd dark sider trigger token）。
const Color _kSiderDarkTriggerBg = Color(0xFF002140);

/// 侧边栏默认宽度。
const double _kSiderWidth = 200;

/// 侧边栏折叠后宽度。
const double _kSiderCollapsedWidth = 80;

/// 顶部区域高度。
const double _kHeaderHeight = 64;

// ============================================================
// AntLayout
// ============================================================

/// 布局容器 — 协调侧边栏与主区域的页面骨架。
///
/// 对齐 antd React Layout 组件，通过命名插槽组合各布局区域：
///
/// ```dart
/// AntLayout(
///   sider: AntLayoutSider(child: Text('侧边栏')),
///   header: AntLayoutHeader(child: Text('顶部')),
///   content: AntLayoutContent(child: Text('内容')),
///   footer: AntLayoutFooter(child: Text('底部')),
/// )
/// ```
class AntLayout extends StatelessWidget {
  const AntLayout({
    super.key,
    this.sider,
    this.header,
    this.content,
    this.footer,
  });

  /// 侧边栏区域。提供时布局为「侧边栏 + 主区域」水平结构。
  final AntLayoutSider? sider;

  /// 顶部区域。
  final Widget? header;

  /// 内容区域。占据主区域剩余空间。
  final Widget? content;

  /// 底部区域。
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final mainArea = Column(
      children: [
        if (header != null) header!,
        if (content != null)
          Expanded(child: content!)
        else
          const Expanded(child: SizedBox.shrink()),
        if (footer != null) footer!,
      ],
    );

    final siderWidget = sider;
    if (siderWidget == null) {
      return mainArea;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        siderWidget,
        Expanded(child: mainArea),
      ],
    );
  }
}

// ============================================================
// AntLayoutSider
// ============================================================

/// 侧边栏 — 可折叠的页面侧边导航容器。
///
/// 对齐 antd React Layout.Sider 组件。
///
/// ```dart
/// AntLayoutSider(
///   collapsible: true,
///   child: Text('侧边内容'),
///   onCollapse: (collapsed) => print(collapsed),
/// )
/// ```
class AntLayoutSider extends StatefulWidget {
  const AntLayoutSider({
    super.key,
    this.width = _kSiderWidth,
    this.collapsedWidth = _kSiderCollapsedWidth,
    this.collapsible = false,
    this.defaultCollapsed = false,
    this.collapsed,
    this.theme = AntLayoutSiderTheme.dark,
    this.breakpoint,
    this.trigger,
    this.child,
    this.onCollapse,
    this.onBreakpoint,
  });

  /// 展开宽度。默认 200。
  final double width;

  /// 折叠后宽度。默认 80。
  final double collapsedWidth;

  /// 是否可折叠。为 true 时底部显示折叠触发器。
  final bool collapsible;

  /// 初始是否折叠（非受控模式）。
  final bool defaultCollapsed;

  /// 受控折叠状态。非 null 时由外部控制，null 时内部管理。
  final bool? collapsed;

  /// 主题。默认 dark。
  final AntLayoutSiderTheme theme;

  /// 响应式断点（逻辑像素）。屏幕宽度小于此值时自动折叠。
  final double? breakpoint;

  /// 自定义折叠触发器。为 null 时使用默认箭头图标。
  final Widget? trigger;

  /// 子元素。
  final Widget? child;

  /// 折叠状态变化回调。
  final ValueChanged<bool>? onCollapse;

  /// 触发响应式断点回调。
  final VoidCallback? onBreakpoint;

  @override
  State<AntLayoutSider> createState() => _AntLayoutSiderState();
}

class _AntLayoutSiderState extends State<AntLayoutSider> {
  late bool _collapsed;
  bool _breakpointTriggered = false;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.defaultCollapsed;
  }

  @override
  void didUpdateWidget(AntLayoutSider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 受控模式：同步外部状态
    if (widget.collapsed != null && widget.collapsed != _collapsed) {
      _collapsed = widget.collapsed!;
    }
  }

  /// 当前是否折叠（受控优先）。
  bool get _effectiveCollapsed => widget.collapsed ?? _collapsed;

  void _toggle() {
    final next = !_effectiveCollapsed;
    if (widget.collapsed == null) {
      setState(() => _collapsed = next);
    }
    widget.onCollapse?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final isDark = widget.theme == AntLayoutSiderTheme.dark;
    final bgColor = isDark ? _kSiderDarkBg : theme.colorBgContainer;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 响应式断点检测
        final bp = widget.breakpoint;
        if (bp != null && constraints.maxWidth.isFinite) {
          final shouldCollapse = constraints.maxWidth < bp;
          if (shouldCollapse && !_breakpointTriggered) {
            _breakpointTriggered = true;
            if (!_effectiveCollapsed) {
              // build 阶段直接修改内部状态（受控模式由 onCollapse 通知外部）
              _collapsed = true;
              widget.onCollapse?.call(true);
            }
            widget.onBreakpoint?.call();
          } else if (!shouldCollapse && _breakpointTriggered) {
            _breakpointTriggered = false;
            if (_effectiveCollapsed) {
              _collapsed = false;
              widget.onCollapse?.call(false);
            }
          }
        }

        final currentWidth =
            _effectiveCollapsed ? widget.collapsedWidth : widget.width;
        final scaledWidth = currentWidth.w;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: scaledWidth,
          color: bgColor,
          child: Column(
            children: [
              Expanded(
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: 0,
                    maxWidth: double.infinity,
                    minHeight: 0,
                    maxHeight: constraints.maxHeight,
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: widget.width.w,
                      child: widget.child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              if (widget.collapsible) _buildTrigger(theme, isDark),
            ],
          ),
        );
      },
    );
  }

  /// 构建折叠触发器。
  Widget _buildTrigger(AntThemeData theme, bool isDark) {
    final customTrigger = widget.trigger;
    if (customTrigger != null) {
      return InkWell(
        onTap: _toggle,
        child: customTrigger,
      );
    }

    final triggerBg = isDark ? _kSiderDarkTriggerBg : theme.colorBgLayout;
    final iconColor =
        isDark ? const Color(0xB3FFFFFF) : theme.colorTextSecondary;

    return InkWell(
      onTap: _toggle,
      child: Container(
        height: _kHeaderHeight.w * 0.75,
        color: triggerBg,
        alignment: Alignment.center,
        child: AntdIcon(
          _effectiveCollapsed ? AntIcons.menuUnfoldOutlined : AntIcons.menuFoldOutlined,
          size: theme.fontSizeIcon,
          color: iconColor,
        ),
      ),
    );
  }
}

// ============================================================
// AntLayoutHeader
// ============================================================

/// 顶部区域 — 页面顶栏容器。
///
/// 对齐 antd React Layout.Header 组件，高度 64，背景 colorBgContainer。
class AntLayoutHeader extends StatelessWidget {
  const AntLayoutHeader({super.key, this.child, this.height});

  /// 子元素。
  final Widget? child;

  /// 自定义高度。默认 64。
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final h = (height ?? _kHeaderHeight).w;

    return Container(
      height: h,
      color: theme.colorBgContainer,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: theme.margin.w),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

// ============================================================
// AntLayoutContent
// ============================================================

/// 内容区域 — 页面主体内容容器。
///
/// 对齐 antd React Layout.Content 组件，flex 自动填充剩余空间。
class AntLayoutContent extends StatelessWidget {
  const AntLayoutContent({super.key, this.child, this.padding});

  /// 子元素。
  final Widget? child;

  /// 内边距。为 null 时无内边距（antd Content 无默认 padding）。
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    Widget content = child ?? const SizedBox.shrink();

    final p = padding;
    if (p != null) {
      content = Padding(padding: p, child: content);
    }

    return ColoredBox(
      color: theme.colorBgLayout,
      child: content,
    );
  }
}

// ============================================================
// AntLayoutFooter
// ============================================================

/// 底部区域 — 页面底栏容器。
///
/// 对齐 antd React Layout.Footer 组件，padding 24×50，
/// 背景 colorBgLayout，文字 colorTextSecondary。
class AntLayoutFooter extends StatelessWidget {
  const AntLayoutFooter({super.key, this.child, this.padding});

  /// 子元素。
  final Widget? child;

  /// 自定义内边距。默认 24×50。
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final p = padding ??
        EdgeInsets.symmetric(
          horizontal: (50).w,
          vertical: (24).w,
        );

    return Container(
      padding: p,
      color: theme.colorBgLayout,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: theme.fontSize.sp,
          color: theme.colorTextSecondary,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}