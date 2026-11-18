/// AntEllipsis — antd-mobile Ellipsis 的 Flutter 实现
///
/// API 与 antd-mobile v5 对齐：
/// - [content] — 文本内容
/// - [direction] — 截断方向（start / end / middle）
/// - [rows] — 展示的行数
/// - [expandText] — 展开文案（为 null 时不可展开）
/// - [collapseText] — 收起文案
/// - [onContentClick] — 点击文本回调
/// - [style] — 文本样式
///
/// ```dart
/// AntEllipsis(content: '很长的一段文本...')
/// AntEllipsis(content: '...', rows: 3, expandText: '展开', collapseText: '收起')
/// ```
/// 截断/测量算法参考 pub.dev/packages/ellipsized_text 的「二分搜索截断长度」实现
/// （本地快照：.temp/ellipsized_text/），在其基础上扩展：测量时把展开/收起动作
/// 的宽度一并计入，截断点 = 整行宽 − 动作宽度，使动作内联跟随截断文字行末。
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_ui/src/display/ellipsis/ant_ellipsis_types.dart';
export 'package:antd_flutter_ui/src/display/ellipsis/ant_ellipsis_types.dart';
import 'package:material_ui/material_ui.dart';

/// 省略号占位符。
const String _kEllipsisChar = '...';

/// 宽度比较精度容差。
const double _kWidthEpsilon = 0.01;

/// 文本省略 — 多行文本按行数截断，支持展开收起。
///
/// 对齐 antd-mobile Ellipsis 组件。
class AntEllipsis extends StatefulWidget {
  const AntEllipsis({
    super.key,
    required this.content,
    this.direction = AntEllipsisDirection.end,
    this.rows = 1,
    this.expandText,
    this.collapseText,
    this.onContentClick,
    this.style,
  });

  /// 文本内容。
  final String content;

  /// 截断方向。
  final AntEllipsisDirection direction;

  /// 展示的行数。
  final int rows;

  /// 展开文案；为 null 时不可展开。
  final String? expandText;

  /// 收起文案。
  final String? collapseText;

  /// 点击文本内容回调。
  final GestureTapCallback? onContentClick;

  /// 文本样式透传。
  final TextStyle? style;

  @override
  State<AntEllipsis> createState() => _AntEllipsisState();
}

class _AntEllipsisState extends State<AntEllipsis> {
  bool _expanded = false;

  bool get _canExpand => widget.expandText != null && widget.expandText != '';

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final baseStyle = (widget.style ?? const TextStyle()).copyWith(
      fontSize: widget.style?.fontSize ?? theme.fontSize,
      color: widget.style?.color ?? theme.colorText,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // 测量必须与渲染使用同一套有效样式与文字缩放：
        // Text 实际渲染样式 = DefaultTextStyle.merge(组件 style)，
        // 仅用裸 style 测量会漏掉 letterSpacing 等继承属性导致截断偏长
        final effectiveStyle = DefaultTextStyle.of(context).style.merge(baseStyle);
        // 测量与渲染使用同一文字缩放，保证截断预算与实际行宽一致
        final textScaler = MediaQuery.textScalerOf(context);
        final isOverflow = _checkOverflow(maxWidth, effectiveStyle, textScaler);

        // 已展开：全文 + 收起动作（内联）
        if (_expanded && _canExpand) {
          return _buildContent(
            context,
            widget.content,
            baseStyle,
            trailingAction: widget.collapseText,
            onActionTap: _toggleExpand,
          );
        }

        if (!isOverflow) {
          return _buildContent(context, widget.content, baseStyle);
        }

        if (!_canExpand) {
          // 不可展开：仅按行数省略展示
          return _buildContent(
              context, _truncate(maxWidth, effectiveStyle, textScaler: textScaler),
              baseStyle,);
        }

        return _buildContent(
          context,
          _truncate(maxWidth, effectiveStyle,
              actionText: widget.expandText, textScaler: textScaler,),
          baseStyle,
          trailingAction: widget.expandText,
          onActionTap: _toggleExpand,
        );
      },
    );
  }

  /// 内容主体：Text.rich 内联渲染 —— 正文 TextSpan + 尾部展开/收起动作
  /// WidgetSpan，动作与截断文字同行内联跟随（对齐 antd-mobile 行为）。
  Widget _buildContent(
    BuildContext context,
    String text,
    TextStyle style, {
    String? trailingAction,
    VoidCallback? onActionTap,
  }) {
    return GestureDetector(
      onTap: widget.onContentClick,
      behavior: HitTestBehavior.opaque,
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            if (trailingAction != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: onActionTap,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    trailingAction,
                    style: style.copyWith(
                      color: AntTheme.of(context).colorPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        style: style,
      ),
    );
  }

  /// 是否溢出（超出 rows 行）。
  bool _checkOverflow(double maxWidth, TextStyle style, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: widget.content, style: style),
      maxLines: widget.rows,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    final overflow = painter.didExceedMaxLines;
    painter.dispose();
    return overflow;
  }

  /// 按方向计算截断后的展示文本（二分查找可容纳的最大字符数，
  /// 参考 ellipsized_text 的二分截断实现）。
  ///
  /// 传入 [actionText] 时，把动作宽度计入测量：截断文字的最后一行须预留
  /// 动作宽度，保证展开动作与截断文字同一行内联。
  String _truncate(
    double maxWidth,
    TextStyle style, {
    String? actionText,
    required TextScaler textScaler,
  }) {
    final actionWidth = actionText == null || actionText.isEmpty
        ? 0.0
        : _measureWidth(actionText, style, textScaler);
    final lastLineBudget = (maxWidth - actionWidth).clamp(0.0, maxWidth);
    var low = 0;
    var high = widget.content.length;
    var fitted = 0;
    while (low <= high) {
      final mid = (low + high) >> 1;
      if (_fitsWithLastLineBudget(
        _sliceByCount(mid),
        lastLineBudget,
        maxWidth,
        style,
        textScaler,
      )) {
        fitted = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return _sliceByCount(fitted);
  }

  /// 按可容纳字符数生成对应方向的展示文本。
  String _sliceByCount(int count) {
    if (count >= widget.content.length) return widget.content;
    switch (widget.direction) {
      case AntEllipsisDirection.end:
        return widget.content.substring(0, count) + _kEllipsisChar;
      case AntEllipsisDirection.start:
        return _kEllipsisChar +
            widget.content.substring(widget.content.length - count);
      case AntEllipsisDirection.middle:
        final headCount = (count / 2).floor();
        final tailCount = count - headCount;
        return widget.content.substring(0, headCount) +
            _kEllipsisChar +
            widget.content.substring(widget.content.length - tailCount);
    }
  }

  /// 测量单行文本宽度（用于预留动作 span 宽度）。
  double _measureWidth(String text, TextStyle style, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  /// 判断文本在 [maxWidth] 内不超过 [rows] 行，且最后一行宽度不超过
  /// [lastLineBudget]（= 整行宽 − 动作宽度），即行末可内联放下动作。
  bool _fitsWithLastLineBudget(
    String text,
    double lastLineBudget,
    double maxWidth,
    TextStyle style,
    TextScaler textScaler,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.rows,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    var fits = !painter.didExceedMaxLines;
    if (fits) {
      final metrics = painter.computeLineMetrics();
      fits = metrics.last.width <= lastLineBudget + _kWidthEpsilon;
    }
    painter.dispose();
    return fits;
  }
}
