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
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

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
/// AntAnchor<Section>(
///   items: sections,
///   keyOf: (section) => section.id,
///   titleBuilder: (context, section, index) => Text(section.title),
///   onClick: (section) => print('clicked: ${section.id}'),
/// )
/// ```
class AntAnchor<T> extends StatefulWidget {
  const AntAnchor({
    super.key,
    this.items = const [],
    this.keyOf,
    this.titleBuilder,
    this.childrenOf,
    this.direction = AntAnchorDirection.vertical,
    this.controller,
    this.onClick,
    this.onChange,
    this.scrollController,
    this.targetKeys = const {},
    this.topOffset = 0,
    this.autoScroll = true,
    this.scrollDuration = const Duration(milliseconds: 300),
  });

  /// 锚点链接项列表。
  final List<T> items;

  /// 提取锚点唯一标识，默认使用扁平化后的下标。
  final Object Function(T item)? keyOf;

  /// 标题构建器，未提供时回退为 `Text('$item')`。
  final AntAnchorTitleBuilder<T>? titleBuilder;

  /// 子锚点提取器，用于嵌套锚点。
  final List<T> Function(T item)? childrenOf;

  /// 锚点方向。
  final AntAnchorDirection direction;

  /// 受控控制器。
  final AntAnchorController? controller;

  /// 点击链接回调。
  final ValueChanged<T>? onClick;

  /// 激活项变化回调。
  final ValueChanged<Object?>? onChange;

  /// 页面内容区的滚动控制器。
  ///
  /// 提供后锚点会监听滚动、自动高亮当前可视区块，并在点击时滚动到目标区块。
  final ScrollController? scrollController;

  /// 锚点 key → 内容区块 [GlobalKey] 的映射。
  ///
  /// 用于定位各区块位置；缺失的 key 只参与高亮切换，不触发滚动。
  final Map<Object, GlobalKey> targetKeys;

  /// 滚动定位时预留的顶部偏移（例如固定导航栏高度）。
  final double topOffset;

  /// 点击锚点后是否自动滚动到目标区块。
  final bool autoScroll;

  /// 点击后滚动动画时长。
  final Duration scrollDuration;

  @override
  State<AntAnchor<T>> createState() => _AntAnchorState<T>();
}

class _AntAnchorState<T> extends State<AntAnchor<T>> {
  AntAnchorController? _internalController;

  /// 点击触发的滚动期间忽略滚动监听，避免高亮抖动。
  bool _programmaticScroll = false;

  AntAnchorController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = AntAnchorController();
    }
    _controller.addListener(_handleControllerChange);
    widget.scrollController?.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncActiveFromScroll();
    });
  }

  @override
  void didUpdateWidget(covariant AntAnchor<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      if (widget.controller == null) {
        _internalController ??= AntAnchorController();
      }
      _controller.addListener(_handleControllerChange);
    }
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_handleScroll);
      widget.scrollController?.addListener(_handleScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncActiveFromScroll();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    widget.scrollController?.removeListener(_handleScroll);
    _internalController?.dispose();
    super.dispose();
  }

  Object _keyOf(T item) {
    final key = widget.keyOf?.call(item);
    if (key != null) return key;
    return _flattenItems(widget.items).indexOf(item);
  }

  List<T> _childrenOf(T item) => widget.childrenOf?.call(item) ?? <T>[];

  void _handleControllerChange() {
    if (mounted) setState(() {});
    widget.onChange?.call(_controller.activeKey);
  }

  void _handleClick(T item) {
    final key = _keyOf(item);
    widget.onClick?.call(item);
    _controller.setActive(key);
    _scrollTo(key);
  }

  // ------------------------------------------------------------
  // 滚动联动
  // ------------------------------------------------------------

  void _handleScroll() {
    if (_programmaticScroll) return;
    _syncActiveFromScroll();
  }

  /// 区块顶部在滚动内容坐标系中的偏移。
  double? _revealOffset(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) return null;
    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return null;
    return viewport.getOffsetToReveal(renderObject, 0).offset;
  }

  /// 按内容顺序取「最后一个顶部已滚过阈值」的区块作为激活项。
  void _syncActiveFromScroll() {
    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) return;
    if (widget.targetKeys.isEmpty) return;

    final threshold = controller.position.pixels + widget.topOffset + 0.5;
    Object? active;
    for (final item in _flattenItems(widget.items)) {
      final key = widget.targetKeys[_keyOf(item)];
      if (key == null) continue;
      final offset = _revealOffset(key);
      if (offset == null) continue;
      if (offset <= threshold) active = _keyOf(item);
    }
    if (active != null) _controller.setActive(active);
  }

  Future<void> _scrollTo(Object key) async {
    if (!widget.autoScroll) return;
    final targetContext = widget.targetKeys[key]?.currentContext;
    if (targetContext == null) return;

    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) {
      // 没有显式控制器时退化为 Scrollable.ensureVisible。
      await Scrollable.ensureVisible(
        targetContext,
        duration: widget.scrollDuration,
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final reveal = _revealOffset(widget.targetKeys[key]!);
    if (reveal == null) return;
    final position = controller.position;
    final desired = (reveal - widget.topOffset).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((desired - position.pixels).abs() < 0.5) return;

    _programmaticScroll = true;
    try {
      await controller.animateTo(
        desired.toDouble(),
        duration: widget.scrollDuration,
        curve: Curves.easeInOutCubic,
      );
    } finally {
      _programmaticScroll = false;
      if (mounted) _syncActiveFromScroll();
    }
  }

  List<T> _flattenItems(List<T> items) {
    final result = <T>[];
    for (final item in items) {
      result.add(item);
      final children = _childrenOf(item);
      if (children.isNotEmpty) {
        result.addAll(_flattenItems(children));
      }
    }
    return result;
  }

  bool _isActive(T item) => _controller.activeKey == _keyOf(item);

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
    List<T> items,
  ) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      children.add(_buildVerticalItem(context, theme, item, i));
      final nested = _childrenOf(item);
      if (nested.isNotEmpty) {
        children.addAll(
          _buildVerticalChildren(context, theme, nested),
        );
      }
    }
    return children;
  }

  List<Widget> _buildVerticalChildren(
    BuildContext context,
    AntThemeData theme,
    List<T> items,
  ) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildVerticalItem(context, theme, items[i], i),
        ),
      );
    }
    return children;
  }

  Widget _buildVerticalItem(
    BuildContext context,
    AntThemeData theme,
    T item,
    int index,
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
          child: _buildTitle(context, theme, item, index, active),
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
    for (var i = 0; i < widget.items.length; i++) {
      items.add(
        _buildHorizontalItem(context, theme, widget.items[i], i),
      );
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
    T item,
    int index,
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
          child: _buildTitle(context, theme, item, index, active),
        ),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    AntThemeData theme,
    T item,
    int index,
    bool active,
  ) {
    final title =
        widget.titleBuilder?.call(context, item, index) ?? Text('$item');
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: theme.fontSizeSM,
        color: active ? theme.colorPrimary : theme.colorTextSecondary,
        fontWeight: active ? FontWeight.w500 : FontWeight.normal,
      ),
      child: title,
    );
  }
}
