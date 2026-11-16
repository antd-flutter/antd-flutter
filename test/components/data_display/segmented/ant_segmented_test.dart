import 'package:antd_flutter_plus/src/components/data_display/segmented/ant_segmented.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Center(child: Material(child: child)),
        ),
      ),
    ),
  );
}

/// 读取 block 模式下滑块（AnimatedAlign）的对齐位置。
Alignment _sliderAlignment(WidgetTester tester) {
  final align = tester.widget<AnimatedAlign>(find.byType(AnimatedAlign).first);
  final resolved = align.alignment.resolve(TextDirection.ltr);
  return resolved;
}

void main() {
  group('AntSegmented', () {
    testWidgets('renders all option labels', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['日', '周', '月'])),
      );
      expect(find.text('日'), findsOneWidget);
      expect(find.text('周'), findsOneWidget);
      expect(find.text('月'), findsOneWidget);
    });

    testWidgets('first option selected by default', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['A', 'B', 'C'], block: true)),
      );
      expect(_sliderAlignment(tester).x, lessThan(-0.5));
    });

    testWidgets('tap option fires onChange with value', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(AntSegmented(
          options: const ['日', '周', '月'],
          onChange: values.add,
        ),),
      );
      await tester.tap(find.text('月'));
      await tester.pumpAndSettle();
      expect(values, ['月']);
    });

    testWidgets('tap option slides slider to selected item', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['日', '周', '月'], block: true)),
      );
      await tester.tap(find.text('月'));
      await tester.pumpAndSettle();
      expect(_sliderAlignment(tester).x, greaterThan(0.5));
    });

    testWidgets('controlled value follows external value', (tester) async {
      var selected = '日';
      late StateSetter setState;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, s) {
          setState = s;
          return AntSegmented(
            options: const ['日', '周', '月'],
            value: selected,
            block: true,
            onChange: (v) => setState(() => selected = v),
          );
        },
      ),),);
      await tester.tap(find.text('周'));
      await tester.pumpAndSettle();
      expect(_sliderAlignment(tester).x, closeTo(0, 0.01));
    });

    testWidgets('defaultValue selects given option', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月'],
          defaultValue: '月',
          block: true,
        ),),
      );
      expect(_sliderAlignment(tester).x, greaterThan(0.5));
    });

    testWidgets('disabled item does not respond to tap', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(AntSegmented(
          options: const [
            AntSegmentedItem(label: 'A'),
            AntSegmentedItem(label: 'B', disabled: true),
          ],
          onChange: values.add,
        ),),
      );
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(values, isEmpty);
    });

    testWidgets('global disabled blocks all taps', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(AntSegmented(
          options: const ['A', 'B'],
          disabled: true,
          onChange: values.add,
        ),),
      );
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(values, isEmpty);
    });

    testWidgets('block expands to full row width', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['A', 'B'], block: true)),
      );
      final width = tester.getSize(find.byType(AntSegmented)).width;
      // 居中场景下占满可用宽度
      expect(width, greaterThan(200));
    });

    testWidgets('size large renders taller than small', (tester) async {
      await tester.pumpWidget(_wrap(const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AntSegmented(options: ['A', 'B'], size: AntSegmentedSize.large),
          AntSegmented(options: ['A', 'B'], size: AntSegmentedSize.small),
        ],
      ),),);
      final largeHeight =
          tester.getSize(find.byType(AntSegmented).at(0)).height;
      final smallHeight =
          tester.getSize(find.byType(AntSegmented).at(1)).height;
      expect(largeHeight, greaterThan(smallHeight));
      expect(largeHeight, greaterThan(36));
      expect(smallHeight, lessThan(30));
    });

    testWidgets('size middle is default height', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['A', 'B'])),
      );
      final height = tester.getSize(find.byType(AntSegmented)).height;
      expect(height, greaterThan(28));
      expect(height, lessThan(38));
    });

    testWidgets('icon item renders icon and label', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: [
          AntSegmentedItem(label: '列表', icon: Icon(Icons.list)),
          AntSegmentedItem(label: '地图', icon: Icon(Icons.map)),
        ],),),
      );
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
      expect(find.text('列表'), findsOneWidget);
    });

    testWidgets('icon-only item uses value on change', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(AntSegmented(
          options: [
            const AntSegmentedItem(value: 'list', icon: Icon(Icons.list)),
            const AntSegmentedItem(value: 'map', icon: Icon(Icons.map)),
          ],
          onChange: values.add,
        ),),
      );
      await tester.tap(find.byIcon(Icons.map));
      await tester.pumpAndSettle();
      expect(values, ['map']);
    });

    testWidgets('round shape renders pill track', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['A', 'B'],
          shape: AntSegmentedShape.round,
        ),),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      final radius = decoration.borderRadius! as BorderRadius;
      // 胶囊形圆角（32 高度的一半）远大于默认圆角
      expect(radius.topLeft.x, greaterThan(12));
    });

    testWidgets('non-block mode highlights selected item background',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['A', 'B'])),
      );
      final boxes = tester
          .widgetList<AnimatedContainer>(
            find.byType(AnimatedContainer),
          )
          .toList();
      expect(boxes, isNotEmpty);
      // 首项选中：第一个选项的 AnimatedContainer 有背景色
      final deco = boxes.first.decoration as BoxDecoration?;
      expect(deco?.color, isNotNull);
    });

    testWidgets('string and item options can be mixed', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: [
          '原始',
          AntSegmentedItem(label: '自定义', value: 'custom'),
        ],),),
      );
      expect(find.text('原始'), findsOneWidget);
      expect(find.text('自定义'), findsOneWidget);
    });
  });
}
