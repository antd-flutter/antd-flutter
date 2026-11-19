# antd_masonry

Ant Design v6 Masonry 组件的 Flutter 实现 — 瀑布流布局，支持贪心最短列分配（瀑布流效果）、轮询交错分配、响应式列数、列/行间距、跨列 span 项，及 sliver 变体 AntSliverMasonry（供 CustomScrollView 使用），API 对齐 antd React Masonry。

> 当前为预览版本。

> R33 判定：Masonry 是滚动集合类组件——按规则必须提供 sliver 变体 [AntSliverMasonry]，供 CustomScrollView 与 SliverAppBar 等其他 sliver 组合使用。
> **sliver 支持形态**：AntSliverMasonry 基于共享瀑布流布局引擎（最短列优先 + span 跨列）计算各项绝对位置，以 sliver 形式（SliverToBoxAdapter 承载布局容器）参与 CustomScrollView 组合；当前为非懒加载实现（全部子项一次性布局），懒加载虚拟化（对照 flutter_staggered_grid_view 的 RenderSliverMasonryGrid）为后续增强项，API 已按 sliver 形态对齐，后续升级不破坏调用方。

> R30.1 轮子参考（迁移即改造评估）：flutter_staggered_grid_view（MIT）。**未引入三方依赖，自绘实现对照吸收**，详见下方「轮子对照」。

> R35 判定（Controller 评估）：Masonry 为纯布局容器，无内部程序化操作语义——滚动到指定位置由外层滚动容器（CustomScrollView / SingleChildScrollView 的 `ScrollController`）承担；刷新（动态添加/清空）通过数据列表 setState 替换实现（见 example「动态添加」分区）。无 imperative Controller 语义需求，**不引入 AntMasonryController**。

## 安装

```yaml
dependencies:
  antd_masonry: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_masonry/antd_masonry.dart';

// ── 基础瀑布流（贪心最短列分配） ────────────────────────
AntMasonry(
  columns: 3,
  gutter: 16,
  children: [
    AntMasonryItem(height: 100, child: Card(child: Text('A'))),
    AntMasonryItem(height: 150, child: Card(child: Text('B'))),
    AntMasonryItem(height: 80, child: Card(child: Text('C'))),
  ],
);

// ── 响应式列数（断点对齐 antd 栅格 xs/sm/md/lg/xl/xxl） ──
AntMasonry(
  responsiveColumns: AntMasonryResponsive(xs: 1, sm: 2, lg: 3, xl: 4),
  gutter: 16,
  children: items,
);

// ── 跨列 span 项 ────────────────────────────────────────
AntMasonry(
  columns: 3,
  gutter: 16,
  children: [
    AntMasonryItem(height: 120, child: ...),
    AntMasonryItem(height: 160, span: 2, child: WideCard()), // 占 2 列
  ],
);

// ── sliver 变体：CustomScrollView + SliverAppBar 组合 ────
CustomScrollView(
  slivers: [
    const SliverAppBar(title: Text('瀑布流')),
    AntSliverMasonry(
      columns: 3,
      gutter: 16,
      children: [
        AntMasonryItem(height: 100, child: ...),
        AntMasonryItem(height: 160, span: 2, child: ...),
      ],
    ),
  ],
);
```

## 轮子对照（R30.1：flutter_staggered_grid_view，MIT）

| 能力 | flutter_staggered_grid_view | antd_masonry 现状 | 处置 |
| --- | --- | --- | --- |
| 列分配算法 | 最短列优先（逐项放置） | 有高度项贪心最短列优先，无高度项 round-robin 交错 | 已对齐，自绘实现 |
| 跨列 span | StaggeredTile.count(w, h) 跨列 tile | `AntMasonryItem.span`，跨列窗口取最大高度对齐放置 | 已吸收（span>1 走绝对定位路径） |
| 响应式列数 | 需手工按宽度传列数 | `AntMasonryResponsive` 断点列数 | 原生更强 |
| sliver 懒加载 | RenderSliverMasonryGrid 增量挂载 | sliver 形态组合可用，非懒加载 | 缺口：懒加载虚拟化为后续增强项（见 R33 判定） |
| 间距 | mainAxisSpacing/crossAxisSpacing | gutter / verticalGutter | 语义等价 |

## 依赖方向

antd_masonry → antd_theme、material_ui；不依赖主包 antd_flutter_plus。主包通过 export re-export 保持符号兼容。
