import 'package:antd_flutter_plus/src/components/data_entry/select/ant_select.dart';
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

const _options = [
  AntSelectOption(value: 'a', label: '选项一'),
  AntSelectOption(value: 'b', label: '选项二'),
  AntSelectOption(value: 'c', label: '选项三'),
];

void main() {
  group('AntSelect', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        placeholder: '请选择',
      ),),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default selected label', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        defaultValue: 'b',
      ),),);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('disabled does not open dropdown', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        disabled: true,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('tap opens dropdown and shows options', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('selecting an option calls onChange and closes',
        (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        options: _options,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项二').last);
      await tester.pump();
      expect(changed, 'b');
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('multiple mode toggles selections', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        mode: AntSelectMode.multiple,
        options: _options,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('a'), true);
      await tester.tap(find.text('选项三').last);
      await tester.pump();
      expect((changed as List).length, 2);
    });

    testWidgets('multiple mode deselect removes from list', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        mode: AntSelectMode.multiple,
        options: _options,
        defaultValue: ['a', 'b'],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('a'), false);
      expect((changed as List).contains('b'), true);
    });

    testWidgets('showSearch filters options', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        showSearch: true,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '二');
      await tester.pump();
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('allowClear clears value', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        options: _options,
        defaultValue: 'a',
        allowClear: true,
        onChange: (v) => changed = v,
      ),),);
      expect(find.text('选项一'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('loading shows spinner', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        loading: true,
      ),),);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}