<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTimelineItem

> 种类：类

```dart
class AntTimelineItem
```

时间轴的每一项。

对齐 antd React Timeline `items` 中的 item。

## 构造函数

### `AntTimelineItem({this.label, this.content, this.color, this.customDot, this.dotColor, this.disabled = false, this.onTap})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `label` | `String?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `color` | `AntTimelineColor?` | 可选 | — |
| `customDot` | `Widget?` | 可选 | — |
| `dotColor` | `Color?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `onTap` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `color` | `AntTimelineColor?` | 节点颜色预设 |
| `content` | `Widget?` | 内容 |
| `customDot` | `Widget?` | 自定义节点 |
| `disabled` | `bool` | 是否禁用 |
| `dotColor` | `Color?` | 自定义节点颜色（customDot 为空时生效） |
| `label` | `String?` | 时间标签（独立于内容的标签列） |
| `onTap` | `VoidCallback?` | 点击回调（disabled 时不可触发） |

