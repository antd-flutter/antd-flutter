/// AntCascader widget tests
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// 测试选项树
List<AntCascaderOption> _testOptions() => [
      const AntCascaderOption(value: 'zj', label: '浙江', children: [
        AntCascaderOption(value: 'hz', label: '杭州', children: [
          AntCascaderOption(value: 'xh', label: '西湖'),
          AntCascaderOption(value: 'yh', label: '余杭'),
        ],),
        AntCascaderOption(value: 'nb', label: '宁波', children: [
          AntCascaderOption(value: 'js', label: '江东'),
        ],),
      ],),
      const AntCascaderOption(value: 'js', label: '江苏', children: [
        AntCascaderOption(value: 'nj', label: '南京', children: [
          AntCascaderOption(value: 'xl', label: '玄武'),
        ],),
      ],),
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
  group('AntCascader', () {
    testWidgets('renders placeholder when no value', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCascader(
          options: [],
          placeholder: '请选择',
        ),
      ),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('displays default value path', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          defaultValue: const ['zj', 'hz', 'xh'],
        ),
      ),);
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
    });

    testWidgets('displays controlled value path', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          value: const ['js', 'nj', 'xl'],
        ),
      ),);
      expect(find.text('江苏 / 南京 / 玄武'), findsOneWidget);
    });

    testWidgets('opens panel on tap and shows first column', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(options: _testOptions()),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      expect(find.text('江苏'), findsWidgets);
    });

    testWidgets('expands second column when clicking parent option', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(options: _testOptions()),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      // 点击"浙江"展开子列
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsWidgets);
      expect(find.text('宁波'), findsWidgets);
    });

    testWidgets('expands third column and confirms leaf selection', (tester) async {
      var selectedPath = <String>[];
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          onChange: (path) => selectedPath = path,
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('西湖'));
      await tester.pumpAndSettle();
      expect(selectedPath, ['zj', 'hz', 'xh']);
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
    });

    testWidgets('non-leaf click does not trigger onChange by default', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          onChange: (_) => callCount++,
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });

    testWidgets('changeOnSelect triggers onChange for non-leaf', (tester) async {
      var selectedPath = <String>[];
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          changeOnSelect: true,
          onChange: (path) => selectedPath = path,
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(selectedPath, ['zj']);
      // 面板保持打开，子列展开
      expect(find.text('杭州'), findsWidgets);
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      var selectedPath = <String>[];
      final disabledOptions = [
        const AntCascaderOption(value: 'a', label: '可用', children: [
          AntCascaderOption(value: 'a1', label: '子项A1'),
        ],),
        const AntCascaderOption(value: 'b', label: '禁用', disabled: true, children: [
          AntCascaderOption(value: 'b1', label: '子项B1'),
        ],),
      ];
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: disabledOptions,
          onChange: (path) => selectedPath = path,
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();
      // 禁用项不应触发选择
      expect(selectedPath, []);
      // 子项B1不应出现
      expect(find.text('子项B1'), findsNothing);
    });

    testWidgets('disabled cascader does not open', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCascader(
          options: [],
          disabled: true,
          placeholder: '禁用',
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('allowClear shows clear icon and clears value', (tester) async {
      var selectedPath = <String>['zj', 'hz', 'xh'];
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          defaultValue: const ['zj', 'hz', 'xh'],
          allowClear: true,
          onChange: (path) => selectedPath = path,
        ),
      ),);
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
      // 点击清除图标
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(selectedPath, []);
    });

    testWidgets('closes panel when tapping outside', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(options: _testOptions()),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      // 点击面板外区域（Scaffold 空白处）
      await tester.tapAt(const Offset(300, 500));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('controlled value updates display', (tester) async {
      late StateSetter setStateOuter;
      List<String>? value;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            setStateOuter = setState;
            return AntCascader(
              options: _testOptions(),
              value: value,
              placeholder: '请选择',
            );
          },
        ),
      ),);
      expect(find.text('请选择'), findsOneWidget);
      setStateOuter(() => value = ['zj', 'nb', 'js']);
      await tester.pumpAndSettle();
      expect(find.text('浙江 / 宁波 / 江东'), findsOneWidget);
    });

    testWidgets('switching column selection resets deeper columns', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(options: _testOptions()),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      // 展开 浙江 → 杭州
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州').last);
      await tester.pumpAndSettle();
      expect(find.text('西湖'), findsOneWidget);
      // 切换到 江苏，第三列应显示南京的子项
      await tester.tap(find.text('江苏').first);
      await tester.pumpAndSettle();
      expect(find.text('南京'), findsWidgets);
      expect(find.text('西湖'), findsNothing); // 旧第三列应消失
    });

    testWidgets('large size renders with larger height', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCascader(
          options: [],
          size: AntCascaderSize.large,
          placeholder: '大',
        ),
      ),);
      final box = tester.getSize(find.byType(AntCascader));
      expect(box.height, greaterThan(35));
    });

    testWidgets('small size renders with smaller height', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCascader(
          options: [],
          size: AntCascaderSize.small,
          placeholder: '小',
        ),
      ),);
      final box = tester.getSize(find.byType(AntCascader));
      expect(box.height, lessThan(30));
    });
  });

  group('AntCascaderOption', () {
    test('isLeaf returns true when children is null or empty', () {
      const leaf1 = AntCascaderOption(value: 'a', label: 'A');
      expect(leaf1.isLeaf, isTrue);

      const leaf2 = AntCascaderOption(value: 'b', label: 'B', children: []);
      expect(leaf2.isLeaf, isTrue);
    });

    test('isLeaf returns false when children is non-empty', () {
      const parent = AntCascaderOption(value: 'a', label: 'A', children: [
        AntCascaderOption(value: 'a1', label: 'A1'),
      ],);
      expect(parent.isLeaf, isFalse);
    });

    test('disabled defaults to false', () {
      const opt = AntCascaderOption(value: 'a', label: 'A');
      expect(opt.disabled, isFalse);
    });
  });

  group('AntCascaderFieldNames', () {
    test('default constructor sets fields', () {
      const fn = AntCascaderFieldNames(
        label: 'name',
        value: 'id',
        children: 'subs',
      );
      expect(fn.label, 'name');
      expect(fn.value, 'id');
      expect(fn.children, 'subs');
    });
  });

    testWidgets('非叶子节点展开不回填触发框（antd 语义，非 changeOnSelect）', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          placeholder: '请选择',
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      // 点击非叶子节点"浙江"：仅展开子列，触发框仍显示占位文本
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsWidgets); // 子列已展开
      expect(find.text('浙江 / 杭州'), findsNothing); // 触发框未回填
      expect(find.text('请选择'), findsOneWidget); // 触发框保持占位
    });

    testWidgets('changeOnSelect 非叶子节点回填触发框', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCascader(
          options: _testOptions(),
          changeOnSelect: true,
          placeholder: '请选择',
        ),
      ),);
      await tester.tap(find.byType(AntCascader));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
    });
}
