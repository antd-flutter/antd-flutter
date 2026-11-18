import 'package:antd_flutter_ui/src/display/page_indicator/ant_page_indicator.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

AnimatedContainer _dot(WidgetTester tester, int index) {
  final finder = find.byKey(ValueKey('page_indicator_dot_$index'));
  return tester.widget<AnimatedContainer>(finder);
}

void main() {
  group('AntPageIndicator', () {
    testWidgets('renders total dots', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 5)));
      for (var i = 0; i < 5; i++) {
        expect(find.byKey(ValueKey('page_indicator_dot_$i')), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('page_indicator_dot_5')), findsNothing);
    });

    testWidgets('defaultCurrent activates the right dot', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 4, defaultCurrent: 2)));
      final dot = _dot(tester, 2);
      final decoration = dot.decoration! as BoxDecoration;
      // 激活点使用主题主色（非普通点颜色）
      expect(decoration.color, AntThemeData.light().colorPrimary);
      // 其余点非主色
      final other = _dot(tester, 0);
      expect(
        (other.decoration! as BoxDecoration).color,
        isNot(AntThemeData.light().colorPrimary),
      );
    });

    testWidgets('default first dot active when defaultCurrent omitted', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 3)));
      final decoration = _dot(tester, 0).decoration! as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorPrimary);
    });

    testWidgets('controlled current switches active dot', (tester) async {
      int page = 0;
      late StateSetter setState;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntPageIndicator(total: 4, current: page);
        },
      ),),);
      expect(
        (_dot(tester, 0).decoration! as BoxDecoration).color,
        AntThemeData.light().colorPrimary,
      );
      setState(() => page = 3);
      await tester.pumpAndSettle();
      expect(
        (_dot(tester, 3).decoration! as BoxDecoration).color,
        AntThemeData.light().colorPrimary,
      );
      expect(
        (_dot(tester, 0).decoration! as BoxDecoration).color,
        isNot(AntThemeData.light().colorPrimary),
      );
    });

    testWidgets('active dot is wider than normal dot (horizontal)', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 4, defaultCurrent: 1)));
      final active = _dot(tester, 1);
      final normal = _dot(tester, 0);
      expect(active.constraints!.maxWidth, greaterThan(normal.constraints!.maxWidth));
    });

    testWidgets('active dot color differs from normal dot', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 3)));
      final activeColor = (_dot(tester, 0).decoration! as BoxDecoration).color;
      final normalColor = (_dot(tester, 1).decoration! as BoxDecoration).color;
      expect(activeColor, isNot(normalColor));
    });

    testWidgets('vertical direction stretches height instead of width',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(
        total: 4,
        defaultCurrent: 1,
        direction: AntPageIndicatorDirection.vertical,
      ),),);
      final active = _dot(tester, 1);
      final normal = _dot(tester, 0);
      // 垂直方向激活点沿高度伸展，宽度保持一致
      expect(active.constraints!.maxHeight, greaterThan(normal.constraints!.maxHeight));
      expect(active.constraints!.maxWidth, normal.constraints!.maxWidth);
    });

    testWidgets('single dot boundary renders and stays active', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(total: 1)));
      expect(find.byKey(const ValueKey('page_indicator_dot_0')), findsOneWidget);
      expect(
        (_dot(tester, 0).decoration! as BoxDecoration).color,
        AntThemeData.light().colorPrimary,
      );
    });

    testWidgets('custom dot color and active dot color apply', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(
        total: 3,
        dotColor: Colors.black12,
        activeDotColor: Colors.orange,
      ),),);
      expect(
        (_dot(tester, 0).decoration! as BoxDecoration).color,
        Colors.orange,
      );
      expect(
        (_dot(tester, 1).decoration! as BoxDecoration).color,
        Colors.black12,
      );
    });

    testWidgets('custom dot size and spacing apply', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(
        total: 3,
        dotSize: 8,
        activeDotSize: 20,
        dotSpacing: 6,
      ),),);
      final normal = _dot(tester, 1);
      final active = _dot(tester, 0);
      expect(normal.constraints!.maxWidth, 8.w);
      expect(active.constraints!.maxWidth, 20.w);
      // 间距体现在 margin 上（首个点之后的点）
      final midMargin = _dot(tester, 1).margin! as EdgeInsets;
      expect(midMargin.right, 6.w);
    });

    testWidgets('white preset uses white active color', (tester) async {
      await tester.pumpWidget(_wrap(const AntPageIndicator(
        total: 2,
        color: AntPageIndicatorPresetColor.white,
      ),),);
      expect(
        (_dot(tester, 0).decoration! as BoxDecoration).color,
        const Color(0xFFFFFFFF),
      );
    });

    testWidgets('current change animates smoothly via AnimatedContainer',
        (tester) async {
      int page = 0;
      late StateSetter setState;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntPageIndicator(total: 3, current: page);
        },
      ),),);
      // 动画进行中（未 settle）即存在动画容器
      setState(() => page = 1);
      await tester.pump();
      expect(find.byType(AnimatedContainer), findsWidgets);
      await tester.pumpAndSettle();
      expect(
        (_dot(tester, 1).decoration! as BoxDecoration).color,
        AntThemeData.light().colorPrimary,
      );
    });
  });
}
