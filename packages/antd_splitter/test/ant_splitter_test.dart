/// AntSplitter Widget 测试
library;

import 'package:antd_splitter/antd_splitter.dart';
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

/// 获取 AntSplitter 内所有面板 SizedBox 的宽度。
List<double> _panelWidths(WidgetTester tester, {int count = 2}) {
  return List.generate(count, (i) {
    final box = tester.widget<SizedBox>(
      find.byKey(ValueKey('ant_splitter_panel_$i')),
    );
    return box.width ?? 0;
  });
}

/// 获取 AntSplitter 内所有面板 SizedBox 的高度。
List<double> _panelHeights(WidgetTester tester, {int count = 2}) {
  return List.generate(count, (i) {
    final box = tester.widget<SizedBox>(
      find.byKey(ValueKey('ant_splitter_panel_$i')),
    );
    return box.height ?? 0;
  });
}

/// 拖拽器 Finder。
final _dragger0 = find.byKey(const ValueKey('ant_splitter_dragger_0'));

void main() {
  group('AntSplitter — 基础渲染', () {
    testWidgets('renders two panels with content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(child: Text('面板A')),
              AntSplitterPanel(child: Text('面板B')),
            ],
          ),
        ),
      );
      expect(find.byType(AntSplitter), findsOneWidget);
      expect(find.text('面板A'), findsOneWidget);
      expect(find.text('面板B'), findsOneWidget);
    });

    testWidgets('renders three panels with two draggers', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(child: Text('P1')),
              AntSplitterPanel(child: Text('P2')),
              AntSplitterPanel(child: Text('P3')),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('ant_splitter_dragger_0')),
          findsOneWidget,);
      expect(find.byKey(const ValueKey('ant_splitter_dragger_1')),
          findsOneWidget,);
      expect(find.text('P1'), findsOneWidget);
      expect(find.text('P2'), findsOneWidget);
      expect(find.text('P3'), findsOneWidget);
    });

    testWidgets('empty children renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(const AntSplitter()));
      expect(find.byType(AntSplitter), findsOneWidget);
      expect(find.byKey(const ValueKey('ant_splitter_panel_0')), findsNothing);
    });
  });

  group('AntSplitter — 尺寸分配', () {
    testWidgets('unspecified panels split remaining space equally',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // 800 - 20(dragger) = 780, 每面板 390
      expect(_panelWidths(tester), closeToList([390, 390]));
    });

    testWidgets('defaultSize takes priority for specified panel',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(defaultSize: 200, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // A=200, B=780-200=580
      expect(_panelWidths(tester), closeToList([200, 580]));
    });

    testWidgets('min constraint clamps panel size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(defaultSize: 100, min: 150, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // A 被 min 约束到 150, B=780-150=630
      expect(_panelWidths(tester), closeToList([150, 630]));
    });

    testWidgets('max constraint clamps panel size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(defaultSize: 500, max: 300, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // A 被 max 约束到 300, B=780-300=480
      expect(_panelWidths(tester), closeToList([300, 480]));
    });
  });

  group('AntSplitter — 垂直布局', () {
    testWidgets('vertical layout uses Column', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            layout: AntSplitterLayout.vertical,
            children: [
              AntSplitterPanel(child: Text('上')),
              AntSplitterPanel(child: Text('下')),
            ],
          ),
        ),
      );
      expect(
        find.descendant(
            of: find.byType(AntSplitter), matching: find.byType(Column),),
        findsOneWidget,
      );
      // 600 - 20 = 580, 每面板 290
      expect(_panelHeights(tester), closeToList([290, 290]));
    });
  });

  group('AntSplitter — 拖拽', () {
    testWidgets('drag updates panel sizes and calls onResize',
        (tester) async {
      var resizeCalled = false;
      List<double>? resizeSizes;
      await tester.pumpWidget(
        _wrap(
          AntSplitter(
            onResize: (sizes) {
              resizeCalled = true;
              resizeSizes = sizes;
            },
            children: const [
              AntSplitterPanel(child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      expect(_panelWidths(tester), closeToList([390, 390]));

      await tester.drag(_dragger0, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(_panelWidths(tester), closeToList([440, 340]));
      expect(resizeCalled, isTrue);
      expect(resizeSizes, isNotNull);
    });

    testWidgets('drag respects min constraint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(child: Text('A')),
              AntSplitterPanel(min: 100, child: Text('B')),
            ],
          ),
        ),
      );
      // 尝试向右拖 350, B 被约束到 min=100
      await tester.drag(_dragger0, const Offset(350, 0));
      await tester.pumpAndSettle();

      final widths = _panelWidths(tester);
      expect(widths[1], closeTo(100, 1));
      expect(widths[0], closeTo(680, 1));
    });

    testWidgets('drag respects max constraint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(max: 450, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // 尝试向右拖 100, A 被约束到 max=450
      await tester.drag(_dragger0, const Offset(100, 0));
      await tester.pumpAndSettle();

      final widths = _panelWidths(tester);
      expect(widths[0], closeTo(450, 1));
    });

    testWidgets('resizable=false prevents dragging', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(resizable: false, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      await tester.drag(_dragger0, const Offset(50, 0));
      await tester.pumpAndSettle();

      // 尺寸不变
      expect(_panelWidths(tester), closeToList([390, 390]));
    });

    testWidgets('onResizeStart and onResizeEnd are called',
        (tester) async {
      var startCalled = false;
      var endCalled = false;
      await tester.pumpWidget(
        _wrap(
          AntSplitter(
            onResizeStart: (_) => startCalled = true,
            onResizeEnd: (_) => endCalled = true,
            children: const [
              AntSplitterPanel(child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      await tester.drag(_dragger0, const Offset(30, 0));
      await tester.pumpAndSettle();

      expect(startCalled, isTrue);
      expect(endCalled, isTrue);
    });
  });

  group('AntSplitter — 折叠', () {
    testWidgets('collapsible shows collapse buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(collapsible: true, child: Text('B')),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('ant_splitter_collapse_0')),
          findsOneWidget,);
      expect(find.byKey(const ValueKey('ant_splitter_collapse_1')),
          findsOneWidget,);
    });

    testWidgets('collapse button renders fully with >=44x44 hit area',
        (tester) async {
      var collapseCalled = false;
      await tester.pumpWidget(
        _wrap(
          AntSplitter(
            onCollapse: (collapsed, sizes) => collapseCalled = true,
            children: const [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );

      final hitBox = tester.getSize(
        find.byKey(const ValueKey('ant_splitter_collapse_0')),
      );

      // 触控区域最小 44x44（Material 触控规范）
      expect(hitBox.width, greaterThanOrEqualTo(44));
      expect(hitBox.height, greaterThanOrEqualTo(44));

      // 视觉按钮（带边框 Container）完整渲染，不被分割条裁剪
      final visual = tester.getSize(
        find
            .descendant(
              of: find.byKey(const ValueKey('ant_splitter_collapse_0')),
              matching: find.byWidgetPredicate(
                (w) => w is Container && w.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect(visual.width, greaterThan(0));
      expect(visual.height, greaterThan(0));

      // 按钮中心位于分割条拖拽区内，且命中框边缘可点（溢出绘制未遮挡命中）
      final center = tester.getCenter(
        find.byKey(const ValueKey('ant_splitter_collapse_0')),
      );
      final draggerRect = tester.getRect(
        find.byKey(const ValueKey('ant_splitter_dragger_0')),
      );
      // 按钮位于分割条两侧（antd 表现）：中心在分割条中心 ±44 内
      expect((center.dx - draggerRect.center.dx).abs(), lessThanOrEqualTo(44));
      // 命中框宽于 20px 拖拽区（允许溢出分割条，保证完整触控区域）
      expect(hitBox.width, greaterThan(draggerRect.width));

      // 分割条以外（面板边缘，分割条中心左侧 40px）点击也能触发折叠：
      // 命中框挂在外层 Stack 上，命中测试不受分割条 20px 约束
      expect(collapseCalled, isFalse);
      await tester.tapAt(Offset(draggerRect.center.dx - 40, center.dy));
      await tester.pumpAndSettle();
      expect(collapseCalled, isTrue);
    });

    testWidgets('tap collapse button collapses panel and calls onCollapse',
        (tester) async {
      var collapseCalled = false;
      List<bool>? collapsedStates;
      await tester.pumpWidget(
        _wrap(
          AntSplitter(
            onCollapse: (collapsed, sizes) {
              collapseCalled = true;
              collapsedStates = collapsed;
            },
            children: const [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      expect(_panelWidths(tester), closeToList([390, 390]));

      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_0')));
      await tester.pumpAndSettle();

      // 面板 A 折叠为 0
      expect(_panelWidths(tester)[0], closeTo(0, 1));
      expect(collapseCalled, isTrue);
      expect(collapsedStates?[0], isTrue);
    });

    testWidgets('tap collapsed button again expands panel',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      // 折叠
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_0')));
      await tester.pumpAndSettle();
      expect(_panelWidths(tester)[0], closeTo(0, 1));

      // 展开
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_0')));
      await tester.pumpAndSettle();
      expect(_panelWidths(tester)[0], closeTo(390, 1));
    });

    testWidgets('collapsing the last expanded panel auto-expands neighbor',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(collapsible: true, child: Text('B')),
            ],
          ),
        ),
      );

      // 先折叠面板 A，再折叠面板 B
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_1')));
      await tester.pumpAndSettle();

      // 面板 B 折叠时面板 A 自动展开（两面板不可同时保持折叠，防死锁）
      final widths = _panelWidths(tester);
      expect(widths[0], greaterThan(0));
      expect(widths[1], closeTo(0, 1));

      // 面板 A 的折叠按钮仍可点击（可再折叠/恢复），不会卡死
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_1')));
      await tester.pumpAndSettle();
      expect(_panelWidths(tester)[1], greaterThan(0));
    });

    testWidgets('collapsed panel space goes to neighbor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            children: [
              AntSplitterPanel(collapsible: true, child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('ant_splitter_collapse_0')));
      await tester.pumpAndSettle();

      // B 获得释放的空间: 780
      expect(_panelWidths(tester)[1], closeTo(780, 1));
    });
  });

  group('AntSplitter — 受控模式', () {
    testWidgets('controlled size syncs on widget update', (tester) async {
      double controlledSize = 200;
      late StateSetter setState;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState_) {
              setState = setState_;
              return AntSplitter(
                children: [
                  AntSplitterPanel(size: controlledSize, child: const Text('A')),
                  const AntSplitterPanel(child: Text('B')),
                ],
              );
            },
          ),
        ),
      );
      expect(_panelWidths(tester), closeToList([200, 580]));

      // 外部更新受控尺寸
      setState(() => controlledSize = 300);
      await tester.pumpAndSettle();

      expect(_panelWidths(tester), closeToList([300, 480]));
    });
  });

  group('AntSplitter — 双击重置', () {
    testWidgets('double tap dragger resets to defaultSize',
        (tester) async {
      var doubleTapCalled = false;
      await tester.pumpWidget(
        _wrap(
          AntSplitter(
            onDraggerDoubleClick: (index) => doubleTapCalled = true,
            children: const [
              AntSplitterPanel(defaultSize: 200, child: Text('A')),
              AntSplitterPanel(defaultSize: 580, child: Text('B')),
            ],
          ),
        ),
      );
      expect(_panelWidths(tester), closeToList([200, 580]));

      // 拖拽改变尺寸
      await tester.drag(_dragger0, const Offset(50, 0));
      await tester.pumpAndSettle();
      expect(_panelWidths(tester), closeToList([250, 530]));

      // 双击重置
      await tester.tap(_dragger0);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(_dragger0);
      await tester.pumpAndSettle();

      expect(doubleTapCalled, isTrue);
      expect(_panelWidths(tester), closeToList([200, 580]));
    });
  });

  group('AntSplitter — lazy 模式', () {
    testWidgets('lazy mode defers size update until drag ends',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSplitter(
            lazy: true,
            children: [
              AntSplitterPanel(child: Text('A')),
              AntSplitterPanel(child: Text('B')),
            ],
          ),
        ),
      );
      expect(_panelWidths(tester), closeToList([390, 390]));

      // 开始拖拽但未释放
      final gesture = await tester.startGesture(tester.getCenter(_dragger0));
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();

      // lazy 模式:尺寸未更新
      expect(_panelWidths(tester), closeToList([390, 390]));

      // 释放
      await gesture.up();
      await tester.pumpAndSettle();

      // 释放后:尺寸更新
      expect(_panelWidths(tester), closeToList([440, 340]));
    });
  });
}

/// 辅助:列表 closeTo 匹配。
Matcher closeToList(List<double> expected) {
  return _CloseToListMatcher(expected);
}

class _CloseToListMatcher extends Matcher {
  _CloseToListMatcher(this._expected);

  final List<double> _expected;

  @override
  bool matches(Object? item, Map matchState) {
    if (item is! List<double>) return false;
    if (item.length != _expected.length) return false;
    for (var i = 0; i < _expected.length; i++) {
      if ((item[i] - _expected[i]).abs() > 1) return false;
    }
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('equals approximately $_expected (±1)');
  }

  @override
  Description describeMismatch(
      Object? item, Description mismatchDescription, Map matchState, bool verbose,) {
    if (item is List<double>) {
      return mismatchDescription.add('was $item');
    }
    return mismatchDescription.add('was not a List<double>');
  }
}