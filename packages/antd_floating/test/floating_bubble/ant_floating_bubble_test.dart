import 'package:antd_floating/src/floating_bubble/ant_floating_bubble.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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

/// 气泡定位记录（top 统一换算：组件底边锚定后 Positioned.top 为 null）。
class _BubblePos {
  _BubblePos(this.left, this.top);

  final double left;
  final double? top;
}

_BubblePos _bubblePosition(WidgetTester tester) {
  final positioned = tester.widget<Positioned>(
    find
        .ancestor(
          of: find.byType(GestureDetector),
          matching: find.byType(Positioned),
        )
        .last,
  );
  final double? top = positioned.top ??
      (positioned.bottom != null
          ? _canvasH - positioned.bottom! - 48.w
          : null);
  return _BubblePos(positioned.left!, top);
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
      ),),);
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, 40.w);
      expect(bubblePos.top!, 60.w);
    });

    testWidgets('axis both allows dragging in both directions', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.both,
      ),),);
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(29, 19)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(29, 19));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, closeTo(80.w, 8));
      expect(bubblePos.top!, closeTo(70.w, 8));
    });

    testWidgets('axis x only drags horizontally', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.x,
      ),),);
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(29, 39)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(29, 39));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, closeTo(80.w, 8));
      expect(bubblePos.top!, 50.w);
    });

    testWidgets('axis y only drags vertically', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(50, 50),
        axis: AntFloatingBubbleAxis.y,
      ),),);
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(59, 29)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(59, 29));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, 50.w);
      expect(bubblePos.top!, closeTo(80.w, 8));
    });

    testWidgets('position updates after drag', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(10, 10),
      ),),);
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
        initialPos: const Offset(10, 300),
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
      ),),);
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
        initialPos: Offset(10, 300),
        menu: [AntFloatingBubbleMenuAction(label: '菜单A')],
      ),),);
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
        initialPos: Offset(10, 300),
        menu: [AntFloatingBubbleMenuAction(label: '菜单A')],
      ),),);
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
      ),),);
      // 向左上方大幅拖拽，应被钳制在边界内（left/top >= 0）
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(-201, -201)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(-201, -201));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, 0.0);
      expect(bubblePos.top!, 0.0);
    });

    testWidgets('constraint false allows dragging out of bounds',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(100, 100),
        constraint: false,
      ),),);
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(-151, -151)); // 触发 pan 接受（不产生位移）
      await gesture.moveBy(const Offset(-151, -151));
      await gesture.up();
      await tester.pumpAndSettle();
      final positioned = _bubblePosition(tester);
      final bubblePos = positioned;
      expect(bubblePos.left, lessThan(0));
      expect(bubblePos.top!, lessThan(0));
    });

    testWidgets('custom child icon renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        child: Icon(Icons.edit),
      ),),);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('onClick fires on tap without menu', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntFloatingBubble(
        onClick: () => tapped = true,
      ),),);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('AntFloatingBubbleController (R35)', () {
    AntFloatingBubble makeBubble({
      Key? key,
      AntFloatingBubbleController? controller,
      Offset initialPos = Offset.zero,
      VoidCallback? onClick,
    }) {
      return AntFloatingBubble(
        key: key,
        controller: controller,
        initialPos: initialPos,
        onClick: onClick,
      );
    }

    testWidgets('moveTo 移动到指定位置（约束在边界内）', (tester) async {
      final controller = AntFloatingBubbleController();
      await tester.pumpWidget(
        _wrap(
        SizedBox(
          width: _canvasW,
          height: _canvasH,
          child: makeBubble(controller: controller),
        ),
      ),
      );
      await tester.pumpAndSettle();
      controller.moveTo(const Offset(1000, 1000)); // 越界 → clamp 到右下角
      await tester.pumpAndSettle();
      final pos = _bubblePosition(tester);
      expect(controller.position, isNotNull);
      expect(controller.position!.dx, closeTo(_canvasW - 48.w, 1));
      expect(controller.position!.dy, closeTo(_canvasH - 48.w, 1));
      expect(pos.left, closeTo(_canvasW - 48.w, 1));
    });

    testWidgets('snapToEdge / snapToNearestEdge 吸附边缘', (tester) async {
      final controller = AntFloatingBubbleController();
      await tester.pumpWidget(
        _wrap(
        SizedBox(
          width: _canvasW,
          height: _canvasH,
          child: makeBubble(
            controller: controller,
            initialPos: const Offset(200, 100),
          ),
        ),
      ),
      );
      await tester.pumpAndSettle();
      controller.snapToNearestEdge(); // x=200 靠右 → 吸附右边缘
      await tester.pumpAndSettle();
      expect(controller.position!.dx, closeTo(_canvasW - 48.w, 1));
      expect(controller.position!.dy, closeTo(100.w, 1));
      controller.snapToEdge(AntFloatingBubbleEdge.left);
      await tester.pumpAndSettle();
      expect(controller.position!.dx, 0.0);
    });

    testWidgets('hide / show 控制可见性', (tester) async {
      final controller = AntFloatingBubbleController();
      await tester.pumpWidget(
        _wrap(
        SizedBox(
          width: _canvasW,
          height: _canvasH,
          child: makeBubble(controller: controller),
        ),
      ),
      );
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();
      expect(controller.visible, isFalse);
      expect(find.byType(AntFloatingBubble), findsOneWidget);
      // 隐藏后气泡本体不再渲染（无 AnimatedContainer 气泡）。
      expect(find.byType(AnimatedContainer), findsNothing);
      controller.show();
      await tester.pumpAndSettle();
      expect(controller.visible, isTrue);
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('resetPosition 回到初始位置', (tester) async {
      final controller = AntFloatingBubbleController();
      await tester.pumpWidget(
        _wrap(
        SizedBox(
          width: _canvasW,
          height: _canvasH,
          child: makeBubble(
            controller: controller,
            initialPos: const Offset(40, 60),
          ),
        ),
      ),
      );
      await tester.pumpAndSettle();
      controller.moveTo(const Offset(10, 10));
      await tester.pumpAndSettle();
      controller.resetPosition();
      await tester.pumpAndSettle();
      expect(controller.position!.dx, closeTo(40.w, 1));
      expect(controller.position!.dy, closeTo(60.w, 1));
    });

    testWidgets('onClick 在 Controller 操作之外仍正常触发', (tester) async {
      final controller = AntFloatingBubbleController();
      var clicks = 0;
      await tester.pumpWidget(
        _wrap(
        SizedBox(
          width: _canvasW,
          height: _canvasH,
          child: makeBubble(
            controller: controller,
            onClick: () => clicks++,
          ),
        ),
      ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(clicks, 1);
    });

    testWidgets('未挂接时调用为安全空操作', (tester) async {
      final controller = AntFloatingBubbleController();
      controller.hide();
      controller.show();
      controller.moveTo(const Offset(1, 1));
      controller.snapToNearestEdge();
      controller.resetPosition();
      expect(controller.visible, isTrue);
      expect(controller.position, isNull);
    });
  });

    testWidgets('菜单模式下气泡位置不因菜单占位下移（回归）', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(10, 300),
        menu: [AntFloatingBubbleMenuAction(label: '菜单A')],
      ),),);
      await tester.pumpAndSettle();
      // 收起态：菜单透明但占位，气泡仍应在 initialPos（顶边换算）。
      final closed = _bubblePosition(tester);
      expect(closed.left, 10.w);
      expect(closed.top!, closeTo(300.w, 1));
      // 展开态：气泡不动，菜单在其上方。
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      final opened = _bubblePosition(tester);
      expect(opened.left, 10.w);
      expect(opened.top!, closeTo(300.w, 1));
      final menuTop = tester.getTopLeft(find.text('菜单A')).dy;
      expect(menuTop, lessThan(opened.top!));
    });

    testWidgets('autoSnapToEdge 拖拽松手后自动吸附最近边缘', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatingBubble(
        initialPos: Offset(20, 200),
        autoSnapToEdge: true,
      ),),);
      await tester.pumpAndSettle();
      final gesture =
          await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
      await gesture.moveBy(const Offset(1, 1));
      await gesture.moveBy(const Offset(40, 10)); // 触发 pan 接受
      await gesture.moveBy(const Offset(40, 10));
      await gesture.up();
      await tester.pumpAndSettle();
      // x=60+48 < 300/2=150 → 吸附左边缘
      expect(_bubblePosition(tester).left, 0.0);
    });
}
