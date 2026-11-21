/// AntTabs — antd React Tabs 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [items] — 选项卡项列表
/// - [activeKey] / [defaultActiveKey] — 受控/非受控当前激活 key
/// - [type] — line / card / editableCard
/// - [size] — large / normal / small
/// - [tabPosition] — top / bottom / left / right
/// - [centered] — 标签居中
/// - [animated] — 切换动画
/// - [onChange] — 切换回调
/// - [onEdit] — 新增/删除回调（editableCard）
///
/// 每项（AntTabsItem）支持 key / label / labelWidget / child / icon / disabled / closable。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_tabs_types.dart';

// ============================================================
// AntTabs
// ============================================================

/// 选项卡 — 对内容进行分区切换的导航组件。
///
/// 对齐 antd React Tabs 组件，支持线条/卡片/可编辑卡片三种类型、
/// 四个方向位置、三种尺寸、居中、动画与增删回调。
///
/// ```dart
/// AntTabs(
///   items: [
///     AntTabsItem(key: '1', label: 'Tab 1', child: Text('Content 1')),
///     AntTabsItem(key: '2', label: 'Tab 2', child: Text('Content 2')),
///   ],
/// )
/// ```
class AntTabs extends StatefulWidget {
  const AntTabs({
    super.key,
    this.activeKey,
    this.defaultActiveKey,
    this.items = const [],
    this.type = AntTabsType.line,
    this.size = AntTabsSize.normal,
    this.tabPosition = AntTabPosition.top,
    this.centered = false,
    this.animated = true,
    this.tabBarGutter,
    this.addIcon,
    this.onChange,
    this.onEdit,
  });

  /// 受控当前激活 key。
  final String? activeKey;

  /// 非受控默认激活 key。
  final String? defaultActiveKey;

  /// 选项卡项列表。
  final List<AntTabsItem> items;

  /// 选项卡类型。
  final AntTabsType type;

  /// 尺寸。
  final AntTabsSize size;

  /// 选项卡位置。
  final AntTabPosition tabPosition;

  /// 标签居中。
  final bool centered;

  /// 切换动画。
  final bool animated;

  /// 标签间隙。
  final double? tabBarGutter;

  /// 自定义新增按钮图标（editableCard）。
  final Widget? addIcon;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  /// 新增/删除回调（editableCard）。
  final void Function(String key, AntTabsEditAction action)? onEdit;

  @override
  State<AntTabs> createState() => _AntTabsState();
}

class _AntTabsState extends State<AntTabs> {
  late String _internalActiveKey;

  @override
  void initState() {
    super.initState();
    _internalActiveKey = widget.defaultActiveKey ??
        (widget.items.isNotEmpty ? widget.items.first.key : '');
  }

  String get _currentKey => widget.activeKey ?? _internalActiveKey;

  void _handleTabClick(AntTabsItem item) {
    if (item.disabled) return;
    if (widget.activeKey == null) {
      setState(() => _internalActiveKey = item.key);
    }
    widget.onChange?.call(item.key);
  }

  void _handleRemove(AntTabsItem item) {
    widget.onEdit?.call(item.key, AntTabsEditAction.remove);
  }

  void _handleAdd() {
    widget.onEdit?.call('', AntTabsEditAction.add);
  }

  bool _isClosable(AntTabsItem item) {
    if (item.closable != null) return item.closable!;
    return widget.type == AntTabsType.editableCard;
  }

  double get _tabHeight {
    return switch (widget.size) {
      AntTabsSize.large => 48,
      AntTabsSize.normal => 40,
      AntTabsSize.small => 32,
    };
  }

  double get _fontSize {
    return switch (widget.size) {
      AntTabsSize.large => 16,
      AntTabsSize.normal => 14,
      AntTabsSize.small => 14,
    };
  }

  double get _indicatorThickness => 2;

  bool get _isHorizontal =>
      widget.tabPosition == AntTabPosition.top ||
      widget.tabPosition == AntTabPosition.bottom;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final tabBar = _buildTabBar(context);
    final content = _buildContent(context);

    Widget result;
    if (_isHorizontal) {
      result = Column(
        children: widget.tabPosition == AntTabPosition.top
            ? [tabBar, content]
            : [content, tabBar],
      );
    } else {
      result = Row(
        children: widget.tabPosition == AntTabPosition.left
            ? [tabBar, content]
            : [content, tabBar],
      );
    }

    // 无界主轴自适应：内部使用 Expanded 撑满主轴，在
    // SingleChildScrollView / 未约束 Column 等无界容器中会触发
    // "given unbounded height/width" 崩溃。检测到无界约束时改用
    // Intrinsic 尺寸自适应（对齐 AntSegmented 无界处理先例）。
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget adapted = result;
        if (!constraints.hasBoundedHeight) {
          adapted = IntrinsicHeight(child: adapted);
        }
        if (!constraints.hasBoundedWidth) {
          adapted = IntrinsicWidth(child: adapted);
        }
        return adapted;
      },
    );
  }

  // ------------------------------------------------------------
  // 标签栏
  // ------------------------------------------------------------

  Widget _buildTabBar(BuildContext context) {
    final theme = AntTheme.of(context);
    final tabs = <Widget>[];

    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      tabs.add(_buildTabItem(context, theme, item));
      if (i < widget.items.length - 1 && widget.tabBarGutter != null) {
        if (_isHorizontal) {
          tabs.add(SizedBox(width: widget.tabBarGutter));
        } else {
          tabs.add(SizedBox(height: widget.tabBarGutter));
        }
      }
    }

    // editableCard 新增按钮
    if (widget.type == AntTabsType.editableCard && widget.onEdit != null) {
      tabs.add(_buildAddButton(theme));
    }

    Widget bar;
    if (_isHorizontal) {
      bar = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              widget.centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: tabs,
        ),
      );
    } else {
      bar = SizedBox(
        width: 140,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: tabs,
          ),
        ),
      );
    }

    // line 类型的分割线
    if (widget.type == AntTabsType.line) {
      final dividerColor = theme.colorSplit;
      if (_isHorizontal) {
        bar = Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: widget.tabPosition == AntTabPosition.top
                  ? BorderSide(color: dividerColor)
                  : BorderSide.none,
              top: widget.tabPosition == AntTabPosition.bottom
                  ? BorderSide(color: dividerColor)
                  : BorderSide.none,
            ),
          ),
          child: bar,
        );
      } else {
        bar = Container(
          decoration: BoxDecoration(
            border: Border(
              right: widget.tabPosition == AntTabPosition.left
                  ? BorderSide(color: dividerColor)
                  : BorderSide.none,
              left: widget.tabPosition == AntTabPosition.right
                  ? BorderSide(color: dividerColor)
                  : BorderSide.none,
            ),
          ),
          child: bar,
        );
      }
    }

    return bar;
  }

  Widget _buildTabItem(
    BuildContext context,
    AntThemeData theme,
    AntTabsItem item,
  ) {
    final isActive = item.key == _currentKey;
    final isCard = widget.type == AntTabsType.card ||
        widget.type == AntTabsType.editableCard;

    // 标签内容
    final labelWidgets = <Widget>[];
    if (item.icon != null) {
      labelWidgets.add(item.icon!);
      labelWidgets.add(SizedBox(width: _isHorizontal ? 8 : 0));
    }
    labelWidgets.add(
      item.labelWidget ??
          Text(
            item.label ?? item.key,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              color: item.disabled
                  ? theme.colorTextDisabled
                  : isActive
                      ? (isCard ? theme.colorPrimary : theme.colorPrimary)
                      : theme.colorText,
            ),
          ),
    );

    // 关闭按钮
    if (_isClosable(item) && widget.onEdit != null && !item.disabled) {
      labelWidgets.add(const SizedBox(width: 6));
      labelWidgets.add(
        GestureDetector(
          onTap: () => _handleRemove(item),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Icon(
              Icons.close,
              size: _fontSize * 0.8,
              color: theme.colorTextTertiary,
            ),
          ),
        ),
      );
    }

    Widget tabContent;
    if (_isHorizontal) {
      tabContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: labelWidgets,
      );
    } else {
      tabContent = Row(
        children: [
          if (item.icon != null) ...[
            item.icon!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: item.labelWidget ??
                Text(
                  item.label ?? item.key,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: item.disabled
                        ? theme.colorTextDisabled
                        : isActive
                            ? theme.colorPrimary
                            : theme.colorText,
                  ),
                ),
          ),
        ],
      );
    }

    // 卡片样式
    BoxDecoration? cardDecoration;
    if (isCard) {
      cardDecoration = BoxDecoration(
        color: isActive ? theme.colorBgContainer : theme.colorBgLayout,
        border: Border.all(color: theme.colorSplit),
        borderRadius: _isHorizontal
            ? BorderRadius.vertical(
                top: widget.tabPosition == AntTabPosition.top
                    ? const Radius.circular(6)
                    : Radius.zero,
                bottom: widget.tabPosition == AntTabPosition.bottom
                    ? const Radius.circular(6)
                    : Radius.zero,
              )
            : BorderRadius.horizontal(
                left: widget.tabPosition == AntTabPosition.left
                    ? const Radius.circular(6)
                    : Radius.zero,
                right: widget.tabPosition == AntTabPosition.right
                    ? const Radius.circular(6)
                    : Radius.zero,
              ),
      );
    }

    // line 类型的指示条
    Widget? indicator;
    if (widget.type == AntTabsType.line && isActive) {
      final indicatorColor = theme.colorPrimary;
      if (widget.tabPosition == AntTabPosition.top) {
        indicator = AnimatedContainer(
          duration: widget.animated
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          height: _indicatorThickness,
          color: indicatorColor,
        );
      } else if (widget.tabPosition == AntTabPosition.bottom) {
        indicator = AnimatedContainer(
          duration: widget.animated
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          height: _indicatorThickness,
          color: indicatorColor,
        );
      } else if (widget.tabPosition == AntTabPosition.left) {
        indicator = AnimatedContainer(
          duration: widget.animated
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          width: _indicatorThickness,
          color: indicatorColor,
        );
      } else {
        indicator = AnimatedContainer(
          duration: widget.animated
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          width: _indicatorThickness,
          color: indicatorColor,
        );
      }
    }

    // 组装标签项
    Widget tab;
    if (_isHorizontal) {
      tab = GestureDetector(
        onTap: () => _handleTabClick(item),
        child: MouseRegion(
          cursor: item.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: Container(
            height: _tabHeight,
            padding: EdgeInsets.symmetric(horizontal: _tabHeight * 0.6),
            decoration: cardDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabContent,
                if (widget.type == AntTabsType.line &&
                    widget.tabPosition == AntTabPosition.top) ...[
                  const SizedBox(height: 2),
                  if (indicator != null)
                    Expanded(child: indicator)
                  else
                    SizedBox(height: _indicatorThickness),
                ],
              ],
            ),
          ),
        ),
      );
    } else {
      // 垂直标签
      tab = GestureDetector(
        onTap: () => _handleTabClick(item),
        child: MouseRegion(
          cursor: item.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: Container(
            height: _tabHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: cardDecoration,
            child: Row(
              children: [
                if (widget.tabPosition == AntTabPosition.left &&
                    widget.type == AntTabsType.line) ...[
                  if (indicator != null)
                    SizedBox(
                      width: _indicatorThickness,
                      height: _tabHeight,
                      child: indicator,
                    )
                  else
                    SizedBox(width: _indicatorThickness),
                  const SizedBox(width: 8),
                ],
                Expanded(child: tabContent),
                if (widget.tabPosition == AntTabPosition.right &&
                    widget.type == AntTabsType.line) ...[
                  const SizedBox(width: 8),
                  if (indicator != null)
                    SizedBox(
                      width: _indicatorThickness,
                      height: _tabHeight,
                      child: indicator,
                    )
                  else
                    SizedBox(width: _indicatorThickness),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return tab;
  }

  Widget _buildAddButton(AntThemeData theme) {
    return GestureDetector(
      onTap: _handleAdd,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: _isHorizontal ? _tabHeight : null,
          width: _isHorizontal ? null : 40,
          padding: _isHorizontal
              ? const EdgeInsets.symmetric(horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: widget.addIcon ??
                Icon(
                  Icons.add,
                  size: _fontSize + 2,
                  color: theme.colorTextTertiary,
                ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 内容区域
  // ------------------------------------------------------------

  Widget _buildContent(BuildContext context) {
    final theme = AntTheme.of(context);
    final isCard = widget.type == AntTabsType.card ||
        widget.type == AntTabsType.editableCard;

    final activeItem = widget.items
        .where((e) => e.key == _currentKey)
        .firstOrNull;

    Widget content;
    if (activeItem?.child != null) {
      content = activeItem!.child!;
    } else {
      content = const SizedBox.shrink();
    }

    if (widget.animated) {
      content = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_currentKey),
          child: content,
        ),
      );
    }

    if (isCard) {
      content = Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorSplit),
          borderRadius: BorderRadius.vertical(
            top: widget.tabPosition == AntTabPosition.bottom
                ? const Radius.circular(6)
                : Radius.zero,
            bottom: widget.tabPosition == AntTabPosition.top
                ? const Radius.circular(6)
                : Radius.zero,
          ),
        ),
        child: content,
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      );
    }

    if (_isHorizontal) {
      return Expanded(child: content);
    }
    return Expanded(child: content);
  }
}