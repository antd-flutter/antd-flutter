/// AntSelector — antd-mobile Selector 选择组的 Flutter 实现
///
/// API 与 antd-mobile React Selector 对齐：
/// - [AntSelector] — 标签/网格风格的单选/多选组件
/// - [AntSelectorOption] — 选项（value/label/description/disabled）
///
/// ```dart
/// AntSelector<String>(
///   options: [
///     AntSelectorOption(value: 'a', label: Text('选项一')),
///     AntSelectorOption(value: 'b', label: Text('选项二')),
///   ],
///   onChange: (vals) => print(vals),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/selector/ant_selector_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/selector/ant_selector_types.dart';
import 'package:flutter/material.dart';

/// 选择组 — 标签/网格风格的单选/多选组件。
///
/// 对齐 antd-mobile React Selector。
class AntSelector<T> extends StatefulWidget {
  const AntSelector({
    super.key,
    this.value,
    this.defaultValue,
    required this.options,
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

  /// 选项列表。
  final List<AntSelectorOption<T>> options;

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

  void _handleTap(AntSelectorOption<T> opt) {
    final isDisabled = widget.disabled || opt.disabled;
    final isReadOnly = widget.readOnly;
    if (isDisabled || isReadOnly) return;

    final next = List<T>.from(_selected);
    if (widget.multiple) {
      if (next.contains(opt.value)) {
        next.remove(opt.value);
      } else {
        next.add(opt.value);
      }
    } else {
      if (next.contains(opt.value)) {
        next.clear();
      } else {
        next
          ..clear()
          ..add(opt.value);
      }
    }

    if (widget.value == null) {
      setState(() => _selected = next);
    }
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.value ?? _selected;

    if (widget.columns != null && widget.columns! > 0) {
      return _buildGrid(current);
    }

    // 自动换行：用 Wrap + 固定宽度项
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.w,
      children: [
        for (final opt in widget.options)
          _SelectorItem<T>(
            option: opt,
            checked: current.contains(opt.value),
            disabled: widget.disabled || opt.disabled,
            readOnly: widget.readOnly,
            onTap: () => _handleTap(opt),
            fixedWidth: true,
          ),
      ],
    );
  }

  Widget _buildGrid(List<T> current) {
    final cols = widget.columns!;
    final rows = <Widget>[];
    for (var i = 0; i < widget.options.length; i += cols) {
      final rowChildren = <Widget>[];
      for (var j = i; j < i + cols && j < widget.options.length; j++) {
        final opt = widget.options[j];
        if (j > i) rowChildren.add(SizedBox(width: 8.w));
        rowChildren.add(
          Expanded(
            child: _SelectorItem<T>(
              option: opt,
              checked: current.contains(opt.value),
              disabled: widget.disabled || opt.disabled,
              readOnly: widget.readOnly,
              onTap: () => _handleTap(opt),
            ),
          ),
        );
      }
      // 补齐空位
      final remainder = widget.options.length - i;
      for (var k = remainder; k < cols; k++) {
        rowChildren.add(SizedBox(width: 8.w));
        rowChildren.add(const Expanded(child: SizedBox()));
      }
      rows.add(Row(children: rowChildren));
      if (i + cols < widget.options.length) {
        rows.add(SizedBox(height: 8.w));
      }
    }
    return Column(children: rows);
  }
}

class _SelectorItem<T> extends StatelessWidget {
  const _SelectorItem({
    required this.option,
    required this.checked,
    required this.disabled,
    required this.readOnly,
    required this.onTap,
    this.fixedWidth = false,
  });

  final AntSelectorOption<T> option;
  final bool checked;
  final bool disabled;
  final bool readOnly;
  final VoidCallback onTap;
  final bool fixedWidth;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final canTap = !disabled && !readOnly;

    Widget content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: t.fontSize.sp,
              color: disabled
                  ? t.colorTextDisabled
                  : checked
                      ? t.colorPrimary
                      : t.colorText,
              fontWeight: checked ? FontWeight.w500 : FontWeight.w400,
            ),
            child: option.label,
          ),
          if (option.description != null) ...[
            SizedBox(height: 2.w),
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: t.fontSizeSM.sp,
                color: disabled
                    ? t.colorTextQuaternary
                    : t.colorTextSecondary,
              ),
              child: option.description!,
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
                  ? t.colorPrimary.withOpacity(0.08)
                  : t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius.w),
          border: Border.all(
            color: checked && !disabled ? t.colorPrimary : Colors.transparent,
            width: 1.w,
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