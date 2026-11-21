/// AntCascaderView — antd-mobile CascaderView 的 Flutter 实现
///
/// 级联选择视图，以 Tab + 列表的形式逐级选择关联数据。
///
/// API 与 antd-mobile CascaderView 对齐：
/// - [dataSource] — 级联选项树（直接使用使用者自己的模型 `T`）
/// - [keyOf] — 从模型取唯一标识
/// - [childrenOf] — 从模型取子节点（返回 null/空表示叶子）
/// - [labelBuilder] — 选项自定义渲染（缺省 `Text('$item')`）
/// - [disabledOf] — 选项禁用判断
/// - [value] / [defaultValue] — 受控/非受控值（元素可为 `T` 或 key）
/// - [onChange] — 值变化回调，附带逐层已选模型（未选层级为 null）
/// - [placeholder] — 未选择层级的占位文本
/// - [onTabsChange] — 切换层级 Tab 回调
/// - [activeIcon] — 自定义选中图标
/// - [height] — 内容区高度
///
/// ```dart
/// AntCascaderView<Region>(
///   dataSource: regions,
///   keyOf: (r) => r.code,
///   childrenOf: (r) => r.children,
///   labelBuilder: (context, r) => Text(r.name),
///   onChange: (value, items) => print(value),
/// )
/// ```
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_cascader_types.dart';

export 'ant_cascader_types.dart';

/// 级联层级数据
class _CascaderLevel<T> {
  const _CascaderLevel({
    this.selected,
    required this.options,
  });

  /// 当前层级已选选项（可能为 null）
  final T? selected;

  /// 当前层级可选列表
  final List<T> options;
}

/// 级联选择视图。
///
/// 以 Tab + 选项列表的形式逐级选择关联层级数据，
/// 选择某项后自动展开下一层级。
class AntCascaderView<T> extends StatefulWidget {
  const AntCascaderView({
    super.key,
    required this.keyOf,
    this.dataSource = const [],
    this.childrenOf,
    this.labelBuilder,
    this.disabledOf,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.placeholder = '请选择',
    this.onTabsChange,
    this.activeIcon,
    this.height,
  });

  /// 级联选项树。
  final List<T> dataSource;

  /// 从模型取唯一标识。
  final AntCascaderKeyOf<T> keyOf;

  /// 从模型取子节点；为空表示所有选项都是叶子。
  final AntCascaderChildrenOf<T>? childrenOf;

  /// 选项自定义渲染；为空时回退为 `Text('$item')`。
  final AntCascaderLabelBuilder<T>? labelBuilder;

  /// 选项禁用判断。
  final AntCascaderDisabledOf<T>? disabledOf;

  /// 受控值（路径数组，元素可为 `T` 或 key）。
  final List<Object>? value;

  /// 非受控默认值（路径数组，元素可为 `T` 或 key）。
  final List<Object> defaultValue;

  /// 值变化回调，附带逐层已选模型（未选层级为 null）。
  final AntCascaderViewOnChange<T>? onChange;

  /// 未选择层级的占位文本。
  final String placeholder;

  /// 切换层级 Tab 回调。
  final ValueChanged<int>? onTabsChange;

  /// 自定义选中图标。
  final Widget? activeIcon;

  /// 内容区高度。
  final double? height;

  @override
  State<AntCascaderView<T>> createState() => _AntCascaderViewState<T>();
}

class _AntCascaderViewState<T> extends State<AntCascaderView<T>> {
  late List<Object> _internalValue;
  int _tabActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    _internalValue = List<Object>.from(widget.defaultValue);
    _tabActiveIndex = _computeLevels(_currentValue).length - 1;
  }

  @override
  void didUpdateWidget(covariant AntCascaderView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null &&
        !_sameValueList(widget.value!, oldWidget.value)) {
      // 受控值变化时，同步内部状态并跳到最后一级
      _internalValue = List<Object>.from(widget.value!);
      _tabActiveIndex = _computeLevels(_internalValue).length - 1;
    }
  }

  List<Object> get _currentValue => widget.value ?? _internalValue;

  bool _matches(T item, Object value) =>
      widget.keyOf(item) == value || identical(item, value) || item == value;

  bool _isDisabled(T item) => widget.disabledOf?.call(item) ?? false;

  /// 根据值路径计算层级列表
  List<_CascaderLevel<T>> _computeLevels(List<Object> value) {
    final ret = <_CascaderLevel<T>>[];
    var currentOptions = widget.dataSource;
    var reachedEnd = false;

    for (final v in value) {
      T? target;
      for (final option in currentOptions) {
        if (_matches(option, v)) {
          target = option;
          break;
        }
      }
      ret.add(_CascaderLevel(selected: target, options: currentOptions));
      if (target == null) {
        reachedEnd = true;
        break;
      }
      final children = widget.childrenOf?.call(target);
      if (children == null || children.isEmpty) {
        reachedEnd = true;
        break;
      }
      currentOptions = children;
    }
    if (!reachedEnd) {
      ret.add(_CascaderLevel(selected: null, options: currentOptions));
    }
    if (ret.isEmpty) {
      ret.add(_CascaderLevel(selected: null, options: widget.dataSource));
    }
    return ret;
  }

  void _onItemSelect(T item, int depth) {
    final next = <Object>[
      ..._currentValue.take(depth),
      widget.keyOf(item),
    ];

    final levels = _computeLevels(next);
    final newTabIndex = levels.length - 1;
    final tabChanged = newTabIndex != _tabActiveIndex;
    setState(() {
      if (widget.value == null) {
        _internalValue = next;
      }
      _tabActiveIndex = newTabIndex;
    });
    final items = <T?>[for (final level in levels) level.selected];
    widget.onChange?.call(items.whereType<T>().toList(), items);
    if (tabChanged) {
      widget.onTabsChange?.call(newTabIndex);
    }
  }

  void _onTabTap(int index) {
    if (index == _tabActiveIndex) return;
    setState(() => _tabActiveIndex = index);
    widget.onTabsChange?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final levels = _computeLevels(_currentValue);

    // 钳制 tab 索引
    final maxIndex = levels.length - 1;
    if (_tabActiveIndex > maxIndex) {
      _tabActiveIndex = maxIndex;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTabBar(t, levels),
        Divider(height: 1, thickness: 1, color: t.colorSplit),
        Flexible(
          child: _buildContent(t, levels),
        ),
      ],
    );
  }

  Widget _buildTabBar(AntThemeData t, List<_CascaderLevel<T>> levels) {
    return SizedBox(
      height: t.s(44),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: t.s(12)),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final active = index == _tabActiveIndex;
          final selected = level.selected;
          return GestureDetector(
            onTap: () => _onTabTap(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: t.s(12)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: active ? t.colorPrimary : Colors.transparent,
                  ),
                ),
              ),
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: t.s(14),
                  color: active ? t.colorPrimary : t.colorTextSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
                child: selected == null
                    ? Text(widget.placeholder)
                    : widget.labelBuilder?.call(context, selected) ??
                        Text('$selected'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(AntThemeData t, List<_CascaderLevel<T>> levels) {
    final level = levels[_tabActiveIndex];
    return SizedBox(
      height: widget.height ?? t.s(300),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: ListView.builder(
          key: ValueKey(_tabActiveIndex),
          padding: EdgeInsets.symmetric(vertical: t.s(4)),
          itemCount: level.options.length,
          itemBuilder: (context, index) {
            final option = level.options[index];
            final selected = _currentValue.length > _tabActiveIndex &&
                _matches(option, _currentValue[_tabActiveIndex]);
            return _buildOptionItem(context, t, option, selected);
          },
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    AntThemeData t,
    T option,
    bool selected,
  ) {
    final disabled = _isDisabled(option);
    return GestureDetector(
      onTap: disabled ? null : () => _onItemSelect(option, _tabActiveIndex),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: disabled ? 0.4 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: t.s(16), vertical: t.s(13)),
          child: Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: t.s(15),
                    color: selected ? t.colorPrimary : t.colorText,
                  ),
                  child: widget.labelBuilder?.call(context, option) ??
                      Text('$option'),
                ),
              ),
              if (selected) ...[
                SizedBox(width: t.s(8)),
                widget.activeIcon ??
                    Icon(
                      AntIcons.checkOutlined,
                      size: t.s(18),
                      color: t.colorPrimary,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

bool _sameValueList(List<Object> a, List<Object>? b) {
  if (b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!identical(a[i], b[i]) && a[i] != b[i]) return false;
  }
  return true;
}
