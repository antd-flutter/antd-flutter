/// AntNumberKeyboard widget 测试
library;

import 'package:antd_keyboard/src/number_keyboard/ant_number_keyboard.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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
  group('AntNumberKeyboard — rendering', () {
    testWidgets('renders all digit keys', (tester) async {
      await tester.pumpWidget(_wrap(const AntNumberKeyboard()));
      await tester.pumpAndSettle();

      for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) {
        expect(find.text(d), findsOneWidget);
      }
    });

    testWidgets('renders backspace icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntNumberKeyboard()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
    });

    testWidgets('renders confirm button when confirmText set', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNumberKeyboard(confirmText: '确定')),
      );
      await tester.pumpAndSettle();

      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('no confirm button when confirmText null', (tester) async {
      await tester.pumpWidget(_wrap(const AntNumberKeyboard()));
      await tester.pumpAndSettle();

      expect(find.text('确定'), findsNothing);
    });

    testWidgets('renders customKey', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNumberKeyboard(customKey: '.')),
      );
      await tester.pumpAndSettle();

      expect(find.text('.'), findsOneWidget);
    });

    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNumberKeyboard(title: '安全键盘')),
      );
      await tester.pumpAndSettle();

      expect(find.text('安全键盘'), findsOneWidget);
    });

    testWidgets('visible false renders nothing', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNumberKeyboard(visible: false)),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNothing);
    });
  });

  group('AntNumberKeyboard — input', () {
    testWidgets('tap digit fires onChange with appended value', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(AntNumberKeyboard(onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      expect(changed, '1');

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(changed, '15');
    });

    testWidgets('backspace removes last character', (tester) async {
      List<String> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            defaultValue: '12',
            onChange: (v) => changed.add(v),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();

      expect(changed, ['1']);
    });

    testWidgets('backspace on empty does nothing', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(AntNumberKeyboard(onChange: (v) => changed = v)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();

      expect(changed, isNull);
    });

    testWidgets('customKey tap fires onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            customKey: '.',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('.'));
      await tester.pumpAndSettle();

      expect(changed, '.');
    });

    testWidgets('maxLength limits input', (tester) async {
      List<String> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            maxLength: 2,
            onChange: (v) => changed.add(v),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      expect(changed, ['1', '12']);
    });

    testWidgets('confirm button fires onConfirm', (tester) async {
      bool confirmed = false;
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            confirmText: '确定',
            onConfirm: () => confirmed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });
  });

  group('AntNumberKeyboard — controlled', () {
    testWidgets('value prop controls text', (tester) async {
      List<String> changed = [];
      await tester.pumpWidget(
        _wrap(
          AntNumberKeyboard(
            value: '99',
            onChange: (v) => changed.add(v),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      expect(changed, ['991']);
    });
  });

  group('AntNumberKeyboard — randomOrder', () {
    testWidgets('all digits still present with randomOrder', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNumberKeyboard(randomOrder: true)),
      );
      await tester.pumpAndSettle();

      for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) {
        expect(find.text(d), findsOneWidget);
      }
    });
  });
}