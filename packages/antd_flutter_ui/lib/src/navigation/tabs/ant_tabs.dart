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
/// 每项为任意用户模型 `T`，通过 [keyOf] / [labelBuilder] / [childBuilder] /
/// [iconBuilder] / [disabledOf] / [closableOf] 取数与渲染。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_tabs_types.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntTabs
// ============================================================

/// 选项卡 — 对内容进行分区切换的导航组件。
///
/// 对齐 antd React Tabs 组件，支持线条/卡片/可编辑卡片三种类型、
/// 四个方向位置、三种尺寸、居中、动画与增删回调。
///
/// ```dart
/// AntTabs<User>(
///   items: users,
///   keyOf: (user) => user.id,
///   labelBuilder: (context, user, index) => Text(user.name),
///   childBuilder: (context, user, index) => Text(user.email),
/// )
/// ```
class AntTabs<T> extends StatefulWidget {
  const AntTabs({
    super.key,
    this.activeKey,
    this.defaultActiveKey,
    this.items = const [],
    this.keyOf,
    this.labelBuilder,
    this.childBuilder,
    this.iconBuilder,
    this.disabledOf,
    this.closableOf,
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
  final Object? activeKey;

  /// 非受控默认激活 key。
  final Object? defaultActiveKey;

  /// 选项卡项列表。
  final List<T> items;

  /// 提取唯一标识，默认使用下标。
  final Object Function(T item)? keyOf;

  /// 标题构建器。未提供时回退为 `Text('$item')`。
  final AntTabsLabelBuilder<T>? labelBuilder;

  /// 内容构建器。
  final AntTabsChildBuilder<T>? childBuilder;

  /// 图标构建器。
  final AntTabsIconBuilder<T>? iconBuilder;

  /// 是否禁用某项。
  final bool Function(T item)? disabledOf;

  /// 是否可关闭某项。null 时由 [AntTabsType] 决定。
  final bool? Function(T item)? closableOf;

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
  final ValueChanged<T>? onChange;

  /// 新增/删除回调（editableCard）。[item] 为 null 表示新增。
  final void Function(T? item, AntTabsEditAction action)? onEdit;

  @override
  State<AntTabs<T>> createState() => _AntTabsState<T>();
}

class _AntTabsState<T> extends State<AntTabs<T>> {
  Object? _internalActiveKey;

  /// 标签栏内容（Stack 的非定位子节点）坐标基准。
  final GlobalKey _tabBarContentKey = GlobalKey();

  /// 每个标签项的测量 key（用于计算指示条位置/宽度）。
  final List<GlobalKey> _tabKeys = <GlobalKey>[];

  /// 每个标签项标题内容的测量 key（指示条对齐标题，而非整格）。
  final List<GlobalKey> _tabLabelKeys = <GlobalKey>[];

  /// 当前指示条几何信息；null 表示尚未测量完成。
  Rect? _indicatorRect;

  /// outlined 分段控件的内容坐标基准与各段矩形（用于绘制外框/分隔线/选中段描边）。
  final GlobalKey _outlinedContentKey = GlobalKey();
  List<Rect> _outlinedSegments = const <Rect>[];
  bool _outlinedMeasureScheduled = false;

  bool _measureScheduled = false;

  @override
  void initState() {
    super.initState();
    _internalActiveKey =
        widget.defaultActiveKey ?? (widget.items.isNotEmpty ? _keyAt(0) : null);
  }

  Object? get _currentKey => widget.activeKey ?? _internalActiveKey;

  Object _keyAt(int index) => widget.keyOf?.call(widget.items[index]) ?? index;

  void _handleTabClick(T item) {
    if (_isDisabled(item)) return;
    if (widget.activeKey == null) {
      setState(() => _internalActiveKey = _key(item));
    }
    widget.onChange?.call(item);
  }

  Object _key(T item) {
    final index = widget.items.indexOf(item);
    return widget.keyOf?.call(item) ?? index;
  }

  bool _isDisabled(T item) => widget.disabledOf?.call(item) ?? false;

  void _handleRemove(T item) {
    widget.onEdit?.call(item, AntTabsEditAction.remove);
  }

  void _handleAdd() {
    widget.onEdit?.call(null, AntTabsEditAction.add);
  }

  bool _isClosable(T item) {
    return widget.closableOf?.call(item) ??
        widget.type == AntTabsType.editableCard;
  }

  /// 双端样式分别对齐：桌面 antd v6、移动 antd-mobile v5。
  bool get _isMobileStyle => AntPlatform.isMobile;

  double get _tabHeight {
    if (_isMobileStyle) {
      return switch (widget.size) {
        AntTabsSize.large => 48,
        AntTabsSize.normal => 44,
        AntTabsSize.small => 32,
      };
    }
    return switch (widget.size) {
      AntTabsSize.large => 48,
      AntTabsSize.normal => 40,
      AntTabsSize.small => 32,
    };
  }

  double get _fontSize {
    if (_isMobileStyle) {
      // antd-mobile --title-font-size: 17px
      return switch (widget.size) {
        AntTabsSize.large => 18,
        AntTabsSize.normal => 17,
        AntTabsSize.small => 15,
      };
    }
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

  /// 标签横向留白：antd-mobile tab-wrapper padding 0 12px；
  /// antd 桌面相邻标签间距 32px（两侧各 16）。
  double get _horizontalTabPadding => _isMobileStyle ? 12 : 16;

  /// 保证测量 key 数量与标签项一致。
  void _syncTabKeys() {
    while (_tabKeys.length < widget.items.length) {
      _tabKeys.add(GlobalKey());
      _tabLabelKeys.add(GlobalKey());
    }
    while (_tabKeys.length > widget.items.length) {
      _tabKeys.removeLast();
      _tabLabelKeys.removeLast();
    }
  }

  /// 在布局完成后测量激活标签的位置，驱动指示条滑动。
  void _scheduleIndicatorMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (!mounted) return;
      _updateIndicator();
    });
  }

  void _updateIndicator() {
    if (widget.type != AntTabsType.line) return;

    final contentBox =
        _tabBarContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (contentBox == null || !contentBox.hasSize) return;

    final index = widget.items.indexWhere(
      (item) =>
          (widget.keyOf?.call(item) ?? widget.items.indexOf(item)) ==
          _currentKey,
    );
    if (index < 0 || index >= _tabKeys.length) {
      if (_indicatorRect != null) {
        setState(() => _indicatorRect = null);
      }
      return;
    }

    final tabBox =
        _tabKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (tabBox == null || !tabBox.hasSize) return;

    final tabOrigin = tabBox.localToGlobal(Offset.zero, ancestor: contentBox);
    final labelBox =
        _tabLabelKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final labelOrigin = labelBox != null && labelBox.hasSize
        ? labelBox.localToGlobal(Offset.zero, ancestor: contentBox)
        : null;

    final Rect rect;
    if (_isHorizontal) {
      final width = labelBox != null && labelBox.hasSize
          ? labelBox.size.width
          : tabBox.size.width - _horizontalTabPadding * 2;
      final left = labelOrigin?.dx ?? (tabOrigin.dx + _horizontalTabPadding);
      rect = Rect.fromLTWH(left, 0, width, _indicatorThickness);
    } else {
      final height = labelBox != null && labelBox.hasSize
          ? labelBox.size.height
          : tabBox.size.height - 8;
      final top = labelOrigin?.dy ?? (tabOrigin.dy + 4);
      rect = Rect.fromLTWH(0, top, _indicatorThickness, height);
    }

    if (_indicatorRect == rect) return;
    setState(() => _indicatorRect = rect);
  }

  /// 在布局完成后测量 outlined 各段矩形，驱动边框绘制层。
  void _scheduleOutlinedMeasure() {
    if (_outlinedMeasureScheduled) return;
    _outlinedMeasureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _outlinedMeasureScheduled = false;
      if (!mounted) return;
      _updateOutlinedSegments();
    });
  }

  void _updateOutlinedSegments() {
    if (!widget.items.isNotEmpty || widget.type != AntTabsType.outlined) return;
    final contentBox =
        _outlinedContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (contentBox == null || !contentBox.hasSize) return;

    final rects = <Rect>[];
    for (final key in _tabKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final origin = box.localToGlobal(Offset.zero, ancestor: contentBox);
      rects.add(origin & box.size);
    }
    if (rects.length != _outlinedSegments.length) {
      setState(() => _outlinedSegments = rects);
      return;
    }
    for (var i = 0; i < rects.length; i++) {
      if (rects[i] != _outlinedSegments[i]) {
        setState(() => _outlinedSegments = rects);
        return;
      }
    }
  }

  /// line 类型的滑动指示条（唯一一条，随激活项平移）。
  Widget _buildLineIndicator(AntThemeData theme) {
    final rect = _indicatorRect;
    final duration =
        widget.animated ? const Duration(milliseconds: 200) : Duration.zero;
    final color = theme.colorPrimary;

    if (_isHorizontal) {
      return AnimatedPositioned(
        duration: duration,
        curve: Curves.easeInOut,
        left: rect?.left ?? 0,
        width: rect?.width ?? 0,
        height: _indicatorThickness,
        bottom: widget.tabPosition == AntTabPosition.top ? 0 : null,
        top: widget.tabPosition == AntTabPosition.bottom ? 0 : null,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
            color: color,
            borderRadius: _isMobileStyle
                ? BorderRadius.circular(_indicatorThickness)
                : null,
          ),
        ),
      );
    }

    return AnimatedPositioned(
      duration: duration,
      curve: Curves.easeInOut,
      top: rect?.top ?? 0,
      height: rect?.height ?? 0,
      width: _indicatorThickness,
      right: widget.tabPosition == AntTabPosition.left ? 0 : null,
      left: widget.tabPosition == AntTabPosition.right ? 0 : null,
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          color: color,
          borderRadius: _isMobileStyle
              ? BorderRadius.circular(_indicatorThickness)
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    _syncTabKeys();
    final tabBar = _buildTabBar(context);
    final content = _buildContent(context);

    Widget result;
    if (_isHorizontal) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.tabPosition == AntTabPosition.top
            ? [tabBar, content]
            : [content, tabBar],
      );
    } else {
      result = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

    final isCard = widget.type == AntTabsType.card ||
        widget.type == AntTabsType.editableCard;
    // antd cardGutter = marginXXS / 2 = 2，卡片之间保留 2px 缝隙，避免边框重叠。
    final gutter = widget.tabBarGutter ?? (isCard ? 2.0 : null);
    final isOutlined = widget.type == AntTabsType.outlined;

    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      tabs.add(_buildTabItem(context, theme, item, i));
      if (i < widget.items.length - 1 && gutter != null) {
        if (_isHorizontal) {
          tabs.add(SizedBox(width: gutter));
        } else {
          tabs.add(SizedBox(height: gutter));
        }
      }
    }

    // editableCard 新增按钮
    if (widget.type == AntTabsType.editableCard && widget.onEdit != null) {
      tabs.add(_buildAddButton(theme));
    }

    Widget contentBar;
    if (_isHorizontal) {
      contentBar = Row(
        mainAxisAlignment: widget.centered
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: tabs,
      );
    } else {
      contentBar = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tabs,
      );
    }

    // line 类型：只保留一条指示条，作为 Stack 的定位子节点随激活项滑动。
    if (widget.type == AntTabsType.line) {
      _scheduleIndicatorMeasure();
      contentBar = Stack(
        clipBehavior: Clip.none,
        children: [
          KeyedSubtree(key: _tabBarContentKey, child: contentBar),
          _buildLineIndicator(theme),
        ],
      );
    }

    Widget bar;
    if (_isHorizontal) {
      bar = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: contentBar,
      );
    } else {
      bar = SizedBox(
        width: 140,
        child: SingleChildScrollView(child: contentBar),
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

    if (isOutlined) {
      _scheduleOutlinedMeasure();
      var activeIndex = -1;
      for (var i = 0; i < widget.items.length; i++) {
        if (_keyAt(i) == _currentKey) {
          activeIndex = i;
          break;
        }
      }
      // 外框只包住标签本身（与 antd Radio.Button 分组一致），不撑满整行。
      bar = Align(
        alignment: AlignmentDirectional.centerStart,
        child: IntrinsicWidth(
          child: Stack(
            children: [
              KeyedSubtree(key: _outlinedContentKey, child: bar),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    key: const ValueKey('ant-tabs-outlined-border'),
                    painter: _OutlinedTabsPainter(
                      segments: _outlinedSegments,
                      activeIndex: activeIndex,
                      borderColor: theme.colorBorder,
                      activeColor: theme.colorPrimary,
                      radius: 6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return bar;
  }

  Widget _buildTabItem(
    BuildContext context,
    AntThemeData theme,
    T item,
    int index,
  ) {
    final isActive = _keyAt(index) == _currentKey;
    final disabled = _isDisabled(item);
    final isCard = widget.type == AntTabsType.card ||
        widget.type == AntTabsType.editableCard;
    final isOutlined = widget.type == AntTabsType.outlined;

    // 标签内容
    final iconWidget = widget.iconBuilder?.call(context, item);
    Widget labelWidget = widget.labelBuilder?.call(context, item, index) ??
        Text(
          '$item',
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w400,
            color: disabled
                ? theme.colorTextDisabled
                : isActive
                    ? theme.colorPrimary
                    : theme.colorText,
          ),
        );

    final labelWidgets = <Widget>[];
    if (iconWidget != null) {
      labelWidgets.add(iconWidget);
      labelWidgets.add(SizedBox(width: _isHorizontal ? 8 : 0));
    }
    labelWidgets.add(labelWidget);

    // 关闭按钮
    if (_isClosable(item) && widget.onEdit != null && !disabled) {
      labelWidgets.add(const SizedBox(width: 6));
      labelWidgets.add(
        GestureDetector(
          onTap: () => _handleRemove(item),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Icon(
              AntIcons.closeOutlined,
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
        key: _tabLabelKeys[index],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: labelWidgets,
      );
    } else {
      tabContent = Row(
        key: _tabLabelKeys[index],
        children: [
          if (iconWidget != null) ...[
            iconWidget,
            const SizedBox(width: 8),
          ],
          Expanded(child: labelWidget),
        ],
      );
    }

    // 外边框分段样式：段与段之间以 1px 分隔线切分，选中段覆盖主色描边。
    // outlined 分段控件的边框统一由「外框 + 分隔线 + 选中段描边」绘制层负责，
    // 各段自身不再画边框，避免相邻段边线重叠、圆角与整组圆角不一致。
    final outlinedDecoration = isOutlined && _isHorizontal && isActive
        ? BoxDecoration(color: theme.colorBgContainer)
        : null;

    // 让 labelBuilder 返回的内容继承激活/禁用态的文字颜色与字号。
    tabContent = DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w400,
        color: disabled
            ? theme.colorTextDisabled
            : isActive
                ? theme.colorPrimary
                : theme.colorText,
      ),
      child: tabContent,
    );

    // 卡片样式：每项一枚带边框的卡片，活动项底色与内容区连通。
    BoxDecoration? cardDecoration;
    if (isCard) {
      final borderSide = BorderSide(color: theme.colorBorderSecondary);
      const radiusLg = 8.0;
      final radius = _isHorizontal
          ? BorderRadius.vertical(
              top: widget.tabPosition == AntTabPosition.top
                  ? const Radius.circular(radiusLg)
                  : Radius.zero,
              bottom: widget.tabPosition == AntTabPosition.bottom
                  ? const Radius.circular(radiusLg)
                  : Radius.zero,
            )
          : BorderRadius.horizontal(
              left: widget.tabPosition == AntTabPosition.left
                  ? const Radius.circular(radiusLg)
                  : Radius.zero,
              right: widget.tabPosition == AntTabPosition.right
                  ? const Radius.circular(radiusLg)
                  : Radius.zero,
            );
      cardDecoration = BoxDecoration(
        color: isActive ? theme.colorBgContainer : theme.colorFillAlter,
        borderRadius: radius,
        border: Border(
          top: isActive && widget.tabPosition == AntTabPosition.bottom
              ? BorderSide.none
              : borderSide,
          bottom: isActive && widget.tabPosition == AntTabPosition.top
              ? BorderSide.none
              : borderSide,
          left: isActive && widget.tabPosition == AntTabPosition.right
              ? BorderSide.none
              : borderSide,
          right: isActive && widget.tabPosition == AntTabPosition.left
              ? BorderSide.none
              : borderSide,
        ),
      );
    }

    // 组装标签项
    Widget tab;
    if (_isHorizontal) {
      tab = GestureDetector(
        onTap: () => _handleTabClick(item),
        child: MouseRegion(
          cursor: disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: Container(
            key: _tabKeys[index],
            height: isOutlined ? 32 : _tabHeight,
            padding: EdgeInsets.symmetric(
              horizontal: isOutlined ? 16 : _horizontalTabPadding,
            ),
            decoration: outlinedDecoration ?? cardDecoration,
            alignment: Alignment.center,
            child: tabContent,
          ),
        ),
      );
    } else {
      // 垂直标签
      tab = GestureDetector(
        onTap: () => _handleTabClick(item),
        child: MouseRegion(
          cursor: disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: Container(
            key: _tabKeys[index],
            height: _tabHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: cardDecoration,
            alignment: Alignment.centerLeft,
            child: tabContent,
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
                  AntIcons.plusOutlined,
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

    final activeIndex = widget.items.indexWhere(
      (item) =>
          (widget.keyOf?.call(item) ?? widget.items.indexOf(item)) ==
          _currentKey,
    );
    final activeItem = activeIndex < 0 ? null : widget.items[activeIndex];

    Widget content;
    final child = activeItem == null
        ? null
        : widget.childBuilder?.call(context, activeItem, activeIndex);
    if (child != null) {
      content = child;
    } else {
      content = const SizedBox.shrink();
    }

    if (widget.animated) {
      content = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        // 默认 Stack(center) 会把内容缩成文字宽度并居中；改为左上对齐，
        // 并让子节点撑满可用宽度，内容才会与标签栏左对齐。
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topLeft,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentKey),
          child: SizedBox(width: double.infinity, child: content),
        ),
      );
    } else {
      content = SizedBox(width: double.infinity, child: content);
    }

    final contentPadding = EdgeInsets.all(_isMobileStyle ? 12 : 16);

    if (isCard && !_isHorizontal) {
      // 垂直卡片：内容区与卡片之间保留一条分隔线（antd body-holder border）。
      content = Container(
        padding: contentPadding,
        decoration: BoxDecoration(
          border: Border(
            left: widget.tabPosition == AntTabPosition.left
                ? BorderSide(color: theme.colorBorderSecondary)
                : BorderSide.none,
            right: widget.tabPosition == AntTabPosition.right
                ? BorderSide(color: theme.colorBorderSecondary)
                : BorderSide.none,
          ),
        ),
        child: content,
      );
    } else {
      content = Padding(
        padding: contentPadding,
        child: content,
      );
    }

    if (_isHorizontal) {
      return Expanded(child: content);
    }
    return Expanded(child: content);
  }
}

/// outlined 分段控件边框绘制层：整组圆角外框 + 内部分隔线 + 选中段描边。
/// 选中段与整组共用外框圆角，内侧保持直角，避免出现独立圆角胶囊。
class _OutlinedTabsPainter extends CustomPainter {
  _OutlinedTabsPainter({
    required this.segments,
    required this.activeIndex,
    required this.borderColor,
    required this.activeColor,
    required this.radius,
  });

  final List<Rect> segments;
  final int activeIndex;
  final Color borderColor;
  final Color activeColor;
  final double radius;

  static const double _stroke = 1;

  Paint get _borderPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _stroke
    ..color = borderColor;

  Paint get _activePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _stroke
    ..color = activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final frame = Rect.fromLTWH(
      _stroke / 2,
      _stroke / 2,
      size.width - _stroke,
      size.height - _stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(frame, Radius.circular(radius)),
      _borderPaint,
    );

    for (var i = 0; i < segments.length - 1; i++) {
      if (i == activeIndex || i + 1 == activeIndex) continue;
      final x = segments[i].right;
      canvas.drawLine(
        Offset(x, _stroke),
        Offset(x, size.height - _stroke),
        _borderPaint,
      );
    }

    if (activeIndex < 0 || activeIndex >= segments.length) return;
    final seg = segments[activeIndex].deflate(_stroke / 2);
    final corner = Radius.circular(radius);
    final isFirst = activeIndex == 0;
    final isLast = activeIndex == segments.length - 1;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        seg,
        topLeft: isFirst ? corner : Radius.zero,
        bottomLeft: isFirst ? corner : Radius.zero,
        topRight: isLast ? corner : Radius.zero,
        bottomRight: isLast ? corner : Radius.zero,
      ),
      _activePaint,
    );
  }

  @override
  bool shouldRepaint(_OutlinedTabsPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.radius != radius ||
        oldDelegate.segments != segments;
  }
}
