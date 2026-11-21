<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTimeline

> 种类：类

```dart
class AntTimeline
```

时间轴 — 垂直展示的时间流信息。

对齐 antd React Timeline 组件。

## 构造函数

### `AntTimeline({super.key, required this.items, this.labelBuilder, this.contentBuilder, this.dotBuilder, this.colorOf, this.dotColorOf, this.disabledOf, this.onTap, this.mode = AntTimelineMode.left, this.pending = false, this.pendingDot, this.pendingContent, this.reverse = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `labelBuilder` | `AntTimelineLabelBuilder<T>?` | 可选 | — |
| `contentBuilder` | `AntTimelineContentBuilder<T>?` | 可选 | — |
| `dotBuilder` | `AntTimelineDotBuilder<T>?` | 可选 | — |
| `colorOf` | `AntTimelineColor? Function(T item)?` | 可选 | — |
| `dotColorOf` | `Color? Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `onTap` | `ValueChanged<T>?` | 可选 | — |
| `mode` | `AntTimelineMode` | = AntTimelineMode.left | — |
| `pending` | `bool` | = false | — |
| `pendingDot` | `Widget?` | 可选 | — |
| `pendingContent` | `Widget?` | 可选 | — |
| `reverse` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colorOf` | `AntTimelineColor? Function(T item)?` | 节点颜色预设提取器 |
| `contentBuilder` | `AntTimelineContentBuilder<T>?` | 内容构建器 |
| `disabledOf` | `bool Function(T item)?` | 是否禁用 |
| `dotBuilder` | `AntTimelineDotBuilder<T>?` | 自定义节点构建器 |
| `dotColorOf` | `Color? Function(T item)?` | 自定义节点颜色提取器（自定义节点为空时生效） |
| `items` | `List<T>` | 时间轴项列表 |
| `labelBuilder` | `AntTimelineLabelBuilder<T>?` | 时间标签构建器 |
| `mode` | `AntTimelineMode` | 模式 |
| `onTap` | `ValueChanged<T>?` | 点击回调（禁用时不触发） |
| `pending` | `bool` | 是否存在待办节点（末尾追加 loading 节点） |
| `pendingContent` | `Widget?` | pending 节点的内容 |
| `pendingDot` | `Widget?` | 自定义 pending 节点 |
| `reverse` | `bool` | 是否倒序展示 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

