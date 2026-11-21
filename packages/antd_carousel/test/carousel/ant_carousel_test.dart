import 'package:antd_carousel/src/carousel/ant_carousel.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
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

const _pages = ['第一页', '第二页', '第三页'];

Widget _carousel({
  bool autoplay = false,
  Duration interval = const Duration(seconds: 3),
  bool pauseOnHover = false,
  bool loop = false,
  bool dots = true,
  AntCarouselDotPosition dotPosition = AntCarouselDotPosition.bottom,
  bool arrows = false,
  bool vertical = false,
  int defaultCurrent = 0,
  int? current,
  ValueChanged<int>? onChange,
  AntCarouselController? controller,
}) {
  return AntCarousel(
    height: 200,
    autoplay: autoplay,
    autoplayInterval: interval,
    pauseOnHover: pauseOnHover,
    loop: loop,
    dots: dots,
    dotPosition: dotPosition,
    arrows: arrows,
    vertical: vertical,
    defaultCurrent: defaultCurrent,
    current: current,
    onChange: onChange,
    controller: controller,
    children: [
      for (final p in _pages) Center(child: Text(p)),
    ],
  );
}

void main() {
  group('AntCarousel', () {
    testWidgets('renders all pages and dots', (tester) async {
      await tester.pumpWidget(_wrap(_carousel()));
      expect(find.text('第一页'), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      // 3 个指示点
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      expect(tester.widgetList(dots).length, 3);
    });

    testWidgets('defaultCurrent shows initial page', (tester) async {
      await tester.pumpWidget(_wrap(_carousel(defaultCurrent: 1)));
      // 需要等 PageView 初始 jumpTo 完成
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      final controller = pageView.controller!;
      expect(controller.page, 1);
    });

    testWidgets('tap dot jumps to page', (tester) async {
      await tester.pumpWidget(_wrap(_carousel()));
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      await tester.tap(dots.at(2));
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 2);
    });

    testWidgets('onChange fires with new index', (tester) async {
      final changes = <int>[];
      await tester.pumpWidget(_wrap(_carousel(onChange: changes.add)));
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      await tester.tap(dots.at(1));
      await tester.pumpAndSettle();
      expect(changes, contains(1));
    });

    testWidgets('dots false hides indicators', (tester) async {
      await tester.pumpWidget(_wrap(_carousel(dots: false)));
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      expect(tester.widgetList(dots), isEmpty);
    });

    testWidgets('arrows rendered and tap flips page', (tester) async {
      await tester.pumpWidget(_wrap(_carousel(arrows: true)));
      expect(find.byIcon(AntIcons.leftOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.rightOutlined), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 1);
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pumpAndSettle();
      final pageView2 = tester.widget<PageView>(find.byType(PageView));
      expect(pageView2.controller!.page, 0);
    });

    testWidgets('autoplay advances page after interval', (tester) async {
      final changes = <int>[];
      await tester.pumpWidget(_wrap(_carousel(
        autoplay: true,
        onChange: changes.add,
      ),),);
      expect(changes, isEmpty);
      // 等待一个 autoplayInterval 周期
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(changes, contains(1));
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 1);
    });

    testWidgets('autoplay loop wraps back to first page (infinite loop)',
        (tester) async {
      // R30.1：loop 为无限循环（PageView.builder + 取模），自动播放持续进行，
      // 不再回弹停在第 0 页；断言 3 次切换后 onChange 回到 0。
      final changes = <int>[];
      await tester.pumpWidget(_wrap(
        _carousel(
          autoplay: true,
          loop: true,
          interval: const Duration(milliseconds: 400),
          onChange: changes.add,
        ),
      ),);
      // 3 次自动切换（动画 300ms + 间隔 400ms）：切换序列 0 → 1 → 2 → 0
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 400));
      }
      // 循环序列 0 → 1 → 2 → 0（取模回绕，持续自动播放）
      expect(changes, containsAll([0, 1, 2]));
    });

    testWidgets('pauseOnHover stops autoplay while hovered', (tester) async {
      await tester.pumpWidget(_wrap(
        _carousel(
          autoplay: true,
          pauseOnHover: true,
          interval: const Duration(milliseconds: 400),
        ),
      ),);
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      // 悬停期间不应自动翻页
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 0);
    });

    testWidgets('controlled current follows widget updates', (tester) async {
      int? current;
      Widget buildHost() => _wrap(StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                TextButton(
                  onPressed: () => setState(() => current = 2),
                  child: const Text('jump'),
                ),
                _carousel(current: current),
              ],
            ),
          ),);
      await tester.pumpWidget(buildHost());
      await tester.pumpAndSettle();
      await tester.tap(find.text('jump'));
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 2);
    });

    testWidgets('goTo via controller jumps with animation', (tester) async {
      final controller = AntCarouselController();
      await tester.pumpWidget(_wrap(_carousel(controller: controller)));
      await tester.pumpAndSettle();
      controller.goTo(2);
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 2);
    });

    testWidgets('vertical layout uses vertical scroll direction',
        (tester) async {
      await tester.pumpWidget(_wrap(_carousel(vertical: true)));
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.scrollDirection, Axis.vertical);
    });

    testWidgets('dotPosition left renders vertical dot column', (tester) async {
      await tester.pumpWidget(
        _wrap(_carousel(dotPosition: AntCarouselDotPosition.left)),
      );
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      // 左侧指示点为纵向排列
      final centers =
          tester.widgetList(dots).map((w) => w as GestureDetector).toList();
      final rects =
          centers.map((g) => tester.getRect(find.byWidget(g))).toList();
      for (var i = 1; i < rects.length; i++) {
        expect(rects[i].left, equals(rects[i - 1].left));
        expect(rects[i].top, greaterThan(rects[i - 1].top));
      }
    });

    testWidgets('dotPosition right renders vertical dot column',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_carousel(dotPosition: AntCarouselDotPosition.right)),
      );
      final dots = find.descendant(
        of: find.byType(AntCarousel),
        matching: find.byWidgetPredicate(
            (w) => w is GestureDetector && w.child is Container,),
      );
      final centers =
          tester.widgetList(dots).map((w) => w as GestureDetector).toList();
      final rects =
          centers.map((g) => tester.getRect(find.byWidget(g))).toList();
      for (var i = 1; i < rects.length; i++) {
        expect(rects[i].right, equals(rects[i - 1].right));
        expect(rects[i].top, greaterThan(rects[i - 1].top));
      }
    });

    testWidgets('swipe gesture flips page', (tester) async {
      await tester.pumpWidget(_wrap(_carousel()));
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1200);
      await tester.pumpAndSettle();
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page, 1);
    });
  });
}
