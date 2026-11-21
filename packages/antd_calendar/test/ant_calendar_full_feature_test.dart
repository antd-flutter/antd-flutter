/// AntCalendar 全量功能完善测试（桌面 antd v6 + 移动 antd-mobile 对齐）。
///
/// 桌面：cellRender/fullCellRender、月/年面板（mode）、validRange、
/// onPanelChange/onChange、月面板自定义渲染；
/// 移动：allowClear、min/max、minPage/maxPage、renderDate/renderLabel、
/// 年导航按钮、Picker onMaskClick/showCloseButton、controller.jumpToToday。
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
  group('桌面：cellRender / fullCellRender 三层渲染', () {
    testWidgets('cellRender 覆盖内容层并拿到状态 info', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          cellRender: (date, info) => Text('c${date.day}${info.isToday ? 'T' : ''}'),
        ),
      ),);
      await tester.pumpAndSettle();
      // 今天的 info.isToday 为 true（测试机当天日期，验证 info 存在即可）。
      expect(find.byWidgetPredicate((w) => w is Text && (w.data ?? '').startsWith('c')), findsWidgets);
    });

    testWidgets('fullCellRender 整格接管且单元格仍可点击', (tester) async {
      DateTime? tapped;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          // 移动端 allowClear 默认 true；此用例验证点击命中，关闭清除。
          allowClear: false,
          fullCellRender: (date, info) => Container(
            key: ValueKey('full-${date.day}'),
            height: 40,
            alignment: Alignment.center,
            child: Text('f${date.day}'),
          ),
          onSelect: (d) => tapped = d,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('f10'), findsOneWidget);
      await tester.tap(find.text('f10'));
      expect(tapped, _date(2024, 6, 10));
    });

    testWidgets('cellRender 优先级高于 dateCell', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          dateCell: (date, {required isCurrentMonth, required isToday, required isSelected}) => Text('d${date.day}'),
          cellRender: (date, info) => Text('c${date.day}'),
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('c10'), findsOneWidget);
      expect(find.text('d10'), findsNothing);
    });
  });

  group('桌面：月/年面板（mode 受控 + onPanelChange）', () {
    testWidgets('切年面板渲染 12 个月格子，点月回到月面板', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(fullscreen: true, defaultValue: _date(2024, 6, 10)),
      ),);
      await tester.pumpAndSettle();
      // fullscreen 默认展示月/年切换器。
      await tester.tap(find.text('年'));
      await tester.pumpAndSettle();
      expect(find.text('6月'), findsOneWidget); // 年面板 12 个月
      expect(find.text('12月'), findsOneWidget);
      await tester.tap(find.text('9月'));
      await tester.pumpAndSettle();
      expect(find.text('2024年9月'), findsOneWidget); // 回到月面板
    });

    testWidgets('monthCellRender / monthFullCellRender 自定义月面板', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          monthCellRender: (month) => Text('m${month.month}'),
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('年'));
      await tester.pumpAndSettle();
      expect(find.text('m5'), findsOneWidget);
    });

    testWidgets('受控 mode=year 保持年面板，onModeChanged 触发', (tester) async {
      AntCalendarMode? modeChanged;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          mode: AntCalendarMode.year,
          onModeChanged: (m) => modeChanged = m,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('3月'), findsOneWidget);
      await tester.tap(find.text('9月'));
      await tester.pumpAndSettle();
      expect(modeChanged, AntCalendarMode.month);
      // 受控：面板仍是 year。
      expect(find.text('9月'), findsOneWidget);
    });

    testWidgets('onPanelChange 在月份导航与模式切换时触发', (tester) async {
      final panels = <(DateTime, AntCalendarMode)>[];
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          onPanelChange: (date, mode) => panels.add((date, mode)),
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pumpAndSettle();
      expect(panels.last.$1, _date(2024, 7, 1));
      expect(panels.last.$2, AntCalendarMode.month);
      await tester.tap(find.text('年'));
      await tester.pumpAndSettle();
      expect(panels.last.$2, AntCalendarMode.year);
    });
  });

  group('桌面：validRange / onChange / 控制器', () {
    testWidgets('validRange 范围外日期不可选，导航被裁剪', (tester) async {
      DateTime? tapped;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(2024, 6, 10),
          allowClear: false,
          validRange: AntCalendarValidRange(_date(2024, 6, 5), _date(2024, 6, 20)),
          onSelect: (d) => tapped = d,
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2').first); // 6 月 2 日：范围外（首格为本月）
      expect(tapped, isNull);
      await tester.tap(find.text('10'));
      expect(tapped, _date(2024, 6, 10));
    });

    testWidgets('onChange 单选回传日期，allowClear 清除回传 null', (tester) async {
      final changes = <DateTime?>[];
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: _date(2024, 6, 10),
          allowClear: true,
          onChange: changes.add,
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('12'));
      expect(changes.single, _date(2024, 6, 12));
      await tester.tap(find.text('12'));
      expect(changes.last, isNull);
    });

    testWidgets('controller.jumpToToday 回到当月', (tester) async {
      final controller = AntCalendarController();
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: _date(2024, 6, 10), controller: controller),
      ),);
      await tester.pumpAndSettle();
      controller.nextMonth();
      await tester.pumpAndSettle();
      expect(find.text('2024年7月'), findsOneWidget);
      controller.jumpToToday();
      await tester.pumpAndSettle();
      final now = DateTime.now();
      expect(find.text('${now.year}年${now.month}月'), findsOneWidget);
    });

    testWidgets('年月滚轮列文案走 locale（en 预设）', (tester) async {
      expect(AntCalendarLocale.en.yearLabel(2024), '2024');
      expect(AntCalendarLocale.en.monthLabel(6), '6');
      expect(AntCalendarLocale.zh.yearLabel(2024), '2024年');
      expect(AntCalendarLocale.zh.monthLabel(6), '6月');
      expect(AntCalendarLocale.en.effectiveModeMonthText, 'Month');
      expect(AntCalendarLocale.ja.effectiveModeYearText, '年');
    });
  });

  group('移动（card）：renderDate / renderLabel / allowClear / min-max / 导航', () {
    testWidgets('renderDate / renderLabel 分层渲染日卡', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          layout: AntCalendarLayout.card,
          defaultValue: _date(2024, 6, 10),
          renderDate: (d) => Text('D${d.day}'),
          renderLabel: (d) => d.day == 10 ? const Text('端午') : null,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('D10'), findsOneWidget);
      expect(find.text('端午'), findsOneWidget);
      expect(find.text('D11'), findsOneWidget);
    });

    testWidgets('card 形态 min/max 限制可选日期', (tester) async {
      DateTime? tapped;
      await tester.pumpWidget(_wrap(
        AntCalendar(
          layout: AntCalendarLayout.card,
          defaultValue: _date(2024, 6, 10),
          min: _date(2024, 6, 5),
          max: _date(2024, 6, 20),
          onSelect: (d) => tapped = d,
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2').first); // 6 月 2 日：min 之外（首格为本月）
      expect(tapped, isNull);
      await tester.tap(find.text('15'));
      expect(tapped, _date(2024, 6, 15));
    });

    testWidgets('minPage / maxPage 裁剪面板导航', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          layout: AntCalendarLayout.card,
          defaultValue: _date(2024, 6, 10),
          minPage: const AntCalendarPage(year: 2024, month: 6),
          maxPage: const AntCalendarPage(year: 2024, month: 6),
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pumpAndSettle();
      expect(find.text('2024年6月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pumpAndSettle();
      expect(find.text('2024年6月'), findsOneWidget);
    });

    testWidgets('showYearNavButtons 年导航按钮翻年 + onPageChange', (tester) async {
      final pages = <(int, int)>[];
      await tester.pumpWidget(_wrap(
        AntCalendar(
          layout: AntCalendarLayout.card,
          defaultValue: _date(2024, 6, 10),
          showYearNavButtons: true,
          onPageChange: (y, m) => pages.add((y, m)),
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleLeftOutlined));
      await tester.pumpAndSettle();
      expect(find.text('2023年6月'), findsOneWidget);
      expect(pages.last, (2023, 6));
    });
  });

  group('移动：AntCalendarPicker onMaskClick / showCloseButton', () {
    testWidgets('遮罩关闭触发 onMaskClick 与 onClose', (tester) async {
      var maskClicked = false;
      var closed = false;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          visible: true,
          onMaskClick: () => maskClicked = true,
          onClose: () => closed = true,
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10)); // 点遮罩
      await tester.pumpAndSettle();
      expect(maskClicked, isTrue);
      expect(closed, isTrue);
    });

    testWidgets('showCloseButton=false 不渲染关闭按钮，默认渲染', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCalendarPicker(visible: true, showCloseButton: false),
      ),);
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);

      await tester.pumpWidget(_wrap(const AntCalendarPicker(visible: true)));
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });

    testWidgets('点击关闭按钮触发 onClose 且不触发 onConfirm', (tester) async {
      var closed = false;
      var confirmed = false;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          visible: true,
          onClose: () => closed = true,
          onConfirm: (_) => confirmed = true,
        ),
      ),);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(confirmed, isFalse);
    });
  });
}
