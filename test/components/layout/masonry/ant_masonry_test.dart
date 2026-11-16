/// AntMasonry Widget 测试
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

/// 获取 AntMasonry 内部 Expanded 的数量（即列数）。
int _columnCount(WidgetTester tester) {
  return tester
      .widgetList<Expanded>(
        find.descendant(
            of: find.byType(AntMasonry), matching: find.byType(Expanded),),
      )
      .length;
}

/// 获取 AntMasonry 内部 Row 的直接子 widget 列表。
List<Widget> _rowChildren(WidgetTester tester) {
  final row = tester.widget<Row>(
    find.descendant(of: find.byType(AntMasonry), matching: find.byType(Row)),
  );
  return row.children;
}

void main() {
  group('AntMasonry — 基础渲染', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
              AntMasonryItem(child: Text('C')),
            ],
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('empty children renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(const AntMasonry()));
      expect(find.byType(AntMasonry), findsOneWidget);
      expect(_columnCount(tester), 0);
    });

    testWidgets('zero columns renders nothing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 0,
            children: [AntMasonryItem(child: Text('A'))],
          ),
        ),
      );
      expect(find.text('A'), findsNothing);
    });
  });

  group('AntMasonry — 列数', () {
    testWidgets('default columns is 3', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
              AntMasonryItem(child: Text('C')),
            ],
          ),
        ),
      );
      expect(_columnCount(tester), 3);
    });

    testWidgets('custom columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 2,
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
            ],
          ),
        ),
      );
      expect(_columnCount(tester), 2);
    });
  });

  group('AntMasonry — 间距', () {
    testWidgets('gutter adds horizontal spacing between columns',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 2,
            gutter: 16,
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
            ],
          ),
        ),
      );
      final children = _rowChildren(tester);
      // Expanded, SizedBox(16), Expanded
      expect(children.length, 3);
      expect(children[1], isA<SizedBox>());
      expect((children[1] as SizedBox).width, 16);
    });

    testWidgets('verticalGutter adds vertical spacing within column',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 1,
            gutter: 0,
            verticalGutter: 20,
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
            ],
          ),
        ),
      );
      final column = tester.widget<Column>(
        find.descendant(
            of: find.byType(AntMasonry), matching: find.byType(Column),),
      );
      // itemA, SizedBox(20), itemB
      expect(column.children.length, 3);
      expect(column.children[1], isA<SizedBox>());
      expect((column.children[1] as SizedBox).height, 20);
    });

    testWidgets('verticalGutter defaults to gutter', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 1,
            gutter: 12,
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
            ],
          ),
        ),
      );
      final column = tester.widget<Column>(
        find.descendant(
            of: find.byType(AntMasonry), matching: find.byType(Column),),
      );
      expect(column.children.length, 3);
      expect((column.children[1] as SizedBox).height, 12);
    });
  });

  group('AntMasonry — 响应式列数', () {
    testWidgets('responsiveColumns resolves by container width',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            responsiveColumns: AntMasonryResponsive(
              xs: 1,
              sm: 2,
              md: 4,
            ),
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
              AntMasonryItem(child: Text('C')),
              AntMasonryItem(child: Text('D')),
            ],
          ),
        ),
      );
      // 测试面宽 800 >= 768 → md → 4 列
      expect(_columnCount(tester), 4);
    });

    testWidgets('responsiveColumns falls back to columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 2,
            responsiveColumns: AntMasonryResponsive(),
            children: [
              AntMasonryItem(child: Text('A')),
              AntMasonryItem(child: Text('B')),
            ],
          ),
        ),
      );
      // 所有断点均未配置 → fallback=columns=2
      expect(_columnCount(tester), 2);
    });
  });

  group('AntMasonry — 分配策略', () {
    testWidgets('greedy distribution with heights', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 3,
            children: [
              AntMasonryItem(
                  key: ValueKey('a'), height: 100, child: Text('A'),),
              AntMasonryItem(
                  key: ValueKey('b'), height: 150, child: Text('B'),),
              AntMasonryItem(
                  key: ValueKey('c'), height: 80, child: Text('C'),),
              AntMasonryItem(
                  key: ValueKey('d'), height: 50, child: Text('D'),),
            ],
          ),
        ),
      );
      // 贪心: A→列0(100), B→列1(150), C→列2(80), D→列2(最矮80→130)
      final aX = tester.getTopLeft(find.byKey(const ValueKey('a'))).dx;
      final bX = tester.getTopLeft(find.byKey(const ValueKey('b'))).dx;
      final cX = tester.getTopLeft(find.byKey(const ValueKey('c'))).dx;
      final dX = tester.getTopLeft(find.byKey(const ValueKey('d'))).dx;
      // D 与 C 同列
      expect(dX, closeTo(cX, 1));
      // 三列 x 递增
      expect(aX, lessThan(bX));
      expect(bX, lessThan(cX));
    });

    testWidgets('round-robin distribution without heights', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntMasonry(
            columns: 3,
            children: [
              AntMasonryItem(key: ValueKey('a'), child: Text('A')),
              AntMasonryItem(key: ValueKey('b'), child: Text('B')),
              AntMasonryItem(key: ValueKey('c'), child: Text('C')),
              AntMasonryItem(key: ValueKey('d'), child: Text('D')),
            ],
          ),
        ),
      );
      // 轮询: A→列0, B→列1, C→列2, D→列0
      final aX = tester.getTopLeft(find.byKey(const ValueKey('a'))).dx;
      final bX = tester.getTopLeft(find.byKey(const ValueKey('b'))).dx;
      final cX = tester.getTopLeft(find.byKey(const ValueKey('c'))).dx;
      final dX = tester.getTopLeft(find.byKey(const ValueKey('d'))).dx;
      // D 与 A 同列
      expect(dX, closeTo(aX, 1));
      // 三列 x 递增
      expect(aX, lessThan(bX));
      expect(bX, lessThan(cX));
    });
  });
}