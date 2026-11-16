import 'package:antd_flutter_plus/src/components/feedback/spin/ant_spin.dart';
import 'package:antd_theme/antd_theme.dart';
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

/// AntSpin 结构内的自定义圆环绘制器数量
int _ringCount(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .where((cp) => cp.painter != null && cp.painter.runtimeType.toString() == '_SpinRingPainter')
      .length;
}

void main() {
  group('AntSpin', () {
    testWidgets('default renders spinning ring', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      await tester.pump();
      expect(_ringCount(tester), 1);
    });

    testWidgets('small size uses 14px indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(size: AntSpinSize.small)));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 14);
    });

    testWidgets('large size uses 32px indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(size: AntSpinSize.large)));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 32);
    });

    testWidgets('middle size is default 20px', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 20);
    });

    testWidgets('tip renders below indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(tip: '加载中...')));
      await tester.pump();
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('no tip by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      // 仅有指示器，无额外文本
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('child wrapper shows mask when spinning', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: true,
        tip: '加载中...',
        child: SizedBox(width: 200, height: 200, child: Text('列表内容')),
      ),),);
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsOneWidget);
      expect(find.text('列表内容'), findsOneWidget);
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('spinning=false has no mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: false,
        tip: '加载中...',
        child: SizedBox(width: 200, height: 200, child: Text('列表内容')),
      ),),);
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsNothing);
      expect(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
      expect(find.text('列表内容'), findsOneWidget);
    });

    testWidgets('custom indicator replaces default ring', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        indicator: Icon(Icons.autorenew, key: Key('my-indicator')),
      ),),);
      await tester.pump();
      expect(find.byKey(const Key('my-indicator')), findsOneWidget);
      expect(_ringCount(tester), 0);
    });

    testWidgets('nested content renders under mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: true,
        child: Column(
          children: [
            Text('第一行'),
            Text('第二行'),
          ],
        ),
      ),),);
      await tester.pump();
      expect(find.text('第一行'), findsOneWidget);
      expect(find.text('第二行'), findsOneWidget);
      expect(find.byKey(kAntSpinMaskKey), findsOneWidget);
    });

    testWidgets('standalone mode has no mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(tip: '独立模式')));
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsNothing);
      expect(find.text('独立模式'), findsOneWidget);
    });

    testWidgets('custom size applies to indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        indicator: SizedBox(
          width: 50,
          height: 50,
          key: Key('custom-size'),
          child: FlutterLogo(),
        ),
      ),),);
      await tester.pump();
      final box = tester.widget<SizedBox>(find.byKey(const Key('custom-size')));
      expect(box.width, 50);
    });
  });
}
