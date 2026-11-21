# antd_refresh - Pull-to-refresh and infinite scroll for touch and desktop

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/README_CN.md)

`antd_refresh` provides two independent, composable scroll interactions:

- `AntPullToRefresh` — pull down (or up) to refresh, aligned with antd-mobile v5 PullToRefresh. It never loads more pages.
- `AntInfiniteScroll` — load the next page when the scroll reaches the bottom, aligned with the InfiniteScroll pattern. It never refreshes.

Either works alone; wrapping an `AntInfiniteScroll` in an `AntPullToRefresh` gives the familiar "pull to refresh + scroll to load" list. Both drive the scroll view you supply as `child`, so they work with `ListView`, `CustomScrollView`, `NestedScrollView` and `SingleChildScrollView` without replacing your list implementation.

## Positioning & design

| Aspect | Decision |
| --- | --- |
| Scope | Refresh and load-more are separate widgets; compose them instead of configuring one mega-widget |
| Direction | `pointer` selects a top or bottom pull edge for refresh; load-more always reacts at the scroll end |
| Input | Touch overscroll on mobile; accumulated mouse-wheel overscroll with a 400 ms settle on desktop and web |
| Constraints | Both are wrappers: `child` must contain a bounded, scrollable widget |
| Slivers | Not required. The widgets wrap a scroll view, they do not build slivers |
| Physics | Platform physics are preserved; `AlwaysScrollableScrollPhysics` is added so short or empty lists still pull |
| Text | Built-in strings in 11 languages, with per-instance overrides |
| Control | `AntPullToRefreshController.callRefresh()` and `AntInfiniteScrollController.callLoadMore()` / `reset()` |

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_refresh: ^1.0.0
```

Inside this monorepo:

```yaml
dependencies:
  antd_refresh:
    path: ../packages/antd_refresh
```

## Quick start

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

Pull down on the list: the header expands, `onRefresh` runs, the spinner shows while the future is pending, then the header bounces back.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_refresh/docs/api-index.md)

Refresh an existing scroll view:

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

Load more pages at the end of the list:

```dart
AntInfiniteScroll(
  loadMore: () async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return false; // no more pages
  },
  child: ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ),
)
```

Trigger a refresh programmatically through a controller:

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

## Project structure

```text
antd_refresh/
├── lib/
│   ├── antd_refresh.dart                        # Public barrel
│   └── src/
│       ├── ant_refresh_controller.dart          # Controller hierarchy
│       ├── pull_to_refresh/
│       │   ├── ant_pull_to_refresh.dart         # AntPullToRefresh
│       │   ├── ant_pull_to_refresh_header.dart  # Head layout + indicator
│       │   ├── ant_pull_to_refresh_notifier.dart# Gesture state machine
│       │   └── ant_pull_to_refresh_types.dart   # Status/pointer enums, constants
│       ├── infinite_scroll/
│       │   ├── ant_infinite_scroll.dart         # AntInfiniteScroll
│       │   └── ant_infinite_scroll_types.dart   # Defaults
│       └── l10n/
│           └── ant_refresh_strings.dart         # 11 built-in languages
├── example/lib/main.dart                        # Demo gallery
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

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
