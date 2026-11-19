import 'package:antd_flutter_plus/src/components/data_entry/date_picker/ant_date_picker.dart';
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
  group('AntDatePicker', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntDatePicker(
        placeholder: '请选择',
      ),),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default value formatted', (tester) async {
      await tester.pumpWidget(_wrap(AntDatePicker(
        defaultValue: DateTime(2024, 1, 15),
      ),),);
      expect(find.text('2024-01-15'), findsOneWidget);
    });

    testWidgets('disabled does not open panel', (tester) async {
      await tester.pumpWidget(_wrap(const AntDatePicker(
        disabled: true,
      ),),);
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.textContaining('年'), findsNothing);
    });

    testWidgets('tap opens calendar panel', (tester) async {
      await tester.pumpWidget(_wrap(AntDatePicker(
        defaultValue: DateTime(2024, 1, 15),
      ),),);
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
    });

    testWidgets('selecting a date calls onChange and closes', (tester) async {
      DateTime? changed;
      await tester.pumpWidget(_wrap(AntDatePicker(
        defaultValue: DateTime(2024, 1, 1),
        onChange: (d) => changed = d,
      ),),);
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(changed, DateTime(2024, 1, 15));
      expect(find.text('2024-01-15'), findsOneWidget);
      expect(find.text('2024年1月'), findsNothing);
    });

    testWidgets('month navigation works', (tester) async {
      await tester.pumpWidget(_wrap(AntDatePicker(
        defaultValue: DateTime(2024, 1, 1),
      ),),);
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('2024年2月'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
    });

    testWidgets('allowClear clears value', (tester) async {
      DateTime? changed = DateTime(2024, 1, 1);
      await tester.pumpWidget(_wrap(AntDatePicker(
        defaultValue: DateTime(2024, 1, 1),
        allowClear: true,
        onChange: (d) => changed = d,
      ),),);
      expect(find.text('2024-01-01'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择日期'), findsOneWidget);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(_wrap(AntDatePicker(
        value: DateTime(2025, 6, 20),
      ),),);
      expect(find.text('2025-06-20'), findsOneWidget);
    });
  });
}