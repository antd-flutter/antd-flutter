import 'package:antd_flutter_ui/src/data_entry/rate/ant_rate.dart';
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

void main() {
  group('AntRate', () {
    testWidgets('renders count stars', (tester) async {
      await tester.pumpWidget(_wrap(const AntRate()));
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('custom count renders correct stars', (tester) async {
      await tester.pumpWidget(_wrap(const AntRate(count: 10)));
      expect(find.byIcon(Icons.star), findsNWidgets(10));
    });

    testWidgets('defaultValue fills stars', (tester) async {
      await tester.pumpWidget(_wrap(const AntRate(defaultValue: 3)));
      // 3 个满星 + 2 个空星
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('tap star calls onChange', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntRate(onChange: (v) => changed = v)));
      await tester.tap(find.byIcon(Icons.star).at(2));
      await tester.pump();
      expect(changed, 3);
    });

    testWidgets('disabled prevents interaction', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntRate(
        defaultValue: 2,
        disabled: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(Icons.star).at(2));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('allowHalf enables half star selection', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntRate(
        allowHalf: true,
        onChange: (v) => changed = v,
      ),),);
      // 点击第 3 颗星的左半部分
      final star = find.byIcon(Icons.star).at(2);
      final center = tester.getCenter(star);
      await tester.tapAt(Offset(center.dx - 2, center.dy));
      await tester.pump();
      expect(changed, 2.5);
    });

    testWidgets('allowClear resets on same value tap', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntRate(
        defaultValue: 3,
        allowClear: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(Icons.star).at(2));
      await tester.pump();
      expect(changed, 0);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(_wrap(const AntRate(value: 4)));
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('custom character renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntRate(
        character: Icons.favorite,
      ),),);
      expect(find.byIcon(Icons.favorite), findsNWidgets(5));
      expect(find.byIcon(Icons.star), findsNothing);
    });
  });
}