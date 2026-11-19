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
/// AntTimeline(
///   items: [
///     AntTimelineItem(content: Text('创建于 2024-01-01'), color: AntTimelineColor.green),
///     AntTimelineItem(content: Text('进行中'), color: AntTimelineColor.blue),
///   ],
///   pending: true,
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/timeline/ant_timeline_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/timeline/ant_timeline_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntTimeline
// ============================================================

/// 时间轴 — 垂直展示的时间流信息。
///
/// 对齐 antd React Timeline 组件。
class AntTimeline extends StatelessWidget {
  const AntTimeline({
    super.key,
    required this.items,
    this.mode = AntTimelineMode.left,
    this.pending = false,
    this.pendingDot,
    this.pendingContent,
    this.reverse = false,
  });

  /// 时间轴项列表。
  final List<AntTimelineItem> items;

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
    var displayItems = List<AntTimelineItem>.of(items);

    if (reverse) {
      displayItems = displayItems.reversed.toList();
    }
    if (pending) {
      displayItems = [
        ...displayItems,
        AntTimelineItem(
          customDot: pendingDot ??
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorPrimary),
                ),
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
            item: displayItems[i],
            isFirst: i == 0,
            isLast: i == displayItems.length - 1,
            alternate:
                mode == AntTimelineMode.alternate && displayItems.length > 1,
            flipAlternate:
                mode == AntTimelineMode.alternate && i.isEven,
            rightAligned: mode == AntTimelineMode.right,
            theme: theme,
          ),
      ],
    );
  }
}

/// 时间轴单行：label 列 + 节点列（含轴线）+ 内容列。
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.alternate,
    required this.flipAlternate,
    required this.rightAligned,
    required this.theme,
  });

  final AntTimelineItem item;
  final bool isFirst;
  final bool isLast;
  final bool alternate;
  final bool flipAlternate;
  final bool rightAligned;
  final AntThemeData theme;

  static const double _dotSize = 12;
  static const double _lineWidth = 2;

  @override
  Widget build(BuildContext context) {
    final dot = _buildDot();
    final content = _buildContent();
    final label = item.label != null
        ? Text(
            item.label!,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorTextSecondary,
            ),
          )
        : null;

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
                  padding: EdgeInsets.only(right: 16.w, top: 2.w),
                  child: leftSide ?? const SizedBox.shrink(),
                ),
              ),
            ),
            _buildCenterColumn(dot),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 2.w),
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
                  padding: EdgeInsets.only(top: 2.w),
                  child: content,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            _buildEndColumn(dot),
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
            _buildStartColumn(dot),
            SizedBox(width: 16.w),
            Expanded(child: content),
          ],
        ),
      );
    }

    if (item.disabled) {
      row = Opacity(opacity: 0.45, child: row);
    }

    if (item.onTap != null && !item.disabled) {
      row = GestureDetector(
        onTap: item.onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.w),
      child: row,
    );
  }

  /// 节点 + 上下延伸的轴线（居中列，alternate 用）。
  Widget _buildCenterColumn(Widget dot) {
    return SizedBox(
      width: _dotSize.w,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: _lineWidth.w,
                child: Container(
                  color: isFirst ? Colors.transparent : theme.colorSplit,
                ),
              ),
            ),
          ),
          dot,
          Expanded(
            child: Center(
              child: SizedBox(
                width: _lineWidth.w,
                child: Container(
                  color: isLast ? Colors.transparent : theme.colorSplit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 节点 + 向下延伸的轴线（左端列，默认模式用）。
  Widget _buildStartColumn(Widget dot) {
    return SizedBox(
      width: _dotSize.w,
      child: Column(
        children: [
          dot,
          Expanded(
            child: Center(
              child: SizedBox(
                width: _lineWidth.w,
                child: Container(
                  color: isLast ? Colors.transparent : theme.colorSplit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 节点 + 向上延伸的轴线（右端列，right 模式用）。
  Widget _buildEndColumn(Widget dot) {
    return SizedBox(
      width: _dotSize.w,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: _lineWidth.w,
                child: Container(
                  color: isFirst ? Colors.transparent : theme.colorSplit,
                ),
              ),
            ),
          ),
          dot,
        ],
      ),
    );
  }

  Widget _buildDot() {
    if (item.customDot != null) {
      return item.customDot!;
    }
    final color = item.dotColor ?? _presetColor(theme);
    return Container(
      width: _dotSize.w,
      height: _dotSize.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorBgContainer,
          width: 2.w,
        ),
      ),
    );
  }

  Color _presetColor(AntThemeData theme) {
    if (item.disabled) {
      return theme.colorTextQuaternary;
    }
    switch (item.color) {
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
        color: item.disabled ? theme.colorTextDisabled : theme.colorText,
        height: 1.5,
      ),
      child: item.content ?? const SizedBox.shrink(),
    );
  }
}
