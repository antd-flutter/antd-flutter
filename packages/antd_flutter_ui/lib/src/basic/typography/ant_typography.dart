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

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../tooltip/ant_tooltip.dart';
import '../tooltip/ant_tooltip_types.dart';

import 'ant_typography_types.dart';

// ============================================================
// 常量
// ============================================================

/// 动作图标（复制/编辑）与前方内容（文本或上一个动作）的间距。
const double _actionGap = 8;

/// 编辑态右下角回车角标图标尺寸。
const double _editorCornerIconSize = 14;

/// 回车角标与输入框内边缘的安全边距（保证图标完全位于输入框边界之内）。
const double _editorCornerSafeMargin = 8;

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
  ///
  /// 移动端（compact / 移动断点，AntResponsive.deviceTypeOf 判定
  /// deviceType == AntDeviceType.phone）下不生效：渲染纯文本展示，
  /// 无编辑入口；桌面端保持编辑能力。
  final bool editable;

  /// 可编辑详细配置。
  ///
  /// 移动端（compact / 移动断点）下不生效，同 [editable]。
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
  late FocusNode _editorFocusNode; // 编辑态 Esc 捕获
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.editConfig?.text ?? widget.text ?? '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _editorFocusNode = FocusNode();
    _expanded = widget.ellipsis?.expanded ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // 对齐 antd 桌面交互：失焦取消编辑（回车确认）
    if (!_focusNode.hasFocus && _editing) {
      _cancelEdit();
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
    // 移动端（compact 断点，deviceType == phone）关闭编辑态：editable /
    // editConfig 不生效，渲染纯文本展示（无编辑入口、不可进入编辑态）。
    final editDisabled =
        AntResponsive.deviceTypeOf(context) == AntDeviceType.phone;
    if (_editing && !editDisabled) {
      return _buildEditor(theme, color);
    }

    // ---- 构建 TextStyle ----
    final baseStyle = _buildBaseStyle(theme, color);

    // ---- inline 动作节点 ----
    // 全部走 Text.rich（TextSpan 文本 + WidgetSpan 图标），动作天然 inline
    // 跟随文字末尾，不单独成行。
    final expandWidget = _buildExpandWidget(theme, baseStyle, hasEllipsis, ellipsis);
    final copyIcon = _buildCopyAction(theme);
    final editIcon = _buildEditAction(theme);
    final copyBefore = widget.copyConfig?.position == AntCopyIconPosition.before;
    final leadingIcons = <Widget>[
      if (copyIcon != null && copyBefore) copyIcon,
    ];
    // antd 顺序：展开 → 复制 → 编辑
    final trailingIcons = <Widget>[
      if (copyIcon != null && !copyBefore) copyIcon,
      if (editIcon != null) editIcon,
    ];

    List<InlineSpan> buildSpans(String text, {Widget? expand}) => [
          for (final icon in leadingIcons)
            WidgetSpan(alignment: PlaceholderAlignment.middle, child: icon),
          TextSpan(text: text),
          if (expand != null)
            WidgetSpan(alignment: PlaceholderAlignment.middle, child: expand),
          for (final icon in trailingIcons)
            WidgetSpan(alignment: PlaceholderAlignment.middle, child: icon),
        ];

    // ---- 自定义 child / selectable：无法内联 WidgetSpan，退化为 Wrap 组合 ----
    if (widget.child != null || widget.selectable) {
      Widget content = widget.child != null
          ? DefaultTextStyle.merge(style: baseStyle, child: widget.child!)
          : SelectableText(
              widget.text ?? '',
              style: baseStyle,
              maxLines: hasEllipsis && !_expanded ? ellipsis.rows : null,
            );
      content = _wrapVisualDecorations(content, theme);
      final rowChildren = <Widget>[content, ...leadingIcons, ...trailingIcons];
      if (expandWidget != null) rowChildren.insert(1, expandWidget);
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

    // ---- 文本模式主体 ----
    // 溢出测量：只有文字确实被截断才挂展开/收起与 tooltip；
    // 未溢出时纯文本 + 动作图标。窗口尺寸变化由 LayoutBuilder 自动重判。
    final needsOverflowMeasure = hasEllipsis &&
        !_expanded &&
        (ellipsis.expandable || ellipsis.tooltip);

    Widget content;
    if (needsOverflowMeasure) {
      content = LayoutBuilder(builder: (context, constraints) {
        final direction = Directionality.of(context);
        final scaler = MediaQuery.textScalerOf(context);
        if (!_measureTextOverflow(
          context,
          baseStyle,
          ellipsis.rows,
          constraints.maxWidth,
        )) {
          // 未溢出：纯文本 + 动作图标，无展开/tooltip
          return _wrapVisualDecorations(
            Text.rich(
              TextSpan(children: buildSpans(widget.text ?? '')),
              style: baseStyle,
            ),
            theme,
          );
        }
        // 溢出：为末行预留 inline 图标空间，按测量截断文本
        // （不用 maxLines+ellipsis，否则 WidgetSpan 会被 ellipsis 挤到隐藏行）。
        final showExpand = ellipsis.expandable && expandWidget != null;
        final reservedIcons = leadingIcons.length +
            trailingIcons.length +
            (showExpand ? 1 : 0);
        final displayText = showExpand
            ? _truncateTextForExpand(
                widget.text ?? '',
                baseStyle,
                ellipsis.rows,
                constraints.maxWidth,
                reservedIcons,
                direction,
                scaler,
              )
            : (widget.text ?? '');
        Widget inner = Text.rich(
          TextSpan(
            children:
                buildSpans(displayText, expand: showExpand ? expandWidget : null),
          ),
          style: baseStyle,
        );
        // antd 自举：包内 AntTooltip（桌面 hover / 移动点击）
        if (ellipsis.tooltip) {
          inner = AntTooltip(
            tooltip: Text(widget.text ?? _plainText),
            child: inner,
          );
        }
        return _wrapVisualDecorations(inner, theme);
      },);
    } else {
      content = _wrapVisualDecorations(
        Text.rich(
          TextSpan(children: buildSpans(widget.text ?? '', expand: expandWidget)),
          style: baseStyle,
          maxLines: hasEllipsis && !_expanded ? ellipsis.rows : null,
          overflow: hasEllipsis && !_expanded ? TextOverflow.ellipsis : null,
        ),
        theme,
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

    return _wrapInteractive(content, theme);
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

  /// 构建编辑器（对齐 antd 桌面交互）。
  ///
  /// 编辑态渲染一个输入框；回车键（keyboard return）图标以角标形式
  /// 叠加在输入区内部右下角（Stack + Positioned right/bottom 对齐，
  /// antd 编辑态角标样式）：经 LayoutBuilder 按输入区实际约束计算
  /// 垂直边距，图标与输入框内边缘保持 [_editorCornerSafeMargin] 安全边距
  /// （高度不足时压缩边距兜底），确保图标完全位于输入框边界之内，
  /// 且输入文字右侧预留角标宽度，不被图标遮挡。
  /// 点击回车图标或键盘回车确认提交；Esc / 失焦取消。
  Widget _buildEditor(AntThemeData theme, Color color) {
    return Focus(
      focusNode: _editorFocusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _cancelEdit();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 垂直边距：高度足够时取安全边距贴右下角；
          // 高度不足时压缩为垂直居中（最小 2px），保证图标不越出输入框边界。
          final centeredGap =
              (constraints.maxHeight - _editorCornerIconSize) / 2;
          final bottomGap = centeredGap >= _editorCornerSafeMargin
              ? _editorCornerSafeMargin
              : math.max(2.0, centeredGap);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              TextField(
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
                  // 右侧留出角标宽度 + 安全边距，避免输入文字被右下角图标遮挡
                  contentPadding: EdgeInsets.only(
                    left: theme.paddingXS,
                    right:
                        theme.paddingXS + _editorCornerIconSize + _editorCornerSafeMargin,
                    top: (theme.controlHeight - theme.fontSize) / 2,
                    bottom: (theme.controlHeight - theme.fontSize) / 2,
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
              // 回车确认图标（keyboard return）：输入区内部右下角叠加角标。
              // _ActionIcon 自带的左内边距向左扩展，不影响图标右缘，
              // 图标可见边缘与输入框内边缘恰为 8px 安全边距。
              Positioned(
                right: _editorCornerSafeMargin,
                // 用户视觉校准：整体上移 2px
                bottom: bottomGap + 2,
                child: _ActionIcon(
                  icon: const Icon(
                    AntIcons.enterOutlined,
                    size: _editorCornerIconSize,
                  ),
                  onTap: _commitEdit,
                  color: theme.colorPrimary,
                  tooltip: '确认',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 用 TextPainter 按当前宽度与 maxRows 判定文字是否真正溢出。
  bool _measureTextOverflow(
    BuildContext context,
    TextStyle style,
    int maxLines,
    double maxWidth,
  ) {
    if (maxWidth <= 0 || maxLines <= 0) return false;
    final text = widget.text ?? '';
    if (text.isEmpty) return false;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);
    final clippedHeight = painter.height;
    final maxIntrinsicWidth = painter.maxIntrinsicWidth;
    // 不限行数再排一次：高度更高说明被 rows 截断
    painter.maxLines = null;
    painter.layout(maxWidth: maxWidth);
    final fullHeight = painter.height;
    painter.dispose();
    // 高度被压低（多行被截）或存在无法换行的超宽内容（末行被截）
    return fullHeight > clippedHeight + 0.5 || maxIntrinsicWidth > maxWidth;
  }

  double _measureTextWidth(
    String text,
    TextStyle style,
    TextDirection direction,
    TextScaler scaler,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
      textScaler: scaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  /// 计算为末行预留 inline 图标空间所需的截断文本（含省略号）。
  ///
  /// 二分搜索最大可容纳前缀：截断后整体不超过 rows 行，
  /// 且末行剩余宽度足够放下全部 inline 图标（展开/复制/编辑）。
  String _truncateTextForExpand(
    String text,
    TextStyle style,
    int rows,
    double maxWidth,
    int reservedIcons,
    TextDirection direction,
    TextScaler scaler,
  ) {
    final fontSize = style.fontSize ?? 14;
    final lineHeight = fontSize * (style.height ?? 1.2);
    final maxHeight = rows * lineHeight;
    // 展开按钮（按“展开”文字宽度）+ 其余图标按固定估算宽（14px 图标 + padding）
    final expandWidth =
        _measureTextWidth('展开', style, direction, scaler) + 12;
    final reserveWidth =
        expandWidth + reservedIcons * 26;

    bool fits(String prefix) {
      final painter = TextPainter(
        text: TextSpan(text: '$prefix…', style: style),
        textDirection: direction,
        textScaler: scaler,
      )..layout(maxWidth: maxWidth);
      if (painter.height > maxHeight + 0.5) {
        painter.dispose();
        return false;
      }
      final metrics = painter.computeLineMetrics();
      final lastLineWidth = metrics.isEmpty ? 0.0 : metrics.last.width;
      painter.dispose();
      return lastLineWidth + reserveWidth <= maxWidth;
    }

    // 全文已经放得下（不溢出）则不截断
    if (fits(text.replaceAll(RegExp(r'…$'), ''))) return text;

    var lo = 0;
    var hi = text.length - 1;
    var best = 0;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      if (fits(text.substring(0, mid))) {
        best = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    if (best <= 0) return '…';
    return '${text.substring(0, best)}…';
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
          // 与文字之间 4px、与后续动作图标之间再由图标自带的 8px 左间距补足
          padding: const EdgeInsets.only(left: 4),
          child: DefaultTextStyle.merge(
            style: linkStyle,
            child: symbol,
          ),
        ),
      ),
    );
  }

  /// 构建复制操作图标（可配置 tooltip 开关；位置由 copyConfig.position 决定）。
  Widget? _buildCopyAction(AntThemeData theme) {
    if (!widget.copyable && widget.copyConfig == null) return null;
    final config = widget.copyConfig ?? const AntCopyConfig();
    final tooltipText = _copied
        ? (config.tooltips?.elementAtOrNull(1) ?? '已复制')
        : (config.tooltips?.elementAtOrNull(0) ?? '复制');
    return _ActionIcon(
      icon: config.icon ??
          Icon(
            _copied ? AntIcons.checkOutlined : AntIcons.copyOutlined,
            size: 14,
          ),
      onTap: _copied ? null : _handleCopy,
      color: _copied ? theme.colorSuccess : theme.colorTextTertiary,
      tooltip: config.tooltip ? tooltipText : null,
    );
  }

  /// 构建编辑操作图标。
  ///
  /// 移动端（compact / 移动断点，经 [AntResponsive.deviceTypeOf] 判定
  /// deviceType == [AntDeviceType.phone]）下 editable / editConfig 不生效：
  /// 不渲染编辑入口，保持纯文本展示；桌面 / 平板 / Web 端保持现有编辑能力。
  Widget? _buildEditAction(AntThemeData theme) {
    if (!widget.editable && widget.editConfig == null) return null;
    if (AntResponsive.deviceTypeOf(context) == AntDeviceType.phone) {
      return null;
    }
    return _ActionIcon(
      icon: const Icon(AntIcons.editOutlined, size: 14),
      onTap: widget.disabled ? null : _startEdit,
      color: widget.disabled ? theme.colorTextDisabled : theme.colorTextTertiary,
      tooltip: '编辑',
    );
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
      // 左侧 _actionGap：图标与文本/上一个动作图标之间统一 8px 间距
      padding: const EdgeInsets.only(left: _actionGap),
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