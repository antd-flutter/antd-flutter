/// AntFloatButton Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
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
  group('AntFloatButton', () {
    testWidgets('renders with default icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntFloatButton()));
      expect(find.byType(AntFloatButton), findsOneWidget);
      expect(find.byIcon(AntIcons.fileTextOutlined), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(icon: Icon(AntIcons.closeOutlined))),
      );
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });

    testWidgets('renders custom content', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(content: Text('帮助'))),
      );
      expect(find.text('帮助'), findsOneWidget);
    });

    testWidgets('primary type uses colorPrimary background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(type: AntFloatButtonType.primary)),
      );
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
            of: find.byType(AntFloatButton),
            matching: find.byType(AnimatedContainer),),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorPrimary);
    });

    testWidgets('square shape has border', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(shape: AntFloatButtonShape.square)),
      );
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
            of: find.byType(AntFloatButton),
            matching: find.byType(AnimatedContainer),),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('circle shape has no border', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(shape: AntFloatButtonShape.circle)),
      );
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
            of: find.byType(AntFloatButton),
            matching: find.byType(AnimatedContainer),),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('onClick fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AntFloatButton(onClick: () => tapped = true)),
      );
      await tester.tap(find.byType(AntFloatButton));
      expect(tapped, isTrue);
    });

    testWidgets('disabled button does not fire onClick', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AntFloatButton(disabled: true, onClick: () => tapped = true)),
      );
      await tester.tap(find.byType(AntFloatButton));
      expect(tapped, isFalse);
    });

    testWidgets('badge count renders number', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(badge: AntFloatButtonBadge(count: 5))),
      );
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('badge count=0 does not render', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(badge: AntFloatButtonBadge(count: 0))),
      );
      expect(find.text('0'), findsNothing);
    });

    testWidgets('badge dot renders without count text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(badge: AntFloatButtonBadge(dot: true))),
      );
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('badge overflow shows 99+', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(
          badge: AntFloatButtonBadge(count: 200, overflowCount: 99),
        ),),
      );
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('tooltip wraps button', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButton(tooltip: '帮助')),
      );
      expect(find.byType(Tooltip), findsOneWidget);
    });
  });

  group('AntFloatButtonGroup', () {
    testWidgets('renders only trigger when closed', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButtonGroup(
          children: [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
            AntFloatButton(icon: Icon(AntIcons.questionOutlined)),
          ],
        ),),
      );
      expect(find.byIcon(AntIcons.ellipsisOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.moreOutlined), findsNothing);
      expect(find.byIcon(AntIcons.questionOutlined), findsNothing);
    });

    testWidgets('click trigger expands children', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButtonGroup(
          children: [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
            AntFloatButton(icon: Icon(AntIcons.questionOutlined)),
          ],
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.ellipsisOutlined));
      await tester.pumpAndSettle();
      // 子按钮可见，触发按钮切换为关闭图标
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.moreOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.questionOutlined), findsOneWidget);
    });

    testWidgets('click trigger again collapses', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButtonGroup(
          children: [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
          ],
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.ellipsisOutlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.moreOutlined), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.moreOutlined), findsNothing);
    });

    testWidgets('onOpenChange fires', (tester) async {
      bool? opened;
      await tester.pumpWidget(
        _wrap(AntFloatButtonGroup(
          onOpenChange: (v) => opened = v,
          children: const [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
          ],
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.ellipsisOutlined));
      await tester.pumpAndSettle();
      expect(opened, isTrue);
    });

    testWidgets('controlled open shows children immediately', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButtonGroup(
          open: true,
          children: [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
          ],
        ),),
      );
      expect(find.byIcon(AntIcons.moreOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });

    testWidgets('square shape renders with border container', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntFloatButtonGroup(
          shape: AntFloatButtonShape.square,
          open: true,
          children: [
            AntFloatButton(icon: Icon(AntIcons.moreOutlined)),
          ],
        ),),
      );
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasClippedBordered = containers.any((c) =>
          c.clipBehavior != Clip.none &&
          c.decoration is BoxDecoration &&
          (c.decoration as BoxDecoration).border != null,);
      expect(hasClippedBordered, isTrue);
    });
  });

  group('AntFloatButtonBackTop', () {
    testWidgets('hidden initially', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_backTopWrap(controller));
      expect(_backTopOpacity(tester), 0.0);
    });

    testWidgets('visible after scrolling past visibilityHeight', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_backTopWrap(controller));
      controller.jumpTo(500);
      await tester.pump();
      expect(_backTopOpacity(tester), 1.0);
    });

    testWidgets('click scrolls back to top', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_backTopWrap(controller));
      controller.jumpTo(500);
      await tester.pump();
      await tester.tap(find.byType(AntFloatButtonBackTop));
      await tester.pumpAndSettle();
      expect(controller.position.pixels, 0);
    });

    testWidgets('onClick fires after tap', (tester) async {
      final controller = ScrollController();
      var clicked = false;
      await tester.pumpWidget(_backTopWrap(controller, onClick: () => clicked = true));
      controller.jumpTo(500);
      await tester.pump();
      await tester.tap(find.byType(AntFloatButtonBackTop));
      await tester.pumpAndSettle();
      expect(clicked, isTrue);
    });
  });
}

/// 获取 BackTop 内部 AnimatedOpacity 的当前值。
double _backTopOpacity(WidgetTester tester) {
  final opacity = tester.widget<AnimatedOpacity>(
    find.descendant(
      of: find.byType(AntFloatButtonBackTop),
      matching: find.byType(AnimatedOpacity),
    ),
  );
  return opacity.opacity;
}

/// BackTop 测试专用包装 — 可滚动列表 + 右下角回到顶部按钮。
Widget _backTopWrap(ScrollController controller, {VoidCallback? onClick}) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Stack(
            children: [
              SizedBox(
                height: 300,
                child: ListView(
                  controller: controller,
                  children: List.generate(100, (i) => Text('Item $i')),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: AntFloatButtonBackTop(
                  scrollController: controller,
                  visibilityHeight: 400,
                  onClick: onClick,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}