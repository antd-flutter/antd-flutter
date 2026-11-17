import 'package:antd_flutter_ui/src/display/badge/ant_badge.dart';
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
  group('AntBadge', () {
    testWidgets('count renders number', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 5)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('count 0 hidden by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 0)));
      expect(find.text('0'), findsNothing);
    });

    testWidgets('showZero displays count 0', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 0, showZero: true)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('overflowCount shows +N', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 100)));
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('custom overflowCount', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 15, overflowCount: 10)));
      expect(find.text('10+'), findsOneWidget);
    });

    testWidgets('dot mode renders small circle', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(dot: true)));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, 8);
    });

    testWidgets('dot mode with child wraps content', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        dot: true,
        child: Icon(Icons.notifications),
      ),),);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      // badge Stack 应作为 Icon 的祖先存在
      expect(
        find.ancestor(
          of: find.byIcon(Icons.notifications),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });

    testWidgets('badge with child wraps in Stack', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        count: 3,
        child: Text('消息'),
      ),),);
      expect(find.text('消息'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('消息'),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });

    testWidgets('custom color overrides default', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(count: 2, color: Colors.blue)));
      final containers = tester.widgetList<Container>(find.byType(Container));
      final badge = containers.firstWhere(
        (c) => c.decoration is BoxDecoration && (c.decoration! as BoxDecoration).color == Colors.blue,
      );
      expect(badge, isNotNull);
    });

    testWidgets('status success renders dot and text', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        status: AntBadgeStatus.success,
        text: '成功',
      ),),);
      expect(find.text('成功'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('status error renders without text', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        status: AntBadgeStatus.error,
      ),),);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('offset shifts badge position', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        count: 1,
        offset: [10, 10],
        child: SizedBox(width: 40, height: 40),
      ),),);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('null count shows nothing', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge()));
      // 无 count、无 dot、无 status → SizedBox.shrink
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('standalone count does not expand to parent width', (tester) async {
      await tester.pumpWidget(_wrap(const Center(
        child: AntBadge(count: 25),
      ),),);
      await tester.pump();
      // 圆角矩形徽标宽度：内容宽 + 左右对称 padding，且不超过 minWidth(20) 与
      // 内容宽度之和；绝不可在松散宽度约束下撑满父容器（回归独立模式横撑满）。
      final badgeFinder = find.ancestor(
        of: find.text('25'),
        matching: find.byType(Container),
      );
      expect(badgeFinder, findsOneWidget);
      final size = tester.getSize(badgeFinder);
      const badgeSize = 20.0;
      // 徽标必须保持内容自适应宽度，而非在松散宽度约束下撑满父容器。
      expect(size.width, lessThan(100));
      expect(size.height, badgeSize);
    });

    testWidgets('standalone count number fully rendered', (tester) async {
      await tester.pumpWidget(_wrap(const Center(
        child: AntBadge(count: 99),
      ),),);
      await tester.pump();
      expect(tester.takeException(), isNull);
      // 数字文字宽度必须完整落在徽标容器内（无裁剪/溢出）
      final textRect = tester.getRect(find.text('99'));
      final badgeRect = tester.getRect(find.ancestor(
        of: find.text('99'),
        matching: find.byType(Container),
      ),);
      expect(
        badgeRect.contains(textRect.center),
        isTrue,
        reason: '数字中心应位于徽标容器内（文字居中且不溢出）',
      );
      expect(textRect.left, greaterThanOrEqualTo(badgeRect.left));
      expect(textRect.right, lessThanOrEqualTo(badgeRect.right));
    });

    testWidgets('status with child shows badge on child', (tester) async {
      await tester.pumpWidget(_wrap(const AntBadge(
        status: AntBadgeStatus.processing,
        child: Text('处理中'),
      ),),);
      expect(find.text('处理中'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('处理中'),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });
  });
}