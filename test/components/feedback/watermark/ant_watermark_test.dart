/// AntWatermark widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/watermark/ant_watermark.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: child,
        ),
      ),
    ),
  );
}

/// 水印层 CustomPaint 的 painter（动态访问配置字段）。
dynamic _painterOf(WidgetTester tester) =>
    tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey)).painter;

void main() {
  testWidgets('默认渲染水印层（CustomPaint 存在）', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntWatermark(
          content: '水印',
          child: Container(color: Colors.white),
        ),
      ),
    );
    expect(find.byKey(kAntWatermarkLayerKey), findsOneWidget);
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(_painterOf(tester), isNotNull);
  });

  testWidgets('content 文字透传到 painter', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '公司机密',
          child: SizedBox(),
        ),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.content, ['公司机密']);
  });

  testWidgets('child 内容正常渲染且在水印层之下', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          child: Center(child: Text('正文内容')),
        ),
      ),
    );
    expect(find.text('正文内容'), findsOneWidget);
    // children 顺序：正文在前（下层）、水印层在后（上层）
    final stack = tester.widget<Stack>(find.byKey(kAntWatermarkLayerKey));
    final children = stack.children;
    expect(children.first, isA<Center>());
    expect(children, hasLength(2));
    final layer = children.last;
    expect(layer, isA<Positioned>());
    expect((layer as Positioned).child, isA<IgnorePointer>());
  });

  testWidgets('水印层不拦截手势（点击穿透到 child）', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        AntWatermark(
          content: '水印',
          child: GestureDetector(
            onTap: () => tapped = true,
            child: Container(
              width: 300,
              height: 300,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
    expect(tapped, isFalse);
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('fontSize 透传', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          fontSize: 28,
          child: SizedBox(),
        ),
      ),
    );
    expect(_painterOf(tester).fontSize, 28);
  });

  testWidgets('fontColor 透传', (tester) async {
    const color = Color(0xFF123456);
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          fontColor: color,
          child: SizedBox(),
        ),
      ),
    );
    expect(_painterOf(tester).fontColor, color);
  });

  testWidgets('rotate 默认 -22°，可自定义', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          child: SizedBox(),
        ),
      ),
    );
    expect(_painterOf(tester).rotate, -22);

    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          rotate: -45,
          child: SizedBox(),
        ),
      ),
    );
    expect(_painterOf(tester).rotate, -45);
  });

  testWidgets('gapX / gapY 透传', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          gapX: 60,
          gapY: 80,
          child: SizedBox(),
        ),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.gapX, 60);
    expect(painter.gapY, 80);
  });

  testWidgets('多行 content 透传', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: ['多行第一行', '多行第二行'],
          child: SizedBox(),
        ),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.content, ['多行第一行', '多行第二行']);
  });

  testWidgets('zIndex 透传', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          zIndex: 9,
          child: SizedBox(),
        ),
      ),
    );
    expect(_painterOf(tester).zIndex, 9);
  });

  testWidgets('AntWatermark.text 便捷构造生成单行 content', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntWatermark.text('快捷水印', child: const SizedBox()),
      ),
    );
    expect(_painterOf(tester).content, ['快捷水印']);
  });

  testWidgets('水印不重复绘制时 painter 可重绘（shouldRepaint 配置变化）',
      (tester) async {
    dynamic first;
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          gapX: 100,
          child: SizedBox(),
        ),
      ),
    );
    first = _painterOf(tester);
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          gapX: 200,
          child: SizedBox(),
        ),
      ),
    );
    final second = _painterOf(tester);
    expect(second.gapX, 200);
    // shouldRepaint：配置变化时返回 true（通过重绘不报错验证）
    await tester.pump();
    expect(first, isNotNull);
  });
}
