import 'package:antd_flutter_ui/antd_flutter_ui.dart';
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
  group('AntVirtualInput — rendering', () {
    testWidgets('renders placeholder when empty', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(placeholder: '请输入金额')),
      );
      expect(find.text('请输入金额'), findsOneWidget);
    });

    testWidgets('renders value text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(defaultValue: '123')),
      );
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('disabled does not open keyboard on tap', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(disabled: true, placeholder: '禁用')),
      );
      await tester.tap(find.text('禁用'));
      await tester.pump();
      expect(find.text('1'), findsNothing);
    });

    testWidgets('autoFocus shows keyboard initially', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(autoFocus: true)),
      );
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('AntVirtualInput — interaction', () {
    testWidgets('tap input opens keyboard', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(placeholder: '点我')),
      );
      expect(find.text('1'), findsNothing);
      await tester.tap(find.text('点我'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('tap digit fires onChange', (tester) async {
      var changed = '';
      await tester.pumpWidget(_wrap(AntVirtualInput(
        placeholder: '输入',
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('输入'));
      await tester.pump();
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(changed, '1');
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(changed, '12');
    });

    testWidgets('clearable icon clears value', (tester) async {
      var changed = '';
      await tester.pumpWidget(_wrap(AntVirtualInput(
        defaultValue: '123',
        clearable: true,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('123'));
      await tester.pump();
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(changed, '');
    });

    testWidgets('confirm button fires onEnterPress', (tester) async {
      var entered = '';
      await tester.pumpWidget(_wrap(AntVirtualInput(
        defaultValue: '99',
        confirmText: '确定',
        onEnterPress: (v) => entered = v,
      ),),);
      await tester.tap(find.text('99'));
      await tester.pump();
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(entered, '99');
    });

    testWidgets('blur icon hides keyboard', (tester) async {
      var blurCount = 0;
      await tester.pumpWidget(_wrap(AntVirtualInput(
        placeholder: '输入',
        onBlur: () => blurCount++,
      ),),);
      await tester.tap(find.text('输入'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.keyboard_hide_outlined));
      await tester.pump();
      expect(find.text('1'), findsNothing);
      expect(blurCount, 1);
    });

    testWidgets('onFocus fires when tapped', (tester) async {
      var focusCount = 0;
      await tester.pumpWidget(_wrap(AntVirtualInput(
        placeholder: '输入',
        onFocus: () => focusCount++,
      ),),);
      await tester.tap(find.text('输入'));
      await tester.pump();
      expect(focusCount, 1);
    });

    testWidgets('customKey renders on keyboard', (tester) async {
      await tester.pumpWidget(_wrap(const AntVirtualInput(
        placeholder: '输入',
        customKey: '.',
        autoFocus: true,
      ),),);
      expect(find.text('.'), findsOneWidget);
    });
  });

  group('AntVirtualInput — controlled', () {
    testWidgets('value prop controls displayed text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(value: '456')),
      );
      expect(find.text('456'), findsOneWidget);
    });

    testWidgets('controlled tap digit fires onChange only', (tester) async {
      var changed = '';
      await tester.pumpWidget(_wrap(AntVirtualInput(
        value: '1',
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(changed, '12');
    });
  });
}