# Changelog

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_splitter` package.

### Features

- `AntSplitter` lays out two or more `AntSplitterPanel` children with horizontal or vertical dividers and drag-to-resize behavior.
- Panels support `defaultSize`, controlled `size`, `min`/`max` constraints, `resizable`, and `collapsible`.
- Sizes that are not specified share the remaining space; drag results are clamped and normalized to the container budget.
- Collapsible panels expose a 44x44 hit target and release their space to the nearest expanded neighbor. The last expanded panel cannot be collapsed.
- Double-tapping a divider resets its two adjacent panels to their default sizes and expands them when collapsed.
- `lazy` mode defers size commits to the end of a drag while keeping the visual drag responsive.
- Resize lifecycle callbacks (`onResize`, `onResizeStart`, `onResizeEnd`), collapse callbacks, and divider double-click callbacks report the full size vector or divider index.
- Rendered sizes scale with the active `AntTheme` scale, so layouts adapt to density without changing their logical values.

### API

- Added `AntSplitter` and `AntSplitterPanel`.
- Added `AntSplitterLayout` with `horizontal` and `vertical`.
- Added `AntSplitterCollapseCallback` for collapse results.
