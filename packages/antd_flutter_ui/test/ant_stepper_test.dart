/// AntStepper widget tests
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  group('AntStepper', () {
    testWidgets('renders with defaultValue', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(defaultValue: 5),
      ),);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('controlled value displays', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(value: 10),
      ),);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('plus button increments value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 3,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed, 4);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('minus button decrements value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 3,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pumpAndSettle();
      expect(changed, 2);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('step prop changes increment amount', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 0,
          step: 5,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed, 5);
    });

    testWidgets('min prop disables minus at boundary', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 0,
          min: 0,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pumpAndSettle();
      // 在 min 边界按钮已禁用，不会触发 onChange
      expect(changed, isNull);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('max prop disables plus at boundary', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 10,
          max: 10,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      // 在 max 边界按钮已禁用，不会触发 onChange
      expect(changed, isNull);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('min prop clamps typed value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 5,
          min: 0,
          onChange: (v) => changed = v,
        ),
      ),);
      // 输入小于 min 的值会被钳制
      await tester.enterText(find.byType(TextField), '-10');
      await tester.pumpAndSettle();
      expect(changed, 0);
    });

    testWidgets('max prop clamps typed value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 5,
          max: 10,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.enterText(find.byType(TextField), '99');
      await tester.pumpAndSettle();
      expect(changed, 10);
    });

    testWidgets('disabled prevents interaction', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 3,
          disabled: true,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('digits formats decimal places', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(
          defaultValue: 3,
          digits: 2,
          step: 0.1,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(find.text('3.10'), findsOneWidget);
    });

    testWidgets('typing in input updates value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 0,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.enterText(find.byType(TextField), '7');
      await tester.pumpAndSettle();
      expect(changed, 7);
    });

    testWidgets('inputReadOnly prevents typing', (tester) async {
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 0,
          inputReadOnly: true,
          onChange: (v) {},
        ),
      ),);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('allowEmpty allows clearing input', (tester) async {
      double? changed = 5;
      await tester.pumpWidget(_wrap(
        AntStepper(
          defaultValue: 5,
          allowEmpty: true,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(changed, isNull);
    });

    testWidgets('minus button disabled at min boundary', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(defaultValue: 0, min: 0),
      ),);
      // minus 图标颜色应为禁用色（无法直接断言颜色，验证值不变即可）
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('plus button disabled at max boundary', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(defaultValue: 10, max: 10),
      ),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('small size renders', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(defaultValue: 1, size: AntStepperSize.small),
      ),);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('large size renders', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntStepper(defaultValue: 1, size: AntStepperSize.large),
      ),);
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('AntStepperSize', () {
    test('has three values', () {
      expect(AntStepperSize.values.length, 3);
      expect(AntStepperSize.values, contains(AntStepperSize.small));
      expect(AntStepperSize.values, contains(AntStepperSize.middle));
      expect(AntStepperSize.values, contains(AntStepperSize.large));
    });
  });
}