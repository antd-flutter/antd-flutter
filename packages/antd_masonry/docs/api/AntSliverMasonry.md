<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSliverMasonry

> 种类：类

```dart
class AntSliverMasonry
```

sliver 形态瀑布流 — 供 CustomScrollView 使用的 AntMasonry 变体。

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(title: Text('瀑布流')),
    AntSliverMasonry(
      columns: 3,
      gutter: 16,
      children: [
        AntMasonryItem(height: 120, child: Card(child: Text('A'))),
        AntMasonryItem(height: 160, span: 2, child: Card(child: Text('B'))),
      ],
    ),
  ],
)
```

## 构造函数

### `AntSliverMasonry({super.key, this.columns = 3, this.responsiveColumns, this.gutter = 0, this.verticalGutter, this.fallbackItemHeight = 120, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columns` | `int` | = 3 | — |
| `responsiveColumns` | `AntMasonryResponsive?` | 可选 | — |
| `gutter` | `double` | = 0 | — |
| `verticalGutter` | `double?` | 可选 | — |
| `fallbackItemHeight` | `double` | = 120 | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>` | 子项列表 |
| `columns` | `int` | 固定列数 |
| `fallbackItemHeight` | `double` | 子项未提供 height 时的估算高度（仅贪心分配用） |
| `gutter` | `double` | 列间距（水平方向，逻辑像素，自动缩放） |
| `responsiveColumns` | `AntMasonryResponsive?` | 响应式列数配置 |
| `verticalGutter` | `double?` | 行间距（垂直方向，逻辑像素，自动缩放） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |
| `_heightFallback` | `Widget` | 为未提供高度的子项补一个不可见的基准高度（不影响子项自身渲染） |

