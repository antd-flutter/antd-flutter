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

    testWidgets('inline selected background fills inner track height',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['A', 'B'])),
      );
      await tester.pumpAndSettle();
      final trackHeight = tester.getSize(find.byType(AntSegmented)).height;
      // 选中项背景（含背景色的 AnimatedContainer）应撑满轨道内高
      // （32 - 2*2 = 28），而不是只有文字行高（"挤"问题修复断言）。
      final boxes = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .where((c) => (c.decoration! as BoxDecoration).color != null)
          .toList();
      expect(boxes, isNotEmpty);
      final bgHeight = tester.getSize(find.byWidget(boxes.first)).height;
      expect(bgHeight, greaterThan(trackHeight - 5));
      expect(bgHeight, lessThan(trackHeight - 2.5));
    });
  });

  group('AntSegmented vertical', () {
    testWidgets('options stack vertically (track taller than wide)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月'],
          direction: AntSegmentedDirection.vertical,
        ),),
      );
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(AntSegmented));
      expect(size.height, greaterThan(size.width));
      // 三项垂直排布高度显著大于水平同款
      expect(size.height, greaterThan(80));
    });

    testWidgets('tap option fires onChange in vertical mode', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        _wrap(AntSegmented(
          options: const ['日', '周', '月'],
          direction: AntSegmentedDirection.vertical,
          onChange: values.add,
        ),),
      );
      await tester.tap(find.text('月'));
      await tester.pumpAndSettle();
      expect(values, ['月']);
    });

    testWidgets('vertical block slider animates along y axis',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月'],
          block: true,
          direction: AntSegmentedDirection.vertical,
        ),),
      );
      await tester.pumpAndSettle();
      // 首项选中：滑块贴近顶部
      expect(_sliderAlignment(tester).y, lessThan(-0.5));
      expect(_sliderAlignment(tester).x, closeTo(0, 0.01));

      await tester.tap(find.text('月'));
      await tester.pumpAndSettle();
      // 末项选中：滑块滑到底部
      expect(_sliderAlignment(tester).y, greaterThan(0.5));
      expect(_sliderAlignment(tester).x, closeTo(0, 0.01));
    });

    testWidgets('vertical block track height = item count × track height',
        (tester) async {
      // 对照基准：单项水平 block 的轨道高（32.w + padding）
      await tester.pumpWidget(
        _wrap(const AntSegmented(options: ['日'], block: true)),
      );
      await tester.pumpAndSettle();
      final refHeight = tester.getSize(find.byType(AntSegmented)).height;

      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月', '年'],
          block: true,
          direction: AntSegmentedDirection.vertical,
        ),),
      );
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(AntSegmented));
      // 四项垂直高度应约为单项水平轨道高的 4 倍
      expect(size.height, greaterThan(refHeight * 3));
      expect(size.height, lessThan(refHeight * 5));
      // 无界宽度（Center）下 hug 最宽项内容，不塌陷为 0、不溢出
      expect(size.width, greaterThan(20));
    });

    testWidgets('vertical block width hugs widest label content',
        (tester) async {
      // 不同父容器宽度（松约束）下轨道宽一致 → hug 内容，不强制撑满
      Future<double> pumpHugWidth(double parentMaxWidth) async {
        await tester.pumpWidget(
          _wrap(SizedBox(
            width: parentMaxWidth,
            child: const Align(
              alignment: Alignment.topLeft,
              child: AntSegmented(
                options: ['日', '周', '月', '年'],
                block: true,
                direction: AntSegmentedDirection.vertical,
              ),
            ),
          ),),
        );
        await tester.pumpAndSettle();
        return tester.getSize(find.byType(AntSegmented)).width;
      }

      final hug300 = await pumpHugWidth(300);
      final hug800 = await pumpHugWidth(800);
      // hug 基准与上面 300 宽松约束一致
      // 容器变宽，轨道宽不变（自适应内容宽）
      expect(hug300, closeTo(hug800, 0.5));
      // hug 内容宽（约一个 label + 内边距），不强制撑满父容器、不塌陷
      expect(hug300, greaterThan(20));
      expect(hug300, lessThan(200));
    });

    testWidgets('vertical block respects external SizedBox width',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const SizedBox(
          width: 160,
          child: AntSegmented(
            options: ['日', '周', '月', '年'],
            block: true,
            direction: AntSegmentedDirection.vertical,
          ),
        ),),
      );
      await tester.pumpAndSettle();
      // 用户设置宽度生效：轨道宽 = 160（有界约束遵父级）
      expect(
        tester.getRect(find.byType(AntSegmented)).width,
        closeTo(160, 0.5),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('vertical block slider occupies selected item slot',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月', '年'],
          block: true,
          direction: AntSegmentedDirection.vertical,
        ),),
      );
      await tester.pumpAndSettle();
      final track = tester.getRect(find.byType(AntSegmented));
      const itemCount = 4;
      // 滑块（FractionallySizedBox）高度 ≈ 轨道内容高 / 项数
      final slider = tester.getRect(
          find.ancestor(
              of: find.byType(AnimatedContainer).first,
              matching: find.byType(FractionallySizedBox),),
          );
      final inner = track.height - 4;
      expect(slider.height, closeTo(inner / itemCount, 8));
      // 首项选中：滑块贴顶
      expect((slider.top - track.top).abs(), lessThan(6));

      await tester.tap(find.text('年'));
      await tester.pumpAndSettle();
      final sliderBottom = tester.getRect(
          find.ancestor(
              of: find.byType(AnimatedContainer).first,
              matching: find.byType(FractionallySizedBox),),);
      // 末项选中：滑块贴底
      expect((track.bottom - sliderBottom.bottom).abs(), lessThan(6));
    });

    testWidgets('horizontal default keeps slider on x axis', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSegmented(
          options: ['日', '周', '月'],
          direction: AntSegmentedDirection.horizontal,
          block: true,
        ),),
      );
      await tester.pumpAndSettle();
      expect(_sliderAlignment(tester).y, closeTo(0, 0.01));
      expect(_sliderAlignment(tester).x, lessThan(-0.5));
    });

    group('vertical block no horizontal overflow', () {
      // 收集布局阶段报出的所有错误（溢出错误经 FlutterError.onError 上报，
      // 不抛异常，takeException 只能取到第一个）。
      Future<List<FlutterErrorDetails>> pumpSegmented(
        WidgetTester tester,
        Widget child,
      ) async {
        final errors = <FlutterErrorDetails>[];
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details);
        addTearDown(() => FlutterError.onError = originalOnError);
        await tester.pumpWidget(_wrap(child));
        await tester.pumpAndSettle();
        return errors;
      }

      const verticalBlock = AntSegmented(
        options: ['日', '周', '月', '年'],
        direction: AntSegmentedDirection.vertical,
        block: true,
      );

      testWidgets('160-wide container renders without overflow', (tester) async {
        final errors = await pumpSegmented(
          tester,
          const SizedBox(width: 160, child: verticalBlock),
        );
        // 验收回归：RIGHT OVERFLOWED BY 22 PIXELS —— 必须零溢出
        expect(errors, isEmpty);
        expect(tester.takeException(), isNull);

        final track = tester.getRect(find.byType(AntSegmented));
        expect(track.width, closeTo(160, 0.5));
        // 白色滑块必须被轨道包住，不塌陷为 0
        final slider = tester.getRect(
          find.ancestor(
            of: find.byType(AnimatedContainer).first,
            matching: find.byType(FractionallySizedBox),
          ),
        );
        expect(slider.width, greaterThan(0));
        expect(slider.right, lessThanOrEqualTo(track.right + 0.5));

        // 每个选项文字都落在轨道水平范围内
        for (final label in const ['日', '周', '月', '年']) {
          final rect = tester.getRect(find.text(label));
          expect(rect.left, greaterThanOrEqualTo(track.left - 0.5));
          expect(rect.right, lessThanOrEqualTo(track.right + 0.5));
        }
      });

      testWidgets('unbounded-width parent (Row child) hugs content, '
          'no collapse no overflow', (tester) async {
        final errors = await pumpSegmented(
          tester,
          const Column(children: [Row(children: [verticalBlock])]),
        );
        expect(errors, isEmpty);
        expect(tester.takeException(), isNull);

        final size = tester.getSize(find.byType(AntSegmented));
        // 不塌陷为 0（约等于最宽项内容 + 轨道 padding），也不溢出
        expect(size.width, greaterThan(20));
        expect(size.height, greaterThan(120));
      });
    });

    group('horizontal block width adapts to parent', () {
      // 读取滑块（FractionallySizedBox）的矩形。
      Rect sliderRect(WidgetTester tester) => tester.getRect(
            find.ancestor(
              of: find.byType(AnimatedContainer).first,
              matching: find.byType(FractionallySizedBox),
            ),
          );

      Future<void> pumpBlockInWidth(WidgetTester tester, double width) async {
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              width: width,
              child: const AntSegmented(
                options: ['A', 'B', 'C'],
                block: true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      testWidgets('track fills 400-wide and 800-wide containers',
          (tester) async {
        await pumpBlockInWidth(tester, 400);
        expect(tester.getRect(find.byType(AntSegmented)).width, closeTo(400, 1));

        await pumpBlockInWidth(tester, 800);
        expect(tester.getRect(find.byType(AntSegmented)).width, closeTo(800, 1));
      });

      testWidgets('slider x position scales proportionally with width',
          (tester) async {
        await pumpBlockInWidth(tester, 400);
        final track400 = tester.getRect(find.byType(AntSegmented));
        // 3 项、首项选中：滑块中心相对轨道 x = 400 * 1/6
        expect(
          sliderRect(tester).center.dx - track400.left,
          closeTo(400 / 6, 2.5),
        );

        await pumpBlockInWidth(tester, 800);
        final track800 = tester.getRect(find.byType(AntSegmented));
        expect(
          sliderRect(tester).center.dx - track800.left,
          closeTo(800 / 6, 2.5),
        );

        // 切到第 2 项：滑块中心相对轨道 x = 宽度 * 3/6
        await tester.tap(find.text('B'));
        await tester.pumpAndSettle();
        expect(
          sliderRect(tester).center.dx - track800.left,
          closeTo(800 / 2, 1),
        );
      });
    });
  });
}
