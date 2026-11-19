/// AntMasonry — antd React Masonry 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [AntMasonry] — 瀑布流布局容器
///   - [AntMasonry.columns] — 列数（默认 3）
///   - [AntMasonry.responsiveColumns] — 响应式列数（优先于 columns）
///   - [AntMasonry.gutter] — 列间距
///   - [AntMasonry.verticalGutter] — 行间距（默认同 gutter）
///   - [AntMasonry.children] — 子项，推荐使用 [AntMasonryItem] 包裹
/// - [AntMasonryItem] — 瀑布流项（可指定 height 实现贪心分配、span 跨列）
///
/// 子项分配策略（对照 flutter_staggered_grid_view 的最短列优先算法）：
/// 任一子项提供 height 时按贪心算法分配到最矮列（瀑布流效果），
/// 全部未提供时按轮询分配；[AntMasonryItem.span] > 1 的项跨列放置。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_masonry_layout.dart';
import 'ant_masonry_types.dart';

// ============================================================
// AntMasonry
// ============================================================

/// 瀑布流布局 — 不同高度内容的多列均匀分布。
///
/// 对齐 antd React Masonry 组件，适合展示图片、卡片等不规则高度内容。
///
/// ```dart
/// AntMasonry(
///   columns: 3,
///   gutter: 16,
///   children: [
///     AntMasonryItem(height: 100, child: Card(child: Text('A'))),
///     AntMasonryItem(height: 150, child: Card(child: Text('B'))),
///     AntMasonryItem(height: 80, child: Card(child: Text('C'))),
///   ],
/// )
/// ```
class AntMasonry extends StatelessWidget {
  const AntMasonry({
    super.key,
    this.columns = 3,
    this.responsiveColumns,
    this.gutter = 0,
    this.verticalGutter,
    this.children = const [],
  });

  /// 固定列数。默认 3。[responsiveColumns] 非 null 时被覆盖。
  final int columns;

  /// 响应式列数配置。非 null 时根据容器宽度自动选择列数。
  final AntMasonryResponsive? responsiveColumns;

  /// 列间距（水平方向，逻辑像素，自动缩放）。
  final double gutter;

  /// 行间距（垂直方向，逻辑像素，自动缩放）。为 null 时同 gutter。
  final double? verticalGutter;

  /// 子项列表。推荐用 [AntMasonryItem] 包裹以指定高度。
  final List<Widget> children;

  /// 子项高度提取（贪心分配依据）。
  static double? _heightOf(Widget item) =>
      item is AntMasonryItem ? item.height : null;

  /// 子项跨列数提取。
  static int _spanOf(Widget item) =>
      item is AntMasonryItem ? item.span : 1;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final hGutter = gutter.w;
    final vGutter = (verticalGutter ?? gutter).w;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 解析列数
        final responsive = responsiveColumns;
        final colCount = responsive != null
            ? responsive.resolve(constraints.maxWidth, fallback: columns)
            : columns;

        if (colCount <= 0) return const SizedBox.shrink();

        // 有跨列项时走绝对定位路径（等价 staggered span tile 语义）
        final hasSpan = children.any((w) => _spanOf(w) > 1);
        if (hasSpan) {
          return _buildStack(constraints, colCount, hGutter, vGutter);
        }

        // 分配子项到各列
        final cols = _distribute(children, colCount);

        // 构建列
        final colWidgets = <Widget>[];
        for (var i = 0; i < colCount; i++) {
          if (i > 0 && hGutter > 0) {
            colWidgets.add(SizedBox(width: hGutter));
          }
          colWidgets.add(
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildColumnChildren(cols[i], vGutter),
              ),
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: colWidgets,
        );
      },
    );
  }

  /// 跨列项的绝对定位布局路径。
  Widget _buildStack(
    BoxConstraints constraints,
    int colCount,
    double hGutter,
    double vGutter,
  ) {
    final cross = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : double.infinity;
    if (!cross.isFinite) return const SizedBox.shrink();
    final cellWidth = (cross - (colCount - 1) * hGutter) / colCount;
    final result = masonryLayout(
      itemCount: children.length,
      heightOf: (i) => _heightOf(children[i]),
      spanOf: (i) => _spanOf(children[i]),
      columns: colCount,
      cellWidth: cellWidth,
      hGutter: hGutter,
      vGutter: vGutter,
    );
    return SizedBox(
      height: result.totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final place in result.places)
            Positioned(
              left: place.offsetX,
              top: place.offsetY,
              width: place.width,
              child: children[place.index],
            ),
        ],
      ),
    );
  }

  /// 构建单列子项列表（插入行间距）。
  List<Widget> _buildColumnChildren(List<Widget> items, double vGutter) {
    if (items.isEmpty) return const [];
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0 && vGutter > 0) {
        result.add(SizedBox(height: vGutter));
      }
      result.add(items[i]);
    }
    return result;
  }

  /// 将子项分配到各列。
  ///
  /// 任一子项提供 height 时启用贪心分配（放入最矮列），
  /// 全部未提供时按轮询分配。
  static List<List<Widget>> _distribute(List<Widget> items, int colCount) {
    final cols = List.generate(colCount, (_) => <Widget>[]);
    final heights = List<double>.filled(colCount, 0);

    // 提取高度信息
    final itemHeights = List<double?>.generate(
      items.length,
      (i) => _heightOf(items[i]),
    );
    final anyHasHeight = itemHeights.any((h) => h != null);

    for (var i = 0; i < items.length; i++) {
      int targetCol;
      if (anyHasHeight) {
        // 贪心分配：放入当前最矮的列
        targetCol = 0;
        for (var c = 1; c < colCount; c++) {
          if (heights[c] < heights[targetCol]) {
            targetCol = c;
          }
        }
        heights[targetCol] += itemHeights[i] ?? 0;
      } else {
        // 轮询分配
        targetCol = i % colCount;
      }
      cols[targetCol].add(items[i]);
    }

    return cols;
  }
}

// ============================================================
// AntMasonryItem
// ============================================================

/// 瀑布流项 — AntMasonry 的子项，可指定高度实现瀑布流分配。
///
/// 对齐 antd React MasonryItem。提供 [height] 时参与贪心分配
/// （放入当前最矮列），不提供时按轮询分配；
/// [span] > 1 时跨列放置（等价 flutter_staggered_grid_view 的
/// StaggeredTile.count(width, height) 跨列语义）。
///
/// ```dart
/// AntMasonryItem(height: 120, child: MyCard())
/// AntMasonryItem(height: 160, span: 2, child: WideCard())
/// ```
class AntMasonryItem extends StatelessWidget {
  const AntMasonryItem({
    super.key,
    this.height,
    this.span = 1,
    this.child,
  });

  /// 项高度（逻辑像素）。用于瀑布流贪心分配。
  final double? height;

  /// 跨列数（默认 1，最小为 1，实际生效时被列数截断）。
  final int span;

  /// 子元素。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}
