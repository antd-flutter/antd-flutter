# antd_refresh_example

`antd_refresh`（AntPullToRefresh / AntInfiniteScroll）组件演示画廊。

## 运行

```bash
cd packages/antd_refresh/example
flutter pub get
flutter run              # 任意平台：ios / android / macos / windows / linux / web
flutter build web --release --base-href /antd-flutter/refresh/   # 静态部署
```

## Demo 区块

1. **基础下拉刷新** — 触摸端下拉越过阈值松手刷新；含 `enableRefresh: false` 对照
2. **桌面滚轮刷新** — 列表到顶后滚轮继续上滚（overscroll）触发刷新
3. **国际化切换** — 语言切换控件演示 `AntPullToRefresh.locale`（zh/en/ja/ko/fr/de/es/ru/pt/it/ar）文案变化
4. **自定义文案** — pullingText / releasingText / finishingText / completeText 逐项覆写
5. **自定义 Header** — `header` 任意 Widget + `pullStatusChange` 状态回调
6. **嵌入滚动视图** — ListView / CustomScrollView / NestedScrollView 三种嵌入
7. **多级嵌套** — PullToRefresh 内嵌 PullToRefresh，内层优先消费手势
8. **组合 InfiniteScroll** — PullToRefresh 包裹 AntInfiniteScroll，下拉刷新 + 上拉加载

## 国际化说明（R34）

- `AntPullToRefresh.locale` 传 `Locale` 指定界面语言；`null` 跟随系统语言
- 仅在未显式传入 `pullingText` 等文案时生效；显式文案优先级最高
- 内置语言：zh（默认）/ en / ja / ko / fr / de / es / ru / pt / it / ar，未命中回退中文
- 也可通过 `strings: AntRefreshStrings.copyWith(...)` 整体覆写文案
