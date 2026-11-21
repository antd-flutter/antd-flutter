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

class _Option {
  const _Option(this.id, this.label, {this.children = const <_Option>[]});

  final int id;
  final String label;
  final List<_Option> children;
}

List<_Option> _options() => const [
      _Option(
        1,
        '浙江',
        children: [
          _Option(
            2,
            '杭州',
            children: [
              _Option(3, '西湖区'),
              _Option(4, '临安区'),
            ],
          ),
          _Option(5, '宁波'),
        ],
      ),
      _Option(
        6,
        '江苏',
        children: [
          _Option(7, '南京'),
          _Option(8, '苏州'),
        ],
      ),
      _Option(9, '广东'),
    ];

Widget _wrap({required bool dark, required Widget child}) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: dark ? AntThemeData.dark() : AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

AntTreeSelect<_Option> _treeSelect({
  Object? value,
  Object? defaultValue,
  bool multiple = false,
  bool expandAll = false,
}) {
  return AntTreeSelect<_Option>(
    dataSource: _options(),
    keyOf: (option) => option.id,
    labelOf: (option) => option.label,
    titleBuilder: (context, option) => Text(option.label),
    childrenOf: (option) => option.children,
    value: value,
    defaultValue: defaultValue,
    multiple: multiple,
    treeDefaultExpandAll: expandAll,
  );
}

void _expectGolden(String name) {
  final dir = Directory('goldens');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  // 基线由 macOS 生成，Linux/Windows runner 字体栅格化不同，CI 上跳过。
  group('TreeSelect golden probes', () {
    testWidgets('probe: 默认树（单层展开）', (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _wrap(
          dark: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _treeSelect(value: 2),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntTreeSelect<_Option>));
      await tester.pumpAndSettle();
      _expectGolden('probe_default_tree');
    });

    testWidgets('probe: 勾选树（多选勾选）', (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _wrap(
          dark: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _treeSelect(
                multiple: true,
                defaultValue: <Object>[7, 8],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntTreeSelect<_Option>));
      await tester.pumpAndSettle();
      _expectGolden('probe_checkable_tree');
    });

    testWidgets('probe: 多级展开（两级子节点全展开）', (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _wrap(
          dark: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _treeSelect(expandAll: true),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntTreeSelect<_Option>));
      await tester.pumpAndSettle();
      _expectGolden('probe_expanded_tree');
    });

    testWidgets('probe: 暗色模式（token 正确性）', (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _wrap(
          dark: true,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _treeSelect(
                expandAll: true,
                defaultValue: 7,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntTreeSelect<_Option>));
      await tester.pumpAndSettle();
      _expectGolden('probe_dark_tree');
    });
  }, skip: !Platform.isMacOS,);
}
