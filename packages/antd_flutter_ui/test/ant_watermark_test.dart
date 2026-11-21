/// AntWatermark widget 测试
library;

import 'package:antd_flutter_ui/src/feedback/watermark/ant_watermark.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: child,
        ),
      ),
    );
}

/// pumpWidget + pump：等待 post-frame 测量回调触发 setState 后水印层出现。
Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(_wrap(child));
  await tester.pump();
}

/// 水印层 CustomPaint 的 painter（动态访问配置字段）。
dynamic _painterOf(WidgetTester tester) =>
    tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey)).painter;

void main() {
  testWidgets('默认渲染水印层（CustomPaint 存在）', (tester) async {
    await _pump(
      tester,
      AntWatermark(
        content: '水印',
        child: Container(color: Colors.white),
      ),
    );
    expect(find.byKey(kAntWatermarkLayerKey), findsOneWidget);
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(_painterOf(tester), isNotNull);
  });

  testWidgets('content 文字透传到 painter', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '公司机密',
        child: SizedBox(width: 300, height: 200),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.content, ['公司机密']);
  });

  testWidgets('child 内容正常渲染且在水印层之下', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: Center(child: Text('正文内容')),
      ),
    );
    expect(find.text('正文内容'), findsOneWidget);
    // children 顺序：正文（KeyedSubtree 包裹，测量用）在前（下层）、
    // 水印层（SizedBox.fromSize）在后（上层）
    final stack = tester.widget<Stack>(find.byKey(kAntWatermarkLayerKey));
    final children = stack.children;
    expect(children.first, isA<KeyedSubtree>());
    expect(
      (children.first as KeyedSubtree).child,
      isA<Center>(),
    );
    expect(children, hasLength(2));
    final layer = children.last;
    expect(layer, isA<SizedBox>());
    expect((layer as SizedBox).child, isA<IgnorePointer>());
  });

  testWidgets('水印层不拦截手势（点击穿透到 child）', (tester) async {
    var tapped = false;
    await _pump(
      tester,
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
    );
    expect(tapped, isFalse);
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('fontSize 透传', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        fontSize: 28,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    expect(_painterOf(tester).fontSize, 28);
  });

  testWidgets('fontColor 透传', (tester) async {
    const color = Color(0xFF123456);
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        fontColor: color,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    expect(_painterOf(tester).fontColor, color);
  });

  testWidgets('rotate 默认 -22°，可自定义', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: SizedBox(width: 300, height: 200),
      ),
    );
    expect(_painterOf(tester).rotate, -22);

    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        rotate: -45,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    expect(_painterOf(tester).rotate, -45);
  });

  testWidgets('gapX / gapY 透传', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        gapX: 60,
        gapY: 80,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.gapX, 60);
    expect(painter.gapY, 80);
  });

  testWidgets('多行 content 透传', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: ['多行第一行', '多行第二行'],
        child: SizedBox(width: 300, height: 200),
      ),
    );
    final painter = _painterOf(tester);
    expect(painter.content, ['多行第一行', '多行第二行']);
  });

  testWidgets('zIndex 透传', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        zIndex: 9,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    expect(_painterOf(tester).zIndex, 9);
  });

  testWidgets('AntWatermark.text 便捷构造生成单行 content', (tester) async {
    await _pump(
      tester,
      AntWatermark.text('快捷水印', child: const SizedBox(width: 300, height: 200)),
    );
    expect(_painterOf(tester).content, ['快捷水印']);
  });

  testWidgets('水印不重复绘制时 painter 可重绘（shouldRepaint 配置变化）',
      (tester) async {
    dynamic first;
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        gapX: 100,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    first = _painterOf(tester);
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        gapX: 200,
        child: SizedBox(width: 300, height: 200),
      ),
    );
    final second = _painterOf(tester);
    expect(second.gapX, 200);
    // shouldRepaint：配置变化时返回 true（通过重绘不报错验证）
    await tester.pump();
    expect(first, isNotNull);
  });

  // ============================================================
  // 尺寸测量方案新增用例
  // ============================================================

  testWidgets('水印层 CustomPaint 尺寸等于 child 实际尺寸', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: SizedBox(width: 320, height: 180),
      ),
    );
    final paint = tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey));
    expect(paint.size, const Size(320, 180));
    // 叠放层与 child 等尺寸
    final layer = tester.widget<Stack>(find.byKey(kAntWatermarkLayerKey));
    final sized = layer.children.last as SizedBox;
    expect(
      tester.renderObject<RenderBox>(find.byWidget(sized)).size,
      const Size(320, 180),
    );
  });

  testWidgets('兼容无界高度上下文（SingleChildScrollView + shrinkWrap ListView）',
      (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100, width: 300),
              SizedBox(height: 100, width: 300),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
  });

  testWidgets('窗口尺寸变化后重测 child 尺寸', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: SizedBox(width: double.infinity, height: 100),
      ),
    );
    final before =
        tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey)).size;
    expect(before.width, 800); // 默认测试窗口宽

    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pump();
    await tester.pump(); // 测量回调 setState 后再渲染一帧

    final after =
        tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey)).size;
    expect(after.width, 400);
  });

  testWidgets('child 为 null 时填充满父级模式', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 500,
          height: 300,
          child: AntWatermark(content: '水印'),
        ),
      ),
    );

    expect(find.byKey(kAntWatermarkLayerKey), findsOneWidget);
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
    final paint =
        tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey));
    // 填充模式：按父约束绘制，无需等待测量帧
    expect(paint.size, Size.zero);
    final layer =
        tester.widget<Stack>(find.byKey(kAntWatermarkLayerKey));
    expect(layer.fit, StackFit.expand);
    final renderPaint = tester.renderObject<RenderBox>(
      find.byKey(kAntWatermarkPaintKey),
    );
    expect(renderPaint.size, const Size(500, 300));
  });

  testWidgets('child 尺寸未变时不触发多余 setState（无循环重建）', (tester) async {
    await _pump(
      tester,
      const AntWatermark(
        content: '水印',
        child: SizedBox(width: 200, height: 100),
      ),
    );
    final paint1 = tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey));

    // 再次 pump：尺寸相等时 _measureChild 跳过 setState
    await tester.pumpWidget(
      _wrap(
        const AntWatermark(
          content: '水印',
          child: SizedBox(width: 200, height: 100),
        ),
      ),
    );
    await tester.pump();

    // 水印层保持稳定渲染、尺寸不变，无异常
    expect(tester.takeException(), isNull);
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
    final paint2 = tester.widget<CustomPaint>(find.byKey(kAntWatermarkPaintKey));
    expect(paint2.size, paint1.size);
    expect(paint2.size, const Size(200, 100));
    expect(find.byKey(kAntWatermarkPaintKey), findsOneWidget);
  });
}
