/// AntTreeSelect widget tests
library;

import 'package:antd_tree/antd_tree.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

List<AntTreeSelectOption> _testTreeData() => [
      const AntTreeSelectOption(value: 'zj', label: '浙江', children: [
        AntTreeSelectOption(value: 'hz', label: '杭州'),
        AntTreeSelectOption(value: 'nb', label: '宁波'),
      ],),
      const AntTreeSelectOption(value: 'js', label: '江苏', children: [
        AntTreeSelectOption(value: 'nj', label: '南京'),
        AntTreeSelectOption(value: 'sz', label: '苏州'),
      ],),
      const AntTreeSelectOption(value: 'gd', label: '广东'),
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
  group('AntTreeSelect', () {
    testWidgets('renders placeholder when no value', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          placeholder: '请选择',
        ),
      ),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('displays default single value', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          defaultValue: 'hz',
          placeholder: '请选择',
        ),
      ),);
      // defaultValue is 'hz' but treeData is empty, so label falls back to value
      expect(find.text('hz'), findsOneWidget);
    });

    testWidgets('displays controlled single value with label', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          value: 'nj',
          placeholder: '请选择',
        ),
      ),);
      expect(find.text('nj'), findsOneWidget);
    });

    testWidgets('opens dropdown on tap and shows root nodes', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      expect(find.text('江苏'), findsWidgets);
      expect(find.text('广东'), findsOneWidget);
    });

    testWidgets('children hidden until parent expanded', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      // 子节点不应显示
      expect(find.text('杭州'), findsNothing);
      expect(find.text('南京'), findsNothing);
    });

    testWidgets('expand shows children', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      // 点击展开箭头展开
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
    });

    testWidgets('collapse hides children', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      // 展开
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsOneWidget);
      // 再次点击箭头收起
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down).first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsNothing);
    });

    testWidgets('treeDefaultExpandAll shows all nodes', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: _testTreeData(),
          treeDefaultExpandAll: true,
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('南京'), findsOneWidget);
    });

    testWidgets('selecting leaf sets value and closes dropdown', (tester) async {
      String? selected;
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: _testTreeData(),
          treeDefaultExpandAll: true,
          onChange: (v) => selected = v as String?,
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      await tester.tap(find.text('南京'));
      await tester.pumpAndSettle();
      expect(selected, 'nj');
      expect(find.text('南京'), findsOneWidget); // 触发器显示
    });

    testWidgets('disabled node cannot be selected', (tester) async {
      String? selected;
      final data = [
        const AntTreeSelectOption(value: 'a', label: '可用'),
        const AntTreeSelectOption(value: 'b', label: '禁用', disabled: true),
      ];
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: data,
          onChange: (v) => selected = v as String?,
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();
      expect(selected, isNull);
    });

    testWidgets('disabled tree select does not open', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          disabled: true,
          placeholder: '禁用',
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('multiple mode toggles selection', (tester) async {
      List<String>? selected;
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: _testTreeData(),
          treeDefaultExpandAll: true,
          multiple: true,
          onChange: (v) => selected = v as List<String>?,
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      expect(selected, ['hz']);
      await tester.tap(find.text('南京'));
      await tester.pumpAndSettle();
      expect(selected, ['hz', 'nj']);
      // 再次点击取消
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      expect(selected, ['nj']);
    });

    testWidgets('multiple mode displays joined labels', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          multiple: true,
          defaultValue: ['a', 'b'],
          placeholder: '请选择',
        ),
      ),);
      expect(find.text('a、b'), findsOneWidget);
    });

    testWidgets('allowClear clears single value', (tester) async {
      String? selected = 'nj';
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: _testTreeData(),
          defaultValue: 'nj',
          allowClear: true,
          onChange: (v) => selected = v as String?,
        ),
      ),);
      expect(find.text('南京'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(selected, isNull);
    });

    testWidgets('allowClear clears multiple values', (tester) async {
      List<String>? selected = ['hz'];
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: _testTreeData(),
          multiple: true,
          defaultValue: const ['hz'],
          allowClear: true,
          onChange: (v) => selected = v as List<String>?,
        ),
      ),);
      expect(find.text('杭州'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(selected, []);
    });

    testWidgets('closes dropdown when tapping outside', (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      await tester.tapAt(const Offset(300, 500));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('controlled value updates display', (tester) async {
      late StateSetter setStateOuter;
      String? value;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            setStateOuter = setState;
            return AntTreeSelect(
              treeData: _testTreeData(),
              value: value,
              placeholder: '请选择',
            );
          },
        ),
      ),);
      expect(find.text('请选择'), findsOneWidget);
      setStateOuter(() => value = 'sz');
      await tester.pumpAndSettle();
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('large size renders with larger height', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          size: AntTreeSelectSize.large,
          placeholder: '大',
        ),
      ),);
      final box = tester.getSize(find.byType(AntTreeSelect));
      expect(box.height, greaterThan(35));
    });

    testWidgets('small size renders with smaller height', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [],
          size: AntTreeSelectSize.small,
          placeholder: '小',
        ),
      ),);
      final box = tester.getSize(find.byType(AntTreeSelect));
      expect(box.height, lessThan(30));
    });
  });

  group('AntTreeSelectOption', () {
    test('isLeaf returns true when children is null or empty', () {
      const leaf1 = AntTreeSelectOption(value: 'a', label: 'A');
      expect(leaf1.isLeaf, isTrue);

      const leaf2 = AntTreeSelectOption(value: 'b', label: 'B', children: []);
      expect(leaf2.isLeaf, isTrue);
    });

    test('isLeaf returns false when children is non-empty', () {
      const parent = AntTreeSelectOption(value: 'a', label: 'A', children: [
        AntTreeSelectOption(value: 'a1', label: 'A1'),
      ],);
      expect(parent.isLeaf, isFalse);
    });

    test('disabled defaults to false', () {
      const opt = AntTreeSelectOption(value: 'a', label: 'A');
      expect(opt.disabled, isFalse);
    });
  });

  group('AntTreeSelectFieldNames', () {
    test('default constructor sets fields', () {
      const fn = AntTreeSelectFieldNames(
        label: 'name',
        value: 'id',
        children: 'subs',
      );
      expect(fn.label, 'name');
      expect(fn.value, 'id');
      expect(fn.children, 'subs');
    });
  });
}