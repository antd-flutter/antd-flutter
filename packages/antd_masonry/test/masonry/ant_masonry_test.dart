import 'package:antd_masonry/antd_masonry.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget body) {
  return MaterialApp(
    home: AntScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => Scaffold(body: body),
    ),
  );
}

Widget _item(String label, {double? height, int span = 1}) {
  return AntMasonryItem(
    height: height,
    span: span,
    child: Text(label),
  );
}

void main() {
  group('AntMasonry 基础瀑布流', () {
    testWidgets('贪心分配：全部项提供 height（round-robin 退化不触发）', (tester) async {
      await tester.pumpWidget(_wrap(AntMasonry(
        columns: 3,
        children: [
          _item('A', height: 100),
          _item('B', height: 150),
          _item('C', height: 80),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('columns 控制列数', (tester) async {
      await tester.pumpWidget(_wrap(AntMasonry(
        columns: 2,
        children: List.generate(
          4,
          (i) => _item('item$i', height: 50 + i * 20),
        ),
      ),),);
      for (var i = 0; i < 4; i++) {
        expect(find.text('item$i'), findsOneWidget);
      }
    });

    testWidgets('responsiveColumns 按容器宽度解析列数', (tester) async {
      await tester.pumpWidget(_wrap(AntMasonry(
        responsiveColumns: const AntMasonryResponsive(md: 2),
        children: List.generate(
          6,
          (i) => _item('r$i', height: 40),
        ),
      ),),);
      expect(find.text('r0'), findsOneWidget);
      expect(find.text('r5'), findsOneWidget);
    });

    testWidgets('空 children 渲染为空', (tester) async {
      await tester.pumpWidget(_wrap(const AntMasonry()));
      expect(find.byType(AntMasonry), findsOneWidget);
    });
  });

  group('AntMasonryItem 跨列 span', () {
    testWidgets('span=2 项走绝对定位路径并参与布局', (tester) async {
      await tester.pumpWidget(_wrap(AntMasonry(
        columns: 3,
        gutter: 8,
        children: [
          _item('n1', height: 100),
          _item('wide', height: 120, span: 2),
          _item('n2', height: 80),
        ],
      ),),);
      expect(find.text('wide'), findsOneWidget);
      expect(find.text('n1'), findsOneWidget);
      expect(find.text('n2'), findsOneWidget);
    });
  });
}
