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
  });
}
