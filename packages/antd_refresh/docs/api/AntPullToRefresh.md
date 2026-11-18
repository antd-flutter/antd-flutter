<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefresh

> 种类：类

```dart
class AntPullToRefresh
```

下拉刷新 — 在可滚动内容顶部下拉触发刷新。

对齐 antd-mobile PullToRefresh 组件：下拉时头部跟随位移并显示
「下拉刷新 → 释放刷新 → 加载转圈 → 完成」提示，松手超过
`AntPullToRefresh.threshold` 触发 `AntPullToRefresh.onRefresh`，
Future 完成后自动回弹。

上拉加载更多由 AntInfiniteScroll 独立承担，两者可组合嵌套使用。

桌面端支持鼠标滚轮：在列表顶部继续向上滚动滚轮即累积下拉位移，
停止滚动 `kAntPullToRefreshWheelSettleDuration` 后超过阈值即触发刷新。

## 构造函数

### `AntPullToRefresh({super.key, required this.child, this.onRefresh, this.headHeight = kAntPullToRefreshHeadHeight, this.threshold = kAntPullToRefreshThreshold, this.pullStatusChange, this.completeText, this.pullingText, this.releasingText, this.finishingText, this.locale, this.strings, this.pointer = AntPullToRefreshPointer.top, this.header, this.enableRefresh = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `onRefresh` | `Future<void> Function()?` | 可选 | — |
| `headHeight` | `double` | = kAntPullToRefreshHeadHeight | — |
| `threshold` | `double` | = kAntPullToRefreshThreshold | — |
| `pullStatusChange` | `ValueChanged<AntPullToRefreshStatus>?` | 可选 | — |
| `completeText` | `String?` | 可选 | — |
| `pullingText` | `String?` | 可选 | — |
| `releasingText` | `String?` | 可选 | — |
| `finishingText` | `String?` | 可选 | — |
| `locale` | `Locale?` | 可选 | — |
| `strings` | `AntRefreshStrings?` | 可选 | — |
| `pointer` | `AntPullToRefreshPointer` | = AntPullToRefreshPointer.top | — |
| `header` | `Widget?` | 可选 | — |
| `enableRefresh` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 可滚动内容（必须是 ListView / CustomScrollView 等可滚动组件才能下拉） |
| `completeText` | `String?` | 刷新完成文案 |
| `enableRefresh` | `bool` | 是否启用下拉刷新（默认 true） |
| `finishingText` | `String?` | 刷新中文案（伴随转圈显示） |
| `headHeight` | `double` | 头部高度（默认 40） |
| `header` | `Widget?` | 自定义头部内容（替换默认的状态提示） |
| `locale` | `Locale?` | 界面语言（null = 跟随系统 WidgetsBinding.instance.platformDispatch… |
| `onRefresh` | `Future<void> Function()?` | 下拉刷新回调（Future 完成后自动回弹） |
| `pointer` | `AntPullToRefreshPointer` | 指针位置：top 顶部下拉（默认）/ bottom 底部上拉 |
| `pullStatusChange` | `ValueChanged<AntPullToRefreshStatus>?` | 状态变化回调（idle/pulling/canRelease/refreshing/complete） |
| `pullingText` | `String?` | 下拉中（未达阈值）文案 |
| `releasingText` | `String?` | 达到阈值释放即刷新文案 |
| `strings` | `AntRefreshStrings?` | 自定义文案覆写（优先于 AntRefreshStrings.resolve 内置解析） |
| `threshold` | `double` | 触发刷新的下拉阈值（默认 50，轻微超过默认 headHeight 40 即触发） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `AntPullToRefreshState` | — |

