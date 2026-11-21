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

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions_types.dart';

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

class _AntMentionsState extends State<AntMentions>
    with PopupContentRefresher<AntMentions> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用；
  /// 镂空遮挡不遮触发输入框，弹层打开时可继续输入）。
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前主题（组件 context 下捕获，overlay builder 经字段重读）。
  AntThemeData _themeData = AntThemeData.light();

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
    _controller =
        TextEditingController(text: widget.defaultValue ?? widget.value ?? '');
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

  /// 键盘上下选择 + Enter 确认（弹层打开时生效，同 AutoComplete 模式）。
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_open) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final options =
        _filteredOptions.where((o) => !o.disabled).toList(growable: false);
    if (options.isEmpty) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _highlightedIndex =
            ((_highlightedIndex ?? -1) + 1).clamp(0, options.length - 1);
      });
      refreshPopupContent();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _highlightedIndex = ((_highlightedIndex ?? options.length) - 1)
            .clamp(0, options.length - 1);
      });
      refreshPopupContent();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final idx = _highlightedIndex;
      if (idx != null && idx >= 0 && idx < options.length) {
        _onSelectOption(options[idx]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// 当前键盘高亮索引（对应 [_filteredOptions] 中可选项的下标）。
  int? _highlightedIndex;

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
    final searchText =
        beforeCursor.substring(prefixIndex + widget.prefix.length);
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

  /// 弹层：承载层换为统一弹层基座 [AntPopupOverlay]（方向决策/边界翻转/
  /// 滑动夹回/镂空遮挡/fade+scale 动画）。
  void _showOverlay() {
    if (_open) {
      _updateOverlay();
      return;
    }
    _themeData = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _MentionsOverlay(
        triggerKey: _triggerKey,
        themeData: _themeData,
        options: _filteredOptions,
        onSelect: _onSelectOption,
        onDismiss: _removeOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  /// 联想内容变化：原地重建面板（PopupContentRefresher 统一沉淀方式）。
  void _updateOverlay() {
    if (_overlayEntry != null) {
      refreshPopupContent();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    _prefixIndex = -1;
    _searchText = '';
    _highlightedIndex = null;
    if (_open && mounted) setState(() => _open = false);
  }

  void _onSelectOption(AntMentionsOption option) {
    if (option.disabled) return;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    // 替换 '@searchText' 为 '@option.value '
    final newText =
        '${text.substring(0, _prefixIndex)}${widget.prefix}${option.value} ${text.substring(cursorPos.clamp(0, text.length))}';

    _controller.text = newText;
    final newCursorPos =
        _prefixIndex + widget.prefix.length + option.value.length + 1;
    _controller.selection = TextSelection.collapsed(offset: newCursorPos);

    widget.onChange?.call(newText);
    widget.onSelect?.call(option);
    _removeOverlay();
    _focusNode.requestFocus();
    _highlightedIndex = null;
  }

  void _clear() {
    _controller.clear();
    widget.onChange?.call('');
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize =
        widget.size == AntMentionsSize.small ? t.fontSizeSM : t.fontSize;
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;
    final maxHeight = _height * widget.maxRows;

    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Container(
        key: _triggerKey,
        constraints: BoxConstraints(
          minHeight: _height.h,
          maxHeight: maxHeight.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: (widget.size == AntMentionsSize.small ? 7 : 12).w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color:
              widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
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
                  // 单一外层描边语义（antd web Mentions）：输入框自身无边框，
                  // enabled/focused/disabled 边框显式置 none——Material 主题的
                  // InputDecorationTheme.enabledBorder 优先级高于 border，
                  // 不显式覆盖会内层再画一圈描边形成双层边框。
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // 填充/悬停/焦点局部填充显式置透明：Material 桥接主题
                  // filled:true + fillColor: colorBgContainer（白）会盖掉
                  // 外层容器的禁用灰底（colorBgContainerDisabled 由外层
                  // 容器按 enabled/disabled 切换），hoverColor/focusColor
                  // 防主题渗入产生局部填充高亮。
                  filled: true,
                  fillColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
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
                  child: Icon(AntIcons.closeCircleFilled,
                      size: 14.sp, color: t.colorTextQuaternary,),
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
    required this.triggerKey,
    required this.themeData,
    required this.options,
    required this.onSelect,
    required this.onDismiss,
  });

  /// 触发元素 GlobalKey（弹层基座定位/镂空遮挡）。
  final GlobalKey triggerKey;
  final AntThemeData themeData;
  final List<AntMentionsOption> options;
  final ValueChanged<AntMentionsOption> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = themeData;

    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转上方；
    // 镂空遮挡不遮触发输入框——弹层打开时输入框可继续输入。
    return AntPopupOverlay(
      targetKey: triggerKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(t),
    );
  }

  /// 提及面板：宽度对齐触发元素（不小于 200），高度上限 200。
  Widget _buildPanel(AntThemeData t) {
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth = (triggerBox != null && triggerBox.hasSize)
        ? triggerBox.size.width
        : 0.0;
    final panelWidth = triggerWidth > 200.w ? triggerWidth : 200.w;

    return Container(
      key: const Key('ant_mentions_panel'),
      width: panelWidth,
      constraints: BoxConstraints(maxHeight: 200.h),
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
