/// AntTransfer widget tests
library;

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_transfer/antd_transfer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型：组件只通过 keyOf/titleBuilder/childrenOf 等读取数据。
class _Item {
  const _Item(
    this.id,
    this.name, {
    this.description,
    this.disabled = false,
    this.children = const <_Item>[],
  });

  final int id;
  final String name;
  final String? description;
  final bool disabled;
  final List<_Item> children;
}

const _testData = <_Item>[
  _Item(1, '选项A', description: '第一个选项'),
  _Item(2, '选项B', description: '第二个选项'),
  _Item(3, '选项C', description: '第三个选项', disabled: true),
  _Item(4, '选项D', description: '第四个选项'),
];

const treeData = <_Item>[
  _Item(
    1,
    '父级1',
    children: [
      _Item(11, '子节点1'),
      _Item(12, '子节点2'),
    ],
  ),
  _Item(
    2,
    '父级2（禁用）',
    disabled: true,
    children: [
      _Item(21, '子节点3'),
      _Item(22, '子节点4'),
    ],
  ),
  _Item(3, '独立节点'),
];

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

AntTransfer<_Item> _transfer({
  List<_Item> dataSource = _testData,
  List<Object>? targetKeys,
  List<Object> defaultTargetKeys = const <Object>[],
  List<Object>? selectedKeys,
  List<Object> defaultSelectedKeys = const <Object>[],
  AntTransferOnChange? onChange,
  AntTransferOnSelectChange? onSelectChange,
  List<String> titles = const ['Source', 'Target'],
  List<String> operations = const ['', ''],
  bool disabled = false,
  bool showSearch = false,
  bool oneWay = false,
  bool Function(String input, _Item item)? filterOption,
  bool defaultExpandAll = false,
  Widget Function(BuildContext context, _Item item)? titleBuilder,
}) {
  return AntTransfer<_Item>(
    dataSource: dataSource,
    keyOf: (item) => item.id,
    titleBuilder: titleBuilder ?? (context, item) => Text(item.name),
    descriptionOf: (item) => item.description,
    childrenOf: (item) => item.children,
    disabledOf: (item) => item.disabled,
    searchTextOf: (item) => '${item.name} ${item.description ?? ''}',
    targetKeys: targetKeys,
    defaultTargetKeys: defaultTargetKeys,
    selectedKeys: selectedKeys,
    defaultSelectedKeys: defaultSelectedKeys,
    onChange: onChange,
    onSelectChange: onSelectChange,
    titles: titles,
    operations: operations,
    disabled: disabled,
    showSearch: showSearch,
    oneWay: oneWay,
    filterOption: filterOption,
    defaultExpandAll: defaultExpandAll,
  );
}

/// 取指定标题所在行的 AntCheckbox（取包含该 Checkbox 的最近 Row）。
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

void main() {
  group('AntTransfer', () {
    testWidgets('renders all source items in left panel', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
      expect(find.text('选项C'), findsOneWidget);
      expect(find.text('选项D'), findsOneWidget);
    });

    testWidgets('renders default titles', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      expect(find.text('Source'), findsOneWidget);
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('renders custom titles', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(titles: const ['左栏', '右栏'])),
      );
      expect(find.text('左栏'), findsOneWidget);
      expect(find.text('右栏'), findsOneWidget);
    });

    testWidgets('defaultTargetKeys moves items to right', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(defaultTargetKeys: const <Object>[2])),
      );
      // 左栏 3 项（a, c, d），右栏 1 项（b）
      expect(find.text('0/3'), findsOneWidget);
      expect(find.text('0/1'), findsOneWidget);
    });

    testWidgets('selecting item updates count', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(find.text('1/4'), findsOneWidget);
    });

    testWidgets('moving selected items to right calls onChange',
        (tester) async {
      List<Object>? resultKeys;
      AntTransferDirection? direction;
      List<Object>? moveKeys;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            onChange: (keys, dir, moves) {
              resultKeys = keys;
              direction = dir;
              moveKeys = moves;
            },
          ),
        ),
      );
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(resultKeys, <Object>[1]);
      expect(direction, AntTransferDirection.right);
      expect(moveKeys, <Object>[1]);
    });

    testWidgets('moving items back to left calls onChange', (tester) async {
      List<Object>? resultKeys;
      AntTransferDirection? direction;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            defaultTargetKeys: const <Object>[2],
            onChange: (keys, dir, moves) {
              resultKeys = keys;
              direction = dir;
            },
          ),
        ),
      );
      await tester.tap(find.text('选项B'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleLeftOutlined));
      await tester.pumpAndSettle();
      expect(resultKeys, isEmpty);
      expect(direction, AntTransferDirection.left);
    });

    testWidgets('disabled item cannot be selected', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      await tester.tap(find.text('选项C'));
      await tester.pumpAndSettle();
      expect(find.text('0/4'), findsOneWidget);
    });

    testWidgets('select all checkbox selects all non-disabled items',
        (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      final checkboxes = find.byType(AntCheckbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      // 应选中 3 项（a, b, d — c 禁用）
      expect(find.text('3/4'), findsOneWidget);
    });

    testWidgets('select all then move moves all non-disabled', (tester) async {
      List<Object>? resultKeys;
      await tester.pumpWidget(
        _wrap(_transfer(onChange: (keys, dir, moves) => resultKeys = keys)),
      );
      final checkboxes = find.byType(AntCheckbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(resultKeys, <Object>[1, 2, 4]);
    });

    testWidgets('oneWay mode hides left arrow button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _transfer(
            oneWay: true,
            defaultTargetKeys: const <Object>[2],
          ),
        ),
      );
      expect(find.byIcon(AntIcons.doubleRightOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.doubleLeftOutlined), findsNothing);
    });

    testWidgets('showSearch renders search fields', (tester) async {
      await tester.pumpWidget(_wrap(_transfer(showSearch: true)));
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('search filters items', (tester) async {
      await tester.pumpWidget(_wrap(_transfer(showSearch: true)));
      await tester.enterText(find.byType(TextField).first, 'A');
      await tester.pumpAndSettle();
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsNothing);
    });

    testWidgets('custom filterOption works', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _transfer(
            showSearch: true,
            filterOption: (input, item) => item.id.toString().contains(input),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).first, '4');
      await tester.pumpAndSettle();
      expect(find.text('选项D'), findsOneWidget);
      expect(find.text('选项A'), findsNothing);
    });

    testWidgets('disabled transfer does not respond to taps', (tester) async {
      await tester.pumpWidget(_wrap(_transfer(disabled: true)));
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(find.text('0/4'), findsOneWidget);
    });

    testWidgets('controlled targetKeys updates display', (tester) async {
      late StateSetter setStateOuter;
      List<Object> targetKeys = <Object>[];
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              setStateOuter = setState;
              return _transfer(targetKeys: targetKeys);
            },
          ),
        ),
      );
      expect(find.text('0/4'), findsOneWidget);
      setStateOuter(() => targetKeys = <Object>[1, 2]);
      await tester.pumpAndSettle();
      expect(find.text('0/2'), findsNWidgets(2));
    });

    testWidgets('onSelectChange fires on item select', (tester) async {
      List<Object>? sourceSelected;
      List<Object>? targetSelected;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            onSelectChange: (source, target) {
              sourceSelected = source;
              targetSelected = target;
            },
          ),
        ),
      );
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(sourceSelected, <Object>[1]);
      expect(targetSelected, isEmpty);
    });

    testWidgets('empty dataSource renders No data', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(dataSource: const <_Item>[])),
      );
      expect(find.text('No data'), findsNWidgets(2));
    });

    testWidgets('operations with labels use text buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(operations: const ['右移', '左移'])),
      );
      expect(find.text('右移'), findsOneWidget);
      expect(find.text('左移'), findsOneWidget);
      expect(find.byIcon(AntIcons.doubleRightOutlined), findsNothing);
    });

    testWidgets('move button disabled when nothing selected', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(find.text('0/4'), findsOneWidget);
    });
  });

  group('AntTransferItem（兼容模型）', () {
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
    testWidgets('collapsed by default, expand arrow reveals children',
        (tester) async {
      await tester.pumpWidget(_wrap(_transfer(dataSource: treeData)));
      expect(find.text('父级1'), findsOneWidget);
      expect(find.text('子节点1'), findsNothing);
      await tester.tap(find.byIcon(AntIcons.rightOutlined).first);
      await tester.pumpAndSettle();
      expect(find.text('子节点1'), findsOneWidget);
      expect(find.text('子节点2'), findsOneWidget);
    });

    testWidgets('defaultExpandAll renders children on both panels',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(dataSource: treeData, defaultExpandAll: true)),
      );
      expect(find.text('子节点1'), findsOneWidget);
      expect(find.text('子节点2'), findsOneWidget);
    });

    testWidgets('checking parent selects all children', (tester) async {
      List<Object>? selected;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: treeData,
            defaultExpandAll: true,
            onSelectChange: (source, _) => selected = source,
          ),
        ),
      );
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      expect(selected, containsAll(<Object>[11, 12]));
      expect(rowCheckbox(tester, '父级1').checked, isTrue);
    });

    testWidgets('unchecking parent deselects all children', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(dataSource: treeData, defaultExpandAll: true)),
      );
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      // 叶子总数 5：c1/c2/c3/c4/d
      expect(find.text('0/5'), findsOneWidget);
    });

    testWidgets('selecting all children checks parent', (tester) async {
      await tester.pumpWidget(
        _wrap(_transfer(dataSource: treeData, defaultExpandAll: true)),
      );
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
      await tester.pumpWidget(
        _wrap(_transfer(dataSource: treeData, defaultExpandAll: true)),
      );
      await tester.tap(find.text('子节点1'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '父级1').indeterminate, isTrue);
      expect(rowCheckbox(tester, '父级1').checked, isFalse);
    });

    testWidgets('disabled parent disables whole subtree', (tester) async {
      var selected = <Object>[];
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: treeData,
            defaultExpandAll: true,
            onSelectChange: (source, _) => selected = source,
          ),
        ),
      );
      await tester.tap(find.text('子节点3'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      await tester.tap(find.text('父级2（禁用）'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(rowCheckbox(tester, '子节点3').disabled, isTrue);
      // 列表可视区域有限，先滚动到子节点4再断言。
      await tester.scrollUntilVisible(
        find.text('子节点4'),
        80,
        scrollable: find.descendant(
          of: find.byType(ListView).first,
          matching: find.byType(Scrollable),
        ),
      );
      expect(rowCheckbox(tester, '子节点4').disabled, isTrue);
    });

    testWidgets('move moves selected subtree with structure', (tester) async {
      List<Object>? moved;
      List<Object>? targets;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: treeData,
            defaultExpandAll: true,
            onChange: (keys, _, moveKeys) {
              targets = keys;
              moved = moveKeys;
            },
          ),
        ),
      );
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(moved, containsAll(<Object>[11, 12]));
      expect(moved, isNot(contains(1)));
      expect(targets, equals(<Object>[11, 12]));
      expect(find.text('父级1'), findsNWidgets(2));
      expect(find.text('子节点1'), findsOneWidget);
    });

    testWidgets('tree search keeps matched node and its parent chain',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: treeData,
            defaultExpandAll: true,
            showSearch: true,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).first, '子节点2');
      await tester.pumpAndSettle();
      final listFinder = find.byType(ListView);
      expect(
        find.descendant(of: listFinder, matching: find.text('父级1')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: listFinder, matching: find.text('子节点2')),
        findsOneWidget,
      );
      expect(find.text('子节点1'), findsNothing);
      expect(find.text('独立节点'), findsNothing);
    });

    testWidgets('flat data still renders flat list', (tester) async {
      await tester.pumpWidget(_wrap(_transfer()));
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
      expect(rowCheckbox(tester, '选项A').checked, isFalse);
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(rowCheckbox(tester, '选项A').checked, isTrue);
    });
  });

  group('AntTransfer — 自定义模型', () {
    testWidgets('自定义模型：keyOf + titleBuilder 驱动扁平穿梭', (tester) async {
      List<Object>? targets;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            titleBuilder: (context, item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AntIcons.fileOutlined, size: 12),
                Text(item.name),
              ],
            ),
            onChange: (keys, _, __) => targets = keys,
          ),
        ),
      );
      expect(find.byIcon(AntIcons.fileOutlined), findsNWidgets(4));
      await tester.tap(find.text('选项B'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(targets, <Object>[2]);
    });

    testWidgets('自定义模型：childrenOf + disabledOf 驱动树形穿梭', (tester) async {
      List<Object>? targets;
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: treeData,
            defaultExpandAll: true,
            onChange: (keys, _, __) => targets = keys,
          ),
        ),
      );
      expect(rowCheckbox(tester, '子节点3').disabled, isTrue);
      await tester.tap(find.text('父级1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(AntIcons.doubleRightOutlined));
      await tester.pumpAndSettle();
      expect(targets, <Object>[11, 12]);
    });
  });

  group('AntTransfer — 对齐', () {
    testWidgets('flat list: row checkbox aligns with header select-all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _transfer(
            dataSource: const <_Item>[
              _Item(1, 'Item A'),
              _Item(2, 'Item B'),
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
          _transfer(
            dataSource: const <_Item>[
              _Item(1, '父级1', children: [_Item(11, '子节点1')]),
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
