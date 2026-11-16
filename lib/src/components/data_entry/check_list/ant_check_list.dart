/// AntCheckList — antd-mobile CheckList 复选列表的 Flutter 实现
///
/// API 与 antd-mobile React CheckList 对齐：
/// - [AntCheckList] — 列表样式的单选/多选组件
/// - [AntCheckListItem] — 列表项（value/child/description/prefix/disabled/readOnly）
///
/// ```dart
/// AntCheckList<String>(
///   multiple: true,
///   defaultValue: ['a'],
///   items: [
///     AntCheckListItem(value: 'a', child: Text('选项一')),
///     AntCheckListItem(value: 'b', child: Text('选项二')),
///   ],
///   onChange: (vals) => print(vals),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/check_list/ant_check_list_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/check_list/ant_check_list_types.dart';
import 'package:flutter/material.dart';

/// 复选列表 — 列表样式的单选/多选组件。
///
/// 对齐 antd-mobile React CheckList。
class AntCheckList<T> extends StatefulWidget {
  const AntCheckList({
    super.key,
    this.value,
    this.defaultValue,
    this.multiple = false,
    this.onChange,
    this.disabled = false,
    this.readOnly = false,
    this.showCheckMark = true,
    this.activeIcon,
    required this.items,
  });

  /// 受控选中值列表。
  final List<T>? value;

  /// 非受控初始选中值列表。
  final List<T>? defaultValue;

  /// 是否支持多选。
  final bool multiple;

  /// 选中值变化回调。
  final ValueChanged<List<T>>? onChange;

  /// 是否整体禁用。
  final bool disabled;

  /// 是否整体只读。
  final bool readOnly;

  /// 是否显示勾选标记。
  final bool showCheckMark;

  /// 自定义选中图标。
  final Widget? activeIcon;

  /// 列表项。
  final List<AntCheckListItem<T>> items;

  @override
  State<AntCheckList<T>> createState() => _AntCheckListState<T>();
}

class _AntCheckListState<T> extends State<AntCheckList<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.value ?? widget.defaultValue ?? []);
  }

  @override
  void didUpdateWidget(AntCheckList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      final incoming = List<T>.from(widget.value!);
      if (!_listEquals(incoming, _selected)) {
        _selected = incoming;
      }
    }
  }

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _handleTap(AntCheckListItem<T> item) {
    final isDisabled = widget.disabled || item.disabled;
    final isReadOnly = widget.readOnly || item.readOnly;
    if (isDisabled || isReadOnly) return;

    final next = List<T>.from(_selected);
    if (widget.multiple) {
      if (next.contains(item.value)) {
        next.remove(item.value);
      } else {
        next.add(item.value);
      }
    } else {
      if (next.contains(item.value)) {
        next.clear();
      } else {
        next
          ..clear()
          ..add(item.value);
      }
    }

    if (widget.value == null) {
      setState(() => _selected = next);
    }
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final current = widget.value ?? _selected;

    return Container(
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0)
              Divider(height: 1.w, thickness: 1.w, color: t.colorSplit),
            _buildItem(context, t, widget.items[i], current),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    AntThemeData t,
    AntCheckListItem<T> item,
    List<T> current,
  ) {
    final isChecked = current.contains(item.value);
    final isDisabled = widget.disabled || item.disabled;
    final isReadOnly = widget.readOnly || item.readOnly;
    final canTap = !isDisabled && !isReadOnly;

    return InkWell(
      onTap: canTap ? () => _handleTap(item) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.margin.w,
          vertical: t.marginSM.w,
        ),
        child: Row(
          children: [
            if (item.prefix != null) ...[
              item.prefix!,
              SizedBox(width: t.marginSM.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: t.fontSize.sp,
                      color: isDisabled ? t.colorTextDisabled : t.colorText,
                    ),
                    child: item.child,
                  ),
                  if (item.description != null) ...[
                    SizedBox(height: 2.w),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: t.fontSizeSM.sp,
                        color: isDisabled
                            ? t.colorTextQuaternary
                            : t.colorTextSecondary,
                      ),
                      child: item.description!,
                    ),
                  ],
                ],
              ),
            ),
            if (widget.showCheckMark)
              Padding(
                padding: EdgeInsets.only(left: t.marginSM.w),
                child: isChecked
                    ? (widget.activeIcon ??
                        Icon(
                          Icons.check,
                          size: 18.w,
                          color: t.colorPrimary,
                        ))
                    : SizedBox(width: 18.w),
              ),
          ],
        ),
      ),
    );
  }
}