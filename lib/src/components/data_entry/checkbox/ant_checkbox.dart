/// AntCheckbox — antd Checkbox 复选框的 Flutter 实现
///
/// API 与 antd React Checkbox 对齐：
/// - [AntCheckbox] — 基础复选框（checked/indeterminate/disabled/onChange）
/// - [AntCheckboxGroup] — 复选框组（options/value/onChange）
///
/// ```dart
/// AntCheckbox(
///   checked: true,
///   onChange: (v) => print(v),
///   child: Text('选项'),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/checkbox/ant_checkbox_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/checkbox/ant_checkbox_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// 内部：复选框方框绘制
// ============================================================

/// 复选框方框
class _CheckboxBox extends StatelessWidget {
  const _CheckboxBox({
    required this.checked,
    required this.indeterminate,
    required this.disabled,
    required this.size,
    required this.theme,
  });

  final bool checked;
  final bool indeterminate;
  final bool disabled;
  final double size;
  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final borderColor = disabled
        ? t.colorBorder
        : checked || indeterminate
            ? (disabled ? t.colorBorder : t.colorPrimary)
            : t.colorBorder;
    final bgColor = disabled
        ? (checked || indeterminate ? t.colorBorder : t.colorBgContainerDisabled)
        : (checked || indeterminate ? t.colorPrimary : t.colorBgContainer);

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: checked || indeterminate
          ? Icon(
              indeterminate ? Icons.remove : Icons.check,
              size: size.w * 0.75,
              color: disabled ? t.colorTextDisabled : Colors.white,
            )
          : null,
    );
  }
}

// ============================================================
// AntCheckbox
// ============================================================

/// 复选框 — 在一组备选项中进行多选。
///
/// 对齐 antd React Checkbox 组件，支持半选、禁用、受控/非受控。
/// 在 [AntCheckboxGroup] children 模式下传入 [AntCheckbox.value] 可与组联动。
class AntCheckbox extends StatefulWidget {
  const AntCheckbox({
    super.key,
    this.checked,
    this.defaultChecked = false,
    this.indeterminate = false,
    this.disabled = false,
    this.onChange,
    this.value,
    required this.child,
    this.autofocus = false,
  });

  /// 受控选中状态。
  final bool? checked;

  /// 非受控初始选中状态。
  final bool defaultChecked;

  /// 半选状态（仅影响样式，不影响 checked）。
  final bool indeterminate;

  /// 是否禁用。
  final bool disabled;

  /// 变化回调。
  final ValueChanged<bool>? onChange;

  /// 组内标识值（在 [AntCheckboxGroup] children 模式下用于联动）。
  final dynamic value;

  /// 标签。
  final Widget child;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntCheckbox> createState() => _AntCheckboxState();
}

class _AntCheckboxState extends State<AntCheckbox> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked ?? widget.defaultChecked;
  }

  @override
  void didUpdateWidget(AntCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked != null && widget.checked != _checked) {
      _checked = widget.checked!;
    }
  }

  void _toggle() {
    if (widget.disabled) return;
    final next = !_checked;
    setState(() => _checked = next);
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final group = _GroupData.of(context);
    final inGroup = group != null && widget.value != null;

    final isChecked = inGroup
        ? group.values.contains(widget.value)
        : (widget.checked ?? _checked);
    final isDisabled =
        inGroup ? (widget.disabled || group.disabled) : widget.disabled;
    final textColor = isDisabled ? t.colorTextDisabled : t.colorText;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (inGroup) {
                widget.onChange?.call(!isChecked);
                group.onToggle(widget.value);
              } else {
                _toggle();
              }
            },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CheckboxBox(
            checked: isChecked,
            indeterminate: widget.indeterminate,
            disabled: isDisabled,
            size: 16,
            theme: t,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(fontSize: t.fontSize.sp, color: textColor),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 内部：CheckboxGroup InheritedWidget
// ============================================================

class _GroupData extends InheritedWidget {
  const _GroupData({
    required this.values,
    required this.disabled,
    required this.onToggle,
    required super.child,
  });

  final Set<dynamic> values;
  final bool disabled;
  final ValueChanged<dynamic> onToggle;

  static _GroupData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_GroupData>();
  }

  @override
  bool updateShouldNotify(_GroupData oldWidget) {
    return values != oldWidget.values || disabled != oldWidget.disabled;
  }
}

// ============================================================
// AntCheckboxGroup
// ============================================================

/// 复选框组 — 包裹一组 [AntCheckbox]，统一管理选中值。
///
/// 对齐 antd React Checkbox.Group，支持 options、受控 value、禁用。
///
/// ```dart
/// AntCheckboxGroup<String>(
///   options: [
///     AntCheckboxOption(value: 'a', label: Text('A')),
///     AntCheckboxOption(value: 'b', label: Text('B')),
///   ],
///   onChange: (vals) => print(vals),
/// )
/// ```
class AntCheckboxGroup<T> extends StatefulWidget {
  const AntCheckboxGroup({
    super.key,
    this.value,
    this.defaultValue = const [],
    this.options = const [],
    this.disabled = false,
    this.onChange,
    this.direction = AntCheckboxGroupDirection.horizontal,
    this.children,
  });

  /// 受控选中值集合。
  final List<T>? value;

  /// 非受控初始选中值集合。
  final List<T> defaultValue;

  /// 选项列表。
  final List<AntCheckboxOption<T>> options;

  /// 是否整体禁用。
  final bool disabled;

  /// 变化回调。
  final ValueChanged<List<T>>? onChange;

  /// 排列方向。
  final AntCheckboxGroupDirection direction;

  /// 直接传入 [AntCheckbox] 子组件（与 options 二选一）。
  final List<Widget>? children;

  @override
  State<AntCheckboxGroup<T>> createState() => _AntCheckboxGroupState<T>();
}

class _AntCheckboxGroupState<T> extends State<AntCheckboxGroup<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.value ?? widget.defaultValue);
  }

  @override
  void didUpdateWidget(AntCheckboxGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _selected) {
      _selected = List<T>.from(widget.value!);
    }
  }

  void _handleToggle(T val) {
    final next = List<T>.from(_selected);
    if (next.contains(val)) {
      next.remove(val);
    } else {
      next.add(val);
    }
    setState(() => _selected = next);
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final currentValues = widget.value != null
        ? Set<dynamic>.from(widget.value!)
        : Set<dynamic>.from(_selected);

    return _GroupData(
      values: currentValues,
      disabled: widget.disabled,
      onToggle: (val) => _handleToggle(val as T),
      child: widget.children != null
          ? _buildFromChildren(t)
          : _buildFromOptions(t, currentValues),
    );
  }

  /// 从 options 构建
  Widget _buildFromOptions(AntThemeData t, Set<dynamic> values) {
    final items = widget.options.map((opt) {
      final isChecked = values.contains(opt.value);
      final isDisabled = widget.disabled || opt.disabled;
      return _GroupCheckboxItem<T>(
        value: opt.value,
        checked: isChecked,
        disabled: isDisabled,
        child: opt.label,
      );
    }).toList();

    if (widget.direction == AntCheckboxGroupDirection.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(height: 8.w),
            items[i],
          ],
        ],
      );
    }
    return Wrap(
      spacing: 12.w,
      runSpacing: 8.w,
      children: items,
    );
  }

  /// 从 children 构建（子项需为 [AntCheckbox]，通过 InheritedWidget 联动）
  Widget _buildFromChildren(AntThemeData t) {
    if (widget.direction == AntCheckboxGroupDirection.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.children!.length; i++) ...[
            if (i > 0) SizedBox(height: 8.w),
            widget.children![i],
          ],
        ],
      );
    }
    return Wrap(
      spacing: 12.w,
      runSpacing: 8.w,
      children: widget.children!,
    );
  }
}

// ============================================================
// 内部：组内复选项
// ============================================================

class _GroupCheckboxItem<T> extends StatelessWidget {
  const _GroupCheckboxItem({
    required this.value,
    required this.checked,
    required this.disabled,
    required this.child,
  });

  final T value;
  final bool checked;
  final bool disabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final textColor = disabled ? t.colorTextDisabled : t.colorText;

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              final group = _GroupData.of(context);
              group?.onToggle(value);
            },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CheckboxBox(
            checked: checked,
            indeterminate: false,
            disabled: disabled,
            size: 16,
            theme: t,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(fontSize: t.fontSize.sp, color: textColor),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}