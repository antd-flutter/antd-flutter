<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefreshState

> 种类：类

```dart
class AntPullToRefreshState
```

`AntPullToRefresh` 的 State（公开供 `AntPullToRefreshController` 挂载；
GlobalKey State.callRefresh 路径保留向后兼容，推荐使用 controller）。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_indicator` | `AntPullToRefreshIndicator` | 指示器状态机（架构参考 easyrefresh IndicatorNotifier）： 状态/动画/任务编排全部收… |
| `_lastMetrics` | `ScrollMetrics?` | 内层可滚动组件最近一次的滚动度量（判定是否在拉动边缘） |
| `_physicsMaxAmount` | `double` | Bouncing 系物理过冲进行中标记：过冲把 pixels 写出滚动范围 （不产生 OverscrollNoti… |
| `_wheelSettleTimer` | `Timer?` | 滚轮停止滚动 → 触发 release 的延时计时器 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_atPullEdge` | `bool` | 内层可滚动组件是否停在拉动边缘（top：顶部 |
| `_isTop` | `bool` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_endPhysicsOverscroll` | `void` | 物理过冲手势结束：按峰值做释放决策（过阈值刷新，否则回弹） |
| `_handleNotification` | `bool` | — |
| `_handlePointerSignalWrapper` | `void` | 滚轮事件处理（非消费式入口） |
| `_handleResolvedWheel` | `void` | 竞争胜出后的滚轮处理：阻断平台默认（页面）滚动，再走拉动状态机 |
| `_handleWheelEvent` | `void` | 桌面端鼠标滚轮拉动（与触摸共用同一状态机） |
| `_syncPhysicsOverscroll` | `void` | 从滚动度量同步 Bouncing 过冲位移（iOS/macOS/web Bouncing 物理路径） |
| `build` | `Widget` | — |
| `callRefresh` | `Future<void>` | 程序化触发下拉刷新（GlobalKey 兼容路径 |
| `didUpdateWidget` | `void` | — |
| `dispose` | `void` | — |
| `initState` | `void` | — |

