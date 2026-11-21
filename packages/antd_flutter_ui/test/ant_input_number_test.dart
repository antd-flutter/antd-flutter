import 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
  group('AntInputNumber', () {
    testWidgets('renders defaultValue', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(defaultValue: 5)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('controlled value updates', (tester) async {
      late StateSetter setState;
      double val = 1;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntInputNumber(value: val);
        },
      ),),);
      expect(find.text('1'), findsOneWidget);
      setState(() => val = 10);
      await tester.pump();
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('renders placeholder when no value', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(placeholder: '请输入')));
      expect(find.text('请输入'), findsOneWidget);
    });

    testWidgets('step up button increments value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 3,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(changed, 4);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('step down button decrements value', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 3,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pump();
      expect(changed, 2);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('respects max limit', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 9,
        max: 10,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(changed, 10);
      // 再点一次，不应超过 max
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('respects min limit', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 1,
        min: 0,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pump();
      expect(changed, 0);
      // 再点一次，不应低于 min
      await tester.tap(find.byIcon(AntIcons.minusOutlined));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('custom step', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 10,
        step: 5,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(changed, 15);
    });

    testWidgets('precision formats value', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(
        defaultValue: 3.14159,
        precision: 2,
      ),),);
      expect(find.text('3.14'), findsOneWidget);
    });

    testWidgets('disabled prevents stepping', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 3,
        disabled: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(changed, null);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('controls none hides step buttons', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(
        defaultValue: 3,
        controls: AntInputNumberControls.none,
      ),),);
      expect(find.byIcon(AntIcons.plusOutlined), findsNothing);
      expect(find.byIcon(AntIcons.minusOutlined), findsNothing);
    });

    testWidgets('keyboard input commits on unfocus', (tester) async {
      double? changed;
      await tester.pumpWidget(_wrap(AntInputNumber(
        onChange: (v) => changed = v,
      ),),);
      await tester.enterText(find.byType(TextField), '42');
      // 模拟失焦提交
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changed, 42);
    });

    testWidgets('addonBefore renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(
        defaultValue: 100,
        addonBefore: Text('¥'),
      ),),);
      expect(find.text('¥'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('onStep fires', (tester) async {
      double? stepped;
      await tester.pumpWidget(_wrap(AntInputNumber(
        defaultValue: 1,
        onStep: (v) => stepped = v,
      ),),);
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(stepped, 2);
    });
  });
}