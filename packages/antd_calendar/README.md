# antd_calendar - Ant Design calendar and date picker for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/README_CN.md)

## Positioning & design

`antd_calendar` renders a month or year panel with Ant Design visuals and ships three coordinated pieces: `AntCalendar` for inline or full-screen display, `AntCalendarPicker` for a bottom-sheet date picker anchored to a trigger widget, and `AntCalendarController` for driving page navigation from outside the widget. A single `platform` switch selects the desktop renderer (year/month dropdowns, week numbers, mode switching) or the mobile renderer (touch-sized cells, range selection), so the same calendar declaration adapts to both form factors.

Design rules:

- **One state model, two renderers.** Selection, page bounds, and disabled dates are declared once; the renderer only changes presentation.
- **Selection is explicit.** `value` makes the calendar controlled, `defaultValue` seeds uncontrolled state, and `onSelect` / `onChange` / `onRangeChange` report what changed.
- **Cell content is composable.** `cellRender` decorates the default cell, `fullCellRender` replaces it entirely, and both fall back to the built-in rendering when they return `null`.
- **Locale is injected, not hard-coded.** `AntCalendarLocaleProvider` supplies weekday labels, month patterns, and button text; presets cover 15 languages and individual fields can be overridden.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_calendar: ^1.0.0
```

Wrap the subtree in `AntTheme`; day cells, panel headers, and popup chrome come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: const MaterialApp(home: CalendarPage()),
      ),
    );

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selected = DateTime(2025, 3, 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: AntCalendar(
        value: _selected,
        weekStartsOn: AntCalendarWeekStartsOn.monday,
        fullscreen: true,
        onSelect: (date) => setState(() => _selected = date),
      ),
    );
  }
}
```

The page shows a full-width month panel with the selected day highlighted. `fullscreen: true` forces the large calendar form; omit it for the compact card form.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/docs/api-index.md)

### 1. Disabled dates and custom day content

```dart
AntCalendar(
  value: _selected,
  onSelect: (date) => setState(() => _selected = date),
  disabledDate: (date) => date.weekday == DateTime.saturday || date.weekday == DateTime.sunday,
  validRange: AntCalendarValidRange(DateTime(2025, 1, 1), DateTime(2025, 12, 31)),
  cellRender: (date, info) {
    if (date.day != 1) return null;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  },
)
```

`disabledDate` blocks interaction per day, `validRange` also clips panel navigation to the year. `cellRender` returning `null` keeps the default cell, so the marker only decorates the first day of each month.

### 2. Range selection on the mobile renderer

```dart
AntCalendar(
  platform: AntCalendarPlatform.mobile,
  selectionMode: AntCalendarSelectionMode.range,
  defaultRangeValue: [DateTime(2025, 3, 3), DateTime(2025, 3, 9)],
  weekStartsOn: AntCalendarWeekStartsOn.monday,
  onRangeChange: (range) => debugPrint('range=$range'),
)
```

The mobile renderer paints the start, end, and in-between days as one band. `rangeValue` / `onRangeChange` are range-mode only, and range state is supported by the mobile renderer.

### 3. Bottom-sheet picker attached to a field

```dart
class PickDateField extends StatefulWidget {
  const PickDateField({super.key});

  @override
  State<PickDateField> createState() => _PickDateFieldState();
}

class _PickDateFieldState extends State<PickDateField> {
  List<DateTime> _dates = <DateTime>[];

  @override
  Widget build(BuildContext context) {
    return AntCalendarPicker(
      title: 'Deadline',
      defaultValue: _dates,
      weekStartsOn: AntCalendarWeekStartsOn.monday,
      onConfirm: (dates) => setState(() => _dates = dates),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        ),
        child: Text(
          _dates.isEmpty ? 'Select a date' : _dates.first.toString(),
        ),
      ),
    );
  }
}
```

Tapping the child opens a modal bottom sheet; confirm reports the picked list through `onConfirm`, while `onChange` fires on every in-sheet selection. `onCancel`, `onClose`, and `onMaskClick` distinguish the dismissal paths.

Wrap any subtree in `AntCalendarLocaleProvider(locale: AntCalendarLocale.en, child: ...)` to switch weekday and button text without touching individual widgets.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/calendar/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_calendar/
├── lib/
│   ├── antd_calendar.dart                  # barrel export
│   └── src/
│       ├── calendar/
│       │   ├── ant_calendar.dart           # public calendar widget
│       │   ├── ant_calendar_controller.dart# month/page navigation
│       │   ├── ant_calendar_types.dart     # modes, layouts, callbacks
│       │   ├── calendar_core/              # state, locale, shared math
│       │   ├── desktop/                    # desktop renderer
│       │   └── mobile/                     # mobile renderer
│       └── calendar_picker/
│           └── ant_calendar_picker.dart    # bottom-sheet picker
├── example/lib/main.dart                   # runnable gallery
├── docs/api-index.md                       # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
