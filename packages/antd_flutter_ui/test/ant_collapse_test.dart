import 'package:antd_flutter_ui/src/display/collapse/ant_collapse.dart';
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

List<AntCollapsePanel> _panels() => const [
      AntCollapsePanel(label: '面板一', child: Text('内容一')),
      AntCollapsePanel(label: '面板二', child: Text('内容二')),
      AntCollapsePanel(label: '面板三', child: Text('内容三')),
    ];

void main() {
  group('AntCollapse', () {
    testWidgets('basic rendering shows all labels and no content', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(items: _panels())));
      expect(find.text('面板一'), findsOneWidget);
      expect(find.text('面板二'), findsOneWidget);
      expect(find.text('面板三'), findsOneWidget);
      expect(find.text('内容一'), findsNothing);
    });

    testWidgets('tap expands content', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(items: _panels())));
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
    });

    testWidgets('tap again collapses content', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(_wrap(AntCollapse(
        key: collapseKey,
        items: _panels(),
      ),),);
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      final expanded = tester.getSize(find.byKey(collapseKey)).height;
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      final collapsed = tester.getSize(find.byKey(collapseKey)).height;
      expect(collapsed, lessThan(expanded));
    });

    testWidgets('accordion allows only one open panel', (tester) async {
      await tester.pumpWidget(
        _wrap(AntCollapse(items: _panels(), accordion: true)),
      );
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('面板二'));
      await tester.pumpAndSettle();
      final aligns = tester
          .widgetList<Align>(
            find.descendant(
              of: find.byType(AntCollapse),
              matching: find.byType(Align),
            ),
          )
          .toList();
      final openCount = aligns
          .where((a) => a.heightFactor != null && a.heightFactor! > 0)
          .length;
      expect(openCount, 1);
      expect(find.text('内容二'), findsOneWidget);
    });

    testWidgets('defaultActiveKey opens multiple panels', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(
        items: _panels(),
        defaultActiveKey: const ['panel_0', 'panel_1'],
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
      expect(find.text('内容二'), findsOneWidget);
    });

    testWidgets('controlled activeKey overrides taps', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(
        items: _panels(),
        activeKey: const ['panel_0'],
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
      // 受控模式下点击面板二不会展开
      await tester.tap(find.text('面板二'));
      await tester.pumpAndSettle();
      expect(find.text('内容二'), findsNothing);
    });

    testWidgets('onChange fires with expanded keys', (tester) async {
      final changes = <List<String>>[];
      await tester.pumpWidget(_wrap(AntCollapse(
        items: _panels(),
        onChange: changes.add,
      ),),);
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      expect(changes, hasLength(1));
      expect(changes.first, contains('panel_0'));
    });

    testWidgets('disabled panel does not expand', (tester) async {
      await tester.pumpWidget(_wrap(const AntCollapse(items: [
        AntCollapsePanel(label: '禁用面板', child: Text('内容'), disabled: true),
      ],),),);
      await tester.tap(find.text('禁用面板'));
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsNothing);
    });

    testWidgets('extra widget renders in header', (tester) async {
      await tester.pumpWidget(_wrap(const AntCollapse(items: [
        AntCollapsePanel(label: '带extra', extra: Text('附加'), child: Text('内容')),
      ],),),);
      expect(find.text('附加'), findsOneWidget);
    });

    testWidgets('expandIconPosition right places icon at end', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(
        items: _panels(),
        expandIconPosition: AntCollapseExpandIconPosition.right,
      ),),);
      final row = tester.widget<Row>(
        find.ancestor(of: find.text('面板一'), matching: find.byType(Row)).first,
      );
      expect(row.children.last, isA<AnimatedRotation>());
    });

    testWidgets('custom expandIcon is used', (tester) async {
      await tester.pumpWidget(_wrap(AntCollapse(
        items: _panels(),
        expandIcon: (context, isExpanded) => const Icon(Icons.star),
      ),),);
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('borderless variant has no outer border', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(_wrap(AntCollapse(
        key: collapseKey,
        items: _panels(),
        bordered: false,
      ),),);
      final decorated = tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byKey(collapseKey),
              matching: find.byType(DecoratedBox),
            ).first,
          );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('expanded panel height greater than collapsed', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(_wrap(AntCollapse(
        key: collapseKey,
        items: _panels(),
      ),),);
      final before = tester.getSize(find.byKey(collapseKey)).height;
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      final after = tester.getSize(find.byKey(collapseKey)).height;
      expect(after, greaterThan(before));
    });
  });
}
