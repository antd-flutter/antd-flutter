/// AntTimeline — antd React Timeline 的 Flutter 实现
///
/// API 与 antd React Timeline 对齐：
/// - [items] — 时间轴项列表
/// - [mode] — 模式（left/right/alternate）
/// - [pending] — 是否存在待办节点（最后追加 loading 转圈）
/// - [pendingDot] — 自定义 pending 节点
/// - [pendingContent] — pending 节点内容
/// - [reverse] — 是否倒序
///
/// ```dart
/// AntTimeline<Event>(
///   items: events,
///   contentBuilder: (context, event, index) => Text(event.text),
///   colorOf: (event) => event.color,
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_timeline_types.dart';
import '../../feedback/loading/ant_loading.dart';
export 'ant_timeline_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntTimeline
// ============================================================

/// 时间轴 — 垂直展示的时间流信息。
///
/// 对齐 antd React Timeline 组件。
class AntTimeline<T> extends StatelessWidget {
  const AntTimeline({
    super.key,
    required this.items,
    this.labelBuilder,
    this.contentBuilder,
    this.dotBuilder,
    this.colorOf,
    this.dotColorOf,
    this.disabledOf,
    this.onTap,
    this.mode = AntTimelineMode.left,
    this.pending = false,
    this.pendingDot,
    this.pendingContent,
    this.reverse = false,
  });

  /// 时间轴项列表。
  final List<T> items;

  /// 时间标签构建器。
  final AntTimelineLabelBuilder<T>? labelBuilder;

  /// 内容构建器。
  final AntTimelineContentBuilder<T>? contentBuilder;

  /// 自定义节点构建器。
  final AntTimelineDotBuilder<T>? dotBuilder;

  /// 节点颜色预设提取器。
  final AntTimelineColor? Function(T item)? colorOf;

  /// 自定义节点颜色提取器（自定义节点为空时生效）。
  final Color? Function(T item)? dotColorOf;

  /// 是否禁用。
  final bool Function(T item)? disabledOf;

  /// 点击回调（禁用时不触发）。
  final ValueChanged<T>? onTap;

  /// 模式。
  final AntTimelineMode mode;

  /// 是否存在待办节点（末尾追加 loading 节点）。
  final bool pending;

  /// 自定义 pending 节点。
  final Widget? pendingDot;

  /// pending 节点的内容。
  final Widget? pendingContent;

  /// 是否倒序展示。
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    var displayItems = <_TimelineCell>[
      for (var i = 0; i < items.length; i++)
        _TimelineCell(
          label: labelBuilder?.call(context, items[i], i),
          content: contentBuilder?.call(context, items[i], i),
          customDot: dotBuilder?.call(context, items[i]),
          color: colorOf?.call(items[i]),
          dotColor: dotColorOf?.call(items[i]),
          disabled: disabledOf?.call(items[i]) ?? false,
          onTap: onTap == null ? null : () => onTap!(items[i]),
        ),
    ];

    if (reverse) {
      displayItems = displayItems.reversed.toList();
    }
    if (pending) {
      displayItems = [
        ...displayItems,
        _TimelineCell(
          customDot: pendingDot ??
              AntLoading(
                size: 14.w,
                color: theme.colorPrimary,
              ),
          content: pendingContent,
        ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < displayItems.length; i++)
          _TimelineRow(
            cell: displayItems[i],
            index: i,
            isFirst: i == 0,
            isLast: i == displayItems.length - 1,
            alternate:
                mode == AntTimelineMode.alternate && displayItems.length > 1,
            flipAlternate: mode == AntTimelineMode.alternate && i.isEven,
            rightAligned: mode == AntTimelineMode.right,
            theme: theme,
          ),
      ],
    );
  }
}

/// 内部归一化后的时间轴单元格。
class _TimelineCell {
  const _TimelineCell({
    this.label,
    this.content,
    this.customDot,
    this.color,
    this.dotColor,
    this.disabled = false,
    this.onTap,
  });

  final Widget? label;
  final Widget? content;
  final Widget? customDot;
  final AntTimelineColor? color;
  final Color? dotColor;
  final bool disabled;
  final VoidCallback? onTap;
}

/// 时间轴单行：label 列 + 节点列（含轴线）+ 内容列。
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.cell,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.alternate,
    required this.flipAlternate,
    required this.rightAligned,
    required this.theme,
  });

  final _TimelineCell cell;
  final int index;
  final bool isFirst;
  final bool isLast;
  final bool alternate;
  final bool flipAlternate;
  final bool rightAligned;
  final AntThemeData theme;

  static const double _dotSize = 12; // antd dotSize，固定不随屏幕缩放
  static const double _lineWidth = 2;

  @override
  Widget build(BuildContext context) {
    final dot = _buildDot();
    final content = _buildContent();
    final gap = isLast ? 0.0 : 16.w;
    final label = cell.label == null
        ? null
        : DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorTextSecondary,
            ),
            child: cell.label!,
          );

    Widget row;
    if (alternate) {
      // alternate：节点列居中，label 与内容左右交替
      final leftSide = flipAlternate ? content : label;
      final rightSide = flipAlternate ? label : content;
      row = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w, bottom: gap),
                  child: leftSide ?? const SizedBox.shrink(),
                ),
              ),
            ),
            _buildDotColumn(dot),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: gap),
                  child: rightSide ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (rightAligned) {
      // right：内容靠右，节点列在右
      row = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: gap),
                  child: content,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            _buildDotColumn(dot),
          ],
        ),
      );
    } else {
      // left（默认）：节点列在左
      row = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (label != null) ...[
              SizedBox(
                width: 64.w,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w, top: 2.w),
                  child: label,
                ),
              ),
            ],
            _buildDotColumn(dot),
            SizedBox(width: 16.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: gap),
                child: content,
              ),
            ),
          ],
        ),
      );
    }

    if (cell.disabled) {
      row = Opacity(opacity: 0.45, child: row);
    }

    if (cell.onTap != null && !cell.disabled) {
      row = GestureDetector(
        onTap: cell.onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      );
    }

    return row;
  }

  /// 节点列：轴线贯穿整列，节点垂直居中于内容首行。
  ///
  /// 内容列不再额外加顶部偏移，节点中心即首行行高的一半；
  /// 轴线用 CustomPaint 画在节点下方/上方并一直延伸到行边界，
  /// 行与行衔接处不会断开；首项不再向上延伸、末项不再向下延伸。
  Widget _buildDotColumn(Widget dot) {
    final centerY = theme.fontSize * 1.5 / 2;
    return SizedBox(
      width: _dotSize,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            key: ValueKey('ant-timeline-tail-$index'),
            painter: _TimelineRailPainter(
              color: theme.colorSplit,
              lineWidth: _lineWidth,
              centerY: centerY,
              isFirst: isFirst,
              isLast: isLast,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: (centerY - _dotSize / 2).clamp(0.0, double.infinity),
              ),
              SizedBox(
                height: _dotSize,
                child: Center(child: dot),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    if (cell.customDot != null) {
      return cell.customDot!;
    }
    final color = cell.dotColor ?? _presetColor(theme);
    return Container(
      key: ValueKey('ant-timeline-dot-$index'),
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorBgContainer,
          width: 2,
        ),
      ),
    );
  }

  Color _presetColor(AntThemeData theme) {
    if (cell.disabled) {
      return theme.colorTextQuaternary;
    }
    switch (cell.color) {
      case AntTimelineColor.blue:
        return theme.colorPrimary;
      case AntTimelineColor.red:
        return theme.colorError;
      case AntTimelineColor.green:
        return theme.colorSuccess;
      case AntTimelineColor.gray:
        return theme.colorTextQuaternary;
      case null:
        return theme.colorPrimary;
    }
  }

  Widget _buildContent() {
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: theme.fontSize,
        color: cell.disabled ? theme.colorTextDisabled : theme.colorText,
        height: 1.5,
      ),
      child: cell.content ?? const SizedBox.shrink(),
    );
  }
}

/// 轴线绘制：从节点中心向下延伸到行底部（末项止于节点中心），
/// 首项不向上延伸。相邻两行的轴线首尾相接，整条时间轴保持连续。
class _TimelineRailPainter extends CustomPainter {
  const _TimelineRailPainter({
    required this.color,
    required this.lineWidth,
    required this.centerY,
    required this.isFirst,
    required this.isLast,
  });

  final Color color;
  final double lineWidth;
  final double centerY;
  final bool isFirst;
  final bool isLast;

  @override
  void paint(Canvas canvas, Size size) {
    final top = isFirst ? centerY : 0.0;
    final bottom = isLast ? centerY : size.height;
    if (bottom <= top) return;
    canvas.drawRect(
      Rect.fromLTWH((size.width - lineWidth) / 2, top, lineWidth, bottom - top),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineRailPainter oldDelegate) {
    return color != oldDelegate.color ||
        lineWidth != oldDelegate.lineWidth ||
        centerY != oldDelegate.centerY ||
        isFirst != oldDelegate.isFirst ||
        isLast != oldDelegate.isLast;
  }
}
