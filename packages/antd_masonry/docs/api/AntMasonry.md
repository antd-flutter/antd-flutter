<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMasonry

> 种类：类

```dart
class AntMasonry
```

瀑布流布局 — 不同高度内容的多列均匀分布。

对齐 antd React Masonry 组件，适合展示图片、卡片等不规则高度内容。

```dart
AntMasonry(
  columns: 3,
  gutter: 16,
  children: [
    AntMasonryItem(height: 100, child: Card(child: Text('A'))),
    AntMasonryItem(height: 150, child: Card(child: Text('B'))),
    AntMasonryItem(height: 80, child: Card(child: Text('C'))),
  ],
)
```

## 构造函数

### `AntMasonry({super.key, this.columns = 3, this.responsiveColumns, this.gutter = 0, this.verticalGutter, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columns` | `int` | = 3 | — |
| `responsiveColumns` | `AntMasonryResponsive?` | 可选 | — |
| `gutter` | `double` | = 0 | — |
| `verticalGutter` | `double?` | 可选 | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>` | 子项列表 |
| `columns` | `int` | 固定列数 |
| `gutter` | `double` | 列间距（水平方向，逻辑像素，自动缩放） |
| `responsiveColumns` | `AntMasonryResponsive?` | 响应式列数配置 |
| `verticalGutter` | `double?` | 行间距（垂直方向，逻辑像素，自动缩放） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildColumnChildren` | `List<Widget>` | 构建单列子项列表（插入行间距） |
| `_buildStack` | `Widget` | 跨列项的绝对定位布局路径 |
| `build` | `Widget` | — |
| `_distribute` | `List<List<Widget>>` | 将子项分配到各列 |
| `_heightOf` | `double?` | 子项高度提取（贪心分配依据） |
| `_spanOf` | `int` | 子项跨列数提取 |

