<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTooltip

> 种类：类

```dart
class AntTooltip
```

文字提示 — 简单的文字提示气泡。

对齐 antd React Tooltip 组件：鼠标移入 / 聚焦 / 点击时显示气泡提示，
支持 12 个弹出方向、受控显示、自定义颜色与箭头。

## 构造函数

### `AntTooltip({super.key, required this.child, required this.tooltip, this.placement = AntTooltipPlacement.top, this.trigger, this.open, this.defaultOpen = false, this.onOpenChange, this.controller, this.color, this.overlayStyle, this.arrow = true, this.mouseEnterDelay = const Duration(milliseconds: 100), this.mouseLeaveDelay = const Duration(milliseconds: 100)})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `tooltip` | `Widget` | 可选 | — |
| `placement` | `AntTooltipPlacement` | = AntTooltipPlacement.top | — |
| `trigger` | `AntTooltipTrigger?` | 可选 | — |
| `open` | `bool?` | 可选 | — |
| `defaultOpen` | `bool` | = false | — |
| `onOpenChange` | `ValueChanged<bool>?` | 可选 | — |
| `controller` | `AntTooltipController?` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `overlayStyle` | `BoxDecoration?` | 可选 | — |
| `arrow` | `bool` | = true | — |
| `mouseEnterDelay` | `Duration` | = const Duration(milliseconds: 100) | — |
| `mouseLeaveDelay` | `Duration` | = const Duration(milliseconds: 100) | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `arrow` | `bool` | 是否显示箭头 |
| `child` | `Widget` | 触发元素 |
| `color` | `Color?` | 自定义气泡背景色（文字自动取反白） |
| `controller` | `AntTooltipController?` | 程序化控制器（可选） |
| `defaultOpen` | `bool` | 非受控模式下的默认显示状态 |
| `mouseEnterDelay` | `Duration` | 桌面端鼠标移入延迟 |
| `mouseLeaveDelay` | `Duration` | 桌面端鼠标移出延迟 |
| `onOpenChange` | `ValueChanged<bool>?` | 显示状态变化回调 |
| `open` | `bool?` | 受控显示状态 |
| `overlayStyle` | `BoxDecoration?` | 气泡容器装饰样式（提供时覆盖默认 decoration） |
| `placement` | `AntTooltipPlacement` | 弹出位置，默认 AntTooltipPlacement.top |
| `tooltip` | `Widget` | 气泡内容提示（Widget） |
| `trigger` | `AntTooltipTrigger?` | 触发方式 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `effectiveTrigger` | `AntTooltipTrigger` | 实际生效的触发方式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTooltip>` | — |

