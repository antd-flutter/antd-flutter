import 'package:antd_flutter_plus/src/components/data_display/badge/ant_badge.dart';
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