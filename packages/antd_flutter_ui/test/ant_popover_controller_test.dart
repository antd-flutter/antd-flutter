/// AntPopoverController 测试（R35.2 Controller 模式）
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 气泡定位辅助。
Finder findBubble(String text) => find.descendant(
      of: find.byKey(kAntPopoverBubbleKey),
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

Widget _popover({
  AntPopoverController? controller,
  bool? open,
  ValueChanged<bool>? onOpenChange,
}) {
  return AntPopover(
    controller: controller,
    open: open,
    onOpenChange: onOpenChange,
    trigger: AntPopoverTrigger.click,
    title: const Text('标题'),
    content: const Text('气泡内容'),
    child: const Text('触发'),
  );
}

void main() {
  group('AntPopoverController — show/hide', () {
    testWidgets('show() 显示气泡、hide() 隐藏气泡', (tester) async {
      final controller = AntPopoverController();
      await tester.pumpWidget(_wrap(_popover(controller: controller)));
      expect(findBubble('气泡内容'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsNothing);
    });

    testWidgets('show() 触发 onOpenChange 上报', (tester) async {
      final controller = AntPopoverController();
      final events = <bool>[];
      await tester.pumpWidget(
        _wrap(_popover(controller: controller, onOpenChange: events.add)),
      );

      controller.show();
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();
      expect(events, [true, false]);
    });

    testWidgets('controller 与受控 open 共存：open 变化仍生效', (tester) async {
      final controller = AntPopoverController();
      await tester.pumpWidget(_wrap(_popover(
        controller: controller,
        open: false,
      ),),);

      // controller 程序化打开：气泡出现且上报 true
      final events = <bool>[];
      await tester.pumpWidget(_wrap(_popover(
        controller: controller,
        open: false,
        onOpenChange: events.add,
      ),),);
      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsOneWidget);
      expect(events.last, isTrue);

      // 父级受控切换 open=true→false 仍生效
      await tester.pumpWidget(_wrap(_popover(
        controller: controller,
        open: true,
      ),),);
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsOneWidget);
      await tester.pumpWidget(_wrap(_popover(
        controller: controller,
        open: false,
      ),),);
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsNothing);
    });
  });

  group('AntPopoverController — attach/detach 生命周期', () {
    testWidgets('挂载后 isAttached=true，卸载后自动 detach', (tester) async {
      final controller = AntPopoverController();
      expect(controller.isAttached, isFalse);

      await tester.pumpWidget(_wrap(_popover(controller: controller)));
      expect(controller.isAttached, isTrue);

      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
    });

    testWidgets('更换 controller：旧 controller 解绑、新 controller 绑定', (tester) async {
      final c1 = AntPopoverController();
      final c2 = AntPopoverController();
      await tester.pumpWidget(_wrap(_popover(controller: c1)));
      await tester.pumpWidget(_wrap(_popover(controller: c2)));
      expect(c1.isAttached, isFalse);
      expect(c2.isAttached, isTrue);
    });
  });

  group('AntPopoverController — 未挂载调用行为', () {
    test('未挂载调用 debug 断言（ScrollController 风格）', () {
      final controller = AntPopoverController();
      expect(() => controller.show(), throwsA(isA<AssertionError>()));
      expect(() => controller.hide(), throwsA(isA<AssertionError>()));
    });
  });
}
