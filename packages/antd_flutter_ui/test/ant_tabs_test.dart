/// AntTabs Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// 测试用用户模型（演示泛型数据源 + builder 写法）。
class _TabData {
  const _TabData({
    required this.key,
    this.label,
    this.labelWidget,
    this.child,
    this.icon,
    this.disabled = false,
    this.closable,
  });

  final String key;
  final String? label;
  final Widget? labelWidget;
  final Widget? child;
  final Widget? icon;
  final bool disabled;
  final bool? closable;
}

Widget _tabs({
  Key? key,
  required List<_TabData> items,
  Object? activeKey,
  Object? defaultActiveKey,
  AntTabsType type = AntTabsType.line,
  AntTabsSize size = AntTabsSize.normal,
  AntTabPosition tabPosition = AntTabPosition.top,
  bool centered = false,
  double? tabBarGutter,
  Widget? addIcon,
  ValueChanged<_TabData>? onChange,
  void Function(_TabData? item, AntTabsEditAction action)? onEdit,
}) {
  return AntTabs<_TabData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    labelBuilder: (context, item, index) =>
        item.labelWidget ?? Text(item.label ?? item.key),
    childBuilder: (context, item, index) =>
        item.child ?? const SizedBox.shrink(),
    iconBuilder: (context, item) => item.icon,
    disabledOf: (item) => item.disabled,
    closableOf: (item) => item.closable ?? type == AntTabsType.editableCard,
    type: type,
    size: size,
    tabPosition: tabPosition,
    centered: centered,
    tabBarGutter: tabBarGutter,
    addIcon: addIcon,
    onChange: onChange,
    onEdit: onEdit,
  );
}

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

List<_TabData> _sampleItems() => const [
      _TabData(key: '1', label: 'Tab 1', child: Text('Content 1')),
      _TabData(key: '2', label: 'Tab 2', child: Text('Content 2')),
      _TabData(key: '3', label: 'Tab 3', child: Text('Content 3')),
    ];

void main() {
  group('AntTabs — 基础渲染', () {
    testWidgets('renders all tab labels', (tester) async {
      await tester.pumpWidget(_wrap(_tabs(items: _sampleItems())));
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('empty items renders SizedBox.shrink', (tester) async {
      await tester.pumpWidget(_wrap(_tabs(items: const [])));
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byType(SizedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows first tab content by default', (tester) async {
      await tester.pumpWidget(_wrap(_tabs(items: _sampleItems())));
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
      expect(find.text('Content 3'), findsNothing);
    });

    testWidgets('defaultActiveKey sets initial active', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(defaultActiveKey: '2', items: _sampleItems())),
      );
      expect(find.text('Content 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('activeKey controlled mode', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(activeKey: '3', items: _sampleItems())),
      );
      expect(find.text('Content 3'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });
  });

  group('AntTabs — 切换行为', () {
    testWidgets('onChange fires on tab click', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        _wrap(
          _tabs(
            items: _sampleItems(),
            onChange: (key) => changedKey = key.key,
          ),
        ),
      );
      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(changedKey, '2');
    });

    testWidgets('uncontrolled mode switches content', (tester) async {
      await tester.pumpWidget(_wrap(_tabs(items: _sampleItems())));
      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(find.text('Content 3'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('controlled mode does not switch internally', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(activeKey: '1', items: _sampleItems())),
      );
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      // 受控模式下内部状态不改变
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('disabled tab cannot be clicked', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        _wrap(
          _tabs(
            items: const [
              _TabData(key: '1', label: 'Tab 1', child: Text('C1')),
              _TabData(
                key: '2',
                label: 'Tab 2',
                child: Text('C2'),
                disabled: true,
              ),
            ],
            onChange: (key) => changedKey = key.key,
          ),
        ),
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
        _wrap(_tabs(type: AntTabsType.line, items: _sampleItems())),
      );
      // 活动标签应该有 AnimatedContainer 指示条
      final indicators = find.descendant(
        of: find.byType(AntTabs<_TabData>),
        matching: find.byType(AnimatedContainer),
      );
      expect(indicators, findsWidgets);
    });

    testWidgets('line indicator slides to active tab (single moving underline)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(type: AntTabsType.line, items: _sampleItems())),
      );
      await tester.pumpAndSettle();

      final indicatorFinder = find.descendant(
        of: find.byType(AntTabs<_TabData>),
        matching: find.byType(AnimatedPositioned),
      );
      expect(indicatorFinder, findsOneWidget);

      final before = tester.getRect(indicatorFinder);
      expect(before.width, greaterThan(0));
      expect(before.left, greaterThanOrEqualTo(0));

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      final after = tester.getRect(indicatorFinder);
      // 指示条跟随激活项向右移动，且仍只有一条
      expect(after.left, greaterThan(before.left));
      expect(indicatorFinder, findsOneWidget);
    });

    testWidgets('switching line tab keeps label vertical position stable',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(type: AntTabsType.line, items: _sampleItems())),
      );
      await tester.pumpAndSettle();

      final before = tester.getCenter(find.text('Tab 2'));
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      final after = tester.getCenter(find.text('Tab 2'));

      // 选中态只变色 + 指示条滑动，文字不应上移/抖动
      expect((after.dy - before.dy).abs(), lessThan(0.5));
    });

    testWidgets('card type renders bordered tabs with 2px gutter',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(type: AntTabsType.card, items: _sampleItems())),
      );
      final first = tester.getRect(
        find
            .ancestor(of: find.text('Tab 1'), matching: find.byType(Container))
            .first,
      );
      final second = tester.getRect(
        find
            .ancestor(of: find.text('Tab 2'), matching: find.byType(Container))
            .first,
      );
      // antd cardGutter = marginXXS / 2 = 2
      expect(second.left - first.right, closeTo(2, 0.01));
      final decoration = tester
          .widgetList<Container>(
            find.ancestor(
              of: find.text('Tab 1'),
              matching: find.byType(Container),
            ),
          )
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      expect(decoration.color, isNotNull);
    });

    testWidgets('outlined type renders one outer frame with segmented tabs',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(type: AntTabsType.outlined, items: _sampleItems())),
      );
      // 整组一枚外框
      final outer = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AntTabs<_TabData>),
              matching: find.byType(Container),
            ),
          )
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .where(
            (d) =>
                d.border != null &&
                d.border!.top.color == const Color(0xFFD9D9D9),
          )
          .toList();
      expect(outer, isNotEmpty);

      // 选中段：主色描边
      final active = tester
          .widgetList<Container>(
            find.ancestor(
              of: find.text('Tab 1'),
              matching: find.byType(Container),
            ),
          )
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .firstWhere(
            (d) =>
                d.border != null &&
                d.border!.top.color == const Color(0xFF1677FF),
          );
      expect(active.borderRadius, BorderRadius.circular(6));

      // 非选中段之间由 1px 分隔线切分
      final first = tester.getRect(
        find
            .ancestor(of: find.text('Tab 1'), matching: find.byType(Container))
            .first,
      );
      final second = tester.getRect(
        find
            .ancestor(of: find.text('Tab 2'), matching: find.byType(Container))
            .first,
      );
      expect(second.left, closeTo(first.right, 0.01));

      // 高度 32
      expect(first.height, closeTo(32, 0.01));
    });

    testWidgets('editableCard shows add button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: _sampleItems(),
            onEdit: (_, __) {},
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.plusOutlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('editableCard shows close buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: _sampleItems(),
            onEdit: (_, __) {},
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.closeOutlined),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('closable false hides close button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: const [
              _TabData(
                key: '1',
                label: 'T1',
                child: Text('C1'),
                closable: false,
              ),
              _TabData(key: '2', label: 'T2', child: Text('C2')),
            ],
            onEdit: (_, __) {},
          ),
        ),
      );
      // 只有第二项显示关闭按钮
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.closeOutlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('no add button when onEdit is null', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(type: AntTabsType.editableCard, items: _sampleItems())),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.plusOutlined),
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
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: _sampleItems(),
            onEdit: (key, act) {
              removedKey = key?.key;
              action = act;
            },
          ),
        ),
      );
      // 点击第一个关闭按钮
      final closeButtons = find.descendant(
        of: find.byType(AntTabs<_TabData>),
        matching: find.byIcon(AntIcons.closeOutlined),
      );
      await tester.tap(closeButtons.first);
      await tester.pump();
      expect(removedKey, '1');
      expect(action, AntTabsEditAction.remove);
    });

    testWidgets('onEdit add fires on add click', (tester) async {
      AntTabsEditAction? action;
      await tester.pumpWidget(
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: _sampleItems(),
            onEdit: (_, act) => action = act,
          ),
        ),
      );
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pump();
      expect(action, AntTabsEditAction.add);
    });
  });

  group('AntTabs — 位置与尺寸', () {
    testWidgets('tabPosition bottom renders tabs below content',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            tabPosition: AntTabPosition.bottom,
            items: _sampleItems(),
          ),
        ),
      );
      // 内容区域应该在标签栏上方
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dy, lessThan(tabBarCenter.dy));
    });

    testWidgets('tabPosition left renders tabs on left', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            tabPosition: AntTabPosition.left,
            items: _sampleItems(),
          ),
        ),
      );
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dx, greaterThan(tabBarCenter.dx));
    });

    testWidgets('tabPosition right renders tabs on right', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            tabPosition: AntTabPosition.right,
            items: _sampleItems(),
          ),
        ),
      );
      final contentCenter = tester.getCenter(find.text('Content 1'));
      final tabBarCenter = tester.getCenter(find.text('Tab 1'));
      expect(contentCenter.dx, lessThan(tabBarCenter.dx));
    });

    testWidgets('size small uses smaller tab height', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(size: AntTabsSize.small, items: _sampleItems())),
      );
      final tabGesture = find
          .ancestor(
            of: find.text('Tab 1'),
            matching: find.byType(GestureDetector),
          )
          .first;
      expect(tester.getSize(tabGesture).height, 32);
    });

    testWidgets('size large uses larger tab height', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(size: AntTabsSize.large, items: _sampleItems())),
      );
      final tabGesture = find
          .ancestor(
            of: find.text('Tab 1'),
            matching: find.byType(GestureDetector),
          )
          .first;
      expect(tester.getSize(tabGesture).height, 48);
    });
  });

  group('AntTabs — 自定义', () {
    testWidgets('labelWidget overrides label text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            items: [
              const _TabData(
                key: '1',
                label: 'Text Label',
                labelWidget: Text('Custom Label'),
                child: Text('C1'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('Custom Label'), findsOneWidget);
      expect(find.text('Text Label'), findsNothing);
    });

    testWidgets('icon renders in tab', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            items: [
              const _TabData(
                key: '1',
                label: 'Tab 1',
                icon: Icon(AntIcons.starFilled),
                child: Text('C1'),
              ),
            ],
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.starFilled),
        ),
        findsOneWidget,
      );
    });

    testWidgets('centered centers tabs', (tester) async {
      await tester.pumpWidget(
        _wrap(_tabs(centered: true, items: _sampleItems())),
      );
      // centered 时 Row 使用 MainAxisAlignment.center
      final row = tester.widget<Row>(
        find
            .descendant(
              of: find.byType(AntTabs<_TabData>),
              matching: find.byType(Row),
            )
            .first,
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('tabBarGutter adds spacing between tabs', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            tabBarGutter: 20,
            items: _sampleItems(),
          ),
        ),
      );
      final tab1Center = tester.getCenter(find.text('Tab 1'));
      final tab2Center = tester.getCenter(find.text('Tab 2'));
      expect(tab2Center.dx - tab1Center.dx, greaterThan(20));
    });

    testWidgets('addIcon custom widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabs(
            type: AntTabsType.editableCard,
            items: _sampleItems(),
            addIcon: const Icon(AntIcons.plusCircleOutlined),
            onEdit: (_, __) {},
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntTabs<_TabData>),
          matching: find.byIcon(AntIcons.plusCircleOutlined),
        ),
        findsOneWidget,
      );
    });
  });
  group('AntTabs — 无界容器回归（P09 bug 修复）', () {
    testWidgets('horizontal tabs in SingleChildScrollView does not crash',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: Column(
              children: [
                _tabs(items: _sampleItems()),
                const Text('after'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('after'), findsOneWidget);
    });

    testWidgets('vertical tabs in SingleChildScrollView does not crash',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: Column(
              children: [
                _tabs(
                  tabPosition: AntTabPosition.left,
                  items: _sampleItems(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Tab 1'), findsOneWidget);
    });
  });
}
