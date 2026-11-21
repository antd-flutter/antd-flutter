/// AntCascaderView — antd-mobile CascaderView 的 Flutter 实现
///
/// 级联选择视图，以 Tab + 列表的形式逐级选择关联数据。
///
/// API 与 antd-mobile CascaderView 对齐：
/// - [options] — 级联选项树（复用 [AntCascaderOption]）
/// - [value] / [defaultValue] — 受控/非受控值（路径数组）
/// - [onChange] — 值变化回调，附带已选选项数组
/// - [placeholder] — 未选择层级的占位文本
/// - [onTabsChange] — 切换层级 Tab 回调
/// - [activeIcon] — 自定义选中图标
/// - [height] — 内容区高度
///
/// ```dart
/// AntCascaderView(
///   options: [
///     AntCascaderOption(value: 'zj', label: '浙江', children: [
///       AntCascaderOption(value: 'hz', label: '杭州'),
///     ]),
///   ],
///   onChange: (value, items) => print(value),
/// )
/// ```
library;

import 'ant_cascader_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'ant_cascader_types.dart';

/// 级联层级数据
class _CascaderLevel {
  const _CascaderLevel({
    this.selected,
    required this.options,
  });

  /// 当前层级已选选项（可能为 null）
  final AntCascaderOption? selected;

  /// 当前层级可选列表
  final List<AntCascaderOption> options;
}

/// 级联选择视图。
///
/// 以 Tab + 选项列表的形式逐级选择关联层级数据，
/// 选择某项后自动展开下一层级。
class AntCascaderView extends StatefulWidget {
  const AntCascaderView({
    super.key,
    this.options = const [],
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.placeholder = '请选择',
    this.onTabsChange,
    this.activeIcon,
    this.height,
  });

  /// 级联选项树
  final List<AntCascaderOption> options;

  /// 受控值（路径数组，如 ['zj', 'hz']）
  final List<String>? value;

  /// 非受控默认值
  final List<String> defaultValue;

  /// 值变化回调，附带已选选项数组（未选层级为 null）
  final void Function(List<String> value, List<AntCascaderOption?> items)?
      onChange;

  /// 未选择层级的占位文本
  final String placeholder;

  /// 切换层级 Tab 回调
  final ValueChanged<int>? onTabsChange;

  /// 自定义选中图标
  final Widget? activeIcon;

  /// 内容区高度
  final double? height;

  @override
  State<AntCascaderView> createState() => _AntCascaderViewState();
}

class _AntCascaderViewState extends State<AntCascaderView> {
  late List<String> _internalValue;
  int _tabActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    _internalValue = List<String>.from(widget.defaultValue);
    _tabActiveIndex = _computeLevels(_currentValue).length - 1;
  }

  @override
  void didUpdateWidget(covariant AntCascaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      // 受控值变化时，同步内部状态并跳到最后一级
      final controlled = widget.value ?? _internalValue;
      if (!_listEquals(controlled, _internalValue)) {
        _internalValue = List<String>.from(controlled);
        _tabActiveIndex = _computeLevels(_internalValue).length - 1;
      }
    }
  }

  List<String> get _currentValue =>
      widget.value ?? _internalValue;

  /// 根据值路径计算层级列表
  List<_CascaderLevel> _computeLevels(List<String> value) {
    final ret = <_CascaderLevel>[];
    var currentOptions = widget.options;
    var reachedEnd = false;

    for (final v in value) {
      AntCascaderOption? target;
      for (final option in currentOptions) {
        if (option.value == v) {
          target = option;
          break;
        }
      }
      ret.add(_CascaderLevel(selected: target, options: currentOptions));
      if (target == null ||
          target.children == null ||
          target.children!.isEmpty) {
        reachedEnd = true;
        break;
      }
      currentOptions = target.children!;
    }
    if (!reachedEnd) {
      ret.add(_CascaderLevel(selected: null, options: currentOptions));
    }
    if (ret.isEmpty) {
      ret.add(_CascaderLevel(selected: null, options: widget.options));
    }
    return ret;
  }

  /// 根据值路径获取已选选项数组
  List<AntCascaderOption?> _getItems(List<String> value) {
    final items = <AntCascaderOption?>[];
    var currentOptions = widget.options;
    for (final v in value) {
      AntCascaderOption? target;
      for (final option in currentOptions) {
        if (option.value == v) {
          target = option;
          break;
        }
      }
      items.add(target);
      if (target == null ||
          target.children == null ||
          target.children!.isEmpty) {
        break;
      }
      currentOptions = target.children!;
    }
    return items;
  }

  void _onItemSelect(String selectValue, int depth) {
    final next = List<String>.from(_currentValue.take(depth));
    next.add(selectValue);

    final newTabIndex = _computeLevels(next).length - 1;
    final tabChanged = newTabIndex != _tabActiveIndex;
    setState(() {
      if (widget.value == null) {
        _internalValue = next;
      }
      _tabActiveIndex = newTabIndex;
    });
    widget.onChange?.call(next, _getItems(next));
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

  Widget _buildTabBar(AntThemeData t, List<_CascaderLevel> levels) {
    return SizedBox(
      height: 44.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final active = index == _tabActiveIndex;
          final title = level.selected?.label ?? widget.placeholder;
          return GestureDetector(
            onTap: () => _onTabTap(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: active ? t.colorPrimary : Colors.transparent,
                  ),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: active ? t.colorPrimary : t.colorTextSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(AntThemeData t, List<_CascaderLevel> levels) {
    final level = levels[_tabActiveIndex];
    return SizedBox(
      height: widget.height ?? 300.h,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: ListView.builder(
          key: ValueKey(_tabActiveIndex),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          itemCount: level.options.length,
          itemBuilder: (context, index) {
            final option = level.options[index];
            final selected = _currentValue.length > _tabActiveIndex &&
                _currentValue[_tabActiveIndex] == option.value;
            return _buildOptionItem(t, option, selected);
          },
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    AntThemeData t,
    AntCascaderOption option,
    bool selected,
  ) {
    return GestureDetector(
      onTap: option.disabled ? null : () => _onItemSelect(option.value, _tabActiveIndex),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: option.disabled ? 0.4 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: selected ? t.colorPrimary : t.colorText,
                  ),
                ),
              ),
              if (selected) ...[
                SizedBox(width: 8.w),
                widget.activeIcon ??
                    Icon(
                      AntIcons.checkOutlined,
                      size: 18.sp,
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

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}