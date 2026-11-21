/// C2 桌面渲染器测试（antd v6 对齐）。
///
/// 全部用例显式指定 `platform: AntCalendarPlatform.desktop`，
/// 覆盖 fullscreen / card 两种形态、头部年月下拉 + 模式切换、
/// showWeek、headerRender、cellRender/fullCellRender info 扩展、
/// deprecated 映射与 validRange 裁剪。
library;

import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

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

/// 统一以桌面渲染器构造（C2 所有用例必须显式 platform）。
AntCalendar _calendar({
  bool fullscreen = true,
  DateTime? value,
  DateTime? defaultValue,
  AntCalendarWeekStartsOn weekStartsOn = AntCalendarWeekStartsOn.monday,
  AntCalendarMode? mode,
  AntCalendarMode initialMode = AntCalendarMode.month,
  AntCalendarValidRange? validRange,
  ValueChanged<DateTime>? onSelect,
  void Function(DateTime, AntCalendarSelectInfo)? onSelectWithInfo,
  ValueChanged<DateTime?>? onChange,
  AntCalendarPanelChangeCallback? onPanelChange,
  AntCalendarCellRender? cellRender,
  AntCalendarFullCellRender? fullCellRender,
  Widget? Function(DateTime)? dateCellRender,
  Widget? Function(DateTime)? dateFullCellRender,
  AntCalendarHeaderRender? headerRender,
  bool showWeek = false,
}) {
  return AntCalendar(
    platform: AntCalendarPlatform.desktop,
    // fullscreen 参数在 layout.auto 下会被自适应覆盖，显式给出布局形态。
    layout: fullscreen ? AntCalendarLayout.fullscreen : AntCalendarLayout.card,
    fullscreen: fullscreen,
    value: value,
    defaultValue: defaultValue,
    weekStartsOn: weekStartsOn,
    mode: mode,
    initialMode: initialMode,
    validRange: validRange,
    onSelect: onSelect,
    onSelectWithInfo: onSelectWithInfo,
    onChange: onChange,
    onPanelChange: onPanelChange,
    cellRender: cellRender,
    fullCellRender: fullCellRender,
    // ignore: deprecated_member_use_from_same_package
    dateCellRender: dateCellRender,
    // ignore: deprecated_member_use_from_same_package
    dateFullCellRender: dateFullCellRender,
    headerRender: headerRender,
    showWeek: showWeek,
  );
}

/// 取单元格外层 Container 的 BoxDecoration。
BoxDecoration _cellDecoration(WidgetTester tester, DateTime day) {
  final cell = find.byKey(
    Key('ant-calendar-cell-${day.year}-${day.month}-${day.day}'),
  );
  final container = tester.widget<Container>(
    find.descendant(of: cell, matching: find.byType(Container)).first,
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  final june2024 = _date(2024, 6, 10);

  group('桌面 fullscreen：网格与头部', () {
    testWidgets('渲染 6×7 日期网格与默认年/月下拉', (tester) async {
      await tester.pumpWidget(_wrap(_calendar(defaultValue: june2024)));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('ant-calendar-desktop-grid')),
        findsOneWidget,
      );
      // fullscreen 日期数字补零（antd v6 date-value）。
      final dayTexts = find.byWidgetPredicate(
        (w) => w is Text && RegExp(r'^\d{2}$').hasMatch(w.data ?? ''),
      );
      expect(dayTexts.evaluate().length, 42);
      expect(
        find.byKey(const Key('ant-calendar-year-select')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ant-calendar-month-select')),
        findsOneWidget,
      );
      // 7 个星期表头。
      expect(
        find.descendant(
          of: find.byKey(const Key('ant-calendar-weekday-row')),
          matching: find.byType(Text),
        ),
        findsNWidgets(7),
      );
      // 默认头部展示当前年份（2024）。
      expect(find.text('2024年'), findsWidgets);
    });

    testWidgets('年份下拉切换：source=year、onChange、onPanelChange', (tester) async {
      DateTime? selected;
      DateTime? changed;
      final sources = <AntCalendarSelectSource>[];
      final panels = <AntCalendarMode>[];

      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onSelect: (date) => selected = date,
            onSelectWithInfo: (date, info) => sources.add(info.source),
            onChange: (date) => changed = date,
            onPanelChange: (date, mode) => panels.add(mode),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ant-calendar-year-select')));
      await tester.pumpAndSettle();
      // 默认区间为当前展示年 ±10（2014..2033），首项可见。
      expect(find.text('2014年'), findsOneWidget);
      expect(find.text('2033年'), findsNothing);

      await tester.tap(find.text('2014年'));
      await tester.pumpAndSettle();

      expect(selected, _date(2014, 6, 10));
      expect(changed, _date(2014, 6, 10));
      expect(sources.last, AntCalendarSelectSource.year);
      expect(panels.last, AntCalendarMode.month);
      // 面板已切换到 2014 年 6 月。
      expect(
        find.byKey(const Key('ant-calendar-cell-2014-6-10')),
        findsOneWidget,
      );
    });

    testWidgets('月份下拉切换：source=month 且面板跳到目标月', (tester) async {
      DateTime? selected;
      final sources = <AntCalendarSelectSource>[];

      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onSelect: (date) => selected = date,
            onSelectWithInfo: (date, info) => sources.add(info.source),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ant-calendar-month-select')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3月'));
      await tester.pumpAndSettle();

      expect(selected!.year, 2024);
      expect(selected!.month, 3);
      expect(sources.last, AntCalendarSelectSource.month);
      expect(
        find.byKey(const Key('ant-calendar-cell-2024-3-1')),
        findsOneWidget,
      );
    });

    testWidgets('模式切换 month↔year 并触发 onPanelChange', (tester) async {
      final panels = <AntCalendarMode>[];
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onPanelChange: (date, mode) => panels.add(mode),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ant-calendar-mode-year')));
      await tester.pumpAndSettle();

      expect(panels.last, AntCalendarMode.year);
      expect(find.byKey(const Key('ant-calendar-desktop-grid')), findsNothing);
      // 年面板为 3×4 = 12 个月份格。
      expect(find.text('1月'), findsOneWidget);
      expect(find.text('12月'), findsOneWidget);

      await tester.tap(find.byKey(const Key('ant-calendar-mode-month')));
      await tester.pumpAndSettle();

      expect(panels.last, AntCalendarMode.month);
      expect(
        find.byKey(const Key('ant-calendar-desktop-grid')),
        findsOneWidget,
      );
    });

    testWidgets('点击日期触发 source=date 且兼容旧 onSelect', (tester) async {
      DateTime? selected;
      DateTime? changed;
      final sources = <AntCalendarSelectSource>[];

      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onSelect: (date) => selected = date,
            onSelectWithInfo: (date, info) => sources.add(info.source),
            onChange: (date) => changed = date,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ant-calendar-cell-2024-6-15')));
      await tester.pumpAndSettle();

      expect(selected, _date(2024, 6, 15));
      expect(changed, _date(2024, 6, 15));
      expect(sources.last, AntCalendarSelectSource.date);
    });
  });

  group('桌面 showWeek 周序号列', () {
    testWidgets('周序号列与日期列同高且按周一起始计算', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            showWeek: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 6 行 × 1 列周序号。
      for (var row = 0; row < 6; row++) {
        expect(
          find.byKey(Key('ant-calendar-week-cell-$row')),
          findsOneWidget,
        );
      }
      final firstWeekCell = find.byKey(const Key('ant-calendar-week-cell-0'));
      final weekText = tester.widget<Text>(
        find.descendant(of: firstWeekCell, matching: find.byType(Text)),
      );
      // 2024-06 网格首行从 2024-05-27（周一）开始，为 2024 年第 22 周。
      expect(weekText.data, '22');

      final dateCell = find.byKey(const Key('ant-calendar-cell-2024-6-1'));
      expect(
        tester.getSize(firstWeekCell).height,
        tester.getSize(dateCell).height,
      );
    });

    testWidgets('weekStartsOn=sunday 时首行从周日起算', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            showWeek: true,
            weekStartsOn: AntCalendarWeekStartsOn.sunday,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 2024-06 网格首格为 2024-05-26（周日）。
      expect(
        find.byKey(const Key('ant-calendar-cell-2024-5-26')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ant-calendar-week-cell-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ant-calendar-cell-2024-5-27')),
        findsOneWidget,
      );
    });
  });

  group('桌面 headerRender 与单元格渲染扩展', () {
    testWidgets('headerRender 替换默认头部并可触发 customize 来源', (tester) async {
      final sources = <AntCalendarSelectSource>[];
      var typeChanges = 0;

      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onSelectWithInfo: (date, info) => sources.add(info.source),
            headerRender: (config) => Row(
              children: [
                const Text('自定义头部'),
                TextButton(
                  onPressed: () => config.onChange(_date(2023, 3, 15)),
                  child: const Text('跳转'),
                ),
                TextButton(
                  onPressed: () {
                    typeChanges++;
                    config.onTypeChange(AntCalendarMode.year);
                  },
                  child: const Text('切年'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('自定义头部'), findsOneWidget);
      expect(
        find.byKey(const Key('ant-calendar-year-select')),
        findsNothing,
      );

      await tester.tap(find.text('跳转'));
      await tester.pumpAndSettle();
      expect(sources.last, AntCalendarSelectSource.customize);
      expect(
        find.byKey(const Key('ant-calendar-cell-2023-3-15')),
        findsOneWidget,
      );

      await tester.tap(find.text('切年'));
      await tester.pumpAndSettle();
      expect(typeChanges, 1);
      expect(find.byKey(const Key('ant-calendar-desktop-grid')), findsNothing);
    });

    testWidgets('cellRender info 含 type=date 与 originNode', (tester) async {
      final infos = <AntCalendarCellRenderInfo>[];
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            cellRender: (date, info) {
              infos.add(info);
              return Text('c${date.day}');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(infos, isNotEmpty);
      expect(infos.first.type, AntCalendarCellType.date);
      expect(infos.first.originNode, isNotNull);
      expect(find.text('c10'), findsOneWidget);
    });

    testWidgets('年面板 cellRender info 含 type=month 与 originNode',
        (tester) async {
      final infos = <AntCalendarCellRenderInfo>[];
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            initialMode: AntCalendarMode.year,
            cellRender: (date, info) {
              infos.add(info);
              return Text('m${date.month}');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(infos.length, 12);
      expect(
        infos.every((info) => info.type == AntCalendarCellType.month),
        isTrue,
      );
      expect(infos.first.originNode, isNotNull);
    });

    testWidgets('fullCellRender 整格接管、originNode 非空且仍可点击', (tester) async {
      final infos = <AntCalendarCellRenderInfo>[];
      final selected = <DateTime>[];

      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            onSelect: selected.add,
            fullCellRender: (date, info) {
              infos.add(info);
              return Container(
                key: ValueKey('full-${date.year}-${date.month}-${date.day}'),
                height: 24,
                color: const Color(0xFFFFF1F0),
                child: Text('F${date.day}'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('full-2024-6-15')),
        findsOneWidget,
      );
      expect(infos.first.originNode, isNotNull);
      expect(infos.first.type, AntCalendarCellType.date);

      await tester.tap(find.byKey(const ValueKey('full-2024-6-15')));
      await tester.pumpAndSettle();
      expect(selected, [_date(2024, 6, 15)]);
    });

    testWidgets('deprecated dateCellRender 映射到内容层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            // ignore: deprecated_member_use_from_same_package
            dateCellRender: (date) => Text('dep${date.day}'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('dep10'), findsOneWidget);
      expect(find.text('dep15'), findsOneWidget);
    });

    testWidgets('deprecated dateFullCellRender 映射到整格', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: june2024,
            // ignore: deprecated_member_use_from_same_package
            dateFullCellRender: (date) => SizedBox(
              key: ValueKey('depfull-${date.day}'),
              height: 24,
              child: Text('DF${date.day}'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('depfull-10')),
        findsOneWidget,
      );
      expect(find.text('DF10'), findsOneWidget);
    });
  });

  group('桌面 card 形态与视觉对齐', () {
    testWidgets('card 形态为 300 宽紧凑面板且含年月下拉与模式切换', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            fullscreen: false,
            defaultValue: june2024,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final root = find.byKey(const Key('ant-calendar-desktop'));
      expect(tester.getSize(root).width, 300);
      expect(
        find.byKey(const Key('ant-calendar-year-select')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ant-calendar-month-select')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('ant-calendar-mode-year')), findsOneWidget);

      await tester.tap(find.byKey(const Key('ant-calendar-mode-year')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ant-calendar-desktop-grid')), findsNothing);
      expect(find.text('1月'), findsOneWidget);
    });

    testWidgets('validRange 裁剪年份下拉区间', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _calendar(
            defaultValue: _date(2021, 6, 10),
            validRange: AntCalendarValidRange(
              _date(2020, 1, 1),
              _date(2022, 12, 31),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ant-calendar-year-select')));
      await tester.pumpAndSettle();

      expect(find.text('2020年'), findsOneWidget);
      expect(find.text('2021年'), findsWidgets);
      expect(find.text('2022年'), findsOneWidget);
      expect(find.text('2023年'), findsNothing);
      expect(find.text('2019年'), findsNothing);
    });

    testWidgets('选中单元格使用 controlItemBgActive 且日期文字主色', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(_wrap(_calendar(value: _date(2024, 6, 15))));
      await tester.pumpAndSettle();

      final decoration = _cellDecoration(tester, _date(2024, 6, 15));
      expect(decoration.color, t.controlItemBgActive);

      final dayText = tester.widget<Text>(find.text('15'));
      expect(dayText.style!.color, t.colorPrimary);
    });

    testWidgets('今天单元格主色描边与主色日期文字', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final t = AntThemeData.light();

      // 不预选日期：今天单元格保持非选中态，验证今天描边。
      await tester.pumpWidget(_wrap(_calendar()));
      await tester.pumpAndSettle();

      final decoration = _cellDecoration(tester, today);
      final border = decoration.border! as Border;
      expect(border.top.color, t.colorPrimary);
      // 选中态优先（今天同时为选中日期时日期文字仍为主色）。
      final dayText =
          tester.widget<Text>(find.text('${today.day}'.padLeft(2, '0')));
      expect(dayText.style!.color, t.colorPrimary);
    });
  });
}
