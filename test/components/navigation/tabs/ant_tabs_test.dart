/// AntTabs Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
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

List<AntTabsItem> _sampleItems() => const [
      AntTabsItem(key: '1', label: 'Tab 1', child: Text('Content 1')),
      AntTabsItem(key: '2', label: 'Tab 2', child: Text('Content 2')),
      AntTabsItem(key: '3', label: 'Tab 3', child: Text('Content 3')),
    ];

void main() {
  group('AntTabs — 基础渲染', () {
    testWidgets('renders all tab labels', (tester) async {
      await tester.pumpWidget(_wrap(AntTabs(items: _sampleItems())));
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('empty items renders SizedBox.shrink', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabs()));
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byType(SizedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows first tab content by default', (tester) async {
      await tester.pumpWidget(_wrap(AntTabs(items: _sampleItems())));
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
      expect(find.text('Content 3'), findsNothing);
    });

    testWidgets('defaultActiveKey sets initial active', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(defaultActiveKey: '2', items: _sampleItems())),
      );
      expect(find.text('Content 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('activeKey controlled mode', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(activeKey: '3', items: _sampleItems())),
      );
      expect(find.text('Content 3'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });
  });

  group('AntTabs — 切换行为', () {
    testWidgets('onChange fires on tab click', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        _wrap(AntTabs(
          items: _sampleItems(),
          onChange: (key) => changedKey = key,
        ),),
      );
      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(changedKey, '2');
    });

    testWidgets('uncontrolled mode switches content', (tester) async {
      await tester.pumpWidget(_wrap(AntTabs(items: _sampleItems())));
      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(find.text('Content 3'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('controlled mode does not switch internally', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(activeKey: '1', items: _sampleItems())),
      );
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      // 受控模式下内部状态不改变
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('disabled tab cannot be clicked', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        _wrap(AntTabs(
          items: const [
            AntTabsItem(key: '1', label: 'Tab 1', child: Text('C1')),
            AntTabsItem(
              key: '2',
              label: 'Tab 2',
              child: Text('C2'),
              disabled: true,
            ),
          ],
          onChange: (key) => changedKey = key,
        ),),
      );
      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(changedKey, isNull);
      expect(find.text('C1'), findsOneWidget);
    });
  });

  group('AntTabs — 类型与样式', () {
    testWidgets('line type renders indicator for active tab', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(type: AntTabsType.line, items: _sampleItems())),
      );
      // 活动标签应该有 AnimatedContainer 指示条
      final indicators = find.descendant(
        of: find.byType(AntTabs),
        matching: find.byType(AnimatedContainer),
      );
      expect(indicators, findsWidgets);
    });

    testWidgets('card type content has border', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(type: AntTabsType.card, items: _sampleItems())),
      );
      // card 类型的内容区域有 Container + BoxDecoration
      final containers = find.descendant(
        of: find.byType(AntTabs),
        matching: find.byType(Container),
      );
      expect(containers, findsWidgets);
    });

    testWidgets('editableCard shows add button', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: _sampleItems(),
          onEdit: (_, __) {},
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.add),
        ),
        findsOneWidget,
      );
    });

    testWidgets('editableCard shows close buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: _sampleItems(),
          onEdit: (_, __) {},
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.close),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('closable false hides close button', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: const [
            AntTabsItem(key: '1', label: 'T1', child: Text('C1'), closable: false),
            AntTabsItem(key: '2', label: 'T2', child: Text('C2')),
          ],
          onEdit: (_, __) {},
        ),),
      );
      // 只有第二项显示关闭按钮
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.close),
        ),
        findsOneWidget,
      );
    });

    testWidgets('no add button when onEdit is null', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(type: AntTabsType.editableCard, items: _sampleItems())),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.add),
        ),
        findsNothing,
      );
    });
  });

  group('AntTabs — 编辑回调', () {
    testWidgets('onEdit remove fires on close click', (tester) async {
      String? removedKey;
      AntTabsEditAction? action;
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: _sampleItems(),
          onEdit: (key, act) {
            removedKey = key;
            action = act;
          },
        ),),
      );
      // 点击第一个关闭按钮
      final closeButtons = find.descendant(
        of: find.byType(AntTabs),
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(closeButtons.first);
      await tester.pump();
      expect(removedKey, '1');
      expect(action, AntTabsEditAction.remove);
    });

    testWidgets('onEdit add fires on add click', (tester) async {
      AntTabsEditAction? action;
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: _sampleItems(),
          onEdit: (_, act) => action = act,
        ),),
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(action, AntTabsEditAction.add);
    });
  });

  group('AntTabs — 位置与尺寸', () {
    testWidgets('tabPosition bottom renders tabs below content',
        (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          tabPosition: AntTabPosition.bottom,
          items: _sampleItems(),
        ),),
      );
      // 内容区域应该在标签栏上方
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dy, lessThan(tabBarCenter.dy));
    });

    testWidgets('tabPosition left renders tabs on left', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          tabPosition: AntTabPosition.left,
          items: _sampleItems(),
        ),),
      );
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dx, greaterThan(tabBarCenter.dx));
    });

    testWidgets('tabPosition right renders tabs on right', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          tabPosition: AntTabPosition.right,
          items: _sampleItems(),
        ),),
      );
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dx, lessThan(tabBarCenter.dx));
    });

    testWidgets('size small uses smaller tab height', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(size: AntTabsSize.small, items: _sampleItems())),
      );
      final tabGesture = find.ancestor(
        of: find.text('Tab 1'),
        matching: find.byType(GestureDetector),
      ).first;
      expect(tester.getSize(tabGesture).height, 32);
    });

    testWidgets('size large uses larger tab height', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(size: AntTabsSize.large, items: _sampleItems())),
      );
      final tabGesture = find.ancestor(
        of: find.text('Tab 1'),
        matching: find.byType(GestureDetector),
      ).first;
      expect(tester.getSize(tabGesture).height, 48);
    });
  });

  group('AntTabs — 自定义', () {
    testWidgets('labelWidget overrides label text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntTabs(
          items: [
            AntTabsItem(
              key: '1',
              label: 'Text Label',
              labelWidget: Text('Custom Label'),
              child: Text('C1'),
            ),
          ],
        ),),
      );
      expect(find.text('Custom Label'), findsOneWidget);
      expect(find.text('Text Label'), findsNothing);
    });

    testWidgets('icon renders in tab', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntTabs(
          items: [
            AntTabsItem(
              key: '1',
              label: 'Tab 1',
              icon: Icon(Icons.star),
              child: Text('C1'),
            ),
          ],
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.star),
        ),
        findsOneWidget,
      );
    });

    testWidgets('centered centers tabs', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(centered: true, items: _sampleItems())),
      );
      // centered 时 Row 使用 MainAxisAlignment.center
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byType(Row),
        ).first,
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('tabBarGutter adds spacing between tabs', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          tabBarGutter: 20,
          items: _sampleItems(),
        ),),
      );
      final tab1Center = tester.getCenter(find.text('Tab 1'));
      final tab2Center = tester.getCenter(find.text('Tab 2'));
      expect(tab2Center.dx - tab1Center.dx, greaterThan(20));
    });

    testWidgets('addIcon custom widget', (tester) async {
      await tester.pumpWidget(
        _wrap(AntTabs(
          type: AntTabsType.editableCard,
          items: _sampleItems(),
          addIcon: const Icon(Icons.add_circle),
          onEdit: (_, __) {},
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs),
          matching: find.byIcon(Icons.add_circle),
        ),
        findsOneWidget,
      );
    });
  });
}