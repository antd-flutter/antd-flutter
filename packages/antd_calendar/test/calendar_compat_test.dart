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


List<String> _weekOrder(WidgetTester tester) {
  const labels = ['一', '二', '三', '四', '五', '六', '日'];
  final entries = <(String, double)>[
    for (final label in labels)
      (label, tester.getTopLeft(find.text(label).first).dx),
  ];
  entries.sort((a, b) => a.$2.compareTo(b.$2));
  return entries.map((e) => e.$1).toList();
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
    expect(_weekOrder(tester), ['日', '一', '二', '三', '四', '五', '六']);
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
    expect(_weekOrder(tester), ['日', '一', '二', '三', '四', '五', '六']);
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
    expect(_weekOrder(tester), ['一', '二', '三', '四', '五', '六', '日']);
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
