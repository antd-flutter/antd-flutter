import 'package:antd_flutter_ui/src/data_entry/slider/ant_slider.dart';
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
  group('AntSlider', () {
    testWidgets('renders by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSlider()));
      expect(find.byType(AntSlider), findsOneWidget);
    });

    testWidgets('tooltipVisible shows value', (tester) async {
      await tester.pumpWidget(_wrap(const AntSlider(
        defaultValue: 30,
        tooltipVisible: true,
      ),),);
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('tap updates value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntSlider(
        defaultValue: 0,
        onChange: (v) => changed = v,
      ),),);
      // 点击轨道右侧
      await tester.tapAt(tester.getCenter(find.byType(AntSlider)) +
          const Offset(100, 0),);
      await tester.pump();
      expect(changed, isNotNull);
      expect(changed! > 0, true);
    });

    testWidgets('disabled prevents interaction', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntSlider(
        defaultValue: 0,
        disabled: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tapAt(tester.getCenter(find.byType(AntSlider)) +
          const Offset(100, 0),);
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(_wrap(const AntSlider(
        value: 50,
        tooltipVisible: true,
      ),),);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('marks render labels', (tester) async {
      await tester.pumpWidget(_wrap(const AntSlider(
        defaultValue: 30,
        marks: [
          AntSliderMark(value: 0, label: '0'),
          AntSliderMark(value: 50, label: '50'),
          AntSliderMark(value: 100, label: '100'),
        ],
      ),),);
      expect(find.text('50'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('onChangeEnd fires after tap', (tester) async {
      double? endValue;
      await tester.pumpWidget(_wrap(AntSlider(
        defaultValue: 0,
        onChangeEnd: (v) => endValue = v,
      ),),);
      await tester.tapAt(tester.getCenter(find.byType(AntSlider)) +
          const Offset(100, 0),);
      await tester.pump();
      expect(endValue, isNotNull);
    });

    testWidgets('step snaps value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntSlider(
        defaultValue: 0,
        min: 0,
        max: 100,
        step: 10,
        onChange: (v) => changed = v,
      ),),);
      await tester.tapAt(tester.getCenter(find.byType(AntSlider)) +
          const Offset(100, 0),);
      await tester.pump();
      expect(changed! % 10, 0);
    });
  });
}