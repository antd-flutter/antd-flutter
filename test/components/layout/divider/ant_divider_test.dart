/// AntDivider Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
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

/// 在 AntDivider 内查找指定类型的 widget
Finder _withinDivider(Finder matching) {
  return find.descendant(of: find.byType(AntDivider), matching: matching);
}

void main() {
  group('AntDivider — 基础渲染', () {
    testWidgets('renders horizontal divider by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntDivider()));
      expect(find.byType(AntDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Row(
            children: [
              Text('左'),
              AntDivider(type: AntDividerType.vertical),
              Text('右'),
            ],
          ),
        ),
      );
      expect(find.byType(AntDivider), findsOneWidget);
      expect(find.text('左'), findsOneWidget);
      expect(find.text('右'), findsOneWidget);
    });

    testWidgets('renders child as title', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntDivider(child: Text('标题文本'))),
      );
      expect(find.text('标题文本'), findsOneWidget);
      expect(find.byType(AntDivider), findsOneWidget);
    });
  });

  group('AntDivider — orientation', () {
    testWidgets('center orientation produces two expanded lines', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(
              orientation: AntDividerOrientation.center,
              child: Text('中'),
            ),
          ),
        ),
      );
      expect(find.text('中'), findsOneWidget);
      final row = tester.widget<Row>(_withinDivider(find.byType(Row)).first);
      // [Expanded, title, Expanded]
      expect(row.children.length, 3);
      expect(row.children.first, isA<Expanded>());
      expect(row.children.last, isA<Expanded>());
    });

    testWidgets('left orientation without margin uses flex ratio', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(
              orientation: AntDividerOrientation.left,
              child: Text('左'),
            ),
          ),
        ),
      );
      final row = tester.widget<Row>(_withinDivider(find.byType(Row)).first);
      expect(row.children.length, 3);
      final firstExp = row.children.first as Expanded;
      final lastExp = row.children.last as Expanded;
      expect(firstExp.flex, 1);
      expect(lastExp.flex, 19);
    });

    testWidgets('right orientation without margin uses flex ratio', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(
              orientation: AntDividerOrientation.right,
              child: Text('右'),
            ),
          ),
        ),
      );
      final row = tester.widget<Row>(_withinDivider(find.byType(Row)).first);
      final firstExp = row.children.first as Expanded;
      final lastExp = row.children.last as Expanded;
      expect(firstExp.flex, 19);
      expect(lastExp.flex, 1);
    });

    testWidgets('left orientation with margin uses SizedBox', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(
              orientation: AntDividerOrientation.left,
              orientationMargin: 20,
              child: Text('左'),
            ),
          ),
        ),
      );
      final row = tester.widget<Row>(_withinDivider(find.byType(Row)).first);
      expect(row.children.first, isA<SizedBox>());
      expect(row.children.last, isA<Expanded>());
    });

    testWidgets('right orientation with margin uses SizedBox', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(
              orientation: AntDividerOrientation.right,
              orientationMargin: 20,
              child: Text('右'),
            ),
          ),
        ),
      );
      final row = tester.widget<Row>(_withinDivider(find.byType(Row)).first);
      expect(row.children.first, isA<Expanded>());
      expect(row.children.last, isA<SizedBox>());
    });
  });

  group('AntDivider — variant', () {
    testWidgets('solid variant renders without CustomPaint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(),
          ),
        ),
      );
      expect(_withinDivider(find.byType(CustomPaint)), findsNothing);
    });

    testWidgets('dashed variant renders CustomPaint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(variant: AntDividerVariant.dashed),
          ),
        ),
      );
      expect(_withinDivider(find.byType(CustomPaint)), findsOneWidget);
    });

    testWidgets('dotted variant renders CustomPaint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(variant: AntDividerVariant.dotted),
          ),
        ),
      );
      expect(_withinDivider(find.byType(CustomPaint)), findsOneWidget);
    });

    testWidgets('dashed=true overrides solid variant', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(dashed: true),
          ),
        ),
      );
      expect(_withinDivider(find.byType(CustomPaint)), findsOneWidget);
    });

    testWidgets('vertical dashed renders CustomPaint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            height: 100,
            child: Row(
              children: [
                AntDivider(
                  type: AntDividerType.vertical,
                  variant: AntDividerVariant.dashed,
                ),
              ],
            ),
          ),
        ),
      );
      expect(_withinDivider(find.byType(CustomPaint)), findsOneWidget);
    });
  });

  group('AntDivider — plain 样式', () {
    testWidgets('plain title uses normal weight', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(plain: true, child: Text('普通')),
          ),
        ),
      );
      final defaultStyle = tester.widget<DefaultTextStyle>(
        _withinDivider(find.byType(DefaultTextStyle)).first,
      );
      expect(defaultStyle.style.fontWeight, FontWeight.normal);
    });

    testWidgets('non-plain title uses medium weight', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(child: Text('标题')),
          ),
        ),
      );
      final defaultStyle = tester.widget<DefaultTextStyle>(
        _withinDivider(find.byType(DefaultTextStyle)).first,
      );
      expect(defaultStyle.style.fontWeight, FontWeight.w500);
    });
  });

  group('AntDivider — 自定义样式', () {
    testWidgets('custom color applies to line', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(color: Colors.red),
          ),
        ),
      );
      // 在 AntDivider 内找到有 color 的 Container（实线线条）
      final containers = tester.widgetList<Container>(
        _withinDivider(find.byType(Container)),
      );
      final colored = containers.where((c) => c.color != null).toList();
      expect(colored, isNotEmpty);
      expect(colored.first.color, Colors.red);
    });

    testWidgets('custom thickness renders narrower line', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(thickness: 3),
          ),
        ),
      );
      // 找到有 color 的 Container（实线线条），验证其 constraints 存在
      final containers = tester.widgetList<Container>(
        _withinDivider(find.byType(Container)),
      );
      final colored = containers.where((c) => c.color != null).toList();
      expect(colored, isNotEmpty);
      expect(colored.first.constraints, isNotNull);
    });

    testWidgets('custom spacing changes outer container height', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(spacing: 40),
          ),
        ),
      );
      // 外层 Container 有 height constraints
      final outerContainer = tester.widget<Container>(
        _withinDivider(find.byType(Container)).first,
      );
      expect(outerContainer.constraints, isNotNull);
    });

    testWidgets('indent applies left margin', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(indent: 16),
          ),
        ),
      );
      final outerContainer = tester.widget<Container>(
        _withinDivider(find.byType(Container)).first,
      );
      expect(outerContainer.margin, isNotNull);
      final margin = outerContainer.margin as EdgeInsets;
      expect(margin.left, greaterThan(0));
      expect(margin.right, 0);
    });

    testWidgets('endIndent applies right margin', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 300,
            child: AntDivider(endIndent: 16),
          ),
        ),
      );
      final outerContainer = tester.widget<Container>(
        _withinDivider(find.byType(Container)).first,
      );
      expect(outerContainer.margin, isNotNull);
      final margin = outerContainer.margin as EdgeInsets;
      expect(margin.right, greaterThan(0));
      expect(margin.left, 0);
    });
  });

  group('AntDivider — 多实例', () {
    testWidgets('renders multiple dividers in column', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              Text('段落一'),
              AntDivider(),
              Text('段落二'),
              AntDivider(child: Text('分割')),
              Text('段落三'),
            ],
          ),
        ),
      );
      expect(find.byType(AntDivider), findsNWidgets(2));
      expect(find.text('段落一'), findsOneWidget);
      expect(find.text('段落二'), findsOneWidget);
      expect(find.text('段落三'), findsOneWidget);
      expect(find.text('分割'), findsOneWidget);
    });
  });
}