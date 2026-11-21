/// AntIndexBar — antd-mobile IndexBar 索引栏的 Flutter 实现
///
/// 对齐 antd-mobile v5：
/// - 分组标题 [AntIndexBarItem.title]，吸顶时固定在顶部（`sticky`）；
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
  _AntIndexBarState? _state;

  /// 滚动到 [index] 对应的分组。
  void scrollTo(String index) => _state?.scrollTo(index);

  void _attach(_AntIndexBarState state) => _state = state;

  void _detach(_AntIndexBarState state) {
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
///   child: AntIndexBar(
///     items: [
///       AntIndexBarItem(index: 'A', child: Text('A 组内容')),
///       AntIndexBarItem(index: 'B', child: Text('B 组内容')),
///     ],
///     onChange: (index) => print(index),
///   ),
/// )
/// ```
class AntIndexBar extends StatefulWidget {
  const AntIndexBar({
    super.key,
    required this.items,
    this.sticky = true,
    this.controller,
    this.onChange,
  });

  /// 分组项列表。
  final List<AntIndexBarItem> items;

  /// 分组标题是否吸顶。默认 true。
  final bool sticky;

  /// 控制器，可调用 [AntIndexBarController.scrollTo] 跳转分组。
  final AntIndexBarController? controller;

  /// 当前索引变化回调（点击、拖动或滚动均会触发）。
  final ValueChanged<String>? onChange;

  @override
  State<AntIndexBar> createState() => _AntIndexBarState();
}

class _AntIndexBarState extends State<AntIndexBar> {
  static const double _headerHeight = 35;
  static const double _rowHeight = 16;
  static const double _rowWidth = 40;
  static const double _bubbleSize = 47;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _rootKey = GlobalKey();
  final Map<String, GlobalKey> _panelKeys = <String, GlobalKey>{};
  final List<GlobalKey> _rowKeys = <GlobalKey>[];

  String? _activeIndex;
  bool _interacting = false;
  bool _pinned = false;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.items.isEmpty ? null : widget.items.first.index;
    widget.controller?._attach(this);
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handleScroll();
    });
  }

  @override
  void didUpdateWidget(covariant AntIndexBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (oldWidget.items != widget.items) {
      final valid = widget.items.any((item) => item.index == _activeIndex);
      if (!valid) {
        _activeIndex = widget.items.isEmpty ? null : widget.items.first.index;
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

  // ------------------------------------------------------------
  // 对外
  // ------------------------------------------------------------

  /// 滚动到指定索引分组。
  void scrollTo(String index) {
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

  GlobalKey _panelKeyFor(String index) =>
      _panelKeys.putIfAbsent(index, GlobalKey.new);

  GlobalKey _rowKeyFor(int i) {
    while (_rowKeys.length <= i) {
      _rowKeys.add(GlobalKey());
    }
    return _rowKeys[i];
  }

  AntIndexBarItem? _itemByIndex(String? index) {
    if (index == null) return null;
    for (final item in widget.items) {
      if (item.index == index) return item;
    }
    return null;
  }

  /// 分组顶部在滚动内容坐标系中的偏移。
  double? _panelOffset(String index) {
    final renderObject =
        _panelKeys[index]?.currentContext?.findRenderObject();
    if (renderObject == null) return null;
    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return null;
    return viewport.getOffsetToReveal(renderObject, 0).offset;
  }

  void _handleScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final offset = _scrollController.offset;

    String? active;
    for (final item in widget.items) {
      final top = _panelOffset(item.index);
      if (top == null) continue;
      if (top <= offset + 0.5) active = item.index;
    }
    active ??= widget.items.isEmpty ? null : widget.items.first.index;
    if (active != null) _setActive(active);

    final activeTop = active == null ? null : _panelOffset(active);
    final pinned =
        activeTop != null && offset > activeTop + 0.5 && widget.sticky;
    if (pinned != _pinned) setState(() => _pinned = pinned);
  }

  void _setActive(String index) {
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
    scrollTo(widget.items[index].index);
  }

  int? _indexFromGlobalY(double globalY) {
    int? nearest;
    var minDistance = double.infinity;
    for (var i = 0; i < widget.items.length && i < _rowKeys.length; i++) {
      final box =
          _rowKeys[i].currentContext?.findRenderObject() as RenderBox?;
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
    final index = _activeIndex;
    if (index == null) return null;
    final i = widget.items.indexWhere((item) => item.index == index);
    if (i < 0 || i >= _rowKeys.length) return null;
    final rowBox = _rowKeys[i].currentContext?.findRenderObject() as RenderBox?;
    final rootBox =
        _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rowBox == null || rootBox == null || !rowBox.hasSize) return null;
    final rowTop = rowBox.localToGlobal(Offset.zero).dy;
    final rootTop = rootBox.localToGlobal(Offset.zero).dy;
    return rowTop - rootTop + rowBox.size.height / 2;
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
                  for (final item in items)
                    Column(
                      key: _panelKeyFor(item.index),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, item.headerTitle),
                        if (item.child != null) item.child!,
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

  Widget _buildHeader(AntThemeData theme, String title) {
    return Container(
      height: _headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      color: Color.alphaBlend(theme.colorFillContent, theme.colorBgContainer),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          height: 1,
          color: theme.colorTextTertiary,
        ),
      ),
    );
  }

  Widget _buildStickyHeader(AntThemeData theme) {
    final item = _itemByIndex(_activeIndex);
    if (item == null) return const SizedBox.shrink();
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: _buildHeader(theme, item.headerTitle),
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

  Widget _buildSidebarRow(AntThemeData theme, AntIndexBarItem item, int i) {
    final active = item.index == _activeIndex;
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
          child: item.briefWidget ??
              Text(
                item.briefText,
                style: TextStyle(
                  fontSize: 12,
                  height: 1,
                  color: active
                      ? theme.colorTextLightSolid
                      : theme.colorTextTertiary,
                ),
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
          child: item.briefWidget ??
              Text(
                item.briefText,
                style: TextStyle(
                  fontSize: 25,
                  height: 1,
                  color: theme.colorTextLightSolid,
                ),
              ),
        ),
      ),
    );
  }
}
