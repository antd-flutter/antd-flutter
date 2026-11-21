# Changelog

## 1.0.3

- Added a plain-text summary line to every icon's dartdoc so the public API documentation coverage is reported correctly (862/862 documented elements).
- Formatted the generated icon sources to satisfy dart format.

## 1.0.2

- Republished with corrected pubspec metadata and changelog formatting for pub.dev.


## 1.0.1

- Added 698 Outlined and Filled icons as `const IconData` values backed by the bundled `AntIcons.ttf` font family, with names matching the Ant Design React package.
- Added `AntIcons.outlinedIcons` and `AntIcons.filledIcons` catalogs containing each icon name and definition.
- Added 150 TwoTone icons as packaged SVG assets, exposed through `AntIconsTwotone` path constants and the `AntIconsTwotone.twotoneIcons` catalog.
- Added `AntdIcon`, a unified widget that dispatches between TTF and SVG rendering based on the icon argument and supports `size`, `color`, `twoToneColor`, and `semanticLabel`.
- Added runtime TwoTone color substitution with automatic secondary-color derivation and a path/primary/secondary cache for repeat renders.
- Added support for Flutter's native `Icon` widget with every Outlined and Filled constant.
