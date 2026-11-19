/// AntRadio — antd Radio 单选框的 Flutter 实现
///
/// API 与 antd React Radio 对齐：
/// - [AntRadio] — 基础单选框（checked/disabled/onChange）
/// - [AntRadioGroup] — 单选框组（options/value/onChange/optionType/buttonStyle）
/// - [AntRadioButton] — 按钮风格单选
///
/// ```dart
/// AntRadioGroup<String>(
///   options: [
///     AntRadioOption(value: 'a', label: Text('A')),
///     AntRadioOption(value: 'b', label: Text('B')),
///   ],
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/radio/ant_radio_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/radio/ant_radio_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// 内部：单选圆圈绘制
// ============================================================

class _RadioDot extends StatelessWidget {
  const _RadioDot({
    required this.checked,
    required this.disabled,
    required this.size,
    required this.theme,
  });

  final bool checked;
  final bool disabled;
  final double size;
  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final borderColor = disabled
        ? t.colorBorder
        : checked
            ? t.colorPrimary
            : t.colorBorder;
    final bgColor = disabled ? t.colorBgContainerDisabled : t.colorBgContainer;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.w),
      ),
      alignment: Alignment.center,
      child: checked
          ? Container(
              width: size.w * 0.5,
              height: size.w * 0.5,
              decoration: BoxDecoration(
                color: disabled ? t.colorTextDisabled : t.colorPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

// ============================================================
// AntRadio
// ============================================================

/// 单选框 — 在一组备选项中进行单选。
///
/// 对齐 antd React Radio 组件，支持受控/非受控、禁用。
class AntRadio extends StatefulWidget {
  const AntRadio({
    super.key,
    this.checked,
    this.defaultChecked = false,
    this.disabled = false,
    this.onChange,
    required this.child,
    this.value,
    this.autofocus = false,
  });

  /// 受控选中状态。
  final bool? checked;

  /// 非受控初始选中状态。
  final bool defaultChecked;

  /// 是否禁用。
  final bool disabled;

  /// 变化回调。
  final ValueChanged<bool>? onChange;

  /// 标签。
  final Widget child;

  /// 在组内使用时的值。
  final dynamic value;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntRadio> createState() => _AntRadioState();
}

class _AntRadioState extends State<AntRadio> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked ?? widget.defaultChecked;
  }

  @override
  void didUpdateWidget(AntRadio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked != null && widget.checked != _checked) {
      _checked = widget.checked!;
    }
  }

  void _select() {
    if (widget.disabled) return;
    if (widget.checked == null) {
      setState(() => _checked = true);
    }
    widget.onChange?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    final group = _GroupData.of(context);
    final t = AntTheme.of(context);
    final isChecked = group != null && widget.value != null
        ? group.value == widget.value
        : (widget.checked ?? _checked);
    final isDisabled = widget.disabled || (group?.disabled ?? false);

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (group != null && widget.value != null) {
                group.onSelect(widget.value);
              } else {
                _select();
              }
            },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioDot(
            checked: isChecked,
            disabled: isDisabled,
            size: 16,
            theme: t,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: t.fontSize.sp,
                color: isDisabled ? t.colorTextDisabled : t.colorText,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 内部：RadioGroup InheritedWidget
// ============================================================

class _GroupData extends InheritedWidget {
  const _GroupData({
    required this.value,
    required this.disabled,
    required this.onSelect,
    required super.child,
  });

  final dynamic value;
  final bool disabled;
  final ValueChanged<dynamic> onSelect;

  static _GroupData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_GroupData>();
  }

  @override
  bool updateShouldNotify(_GroupData oldWidget) {
    return value != oldWidget.value || disabled != oldWidget.disabled;
  }
}

// ============================================================
// AntRadioButton
// ============================================================

/// 按钮风格单选 — 搭配 [AntRadioGroup] 使用。
///
/// ```dart
/// AntRadioGroup<String>(
///   optionType: AntRadioGroupOptionType.button,
///   children: [
///     AntRadioButton(value: 'a', child: Text('A')),
///     AntRadioButton(value: 'b', child: Text('B')),
///   ],
/// )
/// ```
class AntRadioButton extends StatelessWidget {
  const AntRadioButton({
    super.key,
    required this.value,
    required this.child,
    this.disabled = false,
  });

  /// 值。
  final dynamic value;

  /// 标签。
  final Widget child;

  /// 是否禁用。
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final group = _GroupData.of(context);
    final t = AntTheme.of(context);
    final isChecked = group?.value == value;
    final isDisabled = disabled || (group?.disabled ?? false);

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () => group?.onSelect(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
        decoration: BoxDecoration(
          color: isChecked
              ? (isDisabled ? t.colorBgContainerDisabled : t.colorPrimary)
              : (isDisabled ? t.colorBgContainerDisabled : t.colorBgContainer),
          border: Border.all(
            color: isChecked && !isDisabled
                ? t.colorPrimary
                : t.colorBorder,
            width: 1.w,
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: t.fontSize.sp,
            color: isChecked
                ? (isDisabled ? t.colorTextDisabled : Colors.white)
                : (isDisabled ? t.colorTextDisabled : t.colorText),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// AntRadioGroup
// ============================================================

/// 单选组选项类型
enum AntRadioGroupOptionType {
  /// 默认圆圈风格
  normal,

  /// 按钮风格
  button,
}

/// 单选框组 — 包裹一组 [AntRadio] / [AntRadioButton]，统一管理选中值。
///
/// 对齐 antd React Radio.Group。
class AntRadioGroup<T> extends StatefulWidget {
  const AntRadioGroup({
    super.key,
    this.value,
    this.defaultValue,
    this.options = const [],
    this.disabled = false,
    this.onChange,
    this.optionType = AntRadioGroupOptionType.normal,
    this.buttonStyle = AntRadioButtonStyle.outline,
    this.direction = AntRadioGroupDirection.horizontal,
    this.children,
  });

  /// 受控选中值。
  final T? value;

  /// 非受控初始选中值。
  final T? defaultValue;

  /// 选项列表。
  final List<AntRadioOption<T>> options;

  /// 是否整体禁用。
  final bool disabled;

  /// 变化回调。
  final ValueChanged<T?>? onChange;

  /// 选项风格。
  final AntRadioGroupOptionType optionType;

  /// 按钮风格（仅 optionType 为 button 时生效）。
  final AntRadioButtonStyle buttonStyle;

  /// 排列方向。
  final AntRadioGroupDirection direction;

  /// 直接传入 [AntRadio] / [AntRadioButton] 子组件。
  final List<Widget>? children;

  @override
  State<AntRadioGroup<T>> createState() => _AntRadioGroupState<T>();
}

class _AntRadioGroupState<T> extends State<AntRadioGroup<T>> {
  dynamic _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? widget.defaultValue;
  }

  @override
  void didUpdateWidget(AntRadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _selected) {
      _selected = widget.value;
    }
  }

  void _handleSelect(dynamic val) {
    if (widget.disabled) return;
    if (widget.value == null) {
      setState(() => _selected = val);
    }
    widget.onChange?.call(val as T?);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final current = widget.value ?? _selected;

    return _GroupData(
      value: current,
      disabled: widget.disabled,
      onSelect: _handleSelect,
      child: widget.children != null
          ? _buildFromChildren(t)
          : _buildFromOptions(t, current),
    );
  }

  /// 从 options 构建
  Widget _buildFromOptions(AntThemeData t, dynamic current) {
    final items = widget.options.map((opt) {
      final isDisabled = widget.disabled || opt.disabled;
      if (widget.optionType == AntRadioGroupOptionType.button) {
        return _GroupButtonItem<T>(
          value: opt.value,
          checked: current == opt.value,
          disabled: isDisabled,
          buttonStyle: widget.buttonStyle,
          child: opt.label,
        );
      }
      return _GroupRadioItem<T>(
        value: opt.value,
        checked: current == opt.value,
        disabled: isDisabled,
        child: opt.label,
      );
    }).toList();

    if (widget.optionType == AntRadioGroupOptionType.button) {
      return Wrap(
        spacing: 0,
        runSpacing: 8.w,
        children: items,
      );
    }

    if (widget.direction == AntRadioGroupDirection.vertical) {
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

  /// 从 children 构建
  Widget _buildFromChildren(AntThemeData t) {
    if (widget.direction == AntRadioGroupDirection.vertical) {
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
// 内部：组内单选项（圆圈）
// ============================================================

class _GroupRadioItem<T> extends StatelessWidget {
  const _GroupRadioItem({
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
    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              final group = _GroupData.of(context);
              group?.onSelect(value);
            },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioDot(
            checked: checked,
            disabled: disabled,
            size: 16,
            theme: t,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: t.fontSize.sp,
                color: disabled ? t.colorTextDisabled : t.colorText,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 内部：组内单选项（按钮）
// ============================================================

class _GroupButtonItem<T> extends StatelessWidget {
  const _GroupButtonItem({
    required this.value,
    required this.checked,
    required this.disabled,
    required this.buttonStyle,
    required this.child,
  });

  final T value;
  final bool checked;
  final bool disabled;
  final AntRadioButtonStyle buttonStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final isSolid = buttonStyle == AntRadioButtonStyle.solid;

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              final group = _GroupData.of(context);
              group?.onSelect(value);
            },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
        decoration: BoxDecoration(
          color: checked
              ? (isSolid
                  ? (disabled ? t.colorBgContainerDisabled : t.colorPrimary)
                  : (disabled ? t.colorBgContainerDisabled : t.colorPrimary.withValues(alpha: 0.06)))
              : (disabled ? t.colorBgContainerDisabled : t.colorBgContainer),
          border: Border.all(
            color: checked && !disabled ? t.colorPrimary : t.colorBorder,
            width: 1.w,
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: t.fontSize.sp,
            color: checked
                ? (isSolid
                    ? (disabled ? t.colorTextDisabled : Colors.white)
                    : (disabled ? t.colorTextDisabled : t.colorPrimary))
                : (disabled ? t.colorTextDisabled : t.colorText),
          ),
          child: child,
        ),
      ),
    );
  }
}