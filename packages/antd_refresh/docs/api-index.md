<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_refresh API 文档总览

> 自动生成时间：2026-11-20T00:16:33.033578；共 29 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（11）

| 名称 | 说明 |
| --- | --- |
| [`AntInfiniteScroll`](api/AntInfiniteScroll.md) | 无限滚动 — 滚动到底部自动加载更多数据 |
| [`AntInfiniteScrollController`](api/AntInfiniteScrollController.md) | AntInfiniteScroll 的控制器：程序化触发加载更多 / 重置分页状态 |
| [`AntInfiniteScrollDefaults`](api/AntInfiniteScrollDefaults.md) | AntInfiniteScroll 默认配置 |
| [`AntInfiniteScrollState`](api/AntInfiniteScrollState.md) | AntInfiniteScroll 的 State（公开供 AntInfiniteScrollController… |
| [`AntPullToRefresh`](api/AntPullToRefresh.md) | 下拉刷新 — 在可滚动内容顶部下拉触发刷新 |
| [`AntPullToRefreshController`](api/AntPullToRefreshController.md) | AntPullToRefresh 的控制器：程序化触发下拉刷新 |
| [`AntPullToRefreshHeader`](api/AntPullToRefreshHeader.md) | AntPullToRefresh 默认头部指示器 |
| [`AntPullToRefreshIndicator`](api/AntPullToRefreshIndicator.md) | 单包独享的刷新指示器状态机 |
| [`AntPullToRefreshState`](api/AntPullToRefreshState.md) | AntPullToRefresh 的 State（公开供 AntPullToRefreshController 挂载 |
| [`AntRefreshController`](api/AntRefreshController.md) | 刷新组件 Controller 基类：统一 isAttached 生命周期状态与未挂载保护 |
| [`AntRefreshStrings`](api/AntRefreshStrings.md) | 下拉刷新组件各阶段文案集合 |

## 枚举（2）

| 名称 | 说明 |
| --- | --- |
| [`AntPullToRefreshPointer`](api/AntPullToRefreshPointer.md) | 下拉刷新指针位置 |
| [`AntPullToRefreshStatus`](api/AntPullToRefreshStatus.md) | 下拉刷新状态 |

## 函数（1）

| 名称 | 说明 |
| --- | --- |
| [`atPullEdge`](api/atPullEdge.md) | 内层可滚动组件是否停在拉动边缘（top：顶部 |

## 常量（15）

| 名称 | 说明 |
| --- | --- |
| [`kAntInfiniteScrollFooterSlot`](api/kAntInfiniteScrollFooterSlot.md) | footer 槽位高度：footer 可见时 child 底部预留的空间 （上下 12 内边距 + 一行文案/指示… |
| [`kAntPullToRefreshCompleteText`](api/kAntPullToRefreshCompleteText.md) | — |
| [`kAntPullToRefreshDuration`](api/kAntPullToRefreshDuration.md) | 回弹动画时长 |
| [`kAntPullToRefreshFinishingText`](api/kAntPullToRefreshFinishingText.md) | — |
| [`kAntPullToRefreshHeadHeight`](api/kAntPullToRefreshHeadHeight.md) | 默认头部高度 |
| [`kAntPullToRefreshHeaderKey`](api/kAntPullToRefreshHeaderKey.md) | 头部高度标记 key，便于测试定位头部容器 |
| [`kAntPullToRefreshIndicatorSize`](api/kAntPullToRefreshIndicatorSize.md) | 头部指示器图标尺寸 |
| [`kAntPullToRefreshIndicatorSpacing`](api/kAntPullToRefreshIndicatorSpacing.md) | 头部指示器图标与文案间距 |
| [`kAntPullToRefreshMaxPullFactor`](api/kAntPullToRefreshMaxPullFactor.md) | 最大下拉距离 = headHeight  3（参照轮子 maxOverScrollExtent 思路） |
| [`kAntPullToRefreshPullingText`](api/kAntPullToRefreshPullingText.md) | 默认文案（中文，向后兼容保留 |
| [`kAntPullToRefreshReleasingText`](api/kAntPullToRefreshReleasingText.md) | — |
| [`kAntPullToRefreshTextFontSize`](api/kAntPullToRefreshTextFontSize.md) | 头部指示器文案字号 |
| [`kAntPullToRefreshThreshold`](api/kAntPullToRefreshThreshold.md) | 默认触发阈值（轻微超过默认头部高度 kAntPullToRefreshHeadHeight， 对齐 antd-mo… |
| [`kAntPullToRefreshWheelSettleDuration`](api/kAntPullToRefreshWheelSettleDuration.md) | 桌面端滚轮拉动后停止滚动到触发刷新的等待时长 |
| [`kIndicatorAnimationDuration`](api/kIndicatorAnimationDuration.md) | 头部展开/回弹动画时长（与组件层的 kAntPullToRefreshDuration 对齐） |

