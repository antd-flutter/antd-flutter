import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  group('AntCapsuleTabs — 渲染', () {
    testWidgets('渲染所有项标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntCapsuleTabs(
        items: [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二'),
        ],
      )));

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(_wrap(const AntCapsuleTabs(
        items: [
          AntCapsuleTabItem(key: 'a', titleWidget: Text('自定义')),
        ],
      )));

      expect(find.text('自定义'), findsOneWidget);
    });

    testWidgets('默认激活第一项', (tester) async {
      await tester.pumpWidget(_wrap(const AntCapsuleTabs(
        items: [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二'),
        ],
      )));

      final textA = tester.widget<Text>(find.text('选项一'));
      final textB = tester.widget<Text>(find.text('选项二'));
      expect(textA.style?.fontWeight, FontWeight.w600);
      expect(textB.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(_wrap(const AntCapsuleTabs(
        defaultActiveKey: 'b',
        items: [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二'),
        ],
      )));

      final textB = tester.widget<Text>(find.text('选项二'));
      expect(textB.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('激活项有阴影，非激活无阴影', (tester) async {
      await tester.pumpWidget(_wrap(const AntCapsuleTabs(
        items: [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二'),
        ],
      )));

      // 两个 AnimatedContainer（胶囊项）
      final containers = find.byType(AnimatedContainer);
      expect(containers, findsNWidgets(2));

      final decoA =
          tester.widget<AnimatedContainer>(containers.at(0)).decoration as BoxDecoration;
      final decoB =
          tester.widget<AnimatedContainer>(containers.at(1)).decoration as BoxDecoration;

      // a 激活 → 有阴影
      expect(decoA.boxShadow, isNotNull);
      // b 非激活 → 无阴影
      expect(decoB.boxShadow, isNull);
    });
  });

  group('AntCapsuleTabs — 交互', () {
    testWidgets('点击切换触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntCapsuleTabs(
          items: const [
            AntCapsuleTabItem(key: 'a', title: '选项一'),
            AntCapsuleTabItem(key: 'b', title: '选项二'),
          ],
          onChange: (key) => setState(() => changed = key),
        )),
      ));

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(changed, 'b');
    });

    testWidgets('受控模式由外部控制', (tester) async {
      String activeKey = 'a';
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntCapsuleTabs(
          activeKey: activeKey,
          items: const [
            AntCapsuleTabItem(key: 'a', title: '选项一'),
            AntCapsuleTabItem(key: 'b', title: '选项二'),
          ],
          onChange: (key) => setState(() => activeKey = key),
        )),
      ));

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(activeKey, 'b');
    });

    testWidgets('点击当前激活项不触发 onChange', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(AntCapsuleTabs(
        items: const [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二'),
        ],
        onChange: (_) => callCount++,
      )));

      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('禁用项不可点击', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(AntCapsuleTabs(
        items: const [
          AntCapsuleTabItem(key: 'a', title: '选项一'),
          AntCapsuleTabItem(key: 'b', title: '选项二', disabled: true),
        ],
        onChange: (_) => callCount++,
      )));

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });
}