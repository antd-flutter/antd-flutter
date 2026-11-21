import 'package:antd_floating/src/floating_panel/ant_floating_panel.dart';
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

/// 默认把手高度（与组件默认一致）。
const double _kDefaultHandleHeight = 28;

AntFloatingPanel _defaultPanel({
  Key? key,
  List<double>? anchors,
  double? handleHeight,
  Widget? handle,
  double? contentHeight,
  void Function(double)? onHeightChange,
  AntFloatingPanelController? controller,
  Widget? child,
}) {
  return AntFloatingPanel(
    key: key,
    anchors: anchors ?? const [0.6, 0.8, 1],
    handleHeight: handleHeight ?? _kDefaultHandleHeight,
    handle: handle,
    contentHeight: contentHeight,
    onHeightChange: onHeightChange,
    controller: controller,
    child: child ?? const Text('面板内容'),
  );
}

/// 面板可见区域（ClipRRect）矩形。
Rect _panelRect(WidgetTester tester) {
  return tester.getRect(find.byType(ClipRRect));
}

void main() {
  group('AntFloatingPanel', () {
    testWidgets('默认渲染把手与内容', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      expect(find.byKey(kAntFloatingPanelHandleKey), findsOneWidget);
      expect(find.text('面板内容'), findsOneWidget);
    });

    testWidgets('初始停在最低锚点', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      await tester.pumpAndSettle();
      // 基准 600，最低锚点 0.6 → 高度 360，顶边在 600-360=240。
      final rect = _panelRect(tester);
      expect(rect.height, closeTo(360, 1));
      expect(rect.top, closeTo(240, 1));
    });

    testWidgets('拖到中间锚点释放后吸附在锚点', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(kAntFloatingPanelHandleKey),
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();
      // 高度吸附到 0.8 → 480，顶边 120。
      final rect = _panelRect(tester);
      expect(rect.height, closeTo(480, 1));
      expect(rect.top, closeTo(120, 1));
    });

    testWidgets('释放后吸附到最近锚点', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      await tester.pumpAndSettle();
      // 拖动约 -180：初始 360 → 约 522，最近锚点为 480。
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(kAntFloatingPanelHandleKey)),
      );
      await gesture.moveBy(const Offset(0, -180));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_panelRect(tester).height, closeTo(480, 1));
    });

    testWidgets('handleHeight 控制把手区域高度', (tester) async {
      await tester.pumpWidget(
        _wrap(_defaultPanel(handleHeight: 60)),
      );
      final handleBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byKey(kAntFloatingPanelHandleKey),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(handleBox.height, 60.w);
    });

    testWidgets('自定义 handle 渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _defaultPanel(
            handle: Container(
              key: const Key('custom_handle'),
              child: const Text('自定义把手'),
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('custom_handle')), findsOneWidget);
      expect(find.text('自定义把手'), findsOneWidget);
    });

    testWidgets('contentHeight 作为基准高度决定锚点位置', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            height: 600,
            child: _defaultPanel(
              anchors: const [0.5, 1],
              contentHeight: 500,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 基准 500，最低锚点 0.5 → 高度 250，顶边 350。
      final rect = _panelRect(tester);
      expect(rect.height, closeTo(250, 1));
      // 拖到最高锚点 1 → 500，顶边 100。
      await tester.drag(
        find.byKey(kAntFloatingPanelHandleKey),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();
      final rect2 = _panelRect(tester);
      expect(rect2.height, closeTo(500, 1));
      expect(rect2.top, closeTo(100, 1));
    });

    testWidgets('onHeightChange 回调返回高度比例', (tester) async {
      final List<double> percents = <double>[];
      await tester.pumpWidget(
        _wrap(_defaultPanel(onHeightChange: percents.add)),
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(kAntFloatingPanelHandleKey),
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();
      expect(percents, isNotEmpty);
      // 拖动过程有中间值，最终停在 0.8 锚点。
      expect(percents.last, closeTo(0.8, 0.01));
      expect(percents.any((double p) => p > 0.6 && p < 0.8), isTrue);
    });

    testWidgets('面板圆角、阴影与白底样式', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final theme = AntThemeData.light();
      expect(decoration.color, theme.colorBgContainer);
      expect(decoration.boxShadow, isNotEmpty);
      final radius = decoration.borderRadius! as BorderRadius;
      expect(radius.topLeft.x, 16.r);
      expect(radius.bottomLeft.x, 0);
    });

    testWidgets('内容区高度为面板高度减把手高度', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      await tester.pumpAndSettle();
      final contentSize = tester.getSize(
        find.byKey(kAntFloatingPanelContentKey),
      );
      // 初始高度 360，把手 28 → 内容区 332。
      expect(contentSize.height, closeTo(360 - 28.w, 1));
    });

    testWidgets('内容列表可滚动', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _defaultPanel(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (_, int index) =>
                  ListTile(title: Text('项目 $index')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('项目 0'), findsOneWidget);
      await tester.drag(find.text('项目 2'), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(find.text('项目 0'), findsNothing);
    });

    testWidgets('拖动过程中面板高度实时跟随', (tester) async {
      await tester.pumpWidget(_wrap(_defaultPanel()));
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(kAntFloatingPanelHandleKey)),
      );
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump(const Duration(milliseconds: 16));
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump(const Duration(milliseconds: 16));
      // 拖动中高度已增加，且未越过中间锚点。
      final draggingHeight = _panelRect(tester).height;
      expect(draggingHeight, greaterThan(360));
      expect(draggingHeight, lessThan(480));
      await gesture.up();
      await tester.pumpAndSettle();
      // 松手后吸附到最近锚点 0.8 → 480。
      expect(_panelRect(tester).height, closeTo(480, 1));
    });

    testWidgets('anchors 为空时回退默认锚点', (tester) async {
      await tester.pumpWidget(
        _wrap(_defaultPanel(anchors: const <double>[])),
      );
      await tester.pumpAndSettle();
      // 回退到默认最低锚点 0.6 → 360。
      expect(_panelRect(tester).height, closeTo(360, 1));
    });
  });

  group('AntFloatingPanelController (R35)', () {
    testWidgets('snapToAnchorAt 吸附到指定锚点', (tester) async {
      final controller = AntFloatingPanelController();
      await tester.pumpWidget(_wrap(_defaultPanel(controller: controller)));
      await tester.pumpAndSettle();
      controller.snapToAnchorAt(2); // 最高锚点 1 → 600
      await tester.pumpAndSettle();
      expect(_panelRect(tester).height, closeTo(600, 1));
      expect(controller.heightRatio, closeTo(1.0, 0.01));
    });

    testWidgets('expand / collapse / resetToInitial', (tester) async {
      final controller = AntFloatingPanelController();
      await tester.pumpWidget(_wrap(_defaultPanel(controller: controller)));
      await tester.pumpAndSettle();
      controller.expand();
      await tester.pumpAndSettle();
      expect(_panelRect(tester).height, closeTo(600, 1));
      controller.collapse();
      await tester.pumpAndSettle();
      expect(_panelRect(tester).height, closeTo(360, 1));
      controller.expand();
      await tester.pumpAndSettle();
      controller.resetToInitial();
      await tester.pumpAndSettle();
      expect(_panelRect(tester).height, closeTo(360, 1));
    });

    testWidgets('heightRatio 随拖拽/吸附变化并可监听', (tester) async {
      final controller = AntFloatingPanelController();
      final List<double> ratios = [];
      controller.addListener(() {
        if (controller.heightRatio != null) ratios.add(controller.heightRatio!);
      });
      await tester.pumpWidget(_wrap(_defaultPanel(controller: controller)));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(kAntFloatingPanelHandleKey),
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();
      expect(ratios, isNotEmpty);
      expect(controller.heightRatio, closeTo(0.8, 0.01));
    });

    testWidgets('未挂接时调用为安全空操作', (tester) async {
      final controller = AntFloatingPanelController();
      controller.expand();
      controller.collapse();
      controller.snapToAnchorAt(1);
      controller.resetToInitial();
      expect(controller.heightRatio, isNull);
    });
  });
}
