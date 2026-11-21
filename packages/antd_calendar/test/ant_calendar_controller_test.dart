import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 构建固定视口高度的日历（card 形态）。
Widget _buildCalendar(AntCalendarController controller) {
  return _wrap(
    SizedBox(
      height: 620,
      child: AntCalendar(
        controller: controller,
        defaultValue: DateTime(2026, 1, 15),
      ),
    ),
  );
}

void main() {
  group('AntCalendarController（R35.2 Controller 优先）', () {
    testWidgets('nextMonth/previousMonth 程序化翻页', (tester) async {
      final controller = AntCalendarController();
      await tester.pumpWidget(_buildCalendar(controller));
      expect(controller.isAttached, isTrue);
      expect(find.text('2026年1月'), findsOneWidget);

      controller.nextMonth();
      await tester.pumpAndSettle();
      expect(find.text('2026年2月'), findsOneWidget);

      controller.previousMonth();
      await tester.pumpAndSettle();
      expect(find.text('2026年1月'), findsOneWidget);
    });

    testWidgets('goToYearMonth 程序化跳转年月', (tester) async {
      final controller = AntCalendarController();
      await tester.pumpWidget(_buildCalendar(controller));

      controller.goToYearMonth(2027, 12);
      await tester.pumpAndSettle();
      expect(find.text('2027年12月'), findsOneWidget);
    });

    testWidgets('controller 换绑：旧 detach 新 attach', (tester) async {
      final first = AntCalendarController();
      final second = AntCalendarController();
      Widget build(AntCalendarController controller) => _wrap(
            SizedBox(
              height: 620,
              child: AntCalendar(
                key: const ValueKey<String>('same'),
                controller: controller,
                defaultValue: DateTime(2026, 1, 15),
              ),
            ),
          );

      await tester.pumpWidget(build(first));
      expect(first.isAttached, isTrue);
      expect(second.isAttached, isFalse);

      await tester.pumpWidget(build(second));
      expect(first.isAttached, isFalse);
      expect(second.isAttached, isTrue);

      second.nextMonth();
      await tester.pumpAndSettle();
      expect(find.text('2026年2月'), findsOneWidget);
    });

    testWidgets('组件卸载后 controller 自动 detach', (tester) async {
      final controller = AntCalendarController();
      await tester.pumpWidget(_buildCalendar(controller));
      expect(controller.isAttached, isTrue);
      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
      expect(
        () => controller.nextMonth(),
        throwsStateError,
      );
    });
  });
}
