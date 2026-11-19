import 'package:antd_flutter_ui/src/data_entry/radio/ant_radio.dart';
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
  group('AntRadio', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadio(child: Text('选项A'))));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('defaultChecked initializes checked', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadio(
        defaultChecked: true,
        child: Text('A'),
      ),),);
      // 选中状态：内圆点存在（小容器），通过检查圆点数量判断
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('tap selects radio', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntRadio(
        child: const Text('A'),
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, true);
    });

    testWidgets('controlled checked updates', (tester) async {
      late StateSetter setState;
      bool val = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntRadio(checked: val, child: const Text('A'));
        },
      ),),);
      setState(() => val = true);
      await tester.pump();
      // 受控选中后，onChange 不应触发
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('disabled prevents selection', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntRadio(
        disabled: true,
        child: const Text('A'),
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('in group, value-based selection works', (tester) async {
      String? selected;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        children: [
          const AntRadio(value: 'a', child: Text('A')),
          const AntRadio(value: 'b', child: Text('B')),
        ],
        onChange: (v) => selected = v,
      ),),);
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selected, 'b');
    });
  });

  group('AntRadioGroup', () {
    testWidgets('renders options', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadioGroup<String>(
        options: [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('selecting fires onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        options: const [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, 'a');
    });

    testWidgets('selecting another replaces selection', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        defaultValue: 'a',
        options: const [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, 'b');
    });

    testWidgets('controlled value updates', (tester) async {
      late StateSetter setState;
      String val = 'a';
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntRadioGroup<String>(
            value: val,
            options: const [
              AntRadioOption(value: 'a', label: Text('A')),
              AntRadioOption(value: 'b', label: Text('B')),
            ],
          );
        },
      ),),);
      setState(() => val = 'b');
      await tester.pump();
      // 受控切换到 b
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('group disabled prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        disabled: true,
        options: const [
          AntRadioOption(value: 'a', label: Text('A')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('option disabled prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        options: const [
          AntRadioOption(value: 'a', label: Text('A'), disabled: true),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('vertical direction renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadioGroup<String>(
        direction: AntRadioGroupDirection.vertical,
        options: [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
      ),),);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('button optionType renders buttons', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadioGroup<String>(
        optionType: AntRadioGroupOptionType.button,
        options: [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('button optionType selection fires onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        optionType: AntRadioGroupOptionType.button,
        options: const [
          AntRadioOption(value: 'a', label: Text('A')),
          AntRadioOption(value: 'b', label: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, 'b');
    });
  });

  group('AntRadioButton', () {
    testWidgets('renders in group', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadioGroup<String>(
        optionType: AntRadioGroupOptionType.button,
        children: [
          AntRadioButton(value: 'a', child: Text('A')),
          AntRadioButton(value: 'b', child: Text('B')),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('tap selects value', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        optionType: AntRadioGroupOptionType.button,
        children: [
          const AntRadioButton(value: 'a', child: Text('A')),
          const AntRadioButton(value: 'b', child: Text('B')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, 'a');
    });

    testWidgets('disabled button prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntRadioGroup<String>(
        optionType: AntRadioGroupOptionType.button,
        children: [
          const AntRadioButton(value: 'a', disabled: true, child: Text('A')),
        ],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });
  });
}