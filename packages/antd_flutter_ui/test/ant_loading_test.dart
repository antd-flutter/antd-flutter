import 'package:antd_flutter_ui/src/feedback/loading/ant_loading.dart';
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

void main() {
  group('AntLoading', () {
    testWidgets('默认渲染转圈图标', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading()));
      expect(find.byKey(kAntLoadingRingKey), findsOneWidget);
      expect(find.byKey(kAntLoadingRotateKey), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('默认尺寸为 18', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading()));
      final box = tester.widget<SizedBox>(
        find.byKey(kAntLoadingRingKey),
      );
      expect(box.width, 18);
      expect(box.height, 18);
    });

    testWidgets('size 尺寸生效', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading(size: 32)));
      final box = tester.widget<SizedBox>(
        find.byKey(kAntLoadingRingKey),
      );
      expect(box.width, 32);
      expect(box.height, 32);
    });

    testWidgets('默认颜色取主题主色', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading()));
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byKey(kAntLoadingRingKey),
          matching: find.byType(CustomPaint),
        ),
      ).painter! as dynamic;
      expect(paint.paintColor, AntThemeData.light().colorPrimary);
    });

    testWidgets('color 自定义颜色生效', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading(color: Colors.purple)));
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byKey(kAntLoadingRingKey),
          matching: find.byType(CustomPaint),
        ),
      ).painter! as dynamic;
      expect(paint.paintColor, Colors.purple);
    });

    testWidgets('动画运行：controller 处于循环状态且角度变化', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading()));
      final rotation = tester.widget<RotationTransition>(
        find.byKey(kAntLoadingRotateKey),
      );
      final controller = rotation.turns as AnimationController;
      expect(controller.isAnimating, isTrue);
      final first = controller.value;
      await tester.pump(const Duration(milliseconds: 150));
      expect(controller.value, isNot(equals(first)));
    });

    testWidgets('child 包裹组合：图标 + 内容并排', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading(child: Text('加载中'))));
      expect(find.text('加载中'), findsOneWidget);
      expect(find.byKey(kAntLoadingRingKey), findsOneWidget);
      // 默认 row 方向
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('direction=column 内容排在图标下方', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading(
        direction: AntLoadingDirection.column,
        child: Text('加载中'),
      ),),);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('自定义旋转速度生效', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading(
        speed: AntLoadingSpeed.fast,
      ),),);
      final rotation = tester.widget<RotationTransition>(
        find.byKey(kAntLoadingRotateKey),
      );
      final controller = rotation.turns as AnimationController;
      // fast = 2 圈/秒 → 单圈时长 500ms
      expect(controller.duration, const Duration(milliseconds: 500));
      expect(
        AntLoadingSpeed.fast.revolutionsPerSecond,
        2,
      );
      expect(
        AntLoadingSpeed.slow.revolutionsPerSecond,
        0.8,
      );
    });

    testWidgets('圆弧绘制常量对齐 3/4 圆弧规格', (tester) async {
      await tester.pumpWidget(_wrap(const AntLoading()));
      expect(kAntLoadingStrokeWidth, 2);
      // 3/4 圆弧约为 4.7 弧度，取 4.6 保持缺口观感
      expect(kAntLoadingArcSweep, greaterThan(3.14159265));
      expect(kAntLoadingArcSweep, lessThan(2 * 3.14159265));
      expect(kAntLoadingSize, 18);
    });
  });
}
