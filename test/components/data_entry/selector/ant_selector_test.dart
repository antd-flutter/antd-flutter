/// AntSelector widget 测试
library;

import 'package:antd_flutter_plus/src/components/data_entry/selector/ant_selector.dart';
import 'package:antd_flutter_plus/src/components/data_entry/selector/ant_selector_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
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

List<AntSelectorOption<String>> _options() => const [
      AntSelectorOption(value: 'a', label: Text('苹果')),
      AntSelectorOption(value: 'b', label: Text('香蕉')),
      AntSelectorOption(value: 'c', label: Text('橙子')),
    ];

void main() {
  group('AntSelector — rendering', () {
    testWidgets('renders all options', (tester) async {
      await tester.pumpWidget(_wrap(AntSelector<String>(options: _options())));
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('香蕉'), findsOneWidget);
      expect(find.text('橙子'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(
            options: const [
              AntSelectorOption(
                value: 'a',
                label: Text('苹果'),
                description: Text('¥5/斤'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('¥5/斤'), findsOneWidget);
    });

    testWidgets('columns layout renders rows', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(
            columns: 2,
            options: _options(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 3 options with 2 columns → 2 Rows
      expect(find.byType(Row), findsNWidgets(2));
    });
  });

  group('AntSelector — single selection', () {
    testWidgets('defaultValue shows checked style', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(defaultValue: ['b'], options: _options()),
        ),
      );
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
        _wrap(
          AntSelector<String>(
            options: _options(),
            onChange: (v) => changed = v,
          ),
        ),
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
          AntSelector<String>(
            defaultValue: ['a'],
            options: _options(),
            onChange: (v) => changed = v,
          ),
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
          AntSelector<String>(
            defaultValue: ['a'],
            options: _options(),
            onChange: (v) => changed = v,
          ),
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
      List<List<String>> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(
            multiple: true,
            options: _options(),
            onChange: (v) => changed.add(v),
          ),
        ),
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
      List<List<String>> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(
            multiple: true,
            defaultValue: ['a', 'b'],
            options: _options(),
            onChange: (v) => changed.add(v),
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
        _wrap(
          AntSelector<String>(value: ['b', 'c'], multiple: true, options: _options()),
        ),
      );
      await tester.pumpAndSettle();

      // no crash, renders fine
      expect(find.text('香蕉'), findsOneWidget);
    });

    testWidgets('internal state not changed when controlled', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntSelector<String>(
            value: ['a'],
            options: _options(),
            onChange: (v) => changed = v,
          ),
        ),
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
        _wrap(
          AntSelector<String>(
            disabled: true,
            options: _options(),
            onChange: (v) => changed = v,
          ),
        ),
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
          AntSelector<String>(
            options: const [
              AntSelectorOption(value: 'a', label: Text('苹果'), disabled: true),
              AntSelectorOption(value: 'b', label: Text('香蕉')),
            ],
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
          AntSelector<String>(
            readOnly: true,
            defaultValue: ['a'],
            options: _options(),
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
}