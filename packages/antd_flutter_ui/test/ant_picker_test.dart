/// AntPicker widget tests（AntPickerView 已迁 antd_flutter_ui）
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _seasons = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '春', value: 'spring'),
  AntPickerColumnItem(label: '夏', value: 'summer'),
  AntPickerColumnItem(label: '秋', value: 'autumn'),
  AntPickerColumnItem(label: '冬', value: 'winter'),
];

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
  group('AntPicker', () {
    testWidgets('renders trigger child', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPicker(
          columns: [_seasons],
          child: Text('打开选择器'),
        ),
      ),);
      expect(find.text('打开选择器'), findsOneWidget);
    });

    testWidgets('tapping child opens bottom sheet', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPicker(
          columns: [_seasons],
          title: '选择季节',
          child: Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('选择季节'), findsOneWidget);
      expect(find.text('春'), findsOneWidget);
    });

    testWidgets('cancel button closes sheet and calls onCancel',
        (tester) async {
      bool cancelled = false;
      await tester.pumpWidget(_wrap(
        AntPicker(
          columns: const [_seasons],
          onCancel: () => cancelled = true,
          child: const Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(cancelled, isTrue);
      expect(find.text('春'), findsNothing);
    });

    testWidgets('confirm button calls onConfirm with selected value',
        (tester) async {
      List<String?>? confirmed;
      await tester.pumpWidget(_wrap(
        AntPicker(
          columns: const [_seasons],
          defaultValue: const ['spring'],
          onConfirm: (vals) => confirmed = vals,
          child: const Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, isNotNull);
      expect(confirmed!.first, 'spring');
    });

    testWidgets('custom confirmText and cancelText display', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPicker(
          columns: [_seasons],
          confirmText: 'OK',
          cancelText: 'Close',
          child: Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('title displays in sheet', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPicker(
          columns: [_seasons],
          title: '请选择',
          child: Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('onSelect fires when wheel scrolls in sheet', (tester) async {
      List<String?>? selected;
      await tester.pumpWidget(_wrap(
        AntPicker(
          columns: const [_seasons],
          onSelect: (vals) => selected = vals,
          child: const Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
      expect(selected!.first, 'summer');
    });

    testWidgets('mask tap closes sheet when closeOnMaskClick is true',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPicker(
          columns: [_seasons],
          closeOnMaskClick: true,
          child: Text('打开选择器'),
        ),
      ),);
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('春'), findsOneWidget);

      // Tap on the barrier (outside the sheet)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('春'), findsNothing);
    });
  });
}