/// AntCalendar 国际化（locale）测试：预设语言 / fromLanguageCode / 注入 / 自定义覆盖
library;

import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(
  Widget child, {
  AntCalendarLocale? injected,
}) =>
    MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: injected != null
                ? AntCalendarLocaleProvider(
                    locale: injected,
                    child: SingleChildScrollView(child: Material(child: child)),
                  )
                : SingleChildScrollView(child: Material(child: child)),
          ),
        ),
      );

void main() {
  group('AntCalendarLocale 预设', () {
    test('内建常用语言预设齐备', () {
      const presets = [
        AntCalendarLocale.zh,
        AntCalendarLocale.zhTw,
        AntCalendarLocale.en,
        AntCalendarLocale.ja,
        AntCalendarLocale.ko,
        AntCalendarLocale.fr,
        AntCalendarLocale.de,
        AntCalendarLocale.es,
        AntCalendarLocale.ru,
        AntCalendarLocale.pt,
        AntCalendarLocale.it,
        AntCalendarLocale.ar,
        AntCalendarLocale.th,
        AntCalendarLocale.vi,
        AntCalendarLocale.id,
      ];
      for (final p in presets) {
        expect(p.effectiveMonthTitlePattern, isNotEmpty);
        expect(p.effectiveTodayText, isNotEmpty);
        expect(p.effectiveConfirmText, isNotEmpty);
        expect(p.effectiveCancelText, isNotEmpty);
        expect(p.effectiveWeekLabels.length, 7);
      }
    });

    test('fromLanguageCode 解析与回退', () {
      expect(
        AntCalendarLocale.fromLanguageCode('zh-CN'),
        same(AntCalendarLocale.zh),
      );
      expect(
        AntCalendarLocale.fromLanguageCode('zh_TW'),
        same(AntCalendarLocale.zhTw),
      );
      expect(
        AntCalendarLocale.fromLanguageCode('ja'),
        same(AntCalendarLocale.ja),
      );
      expect(
        AntCalendarLocale.fromLanguageCode('pt-BR'),
        same(AntCalendarLocale.pt),
      );
      expect(
        AntCalendarLocale.fromLanguageCode('xx-unknown'),
        same(AntCalendarLocale.zh),
      );
    });

    test('zh 预设与既有中文文案向后兼容', () {
      expect(AntCalendarLocale.zh.effectiveTodayText, '本月');
      expect(AntCalendarLocale.zh.monthTitle(2024, 6), '2024年6月');
      expect(AntCalendarLocale.zh.effectiveConfirmText, '确定');
    });

    test('自定义字段覆盖 + messages 扩展', () {
      const loc = AntCalendarLocale(
        fallback: AntCalendarLocale.en,
        todayText: '回到今天',
        messages: {'customKey': '自定义文案'},
      );
      expect(loc.effectiveTodayText, '回到今天');
      expect(loc.effectiveCancelText, 'Cancel'); // 一级回退 en
      expect(loc.effectiveMonthTitlePattern, '{month}/{year}');
      expect(loc.text('customKey'), '自定义文案');
    });
  });

  group('AntCalendar locale 接线', () {
    testWidgets('默认中文（向后兼容）', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: DateTime(2024, 6, 10)),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      // 移动端默认周日起始，默认头部无「本月」按钮（四向箭头翻页）。
      expect(find.text('本月'), findsNothing);
      expect(find.text('日'), findsOneWidget);
    });

    testWidgets('locale 参数：英文预设生效', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: DateTime(2024, 6, 10),
          locale: AntCalendarLocale.en,
        ),
      ),);
      expect(find.text('6/2024'), findsOneWidget);
      expect(find.text('Today'), findsNothing);
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('一'), findsNothing);
    });

    testWidgets('AntCalendarLocaleProvider 全局注入生效', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(defaultValue: DateTime(2024, 6, 10)),
        injected: AntCalendarLocale.ja,
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      expect(find.text('今月'), findsNothing);
      expect(find.text('日'), findsOneWidget);
    });

    testWidgets('周日起始时英文周标签轮转', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendar(
          defaultValue: DateTime(2024, 6, 10),
          locale: AntCalendarLocale.en,
          weekStartsOn: AntCalendarWeekStartsOn.sunday,
        ),
      ),);
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
    });
  });

  group('AntCalendarPicker locale 接线', () {
    testWidgets('弹窗按钮文案随 locale 切换', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCalendarPicker(
          locale: AntCalendarLocale.en,
          visible: true,
          title: 'Pick a date',
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('默认确认/取消为中文（向后兼容）', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCalendarPicker(visible: true, title: '选择日期'),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
    });
  });
}
