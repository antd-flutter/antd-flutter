/// AntTransfer widget tests
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
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
      ));
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
      expect(find.text('选项C'), findsOneWidget);
      expect(find.text('选项D'), findsOneWidget);
    });

    testWidgets('renders default titles', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ));
      expect(find.text('Source'), findsOneWidget);
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('renders custom titles', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          titles: ['左栏', '右栏'],
        ),
      ));
      expect(find.text('左栏'), findsOneWidget);
      expect(find.text('右栏'), findsOneWidget);
    });

    testWidgets('defaultTargetKeys moves items to right', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          defaultTargetKeys: ['b'],
        ),
      ));
      // 左栏应有 3 项（a, c, d），右栏应有 1 项（b）
      // 标题栏计数：0/3 和 0/1
      expect(find.text('0/3'), findsOneWidget);
      expect(find.text('0/1'), findsOneWidget);
    });

    testWidgets('selecting item updates count', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ));
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
      ));
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
      ));
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
      ));
      // 选项C 是禁用的
      await tester.tap(find.text('选项C'));
      await tester.pumpAndSettle();
      // 计数不应变化
      expect(find.text('0/4'), findsOneWidget);
    });

    testWidgets('select all checkbox selects all non-disabled items', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ));
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
      ));
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
      ));
      expect(find.byIcon(Icons.keyboard_double_arrow_right), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_double_arrow_left), findsNothing);
    });

    testWidgets('showSearch renders search fields', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          showSearch: true,
        ),
      ));
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('search filters items', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          showSearch: true,
        ),
      ));
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
      ));
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
      ));
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
      ));
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
      ));
      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(sourceSelected, ['a']);
      expect(targetSelected, isEmpty);
    });

    testWidgets('empty dataSource renders No data', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: []),
      ));
      expect(find.text('No data'), findsNWidgets(2));
    });

    testWidgets('operations with labels use text buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(
          dataSource: _testData,
          operations: ['右移', '左移'],
        ),
      ));
      expect(find.text('右移'), findsOneWidget);
      expect(find.text('左移'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_double_arrow_right), findsNothing);
    });

    testWidgets('move button disabled when nothing selected', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTransfer(dataSource: _testData),
      ));
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
}