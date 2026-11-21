/// AntAnchor widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AntAnchor — 渲染', () {
    testWidgets('渲染空列表', (tester) async {
      await tester.pumpWidget(_wrap(const AntAnchor()));
      expect(find.byType(AntAnchor), findsOneWidget);
    });

    testWidgets('渲染垂直锚点项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [
              AntAnchorItem(key: 'part-1', title: 'Part 1'),
              AntAnchorItem(key: 'part-2', title: 'Part 2'),
            ],
          ),
        ),
      );
      expect(find.text('Part 1'), findsOneWidget);
      expect(find.text('Part 2'), findsOneWidget);
    });

    testWidgets('渲染嵌套子链接', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [
              AntAnchorItem(key: 'part-1', title: 'Part 1', children: [
                AntAnchorItem(key: 'part-1-1', title: 'Sub 1'),
                AntAnchorItem(key: 'part-1-2', title: 'Sub 2'),
              ],),
            ],
          ),
        ),
      );
      expect(find.text('Part 1'), findsOneWidget);
      expect(find.text('Sub 1'), findsOneWidget);
      expect(find.text('Sub 2'), findsOneWidget);
    });

    testWidgets('渲染水平锚点项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            direction: AntAnchorDirection.horizontal,
            items: [
              AntAnchorItem(key: 'a', title: '锚点 A'),
              AntAnchorItem(key: 'b', title: '锚点 B'),
            ],
          ),
        ),
      );
      expect(find.text('锚点 A'), findsOneWidget);
      expect(find.text('锚点 B'), findsOneWidget);
    });

    testWidgets('titleWidget 优先于 title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [
              AntAnchorItem(
                key: '1',
                title: '文字标题',
                titleWidget: Text('自定义标题'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('自定义标题'), findsOneWidget);
      expect(find.text('文字标题'), findsNothing);
    });

    testWidgets('无 title 时回退到 key', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [AntAnchorItem(key: 'fallback-key')],
          ),
        ),
      );
      expect(find.text('fallback-key'), findsOneWidget);
    });
  });

  group('AntAnchor — 点击与激活', () {
    testWidgets('点击触发 onClick', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntAnchor(
            items: const [
              AntAnchorItem(key: 'a', title: '锚点 A'),
            ],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );
      await tester.tap(find.text('锚点 A'));
      expect(clickedKey, 'a');
    });

    testWidgets('点击非受控模式设置激活项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [
              AntAnchorItem(key: 'a', title: '锚点 A'),
              AntAnchorItem(key: 'b', title: '锚点 B'),
            ],
          ),
        ),
      );
      // 初始无激活（激活态仅改变文字颜色，不渲染额外图标）

      await tester.tap(find.text('锚点 B'));
      await tester.pumpAndSettle();

      // 激活项文字颜色为主题色
      final text = tester.widget<Text>(find.text('锚点 B'));
      final theme = AntThemeData.light();
      expect(text.style?.color, theme.colorPrimary);
    });

    testWidgets('onChange 激活变化回调', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        _wrap(
          AntAnchor(
            items: const [
              AntAnchorItem(key: 'a', title: '锚点 A'),
              AntAnchorItem(key: 'b', title: '锚点 B'),
            ],
            onChange: (key) => changedKey = key,
          ),
        ),
      );
      await tester.tap(find.text('锚点 A'));
      await tester.pumpAndSettle();
      expect(changedKey, 'a');

      await tester.tap(find.text('锚点 B'));
      await tester.pumpAndSettle();
      expect(changedKey, 'b');
    });

    testWidgets('受控 controller 设置激活项', (tester) async {
      final controller = AntAnchorController();
      await tester.pumpWidget(
        _wrap(
          AntAnchor(
            controller: controller,
            items: const [
              AntAnchorItem(key: 'a', title: '锚点 A'),
              AntAnchorItem(key: 'b', title: '锚点 B'),
            ],
          ),
        ),
      );

      controller.setActive('b');
      await tester.pumpAndSettle();

      final theme = AntThemeData.light();
      final textB = tester.widget<Text>(find.text('锚点 B'));
      expect(textB.style?.color, theme.colorPrimary);
      final textA = tester.widget<Text>(find.text('锚点 A'));
      expect(textA.style?.color, theme.colorTextSecondary);
    });

    testWidgets('点击嵌套子链接激活子项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            items: [
              AntAnchorItem(key: 'part-1', title: 'Part 1', children: [
                AntAnchorItem(key: 'sub-1', title: 'Sub 1'),
              ],),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Sub 1'));
      await tester.pumpAndSettle();

      final theme = AntThemeData.light();
      final text = tester.widget<Text>(find.text('Sub 1'));
      expect(text.style?.color, theme.colorPrimary);
    });
  });

  group('AntAnchor — 水平模式', () {
    testWidgets('水平模式点击激活有底部边框', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAnchor(
            direction: AntAnchorDirection.horizontal,
            items: [
              AntAnchorItem(key: 'a', title: '锚点 A'),
              AntAnchorItem(key: 'b', title: '锚点 B'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('锚点 A'));
      await tester.pumpAndSettle();

      // 激活项文字为主题色
      final theme = AntThemeData.light();
      final text = tester.widget<Text>(find.text('锚点 A'));
      expect(text.style?.color, theme.colorPrimary);
    });

    testWidgets('水平模式点击触发 onClick', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntAnchor(
            direction: AntAnchorDirection.horizontal,
            items: const [
              AntAnchorItem(key: 'x', title: '水平项'),
            ],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );
      await tester.tap(find.text('水平项'));
      expect(clickedKey, 'x');
    });
  });

  group('AntAnchor — 滚动联动', _scrollLinkTests);

  group('AntAnchorController', () {
    test('setActive 相同值不通知', () {
      final controller = AntAnchorController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.setActive('a');
      expect(notifyCount, 1);
      controller.setActive('a');
      expect(notifyCount, 1);
      controller.setActive('b');
      expect(notifyCount, 2);
      controller.setActive(null);
      expect(notifyCount, 3);
    });

    test('activeKey 初始为 null', () {
      final controller = AntAnchorController();
      expect(controller.activeKey, isNull);
    });
  });
}
// ============================================================
// 滚动联动
// ============================================================

Widget _linkedHarness({
  required ScrollController scrollController,
  required AntAnchorController anchorController,
  required Map<String, GlobalKey> keys,
  double topOffset = 0,
}) {
  return _wrap(
    SizedBox(
      height: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: AntAnchor(
              controller: anchorController,
              scrollController: scrollController,
              targetKeys: keys,
              topOffset: topOffset,
              scrollDuration: const Duration(milliseconds: 50),
              items: const [
                AntAnchorItem(key: 'a', title: 'A'),
                AntAnchorItem(key: 'b', title: 'B'),
                AntAnchorItem(key: 'c', title: 'C'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  for (final key in ['a', 'b', 'c'])
                    Container(
                      key: keys[key],
                      height: 400,
                      color: Colors.grey.shade100,
                      alignment: Alignment.topLeft,
                      child: Text('Section ${key.toUpperCase()}'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _scrollLinkTests() {
  testWidgets('点击锚点滚动到目标区块', (tester) async {
    final scroll = ScrollController();
    final anchor = AntAnchorController();
    final keys = {'a': GlobalKey(), 'b': GlobalKey(), 'c': GlobalKey()};
    addTearDown(scroll.dispose);
    addTearDown(anchor.dispose);

    await tester.pumpWidget(
      _linkedHarness(scrollController: scroll, anchorController: anchor, keys: keys),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(anchor.activeKey, 'b');
    expect(scroll.offset, greaterThanOrEqualTo(399));
  });

  testWidgets('滚动页面时高亮跟随可视区块', (tester) async {
    final scroll = ScrollController();
    final anchor = AntAnchorController();
    final keys = {'a': GlobalKey(), 'b': GlobalKey(), 'c': GlobalKey()};
    addTearDown(scroll.dispose);
    addTearDown(anchor.dispose);

    await tester.pumpWidget(
      _linkedHarness(scrollController: scroll, anchorController: anchor, keys: keys),
    );
    await tester.pumpAndSettle();
    expect(anchor.activeKey, 'a');

    scroll.jumpTo(410);
    await tester.pump();
    expect(anchor.activeKey, 'b');

    scroll.jumpTo(810);
    await tester.pump();
    expect(anchor.activeKey, 'c');
  });

  testWidgets('topOffset 预留顶部偏移', (tester) async {
    final scroll = ScrollController();
    final anchor = AntAnchorController();
    final keys = {'a': GlobalKey(), 'b': GlobalKey(), 'c': GlobalKey()};
    addTearDown(scroll.dispose);
    addTearDown(anchor.dispose);

    await tester.pumpWidget(
      _linkedHarness(
        scrollController: scroll,
        anchorController: anchor,
        keys: keys,
        topOffset: 40,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();

    expect(anchor.activeKey, 'c');
    final target = keys['c']!.currentContext!.findRenderObject()!;
    final viewport = RenderAbstractViewport.of(target);
    final reveal = viewport.getOffsetToReveal(target, 0).offset;
    expect((scroll.offset - (reveal - 40)).abs(), lessThan(1));
  });
}
