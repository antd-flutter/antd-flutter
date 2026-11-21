import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

DateTime _date(int y, int m, int d) => DateTime(y, m, d);

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: SingleChildScrollView(child: Material(child: child)),
      ),
    ),
  );
}

AntCalendar _mobileCalendar({
  DateTime? value,
  DateTime? defaultValue,
  AntCalendarSelectionMode? selectionMode = AntCalendarSelectionMode.single,
  bool? allowClear,
  ValueChanged<DateTime>? onSelect,
  ValueChanged<DateTime?>? onChange,
  ValueChanged<List<DateTime>?>? onRangeChange,
  void Function(DateTime start, DateTime end)? onRangeSelected,
  List<DateTime>? rangeValue,
  List<DateTime>? defaultRangeValue,
  bool Function(DateTime)? disabledDate,
  bool Function(DateTime)? shouldDisableDate,
  DateTime? min,
  DateTime? max,
  AntCalendarPage? minPage,
  AntCalendarPage? maxPage,
  AntCalendarFormat calendarFormat = AntCalendarFormat.month,
  bool multiSelect = false,
  ValueChanged<List<DateTime>>? onSelectMulti,
  List<DateTime> Function(DateTime)? eventLoader,
  bool showFormatSwitcher = false,
  void Function(int year, int month)? onPageChange,
  Widget? Function(DateTime)? renderDate,
  Widget? Function(DateTime)? renderLabel,
  Widget Function(Widget oriNode, {required DateTime date})? mobileCellRender,
  Widget? prevYearButton =
      const AntCalendarBuiltInNavButton(AntIcons.doubleLeftOutlined),
  Widget? prevMonthButton =
      const AntCalendarBuiltInNavButton(AntIcons.leftOutlined),
  Widget? nextMonthButton =
      const AntCalendarBuiltInNavButton(AntIcons.rightOutlined),
  Widget? nextYearButton =
      const AntCalendarBuiltInNavButton(AntIcons.doubleRightOutlined),
}) {
  return AntCalendar(
    platform: AntCalendarPlatform.mobile,
    layout: AntCalendarLayout.card,
    value: value,
    defaultValue: defaultValue,
    selectionMode: selectionMode,
    allowClear: allowClear,
    onSelect: onSelect,
    onChange: onChange,
    onRangeChange: onRangeChange,
    onRangeSelected: onRangeSelected,
    rangeValue: rangeValue,
    defaultRangeValue: defaultRangeValue,
    disabledDate: disabledDate,
    shouldDisableDate: shouldDisableDate,
    min: min,
    max: max,
    minPage: minPage,
    maxPage: maxPage,
    calendarFormat: calendarFormat,
    multiSelect: multiSelect,
    onSelectMulti: onSelectMulti,
    eventLoader: eventLoader,
    showFormatSwitcher: showFormatSwitcher,
    onPageChange: onPageChange,
    renderDate: renderDate,
    renderLabel: renderLabel,
    mobileCellRender: mobileCellRender,
    prevYearButton: prevYearButton,
    prevMonthButton: prevMonthButton,
    nextMonthButton: nextMonthButton,
    nextYearButton: nextYearButton,
  );
}

Finder _cell(DateTime date) => find.byKey(
      ValueKey(
        'ant-calendar-mobile-cell-${date.year}-${date.month}-${date.day}',
      ),
    );

Color? _cellColor(WidgetTester tester, DateTime date) {
  final container = tester.widget<Container>(_cell(date));
  return (container.decoration as BoxDecoration?)?.color;
}

Future<void> _tapDay(WidgetTester tester, DateTime date) async {
  await tester.ensureVisible(_cell(date));
  await tester.tap(_cell(date));
  await tester.pump();
}

int _dateTextCount(WidgetTester tester) => tester
    .widgetList<Text>(
      find.byWidgetPredicate(
        (w) => w is Text && RegExp(r'^\d+$').hasMatch(w.data ?? ''),
      ),
    )
    .length;

void main() {
  final june = _date(2024, 6, 10);

  testWidgets('mobile header renders title and four navigation buttons',
      (tester) async {
    await tester.pumpWidget(_wrap(_mobileCalendar(value: june)));
    expect(find.text('2024年6月'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('ant-calendar-prev-year')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('ant-calendar-prev-month')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('ant-calendar-next-month')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('ant-calendar-next-year')),
      findsOneWidget,
    );
  });

  testWidgets('mobile header buttons can be hidden and replaced',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          prevYearButton: null,
          nextYearButton: null,
          prevMonthButton: const Text('PM'),
          nextMonthButton: const Text('NM'),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('ant-calendar-prev-year')), findsNothing);
    expect(find.byKey(const ValueKey('ant-calendar-next-year')), findsNothing);
    expect(find.text('PM'), findsOneWidget);
    expect(find.text('NM'), findsOneWidget);
  });

  testWidgets('week row is 45 high and starts on Sunday', (tester) async {
    await tester.pumpWidget(_wrap(_mobileCalendar(value: june)));
    final row = find.byKey(const ValueKey('ant-calendar-mobile-week-row'));
    expect(tester.getSize(row).height, 45);
    expect(find.text('日'), findsOneWidget);
    expect(find.text('六'), findsOneWidget);
    // 周日起始：2024-06 首格为 5/26（周日）。
    expect(_cell(_date(2024, 5, 26)), findsOneWidget);
  });

  testWidgets('day cell is 48 high with 19px date', (tester) async {
    await tester.pumpWidget(_wrap(_mobileCalendar(value: june)));
    expect(tester.getSize(_cell(june)).height, 48);
    final text = tester.widget<Text>(
      find.descendant(of: _cell(june), matching: find.text('10')),
    );
    expect(text.style!.fontSize, 19);
  });

  testWidgets('selected day uses primary background and white text',
      (tester) async {
    await tester.pumpWidget(
      _wrap(_mobileCalendar(defaultValue: june)),
    );
    final theme = AntThemeData.light();
    expect(_cellColor(tester, june), theme.colorPrimary);
    final text = tester.widget<Text>(
      find.descendant(of: _cell(june), matching: find.text('10')),
    );
    expect(text.style!.color, Colors.white);
  });

  testWidgets('single allowClear defaults to true on mobile', (tester) async {
    final changes = <DateTime?>[];
    var selectedCalls = 0;
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          defaultValue: june,
          onChange: changes.add,
          onSelect: (_) => selectedCalls++,
        ),
      ),
    );
    await _tapDay(tester, june);
    expect(changes, [null]);
    expect(selectedCalls, 0);
    expect(_cellColor(tester, june), isNull);
  });

  testWidgets('range selects pending first then sorted second tap',
      (tester) async {
    final ranges = <List<DateTime>?>[];
    List<DateTime>? selectedRange;
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          defaultValue: june,
          selectionMode: AntCalendarSelectionMode.range,
          onRangeChange: ranges.add,
          onRangeSelected: (start, end) => selectedRange = [start, end],
        ),
      ),
    );
    await _tapDay(tester, _date(2024, 6, 12));
    expect(ranges.last, [_date(2024, 6, 12), _date(2024, 6, 12)]);
    expect(
      _cellColor(tester, _date(2024, 6, 12)),
      AntThemeData.light().colorPrimary,
    );

    await _tapDay(tester, _date(2024, 6, 5));
    expect(ranges.last, [_date(2024, 6, 5), _date(2024, 6, 12)]);
    expect(selectedRange, [_date(2024, 6, 5), _date(2024, 6, 12)]);
    // 范围中间日期同样为主色底。
    expect(
      _cellColor(tester, _date(2024, 6, 8)),
      AntThemeData.light().colorPrimary,
    );
  });

  testWidgets('intermediate same-day tap resets the range start',
      (tester) async {
    final ranges = <List<DateTime>?>[];
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          defaultValue: june,
          selectionMode: AntCalendarSelectionMode.range,
          onRangeChange: ranges.add,
        ),
      ),
    );
    await _tapDay(tester, _date(2024, 6, 12));
    await _tapDay(tester, _date(2024, 6, 12));
    expect(ranges.last, [_date(2024, 6, 12), _date(2024, 6, 12)]);
    expect(
      _cellColor(tester, _date(2024, 6, 12)),
      AntThemeData.light().colorPrimary,
    );

    await _tapDay(tester, _date(2024, 6, 5));
    expect(ranges.last, [_date(2024, 6, 5), _date(2024, 6, 12)]);
  });

  testWidgets('completed range clears when allowClear is true', (tester) async {
    final ranges = <List<DateTime>?>[];
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          selectionMode: AntCalendarSelectionMode.range,
          defaultRangeValue: [_date(2024, 6, 5), _date(2024, 6, 12)],
          onRangeChange: ranges.add,
        ),
      ),
    );
    expect(
      _cellColor(tester, _date(2024, 6, 5)),
      AntThemeData.light().colorPrimary,
    );
    await _tapDay(tester, _date(2024, 6, 5));
    expect(ranges, [null]);
    expect(_cellColor(tester, _date(2024, 6, 5)), isNull);
  });

  testWidgets('selectionMode null makes the calendar display-only',
      (tester) async {
    var changed = 0;
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          defaultValue: june,
          selectionMode: null,
          onChange: (_) => changed++,
        ),
      ),
    );
    await _tapDay(tester, june);
    expect(changed, 0);
    // allowClear 不生效，原选中态保持。
    expect(_cellColor(tester, june), AntThemeData.light().colorPrimary);
  });

  testWidgets('renderDate and renderLabel replace default content',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          renderDate: (date) => Text('D${date.day}'),
          renderLabel: (date) => Text('L${date.day}'),
        ),
      ),
    );
    expect(find.text('D10'), findsOneWidget);
    expect(find.text('L10'), findsOneWidget);
    expect(find.text('10'), findsNothing);
  });

  testWidgets('mobileCellRender wraps the whole cell', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          mobileCellRender: (oriNode, {required date}) {
            if (date.day == 10) {
              return Container(
                key: const ValueKey('mobile-cell-wrap-10'),
                child: oriNode,
              );
            }
            return oriNode;
          },
        ),
      ),
    );
    final wrap = find.byKey(const ValueKey('mobile-cell-wrap-10'));
    expect(wrap, findsOneWidget);
    expect(
      find.descendant(of: wrap, matching: _cell(june)),
      findsOneWidget,
    );
  });

  testWidgets('minPage and maxPage clip arrow navigation', (tester) async {
    final pages = <String>[];
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          minPage: const AntCalendarPage(year: 2024, month: 6),
          maxPage: const AntCalendarPage(year: 2024, month: 7),
          onPageChange: (year, month) => pages.add('$year-$month'),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('ant-calendar-prev-month')));
    await tester.pump();
    expect(find.text('2024年6月'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('ant-calendar-next-month')));
    await tester.pump();
    expect(find.text('2024年7月'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('ant-calendar-next-month')));
    await tester.pump();
    expect(find.text('2024年7月'), findsOneWidget);
    expect(pages, ['2024-7']);
  });

  testWidgets('onPageChange fires after month and year navigation',
      (tester) async {
    final pages = <String>[];
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          onPageChange: (year, month) => pages.add('$year-$month'),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('ant-calendar-next-month')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('ant-calendar-prev-year')));
    await tester.pump();
    expect(pages, ['2024-7', '2023-7']);
    expect(find.text('2023年7月'), findsOneWidget);
  });

  testWidgets('disabledDate and shouldDisableDate aliases both disable',
      (tester) async {
    var changed = 0;
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          disabledDate: (date) => date.day == 15,
          shouldDisableDate: (date) => date.day == 16,
          min: _date(2024, 6, 5),
          onChange: (_) => changed++,
        ),
      ),
    );
    final theme = AntThemeData.light();
    Text dayText(int day) => tester.widget<Text>(
          find.descendant(
            of: _cell(_date(2024, 6, day)),
            matching: find.text('$day'),
          ),
        );
    expect(dayText(15).style!.color, theme.colorTextQuaternary);
    expect(dayText(16).style!.color, theme.colorTextQuaternary);
    expect(dayText(4).style!.color, theme.colorTextQuaternary);
    await _tapDay(tester, _date(2024, 6, 15));
    await _tapDay(tester, _date(2024, 6, 16));
    expect(changed, 0);
  });

  testWidgets('controlled rangeValue renders an initial range', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          selectionMode: AntCalendarSelectionMode.range,
          rangeValue: [_date(2024, 6, 5), _date(2024, 6, 12)],
        ),
      ),
    );
    final theme = AntThemeData.light();
    expect(_cellColor(tester, _date(2024, 6, 5)), theme.colorPrimary);
    expect(_cellColor(tester, _date(2024, 6, 8)), theme.colorPrimary);
    expect(_cellColor(tester, _date(2024, 6, 12)), theme.colorPrimary);
  });

  testWidgets('controlled rangeValue follows parent updates and clearing',
      (tester) async {
    List<DateTime>? range = [_date(2024, 6, 5), _date(2024, 6, 12)];
    late StateSetter setOuterState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            setOuterState = setState;
            return _mobileCalendar(
              defaultValue: june,
              selectionMode: AntCalendarSelectionMode.range,
              rangeValue: range,
              onRangeChange: (next) => setState(() => range = next),
            );
          },
        ),
      ),
    );
    final theme = AntThemeData.light();
    expect(_cellColor(tester, _date(2024, 6, 8)), theme.colorPrimary);

    await _tapDay(tester, _date(2024, 6, 18));
    expect(range, [_date(2024, 6, 18), _date(2024, 6, 18)]);
    expect(_cellColor(tester, _date(2024, 6, 18)), theme.colorPrimary);
    expect(_cellColor(tester, _date(2024, 6, 8)), isNull);

    await _tapDay(tester, _date(2024, 6, 20));
    expect(range, [_date(2024, 6, 18), _date(2024, 6, 20)]);
    setOuterState(() => range = null);
    await tester.pump();
    expect(_cellColor(tester, _date(2024, 6, 18)), isNull);
    expect(_cellColor(tester, _date(2024, 6, 20)), isNull);
  });

  testWidgets('today uses primary text color', (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      _wrap(_mobileCalendar(value: DateTime(now.year, now.month, 1))),
    );
    final text = tester.widget<Text>(
      find.descendant(
        of: _cell(_date(now.year, now.month, now.day)),
        matching: find.text('${now.day}'),
      ),
    );
    expect(text.style!.color, AntThemeData.light().colorPrimary);
  });

  // ---- 扩展能力：非默认参数走兼容渲染分支 ----

  testWidgets('week calendarFormat uses the compatibility branch',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          calendarFormat: AntCalendarFormat.week,
        ),
      ),
    );
    expect(_dateTextCount(tester), 7);
  });

  testWidgets('twoWeeks calendarFormat uses the compatibility branch',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          calendarFormat: AntCalendarFormat.twoWeeks,
        ),
      ),
    );
    expect(_dateTextCount(tester), 14);
  });

  testWidgets('multiSelect uses the compatibility branch', (tester) async {
    final selections = <List<DateTime>>[];
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          multiSelect: true,
          onSelectMulti: selections.add,
        ),
      ),
    );
    await _tapDay(tester, _date(2024, 6, 10));
    await _tapDay(tester, _date(2024, 6, 12));
    expect(selections.last, [_date(2024, 6, 10), _date(2024, 6, 12)]);
  });

  testWidgets('eventLoader renders event dots in compatibility branch',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _mobileCalendar(
          value: june,
          eventLoader: (date) => [date],
        ),
      ),
    );
    final dots = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          (w.decoration as BoxDecoration?)?.shape == BoxShape.circle,
    );
    expect(dots, findsWidgets);
  });

  testWidgets('showFormatSwitcher switches from month to week in compat',
      (tester) async {
    await tester.pumpWidget(
      _wrap(_mobileCalendar(value: june, showFormatSwitcher: true)),
    );
    expect(find.text('月'), findsWidgets);
    expect(find.text('两周'), findsOneWidget);
    expect(find.text('周'), findsOneWidget);
    await tester.tap(find.text('周'));
    await tester.pump();
    expect(_dateTextCount(tester), 7);
  });
}
