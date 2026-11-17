/// AntSpace Widget 测试
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

/// 在 AntSpace 内查找指定类型的 widget
Finder _withinSpace(Finder matching) {
  return find.descendant(of: find.byType(AntSpace), matching: matching);
}

void main() {
  group('AntSpace — 基础渲染', () {
    testWidgets('renders horizontal Flex by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(find.byType(AntSpace), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.direction, Axis.horizontal);
    });

    testWidgets('renders vertical Flex when direction is vertical',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.direction, Axis.vertical);
    });

    testWidgets('renders empty children without error', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpace()));
      expect(find.byType(AntSpace), findsOneWidget);
    });

    testWidgets('renders single child without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSpace(children: [Text('A')])),
      );
      expect(find.text('A'), findsOneWidget);
    });
  });

  group('AntSpace — align 对齐', () {
    testWidgets('default horizontal align is center', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('default vertical align is start', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('align start maps to CrossAxisAlignment.start',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            align: AntSpaceAlign.start,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('align end maps to CrossAxisAlignment.end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            align: AntSpaceAlign.end,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.end);
    });

    testWidgets('align center maps to CrossAxisAlignment.center',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            align: AntSpaceAlign.center,
            children: [Text('A')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('align baseline sets textBaseline', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            align: AntSpaceAlign.baseline,
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final flex = tester.widget<Flex>(_withinSpace(find.byType(Flex)));
      expect(flex.crossAxisAlignment, CrossAxisAlignment.baseline);
      expect(flex.textBaseline, TextBaseline.alphabetic);
    });
  });

  group('AntSpace — size 间距', () {
    testWidgets('no SizedBox inserted when size is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('size small inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.small(),
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );
      // 3 个子元素 → 2 个间距 SizedBox
      expect(_withinSpace(find.byType(SizedBox)), findsNWidgets(2));
    });

    testWidgets('size middle inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.middle(),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(SizedBox)), findsOneWidget);
    });

    testWidgets('size large inserts SizedBox between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.large(),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(SizedBox)), findsOneWidget);
    });

    testWidgets('size all(value) inserts horizontal SizedBox',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.all(10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinSpace(find.byType(SizedBox)),
      );
      expect(sizedBox.width, isNotNull);
      expect(sizedBox.width! > 0, isTrue);
      expect(sizedBox.height, isNull);
    });

    testWidgets(
        'vertical Space with size all(value) inserts vertical SizedBox',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            size: AntSpaceSize.all(10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinSpace(find.byType(SizedBox)),
      );
      expect(sizedBox.height, isNotNull);
      expect(sizedBox.height! > 0, isTrue);
      expect(sizedBox.width, isNull);
    });

    testWidgets('size only(horizontal:) inserts horizontal spacing',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.only(horizontal: 12),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinSpace(find.byType(SizedBox)),
      );
      expect(sizedBox.width, isNotNull);
      expect(sizedBox.height, isNull);
    });

    testWidgets('size only(vertical:) inserts vertical spacing in vertical',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            size: AntSpaceSize.only(vertical: 12),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(
        _withinSpace(find.byType(SizedBox)),
      );
      expect(sizedBox.height, isNotNull);
      expect(sizedBox.width, isNull);
    });

    testWidgets('size only(horizontal:) has no effect in vertical direction',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            size: AntSpaceSize.only(horizontal: 12),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      // vertical 方向只取 verticalValue，horizontal-only 不产生间距
      expect(_withinSpace(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('single child with size does not insert SizedBox',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.middle(),
            children: [Text('A')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('size all(0) does not insert SizedBox', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.all(0),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(SizedBox)), findsNothing);
    });
  });

  group('AntSpace — wrap 换行', () {
    testWidgets('renders Wrap when wrap is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(Wrap)), findsOneWidget);
      expect(_withinSpace(find.byType(Flex)), findsNothing);
    });

    testWidgets('Wrap direction is horizontal by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinSpace(find.byType(Wrap)));
      expect(wrap.direction, Axis.horizontal);
    });

    testWidgets('Wrap direction is vertical when direction is vertical',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            direction: AntSpaceDirection.vertical,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinSpace(find.byType(Wrap)));
      expect(wrap.direction, Axis.vertical);
    });

    testWidgets('Wrap maps size to spacing and runSpacing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            size: AntSpaceSize.all(10),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinSpace(find.byType(Wrap)));
      // 水平 Wrap：spacing = hGap，runSpacing = vGap
      expect(wrap.spacing, greaterThan(0));
      expect(wrap.runSpacing, greaterThan(0));
    });

    testWidgets('Wrap cross alignment defaults to center for horizontal',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinSpace(find.byType(Wrap)));
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
    });

    testWidgets('Wrap cross alignment defaults to start for vertical',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            direction: AntSpaceDirection.vertical,
            children: [Text('A')],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinSpace(find.byType(Wrap)));
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.start);
    });
  });

  group('AntSpace — split 分隔符', () {
    testWidgets('split inserts separator between children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            split: Text('|'),
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );
      // 3 个子元素 → 2 个分隔符
      expect(find.text('|'), findsNWidgets(2));
    });

    testWidgets('split with size inserts half-gap on both sides',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.all(10),
            split: Text('|'),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      // 2 个子元素 → 1 个分隔符 + 2 个半间距 SizedBox
      expect(find.text('|'), findsOneWidget);
      expect(_withinSpace(find.byType(SizedBox)), findsNWidgets(2));
    });

    testWidgets('split without size inserts only separator', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            split: Text('|'),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(find.text('|'), findsOneWidget);
      expect(_withinSpace(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('single child with split does not insert separator',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            split: Text('|'),
            children: [Text('A')],
          ),
        ),
      );
      expect(find.text('|'), findsNothing);
    });

    testWidgets('split with vertical direction works', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            split: Text('-'),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('split with wrap mode renders Wrap', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            wrap: true,
            split: Text('|'),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      expect(_withinSpace(find.byType(Wrap)), findsOneWidget);
      expect(find.text('|'), findsOneWidget);
    });
  });

  group('AntSpace — 布局验证', () {
    testWidgets('children are laid out horizontally in order',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
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
          const AntSpace(
            direction: AntSpaceDirection.vertical,
            children: [Text('First'), Text('Second')],
          ),
        ),
      );
      final firstRect = tester.getTopLeft(find.text('First'));
      final secondRect = tester.getTopLeft(find.text('Second'));
      expect(secondRect.dy, greaterThan(firstRect.dy));
    });

    testWidgets('size creates actual spacing between children',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.all(20),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      // 无 size 版本
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final noGapDistance =
          tester.getTopLeft(find.text('B')).dx - tester.getTopLeft(find.text('A')).dx;

      // 有 size 版本
      await tester.pumpWidget(
        _wrap(
          const AntSpace(
            size: AntSpaceSize.all(20),
            children: [Text('A'), Text('B')],
          ),
        ),
      );
      final withGapDistance =
          tester.getTopLeft(find.text('B')).dx - tester.getTopLeft(find.text('A')).dx;

      expect(withGapDistance, greaterThan(noGapDistance));
    });
  });
}