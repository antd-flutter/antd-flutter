/// AntIndexBar widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _panelHeight = 300.0;
const _headerHeight = 35.0;

List<AntIndexBarItem> _items() => [
      for (final letter in ['A', 'B', 'C', 'D', 'E'])
        AntIndexBarItem(
          index: letter,
          title: '$letter 组',
          brief: letter,
          child: SizedBox(
            height: _panelHeight,
            child: Text('$letter 内容'),
          ),
        ),
    ];

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            child: AntTheme(
              data: AntThemeData.light(),
              child: Material(child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  group('AntIndexBar — 渲染', () {
    testWidgets('渲染分组标题与索引字母', (tester) async {
      await tester.pumpWidget(_wrap(AntIndexBar(items: _items())));

      expect(find.text('A 组'), findsOneWidget);
      expect(find.text('B 组'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('brief 决定索引字母，默认取 index 首字符', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntIndexBar(
            items: [
              AntIndexBarItem(index: 'A', title: 'A 组', brief: '阿'),
              AntIndexBarItem(index: 'B', title: 'B 组'),
            ],
          ),
        ),
      );

      expect(find.text('阿'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('首项默认高亮为圆形主色底', (tester) async {
      final theme = AntThemeData.light();
      await tester.pumpWidget(_wrap(AntIndexBar(items: _items())));

      final letter = tester.widget<Text>(find.text('A'));
      expect(letter.style?.color, theme.colorTextLightSolid);

      final circle = tester.widget<Container>(
        find.ancestor(
          of: find.text('A'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = circle.decoration! as BoxDecoration;
      expect(decoration.color, theme.colorPrimary);
      expect(decoration.shape, BoxShape.circle);

      // 非激活项为常规文字色、无底色。
      final other = tester.widget<Text>(find.text('B'));
      expect(other.style?.color, theme.colorTextTertiary);
    });
  });

  group('AntIndexBar — 交互', () {
    testWidgets('点击索引字母滚动到对应分组', (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(
        _wrap(AntIndexBar(items: _items(), onChange: changes.add)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      expect(changes.last, 'C');
      expect(
        tester.widget<Text>(find.text('C')).style?.color,
        AntThemeData.light().colorTextLightSolid,
      );

      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      // C 组顶 = 2 * (300 + 35)。
      expect(scrollable.position.pixels, closeTo(2 * (_panelHeight + _headerHeight), 1));
    });

    testWidgets('滚动内容时自动切换索引并回调', (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(
        _wrap(AntIndexBar(items: _items(), onChange: changes.add)),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(changes, isNotEmpty);
      expect(changes.last, 'B');
    });

    testWidgets('交互时显示气泡，松手后消失', (tester) async {
      await tester.pumpWidget(_wrap(AntIndexBar(items: _items())));
      await tester.pumpAndSettle();
      expect(find.text('B'), findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(find.text('B')));
      await tester.pump();

      // 气泡与索引字母各一个 B。
      expect(find.text('B'), findsNWidgets(2));

      await gesture.up();
      await tester.pump();
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('拖动索引条连续切换索引', (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(
        _wrap(AntIndexBar(items: _items(), onChange: changes.add)),
      );
      await tester.pumpAndSettle();

      final start = tester.getCenter(find.text('A'));
      final gesture = await tester.startGesture(start);
      await tester.pump();
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(const Offset(0, 16));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();

      expect(changes, containsAllInOrder(['B', 'C', 'D']));
      expect(changes.last, 'D');
    });
  });

  group('AntIndexBar — 吸顶', () {
    testWidgets('分组标题滚出后吸顶显示', (tester) async {
      await tester.pumpWidget(_wrap(AntIndexBar(items: _items())));
      await tester.pumpAndSettle();

      // 顶部时只有流式标题。
      expect(find.text('A 组'), findsOneWidget);

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();

      // 流式标题滚出，吸顶标题补充一份。
      expect(find.text('A 组'), findsNWidgets(2));
    });

    testWidgets('sticky=false 时不显示吸顶标题', (tester) async {
      await tester.pumpWidget(
        _wrap(AntIndexBar(items: _items(), sticky: false)),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();

      expect(find.text('A 组'), findsOneWidget);
    });
  });

  group('AntIndexBarController', () {
    testWidgets('scrollTo 跳转指定索引', (tester) async {
      final controller = AntIndexBarController();
      final changes = <String>[];
      await tester.pumpWidget(
        _wrap(
          AntIndexBar(
            items: _items(),
            controller: controller,
            onChange: changes.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      controller.scrollTo('D');
      await tester.pumpAndSettle();

      expect(changes.last, 'D');
      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(
        scrollable.position.pixels,
        closeTo(3 * (_panelHeight + _headerHeight), 1),
      );
    });
  });
}
