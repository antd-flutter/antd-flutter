import 'package:antd_keyboard/src/engines/keyboard_overlay.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(WidgetBuilder builder) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: Builder(builder: builder)),
        ),
      ),
    ),
  );
}

void main() {
  group('AntKeyboardOverlayController — Esc 收起（本地 HardwareKeyboard）', () {
    testWidgets('show 后按 Esc 收起并触发 dismiss', (tester) async {
      final controller = AntKeyboardOverlayController();
      var dismissed = false;
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _wrap(
          (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      );
      await tester.pumpAndSettle();

      controller.show(
        capturedContext,
        const ColoredBox(color: Color(0xFF123456), child: SizedBox(height: 100)),
        onDismiss: () => dismissed = true,
      );
      await tester.pumpAndSettle();
      expect(controller.showing, isTrue);
      expect(
        find.byWidgetPredicate(
          (w) => w is ColoredBox && w.color == const Color(0xFF123456),
        ),
        findsOneWidget,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(controller.showing, isFalse);
      expect(dismissed, isTrue);

      // 收起后再按 Esc 不再触发（监听已注销）。
      dismissed = false;
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(dismissed, isFalse);
    });
  });
}
