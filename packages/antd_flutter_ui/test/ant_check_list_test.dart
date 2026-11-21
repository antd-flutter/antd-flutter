/// AntCheckList widget 测试
library;

import 'package:antd_flutter_ui/src/data_entry/check_list/ant_check_list.dart';
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

List<AntCheckListItem<String>> _items() => const [
      AntCheckListItem(value: 'a', child: Text('苹果')),
      AntCheckListItem(value: 'b', child: Text('香蕉')),
      AntCheckListItem(value: 'c', child: Text('橙子')),
    ];

void main() {
  group('AntCheckList — rendering', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(_wrap(AntCheckList<String>(items: _items())));
      await tester.pumpAndSettle();

      expect(find.text('苹果'), findsOneWidget);
      expect(find.text('香蕉'), findsOneWidget);
      expect(find.text('橙子'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckList<String>(
            items: [
              AntCheckListItem(
                value: 'a',
                child: Text('苹果'),
                description: Text('红色水果'),
              ),
            ],
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
          const AntCheckList<String>(
            items: [
              AntCheckListItem(
                value: 'a',
                child: Text('苹果'),
                prefix: Icon(Icons.apple),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.apple), findsOneWidget);
    });

    testWidgets('hideCheckMark — no check icon shown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            showCheckMark: false,
            defaultValue: ['a'],
            items: _items(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('custom activeIcon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            activeIcon: const Icon(Icons.star),
            defaultValue: ['a'],
            items: _items(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('AntCheckList — single selection', () {
    testWidgets('defaultValue shows check mark', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(defaultValue: ['b'], items: _items()),
        ),
      );
      await tester.pumpAndSettle();

      // only 'b' row has check icon
      final bRow = find.ancestor(
        of: find.text('香蕉'),
        matching: find.byType(Row),
      );
      expect(
        find.descendant(of: bRow, matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
    });

    testWidgets('tap selects item and fires onChange', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, ['a']);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('tap another item switches selection', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            defaultValue: ['a'],
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, ['b']);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('tap selected item clears selection', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            defaultValue: ['a'],
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('苹果'));
      await tester.pumpAndSettle();

      expect(changed, isEmpty);
      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  group('AntCheckList — multiple selection', () {
    testWidgets('tap selects multiple items', (tester) async {
      List<List<String>> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            multiple: true,
            items: _items(),
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
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('tap again deselects', (tester) async {
      List<List<String>> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            multiple: true,
            defaultValue: ['a', 'b'],
            items: _items(),
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
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('AntCheckList — controlled', () {
    testWidgets('value prop controls selection', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(value: ['b', 'c'], items: _items()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('internal state not changed when controlled', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            value: ['a'],
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      // callback fires but UI stays controlled
      expect(changed, ['b']);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('AntCheckList — disabled & readOnly', () {
    testWidgets('disabled list does not respond to taps', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            disabled: true,
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
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
          AntCheckList<String>(
            items: const [
              AntCheckListItem(value: 'a', child: Text('苹果'), disabled: true),
              AntCheckListItem(value: 'b', child: Text('香蕉')),
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

    testWidgets('readOnly list does not respond to taps', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckList<String>(
            readOnly: true,
            defaultValue: ['a'],
            items: _items(),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}