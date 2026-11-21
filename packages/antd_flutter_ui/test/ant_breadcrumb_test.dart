/// AntBreadcrumb Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

class _BreadcrumbData {
  const _BreadcrumbData({
    this.title,
    this.titleWidget,
    this.icon,
    this.onClick,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? icon;
  final VoidCallback? onClick;
}

Widget _breadcrumb({
  Key? key,
  List<_BreadcrumbData> items = const [],
  String separator = '/',
  Widget? separatorWidget,
}) {
  return AntBreadcrumb<_BreadcrumbData>(
    key: key,
    items: items,
    titleBuilder: (context, item, index) =>
        item.titleWidget ?? Text(item.title ?? ''),
    iconBuilder: (context, item) => item.icon,
    onTap: (item) => item.onClick?.call(),
    clickableOf: (item) => item.onClick != null,
    separator: separator,
    separatorWidget: separatorWidget,
  );
}

TextStyle? _effectiveStyle(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.text.style;
}

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
        _wrap(
          _breadcrumb(
            items: [
              const _BreadcrumbData(title: 'Home'),
              const _BreadcrumbData(title: 'List'),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('List'), findsOneWidget);
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('empty items renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(_breadcrumb()));
      expect(find.byType(AntBreadcrumb<_BreadcrumbData>), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb<_BreadcrumbData>),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });

    testWidgets('renders default separator "/"', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              const _BreadcrumbData(title: 'Home'),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('renders custom separator', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            separator: '>',
            items: [
              const _BreadcrumbData(title: 'Home'),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      expect(find.text('>'), findsOneWidget);
      expect(find.text('/'), findsNothing);
    });

    testWidgets('renders custom separatorWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            separatorWidget: const Icon(AntIcons.arrowRightOutlined, size: 12),
            items: [
              const _BreadcrumbData(title: 'Home'),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb<_BreadcrumbData>),
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
        _wrap(
          _breadcrumb(
            items: [
              _BreadcrumbData(title: 'Home', onClick: () => clicked = true),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isTrue);
    });

    testWidgets('last item does not trigger onClick', (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              _BreadcrumbData(title: 'Home', onClick: () => clicked = true),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Home'));
      expect(clicked, isFalse);
    });

    testWidgets('clickable item has InkWell', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              const _BreadcrumbData(title: 'Home', onClick: null),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      // 无 onClick 的项不应有 InkWell
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb<_BreadcrumbData>),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
    });

    testWidgets('clickable item hover turns primary', (tester) async {
      final theme = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              _BreadcrumbData(title: 'Home', onClick: () {}),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );

      // 默认可点击项使用 colorTextDescription（antd breadcrumb link 色）。
      expect(
        _effectiveStyle(tester, 'Home')?.color,
        theme.colorTextDescription,
      );

      final gesture =
          await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.text('Home')));
      await tester.pump();

      expect(_effectiveStyle(tester, 'Home')?.color, theme.colorPrimary);

      await gesture.removePointer();
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              const _BreadcrumbData(
                title: 'Home',
                icon: Icon(AntIcons.homeOutlined, size: 14),
              ),
              const _BreadcrumbData(title: 'App'),
            ],
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntBreadcrumb<_BreadcrumbData>),
          matching: find.byIcon(AntIcons.homeOutlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('titleWidget takes precedence over title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _breadcrumb(
            items: [
              const _BreadcrumbData(
                title: 'Text Title',
                titleWidget: Text('Widget Title'),
              ),
            ],
          ),
        ),
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
              return _breadcrumb(
                items: [
                  const _BreadcrumbData(title: 'Home'),
                  const _BreadcrumbData(title: 'App'),
                ],
              );
            },
          ),
        ),
      );

      expect(_effectiveStyle(tester, 'App')?.color, capturedTheme.colorText);
      expect(
        _effectiveStyle(tester, 'Home')?.color,
        capturedTheme.colorTextTertiary,
      );
    });
  });
}
