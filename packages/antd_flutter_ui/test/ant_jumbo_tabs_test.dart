import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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
  group('AntJumboTabs — 渲染', () {
    testWidgets('渲染主标题和描述', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        items: [
          AntJumboTabItem(key: 'a', title: '全部', description: '所有订单'),
          AntJumboTabItem(key: 'b', title: '待付款', description: '等待付款'),
        ],
      ),),);

      expect(find.text('全部'), findsOneWidget);
      expect(find.text('所有订单'), findsOneWidget);
      expect(find.text('待付款'), findsOneWidget);
      expect(find.text('等待付款'), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        items: [
          AntJumboTabItem(key: 'a', titleWidget: Text('自定义标题')),
        ],
      ),),);

      expect(find.text('自定义标题'), findsOneWidget);
    });

    testWidgets('无 description 时不渲染描述', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        items: [
          AntJumboTabItem(key: 'a', title: '全部'),
        ],
      ),),);

      expect(find.text('全部'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('默认激活第一项', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        items: [
          AntJumboTabItem(key: 'a', title: '全部'),
          AntJumboTabItem(key: 'b', title: '待付款'),
        ],
      ),),);

      final textA = tester.widget<Text>(find.text('全部'));
      final textB = tester.widget<Text>(find.text('待付款'));
      expect(textA.style?.fontWeight, FontWeight.w600);
      expect(textB.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        defaultActiveKey: 'b',
        items: [
          AntJumboTabItem(key: 'a', title: '全部'),
          AntJumboTabItem(key: 'b', title: '待付款'),
        ],
      ),),);

      final textB = tester.widget<Text>(find.text('待付款'));
      expect(textB.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('激活项显示底部指示条', (tester) async {
      await tester.pumpWidget(_wrap(const AntJumboTabs(
        items: [
          AntJumboTabItem(key: 'a', title: '全部'),
          AntJumboTabItem(key: 'b', title: '待付款'),
        ],
      ),),);

      // 两个 AnimatedContainer（指示条）
      final indicators = find.byType(AnimatedContainer);
      expect(indicators, findsNWidgets(2));

      // a 激活 → 指示条有色
      final decoA = tester.widget<AnimatedContainer>(indicators.at(0)).decoration as BoxDecoration;
      expect(decoA.color, isNot(Colors.transparent));

      // b 非激活 → 指示条透明
      final decoB = tester.widget<AnimatedContainer>(indicators.at(1)).decoration as BoxDecoration;
      expect(decoB.color, Colors.transparent);
    });
  });

  group('AntJumboTabs — 交互', () {
    testWidgets('点击切换触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntJumboTabs(
          items: const [
            AntJumboTabItem(key: 'a', title: '全部'),
            AntJumboTabItem(key: 'b', title: '待付款'),
          ],
          onChange: (key) => setState(() => changed = key),
        ),),
      ),);

      await tester.tap(find.text('待付款'));
      await tester.pumpAndSettle();

      expect(changed, 'b');
    });

    testWidgets('受控模式由外部控制', (tester) async {
      String activeKey = 'a';
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntJumboTabs(
          activeKey: activeKey,
          items: const [
            AntJumboTabItem(key: 'a', title: '全部'),
            AntJumboTabItem(key: 'b', title: '待付款'),
          ],
          onChange: (key) => setState(() => activeKey = key),
        ),),
      ),);

      await tester.tap(find.text('待付款'));
      await tester.pumpAndSettle();

      expect(activeKey, 'b');
    });

    testWidgets('点击当前激活项不触发 onChange', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(AntJumboTabs(
        items: const [
          AntJumboTabItem(key: 'a', title: '全部'),
          AntJumboTabItem(key: 'b', title: '待付款'),
        ],
        onChange: (_) => callCount++,
      ),),);

      await tester.tap(find.text('全部'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('禁用项不可点击', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(AntJumboTabs(
        items: const [
          AntJumboTabItem(key: 'a', title: '全部'),
          AntJumboTabItem(key: 'b', title: '待付款', disabled: true),
        ],
        onChange: (_) => callCount++,
      ),),);

      await tester.tap(find.text('待付款'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });
}