/// AntMentions — antd React Mentions 的 Flutter 实现
///
/// 在输入中提及某人或某物，输入 [prefix]（默认 '@'）触发选项弹出。
///
/// API 与 antd React Mentions 对齐：
/// - [options] — 提及选项列表
/// - [value] / [defaultValue] — 受控/非受控文本值
/// - [onChange] — 文本变化回调
/// - [onSelect] — 选中提及项回调
/// - [prefix] — 触发字符（默认 '@'）
/// - [placeholder] / [disabled] / [allowClear] / [size]
/// - [maxRows] — 最大行数
///
/// ```dart
/// AntMentions(
///   options: [
///     AntMentionsOption(value: 'afc163', label: 'afc163'),
///     AntMentionsOption(value: 'zombiej', label: 'zombiej'),
///   ],
///   onChange: (text) => print(text),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/mentions/ant_mentions_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

export 'package:antd_flutter_plus/src/components/data_entry/mentions/ant_mentions_types.dart';

// ============================================================
// AntMentions
// ============================================================

/// 提及组件。
///
/// 在文本输入中通过输入 '@' 等前缀触发选项列表。
class AntMentions extends StatefulWidget {
  const AntMentions({
    super.key,
    this.options = const [],
    this.value,
    this.defaultValue,
    this.onChange,
    this.onSelect,
    this.prefix = '@',
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.size = AntMentionsSize.middle,
    this.maxRows = 3,
  });

  /// 提及选项列表
  final List<AntMentionsOption> options;

  /// 受控文本值
  final String? value;

  /// 非受控默认值
  final String? defaultValue;

  /// 文本变化回调
  final ValueChanged<String>? onChange;

  /// 选中提及项回调
  final ValueChanged<AntMentionsOption>? onSelect;

  /// 触发字符
  final String prefix;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 尺寸
  final AntMentionsSize size;

  /// 最大行数
  final int maxRows;

  @override
  State<AntMentions> createState() => _AntMentionsState();
}

class _AntMentionsState extends State<AntMentions> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前匹配到的搜索文本（'@' 后的文本）
  String _searchText = '';

  /// 当前 '@' 在文本中的位置
  int _prefixIndex = -1;

  String get _currentValue => widget.value ?? _controller.text;

  double get _height {
    switch (widget.size) {
      case AntMentionsSize.large:
        return 40;
      case AntMentionsSize.small:
        return 24;
      case AntMentionsSize.middle:
        return 32;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue ?? widget.value ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant AntMentions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      if (_controller.text != widget.value) {
        _controller.text = widget.value!;
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (widget.value == null) {
      // 非受控模式：通知 onChange
      widget.onChange?.call(_controller.text);
    }
    _detectMention();
  }

  /// 检测光标前是否有触发前缀，显示/隐藏选项面板
  void _detectMention() {
    if (widget.disabled || !mounted) return;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    if (cursorPos < 0 || cursorPos > text.length) {
      _removeOverlay();
      return;
    }

    // 从光标位置向前查找最近的触发前缀
    final beforeCursor = text.substring(0, cursorPos);
    final prefixIndex = beforeCursor.lastIndexOf(widget.prefix);

    if (prefixIndex < 0) {
      _removeOverlay();
      return;
    }

    // 确保前缀后没有空格（空格视为提及结束）
    final searchText = beforeCursor.substring(prefixIndex + widget.prefix.length);
    if (searchText.contains(' ') || searchText.contains('\n')) {
      _removeOverlay();
      return;
    }

    _prefixIndex = prefixIndex;
    _searchText = searchText;
    _showOverlay();
  }

  List<AntMentionsOption> get _filteredOptions {
    final search = _searchText.toLowerCase();
    return widget.options.where((opt) {
      if (opt.disabled) return true; // 禁用项仍显示
      return opt.displayLabel.toLowerCase().contains(search);
    }).toList();
  }

  void _showOverlay() {
    if (_open) {
      _updateOverlay();
      return;
    }
    final t = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _MentionsOverlay(
        layerLink: _layerLink,
        themeData: t,
        options: _filteredOptions,
        onSelect: _onSelectOption,
        onDismiss: _removeOverlay,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      final t = AntTheme.of(context);
      _overlayEntry!.remove();
      _overlayEntry = OverlayEntry(
        builder: (context) => _MentionsOverlay(
          layerLink: _layerLink,
          themeData: t,
          options: _filteredOptions,
          onSelect: _onSelectOption,
          onDismiss: _removeOverlay,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _prefixIndex = -1;
    _searchText = '';
    if (_open && mounted) setState(() => _open = false);
  }

  void _onSelectOption(AntMentionsOption option) {
    if (option.disabled) return;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    // 替换 '@searchText' 为 '@option.value '
    final newText = '${text.substring(0, _prefixIndex)}${widget.prefix}${option.value} ${text.substring(cursorPos.clamp(0, text.length))}';

    _controller.text = newText;
    final newCursorPos = _prefixIndex + widget.prefix.length + option.value.length + 1;
    _controller.selection = TextSelection.collapsed(offset: newCursorPos);

    widget.onChange?.call(newText);
    widget.onSelect?.call(option);
    _removeOverlay();
    _focusNode.requestFocus();
  }

  void _clear() {
    _controller.clear();
    widget.onChange?.call('');
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize = widget.size == AntMentionsSize.small ? t.fontSizeSM : t.fontSize;
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;
    final maxHeight = _height * widget.maxRows;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        constraints: BoxConstraints(
          minHeight: _height.h,
          maxHeight: maxHeight.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: (widget.size == AntMentionsSize.small ? 7 : 12).w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          border: Border.all(
            color: _focusNode.hasFocus ? t.colorPrimary : t.colorBorder,
            width: _focusNode.hasFocus ? t.controlOutlineWidth : 1,
          ),
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.disabled,
                maxLines: widget.maxRows,
                minLines: 1,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: widget.disabled ? t.colorTextDisabled : t.colorText,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    fontSize: fontSize.sp,
                    color: t.colorTextPlaceholder,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                ),
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
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _MentionsOverlay — 提及选项浮层
// ============================================================

class _MentionsOverlay extends StatelessWidget {
  const _MentionsOverlay({
    required this.layerLink,
    required this.themeData,
    required this.options,
    required this.onSelect,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final AntThemeData themeData;
  final List<AntMentionsOption> options;
  final ValueChanged<AntMentionsOption> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = themeData;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          child: CompositedTransformFollower(
            link: layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 4.h),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200.h,
                  maxWidth: 200.w,
                ),
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
                child: options.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Text(
                          '无匹配项',
                          style: TextStyle(
                            fontSize: t.fontSizeSM.sp,
                            color: t.colorTextQuaternary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          return _MentionOptionTile(
                            option: option,
                            fontSize: t.fontSize,
                            colorText: t.colorText,
                            colorTextDisabled: t.colorTextDisabled,
                            colorFillSecondary: t.colorFillSecondary,
                            onTap: () => onSelect(option),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _MentionOptionTile — 单个提及选项条目
// ============================================================

class _MentionOptionTile extends StatefulWidget {
  const _MentionOptionTile({
    required this.option,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorFillSecondary,
    required this.onTap,
  });

  final AntMentionsOption option;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorFillSecondary;
  final VoidCallback onTap;

  @override
  State<_MentionOptionTile> createState() => _MentionOptionTileState();
}

class _MentionOptionTileState extends State<_MentionOptionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.option.disabled;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : _isHovered
                  ? widget.colorFillSecondary
                  : null,
          child: Text(
            widget.option.displayLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize.sp,
              color: disabled ? widget.colorTextDisabled : widget.colorText,
            ),
          ),
        ),
      ),
    );
  }
}