# Changelog

## 1.0.2

- Republished with a Web-compatible dependency chain.
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_masonry` package.

### Features

- `AntMasonry` multi-column layout for content of differing heights, with configurable `columns`, `gutter` and `verticalGutter`.
- Greedy shortest-column placement when items declare a height, falling back to round-robin distribution when none do.
- `AntMasonryItem` with an explicit `height` (used both for placement and as the rendered box height) and a `span` for two-or-more-column items, including full-width rows.
- `AntMasonryResponsive` breakpoint column counts aligned with antd grid breakpoints (`xs` through `xxl`) and width-based resolution with fallback.
- `AntSliverMasonry` for composition with `CustomScrollView`, `SliverAppBar` and other slivers, carrying the shared placement engine.
- In-package placement engine with no third-party staggered-grid dependency.
- Theme-scaled gutters and support for empty content.

### Notes

- Every item should declare a height when spans are used; undeclared heights contribute nothing to column accounting.
- The sliver variant is non-lazy and lays out all children at once.
- The package is a pure layout container: scrolling is provided by the host scroll view, and content changes are applied by rebuilding the children list.
