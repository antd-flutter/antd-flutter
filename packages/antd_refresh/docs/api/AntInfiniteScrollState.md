<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInfiniteScrollState

> 种类：类

```dart
class AntInfiniteScrollState
```

`AntInfiniteScroll` 的 State（公开供 `AntInfiniteScrollController` 挂载）。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_childMetrics` | `ScrollMetrics?` | child 子树最内层滚动组件最近一次的滚动度量（内层消费隔离存储值， 状态机/触发逻辑只读该值，不感知外层页面滚动） |
| `_failed` | `bool` | 是否加载失败 |
| `_hasMore` | `bool` | 是否还有更多数据 |
| `_initialChecked` | `bool` | 是否已完成首次阈值检查 |
| `_loading` | `bool` | 是否正在加载 |
| `_phase` | `ValueNotifier<_AntInfiniteScrollPhase>` | 底部状态区阶段（ValueNotifier + ListenableBuilder 局部刷新 footer， R3… |
| `_resolveAttempts` | `int` | — |
| `_kMaxResolveAttempts` | `int` | 首次滚动度量解析重试次数上限（child 迟迟不含滚动组件时停止轮询） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_canLoad` | `bool` | 防重入锁：加载中不重复触发 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_atTriggerEdge` | `bool` | child 子树是否停在触发边缘（内层消费隔离的判定条件） |
| `_buildFooter` | `Widget` | 底部状态区：加载中 / 失败重试 / 没有更多 / 还有更多 |
| `_check` | `void` | 检查滚动位置是否进入触发阈值范围 |
| `_handleChildNotification` | `bool` | 内层通知处理：只接受 child 子树最内层（depth == 0）滚动组件的通知， 度量存入 childMetr… |
| `_loadMore` | `Future<void>` | 执行加载：成功时按返回值更新 hasMore，异常时进入失败态 |
| `_maybeInitialCheck` | `void` | 执行首次阈值检查 |
| `_syncPhase` | `void` | 按当前布尔状态同步 footer 阶段并触发局部刷新 |
| `build` | `Widget` | — |
| `callLoadMore` | `Future<void>` | 程序化触发加载更多（Controller 入口 |
| `didUpdateWidget` | `void` | — |
| `dispose` | `void` | — |
| `initState` | `void` | — |
| `reset` | `void` | 重置分页状态：清除失败态并恢复「还有更多」（Controller 入口） |
| `_resolveDescendantMetrics` | `ScrollMetrics?` | 从子树中找到最近的 ScrollableState 并返回其滚动度量 （child 自带滚动视图的用法） |

