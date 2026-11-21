import 'package:antd_flutter_ui/src/feedback/spin/ant_spin.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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

/// AntSpin 结构内的自定义圆环绘制器数量
int _ringCount(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .where((cp) => cp.painter != null && cp.painter.runtimeType.toString() == '_SpinRingPainter')
      .length;
}

void main() {
  group('AntSpin', () {
    testWidgets('default renders spinning ring', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      await tester.pump();
      expect(_ringCount(tester), 1);
    });

    testWidgets('small size uses 14px indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(size: AntSpinSize.small)));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 14);
    });

    testWidgets('large size uses 32px indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(size: AntSpinSize.large)));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 32);
    });

    testWidgets('middle size is default 20px', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      await tester.pump();
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 20);
    });

    testWidgets('tip renders below indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(tip: '加载中...')));
      await tester.pump();
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('no tip by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin()));
      // 仅有指示器，无额外文本
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('child wrapper shows mask when spinning', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: true,
        tip: '加载中...',
        child: SizedBox(width: 200, height: 200, child: Text('列表内容')),
      ),),);
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsOneWidget);
      expect(find.text('列表内容'), findsOneWidget);
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('spinning=false has no mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: false,
        tip: '加载中...',
        child: SizedBox(width: 200, height: 200, child: Text('列表内容')),
      ),),);
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsNothing);
      expect(
        find.descendant(
          of: find.byType(AntSpin),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
      expect(find.text('列表内容'), findsOneWidget);
    });

    testWidgets('custom indicator replaces default ring', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        indicator: Icon(AntIcons.syncOutlined, key: Key('my-indicator')),
      ),),);
      await tester.pump();
      expect(find.byKey(const Key('my-indicator')), findsOneWidget);
      expect(_ringCount(tester), 0);
    });

    testWidgets('nested content renders under mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        spinning: true,
        child: Column(
          children: [
            Text('第一行'),
            Text('第二行'),
          ],
        ),
      ),),);
      await tester.pump();
      expect(find.text('第一行'), findsOneWidget);
      expect(find.text('第二行'), findsOneWidget);
      expect(find.byKey(kAntSpinMaskKey), findsOneWidget);
    });

    testWidgets('standalone mode has no mask', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(tip: '独立模式')));
      await tester.pump();
      expect(find.byKey(kAntSpinMaskKey), findsNothing);
      expect(find.text('独立模式'), findsOneWidget);
    });

    testWidgets('custom size applies to indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntSpin(
        indicator: SizedBox(
          width: 50,
          height: 50,
          key: Key('custom-size'),
          child: FlutterLogo(),
        ),
      ),),);
      await tester.pump();
      final box = tester.widget<SizedBox>(find.byKey(const Key('custom-size')));
      expect(box.width, 50);
    });

    group('特殊样式补齐（批次 0-1 优化）', () {
      testWidgets('dot 指示器渲染四点阵', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              indicatorType: AntSpinIndicatorType.dot,
              tip: '点阵加载',
            ),
          ),
        );
        await tester.pump();
        expect(find.byKey(kAntSpinDotsKey), findsOneWidget);
        // 默认 circle 模式不应出现 dots key。
        await tester.pumpWidget(
          _wrap(const AntSpin(indicatorType: AntSpinIndicatorType.circle)),
        );
        await tester.pump();
        expect(find.byKey(kAntSpinDotsKey), findsNothing);
      });

      testWidgets('size 三档对应指示器尺寸', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              size: AntSpinSize.small,
              indicatorType: AntSpinIndicatorType.dot,
            ),
          ),
        );
        await tester.pump();
        final small = tester.getRect(find.byKey(kAntSpinDotsKey));

        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              size: AntSpinSize.middle,
              indicatorType: AntSpinIndicatorType.dot,
            ),
          ),
        );
        await tester.pump();
        final middle = tester.getRect(find.byKey(kAntSpinDotsKey));

        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              size: AntSpinSize.large,
              indicatorType: AntSpinIndicatorType.dot,
            ),
          ),
        );
        await tester.pump();
        final large = tester.getRect(find.byKey(kAntSpinDotsKey));

        expect(small.width, 14);
        expect(middle.width, 20);
        expect(large.width, 32);
      });

      testWidgets('tip 文案显示在指示器下方', (tester) async {
        await tester.pumpWidget(
          _wrap(const AntSpin(tip: '正在保存')),
        );
        await tester.pump();
        expect(find.text('正在保存'), findsOneWidget);
      });

      testWidgets('fullscreen 独立模式渲染全屏遮罩', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(fullscreen: true, tip: '全屏加载中'),
          ),
        );
        await tester.pump();
        final overlay = tester.getRect(find.byKey(kAntSpinFullscreenKey));
        // 全屏遮罩铺满测试视口（800x600 默认）。
        expect(overlay.width, 800);
        expect(overlay.height, 600);
        expect(find.text('全屏加载中'), findsOneWidget);
      });

      testWidgets('fullscreen 包裹模式叠加在 child 之上', (tester) async {
        await tester.pumpWidget(
          _wrap(
            AntSpin(
              fullscreen: true,
              child: Container(
                width: 200,
                height: 200,
                color: const Color(0xFF00FF00),
                child: const Text('页面内容'),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byKey(kAntSpinFullscreenKey), findsOneWidget);
        expect(find.text('页面内容'), findsOneWidget);
      });

      testWidgets('fullscreen spinning=false 不渲染遮罩', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(fullscreen: true, spinning: false, tip: '不显示'),
          ),
        );
        await tester.pump();
        expect(find.byKey(kAntSpinFullscreenKey), findsNothing);
        expect(find.text('不显示'), findsNothing);
      });

      testWidgets('delay：未到延迟不显示，到时后显示', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              delay: Duration(milliseconds: 400),
              tip: '延迟加载',
            ),
          ),
        );
        await tester.pump();
        // 延迟期内：不显示指示器与 tip。
        expect(find.text('延迟加载'), findsNothing);
        expect(find.byKey(kAntSpinDotsKey), findsNothing);

        // 推进超过延迟时长后显示。
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('延迟加载'), findsOneWidget);
      });

      testWidgets('delay：延迟期内停止 spinning 则永不显示', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              delay: Duration(milliseconds: 400),
              tip: '闪烁防护',
            ),
          ),
        );
        await tester.pump();
        expect(find.text('闪烁防护'), findsNothing);

        // 延迟期内切换为 false，再推进也不应显示。
        await tester.pumpWidget(
          _wrap(
            const AntSpin(
              spinning: false,
              delay: Duration(milliseconds: 400),
              tip: '闪烁防护',
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('闪烁防护'), findsNothing);
      });

      testWidgets('无 delay 时立即显示（向后兼容）', (tester) async {
        await tester.pumpWidget(_wrap(const AntSpin(tip: '立即显示')));
        await tester.pump();
        expect(find.text('立即显示'), findsOneWidget);
      });
    });
  });
}

