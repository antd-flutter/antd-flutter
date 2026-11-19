import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
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
  group('AntInput', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(placeholder: '请输入')));
      expect(find.text('请输入'), findsOneWidget);
    });

    testWidgets('defaultValue shows initial text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'hello')));
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('controlled value updates text', (tester) async {
      late StateSetter setState;
      String val = 'a';
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntInput(value: val);
        },
      ),),);
      expect(find.text('a'), findsOneWidget);
      setState(() => val = 'b');
      await tester.pump();
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('onChange fires on text input', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntInput(onChange: (v) => changed = v)));
      await tester.enterText(find.byType(TextField), 'hi');
      expect(changed, 'hi');
    });

    testWidgets('disabled input does not accept text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(disabled: true, placeholder: '禁用')));
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);
    });

    testWidgets('prefix and suffix render', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(
        prefix: Icon(Icons.search),
        suffix: Icon(Icons.settings),
      ),),);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('addonBefore renders as label', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(
        addonBefore: Text('http://'),
        placeholder: 'url',
      ),),);
      expect(find.text('http://'), findsOneWidget);
    });

    testWidgets('allowClear shows clear icon when has value', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(
        allowClear: true,
        defaultValue: 'text',
      ),),);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('allowClear hidden when empty', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(allowClear: true)));
      expect(find.byIcon(Icons.cancel), findsNothing);
    });

    testWidgets('clear button clears text', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntInput(
        allowClear: true,
        defaultValue: 'text',
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(changed, '');
      expect(find.text('text'), findsNothing);
    });

    testWidgets('showCount displays count with maxLength', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(
        maxLength: 10,
        showCount: true,
        defaultValue: 'abc',
      ),),);
      expect(find.text('3 / 10'), findsOneWidget);
    });

    testWidgets('onPressEnter fires on submit', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(_wrap(AntInput(onPressEnter: () => pressed = true)));
      await tester.enterText(find.byType(TextField), 'x');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(pressed, true);
    });

    testWidgets('bordered=false renders without border', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(bordered: false, placeholder: '无边框')));
      expect(find.text('无边框'), findsOneWidget);
      // AnimatedContainer 存在但无 border
      expect(find.byType(AnimatedContainer), findsNothing);
    });
  });

  group('AntInputTextArea', () {
    testWidgets('renders multiline TextField', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputTextArea(
        placeholder: '多行',
        rows: 4,
      ),),);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.minLines, 4);
      expect(field.maxLines, 4);
      expect(find.text('多行'), findsOneWidget);
    });

    testWidgets('autoSize true allows expand', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputTextArea(autoSize: true)));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.minLines, 1);
      expect(field.maxLines, null);
    });

    testWidgets('autoSize with min max', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputTextArea(autoSize: [2, 6])));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.minLines, 2);
      expect(field.maxLines, 6);
    });

    testWidgets('showCount displays count', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputTextArea(
        maxLength: 50,
        showCount: true,
        defaultValue: 'abc',
      ),),);
      expect(find.text('3 / 50'), findsOneWidget);
    });

    testWidgets('onChange fires', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntInputTextArea(onChange: (v) => changed = v)));
      await tester.enterText(find.byType(TextField), 'test');
      expect(changed, 'test');
    });
  });

  group('AntInputPassword', () {
    testWidgets('obscures text by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputPassword(defaultValue: 'secret')));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, true);
    });

    testWidgets('toggle visibility reveals text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputPassword(defaultValue: 'secret')));
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, false);
    });

    testWidgets('visibilityToggle false hides toggle icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputPassword(
        visibilityToggle: false,
        defaultValue: 'x',
      ),),);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('disabled password cannot toggle', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputPassword(
        disabled: true,
        defaultValue: 'x',
      ),),);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      // 仍然是密文状态
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });

  group('AntInputSearch', () {
    testWidgets('renders suffix search icon by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputSearch(placeholder: '搜索')));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('onSearch fires via suffix tap', (tester) async {
      String? searched;
      await tester.pumpWidget(_wrap(AntInputSearch(
        defaultValue: 'keyword',
        onSearch: (v) => searched = v,
      ),),);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      expect(searched, 'keyword');
    });

    testWidgets('enterButton true renders text button', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputSearch(
        enterButton: true,
        placeholder: 's',
      ),),);
      expect(find.text('搜索'), findsOneWidget);
    });

    testWidgets('enterButton with custom text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputSearch(
        enterButton: '查找',
        placeholder: 's',
      ),),);
      expect(find.text('查找'), findsOneWidget);
    });

    testWidgets('onSearch fires via enter button', (tester) async {
      String? searched;
      await tester.pumpWidget(_wrap(AntInputSearch(
        enterButton: true,
        defaultValue: 'q',
        onSearch: (v) => searched = v,
      ),),);
      await tester.tap(find.text('搜索'));
      await tester.pump();
      expect(searched, 'q');
    });

    testWidgets('onSearch fires via enter key', (tester) async {
      String? searched;
      await tester.pumpWidget(_wrap(AntInputSearch(
        onSearch: (v) => searched = v,
      ),),);
      await tester.enterText(find.byType(TextField), 'enter');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(searched, 'enter');
    });
  });

  group('AntInputGroup', () {
    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputGroup(
        children: [
          AntInput(placeholder: 'a'),
          AntInput(placeholder: 'b'),
        ],
      ),),);
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('compact mode renders children', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputGroup(
        compact: true,
        children: [
          AntInput(placeholder: 'a'),
          AntInput(placeholder: 'b'),
        ],
      ),),);
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });
  });
}