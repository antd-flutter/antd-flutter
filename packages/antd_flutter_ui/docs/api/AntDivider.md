<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDivider

> 种类：类

```dart
class AntDivider
```

分割线 — 区隔内容的分割线。

对不同段落文本元素进行分割，也可用于页面内垂直分割。

```dart
AntDivider() // 水平实线
AntDivider(child: Text('标题')) // 带标题
AntDivider(type: AntDividerType.vertical) // 垂直
AntDivider(variant: AntDividerVariant.dashed) // 虚线
```

## 构造函数

### `AntDivider({super.key, this.type = AntDividerType.horizontal, this.orientation = AntDividerOrientation.center, this.orientationMargin, this.plain = false, this.variant = AntDividerVariant.solid, this.dashed = false, this.child, this.color, this.thickness, this.indent, this.endIndent, this.spacing})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `type` | `AntDividerType` | = AntDividerType.horizontal | — |
| `orientation` | `AntDividerOrientation` | = AntDividerOrientation.center | — |
| `orientationMargin` | `double?` | 可选 | — |
| `plain` | `bool` | = false | — |
| `variant` | `AntDividerVariant` | = AntDividerVariant.solid | — |
| `dashed` | `bool` | = false | — |
| `child` | `Widget?` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `thickness` | `double?` | 可选 | — |
| `indent` | `double?` | 可选 | — |
| `endIndent` | `double?` | 可选 | — |
| `spacing` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 标题内容 |
| `color` | `Color?` | 自定义分割线颜色（默认 colorSplit） |
| `dashed` | `bool` | 虚线便捷属性 |
| `endIndent` | `double?` | 水平分割线右侧缩进 |
| `indent` | `double?` | 水平分割线左侧缩进 |
| `orientation` | `AntDividerOrientation` | 标题位置（仅水平分割线带 child 时生效） |
| `orientationMargin` | `double?` | 标题与边缘的边距 |
| `plain` | `bool` | 文字是否显示为普通正文样式（字号更小、颜色更淡） |
| `spacing` | `double?` | 水平分割线上下间距（默认 marginLG） |
| `thickness` | `double?` | 自定义线条粗细（默认 lineWidth） |
| `type` | `AntDividerType` | 分割线类型 |
| `variant` | `AntDividerVariant` | 线条样式变体 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildHorizontal` | `Widget` | 构建水平分割线 |
| `_buildSegmentedLine` | `List<Widget>` | 根据方向构建 线段, 标题, 线段 布局 |
| `_buildVertical` | `Widget` | 构建垂直分割线 |
| `build` | `Widget` | — |

