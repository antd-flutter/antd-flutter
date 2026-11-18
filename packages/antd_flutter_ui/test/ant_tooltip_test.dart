/// AntTooltip widget 测试
library;

import 'package:antd_flutter_ui/src/basic/tooltip/ant_tooltip.dart';
import 'package:antd_flutter_ui/src/basic/tooltip/ant_tooltip_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 气泡内容定位辅助。
Finder findBubble(String text) => find.descendant(
      of: find.byKey(const Key('ant_tooltip_content')),
      matching: find.text(text),
    );

/// 触发元素定位辅助。
Finder findTrigger(String text) => find.text(text);

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AntTooltip — 基础渲染', () {
    testWidgets('默认不显示气泡', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            tooltip: Text('提示文案'),
            child: Text('触发'),
          ),
        ),
      );
      expect(findBubble('提示文案'), findsNothing);
      expect(findTrigger('触发'), findsOneWidget);
    });

    testWidgets('defaultOpen 非受控默认显示', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            defaultOpen: true,
            tooltip: Text('默认打开'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('默认打开'), findsOneWidget);
    });

    testWidgets('Widget 气泡内容渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            defaultOpen: true,
            tooltip: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.info), Text('带图标提示')],
            ),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('带图标提示'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('点击空白处关闭气泡', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            defaultOpen: true,
            tooltip: Text('点击关闭'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('点击关闭'), findsOneWidget);

      // 点击触发元素之外的区域
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(findBubble('点击关闭'), findsNothing);
    });
  });

  group('AntTooltip — placement 弹出位置', () {
    Future<void> pumpPlacement(
      WidgetTester tester,
      AntTooltipPlacement placement,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AntTooltip(
            open: true,
            placement: placement,
            tooltip: const Text('位置提示'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('top 气泡在触发元素上方', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.top);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dy, lessThan(childCenter.dy));
    });

    testWidgets('bottom 气泡在触发元素下方', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.bottom);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dy, greaterThan(childCenter.dy));
    });

    testWidgets('left 气泡在触发元素左侧', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.left);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dx, lessThan(childCenter.dx));
    });

    testWidgets('right 气泡在触发元素右侧', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.right);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dx, greaterThan(childCenter.dx));
    });

    testWidgets('topLeft 左对齐（左边缘接近触发元素左边缘）', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.topLeft);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dy, lessThan(childCenter.dy));
      // 左对齐时气泡中心偏向触发元素中心左侧
      final bubbleLeft = tester.getTopLeft(findBubble('位置提示')).dx;
      final childLeft = tester.getTopLeft(findTrigger('触发')).dx;
      expect((bubbleLeft - childLeft).abs(), lessThan(20));
    });

    testWidgets('bottomRight 右对齐', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.bottomRight);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dy, greaterThan(childCenter.dy));
      final bubbleRight = tester.getTopRight(findBubble('位置提示')).dx;
      final childRight = tester.getTopRight(findTrigger('触发')).dx;
      expect((bubbleRight - childRight).abs(), lessThan(20));
    });

    testWidgets('leftTop 顶部对齐（纵向边缘接近）', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.leftTop);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dx, lessThan(childCenter.dx));
      final bubbleTop = tester.getTopLeft(findBubble('位置提示')).dy;
      final childTop = tester.getTopLeft(findTrigger('触发')).dy;
      expect((bubbleTop - childTop).abs(), lessThan(20));
    });

    testWidgets('rightBottom 底部对齐', (tester) async {
      await pumpPlacement(tester, AntTooltipPlacement.rightBottom);
      final bubbleCenter = tester.getCenter(findBubble('位置提示'));
      final childCenter = tester.getCenter(findTrigger('触发'));
      expect(bubbleCenter.dx, greaterThan(childCenter.dx));
      final bubbleBottom = tester.getBottomRight(findBubble('位置提示')).dy;
      final childBottom = tester.getBottomRight(findTrigger('触发')).dy;
      expect((bubbleBottom - childBottom).abs(), lessThan(20));
    });
  });

  group('AntTooltip — 受控 / 非受控', () {
    testWidgets('open=true 受控显示', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            tooltip: Text('受控提示'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('受控提示'), findsOneWidget);
    });

    testWidgets('open=false 受控隐藏，点击不改变', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: false,
            trigger: AntTooltipTrigger.click,
            tooltip: Text('受控隐藏'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('受控隐藏'), findsNothing);
    });

    testWidgets('受控 open 变化联动显隐', (tester) async {
      bool open = true;
      late StateSetter setState;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return AntTooltip(
                open: open,
                tooltip: const Text('联动提示'),
                child: const Text('触发'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('联动提示'), findsOneWidget);

      setState(() => open = false);
      await tester.pumpAndSettle();
      expect(findBubble('联动提示'), findsNothing);
    });

    testWidgets('受控 open false→true 切换显示（build 阶段 setState 联动回归）', (tester) async {
      // 回归：didUpdateWidget 中直接 Overlay.insert 会在父级 build 阶段触发
      // markNeedsBuild during build 异常（example 受控 demo 场景）
      bool open = false;
      late StateSetter setState;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return AntTooltip(
                open: open,
                onOpenChange: (value) => setState(() => open = value),
                tooltip: const Text('受控气泡'),
                child: const Text('受控触发'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('受控气泡'), findsNothing);

      setState(() => open = true);
      await tester.pumpAndSettle();
      expect(findBubble('受控气泡'), findsOneWidget);

      setState(() => open = false);
      await tester.pumpAndSettle();
      expect(findBubble('受控气泡'), findsNothing);
    });

    testWidgets('受控切换触发 onOpenChange 回调', (tester) async {
      final states = <bool>[];
      bool open = false;
      late StateSetter setState;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return AntTooltip(
                open: open,
                onOpenChange: states.add,
                tooltip: const Text('回调联动'),
                child: const Text('受控触发'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      setState(() => open = true);
      await tester.pumpAndSettle();
      // onOpenChange 由组件显隐操作触发（点击受控元素时回调）
      await tester.tap(findTrigger('受控触发'));
      await tester.pumpAndSettle();
      // 受控模式下点击不改变 open（由外部状态驱动），回调仍上报 false 语义
      expect(states, isNotEmpty);
    });

    testWidgets('defaultOpen=false 默认隐藏', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            tooltip: Text('非受控提示'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(findBubble('非受控提示'), findsNothing);
    });

    testWidgets('onOpenChange 回调触发', (tester) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(
          AntTooltip(
            trigger: AntTooltipTrigger.click,
            onOpenChange: states.add,
            tooltip: const Text('回调提示'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(states, contains(true));

      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(states, contains(false));
    });
  });

  group('AntTooltip — 触发方式', () {
    testWidgets('click 触发点击打开/关闭', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.click,
            tooltip: Text('点击提示'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('点击提示'), findsOneWidget);

      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('点击提示'), findsNothing);
    });

    testWidgets('click 触发移动端长按打开', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.click,
            tooltip: Text('长按提示'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.longPress(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('长按提示'), findsOneWidget);
    });

    testWidgets('hover 触发悬停打开，移出关闭', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.hover,
            mouseEnterDelay: Duration.zero,
            mouseLeaveDelay: Duration.zero,
            tooltip: Text('悬停提示'),
            child: Text('触发'),
          ),
        ),
      );
      expect(findBubble('悬停提示'), findsNothing);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(findTrigger('触发')));
      await tester.pumpAndSettle();
      expect(findBubble('悬停提示'), findsOneWidget);

      await gesture.moveTo(const Offset(600, 500));
      await tester.pumpAndSettle();
      expect(findBubble('悬停提示'), findsNothing);
    });

    testWidgets('hover 延迟生效（mouseEnterDelay 内不显示）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.hover,
            mouseEnterDelay: Duration(milliseconds: 500),
            mouseLeaveDelay: Duration.zero,
            tooltip: Text('延迟提示'),
            child: Text('触发'),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(findTrigger('触发')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(findBubble('延迟提示'), findsNothing);

      await tester.pump(const Duration(milliseconds: 600));
      expect(findBubble('延迟提示'), findsOneWidget);
    });

    testWidgets('快速移动：enter 延迟窗口内移出，气泡不出现', (tester) async {
      // 回归：移出时未取消 pending 的 enter 计时器，导致延迟到期后
      // 气泡弹出且再无 exit 事件关闭
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.hover,
            mouseEnterDelay: Duration(milliseconds: 300),
            mouseLeaveDelay: Duration.zero,
            tooltip: Text('快速移出'),
            child: Text('悬停目标'),
          ),
        ),
      );
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(findTrigger('悬停目标')));
      await tester.pump(const Duration(milliseconds: 100));

      // 在 enter 延迟窗口内快速大幅移开
      await gesture.moveTo(const Offset(700, 500));
      await tester.pump(const Duration(milliseconds: 600));
      expect(findBubble('快速移出'), findsNothing);
    });

    testWidgets('快速移动：气泡打开后大幅移开必消失', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.hover,
            mouseEnterDelay: Duration.zero,
            mouseLeaveDelay: Duration(milliseconds: 100),
            tooltip: Text('大幅移开'),
            child: Text('悬停目标'),
          ),
        ),
      );
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(findTrigger('悬停目标')));
      await tester.pumpAndSettle();
      expect(findBubble('大幅移开'), findsOneWidget);

      // 单次 moveTo 大幅移开（模拟快速移动，exit 事件仍必达）
      await gesture.moveTo(const Offset(700, 550));
      await tester.pumpAndSettle();
      expect(findBubble('大幅移开'), findsNothing);
    });

    testWidgets('focus 触发聚焦打开，失焦关闭', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            trigger: AntTooltipTrigger.focus,
            tooltip: Text('聚焦提示'),
            child: Text('触发'),
          ),
        ),
      );
      expect(findBubble('聚焦提示'), findsNothing);

      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('聚焦提示'), findsOneWidget);
    });
  });

  group('AntTooltip — 箭头与样式', () {
    testWidgets('arrow=true 显示箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            arrow: true,
            tooltip: Text('带箭头'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ant_tooltip_arrow')), findsOneWidget);
    });

    testWidgets('arrow=false 不显示箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            arrow: false,
            tooltip: Text('无箭头'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ant_tooltip_arrow')), findsNothing);
    });

    testWidgets('color 自定义背景色', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            color: Colors.purple,
            tooltip: Text('紫色气泡'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find.byKey(const Key('ant_tooltip_content')),
      );
      expect(container.decoration, isA<BoxDecoration>());
      expect(
        (container.decoration! as BoxDecoration).color,
        Colors.purple,
      );
    });

    testWidgets('overlayStyle 覆盖容器装饰', (tester) async {
      const style = BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      );
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            overlayStyle: style,
            tooltip: Text('样式气泡'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find.byKey(const Key('ant_tooltip_content')),
      );
      expect(container.decoration, same(style));
    });

    testWidgets('自定义 color 下文字颜色对比取反', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntTooltip(
            open: true,
            color: Colors.yellow,
            tooltip: Text('黄色气泡'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final defaultStyle = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: findBubble('黄色气泡'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      // 浅色背景上文字应为深色
      expect(defaultStyle.style.color, const Color(0xFF141414));
    });
  });
}
