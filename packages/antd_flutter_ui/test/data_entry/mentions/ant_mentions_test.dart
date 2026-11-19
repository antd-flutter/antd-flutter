/// AntMentions widget tests
library;

import 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _testOptions = <AntMentionsOption>[
  AntMentionsOption(value: 'afc163', label: 'afc163'),
  AntMentionsOption(value: 'zombiej', label: 'zombiej'),
  AntMentionsOption(value: 'yesmeck', label: 'yesmeck'),
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
  group('AntMentions', () {
    testWidgets('renders placeholder when empty', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(
          options: [],
          placeholder: '输入 @ 提及他人',
        ),
      ),);
      expect(find.text('输入 @ 提及他人'), findsOneWidget);
    });

    testWidgets('renders default value', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(
          options: [],
          defaultValue: 'hello',
        ),
      ),);
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('renders controlled value', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(
          options: [],
          value: 'controlled',
        ),
      ),);
      expect(find.text('controlled'), findsOneWidget);
    });

    testWidgets('typing @ shows options dropdown', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(options: _testOptions),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
      expect(find.text('zombiej'), findsWidgets);
    });

    testWidgets('typing @a filters options', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(options: _testOptions),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@a');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
      // zombiej 和 yesmeck 不含 'a'，不应显示在选项中
      expect(find.text('zombiej'), findsNothing);
    });

    testWidgets('typing without @ does not show dropdown', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(options: _testOptions),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsNothing);
    });

    testWidgets('selecting option inserts mention text', (tester) async {
      String? changedText;
      AntMentionsOption? selectedOption;
      await tester.pumpWidget(_wrap(
        AntMentions(
          options: _testOptions,
          onChange: (text) => changedText = text,
          onSelect: (opt) => selectedOption = opt,
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      await tester.tap(find.text('afc163').last);
      await tester.pumpAndSettle();
      expect(changedText, '@afc163 ');
      expect(selectedOption?.value, 'afc163');
    });

    testWidgets('selecting option replaces search text', (tester) async {
      String? changedText;
      await tester.pumpWidget(_wrap(
        AntMentions(
          options: _testOptions,
          onChange: (text) => changedText = text,
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@zom');
      await tester.pumpAndSettle();
      await tester.tap(find.text('zombiej').last);
      await tester.pumpAndSettle();
      expect(changedText, '@zombiej ');
    });

    testWidgets('space after @ closes dropdown', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(options: _testOptions),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@ afc');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsNothing);
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      String? changedText;
      const options = [
        AntMentionsOption(value: 'ok', label: '可用'),
        AntMentionsOption(value: 'no', label: '禁用', disabled: true),
      ];
      await tester.pumpWidget(_wrap(
        AntMentions(
          options: options,
          onChange: (text) => changedText = text,
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      expect(changedText, '@');
      await tester.tap(find.text('禁用').last);
      await tester.pumpAndSettle();
      // 禁用项不应被选中，文本仍为 '@'
      expect(changedText, '@');
    });

    testWidgets('disabled mentions does not respond to input', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(
          options: _testOptions,
          disabled: true,
          placeholder: '禁用',
        ),
      ),);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('allowClear shows clear icon and clears text', (tester) async {
      String? changedText = 'hello';
      await tester.pumpWidget(_wrap(
        AntMentions(
          options: _testOptions,
          defaultValue: 'hello',
          allowClear: true,
          onChange: (text) => changedText = text,
        ),
      ),);
      expect(find.text('hello'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(changedText, '');
    });

    testWidgets('custom prefix triggers dropdown', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(
          options: _testOptions,
          prefix: '#',
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '#');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
    });

    testWidgets('controlled value updates display', (tester) async {
      late StateSetter setStateOuter;
      String? value;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            setStateOuter = setState;
            return AntMentions(
              options: _testOptions,
              value: value,
              placeholder: '请输入',
            );
          },
        ),
      ),);
      expect(find.text('请输入'), findsOneWidget);
      setStateOuter(() => value = 'updated');
      await tester.pumpAndSettle();
      expect(find.text('updated'), findsOneWidget);
    });

    testWidgets('onChange fires on text change in uncontrolled mode', (tester) async {
      String? changedText;
      await tester.pumpWidget(_wrap(
        AntMentions(
          options: _testOptions,
          onChange: (text) => changedText = text,
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'hello world');
      await tester.pumpAndSettle();
      expect(changedText, 'hello world');
    });
  });

  group('AntMentionsOption', () {
    test('displayLabel returns label when set', () {
      const opt = AntMentionsOption(value: 'v1', label: '显示文本');
      expect(opt.displayLabel, '显示文本');
    });

    test('displayLabel returns value when label is null', () {
      const opt = AntMentionsOption(value: 'v1');
      expect(opt.displayLabel, 'v1');
    });

    test('disabled defaults to false', () {
      const opt = AntMentionsOption(value: 'v1');
      expect(opt.disabled, isFalse);
    });
  });

  group('AntMentionsSize', () {
    test('has three values', () {
      expect(AntMentionsSize.values.length, 3);
      expect(AntMentionsSize.values, contains(AntMentionsSize.large));
      expect(AntMentionsSize.values, contains(AntMentionsSize.middle));
      expect(AntMentionsSize.values, contains(AntMentionsSize.small));
    });
  });

  group('AntMentions — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(_wrap(
        const Align(
          alignment: Alignment.bottomCenter,
          child: AntMentions(options: _testOptions),
        ),
      ),);
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_mentions_panel')));
      final trigger = tester.getRect(find.byType(AntMentions));
      expect(panel.bottom, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('镂空遮挡不干扰输入框继续输入', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntMentions(options: _testOptions),
      ),);
      await tester.enterText(find.byType(TextField), '@a');
      await tester.pumpAndSettle();
      // 弹层打开（@ 触发）后继续输入仍可过滤选项
      await tester.enterText(find.byType(TextField), '@af');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsOneWidget);
    });
  });
}
