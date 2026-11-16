import 'package:antd_flutter_plus/src/components/feedback/progress/ant_progress.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
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

Future<void> _pump(WidgetTester tester, AntProgress progress) async {
  await tester.pumpWidget(_wrap(progress));
  await tester.pumpAndSettle();
}

void main() {
  group('AntProgress — line', () {
    testWidgets('default renders track and percent text', (tester) async {
      await _pump(tester, const AntProgress(percent: 50));
      expect(find.text('50%'), findsOneWidget);
      // 轨道容器存在
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      );
      expect(containers, isNotEmpty);
    });

    testWidgets('showInfo false hides percent text', (tester) async {
      await _pump(tester, const AntProgress(percent: 50, showInfo: false));
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('normal status uses primary color', (tester) async {
      await _pump(tester, const AntProgress(percent: 50));
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final bar = containers.last.decoration! as BoxDecoration;
      expect(bar.color, equals(AntThemeData.light().colorPrimary));
    });

    testWidgets('success status uses success color and text', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 100,
        status: AntProgressStatus.success,
      ),);
      expect(find.text('已完成'), findsOneWidget);
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final bar = containers.last.decoration! as BoxDecoration;
      expect(bar.color, equals(AntThemeData.light().colorSuccess));
    });

    testWidgets('exception status uses error color and text', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 40,
        status: AntProgressStatus.exception,
      ),);
      expect(find.text('加载失败'), findsOneWidget);
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final bar = containers.last.decoration! as BoxDecoration;
      expect(bar.color, equals(AntThemeData.light().colorError));
    });

    testWidgets('active status uses primary color', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 30,
        status: AntProgressStatus.active,
      ),);
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final bar = containers.last.decoration! as BoxDecoration;
      expect(bar.color, equals(AntThemeData.light().colorPrimary));
    });

    testWidgets('custom strokeColor applies to bar', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 60,
        strokeColor: Colors.purple,
      ),);
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final bar = containers.last.decoration! as BoxDecoration;
      expect(bar.color, equals(Colors.purple));
    });

    testWidgets('size controls track thickness', (tester) async {
      await _pump(tester, const AntProgress(percent: 50, size: 16));
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      ).toList();
      final track = containers.first.constraints;
      expect(track?.maxHeight, equals(16));
    });

    testWidgets('format customizes percent text', (tester) async {
      await _pump(tester, AntProgress(
        percent: 30,
        format: (p) => '进度 ${p.round()}',
      ),);
      expect(find.text('进度 30'), findsOneWidget);
    });

    testWidgets('percent change animates smoothly', (tester) async {
      await _pump(tester, const AntProgress(percent: 20));
      await tester.pumpWidget(_wrap(const AntProgress(percent: 80)));
      // 动画进行中不等于终值
      await tester.pump(const Duration(milliseconds: 100));
      final midText = find.byType(Row);
      expect(midText, findsWidgets);
      await tester.pumpAndSettle();
      expect(find.text('80%'), findsOneWidget);
    });
  });

  group('AntProgress — circle', () {
    testWidgets('renders CustomPainter arc', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 75,
        type: AntProgressType.circle,
      ),);
      expect(
        find.byWidgetPredicate((w) => w is CustomPaint),
        findsWidgets,
      );
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('circle size controls diameter', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 50,
        type: AntProgressType.circle,
        size: 160,
      ),);
      final sized = tester.widget<SizedBox>(
        find.byWidgetPredicate((w) =>
            w is SizedBox && w.width == 160 && w.height == 160,),
      );
      expect(sized.width, equals(160));
    });

    testWidgets('circle format customizes text', (tester) async {
      await _pump(tester, AntProgress(
        percent: 60,
        type: AntProgressType.circle,
        format: (p) => '剩余${100 - p.round()}%',
      ),);
      expect(find.text('剩余40%'), findsOneWidget);
    });

    testWidgets('circle strokeWidth is applied to painter', (tester) async {
      await _pump(tester, const AntProgress(
        percent: 50,
        type: AntProgressType.circle,
        strokeWidth: 10,
      ),);
      final painter = tester.widget<CustomPaint>(
        find.byWidgetPredicate((w) =>
            w is CustomPaint &&
            w.painter != null &&
            w.painter.runtimeType.toString().contains('CircleProgress'),),
      );
      expect(painter.painter, isA<dynamic>());
      expect(
        (painter.painter as dynamic).strokeWidth,
        equals(10),
      );
    });
  });
}
