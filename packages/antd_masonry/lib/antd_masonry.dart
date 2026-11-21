/// antd_masonry — Ant Design v6 Masonry 独立组件包（滚动集合类，含 sliver 变体）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntMasonry] — 瀑布流布局容器（列数/响应式列数/间距/贪心最短列分配）
/// - [AntMasonryItem] — 瀑布流项（height 参与贪心分配、span 跨列）
/// - [AntMasonryResponsive] — 响应式列数配置（断点对齐 antd 栅格）
/// - [AntSliverMasonry] — sliver 变体，供 CustomScrollView 使用（R33 强制项）
///
/// 依赖方向约定：antd_masonry → antd_theme（+ material_ui），
/// 不依赖主包 antd_flutter_plus；主包通过 export re-export 保持零符号破坏。
///
/// ```dart
/// import 'package:antd_masonry/antd_masonry.dart';
///
/// AntMasonry(
///   columns: 3,
///   gutter: 16,
///   children: [
///     AntMasonryItem(height: 120, child: Card(child: Text('A'))),
///     AntMasonryItem(height: 180, span: 2, child: Card(child: Text('B'))),
///   ],
/// );
/// ```
///
/// sliver 形态（CustomScrollView + SliverAppBar 组合）：
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     const SliverAppBar(title: Text('瀑布流')),
///     AntSliverMasonry(
///       columns: 3,
///       gutter: 16,
///       children: [AntMasonryItem(height: 100, child: ...)],
///     ),
///   ],
/// );
/// ```
library;

export 'src/masonry/ant_masonry.dart';
export 'src/masonry/ant_masonry_types.dart';
export 'src/masonry/ant_sliver_masonry.dart';
