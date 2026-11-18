/// AntPopover widget 测试
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
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
/// 桌面 hover 用例辅助：显式切到 macOS 平台（flutter_test 默认 android，
/// 会被平台降级逻辑判定为移动端），仅在 pumpWidget 期间生效。
Future<void> _pumpDesktop(WidgetTester tester, Widget child) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  try {
    await tester.pumpWidget(_wrap(child));
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}


const _bubbleKey = Key('AntPopoverBubble');
const _arrowKey = Key('AntPopoverArrow');

void main() {
  group('AntPopover — 渲染', () {
    testWidgets('基础渲染：defaultOpen 展示 title 与 content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            title: Text('标题'),
            content: Text('气泡内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('气泡内容'), findsOneWidget);
    });

    testWidgets('默认不展示气泡', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            content: Text('气泡内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsNothing);
      expect(find.text('触发'), findsOneWidget);
    });

    testWidgets('无 title 时不渲染标题区', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            content: Text('只有内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('只有内容'), findsOneWidget);
    });

    testWidgets('气泡容器存在且为卡片样式', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            content: Text('卡片内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bubble = tester.widget(find.byKey(_bubbleKey));
      expect(bubble, isNotNull);
    });
  });

  group('AntPopover — 悬停触发', () {
    testWidgets('悬停打开，移出关闭', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await _pumpDesktop(tester,
        _wrap(
          const AntPopover(
            trigger: AntPopoverTrigger.hover,
            content: Text('悬停内容'),
            child: Text('悬停'),
          ),
        )
      );
      debugDefaultTargetPlatformOverride = null;
      expect(find.text('悬停内容'), findsNothing);

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: tester.getCenter(find.text('悬停')));
      await tester.pumpAndSettle();
      expect(find.text('悬停内容'), findsOneWidget);

      await gesture.moveTo(const Offset(500, 500));
      await tester.pumpAndSettle();
      expect(find.text('悬停内容'), findsNothing);
    });
  });

  group('AntPopover — 点击触发', () {
    testWidgets('点击打开，再次点击关闭', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            trigger: AntPopoverTrigger.click,
            content: Text('点击内容'),
            child: Text('点击触发'),
          ),
        ),
      );
      await tester.tap(find.text('点击触发'));
      await tester.pumpAndSettle();
      expect(find.text('点击内容'), findsOneWidget);

      await tester.tap(find.text('点击触发'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('点击内容'), findsNothing);
    });

    testWidgets('点击触发 onOpenChange 回调', (tester) async {
      var openState = false;
      await tester.pumpWidget(
        _wrap(
          AntPopover(
            trigger: AntPopoverTrigger.click,
            onOpenChange: (v) => openState = v,
            content: const Text('回调内容'),
            child: const Text('点击触发'),
          ),
        ),
      );
      await tester.tap(find.text('点击触发'));
      await tester.pumpAndSettle();
      expect(openState, isTrue);
    });

    testWidgets('disabled 时不弹出', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            trigger: AntPopoverTrigger.click,
            disabled: true,
            content: Text('禁用内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      expect(find.text('禁用内容'), findsNothing);
    });
  });

  group('AntPopover — 受控模式', () {
    testWidgets('open=true 受控展示', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            open: true,
            content: Text('受控内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('受控内容'), findsOneWidget);
    });

    testWidgets('open=false 受控隐藏且点击无效', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            open: false,
            trigger: AntPopoverTrigger.click,
            content: Text('受控内容'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      expect(find.text('受控内容'), findsNothing);
    });
  });

  group('AntPopover — placement 方向', () {
    Future<void> pumpPlacement(
      WidgetTester tester,
      AntPopoverPlacement placement,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Align(
            alignment: Alignment.center,
            child: AntPopover(
              defaultOpen: true,
              placement: placement,
              content: const Text('方向内容'),
              child: const SizedBox(key: Key('triggerBox'), width: 80, height: 40),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('topCenter 在触发元素上方', (tester) async {
      await pumpPlacement(tester, AntPopoverPlacement.topCenter);
      final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
      final childRect = tester.getRect(find.byKey(const Key('triggerBox')));
      expect(bubbleRect.bottom, lessThan(childRect.top));
    });

    testWidgets('bottomCenter 在触发元素下方', (tester) async {
      await pumpPlacement(tester, AntPopoverPlacement.bottomCenter);
      final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
      final childRect = tester.getRect(find.byKey(const Key('triggerBox')));
      expect(bubbleRect.top, greaterThan(childRect.bottom));
    });

    testWidgets('rightCenter 在触发元素右侧', (tester) async {
      await pumpPlacement(tester, AntPopoverPlacement.rightCenter);
      final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
      final childRect = tester.getRect(find.byKey(const Key('triggerBox')));
      expect(bubbleRect.left, greaterThan(childRect.right));
    });

    testWidgets('leftCenter 在触发元素左侧', (tester) async {
      await pumpPlacement(tester, AntPopoverPlacement.leftCenter);
      final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
      final childRect = tester.getRect(find.byKey(const Key('triggerBox')));
      expect(bubbleRect.right, lessThan(childRect.left));
    });

    testWidgets('topRight 与触发元素右对齐', (tester) async {
      await pumpPlacement(tester, AntPopoverPlacement.topRight);
      final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
      final childRect = tester.getRect(find.byKey(const Key('triggerBox')));
      expect(bubbleRect.bottom, lessThan(childRect.top));
      expect(bubbleRect.right, closeTo(childRect.right, 16));
    });
  });

  group('AntPopover — 样式', () {
    testWidgets('arrow=true 显示箭头，arrow=false 不显示', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            arrow: true,
            content: Text('带箭头'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(_arrowKey), findsOneWidget);
    });

    testWidgets('默认无箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            content: Text('无箭头'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(_arrowKey), findsNothing);
    });

    testWidgets('自定义 color 应用背景色', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            color: Colors.purple,
            content: Text('自定义背景'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 找到气泡内的 DecoratedBox 验证背景色
      final decorated = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byKey(_bubbleKey),
              matching: find.byType(DecoratedBox),
            )
            .last,
      );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.color, Colors.purple);
    });

    testWidgets('overlayStyle 应用内边距', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPopover(
            defaultOpen: true,
            overlayStyle: AntPopoverOverlayStyle(
              padding: EdgeInsets.all(24),
            ),
            content: Text('自定义样式'),
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(_bubbleKey),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.padding, const EdgeInsets.all(24));
    });
  });
}
