import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  group('AntStatistic', () {
    testWidgets('renders title and value', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        title: '活跃用户',
        value: 112893,
      ),),);
      expect(find.text('活跃用户'), findsOneWidget);
      expect(find.text('112,893'), findsOneWidget);
    });

    testWidgets('renders integer without separator when short', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(value: 999)));
      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('adds group separator for thousands', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(value: 1234567)));
      expect(find.text('1,234,567'), findsOneWidget);
    });

    testWidgets('precision formats decimal places', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 3.14159,
        precision: 2,
      ),),);
      expect(find.text('3.14'), findsOneWidget);
    });

    testWidgets('negative value with separator', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(value: -112893)));
      expect(find.text('-112,893'), findsOneWidget);
    });

    testWidgets('valueString overrides value', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 100,
        valueString: '自定义值',
      ),),);
      expect(find.text('自定义值'), findsOneWidget);
      expect(find.text('100'), findsNothing);
    });

    testWidgets('prefix renders before value', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 99,
        prefix: Text('¥'),
      ),),);
      expect(find.text('¥'), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('suffix renders after value', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 99,
        suffix: Text('元'),
      ),),);
      expect(find.text('元'), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('loading shows skeleton', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 100,
        loading: true,
      ),),);
      expect(find.text('100'), findsNothing);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('custom groupSeparator', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 1234567,
        groupSeparator: ' ',
      ),),);
      expect(find.text('1 234 567'), findsOneWidget);
    });

    testWidgets('null value renders empty', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic()));
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('custom valueStyle applies', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatistic(
        value: 100,
        valueStyle: TextStyle(color: Colors.red, fontSize: 32),
      ),),);
      // Text/DefaultTextStyle 会包 1~2 层无 text 的中间 TextSpan，逐层下钻到用户 span。
      final rich = tester.widget<RichText>(find.byType(RichText));
      var cur = rich.text as TextSpan;
      while (cur.text == null &&
          cur.children != null &&
          cur.children!.length == 1 &&
          cur.children!.single is TextSpan) {
        cur = cur.children!.single as TextSpan;
      }
      expect(cur.style?.color, Colors.red);
    });
  });

  group('AntStatisticCountdown', () {
    testWidgets('renders initial countdown value', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatisticCountdown(
        title: '倒计时',
        value: Duration(hours: 1, minutes: 30, seconds: 45),
      ),),);
      expect(find.text('倒计时'), findsOneWidget);
      expect(find.text('01:30:45'), findsOneWidget);
    });

    testWidgets('countdown ticks down', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatisticCountdown(
        value: Duration(seconds: 3),
      ),),);
      expect(find.text('00:00:03'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('00:00:02'), findsOneWidget);
    });

    testWidgets('onFinish fires when countdown reaches zero', (tester) async {
      var finished = false;
      await tester.pumpWidget(_wrap(AntStatisticCountdown(
        value: const Duration(seconds: 1),
        onFinish: () => finished = true,
      ),),);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('00:00:00'), findsOneWidget);
      expect(finished, isTrue);
    });

    testWidgets('custom format', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatisticCountdown(
        value: Duration(days: 2, hours: 3, minutes: 4, seconds: 5),
        format: 'DD天HH:mm:ss',
      ),),);
      expect(find.text('02天03:04:05'), findsOneWidget);
    });

    testWidgets('int value as milliseconds', (tester) async {
      await tester.pumpWidget(_wrap(const AntStatisticCountdown(
        value: 65000, // 65 seconds
      ),),);
      expect(find.text('00:01:05'), findsOneWidget);
    });
  });
  testWidgets('decimalStyle 小数部分独立样式', (tester) async {
    await tester.pumpWidget(_wrap(const AntStatistic(
      value: 112893,
      precision: 2,
      decimalStyle: TextStyle(fontSize: 12, color: Colors.grey),
    ),),);
    await tester.pumpAndSettle();

    // decimalStyle 生效 → 渲染为 RichText（整数/小数两个 span）
    // decimalStyle 生效 → 存在含 2 个 span 的 RichText（整数段 + 小数段）
    final stat = tester.widget<AntStatistic>(find.byType(AntStatistic));
    debugPrint('STAT decimalStyle=${stat.decimalStyle} value=${stat.value} precision=${stat.precision}');
    for (final r in tester.widgetList<RichText>(find.byType(RichText))) {
      final ts = r.text as TextSpan;
      debugPrint('RT: "${ts.toPlainText()}" children=${ts.children?.length} spans=${(ts.children ?? []).map((c) => c is TextSpan ? '${c.text}:${c.style?.fontSize}' : 'widget').join(',')}');
    }
    // Text.rich 外层 TextSpan 会被 Text 包一层（root.children = [用户 span]），
    // 故先下钻到用户传入的 value span（含 2 个子 span：整数段 + 小数段）。
    TextSpan valueRootOf(RichText r) {
      var cur = r.text as TextSpan;
      // Text/DefaultTextStyle 会包 1~2 层无 text 的中间 TextSpan，逐层下钻到用户 span。
      while (cur.text == null &&
          cur.children != null &&
          cur.children!.length == 1 &&
          cur.children!.single is TextSpan) {
        cur = cur.children!.single as TextSpan;
      }
      return cur;
    }

    final twoSpanRich = tester
        .widgetList<RichText>(find.byType(RichText))
        .firstWhere((r) => (valueRootOf(r).children ?? []).length == 2);
    final spans = (valueRootOf(twoSpanRich).children)!;
    expect((spans[0] as TextSpan).text, '112,893.');
    expect((spans[1] as TextSpan).text, '00');
    expect((spans[1] as TextSpan).style!.fontSize, 12);
    expect((spans[0] as TextSpan).style!.fontSize, isNot(12));
  });

  testWidgets('无 decimalStyle 时数值单 Text 渲染（回归）', (tester) async {
    await tester.pumpWidget(
        _wrap(const AntStatistic(value: 112893, precision: 2)),);
    await tester.pumpAndSettle();

    // 无 decimalStyle → 不存在 2 span 的 RichText（全部单 span）
    final twoSpanCount = tester
        .widgetList<RichText>(find.byType(RichText))
        .where((r) => (r.text as TextSpan).children?.length == 2)
        .length;
    expect(twoSpanCount, 0);
    expect(find.textContaining('112,893'), findsOneWidget);
  });
}