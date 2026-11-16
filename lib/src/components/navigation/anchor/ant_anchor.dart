/// AntAnchor — antd React Anchor 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 锚点链接项列表
/// - [direction] — vertical / horizontal
/// - [controller] — 受控激活状态
/// - [onClick] — 点击链接回调
/// - [onChange] — 激活项变化回调
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import 'ant_anchor_types.dart';

// ============================================================
// AntAnchor
// ============================================================

/// 锚点 — 用于跳转到页面指定位置。
///
/// 对齐 antd React Anchor 组件，支持垂直/水平方向、
/// 受控激活状态、点击与变化回调。
///
/// ```dart
/// AntAnchor(
///   items: [
///     AntAnchorItem(key: 'part-1', title: 'Part 1'),
///     AntAnchorItem(key: 'part-2', title: 'Part 2'),
///   ],
///   onClick: (key) => print('clicked: $key'),
/// )
/// ```
class AntAnchor extends StatefulWidget {
  const AntAnchor({
    super.key,
    this.items = const [],
    this.direction = AntAnchorDirection.vertical,
    this.controller,
    this.onClick,
    this.onChange,
  });

  /// 锚点链接项列表。
  final List<AntAnchorItem> items;

  /// 锚点方向。
  final AntAnchorDirection direction;

  /// 受控控制器。
  final AntAnchorController? controller;

  /// 点击链接回调。
  final ValueChanged<String>? onClick;

  /// 激活项变化回调。
  final ValueChanged<String?>? onChange;

  @override
  State<AntAnchor> createState() => _AntAnchorState();
}

class _AntAnchorState extends State<AntAnchor> {
  AntAnchorController? _internalController;

  AntAnchorController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = AntAnchorController();
    }
    _controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant AntAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      if (widget.controller == null) {
        _internalController ??= AntAnchorController();
      }
      _controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) setState(() {});
    widget.onChange?.call(_controller.activeKey);
  }

  void _handleClick(AntAnchorItem item) {
    widget.onClick?.call(item.key);
    _controller.setActive(item.key);
  }

  bool _isActive(AntAnchorItem item) =>
      _controller.activeKey == item.key;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    if (widget.direction == AntAnchorDirection.horizontal) {
      return _buildHorizontal(context);
    }
    return _buildVertical(context);
  }

  // ------------------------------------------------------------
  // 垂直方向
  // ------------------------------------------------------------

  Widget _buildVertical(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 4),
      child: Ink(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorSplit, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _buildVerticalItems(context, theme, widget.items),
        ),
      ),
    );
  }

  List<Widget> _buildVerticalItems(
    BuildContext context,
    AntThemeData theme,
    List<AntAnchorItem> items,
  ) {
    final children = <Widget>[];
    for (final item in items) {
      children.add(_buildVerticalItem(context, theme, item));
      if (item.children.isNotEmpty) {
        children.addAll(
          _buildVerticalChildren(context, theme, item.children),
        );
      }
    }
    return children;
  }

  List<Widget> _buildVerticalChildren(
    BuildContext context,
    AntThemeData theme,
    List<AntAnchorItem> items,
  ) {
    final children = <Widget>[];
    for (final item in items) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildVerticalItem(context, theme, item),
        ),
      );
    }
    return children;
  }

  Widget _buildVerticalItem(
    BuildContext context,
    AntThemeData theme,
    AntAnchorItem item,
  ) {
    final active = _isActive(item);
    return GestureDetector(
      onTap: () => _handleClick(item),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active ? theme.colorPrimary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: item.titleWidget ??
              Text(
                item.title ?? item.key,
                style: TextStyle(
                  fontSize: theme.fontSizeSM,
                  color: active
                      ? theme.colorPrimary
                      : theme.colorTextSecondary,
                  fontWeight: active ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 水平方向
  // ------------------------------------------------------------

  Widget _buildHorizontal(BuildContext context) {
    final theme = AntTheme.of(context);
    final items = <Widget>[];
    for (final item in widget.items) {
      items.add(_buildHorizontalItem(context, theme, item));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(children: items),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalItem(
    BuildContext context,
    AntThemeData theme,
    AntAnchorItem item,
  ) {
    final active = _isActive(item);
    return GestureDetector(
      onTap: () => _handleClick(item),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? theme.colorPrimary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: item.titleWidget ??
              Text(
                item.title ?? item.key,
                style: TextStyle(
                  fontSize: theme.fontSizeSM,
                  color: active
                      ? theme.colorPrimary
                      : theme.colorTextSecondary,
                  fontWeight: active ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
        ),
      ),
    );
  }
}