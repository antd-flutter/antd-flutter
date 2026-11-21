/// AntBreadcrumb Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
        ],),),
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
        ],),),
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
        ),),
      );
      expect(find.text('>'), findsOneWidget);
      expect(find.text('/'), findsNothing);
    });

    testWidgets('renders custom separatorWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(
          separatorWidget: Icon(AntIcons.arrowRightOutlined, size: 12),
          items: [
            AntBreadcrumbItem(title: 'Home'),
            AntBreadcrumbItem(title: 'App'),
          ],
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byIcon(AntIcons.arrowRightOutlined),
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
        ],),),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isTrue);
    });

    testWidgets('last item does not trigger onClick', (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        _wrap(AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: () => clicked = true),
        ],),),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isFalse);
    });

    testWidgets('clickable item has InkWell', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: null),
          AntBreadcrumbItem(title: 'App'),
        ],),),
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

    testWidgets('clickable item hover turns primary', (tester) async {
      final theme = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(AntBreadcrumb(items: [
          AntBreadcrumbItem(title: 'Home', onClick: () {}),
          const AntBreadcrumbItem(title: 'App'),
        ],),),
      );

      // 默认可点击项使用 colorTextDescription（antd breadcrumb link 色）。
      expect(
        tester.widget<Text>(find.text('Home')).style?.color,
        theme.colorTextDescription,
      );

      final gesture = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.text('Home')));
      await tester.pump();

      expect(
        tester.widget<Text>(find.text('Home')).style?.color,
        theme.colorPrimary,
      );

      await gesture.removePointer();
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBreadcrumb(items: [
          AntBreadcrumbItem(
            title: 'Home',
            icon: Icon(AntIcons.homeOutlined, size: 14),
          ),
          AntBreadcrumbItem(title: 'App'),
        ],),),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb),
          matching: find.byIcon(AntIcons.homeOutlined),
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
        ],),),
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
              ],);
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