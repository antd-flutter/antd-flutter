# Changelog

## 1.0.2

- Republished with a Web-compatible dependency chain.
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_swipe_action` package.

### Features

- `AntSwipeAction` wraps any row and reveals action groups with horizontal swipes: left for `rightActions`, right for `leftActions`.
- Content follows the finger 1:1 up to the total action width, then applies rubber-band damping with a bounded overdrag.
- Release snaps open past half of the revealed width, otherwise closes; a fast fling above the velocity threshold opens or closes in the swipe direction.
- Action taps run `onPressed` and close the row when `closeOnAction` is true; tapping the content while open always closes it.
- `AntSwipeActionItem` supports per-action text, color, callback, and a disabled state that suppresses taps without hiding the button.
- `onOpened` reports the revealed side after the open animation, and `onClosed` fires after the close animation.
- Horizontal-only gesture recognition preserves vertical scrolling in lists.
- Empty action groups disable their swipe direction instead of producing dead movement.
- Snap animation uses a dedicated duration and curve; `resolveSnapTarget` exposes the decision for testing.

### API

- Added `AntSwipeAction` and `AntSwipeActionItem`.
- Added the `kAntSwipeAction*` gesture and animation constants.
