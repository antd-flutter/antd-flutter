<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDescriptions

> 种类：类

```dart
class AntDescriptions
```

描述列表 — 成列展示只读字段。

对齐 antd React Descriptions 组件。

## 构造函数

### `AntDescriptions({super.key, required this.items, this.labelBuilder, this.contentBuilder, this.spanOf, this.title, this.extra, this.column = 3, this.bordered = false, this.size = AntDescriptionsSize.middle, this.colon = true, this.layout = AntDescriptionsLayout.horizontal})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `labelBuilder` | `AntDescriptionsLabelBuilder<T>?` | 可选 | — |
| `contentBuilder` | `AntDescriptionsContentBuilder<T>?` | 可选 | — |
| `spanOf` | `int Function(T item)?` | 可选 | — |
| `title` | `Widget?` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `column` | `int` | = 3 | — |
| `bordered` | `bool` | = false | — |
| `size` | `AntDescriptionsSize` | = AntDescriptionsSize.middle | — |
| `colon` | `bool` | = true | — |
| `layout` | `AntDescriptionsLayout` | = AntDescriptionsLayout.horizontal | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bordered` | `bool` | 是否展示边框（bordered 模式下 label 列带灰底） |
| `colon` | `bool` | 是否显示冒号 |
| `column` | `int` | 每行的列数 |
| `contentBuilder` | `AntDescriptionsContentBuilder<T>?` | 描述内容构建器 |
| `extra` | `Widget?` | 列表操作区，位于标题右侧 |
| `items` | `List<T>` | 描述项列表 |
| `labelBuilder` | `AntDescriptionsLabelBuilder<T>?` | 描述标签构建器，未提供时回退为 Text('$item') |
| `layout` | `AntDescriptionsLayout` | 布局方向 |
| `size` | `AntDescriptionsSize` | 尺寸 |
| `spanOf` | `int Function(T item)?` | 占用列数提取器，默认 1 |
| `title` | `Widget?` | 列表标题 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildBorderedHorizontalCell` | `Widget` | 水平 + 边框：label 灰底格 + content 格，right/bottom 画内部分隔线 |
| `_buildContent` | `Widget` | — |
| `_buildHorizontalRow` | `Widget` | 水平布局的一行：每项占 2  span 列，label 固定 1 列宽 |
| `_buildLabel` | `Widget` | — |
| `_buildTable` | `Widget` | — |
| `_buildVerticalBlock` | `Widget` | 垂直布局的一块：label 行 + content 行，跨列方向对齐 |
| `_resolveMetrics` | `_DescriptionsMetrics` | — |
| `_splitRows` | `List<List<_PlacedItem>>` | 按 span 把 items 切分成多行 |
| `build` | `Widget` | — |

