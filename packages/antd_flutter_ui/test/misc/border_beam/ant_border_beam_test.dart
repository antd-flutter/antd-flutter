import 'package:antd_flutter_ui/src/misc/border_beam/ant_border_beam.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: Center(child: child)),
        ),
      ),
    ),
  );
}

AntBorderBeamPainter _painter(WidgetTester tester) {
  final customPaint =
      tester.widget<CustomPaint>(find.byKey(kAntBorderBeamPaintKey));
  return customPaint.foregroundPainter! as AntBorderBeamPainter;
}

void main() {
  group('AntBorderBeam', () {
    testWidgets('child 正常渲染', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(
        child: Text('流光卡片'),
      ),),);
      expect(find.text('流光卡片'), findsOneWidget);
    });

    testWidgets('默认边框宽度为 3', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('默认'))));
      expect(_painter(tester).size, kAntBorderBeamDefaultSize);
    });

    testWidgets('自定义边框宽度透传', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntBorderBeam(size: 6, child: Text('宽度'))),
      );
      expect(_painter(tester).size, 6);
    });

    testWidgets('colorPrimary / colorSecondary 双颜色透传', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(
        colorPrimary: Colors.purple,
        colorSecondary: Colors.teal,
        child: Text('双色'),
      ),),);
      final painter = _painter(tester);
      expect(painter.colorPrimary, Colors.purple);
      expect(painter.colorSecondary, Colors.teal);
    });

    testWidgets('未指定颜色时取主题令牌', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('主题'))));
      final painter = _painter(tester);
      expect(painter.colorPrimary, AntThemeData.light().colorPrimary);
      expect(painter.colorSecondary, AntThemeData.light().colorBorder);
    });

    testWidgets('duration 默认 6s，且可自定义', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('周期'))));
      final customPaint =
          tester.widget<CustomPaint>(find.byKey(kAntBorderBeamPaintKey));
      final controller =
          (customPaint.foregroundPainter! as AntBorderBeamPainter)
              .progress as AnimationController;
      expect(
        controller.duration,
        const Duration(seconds: kAntBorderBeamDefaultDurationSeconds),
      );

      await tester.pumpWidget(_wrap(const AntBorderBeam(
        duration: Duration(seconds: 2),
        child: Text('周期2'),
      ),),);
      await tester.pump();
      final controller2 =
          _painter(tester).progress as AnimationController;
      expect(controller2.duration, const Duration(seconds: 2));
    });

    testWidgets('动画运行：pump 后进度变化', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('动画'))));
      final p1 = _painter(tester).progress.value;
      await tester.pump(const Duration(seconds: 1));
      final p2 = _painter(tester).progress.value;
      expect(p2, greaterThan(p1));
      expect(p2, lessThanOrEqualTo(1.0));
    });

    testWidgets('reverse 方向：进度反向', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(
        reverse: true,
        child: Text('反向'),
      ),),);
      final painter = _painter(tester);
      expect(painter.reverse, isTrue);
      // 进度 0.2 时反向有效进度应为 0.8
      (painter.progress as AnimationController).value = 0.2;
      await tester.pump();
      final value = painter.progress.value;
      expect(1 - value, closeTo(0.8, 0.01));
    });

    testWidgets('borderRadius 透传', (tester) async {
      const radius = BorderRadius.all(Radius.circular(24));
      await tester.pumpWidget(_wrap(const AntBorderBeam(
        borderRadius: radius,
        child: Text('圆角'),
      ),),);
      expect(_painter(tester).borderRadius, radius);
    });

    testWidgets('默认圆角取主题令牌', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('默认圆角'))));
      expect(
        _painter(tester).borderRadius,
        BorderRadius.circular(AntThemeData.light().borderRadiusLG),
      );
    });

    testWidgets('initialOffset 设置初始相位', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(
        initialOffset: 0.5,
        child: Text('相位'),
      ),),);
      expect(_painter(tester).progress.value, 0.5);
    });

    testWidgets('CustomPaint 存在且为 foregroundPainter', (tester) async {
      await tester.pumpWidget(_wrap(const AntBorderBeam(child: Text('画笔'))));
      final customPaint =
          tester.widget<CustomPaint>(find.byKey(kAntBorderBeamPaintKey));
      expect(customPaint.foregroundPainter, isA<AntBorderBeamPainter>());
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
