import 'package:antd_flutter_ui/src/display/collapse/ant_collapse.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

class _PanelData {
  const _PanelData({
    required this.label,
    this.child,
    this.extra,
    this.disabled = false,
  });

  final String label;
  final Widget? child;
  final Widget? extra;
  final bool disabled;
}

Widget _collapse({
  Key? key,
  required List<_PanelData> items,
  bool accordion = false,
  List<Object>? activeKey,
  List<Object>? defaultActiveKey,
  ValueChanged<List<Object>>? onChange,
  AntCollapseExpandIconPosition expandIconPosition =
      AntCollapseExpandIconPosition.left,
  bool bordered = true,
  AntCollapseSize size = AntCollapseSize.middle,
  Widget Function(BuildContext, bool)? expandIcon,
}) {
  return AntCollapse<_PanelData>(
    key: key,
    items: items,
    keyOf: (item) => 'panel_${items.indexOf(item)}',
    labelBuilder: (context, item, index) => Text(item.label),
    childBuilder: (context, item, index) => item.child,
    extraBuilder: (context, item, index) => item.extra,
    disabledOf: (item) => item.disabled,
    accordion: accordion,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
    expandIconPosition: expandIconPosition,
    bordered: bordered,
    size: size,
    expandIcon: expandIcon,
  );
}

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

List<_PanelData> _panels() => const [
      _PanelData(label: '面板一', child: Text('内容一')),
      _PanelData(label: '面板二', child: Text('内容二')),
      _PanelData(label: '面板三', child: Text('内容三')),
    ];

void main() {
  group('AntCollapse', () {
    testWidgets('basic rendering shows all labels and no content',
        (tester) async {
      await tester.pumpWidget(_wrap(_collapse(items: _panels())));
      expect(find.text('面板一'), findsOneWidget);
      expect(find.text('面板二'), findsOneWidget);
      expect(find.text('面板三'), findsOneWidget);
      expect(find.text('内容一'), findsNothing);
    });

    testWidgets('tap expands content', (tester) async {
      await tester.pumpWidget(_wrap(_collapse(items: _panels())));
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
    });

    testWidgets('tap again collapses content', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(
        _wrap(
          _collapse(
            key: collapseKey,
            items: _panels(),
          ),
        ),
      );
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
        _wrap(_collapse(items: _panels(), accordion: true)),
      );
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('面板二'));
      await tester.pumpAndSettle();
      final aligns = tester
          .widgetList<Align>(
            find.descendant(
              of: find.byType(AntCollapse<_PanelData>),
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
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: _panels(),
            defaultActiveKey: const ['panel_0', 'panel_1'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
      expect(find.text('内容二'), findsOneWidget);
    });

    testWidgets('controlled activeKey overrides taps', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: _panels(),
            activeKey: const ['panel_0'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('内容一'), findsOneWidget);
      // 受控模式下点击面板二不会展开
      await tester.tap(find.text('面板二'));
      await tester.pumpAndSettle();
      expect(find.text('内容二'), findsNothing);
    });

    testWidgets('onChange fires with expanded keys', (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: _panels(),
            onChange: changes.add,
          ),
        ),
      );
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      expect(changes, hasLength(1));
      expect(changes.first, contains('panel_0'));
    });

    testWidgets('disabled panel does not expand', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: [
              const _PanelData(
                label: '禁用面板',
                child: Text('内容'),
                disabled: true,
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('禁用面板'));
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsNothing);
    });

    testWidgets('extra widget renders in header', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: [
              const _PanelData(
                label: '带extra',
                extra: Text('附加'),
                child: Text('内容'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('附加'), findsOneWidget);
    });

    testWidgets('expandIconPosition right places icon at end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: _panels(),
            expandIconPosition: AntCollapseExpandIconPosition.right,
          ),
        ),
      );
      final row = tester.widget<Row>(
        find.ancestor(of: find.text('面板一'), matching: find.byType(Row)).first,
      );
      expect(row.children.last, isA<AnimatedRotation>());
    });

    testWidgets('custom expandIcon is used', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _collapse(
            items: _panels(),
            expandIcon: (context, isExpanded) =>
                const Icon(AntIcons.starFilled),
          ),
        ),
      );
      expect(find.byIcon(AntIcons.starFilled), findsWidgets);
    });

    testWidgets('borderless variant has no outer border', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(
        _wrap(
          _collapse(
            key: collapseKey,
            items: _panels(),
            bordered: false,
          ),
        ),
      );
      final decorated = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byKey(collapseKey),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('expanded panel height greater than collapsed', (tester) async {
      const collapseKey = Key('collapse');
      await tester.pumpWidget(
        _wrap(
          _collapse(
            key: collapseKey,
            items: _panels(),
          ),
        ),
      );
      final before = tester.getSize(find.byKey(collapseKey)).height;
      await tester.tap(find.text('面板一'));
      await tester.pumpAndSettle();
      final after = tester.getSize(find.byKey(collapseKey)).height;
      expect(after, greaterThan(before));
    });

    testWidgets('arrow size is fixed regardless of wide mobile width',
        (tester) async {
      tester.view.physicalSize = const Size(669 * 3, 951 * 3);
      tester.view.devicePixelRatio = 3.0;
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        debugDefaultTargetPlatformOverride = null;
      });

      await tester.pumpWidget(_wrap(_collapse(items: _panels())));
      await tester.pump();

      // 669 逻辑宽下 .w 因子约 1.78；箭头应保持 12px 而非被放大到 ~21px。
      expect(
        tester.getSize(find.byIcon(AntIcons.rightOutlined).first),
        const Size(12, 12),
      );
    });

    testWidgets('arrow size matches desktop on wide desktop window',
        (tester) async {
      tester.view.physicalSize = const Size(1728 * 2, 972 * 2);
      tester.view.devicePixelRatio = 2.0;
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        debugDefaultTargetPlatformOverride = null;
      });

      await tester.pumpWidget(_wrap(_collapse(items: _panels())));
      await tester.pump();

      expect(
        tester.getSize(find.byIcon(AntIcons.rightOutlined).first),
        const Size(12, 12),
      );
    });
  });
}
