# antd_refresh

Ant Design **滚动刷新** 的 Flutter 独立组件包，API 对齐 antd-mobile v5，包含两个职责分离、可组合使用的控件：

- **AntPullToRefresh（下拉刷新）**：只做下拉刷新，滚动到底部加载更多不在其职责内
- **AntInfiniteScroll（无限滚动 / 上拉加载）**：只做滚动到底自动加载更多，不负责下拉刷新

两个控件相互独立、互不依赖，可自由组合：用 `AntPullToRefresh` 包裹 `AntInfiniteScroll` 即得完整「下拉刷新 + 上拉加载」体验。

从主包 [antd_flutter_plus](https://github.com/antd-flutter/antd-flutter) 拆分而来（P08 独立包拆分）；主包经 re-export 保持对外 API 完全兼容，已接入主包的用户无需改动。

## 定位

- **独立理由**：下拉刷新手势状态机（idle → pulling → canRelease → refreshing → complete）为单包独享引擎，且「只想用下拉刷新 / 只想用上拉加载」的独立使用场景强。
- **零三方依赖**：不引入任何第三方包。
- **移动端手势**：AntPullToRefresh 触摸下拉（OverscrollNotification 驱动状态机 + 回弹）；AntInfiniteScroll 滚动到底自动触发。
- **桌面端滚轮**：AntPullToRefresh 支持鼠标滚轮在顶部边缘继续滚动累积下拉位移，停止滚动约 400ms 后按阈值触发刷新（经 PointerSignalResolver 事件竞争，不影响同页其他滚动容器）。

## R33 判定

**包裹类组件，不需要 sliver 支持（R33）**：两个控件均以 `child` 包裹调用方自带的可滚动组件（ListView/CustomScrollView 等均可），通过 NotificationListener 实现，不要求 sliver 家族形态。

## 使用

```yaml
dependencies:
  antd_refresh: ^0.1.0-beta.1
```

```dart
import 'package:antd_refresh/antd_refresh.dart';

// 下拉刷新（只刷新）
AntPullToRefresh(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(seconds: 1));
  },
  child: ListView(children: const [Text('item')]),
)

// 上拉加载（只加载更多）
AntInfiniteScroll(
  loadMore: () async => items.addAll(await fetchPage()),
  child: Column(children: [...]),
)

// 组合：下拉刷新 + 上拉加载
AntPullToRefresh(
  onRefresh: _refresh,
  child: AntInfiniteScroll(
    loadMore: _loadMore,
    child: ListView(children: items.map(Text.new).toList()),
  ),
)
```
