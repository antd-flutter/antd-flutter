import 'package:antd_flutter_ui/src/display/descriptions/ant_descriptions.dart';
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

const _basicItems = [
  AntDescriptionsItem(label: '名称', child: Text('张三')),
  AntDescriptionsItem(label: '手机号', child: Text('138****8888')),
  AntDescriptionsItem(label: '城市', child: Text('杭州')),
];

void main() {
  group('AntDescriptions', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            colon: false,
          ),
        ),
      );
      expect(find.text('名称'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('手机号'), findsOneWidget);
      expect(find.text('138****8888'), findsOneWidget);
    });

    testWidgets('column wraps items into rows', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: [
              AntDescriptionsItem(label: 'a', child: Text('1')),
              AntDescriptionsItem(label: 'b', child: Text('2')),
              AntDescriptionsItem(label: 'c', child: Text('3')),
              AntDescriptionsItem(label: 'd', child: Text('4')),
            ],
            column: 2,
          ),
        ),
      );
      // 4 项、每行 2 列 → 应有 4 行；验证第 4 项仍渲染
      expect(find.text('4'), findsOneWidget);
      // 第 4 项位于最后一行，纵坐标应大于第一行
      final first = tester.getTopLeft(find.text('1'));
      final last = tester.getTopLeft(find.text('4'));
      expect(last.dy, greaterThan(first.dy));
    });

    testWidgets('span crosses columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: [
              AntDescriptionsItem(label: 'a', child: Text('1')),
              AntDescriptionsItem(label: 'b', child: Text('span2'), span: 2),
            ],
            column: 3,
            bordered: true,
          ),
        ),
      );
      expect(find.text('span2'), findsOneWidget);
      // span=2 的 cell 宽度应大于 span=1 的 cell
      final w1 = tester.getSize(find.text('1')).width;
      final w2 = tester.getSize(find.text('span2')).width;
      expect(w2, greaterThan(w1));
    });

    testWidgets('bordered shows gray label background', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            bordered: true,
          ),
        ),
      );
      // bordered 模式下存在灰底（colorFillAlter）容器
      final light = AntThemeData.light();
      final grayCells = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              (w.color == light.colorFillAlter ||
                  (w.decoration is BoxDecoration &&
                      (w.decoration! as BoxDecoration).color ==
                          light.colorFillAlter)),
        ),
      );
      expect(grayCells.length, greaterThanOrEqualTo(3));
    });

    testWidgets('small size uses smaller font', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            size: AntDescriptionsSize.small,
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('名称:'));
      expect(text.style!.fontSize, AntThemeData.light().fontSizeSM);
    });

    testWidgets('large size uses base font', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            size: AntDescriptionsSize.large,
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('名称:'));
      expect(text.style!.fontSize, AntThemeData.light().fontSize);
    });

    testWidgets('middle size renders', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            size: AntDescriptionsSize.middle,
          ),
        ),
      );
      expect(find.text('张三'), findsOneWidget);
    });

    testWidgets('colon shown by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(items: _basicItems)));
      expect(find.text('名称:'), findsOneWidget);
    });

    testWidgets('colon false hides colon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            colon: false,
          ),
        ),
      );
      expect(find.text('名称:'), findsNothing);
      expect(find.text('名称'), findsOneWidget);
    });

    testWidgets('vertical layout stacks label above value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            layout: AntDescriptionsLayout.vertical,
          ),
        ),
      );
      final label = tester.getTopLeft(find.text('名称'));
      final value = tester.getTopLeft(find.text('张三'));
      expect(value.dy, greaterThan(label.dy));
    });

    testWidgets('horizontal layout puts label beside value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            layout: AntDescriptionsLayout.horizontal,
          ),
        ),
      );
      final label = tester.getTopLeft(find.text('名称:'));
      final value = tester.getTopLeft(find.text('张三'));
      expect(value.dx, greaterThan(label.dx));
    });

    testWidgets('renders title and extra', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: _basicItems,
            title: Text('用户信息'),
            extra: Text('编辑'),
          ),
        ),
      );
      expect(find.text('用户信息'), findsOneWidget);
      expect(find.text('编辑'), findsOneWidget);
    });

    testWidgets('empty items renders nothing but title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: [],
            title: Text('空列表'),
          ),
        ),
      );
      expect(find.text('空列表'), findsOneWidget);
      expect(find.text('张三'), findsNothing);
    });

    testWidgets('custom child widget renders', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDescriptions(
            items: [
              AntDescriptionsItem(
                label: '状态',
                child: Icon(Icons.check_circle),
              ),
            ],
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('窄屏不同 label 宽度下 value 起点偏移保持等宽', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 360,
        child: AntDescriptions(
          column: 3,
          items: [
            AntDescriptionsItem(label: '名称', child: Text('张三')),
            AntDescriptionsItem(label: '手机号码', child: Text('138****8888')),
            AntDescriptionsItem(label: '城市', child: Text('杭州')),
          ],
        ),
      ),),);

      // 每项的 value 相对自身 label 的偏移应等于同一列宽（360 / 6 = 60），
      // 不能被 label 文本宽度撑开。
      final pairs = [
        (find.text('名称:'), find.text('张三')),
        (find.text('手机号码:'), find.text('138****8888')),
        (find.text('城市:'), find.text('杭州')),
      ];
      final offsets = [
        for (final (label, value) in pairs)
          tester.getTopLeft(value).dx - tester.getTopLeft(label).dx,
      ];
      expect(offsets[0], closeTo(60, 0.5));
      expect(offsets[1], closeTo(60, 0.5));
      expect(offsets[2], closeTo(60, 0.5));
    });

    testWidgets('换行后的行与上一行列起点对齐', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 360,
        child: AntDescriptions(
          column: 2,
          items: [
            AntDescriptionsItem(label: '名称', child: Text('张三')),
            AntDescriptionsItem(label: '手机号', child: Text('138****8888')),
            AntDescriptionsItem(label: '城市', child: Text('杭州')),
            AntDescriptionsItem(label: '邮箱', child: Text('a@b.com')),
          ],
        ),
      ),),);

      // 第二行第一列应与第一行第一列的 label / value 起点相同
      expect(
        tester.getTopLeft(find.text('城市:')).dx,
        closeTo(tester.getTopLeft(find.text('名称:')).dx, 0.5),
      );
      expect(
        tester.getTopLeft(find.text('杭州')).dx,
        closeTo(tester.getTopLeft(find.text('张三')).dx, 0.5),
      );
    });

    testWidgets('边框模式同一行 label 格高度一致', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 360,
        child: AntDescriptions(
          column: 2,
          bordered: true,
          items: [
            AntDescriptionsItem(
              label: '名称',
              child: Text('一段会换行很多次的较长内容用于撑高这一格以便验证同行等高'),
            ),
            AntDescriptionsItem(label: '城市', child: Text('杭州')),
          ],
        ),
      ),),);

      final light = AntThemeData.light();
      final grays = tester
          .widgetList<Container>(find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration! as BoxDecoration).color == light.colorFillAlter,
          ),)
          .toList();
      expect(grays.length, greaterThanOrEqualTo(2));
      final heights = find
          .byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration! as BoxDecoration).color == light.colorFillAlter,
          )
          .evaluate()
          .map((e) => (e.renderObject! as RenderBox).size.height)
          .toList();
      expect(heights[0], closeTo(heights[1], 0.5));
    });
  });
}
