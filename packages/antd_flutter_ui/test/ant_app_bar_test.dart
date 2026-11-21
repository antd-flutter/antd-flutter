import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(
              child: Column(
                children: [child, const Expanded(child: SizedBox())],
              ),
            ),
          ),
        ),
      ),
    );

void main() {
  group('AntAppBar', () {
    testWidgets('renders title centered', (tester) async {
      await tester.pumpWidget(_wrap(const AntAppBar(title: Text('标题'))));
      final title = find.text('标题');
      expect(title, findsOneWidget);
      final box = tester.getRect(title);
      expect((box.center.dx - 400).abs(), lessThan(2));
    });

    testWidgets('renders actions on the right', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAppBar(
            title: Text('标题'),
            actions: [Icon(AntIcons.searchOutlined), Icon(AntIcons.moreOutlined)],
          ),
        ),
      );
      expect(find.byIcon(AntIcons.searchOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.moreOutlined), findsOneWidget);
      final more = tester.getRect(find.byIcon(AntIcons.moreOutlined));
      expect(more.center.dx, greaterThan(760));
    });

    testWidgets('leading hides back arrow', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntAppBar(
            leading: Icon(AntIcons.menuOutlined),
            title: Text('标题'),
          ),
        ),
      );
      expect(find.byIcon(AntIcons.menuOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.leftOutlined), findsNothing);
    });

    testWidgets('shows back arrow when route can pop', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        AntScreenUtilInit(
          builder: (context, _) => MaterialApp(
            navigatorKey: navigatorKey,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    navigatorKey.currentState!.push(
                      MaterialPageRoute<void>(
                        builder: (_) => const Scaffold(
                          body: AntAppBar(title: Text('第二页')),
                        ),
                      ),
                    );
                  },
                  child: const Text('go'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.leftOutlined), findsOneWidget);

      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pumpAndSettle();
      expect(find.text('go'), findsOneWidget);
    });

    testWidgets('supports AntdAppBar alias and border toggle', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntdAppBar(
            title: Text('别名'),
            border: false,
          ),
        ),
      );
      expect(find.byType(AntAppBar), findsOneWidget);
      expect(find.text('别名'), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AntAppBar),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNull);
    });
  });
}
