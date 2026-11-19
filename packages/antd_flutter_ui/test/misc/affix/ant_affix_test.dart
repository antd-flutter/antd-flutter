import 'package:antd_flutter_ui/src/misc/affix/ant_affix.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

ScrollController? _controller;

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

/// 无 Overlay 祖先的极简包裹（不用 MaterialApp/Navigator），
/// 用于验证 Affix 找不到 Overlay 时的降级行为不崩溃。
Widget _wrapNoOverlay(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(600, 600)),
        child: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

/// 可滚动页面：头部 [headHeight]，随后是 AntAffix（高 60），下方为占位内容。
Widget _scrollPage({
  double headHeight = 200,
  double offsetTop = kAntAffixDefaultOffsetTop,
  double? offsetBottom,
  ValueChanged<bool>? onChange,
  Widget? affixChild,
}) {
  _controller?.dispose();
  _controller = ScrollController();
  return SingleChildScrollView(
    controller: _controller,
    child: Column(
      children: [
        Container(
          height: headHeight,
          alignment: Alignment.center,
          child: const Text('头部内容'),
        ),
        AntAffix(
          offsetTop: offsetTop,
          offsetBottom: offsetBottom,
          onChange: onChange,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: affixChild ?? const Text('固钉内容'),
          ),
        ),
        for (var i = 0; i < 30; i++)
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text('内容 $i'),
          ),
      ],
    ),
  );
}

Future<void> _scrollTo(WidgetTester tester, double offset) async {
  _controller!.jumpTo(offset);
  await tester.pumpAndSettle();
}

void main() {
  group('AntAffix', () {
    testWidgets('初始未钉住（onChange 不触发，无位移层）', (tester) async {
      var changed = 0;
      await tester.pumpWidget(_wrap(_scrollPage(onChange: (_) => changed++)));
      await tester.pumpAndSettle();
      expect(changed, 0);
      expect(find.byKey(kAntAffixShiftKey), findsNothing);
    });

    testWidgets('child 正常渲染', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage()));
      expect(find.text('固钉内容'), findsOneWidget);
    });

    testWidgets('offsetTop 触发钉住并回调 true', (tester) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(_scrollPage(offsetTop: 100, onChange: states.add)),
      );
      await _scrollTo(tester, 300);
      expect(states, contains(true));
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
    });

    testWidgets('滚回原位解除钉住并回调 false', (tester) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(_scrollPage(offsetTop: 100, onChange: states.add)),
      );
      await _scrollTo(tester, 300);
      expect(states.last, isTrue);
      await _scrollTo(tester, 0);
      expect(states.last, isFalse);
      expect(find.byKey(kAntAffixShiftKey), findsNothing);
    });

    testWidgets('offsetBottom 触发钉住', (tester) async {
      // 视口 600，threshold = 600 - 400 = 200；固钉初始 bottom=360 > 200
      await tester.pumpWidget(_wrap(_scrollPage(headHeight: 300, offsetBottom: 400)));
      await tester.pumpAndSettle();
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
      // 向下滚动 300 后 originalBottom = 60 < 200，解除
      await _scrollTo(tester, 300);
      expect(find.byKey(kAntAffixShiftKey), findsNothing);
    });

    testWidgets('钉住后位置固定在 offsetTop（顶部偏移断言）', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await _scrollTo(tester, 300);
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).top,
        closeTo(100, 1.0),
      );
    });

    testWidgets('钉住后位置固定在视口底部 offsetBottom（底部偏移断言）', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(headHeight: 300, offsetBottom: 400)));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).bottom,
        closeTo(200, 1.0),
      );
    });

    testWidgets('占位高度保持，下方内容不跳动', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      // 滚动 300：固钉钉住（视觉 top=100），占位仍在原布局流（视觉 top=-100），
      // 下方「内容 0」紧跟占位（视觉 top=-40），布局未跳动
      await _scrollTo(tester, 300);
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).top,
        closeTo(100, 1.0),
      );
      expect(tester.getRect(find.text('内容 0')).top, closeTo(0, 1.0));
    });

    testWidgets('滚动通知驱动位置更新（连续滚动保持钉住）', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await _scrollTo(tester, 150);
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).top,
        closeTo(100, 1.0),
      );
      await _scrollTo(tester, 250);
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).top,
        closeTo(100, 1.0),
      );
    });

    testWidgets('offsetTop=0 默认值：滚过原位即钉住（阈值顶部 0）', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage()));
      await _scrollTo(tester, 260);
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
      expect(
        tester.getRect(find.byKey(kAntAffixChildKey)).top,
        closeTo(0, 1.0),
      );
    });

    testWidgets('钉住时宽度与原位一致', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await tester.pumpAndSettle();
      final before = tester.getRect(find.byKey(kAntAffixChildKey)).width;
      await _scrollTo(tester, 300);
      final after = tester.getRect(find.byKey(kAntAffixChildKey)).width;
      expect(after, before);
    });

    testWidgets('自定义 child（按钮）渲染并可点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(_scrollPage(
        offsetTop: 100,
        affixChild: TextButton(
          onPressed: () => tapped = true,
          child: const Text('固钉按钮'),
        ),
      ),),);
      await _scrollTo(tester, 300);
      await tester.tap(find.text('固钉按钮'));
      expect(tapped, isTrue);
    });

    testWidgets('钉住后 child 挂根 Overlay，脱离滚动容器不被裁剪/遮挡（回归）', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await _scrollTo(tester, 300);
      // 钉住的固钉位于 Overlay 顶层
      final overlay = find.ancestor(
        of: find.byKey(kAntAffixChildKey),
        matching: find.byType(Overlay),
      );
      expect(overlay, findsOneWidget);
      // 且不在滚动视口（SingleChildScrollView）内部 → 不被滚动裁剪
      final insideScroll = find.ancestor(
        of: find.byKey(kAntAffixChildKey),
        matching: find.byType(SingleChildScrollView),
      );
      expect(insideScroll, findsNothing);
      // 固定在 offsetTop 处，视口内可见
      final rect = tester.getRect(find.byKey(kAntAffixChildKey));
      expect(rect.top, closeTo(100, 1.0));
      expect(rect.bottom, greaterThan(100));
    });

    testWidgets('钉住时原布局保留等尺寸占位', (tester) async {
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await tester.pumpAndSettle();
      expect(find.byKey(kAntAffixPlaceholderKey), findsNothing);
      await _scrollTo(tester, 300);
      final placeholder = tester.getRect(find.byKey(kAntAffixPlaceholderKey));
      expect(placeholder.height, 60);
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
    });

    testWidgets('无 Overlay 祖先：降级为原位平移，不崩溃（回归）', (tester) async {
      await tester.pumpWidget(_wrapNoOverlay(_scrollPage(offsetTop: 100)));
      await tester.pumpAndSettle();
      await _scrollTo(tester, 300);
      // 降级模式仍产生钉住层（Transform 平移），不抛 No Overlay 异常
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
      expect(find.byKey(kAntAffixPlaceholderKey), findsNothing);
      final rect = tester.getRect(find.byKey(kAntAffixChildKey));
      expect(rect.top, closeTo(100, 1.0));
    });

    testWidgets('无 Overlay 祖先：滚回原位解除钉住（回归）', (tester) async {
      await tester.pumpWidget(_wrapNoOverlay(_scrollPage(offsetTop: 100)));
      await tester.pumpAndSettle();
      await _scrollTo(tester, 300);
      expect(find.byKey(kAntAffixShiftKey), findsOneWidget);
      await _scrollTo(tester, 0);
      expect(find.byKey(kAntAffixShiftKey), findsNothing);
      expect(find.byKey(kAntAffixChildKey), findsOneWidget);
    });

    testWidgets('钉住触发于滚动监听：Overlay 增删延迟帧末，无 during build 异常（回归）',
        (tester) async {
      final errors = <FlutterErrorDetails>[];
      final original = FlutterError.onError;
      FlutterError.onError = (details) => errors.add(details);
      await tester.pumpWidget(_wrap(_scrollPage(offsetTop: 100)));
      await _scrollTo(tester, 300);
      await _scrollTo(tester, 0);
      await tester.pumpAndSettle();
      FlutterError.onError = original;
      expect(errors, isEmpty);
    });

    testWidgets('同线两个 Affix 依次钉住位置错开不重叠；解除后补位（回归）', (tester) async {
      _controller?.dispose();
      _controller = ScrollController();
      await tester.pumpWidget(_wrap(SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            Container(height: 200, alignment: Alignment.center, child: const Text('头部')),
            // 文档序在前的 B 先钉：top=50
            AntAffix(
              offsetTop: 50,
              child: Container(key: const ValueKey('pinB'), height: 60, alignment: Alignment.center, child: const Text('钉B')),
            ),
            Container(height: 400),
            // A 后钉：同线堆叠 top = 50 + B高度60 = 110
            AntAffix(
              offsetTop: 50,
              child: Container(key: const ValueKey('pinA'), height: 60, alignment: Alignment.center, child: const Text('钉A')),
            ),
            for (var i = 0; i < 30; i++)
              Container(height: 100, alignment: Alignment.center, child: Text('内容 $i')),
          ],
        ),
      ),),);
      await tester.pumpAndSettle();

      // 滚 260：B 钉住（top=50），A 未钉
      await _scrollTo(tester, 260);
      expect(tester.getRect(find.byKey(const ValueKey('pinB'))).top, closeTo(50, 1.0));
      expect(tester.getRect(find.byKey(const ValueKey('pinA'))).top, closeTo(400, 1.0)); // 原位 660-260

      // 滚 660：A 也钉住，同线堆叠 top=110，与 B 错开不重叠
      await _scrollTo(tester, 660);
      expect(tester.getRect(find.byKey(const ValueKey('pinB'))).top, closeTo(50, 1.0));
      expect(tester.getRect(find.byKey(const ValueKey('pinA'))).top, closeTo(110, 1.0));

      // 滚回 260：A 解除，B 上移补位回到 top=50
      await _scrollTo(tester, 260);
      expect(tester.getRect(find.byKey(const ValueKey('pinB'))).top, closeTo(50, 1.0));
      expect(tester.getRect(find.byKey(const ValueKey('pinA'))).top, closeTo(400, 1.0)); // 回到原位
    });
  });
}
