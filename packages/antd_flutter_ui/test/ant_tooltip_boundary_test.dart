/// 弹层边界翻转 widget 测试 — tooltip 贴近视口边缘自动翻向，不溢出视口
///
/// 验证统一弹层底座 popup_engine 的方向决策在组件层的生效。
library;

import 'package:antd_flutter_ui/src/basic/tooltip/ant_tooltip.dart';
import 'package:antd_flutter_ui/src/basic/tooltip/ant_tooltip_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _triggerKey = Key('boundary-trigger');

/// 气泡内容定位辅助。
Finder findBubble(String text) => find.descendant(
      of: find.byKey(const Key('ant_tooltip_content')),
      matching: find.text(text),
    );

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

void main() {
  group('AntTooltip — 边界翻转（popup_engine 方向决策）', () {
    testWidgets('贴近视口底部：placement bottom 自动翻向上方', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.bottomCenter,
            child: AntTooltip(
              key: Key('tooltip-near-bottom'),
              defaultOpen: true,
              placement: AntTooltipPlacement.bottom,
              tooltip: Text('底部翻转'),
              child: SizedBox(
                key: _triggerKey,
                width: 80,
                height: 32,
                child: ColoredBox(color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerBottom = tester.getBottomRight(find.byKey(_triggerKey)).dy;
      final bubbleTop = tester.getTopLeft(findBubble('底部翻转')).dy;
      // 放不下 bottom → 翻到上方：气泡顶缘在触发元素底缘之上
      expect(bubbleTop, lessThan(triggerBottom));
      // 不溢出视口底部
      expect(bubbleTop, greaterThanOrEqualTo(0));
    });

    testWidgets('贴近视口顶部：placement top 自动翻向下方', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.topCenter,
            child: AntTooltip(
              key: Key('tooltip-near-top'),
              defaultOpen: true,
              placement: AntTooltipPlacement.top,
              tooltip: Text('顶部翻转'),
              child: SizedBox(
                key: _triggerKey,
                width: 80,
                height: 24,
                child: ColoredBox(color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerTop = tester.getTopLeft(find.byKey(_triggerKey)).dy;
      final bubbleBottom = tester.getBottomRight(findBubble('顶部翻转')).dy;
      // 放不下 top → 翻到下方：气泡底缘在触发元素顶缘之下
      expect(bubbleBottom, greaterThan(triggerTop));
    });

    testWidgets('贴近视口右缘：placement right 自动翻向左侧，不溢出视口', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.centerRight,
            child: AntTooltip(
              key: Key('tooltip-near-right'),
              defaultOpen: true,
              placement: AntTooltipPlacement.right,
              tooltip: Text('右侧翻转'),
              child: SizedBox(
                key: _triggerKey,
                width: 40,
                height: 32,
                child: ColoredBox(color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerRight = tester.getBottomRight(find.byKey(_triggerKey)).dx;
      final bubbleRect = tester.getRect(findBubble('右侧翻转'));
      // 放不下 right → 翻到左侧
      expect(bubbleRect.right, lessThan(triggerRight));
      // 不溢出视口右缘
      expect(bubbleRect.right, lessThanOrEqualTo(800));
    });

    testWidgets('视口内正常 placement 不翻转', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.center,
            child: AntTooltip(
              key: Key('tooltip-center'),
              defaultOpen: true,
              placement: AntTooltipPlacement.bottom,
              tooltip: Text('居中不翻转'),
              child: SizedBox(
                key: _triggerKey,
                width: 80,
                height: 32,
                child: ColoredBox(color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerBottom = tester.getBottomRight(find.byKey(_triggerKey)).dy;
      final bubbleTop = tester.getTopLeft(findBubble('居中不翻转')).dy;
      // 居中时 bottom 放得下，保持不翻转
      expect(bubbleTop, greaterThan(triggerBottom));
    });
  });
}
