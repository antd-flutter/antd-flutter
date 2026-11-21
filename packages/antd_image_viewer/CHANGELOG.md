# Changelog

## 1.0.2

- Web support: network images go through a conditional loader (Image.network on Web).
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_image_viewer` package.

### Features

- `AntImageViewer` fullscreen overlay viewer with a controlled `open` flag, `onClose` and `afterClose` callbacks.
- Multi-image browsing through `PageView.builder` with a `current / total` page counter.
- Pinch zoom and pan backed by `InteractiveViewer`, bounded by `maxZoomRatio`.
- Double-tap zoom toggling between 1x and `maxZoomRatio`, with `enableCompositeZoom` to opt out.
- Tap-to-close at 1x zoom, a close button, and Escape-key dismissal on keyboard platforms.
- Network images loaded through `cached_network_image`, asset images for non-`http` sources, with a shared placeholder and error state.
- `AntImageViewerDefaults` exposing the barrier opacity, fade duration, zoom defaults, source detection and reusable image builders.

### Notes

- The overlay captures its configuration when it opens; changes while open require closing and reopening.
- Zoom gestures take precedence over the close tap once the page is zoomed.
- The viewer renders no layout of its own; the visible UI is an entry in the root overlay.
