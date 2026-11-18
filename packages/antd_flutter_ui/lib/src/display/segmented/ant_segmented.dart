/// AntSegmented — antd React Segmented 的 Flutter 实现
///
/// API 与 antd React Segmented 对齐：
/// - [options] — 选项，支持 String 或 [AntSegmentedItem]（label/icon/value/disabled）
/// - [value] — 受控选中值
/// - [defaultValue] — 非受控初始选中值（缺省为 options 首项）
/// - [onChange] — 选中值变化回调
/// - [block] — 占满整行
/// - [size] — small/middle/large
/// - [disabled] — 全局禁用
/// - [shape] — rounded（默认圆角）/ round（胶囊）
/// - [direction] — horizontal（默认）/ vertical（竖排，对齐 antd `orientation`）
///
/// ```dart
/// AntSegmented(options: ['日', '周', '月'])
/// AntSegmented(
///   options: [AntSegmentedItem(label: '列表', icon: Icon(Icons.list))],
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/display/segmented/ant_segmented_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/display/segmented/ant_segmented_types.dart';
import 'package:material_ui/material_ui.dart';

/// 滑块动画时长。
const Duration _kSlideDuration = Duration(milliseconds: 200);

/// 分段控制器 — 展示多个选项并允许用户选择其中单个选项。
///
/// 对齐 antd React Segmented 组件。
class AntSegmented extends StatefulWidget {
  const AntSegmented({
    super.key,
    required this.options,
    this.value,
    this.defaultValue,
    this.onChange,
    this.block = false,
    this.size = AntSegmentedSize.middle,
    this.disabled = false,
    this.shape = AntSegmentedShape.rounded,
    this.direction = AntSegmentedDirection.horizontal,
  });

  /// 选项列表，支持 String 或 [AntSegmentedItem]。
  final List<Object> options;

  /// 受控选中值。
  final String? value;

  /// 非受控初始选中值（缺省为 options 首项的值）。
  final String? defaultValue;

  /// 选中值变化回调。
  final ValueChanged<String>? onChange;

  /// 是否占满整行。
  final bool block;

  /// 控件尺寸。
  final AntSegmentedSize size;

  /// 是否全局禁用。
  final bool disabled;

  /// 形状。
  final AntSegmentedShape shape;

  /// 排列方向（对齐 antd `orientation`）：horizontal（默认）/ vertical。
  final AntSegmentedDirection direction;

  @override
  State<AntSegmented> createState() => _AntSegmentedState();
}

class _AntSegmentedState extends State<AntSegmented> {
  bool get _isVertical => widget.direction == AntSegmentedDirection.vertical;

  late List<AntSegmentedItem> _items;
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _items = _normalizeItems();
    _selectedValue = _resolveInitialValue();
  }

  @override
  void didUpdateWidget(AntSegmented oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.options, widget.options)) {
      _items = _normalizeItems();
    }
    if (widget.value != null && widget.value != _selectedValue) {
      _selectedValue = widget.value!;
    }
  }

  List<AntSegmentedItem> _normalizeItems() {
    return widget.options.map((opt) {
      if (opt is AntSegmentedItem) return opt;
      if (opt is String) return AntSegmentedItem(label: opt, value: opt);
      throw ArgumentError.value(opt, 'options', '选项必须是 String 或 AntSegmentedItem');
    }).toList();
  }

  String _resolveInitialValue() {
    final explicit = widget.value ?? widget.defaultValue;
    if (explicit != null) return explicit;
    final first = _items.isNotEmpty ? _items.first : null;
    return first?.value ?? first?.label ?? '';
  }

  String _itemValue(AntSegmentedItem item) => item.value ?? item.label ?? '';

  void _handleTap(AntSegmentedItem item) {
    if (widget.disabled || item.disabled) return;
    final value = _itemValue(item);
    if (value == _selectedValue) return;
    if (widget.value == null) {
      setState(() => _selectedValue = value);
    } else {
      _selectedValue = value;
    }
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    Widget track = widget.block ? _buildBlock(theme) : _buildInline(theme);
    // 水平：轨道定高（32.w）；垂直 inline：宽度取最宽项（IntrinsicWidth），
    // 垂直 block：高度 = 项数 × 单项轨道高（紧约束）。
    // 注意不能用 IntrinsicHeight：block 的 Stack 子节点均为 Positioned.fill，
    // 固有高度为 0，会导致轨道高度塌陷、选项被压扁。
    return Container(
      constraints: _isVertical
          ? (widget.block
              ? BoxConstraints.tightFor(
                  height: _items.length * _trackHeight.w,
                )
              : null)
          : BoxConstraints.tightFor(height: _trackHeight.w),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: theme.colorFillQuaternary,
        borderRadius: _trackBorderRadius(theme),
      ),
      child: _isVertical && !widget.block ? IntrinsicWidth(child: track) : track,
    );
  }

  Widget _buildBlock(AntThemeData theme) {
    return Stack(
      children: [
        Positioned.fill(
          child: _Slider(
            itemCount: _items.length,
            selectedIndex: _indexOf(_selectedValue) < 0
                ? 0
                : _indexOf(_selectedValue),
            borderRadius: _sliderBorderRadius(theme),
            theme: theme,
            vertical: _isVertical,
          ),
        ),
        Positioned.fill(
          child: Flex(
            direction: _isVertical ? Axis.vertical : Axis.horizontal,
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _SegmentItem(
                    item: _items[i],
                    selected: i == _indexOf(_selectedValue),
                    disabled: widget.disabled || _items[i].disabled,
                    theme: theme,
                    size: widget.size,
                    withBackground: false,
                    vertical: _isVertical,
                    onTap: () => _handleTap(_items[i]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInline(AntThemeData theme) {
    return Flex(
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _items.length; i++)
          _SegmentItem(
            item: _items[i],
            selected: i == _indexOf(_selectedValue),
            disabled: widget.disabled || _items[i].disabled,
            theme: theme,
            size: widget.size,
            withBackground: true,
            vertical: _isVertical,
            onTap: () => _handleTap(_items[i]),
          ),
      ],
    );
  }

  int _indexOf(String value) {
    for (var i = 0; i < _items.length; i++) {
      if (_itemValue(_items[i]) == value) return i;
    }
    return -1;
  }

  double get _trackHeight {
    switch (widget.size) {
      case AntSegmentedSize.small:
        return 24;
      case AntSegmentedSize.middle:
        return 32;
      case AntSegmentedSize.large:
        return 40;
    }
  }

  BorderRadius _trackBorderRadius(AntThemeData theme) {
    final radius = widget.shape == AntSegmentedShape.round
        ? _trackHeight / 2
        : theme.borderRadiusSM;
    return BorderRadius.circular(radius.w);
  }

  BorderRadius _sliderBorderRadius(AntThemeData theme) {
    final inner = _trackHeight - 4;
    final radius = widget.shape == AntSegmentedShape.round
        ? inner / 2
        : theme.borderRadiusSM - 2;
    return BorderRadius.circular(radius.clamp(0.0, double.infinity).w);
  }
}

/// 选中滑块（block 模式下随选中项平滑滑动）。
class _Slider extends StatelessWidget {
  const _Slider({
    required this.itemCount,
    required this.selectedIndex,
    required this.borderRadius,
    required this.theme,
    this.vertical = false,
  });

  final int itemCount;
  final int selectedIndex;
  final BorderRadius borderRadius;
  final AntThemeData theme;

  /// 是否垂直方向滑块（沿 y 轴动画）。
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final progress = itemCount <= 1 ? 0.0 : selectedIndex / (itemCount - 1);
    final alignment = vertical
        ? Alignment(0, -1 + 2 * progress)
        : Alignment(-1 + 2 * progress, 0);

    return AnimatedAlign(
      duration: _kSlideDuration,
      curve: Curves.easeOut,
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: itemCount <= 0 ? 1 : (vertical ? 1 : 1 / itemCount),
        heightFactor: itemCount <= 0 ? 1 : (vertical ? 1 / itemCount : 1),
        child: AnimatedContainer(
          duration: _kSlideDuration,
          decoration: BoxDecoration(
            color: theme.colorBgContainer,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4.w,
                offset: Offset(0, 2.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单个选项。
class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.item,
    required this.selected,
    required this.disabled,
    required this.theme,
    required this.size,
    required this.withBackground,
    required this.vertical,
    required this.onTap,
  });

  final AntSegmentedItem item;
  final bool selected;
  final bool disabled;
  final AntThemeData theme;
  final AntSegmentedSize size;
  final bool withBackground;

  /// 是否垂直排列（inline 背景需纵向 padding 撑高，不使用 height infinity）。
  final bool vertical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = disabled
        ? theme.colorTextQuaternary
        : selected
            ? theme.colorText
            : theme.colorTextSecondary;
    final fontSize = _fontSize();

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.icon != null) ...[
          IconTheme.merge(
            data: IconThemeData(color: fg, size: _iconSize()),
            child: item.icon!,
          ),
          if (item.label?.isNotEmpty ?? false) SizedBox(width: 4.w),
        ],
        if (item.label?.isNotEmpty ?? false)
          Text(
            item.label!,
            style: TextStyle(
              fontSize: fontSize.sp,
              color: fg,
              fontWeight: selected && !disabled ? FontWeight.w500 : FontWeight.w400,
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    // 非 block 模式：滑块背景随选中项原地过渡。
    // 水平：背景撑满轨道内高（height infinity + alignment center 修复
    // 背景只有文字行高导致的"挤"观感）；垂直：用纵向 padding 撑出项高。
    final box = withBackground
        ? AnimatedContainer(
            duration: _kSlideDuration,
            height: vertical ? null : double.infinity,
            alignment: vertical ? null : Alignment.center,
            padding: vertical
                ? EdgeInsets.symmetric(
                    horizontal: _horizontalPadding().w,
                    vertical: _verticalPadding().w,
                  )
                : EdgeInsets.symmetric(horizontal: _horizontalPadding().w),
            decoration: BoxDecoration(
              color: selected && !disabled ? theme.colorBgContainer : null,
              borderRadius: BorderRadius.circular((theme.borderRadiusSM - 2).w),
              boxShadow: selected && !disabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4.w,
                        offset: Offset(0, 2.w),
                      ),
                    ]
                  : null,
            ),
            child: content,
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: content,
            ),
          );

    return GestureDetector(
      onTap: disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: box,
    );
  }

  double _fontSize() {
    switch (size) {
      case AntSegmentedSize.small:
        return theme.fontSizeSM;
      case AntSegmentedSize.middle:
        return theme.fontSize;
      case AntSegmentedSize.large:
        return theme.fontSizeLG;
    }
  }

  double _iconSize() {
    switch (size) {
      case AntSegmentedSize.small:
        return 12;
      case AntSegmentedSize.middle:
        return 14;
      case AntSegmentedSize.large:
        return 16;
    }
  }

  double _horizontalPadding() {
    switch (size) {
      case AntSegmentedSize.small:
        return 8;
      case AntSegmentedSize.middle:
        return 12;
      case AntSegmentedSize.large:
        return 16;
    }
  }

  /// 垂直模式的纵向内边距（水平加大、垂直缩小，撑出 32.w 等效项高）。
  double _verticalPadding() {
    switch (size) {
      case AntSegmentedSize.small:
        return 4;
      case AntSegmentedSize.middle:
        return 7;
      case AntSegmentedSize.large:
        return 10;
    }
  }
}
