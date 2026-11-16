import 'package:antd_flutter_plus/src/components/data_display/floating_bubble/ant_floating_bubble.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const double _canvasW = 300;
const double _canvasH = 400;

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(
            child: SizedBox(
              width: _canvasW,
              height: _canvasH,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

Positioned _bubblePosition(WidgetTester tester) {
  final positioned = tester.widget<Positioned>(
    find
        .ancestor(
          of: find.byType(GestureDetector),
          matching: find.byType(Positioned),
        )
        .last,
  );
  return positioned;
}

void main() {
  group('AntFloatingBubble', () {
    testWidgets('renders default circular button', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble()));
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, AntThemeData.light().colorPrimary);
      expect(container.constraints!.maxWidth, 48.w);
      expect(container.constraints!.maxHeight, 48.w);
      // 默认图标
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('initialPos positions the bubble', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(40, 60),
      )));
      final positioned = _bubblePosition(tester);
      expect(positioned.left, 40.w);
      expect(positioned.top, 60.w);
    });

    testWidgets('axis both allows dragging in both directions', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.both,
      )));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(29, 19)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(29, 19));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      expect(positioned.left, closeTo(80.w, 8));
      expect(positioned.top, closeTo(70.w, 8));
    });

    testWidgets('axis x only drags horizontally', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.x,
      )));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(29, 39)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(29, 39));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      expect(positioned.left, closeTo(80.w, 8));
      expect(positioned.top, 50.w);
    });

    testWidgets('axis y only drags vertically', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.y,
      )));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(59, 29)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(59, 29));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      expect(positioned.left, 50.w);
      expect(positioned.top, closeTo(80.w, 8));
    });

    testWidgets('position updates after drag', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(10, 10),
      )));
      expect(_bubblePosition(tester).left, 10.w);
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(19, -1)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(19, -1));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_bubblePosition(tester).left, closeTo(30.w, 8));
    });

    testWidgets('tap opens menu and renders actions with onClick',
        (tester) async {
      var clicked = '';
      await tester.pumpWidget(_wrap(AntFloatingBubble(
        menu: [
          AntFloatingBubbleMenuAction(
            label: '菜单A',
            icon: const Icon(Icons.home),
            onClick: () => clicked = 'A',
          ),
          AntFloatingBubbleMenuAction(
            label: '菜单B',
            onClick: () => clicked = 'B',
          ),
        ],
      )));
      // 收起时菜单文字不可见（透明但仍在树中，断言 IgnorePointer 生效后点击不可达）
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('菜单A'), findsOneWidget);
      expect(find.text('菜单B'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      await tester.tap(find.text('菜单A'));
      await tester.pumpAndSettle();
      expect(clicked, 'A');
    });

    testWidgets('tap again collapses menu', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        menu: [AntFloatingBubbleMenuAction(label: '菜单A')],
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      final panel = tester.widget<AnimatedOpacity>(
        find
            .ancestor(
              of: find.text('菜单A'),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(panel.opacity, 1.0);
      // 再点一次收起
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      final collapsed = tester.widget<AnimatedOpacity>(
        find
            .ancestor(
              of: find.text('菜单A'),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(collapsed.opacity, 0.0);
    });

    testWidgets('menu item click collapses menu', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        menu: [AntFloatingBubbleMenuAction(label: '菜单A')],
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('菜单A'));
      await tester.pumpAndSettle();
      final panel = tester.widget<AnimatedOpacity>(
        find
            .ancestor(
              of: find.text('菜单A'),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(panel.opacity, 0.0);
    });

    testWidgets('constraint keeps bubble inside bounds', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(20, 20),
        constraint: true,
      )));
      // 向左上方大幅拖拽，应被钳制在边界内（left/top >= 0）
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(-201, -201)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(-201, -201));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      expect(positioned.left, 0.0);
      expect(positioned.top, 0.0);
    });

    testWidgets('constraint false allows dragging out of bounds',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(100, 100),
        constraint: false,
      )));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(-151, -151)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(-151, -151));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      expect(positioned.left, lessThan(0));
      expect(positioned.top, lessThan(0));
    });

    testWidgets('custom child icon renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        child: Icon(Icons.edit),
      )));
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('onClick fires on tap without menu', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntFloatingBubble(
        onClick: () => tapped = true,
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
