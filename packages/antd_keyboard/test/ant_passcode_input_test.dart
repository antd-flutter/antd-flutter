import 'package:antd_keyboard/antd_keyboard.dart';
import 'package:antd_theme/antd_theme.dart';
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

void main() {
  group('AntPasscodeInput — rendering', () {
    testWidgets('renders default length 6 cells with plain value',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            defaultValue: '123456',
            plain: true,
            keyboard: false,
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('renders custom length cells', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            length: 4,
            defaultValue: '1234',
            plain: true,
            keyboard: false,
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('masked mode shows dots not text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            defaultValue: '12',
            keyboard: false,
          ),
        ),
      );
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
      // 圆点容器存在
      final dots = tester.widgetList<Container>(find.byType(Container)).where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).shape == BoxShape.circle,
          );
      expect(dots.length, 2);
    });

    testWidgets('plain mode shows digits', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            defaultValue: '12',
            plain: true,
            keyboard: false,
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('separated mode renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            separated: true,
            defaultValue: '1',
            keyboard: false,
          ),
        ),
      );
      expect(find.byType(AntPasscodeInput), findsOneWidget);
    });

    testWidgets('error mode renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            error: true,
            keyboard: false,
          ),
        ),
      );
      expect(find.byType(AntPasscodeInput), findsOneWidget);
    });
  });

  group('AntPasscodeInput — interaction', () {
    testWidgets('tapping cells toggles keyboard', (tester) async {
      await tester.pumpWidget(_wrap(const AntPasscodeInput()));
      // 初始无键盘
      expect(find.text('1'), findsNothing);
      // 点击格子区域展开键盘
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      // 再次点击收起
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(find.text('1'), findsNothing);
    });

    testWidgets('autofocus shows keyboard initially', (tester) async {
      await tester.pumpWidget(_wrap(const AntPasscodeInput(autofocus: true)));
      await tester.pump(); // 键盘经 postFrame 插入 root Overlay，需再 pump 一帧
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('keyboard false does not show keyboard on tap', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPasscodeInput(keyboard: false)),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(find.text('1'), findsNothing);
    });

    testWidgets('tap digit fires onChange with appended value', (tester) async {
      var changed = '';
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(changed, '1');
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(changed, '12');
    });

    testWidgets('backspace removes last character', (tester) async {
      var changed = '';
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            defaultValue: '12',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();
      expect(changed, '1');
    });

    testWidgets('onFill fires when all cells filled', (tester) async {
      var filled = '';
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            length: 2,
            onFill: (v) => filled = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(filled, '');
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(filled, '12');
    });

    testWidgets('maxLength prevents typing beyond length', (tester) async {
      var changed = '';
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            length: 2,
            defaultValue: '12',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      expect(changed, '');
    });
  });

  group('AntPasscodeInput — controlled', () {
    testWidgets('value prop controls displayed content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntPasscodeInput(
            value: '123',
            plain: true,
            keyboard: false,
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('controlled tap digit fires onChange only', (tester) async {
      var changed = '';
      await tester.pumpWidget(
        _wrap(
          AntPasscodeInput(
            value: '1',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(changed, '12');
      // 受控模式内部值不变，仍只显示 '1' 的格子
      expect(find.text('2'), findsOneWidget); // 仅键盘上的 2 键
    });
  });
  group('AntPasscodeInput — 桌面端降级（回归）', () {
    testWidgets('desktop renders hidden field input without custom keyboard',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.pumpWidget(_wrap(const AntPasscodeInput(autofocus: true)));
      await tester.pump();
      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(AntNumberKeyboard), findsNothing);
    });
  });
}
