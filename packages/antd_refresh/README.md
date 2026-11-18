# antd_refresh

Ant Design 滚动刷新的 Flutter 组件包，API 对齐 antd-mobile v5 — 包含下拉刷新（`AntPullToRefresh`）与无限滚动加载（`AntInfiniteScroll`）两个独立控件。

> 当前为预览版本。

## 安装

```yaml
dependencies:
  antd_refresh: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_refresh/antd_refresh.dart';

// ── 下拉刷新（只刷新） ───────────────────────────────────
AntPullToRefresh(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(seconds: 1));
  },
  child: ListView(children: const [Text('item')]),
);

// ── 上拉加载（只加载更多） ───────────────────────────────
AntInfiniteScroll(
  loadMore: () async => items.addAll(await fetchPage()),
  child: Column(children: [...]),
);

// ── 组合：下拉刷新 + 上拉加载 ────────────────────────────
AntPullToRefresh(
  onRefresh: _refresh,
  child: AntInfiniteScroll(
    loadMore: _loadMore,
    child: ListView(children: items.map(Text.new).toList()),
  ),
);

// ── 下拉刷新关键参数 ─────────────────────────────────────
AntPullToRefresh(
  onRefresh: _refresh,
  headHeight: 60,                     // 头部高度
  threshold: 80,                      // 触发刷新的下拉阈值
  pointer: AntPullToRefreshPointer.top, // 顶部下拉（支持桌面滚轮）
  enableRefresh: true,
  child: _list,
);

// ── 国际化（内建轻量 locale 机制，默认中文，未命中回退中文）──
// 1. 跟随系统语言（locale 不传即跟随 platformDispatcher.locale）
AntPullToRefresh(onRefresh: _refresh, child: _list);

// 2. 显式指定语言（zh / en / ja / ko / fr / de / es / ru / pt / it / ar）
AntPullToRefresh(locale: Locale('en'), onRefresh: _refresh, child: _list);

// 3. 显式文案最优先，仅覆盖对应字段
AntPullToRefresh(
  locale: Locale('en'),
  pullingText: 'Pull!',
  onRefresh: _refresh,
  child: _list,
);

// 4. 整体自定义文案（可基于 copyWith 覆写个别字段）
AntPullToRefresh(
  strings: AntRefreshStrings.en.copyWith(completeText: 'Done!'),
  onRefresh: _refresh,
  child: _list,
);
```

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 在线演示：<https://antd-flutter.github.io/antd-flutter/refresh/>

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)。
