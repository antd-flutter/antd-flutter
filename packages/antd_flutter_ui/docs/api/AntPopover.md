<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopover

> 种类：类

```dart
class AntPopover
```

气泡卡片 — 点击/悬停元素时弹出的卡片式浮层。

对齐 antd React Popover 组件，用于展示富文本内容，
支持标题区、九方向弹出位置、受控显示、自定义背景色与箭头。

## 构造函数

### `AntPopover({super.key, required this.child, required this.content, this.title, this.trigger = AntPopoverTrigger.hover, this.placement = AntPopoverPlacement.bottomLeft, this.open, this.defaultOpen = false, this.onOpenChange, this.controller, this.color, this.arrow = false, this.overlayStyle, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `content` | `Widget` | 可选 | — |
| `title` | `Widget?` | 可选 | — |
| `trigger` | `AntPopoverTrigger` | = AntPopoverTrigger.hover | — |
| `placement` | `AntPopoverPlacement` | = AntPopoverPlacement.bottomLeft | — |
| `open` | `bool?` | 可选 | — |
| `defaultOpen` | `bool` | = false | — |
| `onOpenChange` | `ValueChanged<bool>?` | 可选 | — |
| `controller` | `AntPopoverController?` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `arrow` | `bool` | = false | — |
| `overlayStyle` | `AntPopoverOverlayStyle?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `arrow` | `bool` | 是否显示箭头 |
| `child` | `Widget` | 触发元素 |
| `color` | `Color?` | 自定义气泡背景色（文字自动反白） |
| `content` | `Widget` | 气泡内容 |
| `controller` | `AntPopoverController?` | 程序化控制器（可选） |
| `defaultOpen` | `bool` | 非受控默认显示状态 |
| `disabled` | `bool` | 是否禁用 |
| `onOpenChange` | `ValueChanged<bool>?` | 显示状态变化回调 |
| `open` | `bool?` | 受控显示状态（非空时进入受控模式） |
| `overlayStyle` | `AntPopoverOverlayStyle?` | 浮层自定义样式 |
| `placement` | `AntPopoverPlacement` | 弹出位置 |
| `title` | `Widget?` | 气泡标题区 |
| `trigger` | `AntPopoverTrigger` | 触发方式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPopover>` | — |

