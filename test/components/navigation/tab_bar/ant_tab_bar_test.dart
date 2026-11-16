import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  group('AntTabBar — 渲染', () {
    testWidgets('渲染所有标签项的标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页'),
          AntTabBarItem(key: 'b', title: '我的'),
        ],
      )));

      expect(find.text('首页'), findsOneWidget);
      expect(find.text('我的'), findsOneWidget);
    });

    testWidgets('渲染图标', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页', icon: Icons.home),
          AntTabBarItem(key: 'b', title: '我的', icon: Icons.person),
        ],
      )));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(
            key: 'a',
            titleWidget: Text('自定义标题'),
          ),
        ],
      )));

      expect(find.text('自定义标题'), findsOneWidget);
    });

    testWidgets('默认激活第一项', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页'),
          AntTabBarItem(key: 'b', title: '我的'),
        ],
      )));

      // 第一项激活 → colorPrimary
      final textA = tester.widget<Text>(find.text('首页'));
      final textB = tester.widget<Text>(find.text('我的'));
      expect(textA.style?.color, isNot(equals(textB.style?.color)));
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        defaultActiveKey: 'b',
        items: [
          AntTabBarItem(key: 'a', title: '首页'),
          AntTabBarItem(key: 'b', title: '我的'),
        ],
      )));

      // b 激活 → 两项颜色不同
      final textA = tester.widget<Text>(find.text('首页'));
      final textB = tester.widget<Text>(find.text('我的'));
      expect(textA.style?.color, isNot(equals(textB.style?.color)));
    });

    testWidgets('渲染文字角标', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页', icon: Icons.home, badgeText: '5'),
        ],
      )));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('渲染圆点角标', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页', badgeDot: true),
        ],
      )));

      // 圆点是一个小 Container（圆形装饰）
      final dot = find.byWidgetPredicate(
        (w) => w is Container && (w.decoration is BoxDecoration),
      );
      expect(dot, findsWidgets);
    });

    testWidgets('border 默认 true 有顶部分割线', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [AntTabBarItem(key: 'a', title: '首页')],
      )));

      // 有 border → BoxDecoration.border 非 null
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('首页'), matching: find.byType(Container)).last,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });

  group('AntTabBar — 交互', () {
    testWidgets('点击切换标签触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntTabBar(
          items: const [
            AntTabBarItem(key: 'a', title: '首页'),
            AntTabBarItem(key: 'b', title: '我的'),
          ],
          onChange: (key) => setState(() => changed = key),
        )),
      ));

      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      expect(changed, 'b');
    });

    testWidgets('受控模式不内部切换', (tester) async {
      String activeKey = 'a';
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) => _wrap(AntTabBar(
          activeKey: activeKey,
          items: const [
            AntTabBarItem(key: 'a', title: '首页'),
            AntTabBarItem(key: 'b', title: '我的'),
          ],
          onChange: (key) => setState(() => activeKey = key),
        )),
      ));

      // 点击 b
      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      // 受控模式：activeKey 更新为 b
      expect(activeKey, 'b');
    });

    testWidgets('点击当前激活项不触发 onChange', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(AntTabBar(
        items: const [
          AntTabBarItem(key: 'a', title: '首页'),
          AntTabBarItem(key: 'b', title: '我的'),
        ],
        onChange: (_) => callCount++,
      )));

      await tester.tap(find.text('首页'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });

  group('AntTabBar — 布局', () {
    testWidgets('border false 无分割线', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        border: false,
        items: [AntTabBarItem(key: 'a', title: '首页')],
      )));

      // border=false → BoxDecoration.border 为 null
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('首页'), matching: find.byType(Container)).last,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('激活时显示 activeIcon', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        defaultActiveKey: 'a',
        items: [
          AntTabBarItem(
            key: 'a',
            title: '首页',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
        ],
      )));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);
    });

    testWidgets('非激活时显示普通 icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        defaultActiveKey: 'b',
        items: [
          AntTabBarItem(
            key: 'a',
            title: '首页',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          AntTabBarItem(key: 'b', title: '我的'),
        ],
      )));

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home), findsNothing);
    });

    testWidgets('无图标时只渲染标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntTabBar(
        items: [
          AntTabBarItem(key: 'a', title: '首页'),
        ],
      )));

      expect(find.text('首页'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });
  });
}