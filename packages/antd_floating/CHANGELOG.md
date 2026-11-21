# Changelog

## 1.0.0

Initial stable release of the standalone `antd_floating` package.

### Features

- `AntFloatingPanel`: bottom-anchored floating panel with ascending `anchors` ratios, a draggable handle, drag-follow height and 250 ms snap-to-nearest-anchor animation.
- Panel options for custom `handle`, `handleHeight` (default 28), `contentHeight` as the anchor base height, and `onHeightChange` ratio callbacks.
- `AntFloatingPanelController` with `heightRatio`, `snapToAnchorAt`, `expand`, `collapse` and `resetToInitial`.
- `AntFloatingBubble`: draggable floating action button supporting `x`, `y` and `both` axes, parent-bound constraints, and optional `autoSnapToEdge` after a drag.
- Bubble menu support through `AntFloatingBubbleMenuAction` entries (label, icon, click callback) toggled by tapping the bubble, plus a separate `onClick` callback.
- `AntFloatingBubbleController` with `visible`, `position`, `show`, `hide`, `moveTo`, `snapToEdge`, `snapToNearestEdge` and `resetPosition`.
- Custom bubble `size`, `backgroundColor` and content, with design logical pixels scaled through the theme scale factor.
- Stable keys (`kAntFloatingPanelKey`, `kAntFloatingPanelHandleKey`, `kAntFloatingPanelContentKey`) for locating panel parts.

### Notes

- Both controllers extend `ChangeNotifier`; calls made while detached are safe no-ops.
- The bubble renders a full-size transparent layer and lets pointer events pass through outside the bubble and its menu, so it must be hosted in a `Stack` or `Overlay`.
- The panel does not provide scrolling; its child is expected to be a scrollable if the content overflows.
