import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

class _TabBarData {
  const _TabBarData({
    required this.key,
    this.title,
    this.titleWidget,
    this.icon,
    this.activeIcon,
    this.badgeText,
    this.badgeDot = false,
  });

  final String key;
  final String? title;
  final Widget? titleWidget;
  final IconData? icon;
  final IconData? activeIcon;
  final String? badgeText;
  final bool badgeDot;
}

Widget _tabBar({
  Key? key,
  required List<_TabBarData> items,
  Object? activeKey,
  Object? defaultActiveKey,
  ValueChanged<_TabBarData>? onChange,
  bool border = true,
}) {
  return AntTabBar<_TabBarData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) =>
        item.titleWidget ?? Text(item.title ?? item.key),
    iconBuilder: (context, item) => item.icon == null ? null : Icon(item.icon!),
    activeIconBuilder: (context, item) =>
        item.activeIcon == null ? null : Icon(item.activeIcon!),
    badgeTextOf: (item) => item.badgeText,
    badgeDotOf: (item) => item.badgeDot,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
    border: border,
  );
}

TextStyle? _effectiveStyle(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.text.style;
}

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
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(key: 'a', title: '首页'),
              const _TabBarData(key: 'b', title: '我的'),
            ],
          ),
        ),
      );

      expect(find.text('首页'), findsOneWidget);
      expect(find.text('我的'), findsOneWidget);
    });

    testWidgets('渲染图标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(
                key: 'a',
                title: '首页',
                icon: AntIcons.homeOutlined,
              ),
              const _TabBarData(
                key: 'b',
                title: '我的',
                icon: AntIcons.userOutlined,
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(AntIcons.homeOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.userOutlined), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(
                key: 'a',
                titleWidget: Text('自定义标题'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('自定义标题'), findsOneWidget);
    });

    testWidgets('默认激活第一项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(key: 'a', title: '首页'),
              const _TabBarData(key: 'b', title: '我的'),
            ],
          ),
        ),
      );

      // 第一项激活 → colorPrimary
      expect(
        _effectiveStyle(tester, '首页')?.color,
        isNot(equals(_effectiveStyle(tester, '我的')?.color)),
      );
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            defaultActiveKey: 'b',
            items: [
              const _TabBarData(key: 'a', title: '首页'),
              const _TabBarData(key: 'b', title: '我的'),
            ],
          ),
        ),
      );

      // b 激活 → 两项颜色不同
      expect(
        _effectiveStyle(tester, '首页')?.color,
        isNot(equals(_effectiveStyle(tester, '我的')?.color)),
      );
    });

    testWidgets('渲染文字角标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(
                key: 'a',
                title: '首页',
                icon: AntIcons.homeOutlined,
                badgeText: '5',
              ),
            ],
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('渲染圆点角标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(key: 'a', title: '首页', badgeDot: true),
            ],
          ),
        ),
      );

      // 圆点是一个小 Container（圆形装饰）
      final dot = find.byWidgetPredicate(
        (w) => w is Container && (w.decoration is BoxDecoration),
      );
      expect(dot, findsWidgets);
    });

    testWidgets('border 默认 true 有顶部分割线', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [const _TabBarData(key: 'a', title: '首页')],
          ),
        ),
      );

      // 有 border → BoxDecoration.border 非 null
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('首页'), matching: find.byType(Container))
            .last,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });

  group('AntTabBar — 交互', () {
    testWidgets('点击切换标签触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _wrap(
            _tabBar(
              items: const [
                _TabBarData(key: 'a', title: '首页'),
                _TabBarData(key: 'b', title: '我的'),
              ],
              onChange: (key) => setState(() => changed = key.key),
            ),
          ),
        ),
      );

      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      expect(changed, 'b');
    });

    testWidgets('受控模式不内部切换', (tester) async {
      String activeKey = 'a';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _wrap(
            _tabBar(
              activeKey: activeKey,
              items: const [
                _TabBarData(key: 'a', title: '首页'),
                _TabBarData(key: 'b', title: '我的'),
              ],
              onChange: (key) => setState(() => activeKey = key.key),
            ),
          ),
        ),
      );

      // 点击 b
      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      // 受控模式：activeKey 更新为 b
      expect(activeKey, 'b');
    });

    testWidgets('点击当前激活项不触发 onChange', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: const [
              _TabBarData(key: 'a', title: '首页'),
              _TabBarData(key: 'b', title: '我的'),
            ],
            onChange: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.text('首页'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });

  group('AntTabBar — 布局', () {
    testWidgets('border false 无分割线', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            border: false,
            items: [const _TabBarData(key: 'a', title: '首页')],
          ),
        ),
      );

      // border=false → BoxDecoration.border 为 null
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('首页'), matching: find.byType(Container))
            .last,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('激活时显示 activeIcon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            defaultActiveKey: 'a',
            items: [
              const _TabBarData(
                key: 'a',
                title: '首页',
                icon: AntIcons.homeOutlined,
                activeIcon: AntIcons.homeFilled,
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(AntIcons.homeFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.homeOutlined), findsNothing);
    });

    testWidgets('非激活时显示普通 icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            defaultActiveKey: 'b',
            items: [
              const _TabBarData(
                key: 'a',
                title: '首页',
                icon: AntIcons.homeOutlined,
                activeIcon: AntIcons.homeFilled,
              ),
              const _TabBarData(key: 'b', title: '我的'),
            ],
          ),
        ),
      );

      expect(find.byIcon(AntIcons.homeOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.homeFilled), findsNothing);
    });

    testWidgets('无图标时只渲染标题', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _tabBar(
            items: [
              const _TabBarData(key: 'a', title: '首页'),
            ],
          ),
        ),
      );

      expect(find.text('首页'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });
  });
}
