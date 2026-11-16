import 'package:antd_flutter_plus/src/components/data_display/tree/ant_tree.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _treeData = [
  AntTreeNode(
    key: 'zj',
    title: '浙江',
    children: [
      AntTreeNode(
        key: 'hz',
        title: '杭州',
        children: [AntTreeNode(key: 'xh', title: '西湖')],
      ),
      AntTreeNode(key: 'nb', title: '宁波'),
    ],
  ),
  AntTreeNode(
    key: 'js',
    title: '江苏',
    children: [
      AntTreeNode(key: 'nj', title: '南京'),
      AntTreeNode(key: 'sz', title: '苏州'),
    ],
  ),
];

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: SingleChildScrollView(
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pumpTree(
  WidgetTester tester, {
  List<AntTreeNode> treeData = _treeData,
  bool checkable = false,
  bool checkStrictly = false,
  bool showLine = false,
  List<String>? defaultExpandedKeys,
  bool defaultExpandAll = false,
  List<String>? defaultSelectedKeys,
  List<String>? defaultCheckedKeys,
  bool selectable = true,
  ValueChanged<List<String>>? onExpand,
  ValueChanged<List<String>>? onSelect,
  void Function(List<String>, List<String>)? onCheck,
}) async {
  await tester.pumpWidget(_wrap(AntTree(
    treeData: treeData,
    checkable: checkable,
    checkStrictly: checkStrictly,
    showLine: showLine,
    defaultExpandedKeys: defaultExpandedKeys,
    defaultExpandAll: defaultExpandAll,
    defaultSelectedKeys: defaultSelectedKeys,
    defaultCheckedKeys: defaultCheckedKeys,
    selectable: selectable,
    onExpand: onExpand,
    onSelect: onSelect,
    onCheck: onCheck,
  ),),);
  await tester.pumpAndSettle();
}

Future<void> _tapSwitcher(WidgetTester tester, String title) async {
  // 找到包含标题的行（Row），再取该行内的展开图标
  final rowElement = tester.element(
    find.ancestor(of: find.text(title), matching: find.byType(Row)).first,
  );
  Icon? switcherIcon;
  void walk(Element element) {
    final widget = element.widget;
    if (widget is Icon && widget.icon == Icons.expand_more) {
      switcherIcon = widget;
      return;
    }
    element.visitChildElements(walk);
  }

  rowElement.visitChildElements(walk);
  expect(switcherIcon, isNotNull, reason: '未找到 $title 的 switcher');
  await tester.tap(find.byWidget(switcherIcon!));
  await tester.pumpAndSettle();
}

void main() {
  group('AntTree', () {
    testWidgets('renders multi-level collapsed by default', (tester) async {
      await _pumpTree(tester);
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('江苏'), findsOneWidget);
      // 未展开时不渲染子项
      expect(find.text('杭州'), findsNothing);
      expect(find.text('南京'), findsNothing);
    });

    testWidgets('defaultExpandedKeys renders children', (tester) async {
      await _pumpTree(tester, defaultExpandedKeys: const ['zj']);
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
      // 二级未展开
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
      expect(find.text('杭州'), findsNothing);
      await _tapSwitcher(tester, '浙江');
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
      await _tapSwitcher(tester, '浙江');
      expect(find.text('杭州'), findsNothing);
    });

    testWidgets('controlled expandedKeys shows children', (tester) async {
      await tester.pumpWidget(_wrap(const AntTree(
        treeData: _treeData,
        expandedKeys: ['js'],
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('南京'), findsOneWidget);
      expect(find.text('杭州'), findsNothing);
    });

    testWidgets('onExpand fires with updated keys', (tester) async {
      List<String>? expanded;
      await _pumpTree(tester, onExpand: (keys) => expanded = keys);
      await _tapSwitcher(tester, '江苏');
      expect(expanded, isNotNull);
      expect(expanded, contains('js'));
    });

    testWidgets('selectable: tap title selects and toggles', (tester) async {
      List<String>? selected;
      await _pumpTree(
        tester,
        defaultExpandedKeys: const ['zj'],
        onSelect: (keys) => selected = keys,
      );
      await tester.tap(find.text('杭州'));
      await tester.pump();
      expect(selected, ['hz']);
      await tester.tap(find.text('杭州'));
      await tester.pump();
      expect(selected, isEmpty);
    });

    testWidgets('selectable false ignores tap', (tester) async {
      var selected = false;
      await _pumpTree(
        tester,
        selectable: false,
        defaultExpandedKeys: const ['zj'],
        onSelect: (_) => selected = true,
      );
      await tester.tap(find.text('杭州'));
      await tester.pump();
      expect(selected, isFalse);
    });

    testWidgets('controlled selectedKeys highlights node', (tester) async {
      await tester.pumpWidget(_wrap(const AntTree(
        treeData: _treeData,
        defaultExpandedKeys: ['zj'],
        selectedKeys: ['hz'],
      ),),);
      await tester.pumpAndSettle();
      final containers = tester.widgetList<Container>(
        find.ancestor(
          of: find.text('杭州'),
          matching: find.byType(Container),
        ),
      );
      final colors = containers
          .map((c) => (c.decoration as BoxDecoration?)?.color)
          .whereType<Color>()
          .toList();
      expect(colors, contains(AntThemeData.light().colorPrimaryBg));
    });

    testWidgets('checkable renders checkboxes', (tester) async {
      await _pumpTree(tester, checkable: true, defaultExpandAll: true);
      expect(
        find.byIcon(Icons.check_box_outline_blank_outlined),
        findsWidgets,
      );
    });

    testWidgets('checking parent checks all descendants', (tester) async {
      List<String>? checked;
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: const ['js'],
        onCheck: (c, _) => checked = c,
      );
      // 勾选父节点 江苏 → 南京 + 苏州 全选
      final checkbox = find.descendant(
        of: find.ancestor(of: find.text('江苏'), matching: find.byType(Row)).first,
        matching: find.byIcon(Icons.check_box_outline_blank_outlined),
      );
      await tester.tap(checkbox.first);
      await tester.pump();
      expect(checked, containsAll(['js', 'nj', 'sz']));
      expect(find.byIcon(Icons.check_box_outlined), findsNWidgets(3));
    });

    testWidgets('checking all children checks parent', (tester) async {
      List<String>? checked;
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: const ['js'],
        onCheck: (c, _) => checked = c,
      );
      for (final title in ['南京', '苏州']) {
        final checkbox = find.descendant(
          of: find.ancestor(of: find.text(title), matching: find.byType(Row)).first,
          matching: find.byIcon(Icons.check_box_outline_blank_outlined),
        );
        await tester.tap(checkbox.first);
        await tester.pump();
      }
      expect(checked, containsAll(['nj', 'sz', 'js']));
    });

    testWidgets('half-checked state shows when partially checked',
        (tester) async {
      await _pumpTree(
        tester,
        checkable: true,
        defaultExpandedKeys: const ['js'],
      );
      // 只勾 南京 → 江苏 半选
      final checkbox = find.descendant(
        of: find.ancestor(of: find.text('南京'), matching: find.byType(Row)).first,
        matching: find.byIcon(Icons.check_box_outline_blank_outlined),
      );
      await tester.tap(checkbox.first);
      await tester.pump();
      expect(find.byIcon(Icons.indeterminate_check_box_outlined), findsOneWidget);
      // 未选的 苏州 仍是空白框
      expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);
    });

    testWidgets('checkStrictly does not cascade', (tester) async {
      List<String>? checked;
      await _pumpTree(
        tester,
        checkable: true,
        checkStrictly: true,
        defaultExpandedKeys: const ['js'],
        onCheck: (c, _) => checked = c,
      );
      final checkbox = find.descendant(
        of: find.ancestor(of: find.text('南京'), matching: find.byType(Row)).first,
        matching: find.byIcon(Icons.check_box_outline_blank_outlined),
      );
      await tester.tap(checkbox.first);
      await tester.pump();
      expect(checked, ['nj']);
      // 父节点保持未选
      expect(checked, isNot(contains('js')));
    });

    testWidgets('disabled node cannot select or check', (tester) async {
      var called = false;
      final data = [
        const AntTreeNode(
          key: 'x',
          title: '禁用节点',
          disabled: true,
          children: [AntTreeNode(key: 'x1', title: '禁用子项')],
        ),
      ];
      await _pumpTree(
        tester,
        treeData: data,
        checkable: true,
        defaultExpandedKeys: const ['x'],
        onSelect: (_) => called = true,
        onCheck: (_, __) => called = true,
      );
      await tester.tap(find.text('禁用节点'));
      await tester.pump();
      expect(called, isFalse);
      final checkbox = find.descendant(
        of: find.ancestor(of: find.text('禁用节点'), matching: find.byType(Row)).first,
        matching: find.byIcon(Icons.check_box_outline_blank_outlined),
      );
      await tester.tap(checkbox.first);
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets('showLine renders guide lines', (tester) async {
      await _pumpTree(
        tester,
        showLine: true,
        defaultExpandedKeys: const ['zj'],
      );
      // 每个可见节点行都有缩进引导线（除第一层）
      final lines = find.byWidgetPredicate((w) =>
          w is Container &&
          w.color != null &&
          w.alignment == null &&
          w.decoration == null,);
      expect(lines, findsWidgets);
    });

    testWidgets('defaultCheckedKeys renders checked state', (tester) async {
      await _pumpTree(
        tester,
        checkable: true,
        defaultCheckedKeys: const ['nj', 'sz'],
        defaultExpandedKeys: const ['js'],
      );
      expect(find.byIcon(Icons.check_box_outlined), findsNWidgets(3));
    });
  });
}
