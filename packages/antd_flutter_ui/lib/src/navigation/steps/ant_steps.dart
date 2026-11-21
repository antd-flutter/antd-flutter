/// AntSteps — antd React Steps 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [current] — 当前步骤索引（从 0 开始）
/// - [items] — 步骤项列表
/// - [direction] — 排列方向（horizontal / vertical）
/// - [status] — 当前步骤的状态（wait / process / finish / error）
/// - [size] — 尺寸（normal / small）
/// - [onChange] — 点击切换步骤回调
///
/// 每项（AntStepsItem）支持 title / description / icon / status / disabled。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_steps_types.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntSteps
// ============================================================

/// 步骤条 — 引导用户按照流程完成任务的导航条。
///
/// 对齐 antd React Steps 组件，支持水平/垂直排列、四种状态、
/// 自定义图标和点击切换。
///
/// ```dart
/// AntSteps(
///   current: 1,
///   items: [
///     AntStepsItem(title: 'Finished', description: 'Step 1 done'),
///     AntStepsItem(title: 'In Progress', description: 'Step 2 running'),
///     AntStepsItem(title: 'Waiting', description: 'Step 3 pending'),
///   ],
/// )
/// ```
class AntSteps extends StatelessWidget {
  const AntSteps({
    super.key,
    this.current = 0,
    this.items = const [],
    this.direction = AntStepsDirection.horizontal,
    this.status = AntStepsStatus.process,
    this.size = AntStepsSize.normal,
    this.onChange,
  });

  /// 当前步骤索引，从 0 开始。
  final int current;

  /// 步骤项列表。
  final List<AntStepsItem> items;

  /// 排列方向。horizontal 为水平排列，vertical 为垂直排列。
  final AntStepsDirection direction;

  /// 当前步骤的状态。默认 process。
  final AntStepsStatus status;

  /// 尺寸。normal 为默认尺寸，small 为小尺寸。
  final AntStepsSize size;

  /// 点击切换步骤回调。设置后步骤可点击切换。
  final ValueChanged<int>? onChange;

  double get _circleSize => size == AntStepsSize.small ? 24 : 32;

  double get _connectorThickness => 1;

  /// 计算指定索引步骤的状态。
  AntStepsStatus _resolveStatus(int index) {
    final item = items[index];
    if (item.status != null) return item.status!;
    if (index < current) return AntStepsStatus.finish;
    if (index == current) return status;
    return AntStepsStatus.wait;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    Widget result;
    if (direction == AntStepsDirection.vertical) {
      result = _buildVertical(context);
    } else {
      result = _buildHorizontal(context);
    }

    // 无界主轴自适应：内部使用 Expanded 撑满主轴，在
    // SingleChildScrollView / 未约束 Column 等无界容器中会触发
    // "Vertical viewport was given unbounded height" 类崩溃。
    // 检测到无界约束时改用 Intrinsic 尺寸自适应
    // （对齐 AntSegmented 无界处理先例）。
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget adapted = result;
        if (!constraints.hasBoundedHeight) {
          adapted = IntrinsicHeight(child: adapted);
        }
        if (!constraints.hasBoundedWidth) {
          adapted = IntrinsicWidth(child: adapted);
        }
        return adapted;
      },
    );
  }

  // ------------------------------------------------------------
  // 水平布局
  // ------------------------------------------------------------

  Widget _buildHorizontal(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final isLast = i == items.length - 1;
      children.add(
        Expanded(
          child: KeyedSubtree(
            key: ValueKey('ant_steps_item_$i'),
            child: _buildHorizontalStep(context, i, isLast),
          ),
        ),
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildHorizontalStep(
    BuildContext context,
    int index,
    bool isLast,
  ) {
    final theme = AntTheme.of(context);
    final item = items[index];
    final stepStatus = _resolveStatus(index);
    final canClick =
        onChange != null && item.disabled != true && index != current;

    // 图标行固定为圆点高度：所有步骤的圆点与连线都落在同一水平线上，
    // 否则末项没有接线、行高不同会导致圆点错位、线接不上。
    final iconRow = SizedBox(
      height: _circleSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCircle(context, theme, index, stepStatus, canClick),
          const SizedBox(width: 8),
          Flexible(
            child: _buildTitle(
              theme,
              item,
              stepStatus,
              singleLine: true,
            ),
          ),
          if (!isLast) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _buildConnector(theme, stepStatus, index: index),
            ),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconRow,
        if (item.description != null)
          Padding(
            padding: EdgeInsets.only(left: _circleSize + 8, top: 4),
            child: _buildDescription(theme, item, stepStatus),
          ),
      ],
    );
  }

  // ------------------------------------------------------------
  // 垂直布局
  // ------------------------------------------------------------

  Widget _buildVertical(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final isLast = i == items.length - 1;
      children.add(
        Expanded(
          child: KeyedSubtree(
            key: ValueKey('ant_steps_item_$i'),
            child: _buildVerticalStep(context, i, isLast),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildVerticalStep(
    BuildContext context,
    int index,
    bool isLast,
  ) {
    final theme = AntTheme.of(context);
    final item = items[index];
    final stepStatus = _resolveStatus(index);
    final canClick =
        onChange != null && item.disabled != true && index != current;

    final circleColumn = <Widget>[
      _buildCircle(context, theme, index, stepStatus, canClick),
    ];
    if (!isLast) {
      // 连接线从圆点下沿直接起画，与下一项圆点上沿相接
      circleColumn.add(
        Expanded(
          child: _buildConnector(
            theme,
            stepStatus,
            index: index,
            vertical: true,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(children: circleColumn),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : 16,
              top: (_circleSize - theme.fontSize * 1.4) / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(theme, item, stepStatus),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  _buildDescription(theme, item, stepStatus),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // 子部件
  // ------------------------------------------------------------

  Widget _buildCircle(
    BuildContext context,
    AntThemeData theme,
    int index,
    AntStepsStatus stepStatus,
    bool canClick,
  ) {
    final circle = Container(
      key: ValueKey('ant_steps_circle_$index'),
      width: _circleSize,
      height: _circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: stepStatus == AntStepsStatus.process
            ? theme.colorPrimary
            : Colors.transparent,
        border: Border.all(
          color: switch (stepStatus) {
            AntStepsStatus.process => theme.colorPrimary,
            AntStepsStatus.finish => theme.colorPrimary,
            AntStepsStatus.error => theme.colorError,
            AntStepsStatus.wait => theme.colorBorder,
          },
          width: 1,
        ),
      ),
      child: Center(
        child: _buildCircleContent(theme, index, stepStatus),
      ),
    );

    if (canClick) {
      return GestureDetector(
        onTap: () => onChange!(index),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: circle,
        ),
      );
    }
    return circle;
  }

  Widget _buildCircleContent(
    AntThemeData theme,
    int index,
    AntStepsStatus stepStatus,
  ) {
    final item = items[index];
    if (item.icon != null) {
      return SizedBox(
        width: _circleSize,
        height: _circleSize,
        child: Center(child: item.icon!),
      );
    }

    final iconSize = _circleSize * 0.5;

    return switch (stepStatus) {
      AntStepsStatus.finish => Icon(
          AntIcons.checkOutlined,
          size: iconSize,
          color: theme.colorPrimary,
        ),
      AntStepsStatus.error => Icon(
          AntIcons.closeOutlined,
          size: iconSize,
          color: theme.colorError,
        ),
      AntStepsStatus.process => Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: _circleSize * 0.45,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      AntStepsStatus.wait => Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: _circleSize * 0.45,
            color: theme.colorTextTertiary,
          ),
        ),
    };
  }

  Widget _buildTitle(
    AntThemeData theme,
    AntStepsItem item,
    AntStepsStatus stepStatus, {
    bool singleLine = false,
  }) {
    if (item.title == null) return const SizedBox.shrink();
    return Text(
      item.title!,
      maxLines: singleLine ? 1 : null,
      overflow: singleLine ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: theme.fontSize,
        fontWeight: stepStatus == AntStepsStatus.process
            ? FontWeight.w600
            : FontWeight.w400,
        color: switch (stepStatus) {
          AntStepsStatus.process => theme.colorText,
          AntStepsStatus.finish => theme.colorText,
          AntStepsStatus.error => theme.colorError,
          AntStepsStatus.wait => theme.colorTextTertiary,
        },
      ),
    );
  }

  Widget _buildDescription(
    AntThemeData theme,
    AntStepsItem item,
    AntStepsStatus stepStatus,
  ) {
    return Text(
      item.description!,
      style: TextStyle(
        fontSize: theme.fontSizeSM,
        color: stepStatus == AntStepsStatus.wait
            ? theme.colorTextQuaternary
            : theme.colorTextSecondary,
      ),
    );
  }

  Widget _buildConnector(
    AntThemeData theme,
    AntStepsStatus fromStatus, {
    required int index,
    bool vertical = false,
  }) {
    final color = fromStatus == AntStepsStatus.finish
        ? theme.colorPrimary
        : theme.colorSplit;

    final key = ValueKey('ant_steps_connector_$index');
    if (vertical) {
      return Container(
        key: key,
        width: _connectorThickness,
        color: color,
      );
    }
    return Container(
      key: key,
      height: _connectorThickness,
      color: color,
    );
  }
}