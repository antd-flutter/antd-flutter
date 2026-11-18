import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime _date(int y, int m, int d) => DateTime(y, m, d);

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: SingleChildScrollView(
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

AntCalendar _calendar({
  DateTime? value,
  DateTime? defaultValue,
  ValueChanged<DateTime>? onSelect,
  AntCalendarWeekStartsOn weekStartsOn = AntCalendarWeekStartsOn.monday,
  bool fullscreen = false,
  AntCalendarDateCellBuilder? dateCell,
  bool Function(DateTime)? disabledDate,
  AntCalendarLayout? layout,
  Key? key,
}) {
  return AntCalendar(
    key: key,
    layout: layout ?? AntCalendarLayout.card,
    value: value,
    defaultValue: defaultValue,
    onSelect: onSelect,
    weekStartsOn: weekStartsOn,
    fullscreen: fullscreen,
    dateCell: dateCell,
    disabledDate: disabledDate,
  );
}

void main() {
  // 固定展示月份便于断言：2024 年 6 月（6 月 1 日为周六）。
  final june2024 = _date(2024, 6, 10);

  group('AntCalendar', () {
    testWidgets('renders fixed 42 cells grid', (tester) async {
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      // 6 行 × 7 列 = 42 个日期数字（含重复的补位日期数字）。
      final cells = find.byWidgetPredicate(
        (w) => w is Text && RegExp(r'^\d+$').hasMatch(w.data ?? ''),
      );
      expect(cells.evaluate().length, 42);
    });

    testWidgets('defaultValue is highlighted as selected', (tester) async {
      await tester.pumpWidget(
        _wrap(_calendar(defaultValue: _date(2024, 6, 10))),
      );
      // 选中日期文字为白色（colorPrimary 背景上）。
      final text = tester.widget<Text>(find.text('10').first);
      expect(text.style!.color, Colors.white);
    });

    testWidgets('today is highlighted with primary color border',
        (tester) async {
      final now = DateTime.now();
      // 选中同月 1 日，保证今天本身未被选中但仍展示在网格中。
      await tester.pumpWidget(
        _wrap(_calendar(value: DateTime(now.year, now.month, 1))),
      );
      // 找到今天数字所在单元格容器，验证今天有主色边框高亮。
      final todayText = tester.widget<Text>(find.text('${now.day}').first);
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byWidget(todayText),
              matching: find.byWidgetPredicate(
                (w) => w is Container && w.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
      expect(
        (decoration.border! as Border).top.color,
        AntThemeData.light().colorPrimary,
      );
    });

    testWidgets('tap a day fires onSelect and updates selection',
        (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          _calendar(
          value: _date(2024, 6, 1),
          onSelect: (d) => picked = d,
          ),
        ),
      );
      await tester.tap(find.text('15').first);
      await tester.pump();
      expect(picked, _date(2024, 6, 15));
    });

    testWidgets('controlled value updates selection', (tester) async {
      DateTime? current = _date(2024, 6, 1);
      late StateSetter setState;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return _calendar(value: current);
            },
          ),
        ),
      );
      // 初始选中 1 日为白色文字。
      expect(
        tester.widget<Text>(find.text('1').first).style!.color,
        Colors.white,
      );
      setState(() => current = _date(2024, 6, 20));
      await tester.pump();
      expect(
        tester.widget<Text>(find.text('20').first).style!.color,
        Colors.white,
      );
      expect(
        tester.widget<Text>(find.text('1').first).style!.color,
        isNot(Colors.white),
      );
    });

    testWidgets('prev month navigation changes header title', (tester) async {
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      expect(find.text('2024年6月'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(find.text('2024年5月'), findsOneWidget);
    });

    testWidgets('next month navigation changes header title', (tester) async {
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('2024年7月'), findsOneWidget);
    });

    testWidgets('current month button returns to today month',
        (tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('2024年7月'), findsOneWidget);
      await tester.tap(find.text('本月'));
      await tester.pump();
      expect(find.text('${now.year}年${now.month}月'), findsOneWidget);
    });

    testWidgets('monday week start shows 一..日 header order',
        (tester) async {
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      const expected = ['一', '二', '三', '四', '五', '六', '日'];
      for (final label in expected) {
        expect(find.text(label), findsOneWidget);
      }
      // 周一起始时 2024-06-01（周六）位于第 6 列，首格为 5 月 27 日，
      // 第一行应为 27 28 29 30 31 1 2（'1'/'2' 等在月末补位中会重复出现）。
      const firstRow = ['27', '28', '29', '30', '31', '1', '2'];
      for (final day in firstRow) {
        expect(find.text(day), findsWidgets);
      }
      // 5/27（补位）与 6/27（本月）同格值 27 出现两次。
      expect(find.text('27'), findsNWidgets(2));
    });

    testWidgets('sunday week start shows 日..六 header order',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
          value: june2024,
          weekStartsOn: AntCalendarWeekStartsOn.sunday,
          ),
        ),
      );
      const expected = ['日', '一', '二', '三', '四', '五', '六'];
      for (final label in expected) {
        expect(find.text(label), findsOneWidget);
      }
      // 周日起始时第一行为 26 27 28 29 30 31 1（补位日 26 仅一次出现）。
      expect(find.text('26'), findsWidgets);
      // 6/1（本月）与 7/1（补位）出现两次。
      expect(find.text('1'), findsNWidgets(2));
    });

    testWidgets('non-current-month filler days render disabled color',
        (tester) async {
      await tester.pumpWidget(_wrap(_calendar(value: june2024)));
      // 5 月 27 日为补位日期，文字应为弱色（colorTextQuaternary）。
      final quaternary = AntThemeData.light().colorTextQuaternary;
      final filler = tester.widgetList<Text>(
        find.byWidgetPredicate((w) => w is Text && w.data == '27'),
      );
      expect(filler.any((t) => t.style!.color == quaternary), isTrue);
    });

    testWidgets('disabledDate prevents selection and fires no onSelect',
        (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          _calendar(
          value: _date(2024, 6, 1),
          onSelect: (d) => picked = d,
          // 禁用周末（周六/周日）。
          disabledDate: (d) =>
              d.weekday == DateTime.saturday || d.weekday == DateTime.sunday,
          ),
        ),
      );
      // 2024-06-15 为周六，点击不应选中。
      final saturday = find.text('15').first;
      final text = tester.widget<Text>(saturday);
      expect(text.style!.color, AntThemeData.light().colorTextDisabled);
      await tester.tap(saturday, warnIfMissed: false);
      await tester.pump();
      expect(picked, isNull);
    });

    testWidgets('fullscreen mode renders taller cells than card mode',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              _calendar(
                value: june2024,
                // 测试环境无手机端 AntResponsive 断点，auto 解析为桌面形态；
                // 本用例断言 card 形态，显式指定。
                layout: AntCalendarLayout.card,
                key: const Key('card'),
              ),
            ],
          ),
        ),
      );
      final cardSize = tester.getSize(find.byKey(const Key('card')));
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              _calendar(
                value: june2024,
                fullscreen: true,
                key: const Key('fullscreen'),
              ),
            ],
          ),
        ),
      );
      final fullscreenSize =
          tester.getSize(find.byKey(const Key('fullscreen')));
      expect(fullscreenSize.height, greaterThan(cardSize.height));
    });

    testWidgets('card mode renders compact cells', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            value: june2024,
            layout: AntCalendarLayout.card,
          ),
        ),
      );
      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.constraints?.minHeight != null,
        ),
      );
      // 默认紧凑模式单元格最小高度为 32.w。
      expect(
        containers.any((c) => c.constraints!.minHeight == 32.w),
        isTrue,
      );
    });

    testWidgets('dateCell custom builder replaces default content',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
          value: june2024,
          dateCell: (
            date, {
            required isCurrentMonth,
            required isToday,
            required isSelected,
          }) {
            if (date.day == 18 && isCurrentMonth) {
              return const Text('_Custom18');
            }
            return null;
          },
          ),
        ),
      );
      expect(find.text('_Custom18'), findsOneWidget);
      // 默认内容仍渲染其他日期。
      expect(find.text('19'), findsWidgets);
    });

    testWidgets('selection persists when navigating across months',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_calendar(defaultValue: _date(2024, 6, 10))),
      );
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('2024年7月'), findsOneWidget);
      // 导航到 7 月后回到 6 月，选中状态保持高亮。
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(
        tester.widget<Text>(find.text('10').first).style!.color,
        Colors.white,
      );
    });

    testWidgets('tapping filler day switches to its month', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          _calendar(
          value: _date(2024, 6, 1),
          onSelect: (d) => picked = d,
          ),
        ),
      );
      // 5 月 27 日补位格，点击后应切到 5 月。
      await tester.tap(find.text('27').first, warnIfMissed: false);
      await tester.pump();
      expect(picked, _date(2024, 5, 27));
      expect(find.text('2024年5月'), findsOneWidget);
    });
  });
}
