/// AntSearchBar — antd-mobile SearchBar 搜索栏的 Flutter 实现
///
/// 用于搜索场景的输入框，左侧带搜索图标，支持清除、取消按钮与搜索回调。
///
/// ```dart
/// AntSearchBar(
///   placeholder: '搜索',
///   onSearch: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input_field.dart';
import 'package:antd_flutter_ui/src/data_entry/search_bar/ant_search_bar_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/search_bar/ant_search_bar_types.dart';
import 'package:material_ui/material_ui.dart';

/// 搜索栏 — 移动端搜索场景的输入组件。
class AntSearchBar extends StatefulWidget {
  const AntSearchBar({
    super.key,
    this.value,
    this.defaultValue,
    this.maxLength,
    this.placeholder,
    this.clearable = true,
    this.onlyShowClearWhenFocus = false,
    this.showCancelButton = AntSearchBarCancelMode.never,
    this.cancelText = '取消',
    this.searchIcon,
    this.clearOnCancel = true,
    this.onSearch,
    this.onChange,
    this.onCancel,
    this.onFocus,
    this.onBlur,
    this.onClear,
    this.autoFocus = false,
    this.focusNode,
    this.controller,
    this.height,
  });

  /// 受控值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 最大输入长度。
  final int? maxLength;

  /// 占位提示文本。
  final String? placeholder;

  /// 是否允许清除。
  final bool clearable;

  /// 是否仅在聚焦时显示清除按钮。
  final bool onlyShowClearWhenFocus;

  /// 取消按钮显示策略。
  final AntSearchBarCancelMode showCancelButton;

  /// 取消按钮文本。
  final String cancelText;

  /// 自定义搜索图标。
  final Widget? searchIcon;

  /// 取消时是否清空输入。
  final bool clearOnCancel;

  /// 按下搜索键（回车）回调。
  final ValueChanged<String>? onSearch;

  /// 输入变化回调。
  final ValueChanged<String>? onChange;

  /// 点击取消按钮回调。
  final VoidCallback? onCancel;

  /// 聚焦回调。
  final VoidCallback? onFocus;

  /// 失焦回调。
  final VoidCallback? onBlur;

  /// 点击清除按钮回调。
  final VoidCallback? onClear;

  /// 自动聚焦。
  final bool autoFocus;

  /// 外部传入的焦点节点。
  final FocusNode? focusNode;

  /// 外部传入的文本控制器。
  final TextEditingController? controller;

  /// 自定义高度。
  final double? height;

  @override
  State<AntSearchBar> createState() => _AntSearchBarState();
}

class _AntSearchBarState extends State<AntSearchBar> {
  late TextEditingController _controller;
  bool _ownsController = false;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? widget.defaultValue ?? '');
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  void _onFocusChanged() {
    final focused = _focusNode.hasFocus;
    if (focused != _hasFocus) {
      setState(() => _hasFocus = focused);
      if (focused) {
        widget.onFocus?.call();
      } else {
        widget.onBlur?.call();
      }
    }
  }

  @override
  void didUpdateWidget(covariant AntSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) _controller.dispose();
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
    }
    if (widget.controller != null && widget.value != oldWidget.value) {
      final v = widget.value ?? '';
      if (_controller.text != v) {
        _controller.text = v;
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (_ownsFocusNode) _focusNode.dispose();
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  String get _currentValue => widget.value ?? _controller.text;

  void _handleChange(String v) {
    if (widget.value != null) {
      // 受控模式，只通知
      widget.onChange?.call(v);
    } else {
      widget.onChange?.call(v);
    }
  }

  void _handleClear() {
    _controller.clear();
    _handleChange('');
    widget.onClear?.call();
  }

  void _handleCancel() {
    if (widget.clearOnCancel) {
      _controller.clear();
      _handleChange('');
    }
    _focusNode.unfocus();
    widget.onCancel?.call();
  }

  bool get _showClear {
    if (!widget.clearable) return false;
    if (_currentValue.isEmpty) return false;
    if (widget.onlyShowClearWhenFocus) return _hasFocus;
    return true;
  }

  bool get _showCancel {
    switch (widget.showCancelButton) {
      case AntSearchBarCancelMode.never:
        return false;
      case AntSearchBarCancelMode.focus:
        return _hasFocus;
      case AntSearchBarCancelMode.always:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final h = widget.height ?? t.controlHeightLG;

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: h,
            decoration: BoxDecoration(
              color: t.colorFillSecondary,
              borderRadius: BorderRadius.circular(h / 2),
              border: Border.all(
                color: _hasFocus ? t.colorPrimary : Colors.transparent,
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                widget.searchIcon ??
                    Icon(
                      Icons.search,
                      size: 16.sp,
                      color: t.colorTextTertiary,
                    ),
                SizedBox(width: 8.w),
                Expanded(
                  // 字段核心复用共享基座（embedded：无边框无填充，由胶囊容器统一绘制）
                  child: AntInputField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: widget.maxLength,
                    placeholder: widget.placeholder,
                    mode: AntInputFieldMode.embedded,
                    contentPadding: EdgeInsets.zero,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (v) {
                      _focusNode.unfocus();
                      widget.onSearch?.call(v);
                    },
                    onChanged: _handleChange,
                  ),
                ),
                if (_showClear)
                  GestureDetector(
                    onTap: _handleClear,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Icon(
                        Icons.cancel,
                        size: 16.sp,
                        color: t.colorTextQuaternary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_showCancel) ...[
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _handleCancel,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                widget.cancelText,
                style: TextStyle(
                  fontSize: t.fontSize,
                  color: t.colorText,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}