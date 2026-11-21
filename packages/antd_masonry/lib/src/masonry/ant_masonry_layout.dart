/// 瀑布流布局引擎（内部共享）。
///
/// 算法对照 flutter_staggered_grid_view（MIT，参考实现，未引入三方依赖）：
/// - 最短列优先（best-fit）：span == 1 的项放入当前累计高度最矮的列，
///   与 flutter_staggered_grid_view `SliverMasonryGrid` 的逐项放置策略一致；
///   全部项未提供高度时退化为交错（round-robin）分配，与拆分前主包行为一致。
/// - 跨列 span：连续 k 列的窗口内取最大累计高度作为放置基线，
///   放置后窗口内所有列对齐到同一高度（等价 staggered 的 span tile 语义）。
library;

/// 单个瀑布流项的计算结果（放置位置与尺寸）。
class MasonryPlace {
  const MasonryPlace({
    required this.index,
    required this.col,
    required this.span,
    required this.offsetX,
    required this.offsetY,
    required this.width,
  });

  /// 子项在 children 中的下标。
  final int index;

  /// 起始列。
  final int col;

  /// 跨列数。
  final int span;

  /// 相对容器左上角的横向偏移。
  final double offsetX;

  /// 相对容器左上角的纵向偏移。
  final double offsetY;

  /// 项宽（含跨列的中间列间距）。
  final double width;
}

/// 一次瀑布流布局的计算结果。
class MasonryLayoutResult {
  const MasonryLayoutResult(this.places, this.totalHeight);

  /// 各项的放置信息。
  final List<MasonryPlace> places;

  /// 布局总高度（不含末行行距）。
  final double totalHeight;
}

/// 瀑布流分配算法。
MasonryLayoutResult masonryLayout({
  required int itemCount,
  required double? Function(int index) heightOf,
  required int Function(int index) spanOf,
  required int columns,
  required double cellWidth,
  required double hGutter,
  required double vGutter,
}) {
  final heights = List<double>.filled(columns, 0);
  final places = <MasonryPlace>[];

  for (var i = 0; i < itemCount; i++) {
    final span = spanOf(i).clamp(1, columns);
    final itemHeight = heightOf(i);

    int col;
    double baseY;
    if (span == columns) {
      // 整行项：所有列取最大高度。
      col = 0;
      baseY = heights.reduce((a, b) => a > b ? a : b);
    } else if (itemHeight != null) {
      // 有高度：贪心放置。
      if (span == 1) {
        col = 0;
        for (var c = 1; c < columns; c++) {
          if (heights[c] < heights[col]) col = c;
        }
        baseY = heights[col];
      } else {
        // 跨列窗口：找连续 span 列中「窗口最大高度」最小的窗口（最矮窗口优先）。
        col = 0;
        baseY = double.infinity;
        for (var c = 0; c <= columns - span; c++) {
          var windowMax = heights[c];
          for (var k = 1; k < span; k++) {
            if (heights[c + k] > windowMax) windowMax = heights[c + k];
          }
          if (windowMax < baseY) {
            col = c;
            baseY = windowMax;
          }
        }
      }
    } else {
      // 无高度：交错分配（round-robin，保持拆分前主包行为）。
      col = i % columns;
      if (col + span > columns) col = 0;
      baseY = heights[col];
    }

    final width = span * cellWidth + (span - 1) * hGutter;
    places.add(MasonryPlace(
      index: i,
      col: col,
      span: span,
      offsetX: col * (cellWidth + hGutter),
      offsetY: baseY,
      width: width,
    ),);

    if (itemHeight != null) {
      final newY = baseY + itemHeight + vGutter;
      for (var k = 0; k < span; k++) {
        heights[col + k] = newY;
      }
    }
  }

  var totalHeight = 0.0;
  for (final h in heights) {
    if (h > totalHeight) totalHeight = h;
  }
  if (totalHeight > vGutter) totalHeight -= vGutter;

  return MasonryLayoutResult(places, totalHeight);
}
