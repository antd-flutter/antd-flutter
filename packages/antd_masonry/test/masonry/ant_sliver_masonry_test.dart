import 'package:antd_masonry/antd_masonry.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(List<Widget> slivers) {
  return MaterialApp(
    home: Scaffold(
      body: CustomScrollView(slivers: slivers),
    ),
  );
}

void main() {
  group('AntSliverMasonry sliver 变体（R33）', () {
    testWidgets('在 CustomScrollView 中渲染并与 SliverAppBar 组合', (tester) async {
      await tester.pumpWidget(
        _wrap(<Widget>[
          const SliverAppBar(title: Text('瀑布流')),
          const AntSliverMasonry(
            columns: 3,
            gutter: 8,
            children: [
              AntMasonryItem(height: 100, child: Text('s1')),
              AntMasonryItem(height: 140, child: Text('s2')),
              AntMasonryItem(height: 80, child: Text('s3')),
            ],
          ),
        ]),
      );
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.text('s1'), findsOneWidget);
      expect(find.text('s2'), findsOneWidget);
      expect(find.text('s3'), findsOneWidget);
    });

    testWidgets('可滚动到底部（滚动集合语义）', (tester) async {
      await tester.pumpWidget(
        _wrap(<Widget>[
          AntSliverMasonry(
            columns: 2,
            gutter: 8,
            children: [
              for (var i = 0; i < 20; i++)
                AntMasonryItem(height: 100 + (i % 4) * 50, child: Text('it$i')),
            ],
          ),
        ]),
      );
      expect(find.text('it0'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('it19'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('it19'), findsOneWidget);
    });

    testWidgets('空 children 渲染为空 sliver', (tester) async {
      await tester.pumpWidget(_wrap(const <Widget>[AntSliverMasonry()]));
      expect(
        find.byType(AntSliverMasonry, skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
