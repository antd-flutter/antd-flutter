/// AntTooltipController 测试（R35.2 Controller 模式）
library;

import 'package:antd_flutter_ui/src/basic/tooltip/ant_tooltip.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 气泡内容定位辅助。
Finder findBubble(String text) => find.descendant(
      of: find.byKey(const Key('ant_tooltip_content')),
      matching: find.text(text),
    );

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );
}

void main() {
  group('AntTooltipController — show/hide/toggle', () {
    testWidgets('show() 显示气泡、hide() 隐藏气泡', (tester) async {
      final controller = AntTooltipController();
      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: controller,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);
      expect(findBubble('气泡文案'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('气泡文案'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(findBubble('气泡文案'), findsNothing);
    });

    testWidgets('toggle() 切换显示状态', (tester) async {
      final controller = AntTooltipController();
      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: controller,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);

      controller.toggle();
      await tester.pumpAndSettle();
      expect(findBubble('气泡文案'), findsOneWidget);

      controller.toggle();
      await tester.pumpAndSettle();
      expect(findBubble('气泡文案'), findsNothing);
    });

    testWidgets('show() 触发 onOpenChange 上报', (tester) async {
      final controller = AntTooltipController();
      final events = <bool>[];
      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: controller,
          onOpenChange: events.add,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);

      controller.show();
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();
      expect(events, [true, false]);
    });

    testWidgets('controller 与受控 open 共存：open 变化仍生效', (tester) async {
      final controller = AntTooltipController();
      bool? open;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) => AntTooltip(
            controller: controller,
            open: open,
            onOpenChange: (v) => setState(() => open = v),
            tooltip: const Text('受控气泡'),
            child: const Text('触发'),
          ),
        ),
      ),);

      // controller 程序化打开：气泡出现且 onOpenChange 上报（父级同步 open=true）
      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('受控气泡'), findsOneWidget);
      expect(open, isTrue);

      // 父级受控关闭：open 参数变化仍生效
      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: controller,
          open: false,
          tooltip: const Text('受控气泡'),
          child: const Text('触发'),
        ),
      ),);
      await tester.pumpAndSettle();
      expect(findBubble('受控气泡'), findsNothing);
    });
  });

  group('AntTooltipController — attach/detach 生命周期', () {
    testWidgets('挂载后 isAttached=true，卸载后自动 detach', (tester) async {
      final controller = AntTooltipController();
      expect(controller.isAttached, isFalse);

      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: controller,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);
      expect(controller.isAttached, isTrue);

      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
    });

    testWidgets('更换 controller：旧 controller 解绑、新 controller 绑定', (tester) async {
      final c1 = AntTooltipController();
      final c2 = AntTooltipController();
      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: c1,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);

      await tester.pumpWidget(_wrap(
        AntTooltip(
          controller: c2,
          tooltip: const Text('气泡文案'),
          child: const Text('触发'),
        ),
      ),);
      expect(c1.isAttached, isFalse);
      expect(c2.isAttached, isTrue);
    });
  });

  group('AntTooltipController — 未挂载调用行为', () {
    test('未挂载调用 debug 断言（ScrollController 风格）', () {
      final controller = AntTooltipController();
      expect(() => controller.show(), throwsA(isA<AssertionError>()));
      expect(() => controller.hide(), throwsA(isA<AssertionError>()));
      expect(() => controller.toggle(), throwsA(isA<AssertionError>()));
    });
  });
}
