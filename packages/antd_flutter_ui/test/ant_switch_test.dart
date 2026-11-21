import 'package:antd_flutter_ui/src/data_entry/switch/ant_switch.dart';
import 'package:antd_flutter_ui/src/feedback/loading/ant_loading.dart';
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
  group('AntSwitch', () {
    testWidgets('renders unchecked by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch()));
      expect(find.byType(AntSwitch), findsOneWidget);
    });

    testWidgets('defaultChecked initializes checked', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(defaultChecked: true)));
      expect(find.byType(AntSwitch), findsOneWidget);
    });

    testWidgets('tap toggles state', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntSwitch(onChange: (v) => changed = v)));
      await tester.tap(find.byType(AntSwitch));
      await tester.pump();
      expect(changed, true);
    });

    testWidgets('tap again toggles back', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntSwitch(
        defaultChecked: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSwitch));
      await tester.pump();
      expect(changed, false);
    });

    testWidgets('controlled checked updates', (tester) async {
      late StateSetter setState;
      bool val = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntSwitch(checked: val);
        },
      ),),);
      setState(() => val = true);
      await tester.pump();
      expect(find.byType(AntSwitch), findsOneWidget);
    });

    testWidgets('disabled prevents toggle', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntSwitch(
        disabled: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSwitch));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('loading prevents toggle', (tester) async {
      bool? changed;
      await tester.pumpWidget(_wrap(AntSwitch(
        loading: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSwitch));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('loading shows progress indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(loading: true)));
      expect(find.byType(AntLoading), findsOneWidget);
    });

    testWidgets('checkedChildren renders when checked', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(
        defaultChecked: true,
        checkedChildren: Text('开'),
      ),),);
      expect(find.text('开'), findsOneWidget);
    });

    testWidgets('unCheckedChildren renders when unchecked', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(
        unCheckedChildren: Text('关'),
      ),),);
      expect(find.text('关'), findsOneWidget);
    });

    testWidgets('children swap on toggle', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(
        checkedChildren: Text('ON'),
        unCheckedChildren: Text('OFF'),
      ),),);
      expect(find.text('OFF'), findsOneWidget);
      await tester.tap(find.byType(AntSwitch));
      await tester.pump();
      expect(find.text('ON'), findsOneWidget);
    });

    testWidgets('small size renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwitch(size: AntSwitchSize.small)));
      expect(find.byType(AntSwitch), findsOneWidget);
    });
  });
}