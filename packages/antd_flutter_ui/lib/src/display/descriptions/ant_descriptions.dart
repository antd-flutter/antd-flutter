/// AntDescriptions — antd React Descriptions 的 Flutter 实现
///
/// API 与 antd React Descriptions 对齐：
/// - [items] — 描述项列表
/// - [title] — 列表标题
/// - [extra] — 列表操作区
/// - [column] — 每行列数
/// - [bordered] — 是否展示边框
/// - [size] — 尺寸
/// - [colon] — 是否显示冒号
/// - [layout] — 布局方向
///
/// ```dart
/// AntDescriptions(
///   title: Text('用户信息'),
///   items: [
///     AntDescriptionsItem(label: '名称', child: Text('张三')),
///     AntDescriptionsItem(label: '手机号', child: Text('138****8888'), span: 2),
///   ],
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/descriptions/ant_descriptions_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/descriptions/ant_descriptions_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntDescriptions
// ============================================================

/// 描述列表 — 成列展示只读字段。
///
/// 对齐 antd React Descriptions 组件。
class AntDescriptions extends StatelessWidget {
  const AntDescriptions({
    super.key,
    required this.items,
    this.title,
    this.extra,
    this.column = 3,
    this.bordered = false,
    this.size = AntDescriptionsSize.middle,
    this.colon = true,
    this.layout = AntDescriptionsLayout.horizontal,
  });

  /// 描述项列表。
  final List<AntDescriptionsItem> items;

  /// 列表标题。
  final Widget? title;

  /// 列表操作区，位于标题右侧。
  final Widget? extra;

  /// 每行的列数。
  final int column;

  /// 是否展示边框（bordered 模式下 label 列带灰底）。
  final bool bordered;

  /// 尺寸。
  final AntDescriptionsSize size;

  /// 是否显示冒号。
  final bool colon;

  /// 布局方向。
  final AntDescriptionsLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final metrics = _resolveMetrics(theme);
    final effectiveColumn = column < 1 ? 1 : column;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标题栏
        if (title != null || extra != null)
          Padding(
            padding: EdgeInsets.only(bottom: 12.w),
            child: Row(
              children: [
                if (title != null)
                  DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: theme.fontSizeLG,
                      fontWeight: FontWeight.w600,
                      color: theme.colorTextHeading,
                    ),
                    child: title!,
                  ),
                const Spacer(),
                if (extra != null)
                  DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: theme.fontSize,
                      color: theme.colorText,
                    ),
                    child: extra!,
                  ),
              ],
            ),
          ),
        // 内容：按 span 切分成行
        ..._buildRows(theme, metrics, effectiveColumn),
      ],
    );
  }

  _DescriptionsMetrics _resolveMetrics(AntThemeData theme) {
    switch (size) {
      case AntDescriptionsSize.large:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          labelFontSize: theme.fontSize,
          contentFontSize: theme.fontSize,
        );
      case AntDescriptionsSize.small:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
          labelFontSize: theme.fontSizeSM,
          contentFontSize: theme.fontSizeSM,
        );
      case AntDescriptionsSize.middle:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          labelFontSize: theme.fontSizeSM,
          contentFontSize: theme.fontSize,
        );
    }
  }

  /// 按 span 把 items 切分成多行。
  List<Widget> _buildRows(
    AntThemeData theme,
    _DescriptionsMetrics metrics,
    int effectiveColumn,
  ) {
    final rows = <Widget>[];
    var index = 0;

    while (index < items.length) {
      final rowItems = <_PlacedItem>[];
      var usedSpan = 0;
      while (index < items.length && usedSpan < effectiveColumn) {
        final item = items[index];
        final span = (item.span < 1 ? 1 : item.span)
            .clamp(1, effectiveColumn - usedSpan);
        rowItems.add(_PlacedItem(item: item, span: span));
        usedSpan += span;
        index++;
      }
      rows.add(
        _DescriptionsRowWidget(
          placedItems: rowItems,
          totalSpan: effectiveColumn,
          bordered: bordered,
          colon: colon,
          vertical: layout == AntDescriptionsLayout.vertical,
          metrics: metrics,
        ),
      );
    }

    return rows;
  }
}

/// 一项及其在本行中实际占用的列数。
class _PlacedItem {
  const _PlacedItem({required this.item, required this.span});

  final AntDescriptionsItem item;
  final int span;
}

class _DescriptionsMetrics {
  const _DescriptionsMetrics({
    required this.cellPadding,
    required this.labelFontSize,
    required this.contentFontSize,
  });

  final EdgeInsets cellPadding;
  final double labelFontSize;
  final double contentFontSize;
}

class _DescriptionsRowWidget extends StatelessWidget {
  const _DescriptionsRowWidget({
    required this.placedItems,
    required this.totalSpan,
    required this.bordered,
    required this.colon,
    required this.vertical,
    required this.metrics,
  });

  final List<_PlacedItem> placedItems;
  final int totalSpan;
  final bool bordered;
  final bool colon;
  final bool vertical;
  final _DescriptionsMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[
      for (final placed in placedItems)
        Expanded(
          flex: placed.span,
          child: _DescriptionsCell(
            item: placed.item,
            bordered: bordered,
            colon: colon,
            vertical: vertical,
            metrics: metrics,
          ),
        ),
    ];

    // 无边框模式补齐空列，保证各行 label 列对齐
    var usedSpan = 0;
    for (final placed in placedItems) {
      usedSpan += placed.span;
    }
    if (!bordered && usedSpan < totalSpan) {
      cells.add(Expanded(
        flex: totalSpan - usedSpan,
        child: const SizedBox.shrink(),
      ),);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cells,
    );
  }
}

/// 单个描述项单元格。
class _DescriptionsCell extends StatelessWidget {
  const _DescriptionsCell({
    required this.item,
    required this.bordered,
    required this.colon,
    required this.vertical,
    required this.metrics,
  });

  final AntDescriptionsItem item;
  final bool bordered;
  final bool colon;
  final bool vertical;
  final _DescriptionsMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    if (bordered) {
      return _buildBorderedCell(theme);
    }
    return _buildPlainCell(theme);
  }

  /// 无边框模式：label 与 content 水平排布。
  Widget _buildPlainCell(AntThemeData theme) {
    if (vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: metrics.cellPadding.horizontal / 2,
          vertical: metrics.cellPadding.vertical / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLabel(theme, theme.colorTextSecondary, showColon: false),
            SizedBox(height: 2.w),
            _buildContent(theme),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.cellPadding.horizontal / 2,
        vertical: metrics.cellPadding.vertical / 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(theme, theme.colorTextSecondary),
          SizedBox(width: 8.w),
          Expanded(child: _buildContent(theme)),
        ],
      ),
    );
  }

  /// 边框模式：label 列灰底，带边框。
  Widget _buildBorderedCell(AntThemeData theme) {
    final border = Border.all(color: theme.colorSplit, width: 1);
    if (vertical) {
      return Container(
        decoration: BoxDecoration(border: border),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: metrics.cellPadding,
              color: theme.colorFillAlter,
              child: _buildLabel(theme, theme.colorText, showColon: false),
            ),
            Container(
              width: double.infinity,
              padding: metrics.cellPadding,
              child: _buildContent(theme),
            ),
          ],
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(border: border),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: metrics.cellPadding,
            color: theme.colorFillAlter,
            child: _buildLabel(theme, theme.colorText, showColon: false),
          ),
          Expanded(
            child: Container(
              padding: metrics.cellPadding,
              child: _buildContent(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(
    AntThemeData theme,
    Color color, {
    bool showColon = true,
  }) {
    final hasColon = showColon && colon;
    return Text(
      '${item.label ?? ''}${hasColon ? ':' : ''}',
      style: TextStyle(
        fontSize: metrics.labelFontSize,
        color: color,
        height: 1.5,
      ),
    );
  }

  Widget _buildContent(AntThemeData theme) {
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: metrics.contentFontSize,
        color: theme.colorText,
        height: 1.5,
      ),
      child: item.child ?? const SizedBox.shrink(),
    );
  }
}
