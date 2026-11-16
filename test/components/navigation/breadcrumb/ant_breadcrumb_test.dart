/// AntBreadcrumb Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
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
  group('AntBreadcrumb — 基础渲染', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home'),
          AntBreadcrumbItem(title: 'List'),
          AntBreadcrumbItem(title: 'App'),
        ])),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('List'), findsOneWidget);
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('empty items renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(const AntBreadcrumb()));
      expect(find.byType(AntBreadcrumb), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });

    testWidgets('renders default separator "/"', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home'),
          AntBreadcrumbItem(title: 'App'),
        ])),
      );
      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('renders custom separator', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(
          separator: '>',
          items: [
            AntBreadcrumbItem(title: 'Home'),
            AntBreadcrumbItem(title: 'App'),
          ],
        )),
      );
      expect(find.text('>'), findsOneWidget);
      expect(find.text('/'), findsNothing);
    });

    testWidgets('renders custom separatorWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(AntBreadcrumb(
          separatorWidget: const Icon(Icons.arrow_forward, size: 12),
          items: const [
            AntBreadcrumbItem(title: 'Home'),
            AntBreadcrumbItem(title: 'App'),
          ],
        )),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byIcon(Icons.arrow_forward),
        ),
        findsOneWidget,
      );
      expect(find.text('/'), findsNothing);
    });
  });

  group('AntBreadcrumb — 点击与样式', () {
    testWidgets('clickable item triggers onClick', (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        _wrap(AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: () => clicked = true),
          const AntBreadcrumbItem(title: 'App'),
        ])),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isTrue);
    });

    testWidgets('last item does not trigger onClick', (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        _wrap(AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: () => clicked = true),
        ])),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isFalse);
    });

    testWidgets('clickable item has InkWell', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: null),
          AntBreadcrumbItem(title: 'App'),
        ])),
      );
      // 无 onClick 的项不应有 InkWell
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(
            title: 'Home',
            icon: Icon(Icons.home, size: 14),
          ),
          AntBreadcrumbItem(title: 'App'),
        ])),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byIcon(Icons.home),
        ),
        findsOneWidget,
      );
    });

    testWidgets('titleWidget takes precedence over title', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(
            title: 'Text Title',
            titleWidget: Text('Widget Title'),
          ),
        ])),
      );
      expect(find.text('Widget Title'), findsOneWidget);
      expect(find.text('Text Title'), findsNothing);
    });

    testWidgets('last item text color is colorText', (tester) async {
      late AntThemeData capturedTheme;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedTheme = AntTheme.of(context);
              return const AntBreadcrumb(items: [
                AntBreadcrumbItem(title: 'Home'),
                AntBreadcrumbItem(title: 'App'),
              ]);
            },
          ),
        ),
      );

      final appText = tester.widget<Text>(find.text('App'));
      expect(appText.style?.color, capturedTheme.colorText);

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, capturedTheme.colorTextTertiary);
    });
  });
}