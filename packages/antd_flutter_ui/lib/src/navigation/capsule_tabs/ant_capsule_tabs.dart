/// AntCapsuleTabs — antd-mobile CapsuleTabs 胶囊选项卡的 Flutter 实现
///
/// API 与 antd-mobile CapsuleTabs 对齐：
/// - [items] — 选项卡项列表
/// - [activeKey] — 受控激活项
/// - [defaultActiveKey] — 非受控默认激活项
/// - [onChange] — 切换回调
///
/// 视觉与交互严格对齐 antd-mobile v5 `capsule-tabs.less`：
/// - header 上下 12 / 左右 6 内边距，底部 1px 分隔线
/// - 每个 tab 均分宽度（flex:auto），可横向滚动并自动滚动到激活项
/// - 胶囊：左右 20 / 上下 8 内边距、圆角 20、底色 fill-content（#f5f5f5）
/// - 激活：主色背景 + 白色文字；禁用：透明度 0.5
/// - 内容区 padding 12
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_capsule_tabs_types.dart';

// ============================================================
// AntCapsuleTabs
// ============================================================

/// 胶囊选项卡 — 圆角胶囊形选项卡组。
///
/// 对齐 antd-mobile CapsuleTabs：标签横向排列、均分宽度，
/// 激活项主色胶囊 + 白字，超出宽度可横向滚动。
///
/// ```dart
/// AntCapsuleTabs<Tag>(
///   items: tags,
///   keyOf: (tag) => tag.id,
///   titleBuilder: (context, tag, index) => Text(tag.name),
///   childBuilder: (context, tag, index) => Text(tag.description),
/// )
/// ```
class AntCapsuleTabs<T> extends StatefulWidget {
  const AntCapsuleTabs({
    super.key,
    required this.items,
    this.keyOf,
    this.titleBuilder,
    this.childBuilder,
    this.disabledOf,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 选项卡项列表。
  final List<T> items;

  /// 提取唯一标识，默认使用下标。
  final Object Function(T item)? keyOf;

  /// 标题构建器，未提供时回退为 `Text('$item')`。
  final AntCapsuleTabsTitleBuilder<T>? titleBuilder;

  /// 面板内容构建器。
  final AntCapsuleTabsChildBuilder<T>? childBuilder;

  /// 是否禁用某项。
  final bool Function(T item)? disabledOf;

  /// 受控激活项 key。
  final Object? activeKey;

  /// 非受控默认激活项 key。
  final Object? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<T>? onChange;

  @override
  State<AntCapsuleTabs<T>> createState() => _AntCapsuleTabsState<T>();
}

class _AntCapsuleTabsState<T> extends State<AntCapsuleTabs<T>> {
  Object? _internalKey;

  final ScrollController _scrollController = ScrollController();

  /// 每个 tab 的测量 key，用于把激活项滚动到可见区域。
  List<GlobalKey> _tabKeys = const [];

  /// 左右边缘渐隐（对齐 antd-mobile ScrollMask）。
  bool _showLeftMask = false;
  bool _showRightMask = false;

  Object? get _currentKey => widget.activeKey ?? _internalKey;

  Object _keyAt(int index) => widget.keyOf?.call(widget.items[index]) ?? index;

  int get _currentIndex => widget.items.indexWhere(
        (item) =>
            (widget.keyOf?.call(item) ?? widget.items.indexOf(item)) ==
            _currentKey,
      );

  @override
  void initState() {
    super.initState();
    _internalKey =
        widget.defaultActiveKey ?? (widget.items.isEmpty ? null : _keyAt(0));
    _syncTabKeys();
    _scrollController.addListener(_updateMasks);
  }

  @override
  void didUpdateWidget(covariant AntCapsuleTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTabKeys();
    if (oldWidget.activeKey != widget.activeKey ||
        oldWidget.defaultActiveKey != widget.defaultActiveKey) {
      _scrollToActive();
    }
    _scheduleMaskUpdate();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateMasks);
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleMaskUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateMasks();
    });
  }

  void _updateMasks() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final left = position.pixels > 0.5;
    // 对齐 antd-mobile：scrollLeft + offsetWidth < scrollWidth
    final right = position.pixels < position.maxScrollExtent - 0.5;
    if (left == _showLeftMask && right == _showRightMask) return;
    setState(() {
      _showLeftMask = left;
      _showRightMask = right;
    });
  }

  void _syncTabKeys() {
    if (_tabKeys.length == widget.items.length) return;
    _tabKeys = List<GlobalKey>.generate(
      widget.items.length,
      (_) => GlobalKey(),
      growable: false,
    );
  }

  void _handleTap(T item, int index) {
    if ((widget.disabledOf?.call(item) ?? false) ||
        _keyAt(index) == _currentKey) {
      return;
    }
    if (widget.activeKey == null) {
      setState(() => _internalKey = _keyAt(index));
    }
    widget.onChange?.call(item);
    _scrollToActive();
  }

  /// 对齐 antd-mobile useTabListScroll：切换后把激活项滚到可视区。
  void _scrollToActive() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final index = _currentIndex;
      if (index < 0 || index >= _tabKeys.length) return;
      final ctx = _tabKeys[index].currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        alignment: 0.5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final currentKey = _currentKey;
    final activeIndex = _currentIndex;
    final activeItem = activeIndex < 0 ? null : widget.items[activeIndex];
    final activeChild = activeItem == null
        ? null
        : widget.childBuilder?.call(context, activeItem, activeIndex);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header：底部 1px 分隔线
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: t.colorBorderSecondary, width: 1),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                child: _buildTabList(t, currentKey),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 30,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showLeftMask ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            t.colorBgContainer,
                            t.colorBgContainer.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 30,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showRightMask ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            t.colorBgContainer,
                            t.colorBgContainer.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (activeChild != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: activeChild,
          ),
      ],
    );
  }

  /// antd-mobile 中 tab-wrapper 为 flex:auto 且 min-width:auto：
  /// 能放下时均分整行宽度，放不下时保持内容宽度并横向滚动（不截断文字）。
  double _tabWidth(
    BuildContext context,
    T item,
    TextStyle baseStyle,
    double share,
  ) {
    final built =
        widget.titleBuilder?.call(context, item, widget.items.indexOf(item));
    final title =
        built is Text ? (built.data ?? '') : (built == null ? '$item' : null);
    if (title == null) return share;
    final painter = TextPainter(
      text: TextSpan(text: title, style: baseStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final intrinsic = painter.width + 40 + 12; // 胶囊左右 20 + wrapper 左右 6
    painter.dispose();
    return intrinsic > share ? intrinsic : share;
  }

  Widget _buildTabList(AntThemeData t, Object? currentKey) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final count = widget.items.length;
        final share = count == 0 ? 0.0 : maxWidth / count;
        final baseStyle = DefaultTextStyle.of(context)
            .style
            .merge(const TextStyle(fontSize: 15));

        _scheduleMaskUpdate();
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < count; i++)
                SizedBox(
                  key: _tabKeys[i],
                  width: _tabWidth(
                    context,
                    widget.items[i],
                    baseStyle,
                    share,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _CapsuleItem(
                      title: widget.titleBuilder?.call(
                            context,
                            widget.items[i],
                            i,
                          ) ??
                          Text('${widget.items[i]}'),
                      disabled:
                          widget.disabledOf?.call(widget.items[i]) ?? false,
                      active: _keyAt(i) == currentKey,
                      primary: t.colorPrimary,
                      fill: t.colorFillContent,
                      textColor: t.colorText,
                      lightSolid: t.colorTextLightSolid,
                      onTap: () => _handleTap(widget.items[i], i),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// 内部：单个胶囊项
// ============================================================

class _CapsuleItem extends StatelessWidget {
  const _CapsuleItem({
    required this.title,
    required this.disabled,
    required this.active,
    required this.primary,
    required this.fill,
    required this.textColor,
    required this.lightSolid,
    required this.onTap,
  });

  final Widget title;
  final bool disabled;
  final bool active;
  final Color primary;
  final Color fill;
  final Color textColor;
  final Color lightSolid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? lightSolid : textColor;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: active ? primary : fill,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 15, color: color),
            child: title,
          ),
        ),
      ),
    );
  }
}
