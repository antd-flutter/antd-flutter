<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMasonryItem

> 种类：类

```dart
class AntMasonryItem
```

瀑布流项 — AntMasonry 的子项，可指定高度实现瀑布流分配。

对齐 antd React MasonryItem。提供 `height` 时参与贪心分配
（放入当前最矮列），不提供时按轮询分配；
`span` > 1 时跨列放置（等价 flutter_staggered_grid_view 的
StaggeredTile.count(width, height) 跨列语义）。

```dart
AntMasonryItem(height: 120, child: MyCard())
AntMasonryItem(height: 160, span: 2, child: WideCard())
```

## 构造函数

### `AntMasonryItem({super.key, this.height, this.span = 1, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `height` | `double?` | 可选 | — |
| `span` | `int` | = 1 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 子元素 |
| `height` | `double?` | 项高度（逻辑像素） |
| `span` | `int` | 跨列数（默认 1，最小为 1，实际生效时被列数截断） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

