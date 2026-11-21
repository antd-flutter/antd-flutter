/// AntCheckList widget 测试
library;

import 'package:antd_flutter_ui/src/data_entry/check_list/ant_check_list.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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

const _items = ['a', 'b', 'c'];
const _names = {'a': '苹果', 'b': '香蕉', 'c': '橙子'};

String _labelOf(String value) => _names[value]!;

/// 自定义模型：成员（名称 / 邮箱 / 状态由模型描述）。
class _Member {
  const _Member(this.id, this.name, this.email, {this.disabled = false});

  final String id;
  final String name;
  final String email;
  final bool disabled;
}

const _members = [
  _Member('u1', '张三', 'zhang@example.com'),
  _Member('u2', '李四', 'li@example.com', disabled: true),
  _Member('u3', '王五', 'wang@example.com'),
];

/// 便捷构造：字符串列表项 + labelOf。
AntCheckList<String> _list({
  List<String>? value,
  List<String>? defaultValue,
  bool multiple = false,
  bool disabled = false,
  bool readOnly = false,
  bool showCheckMark = true,
  Widget? activeIcon,
  bool Function(String item)? disabledOf,
  ValueChanged<List<String>>? onChange,
}) {
  return AntCheckList<String>(
    value: value,
    defaultValue: defaultValue,
    multiple: multiple,
    disabled: disabled,
    readOnly: readOnly,
    showCheckMark: showCheckMark,
    activeIcon: activeIcon,
    items: _items,
    labelOf: _labelOf,
    disabledOf: disabledOf,
    onChange: onChange,
  );
}

void main() {
  group('AntCheckList — rendering', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(_wrap(_list()));
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('香蕉'), findsOneWidget);
      expect(find.text('橙子'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _list(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
    });

    testWidgets('renders description via descriptionOf', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckList<String>(
            items: ['a'],
            labelOf: _labelOf,
            descriptionOf: _descriptionOf,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('红色水果'), findsOneWidget);
    });

    testWidgets('renders prefix', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            items: const ['a'],
            labelOf: _labelOf,
            prefixBuilder: (context, item) =>
                const Icon(AntIcons.appleOutlined),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.appleOutlined), findsOneWidget);
    });

    testWidgets('hideCheckMark — no check icon shown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _list(showCheckMark: false, defaultValue: ['a']),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('custom activeIcon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _list(
              activeIcon: const Icon(AntIcons.starFilled), defaultValue: ['a'],),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.starFilled), findsOneWidget);
    });
  });

  group('AntCheckList — single selection', () {
    testWidgets('defaultValue shows check mark', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _list(defaultValue: ['b']),
        ),
      );
      await tester.pumpAndSettle();

      // only 'b' row has check icon
      final bRow = find.ancestor(
        of: find.text('香蕉'),
        matching: find.byType(Row),
      );
      expect(
        find.descendant(
            of: bRow, matching: find.byIcon(AntIcons.checkOutlined),),
        findsOneWidget,
      );
    });

    testWidgets('tap selects item and fires onChange', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(_list(onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, ['a']);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('tap another item switches selection', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _list(defaultValue: ['a'], onChange: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, ['b']);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('tap selected item clears selection', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _list(defaultValue: ['a'], onChange: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, isEmpty);
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });
  });

  group('AntCheckList — multiple selection', () {
    testWidgets('tap selects multiple items', (tester) async {
      final changed = <List<String>>[];
      await tester.pumpWidget(
        _wrap(_list(multiple: true, onChange: changed.add)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('橙子'));
      await tester.pumpAndSettle();

      expect(changed, [
        ['a'],
        ['a', 'c'],
      ]);
      expect(find.byIcon(AntIcons.checkOutlined), findsNWidgets(2));
    });

    testWidgets('tap again deselects', (tester) async {
      final changed = <List<String>>[];
      await tester.pumpWidget(
        _wrap(
          _list(
            multiple: true,
            defaultValue: ['a', 'b'],
            onChange: changed.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, [
        ['b'],
      ]);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });
  });

  group('AntCheckList — controlled', () {
    testWidgets('value prop controls selection', (tester) async {
      await tester.pumpWidget(
        _wrap(_list(value: ['b', 'c'])),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.checkOutlined), findsNWidgets(2));
    });

    testWidgets('internal state not changed when controlled', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _list(value: ['a'], onChange: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      // callback fires but UI stays controlled
      expect(changed, ['b']);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });
  });

  group('AntCheckList — disabled & readOnly', () {
    testWidgets('disabled list does not respond to taps', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(_list(disabled: true, onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
    });

    testWidgets('disabled item does not respond to taps', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _list(
              disabledOf: (value) => value == 'a',
              onChange: (v) => changed = v,),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();
      expect(changed, isNull);

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();
      expect(changed, ['b']);
    });

    testWidgets('readOnly list does not respond to taps', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _list(
            readOnly: true,
            defaultValue: ['a'],
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });
  });

  group('AntCheckList — 自定义模型', () {
    testWidgets('自定义模型：labelOf/descriptionOf/disabledOf 驱动渲染与选择',
        (tester) async {
      final changed = <List<_Member>>[];
      await tester.pumpWidget(
        _wrap(
          AntCheckList<_Member>(
            items: _members,
            labelOf: (member) => member.name,
            descriptionOf: (member) => member.email,
            disabledOf: (member) => member.disabled,
            onChange: changed.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('张三'), findsOneWidget);
      expect(find.text('zhang@example.com'), findsOneWidget);

      // 禁用项不响应
      await tester.tap(find.text('李四'));
      await tester.pumpAndSettle();
      expect(changed, isEmpty);

      // 回调直接给出模型对象
      await tester.tap(find.text('王五'));
      await tester.pumpAndSettle();
      expect(changed.single.single.id, 'u3');
    });

    testWidgets('自定义模型：itemBuilder 整行自定义渲染', (tester) async {
      final changed = <List<_Member>>[];
      await tester.pumpWidget(
        _wrap(
          AntCheckList<_Member>(
            items: _members,
            itemBuilder: (context, member, index) =>
                Text('${index + 1}. ${member.name}'),
            onChange: changed.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2. 李四'), findsOneWidget);
      await tester.tap(find.text('1. 张三'));
      await tester.pumpAndSettle();
      expect(changed.single.single.id, 'u1');
    });
  });
}

const _descriptions = {'a': '红色水果'};

String _descriptionOf(String value) => _descriptions[value]!;
