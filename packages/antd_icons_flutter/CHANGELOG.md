# Changelog

## 1.0.1

- Added 698 Outlined and Filled icons as `const IconData` values backed by the bundled `AntIcons.ttf` font family, with names matching the Ant Design React package.
- Added `AntIcons.outlinedIcons` and `AntIcons.filledIcons` catalogs containing each icon name and definition.
- Added 150 TwoTone icons as packaged SVG assets, exposed through `AntIconsTwotone` path constants and the `AntIconsTwotone.twotoneIcons` catalog.
- Added `AntdIcon`, a unified widget that dispatches between TTF and SVG rendering based on the icon argument and supports `size`, `color`, `twoToneColor`, and `semanticLabel`.
- Added runtime TwoTone color substitution with automatic secondary-color derivation and a path/primary/secondary cache for repeat renders.
- Added support for Flutter's native `Icon` widget with every Outlined and Filled constant.
