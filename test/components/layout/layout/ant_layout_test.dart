/// AntLayout Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
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

/// 在 AntLayoutSider 内查找指定类型的 widget
Finder _withinSider(Finder matching) {
  return find.descendant(of: find.byType(AntLayoutSider), matching: matching);
}

void main() {
  group('AntLayout — 基础渲染', () {
    testWidgets('renders sider + header + content + footer', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayout(
            sider: AntLayoutSider(child: Text('侧边栏')),
            header: AntLayoutHeader(child: Text('顶部')),
            content: AntLayoutContent(child: Text('内容')),
            footer: AntLayoutFooter(child: Text('底部')),
          ),
        ),
      );
      expect(find.byType(AntLayout), findsOneWidget);
      expect(find.byType(AntLayoutSider), findsOneWidget);
      expect(find.byType(AntLayoutHeader), findsOneWidget);
      expect(find.byType(AntLayoutContent), findsOneWidget);
      expect(find.byType(AntLayoutFooter), findsOneWidget);
      expect(find.text('侧边栏'), findsOneWidget);
      expect(find.text('顶部'), findsOneWidget);
      expect(find.text('内容'), findsOneWidget);
      expect(find.text('底部'), findsOneWidget);
    });

    testWidgets('renders without sider — vertical structure only',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayout(
            header: AntLayoutHeader(child: Text('顶部')),
            content: AntLayoutContent(child: Text('内容')),
          ),
        ),
      );
      expect(find.byType(AntLayout), findsOneWidget);
      expect(find.byType(AntLayoutSider), findsNothing);
      expect(find.byType(AntLayoutHeader), findsOneWidget);
      expect(find.byType(AntLayoutContent), findsOneWidget);
      // 无 sider 时不应有 Row
      expect(
        find.descendant(of: find.byType(AntLayout), matching: find.byType(Row)),
        findsNothing,
      );
    });

    testWidgets('with sider renders horizontal Row structure',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayout(
            sider: AntLayoutSider(child: Text('S')),
            content: AntLayoutContent(child: Text('C')),
          ),
        ),
      );
      expect(
        find.descendant(of: find.byType(AntLayout), matching: find.byType(Row)),
        findsOneWidget,
      );
    });

    testWidgets('all slots null renders empty expanded', (tester) async {
      await tester.pumpWidget(_wrap(const AntLayout()));
      expect(find.byType(AntLayout), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });

  group('AntLayoutHeader', () {
    testWidgets('default height is 64', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutHeader(child: Text('头部'))),
      );
      final size = tester.getSize(find.byType(AntLayoutHeader));
      expect(size.height, closeTo(64, 0.01));
    });

    testWidgets('custom height overrides default', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutHeader(height: 100, child: Text('头部'))),
      );
      final size = tester.getSize(find.byType(AntLayoutHeader));
      expect(size.height, closeTo(100, 0.01));
    });

    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutHeader(child: Text('头部内容'))),
      );
      expect(find.text('头部内容'), findsOneWidget);
    });
  });

  group('AntLayoutContent', () {
    testWidgets('renders child with colorBgLayout background',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutContent(child: Text('主体'))),
      );
      expect(find.text('主体'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntLayoutContent),
          matching: find.byType(ColoredBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('custom padding wraps child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutContent(
            padding: EdgeInsets.all(20),
            child: Text('带边距'),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntLayoutContent),
          matching: find.byType(Padding),
        ),
        findsOneWidget,
      );
      expect(find.text('带边距'), findsOneWidget);
    });

    testWidgets('null child renders shrink', (tester) async {
      await tester.pumpWidget(_wrap(const AntLayoutContent()));
      expect(find.byType(AntLayoutContent), findsOneWidget);
    });
  });

  group('AntLayoutFooter', () {
    testWidgets('renders child with default padding', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutFooter(child: Text('底部'))),
      );
      expect(find.text('底部'), findsOneWidget);
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntLayoutFooter),
          matching: find.byType(Container),
        ),
      );
      expect(container.padding, isNotNull);
    });

    testWidgets('custom padding overrides default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutFooter(
            padding: EdgeInsets.all(8),
            child: Text('自定义边距'),
          ),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntLayoutFooter),
          matching: find.byType(Container),
        ),
      );
      expect(container.padding, const EdgeInsets.all(8));
    });

    testWidgets('applies DefaultTextStyle with colorTextSecondary',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutFooter(child: Text('底部文字'))),
      );
      final defaultStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(AntLayoutFooter),
          matching: find.byType(DefaultTextStyle),
        ),
      );
      expect(defaultStyle.style.color, isNotNull);
    });
  });

  group('AntLayoutSider — 基础', () {
    testWidgets('default width is 200', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutSider(child: Text('侧边'))),
      );
      final size = tester.getSize(find.byType(AntLayoutSider));
      expect(size.width, closeTo(200, 0.01));
    });

    testWidgets('dark theme background is #001529', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutSider(child: Text('深色'))),
      );
      final container = tester.widget<AnimatedContainer>(
        _withinSider(find.byType(AnimatedContainer)),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF001529));
    });

    testWidgets('light theme background is colorBgContainer',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            theme: AntLayoutSiderTheme.light,
            child: Text('浅色'),
          ),
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        _withinSider(find.byType(AnimatedContainer)),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(const Color(0xFF001529)));
    });

    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutSider(child: Text('侧边内容'))),
      );
      expect(find.text('侧边内容'), findsOneWidget);
    });
  });

  group('AntLayoutSider — 折叠', () {
    testWidgets('collapsible false hides trigger', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLayoutSider(child: Text('无触发器'))),
      );
      expect(_withinSider(find.byType(InkWell)), findsNothing);
    });

    testWidgets('collapsible true shows trigger', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            child: Text('有触发器'),
          ),
        ),
      );
      expect(_withinSider(find.byType(InkWell)), findsOneWidget);
    });

    testWidgets('tap trigger toggles to collapsed width', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            child: Text('可折叠'),
          ),
        ),
      );
      // 初始展开宽度
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(200, 0.01),
      );

      // 点击触发器
      await tester.tap(_withinSider(find.byType(InkWell)));
      await tester.pumpAndSettle();

      // 折叠后宽度 = 80
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('defaultCollapsed starts at collapsedWidth',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            defaultCollapsed: true,
            child: Text('初始折叠'),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('onCollapse callback fires with correct value',
        (tester) async {
      bool? collapsed;
      await tester.pumpWidget(
        _wrap(
          AntLayoutSider(
            collapsible: true,
            onCollapse: (value) => collapsed = value,
            child: const Text('回调'),
          ),
        ),
      );

      await tester.tap(_withinSider(find.byType(InkWell)));
      await tester.pumpAndSettle();

      expect(collapsed, isTrue);
    });

    testWidgets('custom trigger replaces default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            trigger: Text('自定义触发'),
            child: Text('内容'),
          ),
        ),
      );
      expect(find.text('自定义触发'), findsOneWidget);
      // 默认图标不应存在
      expect(_withinSider(find.byType(AntdIcon)), findsNothing);
    });

    testWidgets('tap custom trigger also toggles', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            trigger: Text('点我折叠'),
            child: Text('内容'),
          ),
        ),
      );
      await tester.tap(find.text('点我折叠'));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('controlled collapsed true renders collapsedWidth',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            collapsible: true,
            collapsed: true,
            child: Text('受控折叠'),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('controlled mode syncs when external collapsed changes',
        (tester) async {
      late StateSetter setState;
      bool collapsed = false;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, s) {
              setState = s;
              return AntLayoutSider(
                collapsible: true,
                collapsed: collapsed,
                onCollapse: (v) => setState(() => collapsed = v),
                child: const Text('受控'),
              );
            },
          ),
        ),
      );
      // 初始展开
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(200, 0.01),
      );
      // 外部切换为折叠
      setState(() => collapsed = true);
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('controlled tap trigger calls onCollapse with next value',
        (tester) async {
      bool? lastValue;
      await tester.pumpWidget(
        _wrap(
          AntLayoutSider(
            collapsible: true,
            collapsed: false,
            onCollapse: (v) => lastValue = v,
            child: const Text('受控点击'),
          ),
        ),
      );
      await tester.tap(_withinSider(find.byType(InkWell)));
      await tester.pumpAndSettle();
      // 回调收到 true（下一个状态）
      expect(lastValue, isTrue);
      // 受控模式：外部未更新 collapsed，宽度不变
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(200, 0.01),
      );
    });
  });

  group('AntLayoutSider — 断点响应', () {
    testWidgets('breakpoint auto-collapses when width below threshold',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            breakpoint: 992,
            child: Text('断点'),
          ),
        ),
      );
      // 测试面宽 800 < 992 → 自动折叠
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(80, 0.01),
      );
    });

    testWidgets('no collapse when width above breakpoint', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayoutSider(
            breakpoint: 500,
            child: Text('宽屏'),
          ),
        ),
      );
      // 测试面宽 800 > 500 → 保持展开
      expect(
        tester.getSize(find.byType(AntLayoutSider)).width,
        closeTo(200, 0.01),
      );
    });

    testWidgets('onBreakpoint fires when below threshold', (tester) async {
      var breakpointHit = false;
      await tester.pumpWidget(
        _wrap(
          AntLayoutSider(
            breakpoint: 992,
            onBreakpoint: () => breakpointHit = true,
            child: const Text('触发断点'),
          ),
        ),
      );
      expect(breakpointHit, isTrue);
    });
  });

  group('AntLayout — 组合场景', () {
    testWidgets('full page layout with collapsible sider', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayout(
            sider: AntLayoutSider(
              collapsible: true,
              child: Text('导航菜单'),
            ),
            header: AntLayoutHeader(child: Text('页面标题')),
            content: AntLayoutContent(child: Text('页面内容')),
            footer: AntLayoutFooter(child: Text('版权信息')),
          ),
        ),
      );
      expect(find.text('导航菜单'), findsOneWidget);
      expect(find.text('页面标题'), findsOneWidget);
      expect(find.text('页面内容'), findsOneWidget);
      expect(find.text('版权信息'), findsOneWidget);
    });

    testWidgets('header + content only (top-bottom structure)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntLayout(
            header: AntLayoutHeader(child: Text('顶')),
            content: AntLayoutContent(child: Text('体')),
          ),
        ),
      );
      expect(find.byType(AntLayoutFooter), findsNothing);
      expect(find.byType(AntLayoutSider), findsNothing);
    });
  });
}