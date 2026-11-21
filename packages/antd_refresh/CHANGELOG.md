# Changelog

## 1.0.0

Initial stable release of the standalone `antd_refresh` package.

### Features

- `AntPullToRefresh` pull-to-refresh aligned with antd-mobile v5 PullToRefresh, driven by the scroll view passed as `child`.
- Top and bottom pull edges through `pointer`.
- Touch gestures via overscroll notifications, working with both bouncing and clamping platform physics.
- Desktop and web refresh driven by accumulated mouse-wheel overscroll at the pull edge, with a 400 ms settle before triggering.
- Wheel handling that only claims events when the pointer is inside the component and the inner scroll is at the edge, keeping nested and sibling scrollables independent.
- `AlwaysScrollableScrollPhysics` added on top of platform physics so short and empty lists can still be pulled.
- Five refresh states (`AntPullToRefreshStatus.idle/pulling/canRelease/refreshing/complete`) with `pullStatusChange`.
- Configurable `headHeight`, `threshold`, `enableRefresh` and a fully custom `header` widget.
- `AntInfiniteScroll` load-more at the scroll end with a `Future<bool>` callback, where `false` marks the end of the data.
- Footer states for loading, failure with tap-to-retry, and no-more, occupying a 48 px slot with matching child bottom padding.
- First-frame check that loads immediately when the content is shorter than the viewport.
- `AntRefreshController` hierarchy with `isAttached`; `AntPullToRefreshController.callRefresh()`, `AntInfiniteScrollController.callLoadMore()` and `reset()`, raising `StateError` when detached.
- `AntRefreshStrings` with built-in text for Chinese, English, Japanese, Korean, French, German, Spanish, Russian, Portuguese, Italian and Arabic, plus `copyWith` and locale resolution with Chinese fallback.
- Explicit text overrides taking precedence over `strings`, `locale` and the system locale.
- Theme-aware indicator, footer typography and spacing through `antd_theme`.

### Notes

- `child` must contain a bounded, scrollable widget; the widgets are wrappers and do not build slivers.
- Default labels are Chinese; pass `locale` or `strings` for other languages.
- `hasMoreText` is accepted for API parity but the footer is not rendered while idle.
