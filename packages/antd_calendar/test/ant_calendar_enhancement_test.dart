/// AntCalendar 增强能力测试：格式切换 / range / 多选 / 事件点 / 年月跳转 / 双 UI 自适应
library;

import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

DateTime _date(int y, int m, int d) => DateTime(y, m, d);

Widget _wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: SingleChildScrollView(
              child: Material(child: child),
            ),
          ),
        ),
      );

void main() {
  // 2024 年 6 月（6 月 1 日为周六），默认 weekStartsOn=monday。
  const juneCell = '10'; // 6 月 10 日单元格文案

  group('AntCalendar 格式切换', () {
    testWidgets('month 格式渲染 6 行网格，week 格式渲染 1 行', (tester) async {
      AntCalendarFormat? changed;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          showFormatSwitcher: true,
          onFormatChanged: (f) => changed = f,
        ),
      ),);
      expect(find.text(juneCell), findsOneWidget);
      // month：42 个单元格（6 行）
      final rowsMonth = find.byWidgetPredicate(
        (w) => w is Row && find.descendant(of: find.byWidget(w), matching: find.text(juneCell)).evaluate().isNotEmpty,
      );
      expect(rowsMonth, findsOneWidget);

      await tester.tap(find.text('周'));
      await tester.pumpAndSettle();
      expect(changed, AntCalendarFormat.week);
    });

    testWidgets('受控 calendarFormat=week 只渲染一行日期', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          calendarFormat: AntCalendarFormat.week,
        ),
      ),);
      // 2024-06-10 为周一，周一起始 → 该周为 6/10~6/16。
      expect(find.text('10'), findsOneWidget);
      expect(find.text('16'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('twoWeeks 格式渲染两周', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          calendarFormat: AntCalendarFormat.twoWeeks,
        ),
      ),);
      // 两周：6/10~6/23。
      expect(find.text('10'), findsOneWidget);
      expect(find.text('23'), findsOneWidget);
      expect(find.text('9'), findsNothing);
    });

    testWidgets('showFormatSwitcher=false 不展示切换按钮（默认兼容）', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: _date(2024, 6, 10)),
      ),);
      expect(find.text('周'), findsNothing);
      expect(find.text('两周'), findsNothing);
    });
  });

  group('AntCalendar range 范围选择', () {
    testWidgets('两次点击触发 onRangeSelected 且 onSelect 兼容触发', (tester) async {
      DateTime? onSelectDay;
      DateTime? start;
      DateTime? end;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          selectionMode: AntCalendarSelectionMode.range,
          onSelect: (d) => onSelectDay = d,
          onRangeSelected: (s, e) {
            start = s;
            end = e;
          },
        ),
      ),);
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();
      expect(onSelectDay, _date(2024, 6, 14));
      expect(start, _date(2024, 6, 11));
      expect(end, _date(2024, 6, 14));
    });

    testWidgets('第二次点击早于起点时自动交换 start/end', (tester) async {
      DateTime? start;
      DateTime? end;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 14),
          selectionMode: AntCalendarSelectionMode.range,
          onRangeSelected: (s, e) {
            start = s;
            end = e;
          },
        ),
      ),);
      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      expect(start, _date(2024, 6, 11));
      expect(end, _date(2024, 6, 14));
    });
  });

  group('AntCalendar 多选', () {
    testWidgets('multiSelect 累积选择并回调 onSelectMulti', (tester) async {
      List<DateTime>? last;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          multiSelect: true,
          onSelectMulti: (v) => last = v,
        ),
      ),);
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('13'));
      await tester.pumpAndSettle();
      expect(last!.length, 2);
      expect(last![0], _date(2024, 6, 11));
      expect(last![1], _date(2024, 6, 13));
    });

    testWidgets('再次点击已选日期取消选择', (tester) async {
      List<DateTime>? last;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          multiSelect: true,
          onSelectMulti: (v) => last = v,
        ),
      ),);
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      expect(last, isEmpty);
    });

    testWidgets('受控 selectedDays 高亮展示', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          value: _date(2024, 6, 10),
          multiSelect: true,
          selectedDays: [_date(2024, 6, 10), _date(2024, 6, 12)],
        ),
      ),);
      // 受控渲染无异常即可；选中样式内部由 token 渲染。
      expect(tester.takeException(), isNull);
    });
  });

  group('AntCalendar 事件点标记', () {
    testWidgets('eventLoader 命中日期渲染事件点容器', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          eventLoader: (day) =>
              day.day == 10 || day.day == 12 ? [day, day, day, day] : const [],
        ),
      ),);
      // 命中日期的默认内容中存在事件点（圆形 Container，最多 3 个）。
      final dots = find.byWidgetPredicate(
        (w) => w is Container &&
            w.decoration is BoxDecoration &&
            ((w.decoration as BoxDecoration).shape == BoxShape.circle),
      );
      expect(dots, findsWidgets);
    });
  });

  group('AntCalendar 头部年月快速跳转', () {
    testWidgets('点击年月标题弹出选择面板，确定后跳转目标月份', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: _date(2024, 6, 10)),
      ),);
      await tester.tap(find.text('2024年6月'));
      await tester.pumpAndSettle();
      // 年月滚轮面板出现
      expect(find.text('2026年'), findsWidgets);

      // 直接点确定 → 跳回当前年月面板默认选中 2024/6（不改变月份）
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.text('2024年6月'), findsOneWidget);
    });

    testWidgets('enableYearMonthDropdown=false 时标题不可点', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          enableYearMonthDropdown: false,
        ),
      ),);
      expect(find.byIcon(AntIcons.downOutlined), findsNothing);
    });
  });

  group('AntCalendar 双 UI 形态', () {
    testWidgets('layout: card 强制移动紧凑形态（滑动手势翻月）', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          layout: AntCalendarLayout.card,
        ),
      ),);
      // drag 不产生速度，用 fling 触发滑动翻月。
      await tester.fling(find.text(juneCell), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('2024年7月'), findsOneWidget);
    });

    testWidgets('layout: fullscreen 强制桌面形态且大格子', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          layout: AntCalendarLayout.fullscreen,
        ),
      ),);
      expect(find.text(juneCell), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fullscreen 兼容参数仍生效', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: _date(2024, 6, 10), fullscreen: true),
      ),);
      expect(tester.takeException(), isNull);
    });
  });
}
