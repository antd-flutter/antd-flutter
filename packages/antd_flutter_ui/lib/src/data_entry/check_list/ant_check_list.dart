/// AntCheckList — antd-mobile CheckList 复选列表的 Flutter 实现
///
/// API 与 antd-mobile React CheckList 对齐：直接传 `List<T>` 列表项，
/// 用 [labelOf]/[labelBuilder]、[descriptionOf]、[prefixOf] 渲染内容。
///
/// ```dart
/// AntCheckList<String>(
///   multiple: true,
///   defaultValue: ['a'],
///   items: const ['选项一', '选项二'],
///   onChange: (vals) => print(vals),
/// )
///
/// AntCheckList<Member>(
///   items: members,                       // List<Member>
///   labelOf: (member) => member.name,
///   descriptionOf: (member) => member.email,
///   onChange: (members) => print(members),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/check_list/ant_check_list_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
    this.labelOf,
    this.labelBuilder,
    this.descriptionOf,
    this.descriptionBuilder,
    this.prefixOf,
    this.prefixBuilder,
    this.itemBuilder,
    this.disabledOf,
    this.readOnlyOf,
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

  /// 列表项（任意模型）。
  final List<T> items;

  /// 主内容的字符串 label 简写（未提供 [labelBuilder] 时作为文本渲染）。
  final String Function(T item)? labelOf;

  /// 主内容的自定义渲染。
  final Widget Function(BuildContext context, T item)? labelBuilder;

  /// 描述文本的字符串简写。
  final String Function(T item)? descriptionOf;

  /// 描述内容的自定义渲染。
  final Widget Function(BuildContext context, T item)? descriptionBuilder;

  /// 前缀内容的字符串简写。
  final String Function(T item)? prefixOf;

  /// 前缀内容的自定义渲染。
  final Widget Function(BuildContext context, T item)? prefixBuilder;

  /// 整行自定义渲染（替换内置行布局，仍保留点击与勾选逻辑）。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 列表项是否禁用。
  final bool Function(T item)? disabledOf;

  /// 列表项是否只读。
  final bool Function(T item)? readOnlyOf;

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

  bool _isDisabled(T item) =>
      widget.disabled || (widget.disabledOf?.call(item) ?? false);

  bool _isReadOnly(T item) =>
      widget.readOnly || (widget.readOnlyOf?.call(item) ?? false);

  void _handleTap(T item) {
    if (_isDisabled(item) || _isReadOnly(item)) return;

    final next = List<T>.from(_selected);
    if (widget.multiple) {
      if (next.contains(item)) {
        next.remove(item);
      } else {
        next.add(item);
      }
    } else {
      if (next.contains(item)) {
        next.clear();
      } else {
        next
          ..clear()
          ..add(item);
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
            _buildItem(context, t, widget.items[i], i, current),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    AntThemeData t,
    T item,
    int index,
    List<T> current,
  ) {
    final isChecked = current.contains(item);
    final isDisabled = _isDisabled(item);
    final isReadOnly = _isReadOnly(item);
    final canTap = !isDisabled && !isReadOnly;

    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: canTap ? () => _handleTap(item) : null,
        child: widget.itemBuilder!(context, item, index),
      );
    }

    final prefix = widget.prefixBuilder?.call(context, item);
    final description = widget.descriptionBuilder?.call(context, item);
    final descriptionText = widget.descriptionOf?.call(item);
    final label = widget.labelBuilder?.call(context, item) ??
        Text(
          widget.labelOf?.call(item) ?? '$item',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    return InkWell(
      onTap: canTap ? () => _handleTap(item) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.margin.w,
          vertical: t.marginSM.w,
        ),
        child: Row(
          children: [
            if (prefix != null) ...[
              prefix,
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
                    child: label,
                  ),
                  if (description != null || descriptionText != null) ...[
                    SizedBox(height: 2.w),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: t.fontSizeSM.sp,
                        color: isDisabled
                            ? t.colorTextQuaternary
                            : t.colorTextSecondary,
                      ),
                      child: description ??
                          Text(
                            descriptionText!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                          AntIcons.checkOutlined,
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
