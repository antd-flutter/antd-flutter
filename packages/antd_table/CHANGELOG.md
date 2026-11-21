# Changelog

## 1.0.2

- Republished with a Web-compatible dependency chain.
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_table` package.

### Features

- Generic table API: `AntTable<T>` and `AntTableColumn<T>` consume the caller's own row model directly. There is no `Map` row and no `dataIndex` string lookup - every data access is a typed callback (`rowKey`, `cell`, `sorter`, `onFilter`, `onCell`, `childrenOf`, `expandedRowRender`, `summary`).
- Sorting: click-to-cycle ascend -> descend -> cancel, `sorter` comparator, initial `defaultSortOrder`, controlled `sortOrder`, configurable `sortDirections`, and multi-column sorting through `sortPriority`.
- Filtering: `filters` + `onFilter` menus with `filterMultiple` (checkbox) or single-select (radio) modes, initial `defaultFilteredValue`, controlled `filteredValue`, and confirm/reset actions.
- Fixed columns (`AntTableFixed.left` / `right`, inherited by group children) and fixed header via `scrollY`, with divider shadows.
- Horizontal scrolling driven by `scrollX`, implemented inside the component over a `SingleChildScrollView` with position-computed column pinning; no sliver dependency and no outer scroll-position coupling.
- Virtual scrolling: with `scrollY` set and more than 50 rows the body switches to `ListView.builder`.
- Merged cells through `AntTableColumn.onCell` returning `AntTableCellSpan(rowSpan:, colSpan:)`, where `rowSpan: 0` hides the cell.
- Expandable rows: `expandedRowRender`, `expandRowByClick`, `expandedRowKeys`, `defaultExpandAllRows`, `onExpandedRowsChange`.
- Tree data via `childrenOf` with indentation, per-level sorting/filtering, and selection cascade.
- Row selection: `AntTableRowSelection<T>` with controlled and uncontrolled keys, `getCheckboxProps` for disabled rows, custom `selections` entries, `checkStrictly`, `hideSelectAll`, configurable column width and pinning, select-all with half-checked state.
- Pagination (`pagination`, `pageSize`, `onPageChange`), summary footer (`summary` + `AntTableSummaryCell` with `colSpan`), and multi-level grouped headers (`AntTableColumn.children`).
- Presentation: `size` (`large` / `middle` / `small`), `bordered`, `loading`, `empty` placeholder, `ellipsis`, `align`, and default column width of 120 for columns without an explicit width.

### Notes

- Leaf columns must provide `cell`; group columns must provide non-empty `children` - both are enforced by assertions at build time.
- Sorting, filtering and pagination operate client-side on `dataSource`; server-driven tables should drive rows externally and observe `onSortChange` / `onFilterChange` / `onPageChange`.
- `rowKey` falls back to the row index when omitted; an explicit key is required for stable expansion and selection across reorders.
- Not included in 1.0.0: column resizing, editable cells, column virtualization, sliver variants.
