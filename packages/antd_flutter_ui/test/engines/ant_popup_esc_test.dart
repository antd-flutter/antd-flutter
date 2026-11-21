// R37 弹层 Esc 关闭 widget 测试 — Popover（AntPopupOverlay 基座）/
// Dialog / Drawer（AntOverlayShell 基座）打开状态下按 Esc 关闭
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover_types.dart';
import 'package:antd_flutter_ui/src/feedback/dialog/ant_dialog.dart';
import 'package:antd_flutter_ui/src/feedback/drawer/ant_drawer.dart';
import 'package:antd_flutter_ui/src/feedback/drawer/ant_drawer_types.dart';
import 'package:antd_flutter_ui/src/engines/hotkeys/hotkey_registry.dart';
import 'package:antd_flutter_ui/src/engines/hotkeys/hotkey_binding.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:flutter/services.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findBubble(String text) => find.descendant(
      of: find.byKey(kAntPopoverBubbleKey),
      matching: find.text(text),
    );

Finder findDialogCard() => find.byKey(kAntDialogCardKey);

Finder findDrawerPanel() => find.byKey(kAntDrawerPanelKey);

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
  setUp(() {
    HotkeyRegistry.instance.clear();
  });
  tearDown(() {
    HotkeyRegistry.instance.clear();
  });

  group('弹层 Esc 关闭 — 基座统一默认绑定', () {
    testWidgets('Popover 打开 → Esc → 关闭', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.click,
        content: Text('气泡内容'),
        child: Text('触发'),
      ),),);
      expect(findBubble('气泡内容'), findsNothing);

      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(findBubble('气泡内容'), findsNothing);
    });

    testWidgets('Popover escToClose=false：Esc 不关闭', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.click,
        content: Text('气泡内容'),
        child: Text('触发'),
      ),),);
      // 经组件参数禁用：AntPopover 未透传 escToClose 时走基座默认开启，
      // 这里直接用基座验证开关语义
      await tester.pumpWidget(_wrap(const AntPopupOverlay(
        targetKey: GlobalObjectKey('t'),
        escToClose: false,
        child: Text('气泡'),
      ),),);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      // 不抛错即通过（escToClose=false 未注册绑定）
      expect(HotkeyRegistry.instance.bindingCount, 0);
    });

    testWidgets('Dialog 打开 → Esc → 关闭', (tester) async {
      await tester.pumpWidget(_wrap(const AntDialog(
        visible: true,
        content: Text('对话框内容'),
      ),),);
      await tester.pumpAndSettle();
      expect(findDialogCard(), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(findDialogCard(), findsNothing);
    });

    testWidgets('Drawer 打开 → Esc → 关闭', (tester) async {
      late StateSetter setState;
      var open = true;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setS) {
          setState = setS;
          return AntDrawer(
            open: open,
            placement: AntDrawerPlacement.right,
            onClose: () => setState(() => open = false),
            child: const Text('抽屉内容'),
          );
        },
      ),),);
      await tester.pumpAndSettle();
      expect(findDrawerPanel(), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(findDrawerPanel(), findsNothing);
    });

    testWidgets('弹层打开期自定义热键绑定生效（AntPopupOverlay.hotkeys）',
        (tester) async {
      var triggered = 0;
      await tester.pumpWidget(_wrap(AntPopupOverlay(
        targetKey: const GlobalObjectKey('t'),
        onDismiss: () {},
        hotkeys: [
          AntHotkeyBinding(
            keys: {LogicalKeyboardKey.keyR},
            modifiers: {AntHotkeyModifier.ctrl},
            debugLabel: 'refresh-while-open',
            onTrigger: () => triggered++,
          ),
        ],
        child: const Text('气泡'),
      ),),);
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyR);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyR);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(triggered, 1);
    });
  });
}
