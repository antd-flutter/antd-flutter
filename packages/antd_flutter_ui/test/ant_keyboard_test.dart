import 'package:antd_flutter_ui/src/data_entry/number_keyboard/ant_number_keyboard.dart';
import 'package:antd_flutter_ui/src/engines/ant_keyboard/ant_keyboard.dart';
import 'package:antd_flutter_ui/src/engines/ant_keyboard/ant_keyboard_layout.dart';
import 'package:antd_flutter_ui/src/engines/ant_keyboard/ant_keyboard_theme.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  bool dark = false,
}) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: dark ? AntThemeData.dark() : AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AntKeyboardLayout — 预设布局', () {
    test('numeric 含 0-9 与退格', () {
      final layout = AntKeyboardLayout.numeric();
      final texts = [
        for (final row in layout.rows)
          for (final k in row.keys)
            if (k.text != null) k.text!,
      ];
      expect(texts, containsAll(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']));
      expect(layout.rows.last.keys.any((k) => k.isBackspace), isTrue);
    });

    test('decimal 含小数点', () {
      final layout = AntKeyboardLayout.decimal();
      expect(
        layout.rows.any((r) => r.keys.any((k) => k.text == '.')),
        isTrue,
      );
    });

    test('text 含 QWERTY 全键与字母长按变体', () {
      final layout = AntKeyboardLayout.text();
      final texts = [
        for (final row in layout.rows)
          for (final k in row.keys)
            if (k.text != null) k.text!,
      ];
      expect(texts, containsAll(['q', 'w', 'e', 'a', 's', 'z', 'm']));
      // 长按变体（重音字符）
      final withVariants = [
        for (final row in layout.rows)
          for (final k in row.keys)
            if (k.hasVariants) k,
      ];
      expect(withVariants, isNotEmpty);
      expect(withVariants.first.variants, isNotEmpty);
    });

    test('symbol 含常用符号', () {
      final layout = AntKeyboardLayout.symbol();
      final texts = [
        for (final row in layout.rows)
          for (final k in row.keys)
            if (k.text != null) k.text!,
      ];
      expect(texts, containsAll(['@', '¥', '.', '!', '?']));
    });

    test('email 含 @ 与 .', () {
      final layout = AntKeyboardLayout.email();
      final texts = [
        for (final row in layout.rows)
          for (final k in row.keys)
            if (k.text != null) k.text!,
      ];
      expect(texts, containsAll(['@', '.']));
    });

    testWidgets('custom layout renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntKeyboard(
        layout: AntKeyboardLayout(rows: [
          AntKeyboardRow([AntKeyboardKey.text('X'), AntKeyboardKey.text('Y')]),
        ],),
      ),),);
      expect(find.text('X'), findsOneWidget);
      expect(find.text('Y'), findsOneWidget);
    });
  });

  group('AntKeyboard — 按键行为', () {
    testWidgets('tap text key fires onTextInput', (tester) async {
      final inputs = <String>[];
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        onTextInput: inputs.add,
      ),),);
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(inputs, ['5']);
    });

    testWidgets('tap backspace fires onBackspace', (tester) async {
      var backspaces = 0;
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        onBackspace: () => backspaces++,
      ),),);
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();
      expect(backspaces, 1);
    });

    testWidgets('long-press backspace repeats delete', (tester) async {
      var deletes = 0;
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        onBackspace: () => deletes++,
      ),),);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.backspace_outlined)),
      );
      // 按下即触发 1 次
      await tester.pump();
      expect(deletes, 1);
      // 300ms 延迟到期 → 启动周期重复
      await tester.pump(const Duration(milliseconds: 350));
      final afterDelay = deletes;
      expect(afterDelay, greaterThanOrEqualTo(1));
      // 周期 80ms：再推进 200ms 应继续递增
      await tester.pump(const Duration(milliseconds: 200));
      expect(deletes, greaterThan(afterDelay));
      await gesture.up();
      await tester.pump();
      // 抬起后停止重复
      final before = deletes;
      await tester.pump(const Duration(milliseconds: 200));
      expect(deletes, before);
    });

    testWidgets('long-press letter shows variants, tap selects',
        (tester) async {
      final inputs = <String>[];
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.text(),
        onTextInput: inputs.add,
      ),),);
      // 手势驱动长按（kLongPressTimeout 500ms）
      final gesture = await tester.startGesture(tester.getCenter(find.text('a')));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.up();
      await tester.pumpAndSettle();
      // 变体气泡渲染
      expect(find.text('á'), findsOneWidget);
      await tester.tap(find.text('á'));
      await tester.pumpAndSettle();
      expect(inputs, contains('á'));
    });
  });

  group('AntKeyboard — 主题适配', () {
    testWidgets('dark theme derives dark tokens', (tester) async {
      late AntKeyboardThemeData resolved;
      await tester.pumpWidget(_wrap(
        Builder(
          builder: (context) {
            resolved = AntKeyboardThemeData.resolve(AntTheme.of(context));
            return AntKeyboard(layout: AntKeyboardLayout.numeric());
          },
        ),
        dark: true,
      ),);
      await tester.pump();
      final t = AntThemeData.dark();
      expect(resolved.keyBackgroundColor, t.colorFillSecondary);
      expect(resolved.surfaceColor, t.colorBgContainer);
    });

    testWidgets('custom theme overrides tokens', (tester) async {
      const custom = AntKeyboardThemeData(
        keyBackgroundColor: Color(0xFF123456),
      );
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        theme: custom,
      ),),);
      await tester.pump();
      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      final colors = containers
          .map((c) => (c.decoration as BoxDecoration).color)
          .whereType<Color>()
          .toSet();
      expect(colors, contains(const Color(0xFF123456)));
    });
  });

  group('AntKeyboard — 桌面展示形态', () {
    testWidgets('desktop density renders larger keys', (tester) async {
      double keyContainerHeight(bool desktop) {
        final containers = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                w.constraints?.maxHeight != null,
          ),
        );
        return containers.first.constraints!.maxHeight;
      }

      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        theme: const AntKeyboardThemeData(desktop: false),
      ),),);
      await tester.pump();
      final mobileHeight = keyContainerHeight(true);

      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        theme: const AntKeyboardThemeData(desktop: true),
      ),),);
      await tester.pump();
      final desktopHeight = keyContainerHeight(true);
      expect(desktopHeight, greaterThan(mobileHeight));
    });

    testWidgets('desktop hover feedback shows hover color', (tester) async {
      const hoverColor = Color(0xFF00FF00);
      await tester.pumpWidget(_wrap(AntKeyboard(
        layout: AntKeyboardLayout.numeric(),
        theme: const AntKeyboardThemeData(
          desktop: true,
          keyBackgroundColor: Colors.black,
          keyHoverBackgroundColor: hoverColor,
        ),
      ),),);
      await tester.pump();
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('5')));
      await tester.pumpAndSettle();
      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      final colors = containers
          .map((c) => (c.decoration as BoxDecoration).color)
          .whereType<Color>()
          .toSet();
      expect(colors, contains(hoverColor));
    });
  });

  group('AntNumberKeyboard — 引擎集成（向后兼容）', () {
    testWidgets('numeric preset renders and inputs', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(_wrap(AntNumberKeyboard(
        onChange: values.add,
      ),),);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.text('7'));
      await tester.pump();
      expect(values, ['7']);
    });

    testWidgets('confirmText renders confirm key', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(_wrap(AntNumberKeyboard(
        confirmText: '确定',
        onConfirm: () => confirmed = true,
      ),),);
      expect(find.text('确定'), findsOneWidget);
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(confirmed, isTrue);
    });
  });
}
