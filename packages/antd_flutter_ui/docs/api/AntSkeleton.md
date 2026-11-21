<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSkeleton

> 种类：类

```dart
class AntSkeleton
```

骨架屏 — 在需要等待加载内容的位置提供一个占位图形组合。

对齐 antd React Skeleton 组件。

## 构造函数

### `AntSkeleton({super.key, this.loading = false, this.active = true, this.round = false, this.avatar, this.title, this.paragraph, this.children, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `loading` | `bool` | = false | — |
| `active` | `bool` | = true | — |
| `round` | `bool` | = false | — |
| `avatar` | `AntSkeletonAvatar?` | 可选 | — |
| `title` | `AntSkeletonTitle?` | 可选 | — |
| `paragraph` | `AntSkeletonParagraph?` | 可选 | — |
| `children` | `List<Widget>?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `active` | `bool` | 是否显示闪烁动画 |
| `avatar` | `AntSkeletonAvatar?` | 头像占位配置 |
| `child` | `Widget?` | 实际内容（loading=false 时展示） |
| `children` | `List<Widget>?` | 自定义骨架元素（设置后替代默认 avatar/title/paragraph 组合） |
| `loading` | `bool` | 为 true 时显示骨架屏，为 false 时显示 child |
| `paragraph` | `AntSkeletonParagraph?` | 段落占位配置 |
| `round` | `bool` | 圆角风格 |
| `title` | `AntSkeletonTitle?` | 标题占位配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_paragraphRowWidth` | `double` | 段落行宽度策略：最后一行缩短，其余行递进变化 |
| `_wrapPulse` | `Widget` | active 时包一层闪烁动画容器，否则原样返回 |
| `build` | `Widget` | — |
| `radiusOf` | `double` | 圆角半径（round 模式使用全圆角胶囊条） |

