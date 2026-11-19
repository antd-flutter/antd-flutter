// 探针出图：TreeSelect 弹层基座渲染四场景对比（默认树/勾选树/多级展开/暗色）。
//
// 运行：flutter test --update-goldens test/tree_select/probe_golden_test.dart
// 产物：test/tree_select/goldens/probe_*.png（人工目检渲染缺陷）。
library;

import 'dart:io';

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

List<AntTreeSelectOption> _options() => [
      const AntTreeSelectOption(value: 'zj', label: '浙江', children: [
        AntTreeSelectOption(value: 'hz', label: '杭州', children: [
          AntTreeSelectOption(value: 'xh', label: '西湖区'),
          AntTreeSelectOption(value: 'lc', label: '临安区'),
        ],),
        AntTreeSelectOption(value: 'nb', label: '宁波'),
      ],),
      const AntTreeSelectOption(value: 'js', label: '江苏', children: [
        AntTreeSelectOption(value: 'nj', label: '南京'),
        AntTreeSelectOption(value: 'sz', label: '苏州'),
      ],),
      const AntTreeSelectOption(value: 'gd', label: '广东'),
    ];

Widget _wrap({required bool dark, required Widget child}) =>
    AntScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: dark ? AntThemeData.dark() : AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void _expectGolden(String name) {
  final dir = Directory('goldens');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  testWidgets('probe: 默认树（单层展开）', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(_wrap(
      dark: false,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AntTreeSelect(treeData: _options(), value: 'hz'),
        ),
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    _expectGolden('probe_default_tree');
  });

  testWidgets('probe: 勾选树（多选勾选）', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(_wrap(
      dark: false,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AntTreeSelect(
            treeData: _options(),
            multiple: true,
            defaultValue: ['nj', 'sz'],
          ),
        ),
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    _expectGolden('probe_checkable_tree');
  });

  testWidgets('probe: 多级展开（两级子节点全展开）', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(_wrap(
      dark: false,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AntTreeSelect(
            treeData: _options(),
            treeDefaultExpandAll: true,
          ),
        ),
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    _expectGolden('probe_expanded_tree');
  });

  testWidgets('probe: 暗色模式（token 正确性）', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(_wrap(
      dark: true,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AntTreeSelect(
            treeData: _options(),
            treeDefaultExpandAll: true,
            defaultValue: 'nj',
          ),
        ),
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    _expectGolden('probe_dark_tree');
  });
}
