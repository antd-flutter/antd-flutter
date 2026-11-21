<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMask

> 种类：类

```dart
class AntMask
```

背景遮罩 — 全屏黑色半透明遮罩，常用于加载中、内容浮层背景。

对齐 antd-mobile Mask：受控显隐（`visible`）、透明度与颜色可配、
点击遮罩触发 `onAction`、上层可通过 `child` 叠加自定义内容。

## 构造函数

### `AntMask({super.key, required this.visible, this.opacity = kAntMaskDefaultOpacity, this.color = kAntMaskDefaultColor, this.onAction, this.destroyOnClose = false, this.forceRender = false, this.child, this.fullScreen = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `visible` | `bool` | 可选 | — |
| `opacity` | `double` | = kAntMaskDefaultOpacity | — |
| `color` | `Color` | = kAntMaskDefaultColor | — |
| `onAction` | `VoidCallback?` | 可选 | — |
| `destroyOnClose` | `bool` | = false | — |
| `forceRender` | `bool` | = false | — |
| `child` | `Widget?` | 可选 | — |
| `fullScreen` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 遮罩上层自定义内容（如 loading 组合） |
| `color` | `Color` | 遮罩颜色，默认黑色 |
| `destroyOnClose` | `bool` | 关闭时是否销毁上层内容（true 时隐藏后不保留 child 状态） |
| `forceRender` | `bool` | 未显示时是否也渲染（简化实现：true 时隐藏但仍挂载） |
| `fullScreen` | `bool` | 是否全屏铺满，默认 true |
| `onAction` | `VoidCallback?` | 点击遮罩时回调 |
| `opacity` | `double` | 遮罩透明度，默认 0.5 |
| `visible` | `bool` | 是否显示遮罩（受控属性） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntMask>` | — |

