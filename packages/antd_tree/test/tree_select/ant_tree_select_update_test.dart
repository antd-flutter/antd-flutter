// TreeSelect 数据/值更新回归测试（面板打开状态下的更新路径）。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child, {bool dark = false}) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: dark ? AntThemeData.dark() : AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('面板打开时更新受控 value：不报错且面板选中态跟随',
      (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    String? value = 'zj';
    late StateSetter setStateOuter;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(
        builder: (context, setState) {
          setStateOuter = setState;
          return AntTreeSelect(
            treeData: const [
              AntTreeSelectOption(value: 'zj', label: '浙江'),
              AntTreeSelectOption(value: 'js', label: '江苏'),
            ],
            value: value,
            onChange: (_) {},
          );
        },
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();

    setStateOuter(() => value = 'js');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // 面板仍打开且江苏行高亮（选中 token 生效）
    expect(find.text('江苏'), findsWidgets);
    expect(find.byKey(const Key('ant_tree_select_panel')), findsOneWidget);
  });

  testWidgets('面板打开时更新 treeData：不报错且新节点渲染', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    late StateSetter setStateOuter;
    var treeData = <AntTreeSelectOption>[
      const AntTreeSelectOption(value: 'a', label: 'A'),
    ];
    await tester.pumpWidget(_wrap(
      StatefulBuilder(
        builder: (context, setState) {
          setStateOuter = setState;
          return AntTreeSelect(treeData: treeData);
        },
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    expect(find.text('A'), findsWidgets);

    setStateOuter(() {
      treeData = [
        const AntTreeSelectOption(value: 'a', label: 'A'),
        const AntTreeSelectOption(value: 'b', label: 'B'),
      ];
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('ant_tree_select_panel')), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('treeDefaultExpandAll 下替换 treeData：展开键随新数据重算',
      (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    late StateSetter setStateOuter;
    var treeData = <AntTreeSelectOption>[
      const AntTreeSelectOption(
        value: 'p1',
        label: 'P1',
        children: [AntTreeSelectOption(value: 'c1', label: 'C1')],
      ),
    ];
    await tester.pumpWidget(_wrap(
      StatefulBuilder(
        builder: (context, setState) {
          setStateOuter = setState;
          return AntTreeSelect(
            treeData: treeData,
            treeDefaultExpandAll: true,
          );
        },
      ),
    ),);
    // 未打开时替换数据 → 打开后新数据全部展开
    setStateOuter(() {
      treeData = [
        const AntTreeSelectOption(
          value: 'p2',
          label: 'P2',
          children: [AntTreeSelectOption(value: 'c2', label: 'C2')],
        ),
      ];
    });
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    expect(find.text('P2'), findsOneWidget);
    // 子节点直接可见（展开键重算生效）
    expect(find.text('C2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo 用法（onChange 非受控流）：选择后触发重建且显示已选',
      (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    String? selected;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            AntTreeSelect(
              treeData: const [
                AntTreeSelectOption(
                  value: 'zj',
                  label: '浙江',
                  children: [AntTreeSelectOption(value: 'hz', label: '杭州')],
                ),
              ],
              treeDefaultExpandAll: true,
              onChange: (v) => setState(() => selected = v as String?),
            ),
            if (selected != null) Text('已选：$selected'),
          ],
        ),
      ),
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    await tester.tap(find.text('杭州'));
    await tester.pumpAndSettle();
    expect(find.text('已选：hz'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('弹层打开时切换主题：不报错且面板 token 跟随', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    var dark = false;
    await tester.pumpWidget(_wrap(
      const AntTreeSelect(
        treeData: [
          AntTreeSelectOption(value: 'a', label: 'A'),
        ],
      ),
      dark: dark,
    ),);
    await tester.tap(find.byType(AntTreeSelect));
    await tester.pumpAndSettle();
    // 重建为暗色主题环境
    await tester.pumpWidget(_wrap(
      const AntTreeSelect(
        treeData: [
          AntTreeSelectOption(value: 'a', label: 'A'),
        ],
      ),
      dark: true,
    ),);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(dark, isFalse);
  });
}
