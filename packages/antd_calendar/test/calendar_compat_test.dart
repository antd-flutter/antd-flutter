import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

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

void main() {
  testWidgets('desktop defaults to Sunday week start', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntCalendar(
          platform: AntCalendarPlatform.desktop,
          defaultValue: DateTime(2024, 6, 10),
        ),
      ),
    );
    final sunday = tester.getTopLeft(find.text('日').first);
    final monday = tester.getTopLeft(find.text('一').first);
    expect(sunday.dx, lessThan(monday.dx));
  });

  testWidgets('mobile defaults to Sunday week start', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntCalendar(
          platform: AntCalendarPlatform.mobile,
          defaultValue: DateTime(2024, 6, 10),
          selectionMode: AntCalendarSelectionMode.single,
        ),
      ),
    );
    final sunday = tester.getTopLeft(find.text('日').first);
    final monday = tester.getTopLeft(find.text('一').first);
    expect(sunday.dx, lessThan(monday.dx));
  });

  testWidgets('explicit monday keeps monday-first header', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntCalendar(
          platform: AntCalendarPlatform.mobile,
          weekStartsOn: AntCalendarWeekStartsOn.monday,
          defaultValue: DateTime(2024, 6, 10),
          selectionMode: AntCalendarSelectionMode.single,
        ),
      ),
    );
    final sunday = tester.getTopLeft(find.text('日').first);
    final monday = tester.getTopLeft(find.text('一').first);
    expect(monday.dx, lessThan(sunday.dx));
  });

  test('rangeValue is rejected on desktop renderer', () {
    expect(
      () => AntCalendar(
        platform: AntCalendarPlatform.desktop,
        selectionMode: AntCalendarSelectionMode.range,
        rangeValue: [DateTime(2024, 6, 10), DateTime(2024, 6, 12)],
      ),
      throwsAssertionError,
    );
  });
}
