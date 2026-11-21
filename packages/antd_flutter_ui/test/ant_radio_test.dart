import 'package:antd_flutter_ui/src/data_entry/radio/ant_radio.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 字符串选项 → 大写 label。
String _upLabel(String value) => value.toUpperCase();

/// 自定义模型：用户（名称 / 禁用由模型描述）。
class _User {
  const _User(this.id, this.name, {this.disabled = false});

  final String id;
  final String name;
  final bool disabled;
}

const _users = [
  _User('u1', '张三'),
  _User('u2', '李四', disabled: true),
  _User('u3', '王五'),
];

void main() {
  group('AntRadio', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(const AntRadio(child: Text('选项A'))));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('defaultChecked initializes checked', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRadio(
            defaultChecked: true,
            child: Text('A'),
          ),
        ),
      );
      // 选中状态：内圆点存在（小容器），通过检查圆点数量判断
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('tap selects radio', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadio(
            child: const Text('A'),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, true);
    });

    testWidgets('controlled checked updates', (tester) async {
      late StateSetter setState;
      bool val = false;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, s) {
              setState = s;
              return AntRadio(checked: val, child: const Text('A'));
            },
          ),
        ),
      );
      setState(() => val = true);
      await tester.pump();
      // 受控选中后，onChange 不应触发
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('disabled prevents selection', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadio(
            disabled: true,
            child: const Text('A'),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('in group, value-based selection works', (tester) async {
      String? selected;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            children: [
              const AntRadio(value: 'a', child: Text('A')),
              const AntRadio(value: 'b', child: Text('B')),
            ],
            onChange: (v) => selected = v,
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selected, 'b');
    });
  });

  group('AntRadioGroup', () {
    testWidgets('renders options', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRadioGroup<String>(
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('selecting fires onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, 'a');
    });

    testWidgets('selecting another replaces selection', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            defaultValue: 'a',
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, 'b');
    });

    testWidgets('controlled value updates', (tester) async {
      late StateSetter setState;
      String val = 'a';
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, s) {
              setState = s;
              return AntRadioGroup<String>(
                value: val,
                options: const ['a', 'b'],
                labelOf: _upLabel,
              );
            },
          ),
        ),
      );
      setState(() => val = 'b');
      await tester.pump();
      // 受控切换到 b
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('group disabled prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            disabled: true,
            options: const ['a'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('option disabled prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            options: const ['a', 'b'],
            labelOf: _upLabel,
            disabledOf: (value) => value == 'a',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('vertical direction renders', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRadioGroup<String>(
            direction: AntRadioGroupDirection.vertical,
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('button optionType renders buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRadioGroup<String>(
            optionType: AntRadioGroupOptionType.button,
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('button optionType selection fires onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            optionType: AntRadioGroupOptionType.button,
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, 'b');
    });
  });

  group('AntRadioGroup — 自定义模型', () {
    testWidgets('自定义模型：labelOf/disabledOf 驱动渲染与选择', (tester) async {
      _User? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<_User>(
            options: _users,
            labelOf: (user) => user.name,
            disabledOf: (user) => user.disabled,
            onChange: (user) => changed = user,
          ),
        ),
      );
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('李四'), findsOneWidget);

      // disabledOf 命中项不响应
      await tester.tap(find.text('李四'));
      await tester.pump();
      expect(changed, isNull);

      // 回调直接给出模型对象
      await tester.tap(find.text('王五'));
      await tester.pump();
      expect(changed?.id, 'u3');
    });

    testWidgets('自定义模型：itemBuilder 整项自定义渲染', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<_User>(
            options: _users,
            itemBuilder: (context, user, index) => Padding(
              padding: const EdgeInsets.all(4),
              child: Text('${index + 1}. ${user.name}'),
            ),
            onChange: (user) => changed = user?.id,
          ),
        ),
      );
      expect(find.text('1. 张三'), findsOneWidget);
      await tester.tap(find.text('3. 王五'));
      await tester.pump();
      expect(changed, 'u3');
    });
  });

  group('AntRadioButton', () {
    testWidgets('renders in group', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRadioGroup<String>(
            optionType: AntRadioGroupOptionType.button,
            children: [
              AntRadioButton(value: 'a', child: Text('A')),
              AntRadioButton(value: 'b', child: Text('B')),
            ],
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('tap selects value', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            optionType: AntRadioGroupOptionType.button,
            children: [
              const AntRadioButton(value: 'a', child: Text('A')),
              const AntRadioButton(value: 'b', child: Text('B')),
            ],
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, 'a');
    });

    testWidgets('disabled button prevents selection', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntRadioGroup<String>(
            optionType: AntRadioGroupOptionType.button,
            children: [
              const AntRadioButton(
                  value: 'a', disabled: true, child: Text('A'),),
            ],
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });
  });
  group('AntRadio — 取消反选（回归）', () {
    testWidgets('tapping selected standalone radio deselects', (tester) async {
      var changed = true;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => AntRadio(
              defaultChecked: true,
              onChange: (v) => setState(() => changed = v),
              child: const Text('A'),
            ),
          ),
        ),
      );
      expect(changed, isTrue);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, isFalse);
    });

    testWidgets('tapping selected radio in group deselects (null)',
        (tester) async {
      String? selected = 'a';
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => AntRadioGroup<String>(
              value: selected,
              onChange: (v) => setState(() => selected = v),
              options: const ['a', 'b'],
              labelOf: _upLabel,
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(selected, isNull);
    });
  });
}
