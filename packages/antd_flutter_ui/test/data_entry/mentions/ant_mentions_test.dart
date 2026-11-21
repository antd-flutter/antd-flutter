/// AntMentions widget tests
library;

import 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

const _testOptions = ['afc163', 'zombiej', 'yesmeck'];

/// 自定义模型：成员（username 插入文本、name 展示文案）。
class _Member {
  const _Member(this.id, this.name, this.username, {this.disabled = false});

  final String id;
  final String name;
  final String username;
  final bool disabled;
}

const _members = [
  _Member('u1', '张三', 'zhangsan'),
  _Member('u2', '李四', 'lisi', disabled: true),
  _Member('u3', '王五', 'wangwu'),
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
      await tester.pumpWidget(
        _wrap(
          const AntMentions(
            options: [],
            placeholder: '输入 @ 提及他人',
          ),
        ),
      );
      expect(find.text('输入 @ 提及他人'), findsOneWidget);
    });

    testWidgets('renders default value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(
            options: [],
            defaultValue: 'hello',
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('renders controlled value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(
            options: [],
            value: 'controlled',
          ),
        ),
      );
      expect(find.text('controlled'), findsOneWidget);
    });

    testWidgets('typing @ shows options dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(options: _testOptions),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
      expect(find.text('zombiej'), findsWidgets);
    });

    testWidgets('typing @a filters options', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(options: _testOptions),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@a');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
      // zombiej 和 yesmeck 不含 'a'，不应显示在选项中
      expect(find.text('zombiej'), findsNothing);
    });

    testWidgets('typing without @ does not show dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(options: _testOptions),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsNothing);
    });

    testWidgets('selecting option inserts mention text', (tester) async {
      String? changedText;
      String? selectedOption;
      await tester.pumpWidget(
        _wrap(
          AntMentions(
            options: _testOptions,
            onChange: (text) => changedText = text,
            onSelect: (opt) => selectedOption = opt,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      await tester.tap(find.text('afc163').last);
      await tester.pumpAndSettle();
      expect(changedText, '@afc163 ');
      expect(selectedOption, 'afc163');
    });

    testWidgets('selecting option replaces search text', (tester) async {
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions(
            options: _testOptions,
            onChange: (text) => changedText = text,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@zom');
      await tester.pumpAndSettle();
      await tester.tap(find.text('zombiej').last);
      await tester.pumpAndSettle();
      expect(changedText, '@zombiej ');
    });

    testWidgets('space after @ closes dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(options: _testOptions),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '@ afc');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsNothing);
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions<String>(
            options: const ['ok', 'no'],
            labelOf: (value) => value == 'ok' ? '可用' : '禁用',
            disabledOf: (value) => value == 'no',
            onChange: (text) => changedText = text,
          ),
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          const AntMentions(
            options: _testOptions,
            disabled: true,
            placeholder: '禁用',
          ),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('allowClear shows clear icon and clears text', (tester) async {
      String? changedText = 'hello';
      await tester.pumpWidget(
        _wrap(
          AntMentions(
            options: _testOptions,
            defaultValue: 'hello',
            allowClear: true,
            onChange: (text) => changedText = text,
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(changedText, '');
    });

    testWidgets('custom prefix triggers dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(
            options: _testOptions,
            prefix: '#',
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '#');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
    });

    testWidgets('controlled value updates display', (tester) async {
      late StateSetter setStateOuter;
      String? value;
      await tester.pumpWidget(
        _wrap(
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
        ),
      );
      expect(find.text('请输入'), findsOneWidget);
      setStateOuter(() => value = 'updated');
      await tester.pumpAndSettle();
      expect(find.text('updated'), findsOneWidget);
    });

    testWidgets('onChange fires on text change in uncontrolled mode',
        (tester) async {
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions(
            options: _testOptions,
            onChange: (text) => changedText = text,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'hello world');
      await tester.pumpAndSettle();
      expect(changedText, 'hello world');
    });
  });

  group('AntMentions — labelOf 缺省回退', () {
    testWidgets('未提供 labelOf 时用 item 文本展示与插入', (tester) async {
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions<String>(
            options: const ['afc163'],
            onChange: (text) => changedText = text,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '@a');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsWidgets);
      await tester.tap(find.text('afc163').last);
      await tester.pumpAndSettle();
      expect(changedText, '@afc163 ');
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

  group('AntMentions — 自定义模型', () {
    testWidgets('自定义模型：labelOf 展示 / valueOf 插入 / onSelect 回传模型',
        (tester) async {
      _Member? selected;
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions<_Member>(
            options: _members,
            labelOf: (member) => member.name,
            valueOf: (member) => member.username,
            disabledOf: (member) => member.disabled,
            onChange: (text) => changedText = text,
            onSelect: (member) => selected = member,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      expect(find.text('张三'), findsWidgets);
      expect(find.text('李四'), findsWidgets);

      await tester.tap(find.text('张三').last);
      await tester.pumpAndSettle();
      expect(selected?.id, 'u1');
      expect(changedText, '@zhangsan ');
    });

    testWidgets('自定义模型：disabledOf 命中项不可选', (tester) async {
      _Member? selected;
      String? changedText;
      await tester.pumpWidget(
        _wrap(
          AntMentions<_Member>(
            options: _members,
            labelOf: (member) => member.name,
            valueOf: (member) => member.username,
            disabledOf: (member) => member.disabled,
            onChange: (text) => changedText = text,
            onSelect: (member) => selected = member,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      await tester.tap(find.text('李四').last);
      await tester.pumpAndSettle();
      expect(selected, isNull);
      expect(changedText, '@');
    });

    testWidgets('自定义模型：itemBuilder 整行自定义渲染', (tester) async {
      _Member? selected;
      await tester.pumpWidget(
        _wrap(
          AntMentions<_Member>(
            options: _members,
            labelOf: (member) => member.name,
            valueOf: (member) => member.username,
            itemBuilder: (context, member, index) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text('@${member.name}'),),
            onSelect: (member) => selected = member,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      expect(find.text('@王五'), findsOneWidget);
      await tester.tap(find.text('@王五'));
      await tester.pumpAndSettle();
      expect(selected?.id, 'u3');
    });
  });

  group('AntMentions — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.bottomCenter,
            child: AntMentions(options: _testOptions),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '@');
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_mentions_panel')));
      final trigger = tester.getRect(find.byType(AntMentions<String>));
      expect(panel.bottom, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('镂空遮挡不干扰输入框继续输入', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMentions(options: _testOptions),
        ),
      );
      await tester.enterText(find.byType(TextField), '@a');
      await tester.pumpAndSettle();
      // 弹层打开（@ 触发）后继续输入仍可过滤选项
      await tester.enterText(find.byType(TextField), '@af');
      await tester.pumpAndSettle();
      expect(find.text('afc163'), findsOneWidget);
    });
  });

  group('AntMentions — 单一外层描边（双层边框回归）', () {
    testWidgets('主题带 InputDecorationTheme 时输入框不产生内层第二道边框', (tester) async {
      await tester.pumpWidget(
        AntScreenUtilInit(
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
                child:
                    const Material(child: AntMentions(options: _testOptions)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect(decoration.border, InputBorder.none);
      expect(decoration.enabledBorder, InputBorder.none);
      expect(decoration.focusedBorder, InputBorder.none);
      expect(decoration.disabledBorder, InputBorder.none);
      // 探针：触发容器是子树内唯一绘制边框的 DecoratedBox
      var borderedCount = 0;
      void visit(Element e) {
        final w = e.widget;
        if (w is DecoratedBox && w.decoration is BoxDecoration) {
          final b = (w.decoration as BoxDecoration).border;
          if (b != null &&
              !(b is Border && b.dimensions == const EdgeInsets.all(0))) {
            borderedCount++;
          }
        }
        e.visitChildren(visit);
      }

      visit(tester.element(find.byType(AntMentions<String>)));
      expect(borderedCount, 1);
    });
  });

  group('AntMentions — 验收回归（禁用灰底）', () {
    testWidgets('禁用态背景为灰底 token，输入框填充不盖掉容器灰底', (tester) async {
      await tester.pumpWidget(
        AntScreenUtilInit(
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
                  child: AntMentions(options: _testOptions, disabled: true),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect(decoration.filled, true);
      expect(decoration.fillColor, Colors.transparent);
      final t = AntThemeData.light();
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AntMentions<String>),
              matching: find.byWidgetPredicate(
                (w) => w is Container && w.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect(
        (container.decoration! as BoxDecoration).color,
        t.colorBgContainerDisabled,
      );
    });
  });
}
