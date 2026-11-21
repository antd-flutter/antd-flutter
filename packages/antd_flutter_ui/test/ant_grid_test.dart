/// AntGrid Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 在 AntRow 内查找指定类型的 widget
Finder _withinRow(Finder matching) {
  return find.descendant(of: find.byType(AntRow), matching: matching);
}

/// 在指定 AntCol 内查找指定类型的 widget
Finder _withinCol(Finder col, Finder matching) {
  return find.descendant(of: col, matching: matching);
}

void main() {
  group('AntRow — 基础渲染', () {
    testWidgets('renders Row with AntCol children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 12, child: Text('左')),
              AntCol(span: 12, child: Text('右')),
            ],
          ),
        ),
      );
      expect(find.byType(AntRow), findsOneWidget);
      expect(find.byType(AntCol), findsNWidgets(2));
      expect(find.text('左'), findsOneWidget);
      expect(find.text('右'), findsOneWidget);
      expect(_withinRow(find.byType(Row)), findsOneWidget);
    });

    testWidgets('renders Wrap when wrap is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            wrap: true,
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      expect(_withinRow(find.byType(Wrap)), findsOneWidget);
      expect(_withinRow(find.byType(Row)), findsNothing);
    });

    testWidgets('renders empty children without error', (tester) async {
      await tester.pumpWidget(_wrap(const AntRow()));
      expect(find.byType(AntRow), findsOneWidget);
    });
  });

  group('AntCol — span 宽度', () {
    testWidgets('span 12 + 12 splits row in half', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 12, child: Text('A')),
              AntCol(span: 12, child: Text('B')),
            ],
          ),
        ),
      );
      // 测试表面宽度 800，span 12 → 400
      final boxes = _withinRow(find.byType(SizedBox)).evaluate().toList();
      expect(boxes.length, 2);
      expect((boxes[0].widget as SizedBox).width, closeTo(400, 0.01));
      expect((boxes[1].widget as SizedBox).width, closeTo(400, 0.01));
    });

    testWidgets('span 8 × 3 splits row in thirds', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 8, child: Text('A')),
              AntCol(span: 8, child: Text('B')),
              AntCol(span: 8, child: Text('C')),
            ],
          ),
        ),
      );
      final boxes = _withinRow(find.byType(SizedBox)).evaluate();
      expect(boxes.length, 3);
      for (final element in boxes) {
        expect(
          (element.widget as SizedBox).width,
          closeTo(800 * 8 / 24, 0.01),
        );
      }
    });

    testWidgets('span 6 × 4 splits row in quarters', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 6, child: Text('A')),
              AntCol(span: 6, child: Text('B')),
              AntCol(span: 6, child: Text('C')),
              AntCol(span: 6, child: Text('D')),
            ],
          ),
        ),
      );
      final boxes = _withinRow(find.byType(SizedBox)).evaluate();
      expect(boxes.length, 4);
      for (final element in boxes) {
        expect(
          (element.widget as SizedBox).width,
          closeTo(800 * 6 / 24, 0.01),
        );
      }
    });

    testWidgets('span 24 takes full width', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 24, child: Text('全宽'))],
          ),
        ),
      );
      final box = _withinRow(find.byType(SizedBox)).evaluate().first;
      expect(
        (box.widget as SizedBox).width,
        closeTo(800, 0.01),
      );
    });

    testWidgets('partial span leaves free space', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 8, child: Text('部分'))],
          ),
        ),
      );
      final box = _withinRow(find.byType(SizedBox)).evaluate().first;
      expect(
        (box.widget as SizedBox).width,
        closeTo(800 * 8 / 24, 0.01),
      );
    });
  });

  group('AntCol — offset', () {
    testWidgets('offset adds left padding', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 8, offset: 8, child: SizedBox(height: 10)),
            ],
          ),
        ),
      );
      // offset 8 → left padding = 800 * 8/24 ≈ 266.67
      final padding = tester.widget<Padding>(
        _withinRow(find.byType(Padding)),
      );
      expect(
        padding.padding.resolve(TextDirection.ltr).left,
        closeTo(800 * 8 / 24, 0.01),
      );
    });

    testWidgets('offset 0 produces no padding', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 12, child: SizedBox(height: 10))],
          ),
        ),
      );
      expect(_withinRow(find.byType(Padding)), findsNothing);
    });
  });

  group('AntRow — gutter', () {
    testWidgets('gutter adds horizontal padding to cols', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            gutter: 16,
            children: [
              AntCol(span: 12, child: SizedBox(height: 10)),
              AntCol(span: 12, child: SizedBox(height: 10)),
            ],
          ),
        ),
      );
      // gutter 16 → 每列水平内边距 8
      final paddings = _withinRow(find.byType(Padding)).evaluate();
      expect(paddings.length, 2);
      for (final element in paddings) {
        final padding = (element.widget as Padding).padding
            .resolve(TextDirection.ltr);
        expect(padding.left, closeTo(8, 0.01));
        expect(padding.right, closeTo(8, 0.01));
      }
    });

    testWidgets('zero gutter produces no padding', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 12, child: SizedBox(height: 10))],
          ),
        ),
      );
      expect(_withinRow(find.byType(Padding)), findsNothing);
    });

    testWidgets('verticalGutter adds vertical padding with wrap',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            wrap: true,
            gutter: 16,
            verticalGutter: 24,
            children: [
              AntCol(span: 12, child: SizedBox(height: 10)),
              AntCol(span: 12, child: SizedBox(height: 10)),
            ],
          ),
        ),
      );
      final paddings = _withinRow(find.byType(Padding)).evaluate();
      expect(paddings.length, 2);
      for (final element in paddings) {
        final padding = (element.widget as Padding).padding
            .resolve(TextDirection.ltr);
        expect(padding.top, closeTo(12, 0.01));
        expect(padding.bottom, closeTo(12, 0.01));
      }
    });
  });

  group('AntRow — align', () {
    testWidgets('default align is top (start)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('align middle maps to center', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            align: AntRowAlign.middle,
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('align bottom maps to end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            align: AntRowAlign.bottom,
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.crossAxisAlignment, CrossAxisAlignment.end);
    });
  });

  group('AntRow — justify', () {
    testWidgets('default justify is start', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 8, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.mainAxisAlignment, MainAxisAlignment.start);
    });

    testWidgets('justify end', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            justify: AntRowJustify.end,
            children: [AntCol(span: 8, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('justify center', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            justify: AntRowJustify.center,
            children: [AntCol(span: 8, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('justify spaceAround', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            justify: AntRowJustify.spaceAround,
            children: [AntCol(span: 8, child: Text('A'))],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceAround);
    });

    testWidgets('justify spaceBetween', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            justify: AntRowJustify.spaceBetween,
            children: [
              AntCol(span: 8, child: Text('A')),
              AntCol(span: 8, child: Text('B')),
            ],
          ),
        ),
      );
      final row = tester.widget<Row>(_withinRow(find.byType(Row)));
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });
  });

  group('AntCol — flex 模式', () {
    testWidgets('flex overrides span', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(flex: 1, child: Text('A')),
              AntCol(flex: 2, child: Text('B')),
            ],
          ),
        ),
      );
      final flexibles = _withinRow(find.byType(Flexible)).evaluate().toList();
      expect(flexibles.length, 2);
      expect((flexibles[0].widget as Flexible).flex, 1);
      expect((flexibles[1].widget as Flexible).flex, 2);
      // flex 模式下不产生 SizedBox
      expect(_withinRow(find.byType(SizedBox)), findsNothing);
    });

    testWidgets('flex with fractional value rounds', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(flex: 1.5, child: Text('A')),
              AntCol(flex: 2.4, child: Text('B')),
            ],
          ),
        ),
      );
      final flexibles = _withinRow(find.byType(Flexible)).evaluate().toList();
      expect((flexibles[0].widget as Flexible).flex, 2);
      expect((flexibles[1].widget as Flexible).flex, 2);
    });
  });

  group('AntCol — 无 span', () {
    testWidgets('col without span renders content-sized', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(child: Text('A')),
              AntCol(span: 12, child: Text('B')),
            ],
          ),
        ),
      );
      // 无 span 的列不产生 SizedBox，直接渲染内容
      final colA = find.byWidgetPredicate(
        (w) => w is AntCol && w.child is Text && (w.child as Text).data == 'A',
      );
      expect(_withinCol(colA, find.byType(SizedBox)), findsNothing);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('col with null child renders shrink', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [AntCol(span: 12)],
          ),
        ),
      );
      final shrinkBoxes = _withinRow(
        find.byWidgetPredicate(
          (w) => w is SizedBox && w.width == 0 && w.height == 0,
        ),
      );
      expect(shrinkBoxes, findsOneWidget);
    });
  });

  group('AntCol — 独立使用', () {
    testWidgets('col outside row renders child directly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Center(
            child: AntCol(span: 12, child: Text('独立')),
          ),
        ),
      );
      expect(find.text('独立'), findsOneWidget);
      // 无 scope 时不产生 SizedBox
      expect(find.byType(SizedBox), findsNothing);
    });
  });

  group('AntRow — wrap 换行', () {
    testWidgets('overflow cols wrap to next line', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            wrap: true,
            children: [
              AntCol(span: 16, child: SizedBox(height: 10)),
              AntCol(span: 16, child: SizedBox(height: 10)),
            ],
          ),
        ),
      );
      // 16+16=32 > 24，第二列换行
      final wrap = tester.widget<Wrap>(_withinRow(find.byType(Wrap)));
      expect(wrap.direction, Axis.horizontal);
      // 两列都存在
      expect(find.byType(AntCol), findsNWidgets(2));
    });

    testWidgets('wrap with align maps to WrapCrossAlignment',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            wrap: true,
            align: AntRowAlign.middle,
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinRow(find.byType(Wrap)));
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
    });

    testWidgets('wrap with justify maps to WrapAlignment',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            wrap: true,
            justify: AntRowJustify.center,
            children: [AntCol(span: 12, child: Text('A'))],
          ),
        ),
      );
      final wrap = tester.widget<Wrap>(_withinRow(find.byType(Wrap)));
      expect(wrap.alignment, WrapAlignment.center);
    });
  });

  group('AntGrid — 组合场景', () {
    testWidgets('nested rows work independently', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(
                span: 12,
                child: AntRow(
                  children: [
                    AntCol(span: 12, child: Text('内左')),
                    AntCol(span: 12, child: Text('内右')),
                  ],
                ),
              ),
              AntCol(span: 12, child: Text('外右')),
            ],
          ),
        ),
      );
      expect(find.byType(AntRow), findsNWidgets(2));
      expect(find.text('内左'), findsOneWidget);
      expect(find.text('内右'), findsOneWidget);
      expect(find.text('外右'), findsOneWidget);
    });

    testWidgets('mixed span and flex cols', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [
              AntCol(span: 8, child: Text('固定')),
              AntCol(flex: 1, child: Text('弹性')),
            ],
          ),
        ),
      );
      expect(find.text('固定'), findsOneWidget);
      expect(find.text('弹性'), findsOneWidget);
      // 固定列有 SizedBox，弹性列有 Flexible
      expect(_withinRow(find.byType(SizedBox)), findsOneWidget);
      expect(_withinRow(find.byType(Flexible)), findsOneWidget);
    });

    testWidgets('non-AntCol child renders in row', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntRow(
            children: [Text('普通子元素')],
          ),
        ),
      );
      expect(find.text('普通子元素'), findsOneWidget);
    });
  });
}