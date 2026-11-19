import 'package:antd_flutter_ui/src/data_entry/auto_complete/ant_auto_complete.dart';
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
  AntAutoCompleteOption(value: 'apple', label: 'Apple'),
  AntAutoCompleteOption(value: 'banana', label: 'Banana'),
  AntAutoCompleteOption(value: 'cherry', label: 'Cherry'),
  AntAutoCompleteOption(value: 'grape', label: 'Grape'),
];

void main() {
  group('AntAutoComplete', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        placeholder: '请输入',
      ),),);
      expect(find.text('请输入'), findsOneWidget);
    });

    testWidgets('shows dropdown when focused', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
      ),),);
      // Initially no dropdown
      expect(find.text('Apple'), findsNothing);
      // Tap to focus
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      // Dropdown shows all options
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Grape'), findsOneWidget);
    });

    testWidgets('filters options based on input', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'app');
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
      expect(find.text('Cherry'), findsNothing);
      expect(find.text('Grape'), findsNothing);
    });

    testWidgets('shows no-match message when filter finds nothing', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('无匹配项'), findsOneWidget);
    });

    testWidgets('selects option and fills input', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      // Tap option in dropdown
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();
      // Input filled with value
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, 'banana');
    });

    testWidgets('calls onChange when typing', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntAutoComplete(
        options: _options,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pumpAndSettle();
      expect(changed, 'hello');
    });

    testWidgets('calls onSelect when selecting an option', (tester) async {
      AntAutoCompleteOption? selected;
      await tester.pumpWidget(_wrap(AntAutoComplete(
        options: _options,
        onSelect: (o) => selected = o,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cherry').last);
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
      expect(selected!.value, 'cherry');
    });

    testWidgets('disabled state prevents interaction', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        disabled: true,
        placeholder: '禁用',
      ),),);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);
    });

    testWidgets('filterOption=false shows all options regardless of input', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        filterOption: false,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('defaultValue shows initial value', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        defaultValue: 'banana',
      ),),);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, 'banana');
    });

    testWidgets('controlled value overrides internal value', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        value: 'apple',
      ),),);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, 'apple');
    });

    testWidgets('allowClear shows clear button and clears value', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: _options,
        defaultValue: 'banana',
        allowClear: true,
      ),),);
      // Clear icon visible
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, '');
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      const options = [
        AntAutoCompleteOption(value: 'a', label: 'A'),
        AntAutoCompleteOption(value: 'b', label: 'B', disabled: true),
      ];
      AntAutoCompleteOption? selected;
      await tester.pumpWidget(_wrap(AntAutoComplete(
        options: options,
        onSelect: (o) => selected = o,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      // Disabled option has no InkWell onTap
      final disabledTile = find.ancestor(
        of: find.text('B'),
        matching: find.byType(InkWell),
      );
      final inkWell = tester.widget<InkWell>(disabledTile);
      expect(inkWell.onTap, isNull);
      expect(selected, isNull);
    });

    testWidgets('option displayLabel falls back to value when label is null', (tester) async {
      const options = [AntAutoCompleteOption(value: 'onlyValue')];
      await tester.pumpWidget(_wrap(const AntAutoComplete(
        options: options,
      ),),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.text('onlyValue'), findsOneWidget);
    });
  });

  group('AntAutoComplete — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(_wrap(
        const Align(
          alignment: Alignment.bottomCenter,
          child: AntAutoComplete(options: _options),
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_auto_complete_panel')));
      final trigger = tester.getRect(find.byType(AntAutoComplete));
      expect(panel.top, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('镂空遮挡不干扰输入框继续输入', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntAutoComplete(options: _options, defaultValue: ''),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      // 弹层打开时输入框仍可输入（弹层遮挡镂空触发区域）
      await tester.enterText(find.byType(TextField), 'ap');
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });
  });

  group('AntAutoComplete — 单一外层描边（双层边框回归）', () {
    /// 探针：统计子树内绘制边框的 DecoratedBox 数量（触发容器应恰好 1 个）
    int countBorderedDecorations(Element root) {
      var count = 0;
      void visit(Element e) {
        final w = e.widget;
        if (w is DecoratedBox && w.decoration is BoxDecoration) {
          final d = w.decoration as BoxDecoration;
          final b = d.border;
          if (b != null && !(b is Border && b.dimensions == const EdgeInsets.all(0))) {
            count++;
          }
        }
        e.visitChildren(visit);
      }
      visit(root);
      return count;
    }

    testWidgets('主题带 InputDecorationTheme 时输入框不产生内层第二道边框', (tester) async {
      // 模拟 app 主题注入 enabledBorder/focusedBorder（双层边框根因场景）
      await tester.pumpWidget(AntScreenUtilInit(
        builder: (context, _) => MaterialApp(
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
          home: Scaffold(
            body: AntTheme(
              data: AntThemeData.light(),
              child: const Material(child: AntAutoComplete(options: _options)),
            ),
          ),
        ),
      ),);
      await tester.pumpAndSettle();
      // 输入框自身四态边框均为 none（单一外层描边语义）
      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect(decoration.border, InputBorder.none);
      expect(decoration.enabledBorder, InputBorder.none);
      expect(decoration.focusedBorder, InputBorder.none);
      expect(decoration.disabledBorder, InputBorder.none);
      // 探针出图核对：触发区域整棵子树只有外层容器 1 道边框
      final root = tester.element(find.byType(AntAutoComplete));
      expect(countBorderedDecorations(root), 1);
    });
  });

  group('AntAutoComplete — 验收回归（面板贴齐 / 禁用灰底）', () {
    testWidgets('联想面板紧贴触发元素：面板 top − 触发 bottom ≈ gap(4±2)', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoComplete(options: _options)),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      final panel =
          tester.getRect(find.byKey(const Key('ant_auto_complete_panel')));
      final trigger = tester.getRect(find.byType(AntAutoComplete));
      final actualGap = panel.top - trigger.bottom;
      expect(actualGap, greaterThanOrEqualTo(2));
      expect(actualGap, lessThanOrEqualTo(6));
    });

    testWidgets('禁用态背景为灰底（colorBgContainerDisabled），非主题白色填充', (tester) async {
      // 模拟 Material 桥接主题注入 filled 白底（双层白底根因场景）
      await tester.pumpWidget(AntScreenUtilInit(
        builder: (context, _) => MaterialApp(
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          home: Scaffold(
            body: AntTheme(
              data: AntThemeData.light(),
              child: const Material(
                child: AntAutoComplete(
                  options: _options,
                  disabled: true,
                ),
              ),
            ),
          ),
        ),
      ),);
      await tester.pumpAndSettle();
      // 输入框填充透明（不盖掉容器灰底）
      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect(decoration.filled, true);
      expect(decoration.fillColor, Colors.transparent);
      // 外层容器为禁用灰底 token
      final t = AntThemeData.light();
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AntAutoComplete),
              matching: find.byWidgetPredicate(
                (w) => w is Container && w.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect((container.decoration! as BoxDecoration).color,
          t.colorBgContainerDisabled,);
    });
  });
}
