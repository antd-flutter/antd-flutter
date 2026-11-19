<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTimeline

> 种类：类

```dart
class AntTimeline
```

时间轴 — 垂直展示的时间流信息。

对齐 antd React Timeline 组件。

## 构造函数

### `AntTimeline({super.key, required this.items, this.mode = AntTimelineMode.left, this.pending = false, this.pendingDot, this.pendingContent, this.reverse = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntTimelineItem>` | 可选 | — |
| `mode` | `AntTimelineMode` | = AntTimelineMode.left | — |
| `pending` | `bool` | = false | — |
| `pendingDot` | `Widget?` | 可选 | — |
| `pendingContent` | `Widget?` | 可选 | — |
| `reverse` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `items` | `List<AntTimelineItem>` | 时间轴项列表 |
| `mode` | `AntTimelineMode` | 模式 |
| `pending` | `bool` | 是否存在待办节点（末尾追加 loading 节点） |
| `pendingContent` | `Widget?` | pending 节点的内容 |
| `pendingDot` | `Widget?` | 自定义 pending 节点 |
| `reverse` | `bool` | 是否倒序展示 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

