/// AntTransfer widget tests
library;

import 'package:antd_transfer/antd_transfer.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _testData = <AntTransferItem>[
  AntTransferItem(key: 'a', title: '选项A'),
  AntTransferItem(key: 'b', title: '选项B'),
  AntTransferItem(key: 'c', title: '选项C', disabled: true),
  AntTransferItem(key: 'd', title: '选项D'),
];

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  group('AntTransfer', () {
    testWidgets('renders all source items in left panel', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
      expect(find.text('选项C'), findsOneWidget);
      expect(find.text('选项D'), findsOneWidget);
    });

    testWidgets('renders default titles', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      expect(find.text('Source'), findsOneWidget);
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('renders custom titles', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          titles: ['左栏', '右栏'],
        ),
      ),);
      expect(find.text('左栏'), findsOneWidget);
      expect(find.text('右栏'), findsOneWidget);
    });

    testWidgets('defaultTargetKeys moves items to right', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          defaultTargetKeys: ['b'],
        ),
      ),);
      // 左栏应有 3 项（a, c, d），右栏应有 1 项（b）
      // 标题栏计数：0/3 和 0/1
      expect(find.text('0/3'), findsOneWidget);
      expect(find.text('0/1'), findsOneWidget);
    });

    testWidgets('selecting item updates count', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      // 点击选项A 的复选框
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(find.text('1/4'), findsOneWidget);
    });

    testWidgets('moving selected items to right calls onChange', (tester) async {
      List<String>? resultKeys;
      AntTransferDirection? direction;
      List<String>? moveKeys;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: _testData,
          onChange: (keys, dir, moves) {
            resultKeys = keys;
            direction = dir;
            moveKeys = moves;
          },
        ),
      ),);
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_right));
      await tester.pumpAndSettle();
      expect(resultKeys, ['a']);
      expect(direction, AntTransferDirection.right);
      expect(moveKeys, ['a']);
    });

    testWidgets('moving items back to left calls onChange', (tester) async {
      List<String>? resultKeys;
      AntTransferDirection? direction;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: _testData,
          defaultTargetKeys: ['b'],
          onChange: (keys, dir, moves) {
            resultKeys = keys;
            direction = dir;
          },
        ),
      ),);
      // 右栏选中 b
      await tester.tap(find.text('选项B'));
      await tester.pumpAndSettle();
      // 移回左栏
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_left));
      await tester.pumpAndSettle();
      expect(resultKeys, isEmpty);
      expect(direction, AntTransferDirection.left);
    });

    testWidgets('disabled item cannot be selected', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      // 选项C 是禁用的
      await tester.tap(find.text('选项C'));
      await tester.pumpAndSettle();
      // 计数不应变化
      expect(find.text('0/4'), findsOneWidget);
    });

    testWidgets('select all checkbox selects all non-disabled items', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      // 点击左栏全选（第一个 AntCheckbox）
      final checkboxes = find.byType(AntCheckbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      // 应选中 3 项（a, b, d — c 禁用）
      expect(find.text('3/4'), findsOneWidget);
    });

    testWidgets('select all then move moves all non-disabled', (tester) async {
      List<String>? resultKeys;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: _testData,
          onChange: (keys, dir, moves) {
            resultKeys = keys;
          },
        ),
      ),);
      final checkboxes = find.byType(AntCheckbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_right));
      await tester.pumpAndSettle();
      expect(resultKeys, ['a', 'b', 'd']);
    });

    testWidgets('oneWay mode hides left arrow button', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          oneWay: true,
          defaultTargetKeys: ['b'],
        ),
      ),);
      expect(find.byIcon(Icons.keyboard_double_arrow_right), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_double_arrow_left), findsNothing);
    });

    testWidgets('showSearch renders search fields', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          showSearch: true,
        ),
      ),);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('search filters items', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          showSearch: true,
        ),
      ),);
      // 左栏搜索框是第一个 TextField
      await tester.enterText(find.byType(TextField).first, 'A');
      await tester.pumpAndSettle();
      // 只有选项A 匹配
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsNothing);
    });

    testWidgets('custom filterOption works', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: _testData,
          showSearch: true,
          filterOption: (input, item) => item.key.contains(input),
        ),
      ),);
      await tester.enterText(find.byType(TextField).first, 'd');
      await tester.pumpAndSettle();
      expect(find.text('选项D'), findsOneWidget);
      expect(find.text('选项A'), findsNothing);
    });

    testWidgets('disabled transfer does not respond to taps', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          disabled: true,
        ),
      ),);
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      // 计数不变
      expect(find.text('0/4'), findsOneWidget);
    });

    testWidgets('controlled targetKeys updates display', (tester) async {
      late StateSetter setStateOuter;
      List<String> targetKeys = [];
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            setStateOuter = setState;
            return AntTransfer(
              dataSource: _testData,
              targetKeys: targetKeys,
            );
          },
        ),
      ),);
      expect(find.text('0/4'), findsOneWidget);
      setStateOuter(() => targetKeys = ['a', 'b']);
      await tester.pumpAndSettle();
      // 左栏 2 项（c, d），右栏 2 项（a, b），两栏计数均为 0/2
      expect(find.text('0/2'), findsNWidgets(2));
    });

    testWidgets('onSelectChange fires on item select', (tester) async {
      List<String>? sourceSelected;
      List<String>? targetSelected;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: _testData,
          onSelectChange: (source, target) {
            sourceSelected = source;
            targetSelected = target;
          },
        ),
      ),);
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(sourceSelected, ['a']);
      expect(targetSelected, isEmpty);
    });

    testWidgets('empty dataSource renders No data', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: []),
      ),);
      expect(find.text('No data'), findsNWidgets(2));
    });

    testWidgets('operations with labels use text buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          operations: ['右移', '左移'],
        ),
      ),);
      expect(find.text('右移'), findsOneWidget);
      expect(find.text('左移'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_double_arrow_right), findsNothing);
    });

    testWidgets('move button disabled when nothing selected', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      final button = find.byIcon(Icons.keyboard_double_arrow_right);
      await tester.tap(button);
      await tester.pumpAndSettle();
      // 没有选中项，不应触发移动，计数不变
      expect(find.text('0/4'), findsOneWidget);
    });
  });

  group('AntTransferItem', () {
    test('supports equality', () {
      const a = AntTransferItem(key: 'k1', title: 't1');
      const b = AntTransferItem(key: 'k1', title: 't1');
      const c = AntTransferItem(key: 'k2', title: 't2');
      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('disabled defaults to false', () {
      const item = AntTransferItem(key: 'k', title: 't');
      expect(item.disabled, isFalse);
    });
  });

  group('AntTransferDirection', () {
    test('has right and left values', () {
      expect(AntTransferDirection.values.length, 2);
      expect(AntTransferDirection.values, contains(AntTransferDirection.right));
      expect(AntTransferDirection.values, contains(AntTransferDirection.left));
    });
  });

  group('AntTransfer 树形模式（TreeTransfer）', () {
    // 结构：父级1(c1,c2)、父级2(c3,c4,禁用联动)、独立叶子 D
    const treeData = <AntTransferItem>[
      AntTransferItem(
        key: 'p1',
        title: '父级1',
        children: [
          AntTransferItem(key: 'c1', title: '子节点1'),
          AntTransferItem(key: 'c2', title: '子节点2'),
        ],
      ),
      AntTransferItem(
        key: 'p2',
        title: '父级2（禁用）',
        disabled: true,
        children: [
          AntTransferItem(key: 'c3', title: '子节点3'),
          AntTransferItem(key: 'c4', title: '子节点4'),
        ],
      ),
      AntTransferItem(key: 'd', title: '独立节点'),
    ];

    /// 取指定标题所在行的 AntCheckbox（取包含该 Checkbox 的最近 Row）
    AntCheckbox rowCheckbox(WidgetTester tester, String title) {
      final rowFinder = find.ancestor(
        of: find.text(title),
        matching: find.byType(Row),
      );
      for (final candidate in rowFinder.evaluate()) {
        final boxes = find.descendant(
          of: find.byWidget(candidate.widget),
          matching: find.byType(AntCheckbox),
        );
        if (boxes.evaluate().length == 1) {
          return tester.widget<AntCheckbox>(boxes.first);
        }
      }
      fail('row checkbox not found for $title');
    }

    testWidgets('collapsed by default, expand arrow reveals children',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: treeData),
      ),);
      expect(find.text('父级1'), findsOneWidget);
      expect(find.text('子节点1'), findsNothing);
      // 点击展开箭头展开子树
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).first);
      await tester.pumpAndSettle();
      expect(find.text('子节点1'), findsOneWidget);
      expect(find.text('子节点2'), findsOneWidget);
    });

    testWidgets('defaultExpandAll renders children on both panels',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: treeData, defaultExpandAll: true),
      ),);
      expect(find.text('子节点1'), findsOneWidget);
      expect(find.text('子节点2'), findsOneWidget);
    });

    testWidgets('checking parent selects all children', (tester) async {
      List<String>? selected;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: treeData,
          defaultExpandAll: true,
          onSelectChange: (source, _) => selected = source,
        ),
      ),);
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      expect(selected, containsAll(['c1', 'c2']));
      expect(rowCheckbox(tester, '父级1').checked, isTrue);
    });

    testWidgets('unchecking parent deselects all children', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: treeData, defaultExpandAll: true),
      ),);
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      // 全选头计数清零（叶子总数 5：c1/c2/c3/c4/d，含禁用子树的叶子）
      expect(find.text('0/5'), findsOneWidget);
    });

    testWidgets('selecting all children checks parent', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: treeData, defaultExpandAll: true),
      ),);
      await tester.tap(find.text('子节点1'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '父级1').checked, isFalse);
      expect(rowCheckbox(tester, '父级1').indeterminate, isTrue);
      await tester.tap(find.text('子节点2'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '父级1').checked, isTrue);
      expect(rowCheckbox(tester, '父级1').indeterminate, isFalse);
    });

    testWidgets('partial child selection shows parent indeterminate',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: treeData, defaultExpandAll: true),
      ),);
      await tester.tap(find.text('子节点1'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '父级1').indeterminate, isTrue);
      expect(rowCheckbox(tester, '父级1').checked, isFalse);
    });

    testWidgets('disabled parent disables whole subtree', (tester) async {
      var selected = <String>[];
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: treeData,
          defaultExpandAll: true,
          onSelectChange: (source, _) => selected = source,
        ),
      ),);
      await tester.tap(find.text('子节点3'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      await tester.tap(find.text('父级2（禁用）'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(rowCheckbox(tester, '子节点3').disabled, isTrue);
      expect(rowCheckbox(tester, '子节点4').disabled, isTrue);
    });

    testWidgets('move moves selected subtree with structure', (tester) async {
      List<String>? moved;
      List<String>? targets;
      await tester.pumpWidget(_wrap(
        AntTransfer(
          dataSource: treeData,
          defaultExpandAll: true,
          onChange: (keys, _, moveKeys) {
            targets = keys;
            moved = moveKeys;
          },
        ),
      ),);
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_right));
      await tester.pumpAndSettle();
      // 勾选计数含子级：移动 keys 为子叶 c1/c2
      expect(moved, containsAll(['c1', 'c2']));
      expect(moved, isNot(contains('p1')));
      expect(targets, equals(['c1', 'c2']));
      // 右侧保持树形展示（父级 + 子级），左侧残留父级空壳（对齐 antd 扁平 dataSource 语义）
      expect(find.text('父级1'), findsNWidgets(2));
      expect(find.text('子节点1'), findsOneWidget);
    });

    testWidgets('tree search keeps matched node and its parent chain',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: treeData,
          defaultExpandAll: true,
          showSearch: true,
        ),
      ),);
      await tester.enterText(find.byType(TextField).first, '子节点2');
      await tester.pumpAndSettle();
      // 以列表区域为准（find.text 也会命中搜索框输入内容）
      final listFinder = find.byType(ListView);
      expect(
        find.descendant(of: listFinder, matching: find.text('父级1')),
        findsOneWidget,
      ); // 父链保留（左侧）
      expect(
        find.descendant(of: listFinder, matching: find.text('子节点2')),
        findsOneWidget,
      ); // 左侧命中节点
      expect(find.text('子节点1'), findsNothing); // 未命中被过滤
      expect(find.text('独立节点'), findsNothing);
    });

    testWidgets('flat data still renders flat list (backward compatible)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ),);
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
      expect(rowCheckbox(tester, '选项A').checked, isFalse);
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '选项A').checked, isTrue);
    });
  });

  group('AntTransfer — 对齐', () {
    testWidgets('flat list: row checkbox aligns with header select-all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AntTransfer(
            dataSource: [
              AntTransferItem(key: 'a', title: 'Item A'),
              AntTransferItem(key: 'b', title: 'Item B'),
            ],
          ),
        ),
      );
      final boxes = find.byType(AntCheckbox).evaluate().toList();
      final headerLeft = tester.getRect(find.byWidget(boxes[0].widget)).left;
      final rowLeft = tester.getRect(find.byWidget(boxes[1].widget)).left;
      expect((rowLeft - headerLeft).abs(), lessThan(0.5));
    });

    testWidgets('tree list: child row keeps arrow indentation', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTransfer(
            dataSource: [
              AntTransferItem(
                key: 'p1',
                title: '父级1',
                children: [AntTransferItem(key: 'c1', title: '子节点1')],
              ),
            ],
            defaultExpandAll: true,
          ),
        ),
      );
      final boxes = find.byType(AntCheckbox).evaluate().toList();
      final headerLeft = tester.getRect(find.byWidget(boxes[0].widget)).left;
      final parentLeft = tester.getRect(find.byWidget(boxes[1].widget)).left;
      expect(parentLeft, greaterThan(headerLeft));
    });
  });
}