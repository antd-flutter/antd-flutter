/// AntSelector — antd-mobile Selector 选择组的 Flutter 实现
///
/// API 与 antd-mobile React Selector 对齐：直接传 `List<T>` 选项，
/// 用 [labelOf] / [labelBuilder] / [descriptionOf] 渲染内容，选中值回调为 `List<T>`。
///
/// ```dart
/// AntSelector<String>(
///   options: const ['选项一', '选项二'],
///   onChange: (vals) => print(vals),
/// )
///
/// AntSelector<Tag>(
///   options: tags,                                  // List<Tag>
///   labelOf: (tag) => tag.name,
///   descriptionOf: (tag) => tag.count.toString(),
///   onChange: (tags) => print(tags),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/selector/ant_selector_types.dart';
import 'package:material_ui/material_ui.dart';

/// 选择组 — 标签/网格风格的单选/多选组件。
///
/// 对齐 antd-mobile React Selector。
class AntSelector<T> extends StatefulWidget {
  const AntSelector({
    super.key,
    this.value,
    this.defaultValue,
    required this.options,
    this.labelOf,
    this.labelBuilder,
    this.descriptionOf,
    this.descriptionBuilder,
    this.itemBuilder,
    this.disabledOf,
    this.multiple = false,
    this.onChange,
    this.disabled = false,
    this.readOnly = false,
    this.columns,
  });

  /// 受控选中值列表。
  final List<T>? value;

  /// 非受控初始选中值列表。
  final List<T>? defaultValue;

  /// 选项列表（任意模型）。
  final List<T> options;

  /// 选项的字符串 label 简写（未提供 [labelBuilder] 时作为文本渲染）。
  final String Function(T item)? labelOf;

  /// 选项 label 的自定义渲染。
  final Widget Function(BuildContext context, T item)? labelBuilder;

  /// 选项描述的字符串简写。
  final String Function(T item)? descriptionOf;

  /// 选项描述的自定义渲染。
  final Widget Function(BuildContext context, T item)? descriptionBuilder;

  /// 整项内容自定义渲染（替换内置 label + description 布局）。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 选项是否禁用。
  final bool Function(T item)? disabledOf;

  /// 是否支持多选。
  final bool multiple;

  /// 选中值变化回调。
  final ValueChanged<List<T>>? onChange;

  /// 是否整体禁用。
  final bool disabled;

  /// 是否整体只读。
  final bool readOnly;

  /// 列数（null 时自动换行）。
  final int? columns;

  @override
  State<AntSelector<T>> createState() => _AntSelectorState<T>();
}

class _AntSelectorState<T> extends State<AntSelector<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.value ?? widget.defaultValue ?? []);
  }

  @override
  void didUpdateWidget(AntSelector<T> oldWidget) {
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

  void _handleTap(T item) {
    if (_isDisabled(item) || widget.readOnly) return;

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

  String _labelTextOf(T item) => widget.labelOf?.call(item) ?? '$item';

  String? _descriptionTextOf(T item) => widget.descriptionOf?.call(item);

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final current = widget.value ?? _selected;

    if (widget.columns != null && widget.columns! > 0) {
      return _buildGrid(current);
    }

    // 自动换行：用 Wrap + 固定宽度项
    return Wrap(
      spacing: t.s(8),
      runSpacing: t.s(8),
      children: [
        for (var i = 0; i < widget.options.length; i++)
          _SelectorItem<T>(
            item: widget.options[i],
            index: i,
            labelText: _labelTextOf(widget.options[i]),
            labelBuilder: widget.labelBuilder,
            descriptionText: _descriptionTextOf(widget.options[i]),
            descriptionBuilder: widget.descriptionBuilder,
            itemBuilder: widget.itemBuilder,
            checked: _containsItem(current, widget.options[i]),
            disabled: _isDisabled(widget.options[i]),
            readOnly: widget.readOnly,
            onTap: () => _handleTap(widget.options[i]),
            fixedWidth: true,
          ),
      ],
    );
  }

  Widget _buildGrid(List<T> current) {
    final t = AntTheme.of(context);
    final cols = widget.columns!;
    final rows = <Widget>[];
    for (var i = 0; i < widget.options.length; i += cols) {
      final rowChildren = <Widget>[];
      for (var j = i; j < i + cols && j < widget.options.length; j++) {
        final item = widget.options[j];
        if (j > i) rowChildren.add(SizedBox(width: t.s(8)));
        rowChildren.add(
          Expanded(
            child: _SelectorItem<T>(
              item: item,
              index: j,
              labelText: _labelTextOf(item),
              labelBuilder: widget.labelBuilder,
              descriptionText: _descriptionTextOf(item),
              descriptionBuilder: widget.descriptionBuilder,
              itemBuilder: widget.itemBuilder,
              checked: _containsItem(current, item),
              disabled: _isDisabled(item),
              readOnly: widget.readOnly,
              onTap: () => _handleTap(item),
            ),
          ),
        );
      }
      // 补齐空位
      final remainder = widget.options.length - i;
      for (var k = remainder; k < cols; k++) {
        rowChildren.add(SizedBox(width: t.s(8)));
        rowChildren.add(const Expanded(child: SizedBox()));
      }
      rows.add(Row(children: rowChildren));
      if (i + cols < widget.options.length) {
        rows.add(SizedBox(height: t.s(8)));
      }
    }
    return Column(children: rows);
  }

  bool _containsItem(List<T> values, T item) => values.contains(item);
}

class _SelectorItem<T> extends StatelessWidget {
  const _SelectorItem({
    required this.item,
    required this.index,
    required this.labelText,
    required this.checked,
    required this.disabled,
    required this.readOnly,
    required this.onTap,
    this.labelBuilder,
    this.descriptionText,
    this.descriptionBuilder,
    this.itemBuilder,
    this.fixedWidth = false,
  });

  final T item;
  final int index;
  final String labelText;
  final bool checked;
  final bool disabled;
  final bool readOnly;
  final VoidCallback onTap;
  final Widget Function(BuildContext context, T item)? labelBuilder;
  final String? descriptionText;
  final Widget Function(BuildContext context, T item)? descriptionBuilder;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final bool fixedWidth;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final canTap = !disabled && !readOnly;

    Widget content = itemBuilder?.call(context, item, index) ??
        Padding(
          padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: t.fontSize,
                  color: disabled
                      ? t.colorTextDisabled
                      : checked
                          ? t.colorPrimary
                          : t.colorText,
                  fontWeight: checked ? FontWeight.w500 : FontWeight.w400,
                ),
                child: labelBuilder?.call(context, item) ??
                    Text(
                      labelText,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (descriptionBuilder != null || descriptionText != null) ...[
                SizedBox(height: t.s(2)),
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color:
                        disabled ? t.colorTextQuaternary : t.colorTextSecondary,
                  ),
                  child: descriptionBuilder?.call(context, item) ??
                      Text(
                        descriptionText!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ],
            ],
          ),
        );

    Widget card = GestureDetector(
      onTap: canTap ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: disabled
              ? t.colorBgContainerDisabled
              : checked
                  ? t.colorPrimary.withValues(alpha: 0.08)
                  : t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius),
          border: Border.all(
            color: checked && !disabled ? t.colorPrimary : Colors.transparent,
            width: t.s(1),
          ),
        ),
        child: content,
      ),
    );

    if (fixedWidth) {
      return IntrinsicWidth(child: card);
    }
    return card;
  }
}
