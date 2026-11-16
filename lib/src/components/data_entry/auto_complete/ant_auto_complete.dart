/// AntAutoComplete — antd React AutoComplete 的 Flutter 实现
///
/// API 与 antd React AutoComplete 对齐：
/// - [options] — 补全选项列表
/// - [value] / [defaultValue] — 受控/非受控值
/// - [onChange] — 输入值变化回调
/// - [onSelect] — 选中选项回调
/// - [filterOption] — 是否根据输入过滤选项
/// - [allowClear] — 清除按钮
/// - [placeholder] / [disabled] / [size]
///
/// ```dart
/// AntAutoComplete(
///   options: [
///     AntAutoCompleteOption(value: 'apple'),
///     AntAutoCompleteOption(value: 'banana'),
///   ],
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/auto_complete/ant_auto_complete_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

export 'package:antd_flutter_plus/src/components/data_entry/auto_complete/ant_auto_complete_types.dart';

// ============================================================
// AntAutoComplete
// ============================================================

/// 自动补全输入组件。
///
/// 输入时展示匹配的选项下拉，选中后回填输入框。
class AntAutoComplete extends StatefulWidget {
  const AntAutoComplete({
    super.key,
    this.options = const [],
    this.value,
    this.defaultValue,
    this.onChange,
    this.onSelect,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.filterOption = true,
    this.size = AntAutoCompleteSize.middle,
    this.autofocus = false,
  });

  /// 补全选项列表
  final List<AntAutoCompleteOption> options;

  /// 受控值
  final String? value;

  /// 非受控默认值
  final String? defaultValue;

  /// 输入值变化回调
  final ValueChanged<String>? onChange;

  /// 选中选项回调
  final ValueChanged<AntAutoCompleteOption>? onSelect;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 是否根据输入过滤选项
  final bool filterOption;

  /// 尺寸
  final AntAutoCompleteSize size;

  /// 自动聚焦
  final bool autofocus;

  @override
  State<AntAutoComplete> createState() => _AntAutoCompleteState();
}

class _AntAutoCompleteState extends State<AntAutoComplete> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  bool _open = false;
  String? _internalValue;
  int? _highlightedIndex;

  String get _currentValue => widget.value ?? _internalValue ?? '';

  double get _height {
    switch (widget.size) {
      case AntAutoCompleteSize.large:
        return 40;
      case AntAutoCompleteSize.small:
        return 24;
      case AntAutoCompleteSize.middle:
        return 32;
    }
  }

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _controller = TextEditingController(text: _currentValue);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AntAutoComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !widget.disabled) {
      _showOverlay();
    } else if (!_focusNode.hasFocus) {
      // 延迟关闭以允许点击选项
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_focusNode.hasFocus) _removeOverlay();
      });
    }
  }

  List<AntAutoCompleteOption> get _filteredOptions {
    if (!widget.filterOption || _currentValue.isEmpty) {
      return widget.options;
    }
    final query = _currentValue.toLowerCase();
    return widget.options
        .where((o) => o.displayLabel.toLowerCase().contains(query))
        .toList();
  }

  void _showOverlay() {
    if (_open) return;
    _highlightedIndex = null;
    final t = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _AutoCompleteOverlay(
        layerLink: _layerLink,
        themeData: t,
        options: _filteredOptions,
        highlightedIndex: _highlightedIndex,
        onSelect: _selectOption,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      final t = AntTheme.of(context);
      _overlayEntry!.remove();
      _overlayEntry = OverlayEntry(
        builder: (context) => _AutoCompleteOverlay(
          layerLink: _layerLink,
          themeData: t,
          options: _filteredOptions,
          highlightedIndex: _highlightedIndex,
          onSelect: _selectOption,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _selectOption(AntAutoCompleteOption option) {
    if (option.disabled) return;
    setState(() {
      _internalValue = option.value;
      _highlightedIndex = null;
    });
    _controller.text = option.value;
    _controller.selection = TextSelection.collapsed(offset: option.value.length);
    widget.onChange?.call(option.value);
    widget.onSelect?.call(option);
    _removeOverlay();
    _focusNode.unfocus();
  }

  void _onInputChanged(String text) {
    setState(() => _internalValue = text);
    widget.onChange?.call(text);
    if (!_open && _focusNode.hasFocus) {
      _showOverlay();
    } else {
      _highlightedIndex = null;
      _updateOverlay();
    }
  }

  void _clear() {
    setState(() => _internalValue = '');
    _controller.text = '';
    widget.onChange?.call('');
    _updateOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize = widget.size == AntAutoCompleteSize.small ? t.fontSizeSM : t.fontSize;
    final showClear = widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: _height.h,
        decoration: BoxDecoration(
          color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          border: Border.all(
            color: _focusNode.hasFocus ? t.colorPrimary : t.colorBorder,
            width: _focusNode.hasFocus ? t.controlOutlineWidth : 1,
          ),
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: (widget.size == AntAutoCompleteSize.small ? 7 : 12).w),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.disabled,
                style: TextStyle(fontSize: fontSize.sp, color: widget.disabled ? t.colorTextDisabled : t.colorText),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(fontSize: fontSize.sp, color: t.colorTextPlaceholder),
                ),
                onChanged: _onInputChanged,
              ),
            ),
            if (showClear)
              GestureDetector(
                onTap: _clear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(Icons.cancel, size: 14.sp, color: t.colorTextQuaternary),
                ),
              )
            else if (_open)
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(Icons.keyboard_arrow_up, size: 14.sp, color: t.colorTextQuaternary),
              )
            else
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(Icons.search, size: 14.sp, color: t.colorTextQuaternary),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _AutoCompleteOverlay
// ============================================================

class _AutoCompleteOverlay extends StatelessWidget {
  const _AutoCompleteOverlay({
    required this.layerLink,
    required this.themeData,
    required this.options,
    required this.highlightedIndex,
    required this.onSelect,
  });

  final LayerLink layerLink;
  final AntThemeData themeData;
  final List<AntAutoCompleteOption> options;
  final int? highlightedIndex;
  final ValueChanged<AntAutoCompleteOption> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = themeData;
    if (options.isEmpty) {
      return Positioned(
        child: CompositedTransformFollower(
          link: layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: Offset(0, 4.h),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200.w,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: t.colorBgContainer,
                borderRadius: BorderRadius.circular(t.borderRadiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '无匹配项',
                style: TextStyle(fontSize: t.fontSizeSM, color: t.colorTextDisabled),
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      child: CompositedTransformFollower(
        link: layerLink,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: Offset(0, 4.h),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200.w,
            constraints: BoxConstraints(maxHeight: 256.h),
            decoration: BoxDecoration(
              color: t.colorBgContainer,
              borderRadius: BorderRadius.circular(t.borderRadiusLG),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isHighlighted = index == highlightedIndex;
                return InkWell(
                  onTap: option.disabled ? null : () => onSelect(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    color: option.disabled
                        ? t.colorFillSecondary.withValues(alpha: 0.3)
                        : isHighlighted
                            ? t.colorFillSecondary
                            : null,
                    child: Text(
                      option.displayLabel,
                      style: TextStyle(
                        fontSize: t.fontSize,
                        color: option.disabled ? t.colorTextDisabled : t.colorText,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}