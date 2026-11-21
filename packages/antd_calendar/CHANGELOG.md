# Changelog

## 1.0.0

Initial stable release of the standalone `antd_calendar` package.

### Architecture

- Split the calendar into a widget-free core plus two renderers: `calendar_core` (config snapshot, `AntCalendarCoreState` `ChangeNotifier`, grid math, locale) with `desktop/` (antd v6) and `mobile/` (antd-mobile v5) implementations.
- Added platform dispatch through `layout` (`auto` / `fullscreen` / `card`) and `platform` (`auto` / `desktop` / `mobile`), resolving `auto` via `AntResponsive` with a desktop fallback when no responsive scope exists.
- Dependency direction is one-way: `antd_calendar` → `antd_flutter_ui` → `antd_theme`; no dependency on other standalone component packages.

### Features

- `AntCalendar` month grid with single, range and multi selection, `eventLoader` dots, `validRange` / `min` / `max` bounds, `minPage` / `maxPage` navigation clamping, and `disabledDate` / `shouldDisableDate` aliases.
- Panel format switching: `month`, `twoWeeks`, `week` via `calendarFormat`, `showFormatSwitcher`, `onFormatChanged`.
- Desktop cells in three layers: `dateCell`, `cellRender` with `AntCalendarCellRenderInfo`, and `fullCellRender`; year panel via `monthCellRender` / `monthFullCellRender`; `headerRender` for a fully custom header; optional `showWeek` week-number column; year/month dropdowns with `enableYearMonthDropdown`.
- Mobile layering: `renderDate` and `renderLabel`, `mobileCellRender`, four navigation arrows, optional `showYearNavButtons`, swipe-to-paginate.
- `AntCalendarController` with `previousMonth`, `nextMonth`, `goToYearMonth`, `jumpToToday`; throws `StateError` before attach and detaches on dispose.
- `AntCalendarPicker` (bottom sheet) and `AntCalendarPickerView` (embedded) with single/range modes, `min` / `max` month clamping, `allowClear`, `onConfirm` / `onCancel` / `onChange`, `visible` / `onClose` / `onMaskClick`, `showCloseButton`, `closeOnMaskClick`.
- `AntCalendarLocale` with 15 built-in presets (`zh`, `zhTw`, `en`, `ja`, `ko`, `fr`, `de`, `es`, `ru`, `pt`, `it`, `ar`, `th`, `vi`, `id`), `AntCalendarLocale.fromLanguageCode` fallback, and `AntCalendarLocaleProvider` global injection.

### Breaking changes

- `weekStartsOn` now defaults to **Sunday** on both renderers. Monday-first layouts must pass `AntCalendarWeekStartsOn.monday` explicitly.
- `selectionMode` is now nullable: `null` renders a display-only calendar whose days are not tappable. The default remains `AntCalendarSelectionMode.single`.
- Range selection is controlled through `rangeValue` / `defaultRangeValue` plus `onRangeChange` instead of a plain value list. Both lists must contain exactly two dates, and the desktop renderer asserts when they are supplied — range control is a mobile-renderer capability.
- `dateCellRender` and `dateFullCellRender` are deprecated in favor of `cellRender` and `fullCellRender`; they remain as compatibility aliases.
- `allowClear` defaults differ by renderer: `true` on mobile, `false` on desktop.
