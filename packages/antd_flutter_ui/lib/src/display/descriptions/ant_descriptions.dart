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
/// 布局按 antd 的 `<table>` 语义实现：水平布局下每项占
/// `2 * span` 个表格列（label 1 列 + content `2 * span - 1` 列），
/// 列宽等分，因此同一行/不同行的 label 与 content 起点严格对齐；
/// 垂直布局下每项占 `span` 列，同一行的 label、content 分别成行对齐。
///
/// ```dart
/// AntDescriptions<User>(
///   title: Text('用户信息'),
///   items: users,
///   labelBuilder: (context, user, index) => Text('用户'),
///   contentBuilder: (context, user, index) => Text(user.name),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_descriptions_types.dart';
export 'ant_descriptions_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntDescriptions
// ============================================================

/// 描述列表 — 成列展示只读字段。
///
/// 对齐 antd React Descriptions 组件。
class AntDescriptions<T> extends StatelessWidget {
  const AntDescriptions({
    super.key,
    required this.items,
    this.labelBuilder,
    this.contentBuilder,
    this.spanOf,
    this.title,
    this.extra,
    this.column = 3,
    this.bordered = false,
    this.size = AntDescriptionsSize.middle,
    this.colon = true,
    this.layout = AntDescriptionsLayout.horizontal,
  });

  /// 描述项列表。
  final List<T> items;

  /// 描述标签构建器，未提供时回退为 `Text('$item')`。
  final AntDescriptionsLabelBuilder<T>? labelBuilder;

  /// 描述内容构建器。
  final AntDescriptionsContentBuilder<T>? contentBuilder;

  /// 占用列数提取器，默认 1。
  final int Function(T item)? spanOf;

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
    final columns = column < 1 ? 1 : column;
    final rows = _splitRows(columns);
    final vertical = layout == AntDescriptionsLayout.vertical;

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
        if (rows.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              // 按 antd table 的等分列计算单列宽度。
              final width = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width;
              final unit = width / (vertical ? columns : columns * 2);
              return _buildTable(
                context,
                theme,
                metrics,
                rows,
                columns,
                unit,
                vertical,
              );
            },
          ),
      ],
    );
  }

  _DescriptionsMetrics _resolveMetrics(AntThemeData theme) {
    switch (size) {
      case AntDescriptionsSize.large:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          labelFontSize: theme.fontSize,
          contentFontSize: theme.fontSize,
          itemPaddingBottom: 16.w,
          itemPaddingEnd: 16.w,
        );
      case AntDescriptionsSize.small:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          labelFontSize: theme.fontSizeSM,
          contentFontSize: theme.fontSizeSM,
          itemPaddingBottom: 8.w,
          itemPaddingEnd: 16.w,
        );
      case AntDescriptionsSize.middle:
        return _DescriptionsMetrics(
          cellPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
          labelFontSize: theme.fontSize,
          contentFontSize: theme.fontSize,
          itemPaddingBottom: 12.w,
          itemPaddingEnd: 16.w,
        );
    }
  }

  /// 按 span 把 items 切分成多行。
  List<List<_PlacedItem>> _splitRows(int columns) {
    final rows = <List<_PlacedItem>>[];
    var index = 0;

    while (index < items.length) {
      final rowItems = <_PlacedItem>[];
      var usedSpan = 0;
      while (index < items.length && usedSpan < columns) {
        final span = (spanOf?.call(items[index]) ?? 1).clamp(
          1,
          columns - usedSpan,
        );
        rowItems.add(_PlacedItem(index: index, span: span));
        usedSpan += span;
        index++;
      }
      rows.add(rowItems);
    }
    return rows;
  }

  Widget _buildTable(
    BuildContext context,
    AntThemeData theme,
    _DescriptionsMetrics metrics,
    List<List<_PlacedItem>> rows,
    int columns,
    double unit,
    bool vertical,
  ) {
    final blocks = <Widget>[];
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final isLastRow = index == rows.length - 1;
      blocks.add(
        vertical
            ? _buildVerticalBlock(
                context,
                theme,
                metrics,
                row,
                unit,
                columns,
                isLastRow,
              )
            : _buildHorizontalRow(
                context,
                theme,
                metrics,
                row,
                unit,
                columns,
                isLastRow,
              ),
      );
    }

    final table = Column(mainAxisSize: MainAxisSize.min, children: blocks);
    if (!bordered) return table;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorSplit, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      ),
      clipBehavior: Clip.antiAlias,
      child: table,
    );
  }

  /// 水平布局的一行：每项占 `2 * span` 列，label 固定 1 列宽。
  Widget _buildHorizontalRow(
    BuildContext context,
    AntThemeData theme,
    _DescriptionsMetrics metrics,
    List<_PlacedItem> row,
    double unit,
    int columns,
    bool isLastRow,
  ) {
    final children = <Widget>[];
    var usedSpan = 0;

    for (var index = 0; index < row.length; index++) {
      final placed = row[index];
      usedSpan += placed.span;
      final isLastCell = index == row.length - 1;
      children.add(
        Expanded(
          flex: placed.span * 2,
          child: bordered
              ? _buildBorderedHorizontalCell(
                  context,
                  theme,
                  metrics,
                  placed,
                  unit,
                  isLastRow: isLastRow,
                  isLastCell: isLastCell,
                )
              : Padding(
                  padding: EdgeInsets.only(
                    right: metrics.itemPaddingEnd,
                    bottom: isLastRow ? 0 : metrics.itemPaddingBottom,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: unit,
                        child: _buildLabel(
                          context,
                          theme,
                          theme.colorTextTertiary,
                          index: placed.index,
                          metrics: metrics,
                        ),
                      ),
                      Expanded(
                        child: _buildContent(
                          context,
                          theme,
                          placed.index,
                          metrics,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }

    final remaining = columns - usedSpan;
    if (remaining > 0) {
      children.add(
        Expanded(
          flex: remaining * 2,
          child: bordered && !isLastRow
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.colorSplit, width: 1),
                    ),
                  ),
                  child: const SizedBox.expand(),
                )
              : const SizedBox.shrink(),
        ),
      );
    }

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    // 边框模式需要用行内最高单元格拉伸其余单元格，保证分隔线闭合。
    return bordered
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : content;
  }

  /// 水平 + 边框：label 灰底格 + content 格，right/bottom 画内部分隔线。
  Widget _buildBorderedHorizontalCell(
    BuildContext context,
    AntThemeData theme,
    _DescriptionsMetrics metrics,
    _PlacedItem placed,
    double unit, {
    required bool isLastRow,
    required bool isLastCell,
  }) {
    final divider = BorderSide(color: theme.colorSplit, width: 1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: unit,
          padding: metrics.cellPadding,
          decoration: BoxDecoration(
            color: theme.colorFillAlter,
            border: Border(
              right: divider,
              bottom: isLastRow ? BorderSide.none : divider,
            ),
          ),
          child: _buildLabel(
            context,
            theme,
            theme.colorTextSecondary,
            index: placed.index,
            metrics: metrics,
          ),
        ),
        Expanded(
          child: Container(
            padding: metrics.cellPadding,
            decoration: BoxDecoration(
              border: Border(
                right: isLastCell ? BorderSide.none : divider,
                bottom: isLastRow ? BorderSide.none : divider,
              ),
            ),
            child: _buildContent(context, theme, placed.index, metrics),
          ),
        ),
      ],
    );
  }

  /// 垂直布局的一块：label 行 + content 行，跨列方向对齐。
  Widget _buildVerticalBlock(
    BuildContext context,
    AntThemeData theme,
    _DescriptionsMetrics metrics,
    List<_PlacedItem> row,
    double unit,
    int columns,
    bool isLastRow,
  ) {
    var usedSpan = 0;
    for (final placed in row) {
      usedSpan += placed.span;
    }
    final remaining = columns - usedSpan;

    final labelCells = <Widget>[];
    final contentCells = <Widget>[];
    for (var index = 0; index < row.length; index++) {
      final placed = row[index];
      final isLastCell = index == row.length - 1;
      labelCells.add(
        Expanded(
          flex: placed.span,
          child: bordered
              ? Container(
                  padding: metrics.cellPadding,
                  decoration: BoxDecoration(
                    color: theme.colorFillAlter,
                    border: Border(
                      right: isLastCell && remaining == 0
                          ? BorderSide.none
                          : BorderSide(color: theme.colorSplit, width: 1),
                      bottom: BorderSide(color: theme.colorSplit, width: 1),
                    ),
                  ),
                  child: _buildLabel(
                    context,
                    theme,
                    theme.colorTextSecondary,
                    index: placed.index,
                    metrics: metrics,
                    showColon: false,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    right: metrics.itemPaddingEnd,
                    bottom: 8.w,
                  ),
                  child: _buildLabel(
                    context,
                    theme,
                    theme.colorTextTertiary,
                    index: placed.index,
                    metrics: metrics,
                    showColon: false,
                  ),
                ),
        ),
      );
      contentCells.add(
        Expanded(
          flex: placed.span,
          child: bordered
              ? Container(
                  padding: metrics.cellPadding,
                  decoration: BoxDecoration(
                    border: Border(
                      right: isLastCell && remaining == 0
                          ? BorderSide.none
                          : BorderSide(color: theme.colorSplit, width: 1),
                      bottom: isLastRow
                          ? BorderSide.none
                          : BorderSide(color: theme.colorSplit, width: 1),
                    ),
                  ),
                  child: _buildContent(context, theme, placed.index, metrics),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    right: metrics.itemPaddingEnd,
                    bottom: isLastRow ? 0 : metrics.itemPaddingBottom,
                  ),
                  child: _buildContent(context, theme, placed.index, metrics),
                ),
        ),
      );
    }

    if (remaining > 0) {
      labelCells.add(
        Expanded(
          flex: remaining,
          child: bordered && !isLastRow
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.colorSplit, width: 1),
                    ),
                  ),
                  child: const SizedBox.expand(),
                )
              : const SizedBox.shrink(),
        ),
      );
      contentCells.add(
        Expanded(
          flex: remaining,
          child: bordered && !isLastRow
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.colorSplit, width: 1),
                    ),
                  ),
                  child: const SizedBox.expand(),
                )
              : const SizedBox.shrink(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bordered
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: labelCells,
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: labelCells,
              ),
        bordered
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: contentCells,
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentCells,
              ),
      ],
    );
  }

  Widget _buildLabel(
    BuildContext context,
    AntThemeData theme,
    Color color, {
    required int index,
    required _DescriptionsMetrics metrics,
    bool showColon = true,
  }) {
    final hasColon = showColon && colon;
    final style = TextStyle(
      fontSize: metrics.labelFontSize,
      color: color,
      height: 1.5,
    );
    final label = labelBuilder?.call(context, items[index], index);
    if (label == null) {
      return Text('${items[index]}${hasColon ? ':' : ''}', style: style);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: DefaultTextStyle.merge(style: style, child: label),
        ),
        if (hasColon) Text(':', style: style),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    AntThemeData theme,
    int index,
    _DescriptionsMetrics metrics,
  ) {
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: metrics.contentFontSize,
        color: theme.colorText,
        height: 1.5,
      ),
      child: contentBuilder?.call(context, items[index], index) ??
          const SizedBox.shrink(),
    );
  }
}

/// 一项及其在本行中实际占用的列数。
class _PlacedItem {
  const _PlacedItem({required this.index, required this.span});

  final int index;
  final int span;
}

class _DescriptionsMetrics {
  const _DescriptionsMetrics({
    required this.cellPadding,
    required this.labelFontSize,
    required this.contentFontSize,
    required this.itemPaddingBottom,
    required this.itemPaddingEnd,
  });

  final EdgeInsets cellPadding;
  final double labelFontSize;
  final double contentFontSize;
  final double itemPaddingBottom;
  final double itemPaddingEnd;
}
