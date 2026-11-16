/// AntPicker / AntPickerView widget tests
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _seasons = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '春', value: 'spring'),
  AntPickerColumnItem(label: '夏', value: 'summer'),
  AntPickerColumnItem(label: '秋', value: 'autumn'),
  AntPickerColumnItem(label: '冬', value: 'winter'),
];

const _weekdays = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '周一', value: 'mon'),
  AntPickerColumnItem(label: '周二', value: 'tue'),
  AntPickerColumnItem(label: '周三', value: 'wed'),
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
  group('AntPickerView', () {
    testWidgets('renders column items', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(columns: [_seasons]),
      ),);
      expect(find.text('春'), findsOneWidget);
      expect(find.text('夏'), findsOneWidget);
      expect(find.text('秋'), findsOneWidget);
      expect(find.text('冬'), findsOneWidget);
    });

    testWidgets('renders multiple columns', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(columns: [_seasons, _weekdays]),
      ),);
      expect(find.text('春'), findsOneWidget);
      expect(find.text('周一'), findsOneWidget);
    });

    testWidgets('defaultValue selects correct item', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(
          columns: [_seasons],
          defaultValue: ['autumn'],
        ),
      ),);
      await tester.pumpAndSettle();
      // The selected item should be '秋' (autumn at index 2)
      // CupertinoPicker centers the selected item
      final picker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
      expect(picker.scrollController!.initialItem, 2);
    });

    testWidgets('controlled value selects correct item', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(
          columns: [_seasons],
          value: ['winter'],
        ),
      ),);
      await tester.pumpAndSettle();
      final picker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
      expect(picker.scrollController!.initialItem, 3);
    });

    testWidgets('null value defaults to first item', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(columns: [_seasons]),
      ),);
      final picker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
      expect(picker.scrollController!.initialItem, 0);
    });

    testWidgets('invalid value defaults to first item', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntPickerView(
          columns: [_seasons],
          defaultValue: ['nonexistent'],
        ),
      ),);
      final picker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
      expect(picker.scrollController!.initialItem, 0);
    });

    testWidgets('onChange fires on scroll', (tester) async {
      List<String?>? changed;
      await tester.pumpWidget(_wrap(
        AntPickerView(
          columns: [_seasons],
          onChange: (vals) => changed = vals,
        ),
      ),);
      // Drag the picker down to select next item
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.first, 'summer');
    });
  });

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