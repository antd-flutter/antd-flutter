/// AntPopconfirmController 测试（R35.2 Controller 模式）
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popconfirm.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 气泡定位辅助。
Finder findBubble(String text) => find.descendant(
      of: find.byKey(kAntPopconfirmBubbleKey),
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

Widget _popconfirm({
  AntPopconfirmController? controller,
  bool? open,
  dynamic onOpenChange,
}) {
  return AntPopconfirm(
    controller: controller,
    open: open,
    onOpenChange: onOpenChange,
    title: '删除这条记录吗？',
    child: const Text('触发'),
  );
}

void main() {
  group('AntPopconfirmController — show/hide', () {
    testWidgets('show() 显示气泡、hide() 隐藏气泡', (tester) async {
      final controller = AntPopconfirmController();
      await tester.pumpWidget(_wrap(_popconfirm(controller: controller)));
      expect(findBubble('删除这条记录吗？'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('删除这条记录吗？'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(findBubble('删除这条记录吗？'), findsNothing);
    });

    testWidgets('show() 触发 onOpenChange 上报', (tester) async {
      final controller = AntPopconfirmController();
      final events = <bool>[];
      await tester.pumpWidget(
        _wrap(_popconfirm(controller: controller, onOpenChange: events.add)),
      );

      controller.show();
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();
      expect(events, [true, false]);
    });

    testWidgets('确认按钮点击后自动关闭（controller 状态同步）', (tester) async {
      final controller = AntPopconfirmController();
      await tester.pumpWidget(_wrap(_popconfirm(controller: controller)));

      controller.show();
      await tester.pumpAndSettle();
      expect(findBubble('删除这条记录吗？'), findsOneWidget);

      await tester.tap(find.byKey(kAntPopconfirmOkButtonKey));
      await tester.pumpAndSettle();
      expect(findBubble('删除这条记录吗？'), findsNothing);
    });
  });

  group('AntPopconfirmController — attach/detach 生命周期', () {
    testWidgets('挂载后 isAttached=true，卸载后自动 detach', (tester) async {
      final controller = AntPopconfirmController();
      expect(controller.isAttached, isFalse);

      await tester.pumpWidget(_wrap(_popconfirm(controller: controller)));
      expect(controller.isAttached, isTrue);

      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
    });

    testWidgets('更换 controller：旧 controller 解绑、新 controller 绑定', (tester) async {
      final c1 = AntPopconfirmController();
      final c2 = AntPopconfirmController();
      await tester.pumpWidget(_wrap(_popconfirm(controller: c1)));
      await tester.pumpWidget(_wrap(_popconfirm(controller: c2)));
      expect(c1.isAttached, isFalse);
      expect(c2.isAttached, isTrue);
    });
  });

  group('AntPopconfirmController — 未挂载调用行为', () {
    test('未挂载调用 debug 断言（ScrollController 风格）', () {
      final controller = AntPopconfirmController();
      expect(() => controller.show(), throwsA(isA<AssertionError>()));
      expect(() => controller.hide(), throwsA(isA<AssertionError>()));
    });
  });
}
