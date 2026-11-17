/// AntTypography — Ant Design v6 Typography 的 Flutter 实现
///
/// API 与 antd React 版对齐：
/// - [AntTitle] — 标题（level 1~5）
/// - [AntParagraph] — 段落
/// - [AntText] — 文本
/// - [AntLink] — 链接
///
/// 通用能力：type / disabled / copyable / editable / ellipsis /
/// code / mark / underline / delete / strong / keyboard / italic。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../tooltip/ant_tooltip.dart';
import '../tooltip/ant_tooltip_types.dart';

import 'ant_typography_types.dart';

// ============================================================
// AntTypography — 基础组件
// ============================================================

/// Ant Design Typography 基础组件。
///
/// 所有排版组件（[AntTitle] / [AntParagraph] / [AntText] / [AntLink]）
/// 共享此基类的通用能力。
class AntTypography extends StatefulWidget {
  const AntTypography({
    super.key,
    this.text,
    this.child,
    this.type,
    this.disabled = false,
    this.copyable = false,
    this.copyConfig,
    this.editable = false,
    this.editConfig,
    this.ellipsis,
    this.code = false,
    this.mark = false,
    this.underline = false,
    this.delete = false,
    this.strong = false,
    this.keyboard = false,
    this.italic = false,
    this.style,
    this.onTap,
    this.selectable = false,
  });

  /// 纯文本内容（用于渲染及 copyable/editable 取文本源）。
  final String? text;

  /// 自定义内容 Widget（显示时优先于 [text]）。
  final Widget? child;

  /// 文本语义类型。
  final AntTypographyType? type;

  /// 禁用状态。
  final bool disabled;

  /// 是否可复制（true 时使用默认配置）。
  final bool copyable;

  /// 可复制详细配置。
  final AntCopyConfig? copyConfig;

  /// 是否可编辑（true 时使用默认配置）。
  final bool editable;

  /// 可编辑详细配置。
  final AntEditConfig? editConfig;

  /// 省略配置。
  final AntEllipsisConfig? ellipsis;

  /// 代码样式（等宽字体 + 灰底 + 边框）。
  final bool code;

  /// 高亮标记（黄色背景）。
  final bool mark;

  /// 下划线。
  final bool underline;

  /// 删除线。
  final bool delete;

  /// 加粗（fontWeightStrong）。
  final bool strong;

  /// 键盘按键样式（等宽字体 + 小号 + 灰底）。
  final bool keyboard;

  /// 斜体。
  final bool italic;

  /// 自定义 TextStyle（叠加在解析样式之上）。
  final TextStyle? style;

  /// 点击回调。
  final VoidCallback? onTap;

  /// 文本是否可选择。
  final bool selectable;

  @override
  State<AntTypography> createState() => _AntTypographyState();
}

class _AntTypographyState extends State<AntTypography> {
  bool _copied = false;
  bool _editing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.editConfig?.text ?? widget.text ?? '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _expanded = widget.ellipsis?.expanded ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _commitEdit();
    }
  }

  /// 解析文本源（用于复制/编辑）。
  String get _plainText =>
      widget.editConfig?.text ?? widget.text ?? _extractText(widget.child) ?? '';

  /// 尝试从 child Widget 提取纯文本。
  static String? _extractText(Widget? widget) {
    if (widget == null) return null;
    if (widget is Text) return widget.data ?? widget.textSpan?.toPlainText();
    if (widget is RichText) return widget.text.toPlainText();
    return null;
  }

  /// 子类可覆盖的额外样式（如标题的字号/行高/字重）。
  TextStyle? headingStyle(AntThemeData theme) => null;

  /// 子类可覆盖：标题颜色使用 colorTextHeading。
  Color headingColor(AntThemeData theme, Color resolved) => resolved;

  // ---- 颜色解析 ----

  Color _resolveColor(AntThemeData theme) {
    if (widget.disabled) return theme.colorTextDisabled;
    switch (widget.type) {
      case AntTypographyType.secondary:
        return theme.colorTextSecondary;
      case AntTypographyType.success:
        return theme.colorSuccessText;
      case AntTypographyType.warning:
        return theme.colorWarningText;
      case AntTypographyType.danger:
        return theme.colorErrorText;
      default:
        return theme.colorText;
    }
  }

  // ---- 复制 ----

  Future<void> _handleCopy() async {
    final config = widget.copyConfig;
    final textToCopy = config?.text ?? _plainText;
    await Clipboard.setData(ClipboardData(text: textToCopy));
    config?.onCopy?.call();
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  // ---- 编辑 ----

  void _startEdit() {
    widget.editConfig?.onStart?.call();
    _controller.text = widget.editConfig?.text ?? _plainText;
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _commitEdit() {
    widget.editConfig?.onChange?.call(_controller.text);
    setState(() => _editing = false);
  }

  void _cancelEdit() {
    widget.editConfig?.onCancel?.call();
    setState(() => _editing = false);
  }

  // ---- 展开/收起 ----

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    widget.ellipsis?.onExpand?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final color = headingColor(theme, _resolveColor(theme));
    final ellipsis = widget.ellipsis;
    final hasEllipsis = ellipsis != null && ellipsis.rows > 0;

    // ---- 编辑态 ----
    if (_editing) {
      return _buildEditor(theme, color);
    }

    // ---- 构建 TextStyle ----
    final baseStyle = _buildBaseStyle(theme, color);

    // ---- 展开/收起按钮 ----
    // 先于 content 构建：expandable 且文本源场景下，图标经 WidgetSpan
    // 与截断文字同处一个 inline Text.rich，避免单独成行。
    final expandWidget = _buildExpandWidget(theme, baseStyle, hasEllipsis, ellipsis);
    final expandInline =
        expandWidget != null && widget.child == null && !widget.selectable;

    // ---- 构建内容 ----
    Widget content;
    if (widget.child != null) {
      content = DefaultTextStyle.merge(
        style: baseStyle,
        child: widget.child!,
      );
    } else if (widget.selectable) {
      content = SelectableText(
        widget.text ?? '',
        style: baseStyle,
        maxLines: hasEllipsis && !_expanded ? ellipsis.rows : null,
      );
    } else if (expandInline) {
      content = Text.rich(
        TextSpan(
          text: widget.text ?? '',
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: expandWidget,
            ),
          ],
        ),
        style: baseStyle,
        maxLines: hasEllipsis && !_expanded ? ellipsis.rows : null,
        overflow: hasEllipsis && !_expanded ? TextOverflow.ellipsis : null,
      );
    } else {
      content = Text(
        widget.text ?? '',
        style: baseStyle,
        maxLines: hasEllipsis && !_expanded ? ellipsis.rows : null,
        overflow: hasEllipsis && !_expanded ? TextOverflow.ellipsis : null,
      );
    }

    // ---- code / keyboard / mark 视觉容器 ----
    content = _wrapVisualDecorations(content, theme);

    // ---- ellipsis tooltip（antd 自举：包内 AntTooltip，桌面 hover / 移动点击）----
    if (hasEllipsis && ellipsis.tooltip && !_expanded) {
      content = AntTooltip(
        tooltip: Text(widget.text ?? _plainText),
        child: content,
      );
    }

    // ---- suffix ----
    if (hasEllipsis && ellipsis.suffix != null) {
      content = Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          content,
          Text(ellipsis.suffix!, style: baseStyle),
        ],
      );
    }

    // ---- 复制/编辑图标 ----
    final actions = _buildActions(theme, color);

    // ---- 组装行 ----
    // expandWidget 为 null 时（expandInline）已并入 Text.rich 的 WidgetSpan。
    final List<Widget> rowChildren = [];
    rowChildren.add(content);
    if (!expandInline && expandWidget != null) rowChildren.add(expandWidget);
    if (actions.isNotEmpty) {
      rowChildren.add(const SizedBox(width: 4));
      rowChildren.addAll(actions);
    }

    if (rowChildren.length == 1) {
      return _wrapInteractive(rowChildren.first, theme);
    }

    return _wrapInteractive(
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: rowChildren,
      ),
      theme,
    );
  }

  /// code / keyboard / mark 的视觉装饰容器。
  Widget _wrapVisualDecorations(Widget content, AntThemeData theme) {
    if (widget.code || widget.keyboard) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.paddingXXS + 1,
          vertical: theme.paddingXXS,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: theme.colorFillTertiary,
          borderRadius: BorderRadius.circular(theme.borderRadiusSM),
          border: Border.all(
            color: theme.colorBorderSecondary,
            width: theme.lineWidth,
          ),
        ),
        child: content,
      );
    }
    if (widget.mark) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: theme.colorWarningBg,
          borderRadius: BorderRadius.circular(theme.borderRadiusXS),
        ),
        child: content,
      );
    }
    return content;
  }

  /// 包装点击交互。
  Widget _wrapInteractive(Widget child, AntThemeData theme) {
    if (widget.onTap == null || widget.disabled) return child;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }

  /// 构建基础 TextStyle（含装饰）。
  TextStyle _buildBaseStyle(AntThemeData theme, Color color) {
    var style = TextStyle(
      color: color,
      fontSize: theme.fontSize,
      height: theme.lineHeight,
      fontFamily: theme.fontFamily,
    );

    // 子类注入的标题样式（字号/行高/字重）— heading 优先级高于基础
    final heading = headingStyle(theme);
    if (heading != null) {
      style = style.merge(heading);
    }

    // strong
    if (widget.strong) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    // italic
    if (widget.italic) {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }

    // underline
    if (widget.underline) {
      style = style.copyWith(
        decoration: TextDecoration.combine([
          style.decoration ?? TextDecoration.none,
          TextDecoration.underline,
        ]),
      );
    }

    // delete (line-through)
    if (widget.delete) {
      style = style.copyWith(
        decoration: TextDecoration.combine([
          style.decoration ?? TextDecoration.none,
          TextDecoration.lineThrough,
        ]),
      );
    }

    // code / keyboard — 等宽字体
    if (widget.code || widget.keyboard) {
      style = style.copyWith(
        fontFamily: theme.fontFamilyCode,
        fontSize: widget.keyboard ? style.fontSize! * 0.85 : style.fontSize,
      );
    }

    // 用户自定义叠加 — 用户样式优先级最高
    if (widget.style != null) {
      style = style.merge(widget.style!);
    }

    return style;
  }

  /// 构建编辑器。
  ///
  /// 对齐约定：输入框以 minHeight=controlHeight 约束撑起行高，
  /// 图标经 Row 的 crossAxisAlignment.center 与编辑框垂直居中对齐。
  Widget _buildEditor(AntThemeData theme, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              color: color,
              fontSize: theme.fontSize,
              height: 1.0,
              fontFamily: theme.fontFamily,
            ),
            decoration: InputDecoration(
              isDense: true,
              constraints: BoxConstraints(minHeight: theme.controlHeight),
              contentPadding: EdgeInsets.symmetric(
                horizontal: theme.paddingXS,
                vertical: (theme.controlHeight - theme.fontSize) / 2,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                borderSide: BorderSide(color: theme.colorPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                borderSide: BorderSide(
                  color: theme.colorPrimary,
                  width: theme.lineWidth,
                ),
              ),
            ),
            onSubmitted: (_) => _commitEdit(),
          ),
        ),
        const SizedBox(width: 4),
        _ActionIcon(
          icon: const Icon(AntIcons.checkOutlined, size: 14),
          onTap: _commitEdit,
          color: theme.colorSuccess,
          tooltip: '确认',
        ),
        const SizedBox(width: 2),
        _ActionIcon(
          icon: const Icon(AntIcons.closeOutlined, size: 14),
          onTap: _cancelEdit,
          color: theme.colorError,
          tooltip: '取消',
        ),
      ],
    );
  }

  /// 构建展开/收起按钮。
  Widget? _buildExpandWidget(
    AntThemeData theme,
    TextStyle baseStyle,
    bool hasEllipsis,
    AntEllipsisConfig? ellipsis,
  ) {
    if (!hasEllipsis || ellipsis == null || !ellipsis.expandable) return null;

    final linkStyle = baseStyle.copyWith(color: theme.colorLink);
    final symbol = _expanded
        ? (ellipsis.symbol ?? const Text('收起'))
        : (ellipsis.symbol ?? const Text('展开'));

    return GestureDetector(
      onTap: _toggleExpand,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: DefaultTextStyle.merge(
            style: linkStyle,
            child: symbol,
          ),
        ),
      ),
    );
  }

  /// 构建复制/编辑操作图标。
  List<Widget> _buildActions(AntThemeData theme, Color color) {
    final List<Widget> actions = [];

    // 复制
    if (widget.copyable || widget.copyConfig != null) {
      final config = widget.copyConfig ?? const AntCopyConfig();
      actions.add(_ActionIcon(
        icon: config.icon ??
            Icon(
              _copied ? AntIcons.checkOutlined : AntIcons.copyOutlined,
              size: 14,
            ),
        onTap: _copied ? null : _handleCopy,
        color: _copied ? theme.colorSuccess : theme.colorTextTertiary,
        tooltip: _copied
            ? (config.tooltips?.elementAtOrNull(1) ?? '已复制')
            : (config.tooltips?.elementAtOrNull(0) ?? '复制'),
      ),);
    }

    // 编辑
    if (widget.editable || widget.editConfig != null) {
      actions.add(_ActionIcon(
        icon: const Icon(AntIcons.editOutlined, size: 14),
        onTap: widget.disabled ? null : _startEdit,
        color: widget.disabled ? theme.colorTextDisabled : theme.colorTextTertiary,
        tooltip: '编辑',
      ),);
    }

    return actions;
  }
}

// ============================================================
// 操作图标
// ============================================================

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    this.onTap,
    this.color,
    this.tooltip,
  });

  final Widget icon;
  final VoidCallback? onTap;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget result = IconTheme.merge(
      data: IconThemeData(color: color, size: 14),
      child: icon,
    );

    if (tooltip != null) {
      // hover 触发：桌面悬停提示；移动端不吞点击（图标自身 tap 生效）
      result = AntTooltip(
        trigger: AntTooltipTrigger.hover,
        tooltip: Text(tooltip!),
        child: result,
      );
    }

    if (onTap != null) {
      result = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: result,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: result,
    );
  }
}

// ============================================================
// AntTitle — 标题
// ============================================================

/// Ant Design 标题组件。
///
/// 对应 antd `<Typography.Title level={1..5}>`。
/// 默认 colorTextHeading、fontWeightStrong、下边距 titleMarginBottom。
class AntTitle extends AntTypography {
  const AntTitle(
    String text, {
    super.key,
    this.level = AntTitleLevel.h1,
    super.type,
    super.disabled,
    super.copyable,
    super.copyConfig,
    super.editable,
    super.editConfig,
    super.ellipsis,
    super.code,
    super.mark,
    super.underline,
    super.delete,
    super.keyboard,
    super.italic,
    super.onTap,
    super.selectable,
    super.style,
  })  : _overrideStrong = false,
        super(text: text);

  /// 标题层级（h1 ~ h5）。
  final AntTitleLevel level;

  /// 内部标记：是否允许 strong 覆盖（默认构造强制 strong=true）。
  final bool _overrideStrong;

  @override
  bool get strong => _overrideStrong ? super.strong : true;

  @override
  State<AntTypography> createState() => _AntTitleState();
}

class _AntTitleState extends _AntTypographyState {
  @override
  TextStyle? headingStyle(AntThemeData theme) {
    final level = (widget as AntTitle).level;
    return switch (level) {
      AntTitleLevel.h1 => TextStyle(
          fontSize: theme.fontSizeHeading1,
          height: theme.lineHeightHeading1,
          fontWeight: FontWeight.w600,
        ),
      AntTitleLevel.h2 => TextStyle(
          fontSize: theme.fontSizeHeading2,
          height: theme.lineHeightHeading2,
          fontWeight: FontWeight.w600,
        ),
      AntTitleLevel.h3 => TextStyle(
          fontSize: theme.fontSizeHeading3,
          height: theme.lineHeightHeading3,
          fontWeight: FontWeight.w600,
        ),
      AntTitleLevel.h4 => TextStyle(
          fontSize: theme.fontSizeHeading4,
          height: theme.lineHeightHeading4,
          fontWeight: FontWeight.w600,
        ),
      AntTitleLevel.h5 => TextStyle(
          fontSize: theme.fontSizeHeading5,
          height: theme.lineHeightHeading5,
          fontWeight: FontWeight.w600,
        ),
    };
  }

  @override
  Color headingColor(AntThemeData theme, Color resolved) {
    // 标题默认使用 colorTextHeading（除非有显式 type）
    if (widget.type == null && !widget.disabled) {
      return theme.colorTextHeading;
    }
    return resolved;
  }
}

// ============================================================
// AntParagraph — 段落
// ============================================================

/// Ant Design 段落组件。
///
/// 对应 antd `<Typography.Paragraph>`。
/// 默认字号 fontSize、行高 lineHeight、下边距 marginBlockEnd。
class AntParagraph extends AntTypography {
  const AntParagraph({
    super.key,
    super.text,
    super.child,
    super.type,
    super.disabled,
    super.copyable,
    super.copyConfig,
    super.editable,
    super.editConfig,
    super.ellipsis,
    super.code,
    super.mark,
    super.underline,
    super.delete,
    super.strong,
    super.keyboard,
    super.italic,
    super.style,
    super.onTap,
    super.selectable,
  });

  @override
  State<AntTypography> createState() => _AntParagraphState();
}

class _AntParagraphState extends _AntTypographyState {
  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    // 段落下边距 = marginBlockEnd ≈ 1em
    return Padding(
      padding: EdgeInsets.only(bottom: theme.fontSize * theme.lineHeight),
      child: super.build(context),
    );
  }
}

// ============================================================
// AntText — 文本
// ============================================================

/// Ant Design 文本组件。
///
/// 对应 antd `<Typography.Text>`。
class AntText extends AntTypography {
  const AntText({
    super.key,
    super.text,
    super.child,
    super.type,
    super.disabled,
    super.copyable,
    super.copyConfig,
    super.editable,
    super.editConfig,
    super.ellipsis,
    super.code,
    super.mark,
    super.underline,
    super.delete,
    super.strong,
    super.keyboard,
    super.italic,
    super.style,
    super.onTap,
    super.selectable,
  });
}

// ============================================================
// AntLink — 链接
// ============================================================

/// Ant Design 链接组件。
///
/// 对应 antd `<Typography.Link>`。
/// 默认 colorLink、hover colorLinkHover、下划线。
class AntLink extends AntTypography {
  const AntLink({
    super.key,
    super.text,
    super.child,
    this.href,
    super.type,
    super.disabled,
    super.copyable,
    super.copyConfig,
    super.ellipsis,
    super.code,
    super.mark,
    super.delete,
    super.strong,
    super.keyboard,
    super.italic,
    super.style,
    super.onTap,
    super.selectable,
  }) : super(
          editable: false,
          editConfig: null,
          underline: true,
        );

  /// 链接地址（语义标注，Flutter 侧由 [onTap] 处理跳转）。
  final String? href;

  @override
  State<AntTypography> createState() => _AntLinkState();
}

class _AntLinkState extends _AntTypographyState {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // 链接 hover 效果
    return MouseRegion(
      onEnter: widget.disabled ? null : (_) => setState(() => _hovered = true),
      onExit: widget.disabled ? null : (_) => setState(() => _hovered = false),
      cursor:
          widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: super.build(context),
    );
  }

  @override
  Color _resolveColor(AntThemeData theme) {
    if (widget.disabled) return theme.colorTextDisabled;
    switch (widget.type) {
      case AntTypographyType.secondary:
        return theme.colorTextSecondary;
      case AntTypographyType.success:
        return theme.colorSuccessText;
      case AntTypographyType.warning:
        return theme.colorWarningText;
      case AntTypographyType.danger:
        return theme.colorErrorText;
      default:
        return _hovered ? theme.colorLinkHover : theme.colorLink;
    }
  }
}