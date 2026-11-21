# Changelog

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_transfer` package.

### Features

- `AntTransfer<T>` renders a generic two-pane transfer control that consumes your model directly through `keyOf`, `titleBuilder`, `descriptionOf`, `childrenOf`, `disabledOf`, and `searchTextOf`.
- Tree mode is inferred automatically when `childrenOf` returns children, with parent/child check cascading, indeterminate half states, disabled-subtree propagation, subtree moves, tree search that keeps ancestor chains, and `defaultExpandAll`.
- Checkbox selection, select-all over enabled rows, and move/return operations work in both directions with `onChange` and `onSelectChange` callbacks.
- `targetKeys`, `selectedKeys`, `defaultTargetKeys`, and `defaultSelectedKeys` support controlled and uncontrolled state.
- Search supports `searchTextOf` and a custom `filterOption` predicate.
- `titles`, `operations`, `height`, `disabled`, `oneWay`, and `showSearch` control the panel layout and available operations.
- Empty data renders an explicit empty state.
- Added the `AntTransferDirection` enum and the `AntTransfer*Of` callback typedefs.

### Deprecated

- `AntTransferItem` is deprecated in favor of a user-defined model combined with `dataSource`, `keyOf`, and `childrenOf`.
