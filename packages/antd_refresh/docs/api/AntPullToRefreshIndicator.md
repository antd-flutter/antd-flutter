<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefreshIndicator

> 种类：类

```dart
class AntPullToRefreshIndicator
```

单包独享的刷新指示器状态机。

一次完整的下拉刷新生命周期：
idle → pulling → canRelease →（释放）refreshing → complete → idle。

## 构造函数

### `AntPullToRefreshIndicator({required TickerProvider vsync, this.onModeChanged})`

创建状态机。

`vsync` 用于位移回弹动画（对应 ER Notifier 内部持有动画控制器）；
`onModeChanged` 在状态跃迁时回调，
供组件转发 `pullStatusChange` 等对外 API。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `vsync` | `TickerProvider` | 可选 | 用于位移回弹动画（对应 ER Notifier 内部持有动画控制器）； |
| `onModeChanged` | `ValueChanged<AntPullToRefreshStatus>?` | 可选 | 在状态跃迁时回调， 供组件转发 `pullStatusChange` 等对外 API。 |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_animTarget` | `double` | 当前动画目标位移（0 = 回弹复位，到位后状态机回 idle） |
| `_headHeight` | `double` | 运行期配置（由组件在 didUpdateWidget 时同步） |
| `_isTop` | `bool` | — |
| `_mode` | `AntPullToRefreshStatus` | — |
| `_offset` | `double` | — |
| `_offsetAnimation` | `Animation<double>?` | 当前回弹动画（Tween 驱动，见 animateTo） |
| `_offsetController` | `AnimationController` | — |
| `_threshold` | `double` | — |
| `onModeChanged` | `ValueChanged<AntPullToRefreshStatus>?` | 头部状态跃迁回调（对外 AntPullToRefresh.pullStatusChange） |
| `wheelDriven` | `bool` | 当前一次拉动是否由桌面滚轮驱动（滚轮没有「松手」事件， 由组件层的停止滚动计时触发 release） |
| `maxPullFactor` | `double` | 最大下拉距离 = headHeight  3（参照轮子 maxOverScrollExtent 思路） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `canPull` | `bool` | 是否允许响应拉动（刷新中/完成阶段不响应新的下拉） |
| `headHeight` | `double` | — |
| `isTop` | `bool` | 指针位置是否在顶部（top 下拉 / bottom 上拉） |
| `mode` | `AntPullToRefreshStatus` | 当前头部状态 |
| `offset` | `double` | 当前头部/内容位移量 |
| `taskRunning` | `bool` | 是否处于任务执行阶段（刷新中/完成），期间不触发新的任务 |
| `threshold` | `double` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_accumulate` | `void` | 位移累积（触摸过冲与桌面滚轮共用 |
| `_handleOffsetTick` | `void` | — |
| `_setMode` | `void` | 更新头部状态并通知 |
| `animateTo` | `void` | 回弹到目标位移（Notifier 内部持有动画控制器， 对应 ER IndicatorNotifier 的 cla… |
| `configure` | `void` | 同步组件配置（headHeight / threshold / pointer），状态不变 |
| `dispose` | `void` | — |
| `drag` | `void` | 触摸过冲拉动（移动端主路径） |
| `release` | `void` | 松手：超过阈值触发刷新，否则回弹（滚动结束路径） |
| `runRefresh` | `Future<void>` | 执行刷新：头部展开到 headHeight → 等待任务完成 → 回弹 |
| `syncOverscroll` | `void` | 物理层过冲同步（Bouncing 系物理：过冲直接写入 pixels 超出范围， 不产生 OverscrollNo… |
| `wheelPull` | `void` | 桌面端滚轮拉动：累积位移并标记滚轮驱动 |

