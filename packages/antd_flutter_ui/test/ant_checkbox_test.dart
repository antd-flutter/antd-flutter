import 'package:antd_flutter_ui/src/data_entry/checkbox/ant_checkbox.dart';
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
  group('AntCheckbox', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(child: Text('选项A'))));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('defaultChecked initializes checked', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(
        defaultChecked: true,
        child: Text('A'),
      ),),);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('unchecked shows no check icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(child: Text('A'))));
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('tap toggles checked state', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntCheckbox(
        child: const Text('A'),
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, true);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('tap again unchecks', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(
        defaultChecked: true,
        child: Text('A'),
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('controlled checked updates', (tester) async {
      late StateSetter setState;
      bool val = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntCheckbox(checked: val, child: const Text('A'));
        },
      ),),);
      expect(find.byIcon(Icons.check), findsNothing);
      setState(() => val = true);
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('disabled prevents toggle', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntCheckbox(
        disabled: true,
        child: const Text('A'),
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('indeterminate shows minus icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(
        indeterminate: true,
        child: Text('A'),
      ),),);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });
  });

  group('AntCheckboxGroup', () {
    testWidgets('renders options', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckboxGroup<String>(
        options: [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('selecting option fires onChange', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        options: const [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, ['a']);
    });

    testWidgets('selecting multiple options accumulates', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        options: const [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, ['a', 'b']);
    });

    testWidgets('deselecting removes value', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        defaultValue: ['a'],
        options: const [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, isEmpty);
    });

    testWidgets('defaultValue shows checked', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckboxGroup<String>(
        defaultValue: ['b'],
        options: [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
      ),),);
      // b 应该选中
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('controlled value updates', (tester) async {
      late StateSetter setState;
      List<String> val = [];
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntCheckboxGroup<String>(
            value: val,
            options: const [
              AntCheckboxOption(value: 'a', label: Text('A')),
            ],
          );
        },
      ),),);
      expect(find.byIcon(Icons.check), findsNothing);
      setState(() => val = ['a']);
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('group disabled prevents toggle', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        disabled: true,
        options: const [
          AntCheckboxOption(value: 'a', label: Text('A')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('option disabled prevents toggle', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        options: const [
          AntCheckboxOption(value: 'a', label: Text('A'), disabled: true),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('vertical direction renders column', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckboxGroup<String>(
        direction: AntCheckboxGroupDirection.vertical,
        options: [
          AntCheckboxOption(value: 'a', label: Text('A')),
          AntCheckboxOption(value: 'b', label: Text('B')),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('children mode toggles via group', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        onChange: (v) => changed = v,
        children: const [
          AntCheckbox(value: 'a', child: Text('A')),
          AntCheckbox(value: 'b', child: Text('B')),
        ],
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, ['a']);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('children mode group disabled prevents toggle',
        (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCheckboxGroup<String>(
        disabled: true,
        onChange: (v) => changed = v,
        children: const [
          AntCheckbox(value: 'a', child: Text('A')),
        ],
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });
  });
}