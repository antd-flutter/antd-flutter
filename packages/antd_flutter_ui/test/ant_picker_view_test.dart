/// AntPickerView widget tests（antd_calendar 独立包）
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

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
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.first, 'summer');
    });
  });
}
