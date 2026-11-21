# antd_refresh - 触屏与桌面通用的下拉刷新与无限滚动

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/README_CN.md)

`antd_refresh` 提供两个独立、可自由组合的滚动交互：

- `AntPullToRefresh` — 下拉（或上拉）刷新，API 对齐 antd-mobile v5 PullToRefresh，只做刷新，不负责加载更多。
- `AntInfiniteScroll` — 滚动到底自动加载下一页，对齐 InfiniteScroll 模式，只做加载，不负责刷新。

两者都能单独使用；把 `AntInfiniteScroll` 包在 `AntPullToRefresh` 里，就得到常见的「下拉刷新 + 上拉加载」列表。它们作用于你传入的 `child` 滚动视图，因此可直接搭配 `ListView`、`CustomScrollView`、`NestedScrollView`、`SingleChildScrollView`，无需替换列表实现。

## 定位与设计

| 方面 | 决策 |
| --- | --- |
| 职责 | 刷新与加载更多是两个独立组件，通过组合使用，而不是一个巨型配置组件 |
| 方向 | `pointer` 决定刷新触发边（顶部或底部）；加载更多始终在滚动末端触发 |
| 输入 | 移动端走触摸过卷；桌面与 Web 累积鼠标滚轮过卷，静置 400ms 后触发 |
| 约束 | 两者都是包裹组件：`child` 必须包含有界、可滚动的组件 |
| Sliver | 不需要。组件包裹滚动视图，不构建 sliver |
| 物理 | 保留平台物理效果，并追加 `AlwaysScrollableScrollPhysics`，短列表或空列表也能下拉 |
| 文案 | 内置 11 种语言，支持实例级覆写 |
| 控制 | `AntPullToRefreshController.callRefresh()` 与 `AntInfiniteScrollController.callLoadMore()` / `reset()` |

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_refresh: ^1.0.0
```

在本 monorepo 内：

```yaml
dependencies:
  antd_refresh:
    path: ../packages/antd_refresh
```

## 快速开始

```dart
import 'package:antd_refresh/antd_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const RefreshApp());

class RefreshApp extends StatelessWidget {
  const RefreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: const MaterialApp(home: FeedPage()),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<int> _items = List<int>.generate(20, (i) => i);

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _items = List<int>.generate(20, (i) => -i - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: AntPullToRefresh(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('Item ${_items[index]}'),
          ),
        ),
      ),
    );
  }
}
```

下拉列表：头部展开，`onRefresh` 执行，Future 未完成时显示加载指示器，完成后头部回弹。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/docs/api-index.md)

为已有滚动视图增加下拉刷新：

```dart
AntPullToRefresh(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  },
  child: ListView(
    children: const [ListTile(title: Text('Item'))],
  ),
)
```

在列表末端加载更多：

```dart
AntInfiniteScroll(
  loadMore: () async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return false; // 没有更多数据
  },
  child: ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ),
)
```

通过 controller 主动触发刷新：

```dart
final AntPullToRefreshController _controller =
    AntPullToRefreshController();

Future<void> refreshNow() => _controller.callRefresh();

Widget buildFeed() {
  return AntPullToRefresh(
    controller: _controller,
    onRefresh: () async {},
    child: ListView(
      children: const [ListTile(title: Text('Item'))],
    ),
  );
}
```

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/refresh/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
antd_refresh/
├── lib/
│   ├── antd_refresh.dart                        # 公开 barrel
│   └── src/
│       ├── ant_refresh_controller.dart          # 控制器层级
│       ├── pull_to_refresh/
│       │   ├── ant_pull_to_refresh.dart         # AntPullToRefresh
│       │   ├── ant_pull_to_refresh_header.dart  # 头部布局与指示器
│       │   ├── ant_pull_to_refresh_notifier.dart# 手势状态机
│       │   └── ant_pull_to_refresh_types.dart   # 状态/方向枚举与常量
│       ├── infinite_scroll/
│       │   ├── ant_infinite_scroll.dart         # AntInfiniteScroll
│       │   └── ant_infinite_scroll_types.dart   # 默认值
│       └── l10n/
│           └── ant_refresh_strings.dart         # 11 种内置语言
├── example/lib/main.dart                        # 演示画廊
├── test/
│   ├── ant_pull_to_refresh_test.dart
│   ├── ant_refresh_controller_test.dart
│   ├── ant_refresh_strings_test.dart
│   ├── combo_ptr_infinite_test.dart
│   └── infinite_scroll/ant_infinite_scroll_test.dart
├── docs/api-index.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## 许可证

MIT。见仓库根目录 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
