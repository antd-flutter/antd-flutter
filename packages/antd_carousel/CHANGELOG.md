# Changelog

## 1.0.2

- Republished with a Web-compatible dependency chain.
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_carousel` package.

### Features

- `AntCarousel` page switcher with `children` / `items`, fixed-height overlay layout, and optional autoplay with a configurable `autoplayInterval`.
- Infinite loop implemented with `PageView.builder` and index modulo, so continuous swiping in either direction never bounces at the ends.
- Page indicators in four positions (`top`, `bottom`, `left`, `right`), including a vertical dot column for left and right.
- Previous/next arrows that render only when more than one page is present.
- Vertical carousel mode.
- Uncontrolled index via `defaultCurrent`, and controlled index via `current` + `onChange`.
- `AntCarouselController.goTo` for animated or instant programmatic jumps.
- `pauseOnHover` to suspend autoplay while the pointer is over the carousel.

### Notes

- Autoplay skips its tick while a page transition is in flight instead of restarting the animation.
- Loop is active only with more than one page; dots are drawn for every page including a single-page carousel, while arrows require more than one page.
- Hover tracking for arrow opacity is installed only when `pauseOnHover` is enabled.
- The carousel does not create a bounded height; the host must provide one.
