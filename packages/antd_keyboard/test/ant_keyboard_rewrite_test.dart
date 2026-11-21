// 重写后的行为锁：双端布局、修饰态、长按连删、绑定输入框、NumberKeyboard /
// PasscodeInput / VirtualInput 的 antd-mobile 语义与桌面 QWERTY 形态。
import 'package:antd_keyboard/antd_keyboard.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(
  Widget child, {
  Size design = const Size(375, 812),
}) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
      ),
    ),
  );
}

void _device(WidgetTester tester, Size logical, double dpr) {
  tester.view.physicalSize = logical * dpr;
  tester.view.devicePixelRatio = dpr;
  addTearDown(tester.view.reset);
}

double _heightOfText(WidgetTester tester, String text) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.text(text), matching: find.byType(Container)).first,
  );
  return container.constraints?.maxHeight ?? 0;
}

void main() {
  group('AntKeyboard — 双端布局', () {
    testWidgets('移动端（Android）：48 高键位且无 hover', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(AntKeyboard(layout: AntKeyboardLayout.numeric())),
      );
      await tester.pumpAndSettle();

      expect(_heightOfText(tester, '5'), 48.0);
      expect(
        find.descendant(
          of: find.byType(AntKeyboard),
          matching: find.byType(MouseRegion),
        ),
        findsNothing,
      );
      expect(find.byKey(const ValueKey('ant-kb-backspace')), findsOneWidget);
    });

    testWidgets('桌面端（macOS）：QWERTY 56 高键位并注入 hover', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(864, 486), 2);
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(layout: AntKeyboardLayout.qwertyDesktop()),
          design: const Size(864, 486),
        ),
      );
      await tester.pumpAndSettle();

      expect(_heightOfText(tester, 'q'), 56.0);
      expect(
        find.descendant(
          of: find.byType(AntKeyboard),
          matching: find.byType(MouseRegion),
        ),
        findsWidgets,
      );
      expect(find.byKey(const ValueKey('ant-kb-tab')), findsOneWidget);
      expect(find.byKey(const ValueKey('ant-kb-capslock')), findsOneWidget);
    });

    testWidgets('显式 theme.desktop 在移动平台强制桌面形态', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.qwertyDesktop(),
            theme: const AntKeyboardThemeData(desktop: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AntKeyboard),
          matching: find.byType(MouseRegion),
        ),
        findsWidgets,
      );
      expect(find.byKey(const ValueKey('ant-kb-capslock')), findsOneWidget);
    });
  });

  group('AntKeyboard — 交互', () {
    testWidgets('字符键、空格与 Shift 自动复位', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final inputs = <String>[];
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.text(),
            onTextInput: inputs.add,
          ),
        ),
      );

      await tester.tap(find.text('q'));
      await tester.tap(find.byKey(const ValueKey('ant-kb-shift')));
      await tester.pump();
      expect(find.text('Q'), findsOneWidget);
      await tester.tap(find.text('Q'));
      await tester.pump();
      expect(inputs, ['q', 'Q']);
      // 一次性 Shift 输入后复位
      expect(find.text('q'), findsOneWidget);
    });

    testWidgets('Shift 与 CapsLock 同时开启按 XOR 输出小写', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final inputs = <String>[];
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.text(),
            onTextInput: inputs.add,
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('ant-kb-capslock')));
      await tester.tap(find.byKey(const ValueKey('ant-kb-shift')));
      await tester.pump();
      await tester.tap(find.text('a'));
      await tester.pump();
      expect(inputs, ['a']);

      // 一次性 Shift 已复位，CapsLock 仍生效 → 大写
      expect(find.text('A'), findsOneWidget);
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(inputs, ['a', 'A']);
    });

    testWidgets('退格按下立即删除，按住 700ms 后以 150ms 连删', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      var deletes = 0;
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.numeric(),
            onBackspace: () => deletes++,
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey('ant-kb-backspace'))),
      );
      await tester.pump();
      expect(deletes, 1);

      await tester.pump(const Duration(milliseconds: 720));
      final afterDelay = deletes;
      expect(afterDelay, greaterThan(1));

      await tester.pump(const Duration(milliseconds: 200));
      expect(deletes, greaterThan(afterDelay));
      await gesture.up();
      await tester.pump();

      final stopped = deletes;
      await tester.pump(const Duration(milliseconds: 400));
      expect(deletes, stopped);
    });

    testWidgets('确认键/自定义文案与关闭动作', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      var confirms = 0;
      var hides = 0;
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: const AntKeyboardLayout(
              rows: [
                AntKeyboardRow([
                  AntKeyboardKey.text('1'),
                  AntKeyboardKey.action(AntKeyAction.confirm),
                  AntKeyboardKey.action(AntKeyAction.hide),
                ]),
              ],
            ),
            confirmText: '完成',
            onConfirm: () => confirms++,
            onHide: () => hides++,
          ),
        ),
      );

      await tester.tap(find.text('完成'));
      await tester.tap(find.byKey(const ValueKey('ant-kb-hide')));
      expect(confirms, 1);
      expect(hides, 1);
    });

    testWidgets('物理键盘：字符输入 / Enter / Esc', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final inputs = <String>[];
      var confirms = 0;
      var hides = 0;
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.qwertyDesktop(),
            handleHardwareKeys: true,
            onTextInput: inputs.add,
            onConfirm: () => confirms++,
            onHide: () => hides++,
          ),
          design: const Size(864, 486),
        ),
      );
      await tester.pumpAndSettle();

      await simulateKeyDownEvent(LogicalKeyboardKey.keyA, character: 'a');
      await tester.pump();
      expect(inputs, ['a']);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(confirms, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(hides, 1);
    });
  });

  group('AntKeyboardController — TextEditingController 绑定', () {
    testWidgets('在光标处插入并应用 inputFormatters', (tester) async {
      final controller = AntKeyboardController();
      final text = TextEditingController(text: 'hello');
      final focus = FocusNode();
      addTearDown(() {
        controller.dispose();
        text.dispose();
        focus.dispose();
      });
      controller.attach(
        controller: text,
        focusNode: focus,
        inputFormatters: [
          TextInputFormatter.withFunction(
            (oldValue, newValue) => newValue.copyWith(
              text: newValue.text.toUpperCase(),
            ),
          ),
        ],
      );
      text.selection = const TextSelection.collapsed(offset: 5);

      controller.insert('ab');
      expect(text.text, 'helloAB');
      expect(text.selection.baseOffset, 7);

      controller.backspace();
      expect(text.text, 'helloA');
    });

    testWidgets('退格按字素删除 emoji', (tester) async {
      final controller = AntKeyboardController();
      final text = TextEditingController(text: '你👨‍👩‍👧');
      addTearDown(() {
        controller.dispose();
        text.dispose();
      });
      controller.attach(controller: text);
      text.selection = TextSelection.collapsed(offset: text.text.length);

      controller.backspace();
      expect(text.text, '你');
    });

    testWidgets('XOR 修饰态与一次性 Shift', (tester) async {
      final controller = AntKeyboardController();
      addTearDown(controller.dispose);

      controller.toggleCaps();
      expect(controller.shiftActive, isTrue);
      controller.toggleShift();
      expect(controller.shiftActive, isFalse);
      controller.consumeShift();
      expect(controller.capsOn, isTrue);
      expect(controller.shiftActive, isTrue);
    });
  });

  group('AntNumberKeyboard — antd-mobile 语义', () {
    testWidgets('确认键为右侧跨 3 行竖列', (tester) async {
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(confirmText: '确定', onChange: (_) {}),
          design: const Size(375, 812),
        ),
      );
      await tester.pumpAndSettle();

      final key = tester.getSize(
        find.ancestor(
          of: find.text('确定'),
          matching: find.byType(AntKeyboardKeyView),
        ),
      );
      expect(key.height, closeTo(48 * 3 + 2, 2));
      // 主区 75% / 右侧 25%
      expect(key.width, closeTo(375 / 4, 1));
    });

    testWidgets('头部标题 + 关闭回调', (tester) async {
      _device(tester, const Size(375, 812), 3);
      var cancelled = 0;
      var changed = 0;
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            title: '数字键盘',
            onCancel: () => cancelled++,
            onChange: (_) => changed++,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('数字键盘'), findsOneWidget);
      expect(tester.getSize(find.byType(AntKeyboardKeyView).first).height, 48);
      await tester.tap(find.byKey(const ValueKey('ant-kb-collapse')));
      expect(cancelled, 1);
      expect(changed, 0);
      // 数字键不再响应已关闭的键盘由调用方控制，这里仅验证回调解耦
    });

    testWidgets('extraKey + customKey 采用 12 键布局', (tester) async {
      _device(tester, const Size(375, 812), 3);
      var value = '';
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            confirmText: 'OK',
            customKey: '.',
            extraKey: '-',
            onChange: (v) => value = v,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('-'), findsOneWidget);
      expect(find.text('.'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('-'));
      await tester.pump();
      expect(value, '-');
    });

    testWidgets('randomOrder 打乱数字但仍可输入', (tester) async {
      _device(tester, const Size(375, 812), 3);
      var value = '';
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            randomOrder: true,
            onChange: (v) => value = v,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pumpAndSettle();

      for (var i = 0; i <= 9; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
      await tester.tap(find.text('7'));
      await tester.pump();
      expect(value, '7');
    });

    testWidgets('onInput / onDelete 额外回调', (tester) async {
      _device(tester, const Size(375, 812), 3);
      final inputs = <String>[];
      var deletes = 0;
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            onChange: (_) {},
            onInput: inputs.add,
            onDelete: () => deletes++,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('3'));
      await tester.pump();
      expect(inputs, ['3']);

      await tester.tap(find.byKey(const ValueKey('ant-kb-backspace')));
      await tester.pump();
      expect(deletes, 1);
    });
  });

  group('AntPasscodeInput — antd-mobile 语义', () {
    testWidgets('40 格宽、自动聚焦并填满回调一次', (tester) async {
      _device(tester, const Size(375, 812), 3);
      final fills = <String>[];
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            length: 4,
            autofocus: true,
            plain: true,
            onFill: fills.add,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pump();
      await tester.pump();

      final cell = tester.getSize(
        find.byKey(const ValueKey('ant-passcode-cell-0')),
      );
      expect(cell.width, 40);
      expect(cell.height, 40);

      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();
      expect(fills, ['1234']);
    });

    testWidgets('错误态描边使用 danger 令牌', (tester) async {
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(error: true, plain: true, defaultValue: '12'),
          design: const Size(375, 812),
        ),
      );
      await tester.pump();

      final theme = AntThemeData.light();
      final decorated =
          tester.widgetList<Container>(find.byType(Container)).where(
                (c) =>
                    c.decoration is BoxDecoration &&
                    (c.decoration! as BoxDecoration).border != null &&
                    (c.decoration! as BoxDecoration).border!.top.color ==
                        theme.colorError,
              );
      expect(decorated, isNotEmpty);
    });

    testWidgets('cellSize / cellGap 可定制', (tester) async {
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            cellSize: 52,
            cellGap: 10,
            keyboard: false,
            plain: true,
            defaultValue: '1',
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pump();

      final cell = tester.getSize(
        find.byKey(const ValueKey('ant-passcode-cell-0')),
      );
      expect(cell.width, 52);
      expect(cell.height, 52);
    });

    testWidgets('桌面端使用透明 TextField 并截断到 length', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            length: 4,
            plain: true,
            autofocus: true,
            onChange: values.add,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(AntNumberKeyboard), findsNothing);

      await tester.enterText(find.byType(EditableText), '123456');
      await tester.pump();
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('ant-passcode-cell-3')),
          matching: find.text('4'),
        ),
        findsOneWidget,
      );
      expect(values.last, '1234');
    });
  });

  group('AntVirtualInput — 绑定与双端键盘', () {
    testWidgets('移动端：antd-mobile 无边框 + 光标，输入回写', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      var value = '';
      await tester.pumpWidget(
        _wrap(
          AntVirtualInput(
            placeholder: '请输入',
            onChange: (v) => value = v,
          ),
          design: const Size(375, 812),
        ),
      );

      await tester.tap(find.text('请输入'));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('ant-virtual-input-caret')),
        findsOneWidget,
      );

      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(value, '12');
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('桌面端默认走系统输入（无软键盘）', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(const AntVirtualInput(autoFocus: true)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(AntKeyboard), findsNothing);
    });

    testWidgets('桌面端 keyboardDesktop:true 弹出 QWERTY 并可输入', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(864, 486), 2);
      var value = '';
      await tester.pumpWidget(
        _wrap(
          AntVirtualInput(
            keyboardDesktop: true,
            autoFocus: true,
            onChange: (v) => value = v,
          ),
          design: const Size(864, 486),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AntKeyboard), findsOneWidget);
      expect(find.byKey(const ValueKey('ant-kb-tab')), findsOneWidget);

      await tester.tap(find.text('q'));
      await tester.pump();
      expect(value, 'q');
      expect(find.text('q'), findsWidgets);
    });

    testWidgets('移动端自定义布局（qwertyDesktop）走通用引擎', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(375, 812), 3);
      await tester.pumpWidget(
        _wrap(
          const AntVirtualInput(
            keyboardPreset: AntKeyboardPreset.qwertyDesktop,
            autoFocus: true,
          ),
          design: const Size(375, 812),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(AntKeyboard), findsOneWidget);
      expect(find.byKey(const ValueKey('ant-kb-tab')), findsOneWidget);
      expect(find.byType(AntNumberKeyboard), findsNothing);
    });
  });

  group('AntKeyboardOverlayController — 定位/动画/Esc', () {
    testWidgets('贴底定位，realign 后贴顶', (tester) async {
      _device(tester, const Size(800, 600), 1);
      final controller = AntKeyboardOverlayController();
      addTearDown(controller.dispose);
      const keyboard = SizedBox(
        key: ValueKey('overlay-keyboard'),
        height: 200,
        child: ColoredBox(color: Color(0xFF123456)),
      );

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => controller.show(context, keyboard),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      expect(controller.showing, isTrue);

      final bottom = tester.getBottomLeft(
        find.byKey(const ValueKey('overlay-keyboard')),
      );
      expect(bottom.dy, 600);

      controller.realign(tester.element(find.text('open')), alignTop: true);
      await tester.pump();
      final top = tester.getTopLeft(
        find.byKey(const ValueKey('overlay-keyboard')),
      );
      expect(top.dy, 0);
    });

    testWidgets('入场/退场动画与 onDismiss', (tester) async {
      _device(tester, const Size(800, 600), 1);
      final controller = AntKeyboardOverlayController();
      addTearDown(controller.dispose);
      var dismisses = 0;
      const keyboard = SizedBox(
        key: ValueKey('overlay-keyboard'),
        height: 200,
        child: ColoredBox(color: Color(0xFF123456)),
      );

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => controller.show(
                context,
                keyboard,
                onDismiss: () => dismisses++,
                animationDuration: const Duration(milliseconds: 200),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      // 动画起点：仍在屏幕下方
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('overlay-keyboard'))).dy,
        greaterThan(400),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getBottomLeft(find.byKey(const ValueKey('overlay-keyboard'))).dy,
        600,
      );

      controller.hide();
      await tester.pump();
      expect(controller.showing, isFalse);
      expect(dismisses, 1);
      expect(find.byKey(const ValueKey('overlay-keyboard')), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('overlay-keyboard')), findsNothing);
    });

    testWidgets('桌面 Esc 关闭并只触发一次', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _device(tester, const Size(800, 600), 1);
      final controller = AntKeyboardOverlayController();
      addTearDown(controller.dispose);
      var dismisses = 0;

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => controller.show(
                context,
                const SizedBox(height: 100),
                onDismiss: () => dismisses++,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      expect(controller.showing, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(controller.showing, isFalse);
      expect(dismisses, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(dismisses, 1);
    });
  });
}
