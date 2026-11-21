/// AntIndexBar — antd-mobile IndexBar 索引栏的 Flutter 实现
///
/// 对齐 antd-mobile v5：
/// - 分组标题由 [AntIndexBar.titleBuilder] 渲染，吸顶时固定在顶部（`sticky`）；
/// - 右侧竖排索引字母，点击/拖动跳转到对应分组；
/// - 交互时在字母左侧显示当前字母气泡；
/// - 滚动内容时自动切换当前索引并回调 `onChange`。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_index_bar_types.dart';

// ============================================================
// AntIndexBarController
// ============================================================

/// [AntIndexBar] 的控制器，用于编程式滚动到指定索引。
class AntIndexBarController {
  _AntIndexBarState<dynamic>? _state;

  /// 滚动到 [index] 对应的分组。
  void scrollTo(Object index) => _state?.scrollTo(index);

  void _attach(_AntIndexBarState<dynamic> state) => _state = state;

  void _detach(_AntIndexBarState<dynamic> state) {
    if (identical(_state, state)) _state = null;
  }
}

// ============================================================
// AntIndexBar
// ============================================================

/// 索引栏 — 通讯录式字母索引导航。
///
/// 需要外层给定高度（内部自管理滚动区域）。
///
/// ```dart
/// SizedBox(
///   height: 400,
///   child: AntIndexBar<Contact>(
///     items: contacts,
///     keyOf: (contact) => contact.initial,
///     titleBuilder: (context, contact, index) => Text(contact.initial),
///     childBuilder: (context, contact) => Text(contact.name),
///   ),
/// )
/// ```
class AntIndexBar<T> extends StatefulWidget {
  const AntIndexBar({
    super.key,
    required this.items,
    this.keyOf,
    this.titleBuilder,
    this.briefBuilder,
    this.childBuilder,
    this.sticky = true,
    this.controller,
    this.onChange,
  });

  /// 分组项列表。
  final List<T> items;

  /// 提取分组索引（如 'A'、'B'），默认使用下标。
  final Object Function(T item)? keyOf;

  /// 分组标题构建器，未提供时回退为 `Text('$item')`。
  final AntIndexBarTitleBuilder<T>? titleBuilder;

  /// 右侧索引字母构建器，未提供时取索引首字符。
  final AntIndexBarBriefBuilder<T>? briefBuilder;

  /// 分组内容构建器。
  final AntIndexBarChildBuilder<T>? childBuilder;

  /// 分组标题是否吸顶。默认 true。
  final bool sticky;

  /// 控制器，可调用 [AntIndexBarController.scrollTo] 跳转分组。
  final AntIndexBarController? controller;

  /// 当前索引变化回调（点击、拖动或滚动均会触发）。
  final ValueChanged<Object>? onChange;

  @override
  State<AntIndexBar<T>> createState() => _AntIndexBarState<T>();
}

class _AntIndexBarState<T> extends State<AntIndexBar<T>> {
  static const double _headerHeight = 35;
  static const double _rowHeight = 16;
  static const double _rowWidth = 40;
  static const double _bubbleSize = 47;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _rootKey = GlobalKey();
  final Map<Object, GlobalKey> _panelKeys = <Object, GlobalKey>{};
  final List<GlobalKey> _rowKeys = <GlobalKey>[];

  Object? _activeIndex;
  bool _interacting = false;
  bool _pinned = false;

  Object _keyAt(int index) => widget.keyOf?.call(widget.items[index]) ?? index;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.items.isEmpty ? null : _keyAt(0);
    widget.controller?._attach(this);
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handleScroll();
    });
  }

  @override
  void didUpdateWidget(covariant AntIndexBar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (oldWidget.items != widget.items) {
      final valid =
          widget.items.any((item) => _keyOfItem(item) == _activeIndex);
      if (!valid) {
        _activeIndex = widget.items.isEmpty ? null : _keyAt(0);
        _pinned = false;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Object _keyOfItem(T item) {
    final index = widget.items.indexOf(item);
    return widget.keyOf?.call(item) ?? index;
  }

  // ------------------------------------------------------------
  // 对外
  // ------------------------------------------------------------

  /// 滚动到指定索引分组。
  void scrollTo(Object index) {
    final offset = _panelOffset(index);
    if (offset == null) return;
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      _scrollController.jumpTo(
        offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      );
    }
    _setActive(index);
  }

  // ------------------------------------------------------------
  // 内部
  // ------------------------------------------------------------

  GlobalKey _panelKeyFor(Object index) =>
      _panelKeys.putIfAbsent(index, GlobalKey.new);

  GlobalKey _rowKeyFor(int i) {
    while (_rowKeys.length <= i) {
      _rowKeys.add(GlobalKey());
    }
    return _rowKeys[i];
  }

  T? _itemByIndex(Object? index) {
    if (index == null) return null;
    for (var i = 0; i < widget.items.length; i++) {
      if (_keyAt(i) == index) return widget.items[i];
    }
    return null;
  }

  int _indexOf(Object? index) {
    if (index == null) return -1;
    for (var i = 0; i < widget.items.length; i++) {
      if (_keyAt(i) == index) return i;
    }
    return -1;
  }

  /// 分组顶部在滚动内容坐标系中的偏移。
  double? _panelOffset(Object index) {
    final renderObject = _panelKeys[index]?.currentContext?.findRenderObject();
    if (renderObject == null) return null;
    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return null;
    return viewport.getOffsetToReveal(renderObject, 0).offset;
  }

  void _handleScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final offset = _scrollController.offset;

    Object? active;
    for (var i = 0; i < widget.items.length; i++) {
      final key = _keyAt(i);
      final top = _panelOffset(key);
      if (top == null) continue;
      if (top <= offset + 0.5) active = key;
    }
    active ??= widget.items.isEmpty ? null : _keyAt(0);
    if (active != null) _setActive(active);

    final activeTop = active == null ? null : _panelOffset(active);
    final pinned =
        activeTop != null && offset > activeTop + 0.5 && widget.sticky;
    if (pinned != _pinned) setState(() => _pinned = pinned);
  }

  void _setActive(Object index) {
    if (_activeIndex == index) return;
    setState(() => _activeIndex = index);
    widget.onChange?.call(index);
  }

  void _startInteraction(double globalY) {
    setState(() => _interacting = true);
    _activateAt(globalY);
  }

  void _endInteraction() {
    if (!_interacting) return;
    setState(() => _interacting = false);
  }

  void _activateAt(double globalY) {
    final index = _indexFromGlobalY(globalY);
    if (index == null) return;
    scrollTo(_keyAt(index));
  }

  int? _indexFromGlobalY(double globalY) {
    int? nearest;
    var minDistance = double.infinity;
    for (var i = 0; i < widget.items.length && i < _rowKeys.length; i++) {
      final box = _rowKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (globalY >= top && globalY < top + box.size.height) return i;
      final center = top + box.size.height / 2;
      final distance = (globalY - center).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearest = i;
      }
    }
    return nearest;
  }

  double? _activeRowCenterY() {
    final i = _indexOf(_activeIndex);
    if (i < 0 || i >= _rowKeys.length) return null;
    final rowBox = _rowKeys[i].currentContext?.findRenderObject() as RenderBox?;
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rowBox == null || rootBox == null || !rowBox.hasSize) return null;
    final rowTop = rowBox.localToGlobal(Offset.zero).dy;
    final rootTop = rootBox.localToGlobal(Offset.zero).dy;
    return rowTop - rootTop + rowBox.size.height / 2;
  }

  /// 索引默认展示字符：字符串取首字符，其它类型取字符串形式。
  String _briefText(Object index) {
    if (index is String) {
      return index.isEmpty ? '' : index.substring(0, 1);
    }
    final text = '$index';
    return text.isEmpty ? '' : text.substring(0, 1);
  }

  // ------------------------------------------------------------
  // 构建
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final items = widget.items;

    return Stack(
      key: _rootKey,
      children: [
        Positioned.fill(
          child: ColoredBox(
            color: theme.colorBgContainer,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++)
                    Column(
                      key: _panelKeyFor(_keyAt(i)),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(
                          theme,
                          widget.titleBuilder?.call(context, items[i], i) ??
                              Text('${items[i]}'),
                        ),
                        if (widget.childBuilder?.call(context, items[i]) !=
                            null)
                          widget.childBuilder!(context, items[i])!,
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.sticky && _pinned) _buildStickyHeader(theme),
        _buildSidebar(theme),
        if (_interacting && _activeIndex != null) _buildBubble(theme),
      ],
    );
  }

  Widget _buildHeader(AntThemeData theme, Widget title) {
    return Container(
      height: _headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      color: Color.alphaBlend(theme.colorFillContent, theme.colorBgContainer),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: 13,
          height: 1,
          color: theme.colorTextTertiary,
        ),
        child: title,
      ),
    );
  }

  Widget _buildStickyHeader(AntThemeData theme) {
    final item = _itemByIndex(_activeIndex);
    if (item == null) return const SizedBox.shrink();
    final index = _indexOf(_activeIndex);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: _buildHeader(
          theme,
          widget.titleBuilder?.call(context, item, index) ?? Text('$item'),
        ),
      ),
    );
  }

  Widget _buildSidebar(AntThemeData theme) {
    final items = widget.items;
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) => _startInteraction(event.position.dy),
          onPointerMove: (event) {
            if (_interacting) _activateAt(event.position.dy);
          },
          onPointerUp: (_) => _endInteraction(),
          onPointerCancel: (_) => _endInteraction(),
          child: SizedBox(
            width: _rowWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < items.length; i++)
                  _buildSidebarRow(theme, items[i], i),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarRow(AntThemeData theme, T item, int i) {
    final active = _keyAt(i) == _activeIndex;
    return SizedBox(
      key: _rowKeyFor(i),
      width: _rowWidth,
      height: _rowHeight,
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? theme.colorPrimary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color:
                  active ? theme.colorTextLightSolid : theme.colorTextTertiary,
            ),
            child: widget.briefBuilder?.call(context, item) ??
                Text(_briefText(_keyAt(i))),
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(AntThemeData theme) {
    final item = _itemByIndex(_activeIndex);
    final centerY = _activeRowCenterY();
    if (item == null || centerY == null) return const SizedBox.shrink();
    return Positioned(
      right: 60,
      top: centerY - _bubbleSize / 2,
      child: IgnorePointer(
        child: Container(
          width: _bubbleSize,
          height: _bubbleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorBorder,
            shape: BoxShape.circle,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 25,
              height: 1,
              color: theme.colorTextLightSolid,
            ),
            child: widget.briefBuilder?.call(context, item) ??
                Text(_briefText(_activeIndex!)),
          ),
        ),
      ),
    );
  }
}
