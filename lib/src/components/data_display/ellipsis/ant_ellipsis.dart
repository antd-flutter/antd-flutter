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
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/ellipsis/ant_ellipsis_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/ellipsis/ant_ellipsis_types.dart';
import 'package:material_ui/material_ui.dart';

/// 省略号占位符。
const String _kEllipsisChar = '...';

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
        final isOverflow = _checkOverflow(maxWidth, baseStyle);

        // 已展开：全文 + 收起动作
        if (_expanded && _canExpand) {
          return _buildContent(context, widget.content, baseStyle,
              trailingAction: widget.collapseText,
              onActionTap: _toggleExpand,);
        }

        if (!isOverflow) {
          return _buildContent(context, widget.content, baseStyle);
        }

        if (!_canExpand) {
          // 不可展开：仅按行数省略展示
          return _buildContent(
              context, _truncate(maxWidth, baseStyle), baseStyle,);
        }

        return _buildContent(
          context,
          _truncate(maxWidth, baseStyle),
          baseStyle,
          trailingAction: widget.expandText,
          onActionTap: _toggleExpand,
        );
      },
    );
  }

  /// 内容主体：文本 + 可选的尾部动作文案（展开/收起）。
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
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(text, style: style),
          if (trailingAction != null)
            GestureDetector(
              onTap: onActionTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                trailingAction,
                style: style.copyWith(
                  color: AntTheme.of(context).colorPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 是否溢出（超出 rows 行）。
  bool _checkOverflow(double maxWidth, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: widget.content, style: style),
      maxLines: widget.rows,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    final overflow = painter.didExceedMaxLines;
    painter.dispose();
    return overflow;
  }

  /// 按方向计算截断后的展示文本（二分查找可容纳的最大字符数）。
  String _truncate(double maxWidth, TextStyle style) {
    var low = 0;
    var high = widget.content.length;
    var fitted = widget.content.length;
    while (low <= high) {
      final mid = (low + high) >> 1;
      if (_fitsWidth(_sliceByCount(mid), maxWidth, style)) {
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

  bool _fitsWidth(String text, double maxWidth, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.rows,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    final fits = !painter.didExceedMaxLines;
    painter.dispose();
    return fits;
  }
}
