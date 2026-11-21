/// AntSelect — antd React Select 的 Flutter 实现
///
/// API 与 antd React Select 对齐：
/// - [mode] — 单选 / 多选
/// - [value] / [defaultValue] — 受控/非受控值
/// - [options] — 选项列表
/// - [onChange] — 选中变化回调
/// - [showSearch] — 是否可搜索
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [loading] / [size]
///
/// ```dart
/// AntSelect<String>(
///   options: [
///     AntSelectOption(value: 'a', label: '选项一'),
///     AntSelectOption(value: 'b', label: '选项二'),
///   ],
///   defaultValue: 'a',
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'dart:math' as math;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import '../../feedback/loading/ant_loading.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/select/ant_select_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/select/ant_select_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntSelect
// ============================================================

/// 选择器 — 下拉选择器，支持单选、多选与搜索。
///
/// 对齐 antd React Select 组件。
class AntSelect<T> extends StatefulWidget {
  const AntSelect({
    super.key,
    this.mode = AntSelectMode.single,
    this.value,
    this.defaultValue,
    this.options = const [],
    this.onChange,
    this.showSearch = false,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.loading = false,
    this.size = AntSelectSize.middle,
    this.autofocus = false,
  });

  /// 选择模式。
  final AntSelectMode mode;

  /// 受控选中值（单选为 `T?`，多选为 `List<T>?`）。
  final Object? value;

  /// 非受控初始值。
  final Object? defaultValue;

  /// 选项列表。
  final List<AntSelectOption<T>> options;

  /// 选中变化回调。
  final ValueChanged<Object?>? onChange;

  /// 是否可搜索。
  final bool showSearch;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 是否加载中。
  final bool loading;

  /// 尺寸。
  final AntSelectSize size;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntSelect<T>> createState() => _AntSelectState<T>();
}

class _AntSelectState<T> extends State<AntSelect<T>>
    with PopupContentRefresher<AntSelect<T>> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用）。
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  Object? _internalValue;
  String _searchText = '';

  bool get _isMultiple => widget.mode == AntSelectMode.multiple;

  bool get _currentOpen => _internalOpen;

  Object? get _currentValue {
    if (widget.value != null) return widget.value;
    return _internalValue;
  }

  @override
  void initState() {
    super.initState();
    _internalValue = _isMultiple
        ? (widget.defaultValue is List
            ? List<T>.from(widget.defaultValue as List)
            : <T>[])
        : widget.defaultValue;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted) return;
    setState(() {
      _internalOpen = value;
      if (!value) _searchText = '';
    });
    if (value) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    if (!mounted) return;
    final theme = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _SelectOverlay<T>(
        fieldKey: _fieldKey,
        options: widget.options,
        isMultiple: _isMultiple,
        selectedValue: _currentValue,
        searchText: _searchText,
        showSearch: widget.showSearch,
        loading: widget.loading,
        themeData: theme,
        onSearch: (text) {
          if (!mounted) return;
          setState(() => _searchText = text);
          // 搜索输入在事件期触发（非 build 期），原地重建可即时生效；
          // 不走 PopupContentRefresher 的帧末延迟——会慢一帧丢输入反馈。
          _overlayEntry?.markNeedsBuild();
        },
        onSelect: _handleSelect,
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    // 登记到 PopupContentRefresher：多选勾选等面板内容变化时经
    // refreshPopupContent 原地重建（builder 闭包重读 State 最新值）；
    // 不登记则 markNeedsBuild 永不触发，面板选中态停留旧值。
    popupContentEntry = _overlayEntry;
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
  }

  void _handleSelect(T optionValue, bool selected) {
    if (_isMultiple) {
      final list = List<T>.from(_currentValue as List? ?? <T>[]);
      if (selected) {
        if (!list.contains(optionValue)) list.add(optionValue);
      } else {
        list.remove(optionValue);
      }
      _internalValue = list;
      widget.onChange?.call(list);
    } else {
      _internalValue = optionValue;
      widget.onChange?.call(optionValue);
      _setOpen(false);
    }
    if (mounted) {
      setState(() {});
      refreshPopupContent();
    }
  }

  void _handleClear() {
    if (_isMultiple) {
      _internalValue = <T>[];
      widget.onChange?.call(<T>[]);
    } else {
      _internalValue = null;
      widget.onChange?.call(null);
    }
    if (mounted) setState(() {});
  }

  double get _controlHeight {
    switch (widget.size) {
      case AntSelectSize.large:
        return 40;
      case AntSelectSize.middle:
        return 32;
      case AntSelectSize.small:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final height = _controlHeight.w;
    final open = _currentOpen;

    final selectedLabels = <Widget>[];
    if (_isMultiple) {
      final list = _currentValue as List? ?? <T>[];
      for (final v in list) {
        final opt = widget.options.firstWhere(
          (o) => o.value == v,
          orElse: () => AntSelectOption<T>(value: v, label: '$v'),
        );
        selectedLabels.add(
          _Tag(
            label: opt.label,
            theme: theme,
            disabled: widget.disabled,
            onClear: widget.allowClear && !widget.disabled
                ? () => _handleSelect(v, false)
                : null,
          ),
        );
      }
    } else {
      final v = _currentValue as T?;
      if (v != null) {
        final opt = widget.options.firstWhere(
          (o) => o.value == v,
          orElse: () => AntSelectOption<T>(value: v, label: '$v'),
        );
        selectedLabels.add(
          Flexible(
            child: Text(
              opt.label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.fontSize.sp,
                color: theme.colorText,
              ),
            ),
          ),
        );
      }
    }

    final hasValue = _isMultiple
        ? (_currentValue as List?)?.isNotEmpty ?? false
        : _currentValue != null;

    final showClear = widget.allowClear && hasValue && !widget.disabled;

    Widget content = Container(
      key: _fieldKey,
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsets.symmetric(
        horizontal: theme.marginSM.w,
        vertical: _isMultiple && selectedLabels.length > 1 ? 4.w : 0,
      ),
      decoration: BoxDecoration(
        color: widget.disabled
            ? theme.colorBgContainerDisabled
            : theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.w),
        border: Border.all(
          color: open && !widget.disabled
              ? theme.controlOutline
              : theme.colorBorder,
          width: open && !widget.disabled ? theme.controlOutlineWidth.w : 1.w,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: selectedLabels.isEmpty
                ? Text(
                    widget.placeholder ?? '请选择',
                    style: TextStyle(
                      fontSize: theme.fontSize.sp,
                      color: theme.colorTextPlaceholder,
                    ),
                  )
                : _isMultiple
                    ? Wrap(
                        spacing: 4.w,
                        runSpacing: 4.w,
                        children: selectedLabels,
                      )
                    : Row(children: selectedLabels),
          ),
          if (showClear) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleClear,
              child: Icon(
                AntIcons.closeCircleFilled,
                size: 14.w,
                color: theme.colorTextPlaceholder,
              ),
            ),
          ] else if (widget.loading)
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: AntLoading(
                size: 14.w,
                color: theme.colorPrimary,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  AntIcons.downOutlined,
                  size: 14.w,
                  color: widget.disabled
                      ? theme.colorTextDisabled
                      : theme.colorTextSecondary,
                ),
              ),
            ),
        ],
      ),
    );

    return GestureDetector(
      onTap: widget.disabled ? null : () => _setOpen(!open),
      child: content,
    );
  }
}

// ============================================================
// _Tag — 多选标签
// ============================================================

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.theme,
    required this.disabled,
    this.onClear,
  });

  final String label;
  final AntThemeData theme;
  final bool disabled;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: theme.colorFillSecondary,
        borderRadius: BorderRadius.circular(theme.borderRadiusSM.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: theme.fontSizeSM.sp,
              color: disabled ? theme.colorTextDisabled : theme.colorText,
            ),
          ),
          if (onClear != null) ...[
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                AntIcons.closeOutlined,
                size: 10.w,
                color: theme.colorTextTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// _SelectOverlay — 下拉浮层
// ============================================================

class _SelectOverlay<T> extends StatelessWidget {
  const _SelectOverlay({
    required this.fieldKey,
    required this.options,
    required this.isMultiple,
    required this.selectedValue,
    required this.searchText,
    required this.showSearch,
    required this.loading,
    required this.themeData,
    required this.onSearch,
    required this.onSelect,
    required this.onDismiss,
  });

  /// 触发元素 GlobalKey（弹层基座定位/镂空遮挡）。
  final GlobalKey fieldKey;
  final List<AntSelectOption<T>> options;
  final bool isMultiple;
  final Object? selectedValue;
  final String searchText;
  final bool showSearch;
  final bool loading;
  final AntThemeData themeData;
  final ValueChanged<String> onSearch;
  final void Function(T value, bool selected) onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = themeData;
    final mediaSize = MediaQuery.sizeOf(context);

    final filtered = searchText.isEmpty
        ? options
        : options
            .where(
              (o) => o.label.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList();

    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转到上方；
    // 方向决策/滑动夹回/镂空遮挡/fade+scale 动画由基座承担（antd Select 无箭头）。
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(context, theme, mediaSize, filtered),
    );
  }

  /// 下拉面板：宽度对齐触发元素（不小于 120，基座 Stack 为宽松约束需定宽），
  /// 高度上限 min(256, 视口一半)，超出面板内滚动。
  Widget _buildPanel(
    BuildContext context,
    AntThemeData theme,
    Size mediaSize,
    List<AntSelectOption<T>> filtered,
  ) {
    final fieldBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth =
        (fieldBox != null && fieldBox.hasSize) ? fieldBox.size.width : 0.0;
    return Container(
      key: const Key('ant_select_panel'),
      width: math.max(fieldWidth, 120),
      constraints: BoxConstraints(
        maxHeight: math.min(256, mediaSize.height * 0.5),
      ),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.w),
        border: Border.all(color: theme.colorSplit),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSearch)
            Padding(
              padding: EdgeInsets.all(8.w),
              child: TextField(
                autofocus: true,
                style: TextStyle(
                  fontSize: theme.fontSize.sp,
                  color: theme.colorText,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 6.w,
                  ),
                  hintText: '搜索',
                  hintStyle: TextStyle(
                    fontSize: theme.fontSizeSM.sp,
                    color: theme.colorTextPlaceholder,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius.w),
                    borderSide: BorderSide(color: theme.colorBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius.w),
                    borderSide: BorderSide(
                      color: theme.colorPrimary,
                      width: 1.5.w,
                    ),
                  ),
                ),
                onChanged: onSearch,
              ),
            ),
          if (loading)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: AntLoading(
                size: 20.w,
                color: theme.colorPrimary,
              ),
            )
          else if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                '暂无数据',
                style: TextStyle(
                  fontSize: theme.fontSize.sp,
                  color: theme.colorTextDisabled,
                ),
              ),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 4.w),
                children: filtered.map((option) {
                  final selected = _isSelected(option.value);
                  return _OptionItem<T>(
                    option: option,
                    selected: selected,
                    isMultiple: isMultiple,
                    theme: theme,
                    onTap: option.disabled
                        ? null
                        : () => onSelect(option.value, !selected),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  bool _isSelected(T value) {
    if (isMultiple) {
      return (selectedValue as List?)?.contains(value) ?? false;
    }
    return selectedValue == value;
  }
}

// ============================================================
// _OptionItem — 选项行
// ============================================================

class _OptionItem<T> extends StatelessWidget {
  const _OptionItem({
    required this.option,
    required this.selected,
    required this.isMultiple,
    required this.theme,
    required this.onTap,
  });

  final AntSelectOption<T> option;
  final bool selected;
  final bool isMultiple;
  final AntThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final textColor = option.disabled
        ? t.colorTextDisabled
        : selected
            ? t.colorPrimary
            : t.colorText;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
        child: Row(
          children: [
            if (isMultiple)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  selected ? AntIcons.checkSquareFilled : AntIcons.borderOutlined,
                  size: 16.w,
                  color: selected && !option.disabled
                      ? t.colorPrimary
                      : t.colorBorder,
                ),
              ),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: t.fontSize.sp,
                  color: textColor,
                ),
              ),
            ),
            if (!isMultiple && selected)
              Icon(
                AntIcons.checkOutlined,
                size: 14.w,
                color: t.colorPrimary,
              ),
          ],
        ),
      ),
    );
  }
}
