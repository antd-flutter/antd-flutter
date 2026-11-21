/// AntRadio — antd Radio 单选框的 Flutter 实现
///
/// API 与 antd React Radio 对齐：
/// - [AntRadio] — 基础单选框（checked/disabled/onChange）
/// - [AntRadioGroup] — 单选框组（options/value/onChange/optionType/buttonStyle）
/// - [AntRadioButton] — 按钮风格单选
///
/// ```dart
/// AntRadioGroup<String>(
///   options: const ['A', 'B'],
///   onChange: (v) => print(v),
/// )
///
/// AntRadioGroup<User>(
///   options: users,                       // List<User>
///   labelOf: (user) => user.name,
///   onChange: (user) => print(user),
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
      width: t.s(size),
      height: t.s(size),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: t.s(1)),
      ),
      alignment: Alignment.center,
      child: checked
          ? Container(
              width: t.s(size) * 0.5,
              height: t.s(size) * 0.5,
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
    // 支持点击已选中项取消选中（移动端交互习惯）
    final next = !(widget.checked ?? _checked);
    if (widget.checked == null) {
      setState(() => _checked = next);
    }
    widget.onChange?.call(next);
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
          SizedBox(width: t.s(8)),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: t.fontSize,
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
      onTap: isDisabled ? null : () => group?.onSelect(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(4)),
        decoration: BoxDecoration(
          color: isChecked
              ? (isDisabled ? t.colorBgContainerDisabled : t.colorPrimary)
              : (isDisabled ? t.colorBgContainerDisabled : t.colorBgContainer),
          border: Border.all(
            color: isChecked && !isDisabled ? t.colorPrimary : t.colorBorder,
            width: t.s(1),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: t.fontSize,
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
    this.labelOf,
    this.labelBuilder,
    this.itemBuilder,
    this.disabledOf,
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

  /// 选项列表（任意模型）。
  final List<T> options;

  /// 选项的字符串 label 简写（未提供 [labelBuilder] 时作为文本渲染）。
  final String Function(T item)? labelOf;

  /// 选项 label 的自定义渲染。
  final Widget Function(BuildContext context, T item)? labelBuilder;

  /// 整项自定义渲染（含单选圆圈/按钮外观），优先级最高。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 选项是否禁用。
  final bool Function(T item)? disabledOf;

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
    // 支持点击已选中项取消选中（再次点击置空）
    final next = val == (widget.value ?? _selected) ? null : val;
    if (widget.value == null) {
      setState(() => _selected = next);
    }
    widget.onChange?.call(next as T?);
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

  Widget _buildLabel(BuildContext context, T item, int index) {
    final custom = widget.labelBuilder?.call(context, item);
    if (custom != null) return custom;
    final text = widget.labelOf?.call(item) ?? '$item';
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  /// 从 options 构建
  Widget _buildFromOptions(AntThemeData t, dynamic current) {
    final items = <Widget>[];
    for (var i = 0; i < widget.options.length; i++) {
      final item = widget.options[i];
      final isDisabled =
          widget.disabled || (widget.disabledOf?.call(item) ?? false);
      final label = _buildLabel(context, item, i);
      if (widget.itemBuilder != null) {
        items.add(
          GestureDetector(
            onTap: isDisabled ? null : () => _handleSelect(item),
            behavior: HitTestBehavior.opaque,
            child: widget.itemBuilder!(context, item, i),
          ),
        );
      } else if (widget.optionType == AntRadioGroupOptionType.button) {
        items.add(
          _GroupButtonItem<T>(
            value: item,
            checked: current == item,
            disabled: isDisabled,
            buttonStyle: widget.buttonStyle,
            child: label,
          ),
        );
      } else {
        items.add(
          _GroupRadioItem<T>(
            value: item,
            checked: current == item,
            disabled: isDisabled,
            child: label,
          ),
        );
      }
    }

    if (widget.optionType == AntRadioGroupOptionType.button) {
      return Wrap(
        spacing: 0,
        runSpacing: t.s(8),
        children: items,
      );
    }

    if (widget.direction == AntRadioGroupDirection.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(height: t.s(8)),
            items[i],
          ],
        ],
      );
    }
    return Wrap(
      spacing: t.s(12),
      runSpacing: t.s(8),
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
            if (i > 0) SizedBox(height: t.s(8)),
            widget.children![i],
          ],
        ],
      );
    }
    return Wrap(
      spacing: t.s(12),
      runSpacing: t.s(8),
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
          SizedBox(width: t.s(8)),
          Flexible(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: t.fontSize,
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
        padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(4)),
        decoration: BoxDecoration(
          color: checked
              ? (isSolid
                  ? (disabled ? t.colorBgContainerDisabled : t.colorPrimary)
                  : (disabled
                      ? t.colorBgContainerDisabled
                      : t.colorPrimary.withValues(alpha: 0.06)))
              : (disabled ? t.colorBgContainerDisabled : t.colorBgContainer),
          border: Border.all(
            color: checked && !disabled ? t.colorPrimary : t.colorBorder,
            width: t.s(1),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: t.fontSize,
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
