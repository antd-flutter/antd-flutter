import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/src/tree/ant_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型：组件不要求实现任何接口。
class _Region {
  const _Region(
    this.id,
    this.name, {
    this.children = const <_Region>[],
    this.disabled = false,
    this.checkable = true,
  });

  final int id;
  final String name;
  final List<_Region> children;
  final bool disabled;
  final bool checkable;
}

const _treeData = <_Region>[
  _Region(
    1,
    '浙江',
    children: [
      _Region(
        2,
        '杭州',
        children: [_Region(3, '西湖')],
      ),
      _Region(4, '宁波'),
    ],
  ),
  _Region(
    5,
    '江苏',
    children: [
      _Region(6, '南京'),
      _Region(7, '苏州'),
    ],
  ),
];

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: SingleChildScrollView(
          child: Material(child: child),
        ),
      ),
    ),
  );
}

Future<void> _pumpTree(
  WidgetTester tester, {
  List<_Region> dataSource = _treeData,
  bool checkable = false,
  bool checkStrictly = false,
  bool showLine = false,
  Set<Object>? defaultExpandedKeys,
  bool defaultExpandAll = false,
  Set<Object>? defaultSelectedKeys,
  Set<Object>? defaultCheckedKeys,
  bool selectable = true,
  ValueChanged<Set<Object>>? onExpand,
  ValueChanged<Set<Object>>? onSelect,
  AntTreeOnCheck? onCheck,
  Set<Object>? expandedKeys,
  Set<Object>? selectedKeys,
  Set<Object>? checkedKeys,
}) async {
  await tester.pumpWidget(
    _wrap(
      AntTree<_Region>(
        dataSource: dataSource,
        keyOf: (region) => region.id,
        titleBuilder: (context, region) => Text(region.name),
        childrenOf: (region) => region.children,
        disabledOf: (region) => region.disabled,
        checkableOf: (region) => region.checkable,
        checkable: checkable,
        checkStrictly: checkStrictly,
        showLine: showLine,
        defaultExpandedKeys: defaultExpandedKeys,
        defaultExpandAll: defaultExpandAll,
        defaultSelectedKeys: defaultSelectedKeys,
        defaultCheckedKeys: defaultCheckedKeys,
        selectable: selectable,
        expandedKeys: expandedKeys,
        selectedKeys: selectedKeys,
        checkedKeys: checkedKeys,
        onExpand: onExpand,
        onSelect: onSelect,
        onCheck: onCheck,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _rowOf(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(Row)).first;

Future<void> _tapSwitcher(WidgetTester tester, String title) async {
  final row = _rowOf(title);
  final icon = find.descendant(
    of: row,
    matching: find.byIcon(AntIcons.downOutlined),
  );
  expect(icon, findsOneWidget);
  await tester.tap(icon);
  await tester.pumpAndSettle();
}

void main() {
  group('AntTree 自定义模型', () {
    testWidgets('renders multi-level tree collapsed by default',
        (tester) async {
      await _pumpTree(tester);
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('江苏'), findsOneWidget);
      expect(find.text('杭州'), findsNothing);
      expect(find.text('南京'), findsNothing);
    });

    testWidgets('defaultExpandedKeys renders children', (tester) async {
      await _pumpTree(tester, defaultExpandedKeys: {1});
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
      expect(find.text('西湖'), findsNothing);
    });

    testWidgets('defaultExpandAll renders all nodes', (tester) async {
      await _pumpTree(tester, defaultExpandAll: true);
      expect(find.text('西湖'), findsOneWidget);
      expect(find.text('南京'), findsOneWidget);
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('tap switcher expands then collapses', (tester) async {
      await _pumpTree(tester);
      await _tapSwitcher(tester, '浙江');
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);

      final row = _rowOf('浙江');
      await tester.tap(
        find.descendant(
          of: row,
          matching: find.byIcon(AntIcons.downOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsNothing);
    });

    testWidgets('controlled expandedKeys shows children', (tester) async {
      await _pumpTree(tester, expandedKeys: {5});
      expect(find.text('南京'), findsOneWidget);
      expect(find.text('杭州'), findsNothing);
    });

    testWidgets('onExpand fires with updated keys', (tester) async {
      Set<Object>? expanded;
      await _pumpTree(
        tester,
        onExpand: (keys) => expanded = keys,
      );
      await _tapSwitcher(tester, '江苏');
      expect(expanded, contains(5));
    });

    testWidgets('selectable: tap title selects and toggles', (tester) async {
      final selected = <Set<Object>>[];
      await _pumpTree(
        tester,
        defaultExpandedKeys: {1},
        onSelect: selected.add,
      );
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      expect(selected.last, {2});

      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('selectable false ignores tap', (tester) async {
      Set<Object>? selected;
      await _pumpTree(
        tester,
        selectable: false,
        onSelect: (keys) => selected = keys,
      );
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      expect(selected, isNull);
    });

    testWidgets('controlled selectedKeys highlights node', (tester) async {
      await _pumpTree(
        tester,
        defaultExpandedKeys: {1},
        selectedKeys: {2},
      );
      final containers = tester.widgetList<Container>(
        find.ancestor(
          of: find.text('杭州'),
          matching: find.byType(Container),
        ),
      );
      expect(
        containers.any((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration &&
              decoration.color == AntThemeData.light().colorPrimaryBg;
        }),
        isTrue,
      );
    });

    testWidgets('checkable renders checkboxes', (tester) async {
      await _pumpTree(tester, checkable: true, defaultExpandedKeys: {1});
      expect(
        find.byIcon(AntIcons.borderOutlined),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('checking parent checks all descendants', (tester) async {
      final checked = <Set<Object>>[];
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: {5},
        onCheck: (keys, _) => checked.add(keys),
      );
      await tester.tap(
        find.descendant(
          of: _rowOf('江苏'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(checked.last, containsAll(<Object>[5, 6, 7]));
      expect(find.byIcon(AntIcons.checkSquareOutlined), findsNWidgets(3));
    });

    testWidgets('checking all children checks parent', (tester) async {
      final checked = <Set<Object>>[];
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: {5},
        onCheck: (keys, _) => checked.add(keys),
      );
      await tester.tap(
        find.descendant(
          of: _rowOf('南京'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: _rowOf('苏州'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(checked.last, containsAll(<Object>[6, 7, 5]));
    });

    testWidgets('half-checked state shows when partially checked', (
      tester,
    ) async {
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: {5},
      );
      await tester.tap(
        find.descendant(
          of: _rowOf('南京'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.minusSquareFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.checkSquareOutlined), findsOneWidget);
    });

    testWidgets('checkStrictly does not cascade', (tester) async {
      final checked = <Set<Object>>[];
      await _pumpTree(
        tester,
        checkable: true,
        checkStrictly: true,
        defaultExpandedKeys: {5},
        onCheck: (keys, _) => checked.add(keys),
      );
      await tester.tap(
        find.descendant(
          of: _rowOf('南京'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(checked.last, {6});
      expect(checked.last, isNot(contains(5)));
    });

    testWidgets('disabled node cannot select or check', (tester) async {
      final data = <_Region>[
        const _Region(
          10,
          '禁用节点',
          disabled: true,
          children: [_Region(11, '子节点')],
        ),
      ];
      Set<Object>? selected;
      Set<Object>? checked;
      await _pumpTree(
        tester,
        dataSource: data,
        checkable: true,
        defaultExpandedKeys: {10},
        onSelect: (keys) => selected = keys,
        onCheck: (keys, _) => checked = keys,
      );

      await tester.tap(find.text('禁用节点'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: _rowOf('禁用节点'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(selected, isNull);
      expect(checked, isNull);
    });

    testWidgets('showLine renders guide lines', (tester) async {
      await _pumpTree(tester, showLine: true, defaultExpandAll: true);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.color != null &&
              widget.alignment == null &&
              widget.decoration == null,
        ),
        findsWidgets,
      );
    });

    testWidgets('defaultCheckedKeys renders checked state', (tester) async {
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: {5},
        defaultCheckedKeys: {6, 7},
      );
      expect(find.byIcon(AntIcons.checkSquareOutlined), findsNWidgets(3));
    });

    testWidgets('自定义模型：childrenOf 驱动多级树', (tester) async {
      await _pumpTree(tester, defaultExpandAll: true);
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('西湖'), findsOneWidget);
      expect(find.text('江苏'), findsOneWidget);
      expect(find.text('南京'), findsOneWidget);
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('自定义模型：disabledOf / checkableOf 控制交互', (tester) async {
      final data = <_Region>[
        const _Region(20, '锁定节点', disabled: true),
        const _Region(21, '不可勾选', checkable: false),
        const _Region(22, '可勾选'),
      ];
      Set<Object>? selected;
      Set<Object>? checked;
      await _pumpTree(
        tester,
        dataSource: data,
        checkable: true,
        onSelect: (keys) => selected = keys,
        onCheck: (keys, _) => checked = keys,
      );

      await tester.tap(find.text('锁定节点'));
      await tester.pumpAndSettle();
      expect(selected, isNull);

      expect(
        find.descendant(
          of: _rowOf('不可勾选'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
        findsNothing,
      );

      await tester.tap(
        find.descendant(
          of: _rowOf('可勾选'),
          matching: find.byIcon(AntIcons.borderOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(checked, {22});
    });
  });
}
