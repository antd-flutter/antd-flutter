import 'package:antd_swipe_action/src/swipe_action/ant_swipe_action.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

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

/// 构建一行内容位移 Transform（内容层唯一：祖先含行文本）。
Offset _contentOffset(WidgetTester tester, String text) {
  final transform = tester.widget<Transform>(
    find
        .ancestor(of: find.text(text), matching: find.byType(Transform))
        .first,
  );
  final Vector3 translation = transform.transform.getTranslation();
  return Offset(translation.x, translation.y);
}

void main() {
  group('AntSwipeAction', () {
    testWidgets('默认渲染 child 内容', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('左滑试试')),
        ),
      ),),);
      expect(find.text('左滑试试'), findsOneWidget);
      expect(find.byKey(kAntSwipeActionContentKey), findsOneWidget);
    });

    testWidgets('左滑露出右侧操作按钮', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('左滑试试')),
        ),
      ),),);
      // 未滑动时按钮被裁剪不可见（内容完全覆盖，按钮文本不在视口内）
      await tester.drag(find.text('左滑试试'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('删除'), findsOneWidget);
      // 吸附展开到位：位移等于 -72（单按钮总宽）
      expect(_contentOffset(tester, '左滑试试').dx, -72);
    });

    testWidgets('按钮 text/color 正确渲染', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '标记', color: Colors.red),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find
            .ancestor(of: find.text('标记'), matching: find.byType(Material))
            .first,
      );
      expect(material.color, Colors.red);
    });

    testWidgets('默认按钮色取主题主色', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '默认色'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find
            .ancestor(of: find.text('默认色'), matching: find.byType(Material))
            .first,
      );
      expect(material.color, AntThemeData.light().colorPrimary);
    });

    testWidgets('点击按钮触发 onPressed 并收起', (tester) async {
      var pressed = false;
      await tester.pumpWidget(_wrap(AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除', onPressed: () => pressed = true),
        ],
        child: const SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
      // 收起后内容位移归零
      expect(_contentOffset(tester, '内容').dx, 0);
    });

    testWidgets('右滑露出左侧操作按钮', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        leftActions: [
          AntSwipeActionItem(text: '置顶'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(find.text('置顶'), findsOneWidget);
      expect(find.byKey(kAntSwipeActionLeftKey), findsOneWidget);
      expect(_contentOffset(tester, '内容').dx, 72);
    });

    testWidgets('disabled 按钮不可点击', (tester) async {
      var pressed = false;
      await tester.pumpWidget(_wrap(AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(
            text: '删除',
            disabled: true,
            onPressed: () => pressed = true,
          ),
        ],
        child: const SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(pressed, isFalse);
      // 禁用按钮点击后保持展开
      expect(_contentOffset(tester, '内容').dx, -72);
    });

    testWidgets('松手吸附动画后停在展开位置', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
          AntSwipeActionItem(text: '收藏'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      // 拖动超过总宽一半（72 > 144/2）自动展开
      await tester.drag(find.text('内容'), const Offset(-80, 0));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -144);
    });

    testWidgets('未超半宽松手回弹关闭', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      // 手动拖动 30（未超过 72/2=36）后松手
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('内容')),
      );
      await gesture.moveBy(const Offset(-30, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, 0);
    });

    testWidgets('多按钮水平排列且宽度一致', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '收藏'),
          AntSwipeActionItem(text: '编辑'),
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 400,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(find.text('收藏'), findsOneWidget);
      expect(find.text('编辑'), findsOneWidget);
      expect(find.text('删除'), findsOneWidget);
      final row = tester.widget<Row>(find.byKey(kAntSwipeActionRightKey));
      expect(row.children.length, 3);
      // 吸附到总宽 = 3 * 72
      expect(_contentOffset(tester, '内容').dx, -216);
    });

    testWidgets('danger 操作按钮渲染错误色', (tester) async {
      final errorColor = AntThemeData.light().colorError;
      await tester.pumpWidget(_wrap(AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '危险操作', color: errorColor),
        ],
        child: const SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find
            .ancestor(
              of: find.text('危险操作'),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, errorColor);
    });

    testWidgets('拖动时内容跟随位移', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('内容')),
      );
      await gesture.moveBy(const Offset(-40, 0));
      await tester.pump();
      // 手指位移 -40，去掉触摸 slop 后跟随 -22
      expect(_contentOffset(tester, '内容').dx, -40);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('closeOnAction=false 点击后保持展开', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        closeOnAction: false,
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -72);
    });

    testWidgets('展开时触发 onOpened 回调', (tester) async {
      String? openedSide;
      await tester.pumpWidget(_wrap(AntSwipeAction(
        rightActions: const [
          AntSwipeActionItem(text: '删除'),
        ],
        onOpened: (side) => openedSide = side,
        child: const SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(openedSide, 'right');
    });

    testWidgets('收起时触发 onClosed 回调', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntSwipeAction(
        rightActions: const [
          AntSwipeActionItem(text: '删除'),
        ],
        onClosed: () => closed = true,
        child: const SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(closed, isFalse);
      // 展开态点击内容收起
      await tester.tap(find.byKey(kAntSwipeActionContentKey));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, 0);
      expect(closed, isTrue);
    });

    /// 模拟 fling：测试环境事件时间戳需手动推进，VelocityTracker 才能算出速度。
    Future<void> flingGesture(
      WidgetTester tester,
      Finder finder,
      double dx,
    ) async {
      final Offset center = tester.getCenter(finder);
      final TestGesture gesture = await tester.startGesture(center);
      await gesture.moveBy(Offset(dx * 0.1, 0));
      await tester.pump(const Duration(milliseconds: 10));
      await gesture.moveBy(Offset(dx * 0.3, 0));
      await tester.pump(const Duration(milliseconds: 10));
      await gesture.moveBy(Offset(dx * 0.6, 0));
      await tester.pump(const Duration(milliseconds: 10));
      await gesture.up();
    }

    testWidgets('fling 快速左甩直接展开', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      // 位移很小（< 72/2）但速度极快：应按 fling 判定直接展开
      await flingGesture(tester, find.text('内容'), -120);
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -72);
    });

    testWidgets('fling 快速右甩（展开态）直接收起', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -72);
      // 向右快甩：未露出左侧按钮，fling 判定收起
      await flingGesture(tester, find.byKey(kAntSwipeActionContentKey), 120);
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, 0);
    });

    testWidgets('rubber-band：超过总宽后弹性阻尼跟随', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
          AntSwipeActionItem(text: '收藏'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      // 总宽 144：先 1:1 拖到 -100、再 1:1 到 -160（事件前未超宽）；
      // 第三步事件前已超宽（160 > 144）→ delta/9 阻尼：-160 - 60/9 ≈ -166.7
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('内容')),
      );
      await gesture.moveBy(const Offset(-100, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, closeTo(-100, 0.1));
      await gesture.moveBy(const Offset(-60, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, closeTo(-160, 0.1));
      await gesture.moveBy(const Offset(-60, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, closeTo(-166.7, 0.2));
      await gesture.up();
      await tester.pumpAndSettle();
      // 松手吸附回展开位
      expect(_contentOffset(tester, '内容').dx, -144);
    });

    testWidgets('rubber-band：过拉距离有上限', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('内容')),
      );
      // 单次大幅拖动：越界被硬夹在 72 + 100 = 172（对齐轮子逐事件语义）
      await gesture.moveBy(const Offset(-600, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, closeTo(-172, 0.2));
      // 继续同向拖动：delta/9 阻尼后仍超上限 → 保持 -172
      await gesture.moveBy(const Offset(-90, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, closeTo(-172, 0.2));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -72);
    });

    testWidgets('snap 动画：松手后逐帧过渡到目标位移', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      await tester.drag(find.text('内容'), const Offset(-60, 0));
      // 动画中间帧：AnimationController 首帧仅启动 ticker（offset 仍为起点），
      // 再推进 100ms 后处于过渡中段（easeOutQuart 前段快）
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 100));
      final double mid = _contentOffset(tester, '内容').dx;
      expect(mid, lessThan(-60));
      expect(mid, greaterThan(-72));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, -72);
    });

    testWidgets('手势竞争：ListView 纵向滚动不触发横滑位移', (tester) async {
      await tester.pumpWidget(_wrap(ListView(
        children: [
          const AntSwipeAction(
            rightActions: [
              AntSwipeActionItem(text: '删除'),
            ],
            child: SizedBox(
              width: 300,
              height: 56,
              child: Center(child: Text('内容')),
            ),
          ),
          for (int i = 0; i < 10; i++) ListTile(title: Text('行 $i')),
        ],
      ),),);
      // 纵向拖动：方向相关识别器不处理纵向手势，内容位移保持 0
      await tester.drag(find.text('内容'), const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(_contentOffset(tester, '内容').dx, 0);
    });

    testWidgets('无对应侧按钮时拖动不产生位移', (tester) async {
      await tester.pumpWidget(_wrap(const AntSwipeAction(
        rightActions: [
          AntSwipeActionItem(text: '删除'),
        ],
        child: SizedBox(
          width: 300,
          height: 56,
          child: Center(child: Text('内容')),
        ),
      ),),);
      // 只有右侧按钮，向右拖动不应产生位移
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('内容')),
      );
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();
      expect(_contentOffset(tester, '内容').dx, 0);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    group('渲染探针：action 可见性与位移联动', () {
      Future<void> pumpProbe(WidgetTester tester) async {
        await tester.pumpWidget(_wrap(const AntSwipeAction(
          rightActions: [
            AntSwipeActionItem(text: '删除'),
          ],
          child: SizedBox(
            width: 300,
            height: 56,
            child: Center(child: Text('内容')),
          ),
        ),),);
        
      }

      testWidgets('拖拽中 action 按钮可见（可视区内非零尺寸）', (tester) async {
        await pumpProbe(tester);
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('内容')),
        );
        await gesture.moveBy(const Offset(-40, 0));
        await tester.pump();

        final Rect actionBox = tester.getRect(find.byKey(kAntSwipeActionRightKey));
        expect(actionBox.width, 72, reason: 'action 区宽度塌陷为 0 则不可见');
        expect(actionBox.height, 56);
        // 视口（组件根）范围内：action 按钮中心必须在可视区
        final Rect viewport = tester.getRect(
          find.ancestor(
            of: find.byKey(kAntSwipeActionRightKey),
            matching: find.byType(ClipRect),
          ).first,
        );
        expect(
          viewport.contains(actionBox.center),
          isTrue,
          reason: 'action 按钮中心应落在可视区内',
        );
        // 内容层背景随位移移走：内容框右缘 = 视口宽 - 40
        expect(
          tester.getRect(find.byKey(kAntSwipeActionContentKey)).right,
          closeTo(viewport.right - 40, 0.5),
          reason: '不透明内容背景必须随位移平移，否则永远盖住 action',
        );
        await gesture.up();
        await tester.pumpAndSettle();
      });

      testWidgets('cell 位移与 action 暴露宽度联动', (tester) async {
        await pumpProbe(tester);
        final Rect viewport = tester.getRect(
          find
              .ancestor(
                of: find.byKey(kAntSwipeActionContentKey),
                matching: find.byType(ClipRect),
              )
              .first,
        );
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('内容')),
        );
        // 逐步拖动：每次 +20px，暴露宽度 = min(|位移|, 72)
        for (int step = 0; step < 5; step++) {
          await gesture.moveBy(const Offset(20, 0));
          await tester.pump();
          final double offset = -_contentOffset(tester, '内容').dx;
          final double exposed = (viewport.right -
                  tester.getRect(find.byKey(kAntSwipeActionContentKey)).right)
              .clamp(0, 72);
          expect(
            exposed,
            closeTo(offset.clamp(0, 72), 0.5),
            reason: '位移 $offset 时 action 暴露宽度应为 ${offset.clamp(0, 72)}',
          );
        }
        await gesture.up();
        await tester.pumpAndSettle();
      });
    });

    group('resolveSnapTarget 松手吸附决策（fling 分支单测）', () {
      const r = AntSwipeAction.resolveSnapTarget;
      // 说明：本 Flutter 版本 DragEndDetails.velocity 在手势判非 fling 时
      // 恒为 0（considerFling 判定），测试环境也无法产生真实速度，
      // 因此 fling 分支通过纯函数单测覆盖。
      test('快速左甩 + 有右侧按钮 → 直接展开右侧', () {
        final result = r(
          velocity: -600,
          offset: -10,
          hasRight: true,
          hasLeft: false,
          rightTotal: 72,
          leftTotal: 0,
        );
        expect(result.target, -72);
        expect(result.open, isTrue);
      });

      test('快速左甩 + 无右侧按钮 → 收起', () {
        final result = r(
          velocity: -600,
          offset: 20,
          hasRight: false,
          hasLeft: true,
          rightTotal: 0,
          leftTotal: 72,
        );
        expect(result.target, 0);
        expect(result.open, isFalse);
      });

      test('快速右甩 + 有左侧按钮 → 直接展开左侧', () {
        final result = r(
          velocity: 600,
          offset: 10,
          hasRight: false,
          hasLeft: true,
          rightTotal: 0,
          leftTotal: 72,
        );
        expect(result.target, 72);
        expect(result.open, isTrue);
      });

      test('快速右甩（左侧按钮未露出）+ 无左侧按钮 → 收起', () {
        final result = r(
          velocity: 600,
          offset: -72,
          hasRight: true,
          hasLeft: false,
          rightTotal: 72,
          leftTotal: 0,
        );
        expect(result.target, 0);
        expect(result.open, isFalse);
      });

      test('无 fling + 未超半宽 → 回弹收起', () {
        final result = r(
          velocity: 0,
          offset: -30,
          hasRight: true,
          hasLeft: false,
          rightTotal: 72,
          leftTotal: 0,
        );
        expect(result.target, 0);
        expect(result.open, isFalse);
      });

      test('无 fling + 超过半宽 → 吸附展开', () {
        final result = r(
          velocity: 0,
          offset: -40,
          hasRight: true,
          hasLeft: false,
          rightTotal: 72,
          leftTotal: 0,
        );
        expect(result.target, -72);
        expect(result.open, isTrue);
      });
    });
  });
}
