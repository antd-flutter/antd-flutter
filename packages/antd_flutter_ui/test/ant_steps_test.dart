/// AntSteps Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
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

List<AntStepsItem> _sampleItems() => const [
      AntStepsItem(title: 'Finished'),
      AntStepsItem(title: 'In Progress'),
      AntStepsItem(title: 'Waiting'),
    ];

void main() {
  group('AntSteps — 基础渲染', () {
    testWidgets('renders all step titles', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(current: 1, items: _sampleItems())),
      );
      expect(find.text('Finished'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Waiting'), findsOneWidget);
    });

    testWidgets('empty items renders SizedBox.shrink', (tester) async {
      await tester.pumpWidget(_wrap(const AntSteps()));
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byType(SizedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSteps(
          current: 0,
          items: [
            AntStepsItem(title: 'Step 1', description: 'Description 1'),
            AntStepsItem(title: 'Step 2'),
          ],
        ),),
      );
      expect(find.text('Description 1'), findsOneWidget);
    });

    testWidgets('horizontal layout uses Row', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(
          direction: AntStepsDirection.horizontal,
          items: _sampleItems(),
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byType(Row),
        ),
        findsWidgets,
      );
    });

    testWidgets('vertical layout uses Column', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(
          direction: AntStepsDirection.vertical,
          items: _sampleItems(),
        ),),
      );
      // 垂直布局顶层是 Column
      final stepsFinder = find.byType(AntSteps);
      final columns = find.descendant(
        of: stepsFinder,
        matching: find.byType(Column),
      );
      expect(columns, findsWidgets);
    });
  });

  group('AntSteps — 状态', () {
    testWidgets('finish status shows check icon', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(current: 1, items: _sampleItems())),
      );
      // index 0 是 finish 状态
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
    });

    testWidgets('process status shows index number in primary circle',
        (tester) async {
      late AntThemeData capturedTheme;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedTheme = AntTheme.of(context);
              return AntSteps(current: 0, items: _sampleItems());
            },
          ),
        ),
      );

      // process 状态圆圈背景为 colorPrimary
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byType(Container),
        ),
      );
      final processCircle = containers.where((c) {
        final decoration = c.decoration;
        if (decoration is! BoxDecoration) return false;
        return decoration.shape == BoxShape.circle &&
            decoration.color == capturedTheme.colorPrimary;
      });
      expect(processCircle, isNotEmpty);

      // process 显示数字 '1'
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('wait status shows index number with tertiary color',
        (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(current: 0, items: _sampleItems())),
      );
      // wait 步骤显示数字 '2' 和 '3'
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('error status shows close icon', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(
          current: 1,
          status: AntStepsStatus.error,
          items: _sampleItems(),
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byIcon(Icons.close),
        ),
        findsOneWidget,
      );
    });

    testWidgets('item.status overrides computed status', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSteps(
          current: 0,
          items: [
            AntStepsItem(
              title: 'Step 1',
              status: AntStepsStatus.error,
            ),
            AntStepsItem(title: 'Step 2'),
          ],
        ),),
      );
      // 即使 index < current 应该是 finish，但 item.status 指定 error
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byIcon(Icons.close),
        ),
        findsOneWidget,
      );
    });
  });

  group('AntSteps — 点击', () {
    testWidgets('onChange triggered on clickable step', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        _wrap(AntSteps(
          current: 0,
          items: _sampleItems(),
          onChange: (i) => tappedIndex = i,
        ),),
      );
      // 点击第 2 步（index 1）
      await tester.tap(find.text('2'));
      expect(tappedIndex, 1);
    });

    testWidgets('current step is not clickable', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        _wrap(AntSteps(
          current: 1,
          items: _sampleItems(),
          onChange: (i) => tappedIndex = i,
        ),),
      );
      // 点击当前步骤（显示数字 '2'）不应触发
      await tester.tap(find.text('2'));
      expect(tappedIndex, -1);
    });

    testWidgets('disabled step is not clickable', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        _wrap(AntSteps(
          current: 0,
          items: const [
            AntStepsItem(title: 'Step 1'),
            AntStepsItem(title: 'Step 2', disabled: true),
            AntStepsItem(title: 'Step 3'),
          ],
          onChange: (i) => tappedIndex = i,
        ),),
      );
      // 点击 disabled 步骤（数字 '2'）不应触发
      await tester.tap(find.text('2'));
      expect(tappedIndex, -1);
    });

    testWidgets('no GestureDetector without onChange', (tester) async {
      await tester.pumpWidget(
        _wrap(AntSteps(current: 0, items: _sampleItems())),
      );
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });
  });

  group('AntSteps — 尺寸与图标', () {
    testWidgets('small size has smaller circle', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSteps(
            size: AntStepsSize.small,
            items: [
              AntStepsItem(title: 'Step 1'),
              AntStepsItem(title: 'Step 2'),
              AntStepsItem(title: 'Step 3'),
            ],
          ),
        ),
      );

      // small 圆圈 24x24
      final circleContainers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byType(Container),
        ),
      );
      final smallCircles = circleContainers.where((c) {
        final decoration = c.decoration;
        if (decoration is! BoxDecoration) return false;
        return decoration.shape == BoxShape.circle;
      });
      expect(smallCircles, isNotEmpty);
      for (final c in smallCircles) {
        expect(c.constraints?.maxWidth, 24);
        expect(c.constraints?.maxHeight, 24);
      }
    });

    testWidgets('custom icon replaces default circle content',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSteps(
          current: 0,
          items: [
            AntStepsItem(
              title: 'Step 1',
              icon: Icon(Icons.star, size: 16),
            ),
            AntStepsItem(title: 'Step 2'),
          ],
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntSteps),
          matching: find.byIcon(Icons.star),
        ),
        findsOneWidget,
      );
      // 自定义 icon 的步骤不显示默认数字
      expect(find.text('1'), findsNothing);
    });
  });
}
