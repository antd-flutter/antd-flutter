/// AntSliverMasonry — AntMasonry 的 sliver 变体（R33 强制项）。
///
/// Masonry 属滚动集合类组件，必须提供 sliver 形态供 CustomScrollView 使用。
/// 本变体可与其他 sliver（SliverAppBar / SliverList / SliverToBoxAdapter 等）
/// 在同一 CustomScrollView 中组合，跟随整体滚动与 SliverAppBar 折叠。
///
/// sliver 支持形态说明（对照 flutter_staggered_grid_view 的 SliverMasonryGrid）：
/// - 本变体基于共享布局引擎（最短列优先 + span 跨列）计算各项绝对位置，
///   以 sliver（SliverToBoxAdapter 承载布局容器）的形式参与 CustomScrollView 组合。
/// - 当前为非懒加载实现：全部子项一次性布局。懒加载虚拟化（按视口增量挂载）
///   为后续吸收 flutter_staggered_grid_view RenderSliverMasonryGrid 的增强项，
///   API 已按 sliver 形态对齐，后续升级不破坏调用方。
/// - 贪心分配依赖子项高度：子项应为 [AntMasonryItem] 并提供 [AntMasonryItem.height]；
///   未提供高度的项按 [AntSliverMasonry.fallbackItemHeight] 估算。
library;

import 'package:flutter/widgets.dart';

import 'ant_masonry.dart';
import 'ant_masonry_types.dart';

/// sliver 形态瀑布流 — 供 CustomScrollView 使用的 AntMasonry 变体。
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     const SliverAppBar(title: Text('瀑布流')),
///     AntSliverMasonry(
///       columns: 3,
///       gutter: 16,
///       children: [
///         AntMasonryItem(height: 120, child: Card(child: Text('A'))),
///         AntMasonryItem(height: 160, span: 2, child: Card(child: Text('B'))),
///       ],
///     ),
///   ],
/// )
/// ```
class AntSliverMasonry extends StatelessWidget {
  const AntSliverMasonry({
    super.key,
    this.columns = 3,
    this.responsiveColumns,
    this.gutter = 0,
    this.verticalGutter,
    this.fallbackItemHeight = 120,
    this.children = const [],
  });

  /// 固定列数。默认 3。[responsiveColumns] 非 null 时被覆盖。
  final int columns;

  /// 响应式列数配置。非 null 时根据视口宽度自动选择列数。
  final AntMasonryResponsive? responsiveColumns;

  /// 列间距（水平方向，逻辑像素，自动缩放）。
  final double gutter;

  /// 行间距（垂直方向，逻辑像素，自动缩放）。为 null 时同 gutter。
  final double? verticalGutter;

  /// 子项未提供 height 时的估算高度（仅贪心分配用）。
  final double fallbackItemHeight;

  /// 子项列表。推荐用 [AntMasonryItem] 提供 height。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: AntMasonry(
        columns: columns,
        responsiveColumns: responsiveColumns,
        gutter: gutter,
        verticalGutter: verticalGutter,
        children: [
          for (final child in children)
            _heightFallback(child, fallbackItemHeight),
        ],
      ),
    );
  }

  /// 为未提供高度的子项补一个不可见的基准高度（不影响子项自身渲染）。
  static Widget _heightFallback(Widget child, double fallback) {
    if (child is AntMasonryItem && child.height != null) return child;
    if (child is AntMasonryItem) {
      return AntMasonryItem(
        key: child.key,
        height: fallback,
        span: child.span,
        child: child.child,
      );
    }
    return child;
  }
}
