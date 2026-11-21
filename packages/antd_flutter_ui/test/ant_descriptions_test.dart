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
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        colon: false,
      ),),);
      expect(find.text('名称'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('手机号'), findsOneWidget);
      expect(find.text('138****8888'), findsOneWidget);
    });

    testWidgets('column wraps items into rows', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: [
          AntDescriptionsItem(label: 'a', child: Text('1')),
          AntDescriptionsItem(label: 'b', child: Text('2')),
          AntDescriptionsItem(label: 'c', child: Text('3')),
          AntDescriptionsItem(label: 'd', child: Text('4')),
        ],
        column: 2,
      ),),);
      // 4 项、每行 2 列 → 应有 4 行；验证第 4 项仍渲染
      expect(find.text('4'), findsOneWidget);
      // 第 4 项位于最后一行，纵坐标应大于第一行
      final first = tester.getTopLeft(find.text('1'));
      final last = tester.getTopLeft(find.text('4'));
      expect(last.dy, greaterThan(first.dy));
    });

    testWidgets('span crosses columns', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: [
          AntDescriptionsItem(label: 'a', child: Text('1')),
          AntDescriptionsItem(label: 'b', child: Text('span2'), span: 2),
        ],
        column: 3,
        bordered: true,
      ),),);
      expect(find.text('span2'), findsOneWidget);
      // span=2 的 cell 宽度应大于 span=1 的 cell
      final w1 = tester.getSize(find.text('1')).width;
      final w2 = tester.getSize(find.text('span2')).width;
      expect(w2, greaterThan(w1));
    });

    testWidgets('bordered shows gray label background', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        bordered: true,
      ),),);
      // bordered 模式下存在灰底（colorFillAlter）容器
      final light = AntThemeData.light();
      final grayCells = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container &&
              (w.color == light.colorFillAlter),
        ),
      );
      expect(grayCells.length, greaterThanOrEqualTo(3));
    });

    testWidgets('small size uses smaller font', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        size: AntDescriptionsSize.small,
      ),),);
      final text = tester.widget<Text>(find.text('名称:'));
      expect(text.style!.fontSize, AntThemeData.light().fontSizeSM);
    });

    testWidgets('large size uses base font', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        size: AntDescriptionsSize.large,
      ),),);
      final text = tester.widget<Text>(find.text('名称:'));
      expect(text.style!.fontSize, AntThemeData.light().fontSize);
    });

    testWidgets('middle size renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        size: AntDescriptionsSize.middle,
      ),),);
      expect(find.text('张三'), findsOneWidget);
    });

    testWidgets('colon shown by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(items: _basicItems)));
      expect(find.text('名称:'), findsOneWidget);
    });

    testWidgets('colon false hides colon', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        colon: false,
      ),),);
      expect(find.text('名称:'), findsNothing);
      expect(find.text('名称'), findsOneWidget);
    });

    testWidgets('vertical layout stacks label above value', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        layout: AntDescriptionsLayout.vertical,
      ),),);
      final label = tester.getTopLeft(find.text('名称'));
      final value = tester.getTopLeft(find.text('张三'));
      expect(value.dy, greaterThan(label.dy));
    });

    testWidgets('horizontal layout puts label beside value', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        layout: AntDescriptionsLayout.horizontal,
      ),),);
      final label = tester.getTopLeft(find.text('名称:'));
      final value = tester.getTopLeft(find.text('张三'));
      expect(value.dx, greaterThan(label.dx));
    });

    testWidgets('renders title and extra', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: _basicItems,
        title: Text('用户信息'),
        extra: Text('编辑'),
      ),),);
      expect(find.text('用户信息'), findsOneWidget);
      expect(find.text('编辑'), findsOneWidget);
    });

    testWidgets('empty items renders nothing but title', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: [],
        title: Text('空列表'),
      ),),);
      expect(find.text('空列表'), findsOneWidget);
      expect(find.text('张三'), findsNothing);
    });

    testWidgets('custom child widget renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntDescriptions(
        items: [
          AntDescriptionsItem(
            label: '状态',
            child: Icon(Icons.check_circle),
          ),
        ],
      ),),);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
