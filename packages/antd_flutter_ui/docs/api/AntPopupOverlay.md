<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopupOverlay

> 种类：类

```dart
class AntPopupOverlay
```

统一弹层基座。

由各弹层组件在 OverlayEntry 中构造：
```dart
AntPopupOverlay(
  targetKey: _childKey,
  placement: AntPopupPlacement.top,
  arrow: true,
  arrowColor: bgColor,
  arrowKey: const Key('ant_tooltip_arrow'),
  onDismiss: () => ...,
  child: bubble,
)
```

## 构造函数

### `AntPopupOverlay({super.key, required this.targetKey, required this.child, this.placement = AntPopupPlacement.bottom, this.arrow = false, this.arrowColor, this.arrowKey, this.arrowSize, this.gap, this.viewportPadding, this.onDismiss, this.dismissOnTapOutside = true, this.animationDuration = const Duration(milliseconds: 150), this.onBubbleHoverEnter, this.onBubbleHoverExit})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `targetKey` | `GlobalKey` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `placement` | `AntPopupPlacement` | = AntPopupPlacement.bottom | — |
| `arrow` | `bool` | = false | — |
| `arrowColor` | `Color?` | 可选 | — |
| `arrowKey` | `Key?` | 可选 | — |
| `arrowSize` | `double?` | 可选 | — |
| `gap` | `double?` | 可选 | — |
| `viewportPadding` | `EdgeInsets?` | 可选 | — |
| `onDismiss` | `VoidCallback?` | 可选 | — |
| `dismissOnTapOutside` | `bool` | = true | — |
| `animationDuration` | `Duration` | = const Duration(milliseconds: 150) | — |
| `onBubbleHoverEnter` | `VoidCallback?` | 可选 | — |
| `onBubbleHoverExit` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `animationDuration` | `Duration` | 出现动画时长 |
| `arrow` | `bool` | 是否渲染箭头 |
| `arrowColor` | `Color?` | 箭头颜色 |
| `arrowKey` | `Key?` | 箭头定位 Key（供组件测试） |
| `arrowSize` | `double?` | 箭头边长（默认 8 逻辑像素） |
| `child` | `Widget` | 气泡内容（不含箭头，箭头由基座渲染） |
| `dismissOnTapOutside` | `bool` | 是否启用点击气泡外关闭 |
| `gap` | `double?` | 气泡与触发元素间距（默认 6） |
| `onBubbleHoverEnter` | `VoidCallback?` | 鼠标进入气泡回调（联合 hover 判定：进入气泡视为未离开弹层） |
| `onBubbleHoverExit` | `VoidCallback?` | 鼠标离开气泡回调（联合 hover 判定：与触发元素退出共同决定关闭） |
| `onDismiss` | `VoidCallback?` | 点击空白处回调 |
| `placement` | `AntPopupPlacement` | 首选弹出位置（边界放不下自动翻转） |
| `targetKey` | `GlobalKey` | 触发元素的 GlobalKey（用于取全局矩形） |
| `viewportPadding` | `EdgeInsets?` | 视口内边距（safe area 语义，默认 8） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPopupOverlay>` | — |

