import 'package:antd_picker/antd_picker.dart';
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
  group('AntTimePicker', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        placeholder: '请选择',
      ),),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default value formatted', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        defaultValue: TimeOfDay(hour: 10, minute: 30),
      ),),);
      expect(find.text('10:30'), findsOneWidget);
    });

    testWidgets('disabled does not open panel', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        disabled: true,
      ),),);
      await tester.tap(find.byType(AntTimePicker));
      await tester.pump();
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('tap opens time panel with columns', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        defaultValue: TimeOfDay(hour: 10, minute: 30),
      ),),);
      await tester.tap(find.byType(AntTimePicker));
      await tester.pump();
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('tapping hour item calls onChange', (tester) async {
      TimeOfDay? changed;
      await tester.pumpWidget(_wrap(AntTimePicker(
        defaultValue: const TimeOfDay(hour: 10, minute: 30),
        onChange: (t) => changed = t,
      ),),);
      await tester.tap(find.byType(AntTimePicker));
      await tester.pump();
      // 点击小时列中的 "08"
      await tester.tap(find.text('08'));
      await tester.pump();
      expect(changed, isNotNull);
      expect(changed!.hour, 8);
    });

    testWidgets('confirm button closes panel', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        defaultValue: TimeOfDay(hour: 10, minute: 30),
      ),),);
      await tester.tap(find.byType(AntTimePicker));
      await tester.pump();
      expect(find.text('确定'), findsOneWidget);
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('allowClear clears value', (tester) async {
      TimeOfDay? changed = const TimeOfDay(hour: 10, minute: 30);
      await tester.pumpWidget(_wrap(AntTimePicker(
        defaultValue: const TimeOfDay(hour: 10, minute: 30),
        allowClear: true,
        onChange: (t) => changed = t,
      ),),);
      expect(find.text('10:30'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择时间'), findsOneWidget);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimePicker(
        value: TimeOfDay(hour: 18, minute: 45),
      ),),);
      expect(find.text('18:45'), findsOneWidget);
    });
  });
}