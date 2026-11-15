/// AntFlex Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
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

/// 在 AntFlex 内查找指定类型的 widget
Finder _withinFlex(Finder matching) {
  return find.descendant(of: find.byType(AntFlex), matching: matching);
}

void main() {
  group('AntFlex — 基础渲染', () {
    testWidgets('renders horizontal Flex by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(find.byType(AntFlex), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.direction, Axis.horizontal);
    });

    testWidgets('renders vertical Flex when vertical is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            vertical: true,
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.direction, Axis.vertical);
    });

    testWidgets('renders empty children without error', (tester) async {
      await tester.pumpWidget(_wrap(const AntFlex()));
      expect(find.byType(AntFlex), findsOneWidget);
    });

    testWidgets('mainAxisSize max by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisSize, MainAxisSize.max);
    });

    testWidgets('mainAxisSize min maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            vertical: true,
            mainAxisSize: MainAxisSize.min,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisSize, MainAxisSize.min);
    });
  });

  group('AntFlex — justify 对齐', () {
    testWidgets('justify start maps to MainAxisAlignment.start', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.start,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.start);
    });

    testWidgets('justify end maps to MainAxisAlignment.end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.end,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('justify center maps to MainAxisAlignment.center',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.center,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('justify spaceBetween maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.spaceBetween,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('justify spaceAround maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.spaceAround,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.spaceAround);
    });

    testWidgets('justify spaceEvenly maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            justify: AntFlexJustify.spaceEvenly,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
    });
  });

  group('AntFlex — align 对齐', () {
    testWidgets('align start maps to CrossAxisAlignment.start',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            align: AntFlexAlign.start,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('align end maps to CrossAxisAlignment.end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            align: AntFlexAlign.end,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.end);
    });

    testWidgets('align center maps to CrossAxisAlignment.center',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            align: AntFlexAlign.center,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('align baseline maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            align: AntFlexAlign.baseline,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.baseline);
    });

    testWidgets('align stretch maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            align: AntFlexAlign.stretch,
            children: [SizedBox(height: 20)],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinFlex(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.stretch);
    });
  });

  group('AntFlex — wrap 换行', () {
    testWidgets('renders Wrap when wrap is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(Wrap)), findsOneWidget);
      expect(_withinFlex(find.byType(Flex)), findsNothing);
    });

    testWidgets('Wrap direction is horizontal by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      expect(wrap.direction, Axis.horizontal);
    });

    testWidgets('Wrap direction is vertical when vertical is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            vertical: true,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      expect(wrap.direction, Axis.vertical);
    });

    testWidgets('Wrap alignment maps justify center', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            justify: AntFlexJustify.center,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      expect(wrap.alignment, WrapAlignment.center);
    });

    testWidgets('Wrap cross alignment maps align center', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            align: AntFlexAlign.center,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
    });
  });

  group('AntFlex — gap 间距', () {
    testWidgets('no SizedBox inserted when gap is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('gap small inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.small(),
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );
      // 3 个子元素 → 2 个间距 SizedBox
      expect(_withinFlex(find.byType(SizedBox)), findsNWidgets(2));
    });

    testWidgets('gap middle inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.middle(),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(SizedBox)), findsOneWidget);
    });

    testWidgets('gap large inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.large(),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(SizedBox)), findsOneWidget);
    });

    testWidgets('gap all(value) inserts SizedBox with correct width',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.all(10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinFlex(find.byType(SizedBox)),
      );
      expect(sizedBox.width, isNotNull);
      // screenutil 缩放后值可能不同，验证非零即可
      expect(sizedBox.width! > 0, isTrue);
    });

    testWidgets('gap only(column:) inserts horizontal spacing',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.only(column: 12),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinFlex(find.byType(SizedBox)),
      );
      expect(sizedBox.width, isNotNull);
      expect(sizedBox.height, isNull);
    });

    testWidgets('vertical Flex with gap only(row:) inserts vertical spacing',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            vertical: true,
            gap: AntFlexGap.only(row: 12),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinFlex(find.byType(SizedBox)),
      );
      expect(sizedBox.height, isNotNull);
      expect(sizedBox.width, isNull);
    });

    testWidgets('single child with gap does not insert SizedBox',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.middle(),
            children: [Text('A')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('Wrap mode maps gap to spacing and runSpacing',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            gap: AntFlexGap.all(10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      // 水平 Wrap：spacing = columnGap，runSpacing = rowGap
      expect(wrap.spacing, greaterThan(0));
      expect(wrap.runSpacing, greaterThan(0));
    });

    testWidgets('vertical Wrap maps gap correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            wrap: true,
            vertical: true,
            gap: AntFlexGap.only(row: 6, column: 10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinFlex(find.byType(Wrap)));
      // 垂直 Wrap：spacing = rowGap，runSpacing = columnGap
      expect(wrap.spacing, greaterThan(0));
      expect(wrap.runSpacing, greaterThan(0));
    });

    testWidgets('gap zero does not insert SizedBox', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            gap: AntFlexGap.all(0),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinFlex(find.byType(SizedBox)), findsNothing);
    });
  });

  group('AntFlex — 布局验证', () {
    testWidgets('children are laid out horizontally in order',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            children: [Text('First'), Text('Second')],
          ),
        ),
      );
      final firstRect = tester.getTopLeft(find.text('First'));
      final secondRect = tester.getTopLeft(find.text('Second'));
      expect(secondRect.dx, greaterThan(firstRect.dx));
    });

    testWidgets('children are laid out vertically in order when vertical',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntFlex(
            vertical: true,
            children: [Text('First'), Text('Second')],
          ),
        ),
      );
      final firstRect = tester.getTopLeft(find.text('First'));
      final secondRect = tester.getTopLeft(find.text('Second'));
      expect(secondRect.dy, greaterThan(firstRect.dy));
    });
  });
}