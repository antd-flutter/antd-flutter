/// AntSelector widget 测试
library;

import 'package:antd_flutter_ui/src/data_entry/selector/ant_selector.dart';
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

const _options = ['a', 'b', 'c'];
const _labels = {'a': '苹果', 'b': '香蕉', 'c': '橙子'};

String _labelOf(String value) => _labels[value]!;

const _prices = {'a': '¥5/斤'};

String _priceOf(String value) => _prices[value]!;

/// 自定义模型：水果（名称 / 价格 / 禁用均由模型描述）。
class _Fruit {
  const _Fruit(this.id, this.name, this.price, {this.disabled = false});

  final String id;
  final String name;
  final String price;
  final bool disabled;
}

const _fruits = [
  _Fruit('apple', '苹果', '¥5/斤'),
  _Fruit('banana', '香蕉', '¥3/斤'),
  _Fruit('orange', '橙子', '¥6/斤', disabled: true),
];

/// 便捷构造：字符串选项 + labelOf。
AntSelector<String> _selector({
  List<String>? value,
  List<String>? defaultValue,
  bool multiple = false,
  bool disabled = false,
  bool readOnly = false,
  int? columns,
  List<String> options = _options,
  bool Function(String item)? disabledOf,
  ValueChanged<List<String>>? onChange,
}) {
  return AntSelector<String>(
    value: value,
    defaultValue: defaultValue,
    multiple: multiple,
    disabled: disabled,
    readOnly: readOnly,
    columns: columns,
    options: options,
    labelOf: _labelOf,
    disabledOf: disabledOf,
    onChange: onChange,
  );
}

void main() {
  group('AntSelector — rendering', () {
    testWidgets('renders all options', (tester) async {
      await tester.pumpWidget(_wrap(_selector()));
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('香蕉'), findsOneWidget);
      expect(find.text('橙子'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSelector<String>(
            options: ['a'],
            labelOf: _labelOf,
            descriptionOf: _priceOf,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('¥5/斤'), findsOneWidget);
    });

    testWidgets('columns layout renders rows', (tester) async {
      await tester.pumpWidget(_wrap(_selector(columns: 2)));
      await tester.pumpAndSettle();

      // 3 options with 2 columns → 2 Rows
      expect(find.byType(Row), findsNWidgets(2));
    });
  });

  group('AntSelector — single selection', () {
    testWidgets('defaultValue shows checked style', (tester) async {
      await tester.pumpWidget(_wrap(_selector(defaultValue: ['b'])));
      await tester.pumpAndSettle();

      // checked item has primary border
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      );
      final hasCheckedBorder = containers.any((c) {
        final deco = c.decoration;
        if (deco is! BoxDecoration) return false;
        final border = deco.border;
        if (border is! Border) return false;
        return border.top.color == const Color(0xFF1677FF);
      });
      expect(hasCheckedBorder, isTrue);
    });

    testWidgets('tap selects and fires onChange', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(_selector(onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, ['a']);
    });

    testWidgets('tap another switches selection', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _selector(defaultValue: ['a'], onChange: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, ['b']);
    });

    testWidgets('tap selected clears', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _selector(defaultValue: ['a'], onChange: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, isEmpty);
    });
  });

  group('AntSelector — multiple selection', () {
    testWidgets('select multiple items', (tester) async {
      final changed = <List<String>>[];
      await tester.pumpWidget(
        _wrap(_selector(multiple: true, onChange: changed.add)),
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
    });

    testWidgets('deselect on second tap', (tester) async {
      final changed = <List<String>>[];
      await tester.pumpWidget(
        _wrap(
          _selector(
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
    });
  });

  group('AntSelector — controlled', () {
    testWidgets('value prop controls selection', (tester) async {
      await tester.pumpWidget(
        _wrap(_selector(value: ['b', 'c'], multiple: true)),
      );
      await tester.pumpAndSettle();

      // no crash, renders fine
      expect(find.text('香蕉'), findsOneWidget);
    });

    testWidgets('internal state not changed when controlled', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(_selector(value: ['a'], onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, ['b']);
    });
  });

  group('AntSelector — disabled & readOnly', () {
    testWidgets('disabled selector does not respond', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(_selector(disabled: true, onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
    });

    testWidgets('disabled option does not respond', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _selector(
            disabledOf: (value) => value == 'a',
            onChange: (v) => changed = v,
          ),
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

    testWidgets('readOnly selector does not respond', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          _selector(
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
    });
  });

  group('AntSelector — 自定义模型', () {
    testWidgets('自定义模型：labelOf/descriptionOf/disabledOf 驱动渲染与选择',
        (tester) async {
      final changed = <List<_Fruit>>[];
      await tester.pumpWidget(
        _wrap(
          AntSelector<_Fruit>(
            options: _fruits,
            labelOf: (fruit) => fruit.name,
            descriptionOf: (fruit) => fruit.price,
            disabledOf: (fruit) => fruit.disabled,
            onChange: changed.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('¥5/斤'), findsOneWidget);
      expect(find.text('橙子'), findsOneWidget);

      // 禁用项不响应
      await tester.tap(find.text('橙子'));
      await tester.pumpAndSettle();
      expect(changed, isEmpty);

      // 选中回调直接给出模型对象
      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();
      expect(changed.single.single.id, 'banana');

      // 再次点击已选项取消选择
      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();
      expect(changed.last, isEmpty);
    });
  });
}
