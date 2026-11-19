/// AntDropdownController 测试（R35.2 Controller 模式）
library;

import 'package:antd_flutter_ui/src/display/popover/ant_dropdown.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_dropdown_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 菜单项定位辅助。
Finder findMenuItem(String label) => find.text(label);

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

Widget _dropdown({
  AntDropdownController? controller,
  bool? open,
  ValueChanged<bool>? onOpenChange,
}) {
  return AntDropdown(
    controller: controller,
    open: open,
    onOpenChange: onOpenChange,
    trigger: AntDropdownTrigger.click,
    items: const [
      AntDropdownItem(key: '1', label: '菜单项一'),
      AntDropdownItem(key: '2', label: '菜单项二'),
    ],
    child: const Text('触发'),
  );
}

void main() {
  group('AntDropdownController — show/hide', () {
    testWidgets('show() 显示菜单、hide() 隐藏菜单', (tester) async {
      final controller = AntDropdownController();
      await tester.pumpWidget(_wrap(_dropdown(controller: controller)));
      expect(findMenuItem('菜单项一'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(findMenuItem('菜单项一'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(findMenuItem('菜单项一'), findsNothing);
    });

    testWidgets('show() 触发 onOpenChange 上报', (tester) async {
      final controller = AntDropdownController();
      final events = <bool>[];
      await tester.pumpWidget(
        _wrap(_dropdown(controller: controller, onOpenChange: events.add)),
      );

      controller.show();
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();
      expect(events, [true, false]);
    });

    testWidgets('controller 与受控 open 共存：open 变化仍生效', (tester) async {
      final controller = AntDropdownController();
      await tester.pumpWidget(_wrap(_dropdown(controller: controller)));

      controller.show();
      await tester.pumpAndSettle();
      expect(findMenuItem('菜单项一'), findsOneWidget);

      // 父级受控关闭：open=false 变化生效（先以 open:null 挂载后切到受控）
      await tester.pumpWidget(_wrap(_dropdown(
        controller: controller,
        open: false,
      ),),);
      await tester.pumpAndSettle();
      expect(findMenuItem('菜单项一'), findsNothing);
    });
  });

  group('AntDropdownController — attach/detach 生命周期', () {
    testWidgets('挂载后 isAttached=true，卸载后自动 detach', (tester) async {
      final controller = AntDropdownController();
      expect(controller.isAttached, isFalse);

      await tester.pumpWidget(_wrap(_dropdown(controller: controller)));
      expect(controller.isAttached, isTrue);

      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
    });

    testWidgets('更换 controller：旧 controller 解绑、新 controller 绑定', (tester) async {
      final c1 = AntDropdownController();
      final c2 = AntDropdownController();
      await tester.pumpWidget(_wrap(_dropdown(controller: c1)));
      await tester.pumpWidget(_wrap(_dropdown(controller: c2)));
      expect(c1.isAttached, isFalse);
      expect(c2.isAttached, isTrue);
    });
  });

  group('AntDropdownController — 未挂载调用行为', () {
    test('未挂载调用 debug 断言（ScrollController 风格）', () {
      final controller = AntDropdownController();
      expect(() => controller.show(), throwsA(isA<AssertionError>()));
      expect(() => controller.hide(), throwsA(isA<AssertionError>()));
    });
  });
}
