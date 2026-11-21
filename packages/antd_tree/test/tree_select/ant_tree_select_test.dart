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

    testWidgets('dropdown opens downward when space below is enough',
        (tester) async {
      await tester.pumpWidget(_wrap(
        AntTreeSelect(treeData: _testTreeData()),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();

      final triggerBox =
          tester.renderObject<RenderBox>(find.byType(AntTreeSelect));
      final panelBox = tester.renderObject<RenderBox>(
          find.byKey(const Key('ant_tree_select_panel')),);
      final triggerTop = triggerBox.localToGlobal(Offset.zero).dy;
      final panelTop = panelBox.localToGlobal(Offset.zero).dy;
      // 触发元素上方空间充足，面板应贴在触发元素下方
      expect(panelTop, greaterThan(triggerTop));
    });

    testWidgets('dropdown flips upward near viewport bottom edge',
        (tester) async {
      // 触发元素放置在视口底部（下方空间不足），面板应自动翻转到上方。
      await tester.pumpWidget(_wrap(
        Align(
          alignment: Alignment.bottomCenter,
          child: AntTreeSelect(treeData: _testTreeData()),
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();

      final triggerBox =
          tester.renderObject<RenderBox>(find.byType(AntTreeSelect));
      final panelBox = tester.renderObject<RenderBox>(
          find.byKey(const Key('ant_tree_select_panel')),);
      final triggerTop = triggerBox.localToGlobal(Offset.zero).dy;
      final panelBottom =
          panelBox.localToGlobal(Offset.zero).dy + panelBox.size.height;
      final viewportHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      // 触发元素贴近视口底部，面板翻转后在触发元素上方且未超出视口
      expect(triggerTop, greaterThan(viewportHeight / 2));
      expect(panelBottom, lessThan(triggerTop));
      expect(panelBottom, lessThanOrEqualTo(viewportHeight));
    });

    testWidgets('in-place refresh keeps panel mounted (no animation remount)',
        (tester) async {
      // 原地重建（PopupContentRefresher）：展开节点后 OverlayEntry 不重挂，
      // 面板 Element 复用，滚动位置保留且位置/尺寸重算正确。
      await tester.pumpWidget(_wrap(
        Align(
          alignment: Alignment.topLeft,
          child: AntTreeSelect(treeData: _testTreeData()),
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();

      final panelBox = tester.renderObject<RenderBox>(
          find.byKey(const Key('ant_tree_select_panel')),);
      final heightBefore = panelBox.size.height;
      // 面板内容未超高时无滚动；展开一个节点后面板高度应增长且位置重算
      final topBefore = panelBox.localToGlobal(Offset.zero).dy;
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).first);
      await tester.pumpAndSettle();

      final panelAfter = tester.renderObject<RenderBox>(
          find.byKey(const Key('ant_tree_select_panel')),);
      final topAfter = panelAfter.localToGlobal(Offset.zero).dy;
      // 高度增长（2 子节点加入）
      expect(panelAfter.size.height, greaterThan(heightBefore));
      // 空间充足时面板仍贴触发元素下方（位置重算无跳位）
      expect(topAfter, topBefore);
    });

    testWidgets('in-place refresh preserves panel scroll offset',
        (tester) async {
      // 内容超高产生内部滚动后，继续展开节点不应丢失滚动位置。
      await tester.pumpWidget(_wrap(
        AntTreeSelect(
          treeData: [
            for (var i = 0; i < 12; i++)
              AntTreeSelectOption(
                value: 'n$i',
                label: '节点 $i',
                children: [
                  AntTreeSelectOption(value: 'n$i-c', label: '子节点 $i'),
                ],
              ),
          ],
        ),
      ),);
      await tester.tap(find.byType(AntTreeSelect));
      await tester.pumpAndSettle();

      final scrollable = find.descendant(
        of: find.byKey(const Key('ant_tree_select_panel')),
        matching: find.byType(Scrollable),
      );
      expect(scrollable, findsOneWidget);
      // 滚动到中部
      await tester.drag(scrollable.first, const Offset(0, -200));
      await tester.pumpAndSettle();
      final position = tester.state<ScrollableState>(scrollable.first).position;
      final offsetBefore = position.pixels;
      expect(offsetBefore, greaterThan(0));

      // 展开任一节点 → 原地重建，滚动位置不丢
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).first);
      await tester.pumpAndSettle();
      final positionAfter =
          tester.state<ScrollableState>(scrollable.first).position;
      expect(positionAfter.pixels, offsetBefore);
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

  group('AntTreeSelect 自定义宽高', () {
    testWidgets('height/width 覆盖触发器尺寸', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntTreeSelect(
          treeData: [AntTreeSelectOption(value: 'a', label: 'A')],
          height: 48,
          width: 260,
        ),
      ),);
      await tester.pump(const Duration(milliseconds: 100));
      final box = tester.renderObject<RenderBox>(
        find.byType(AntTreeSelect).first,
      );
      expect(box.size.height, closeTo(48.h, 2));
      expect(box.size.width, closeTo(260.w, 2));
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