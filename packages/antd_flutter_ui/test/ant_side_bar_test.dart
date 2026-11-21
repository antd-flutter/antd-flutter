import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

class _SideData {
  const _SideData({
    required this.key,
    this.title,
    this.titleWidget,
    this.badgeText,
    this.badgeDot = false,
    this.disabled = false,
  });

  final String key;
  final String? title;
  final Widget? titleWidget;
  final String? badgeText;
  final bool badgeDot;
  final bool disabled;
}

Widget _sideBar({
  Key? key,
  required List<_SideData> items,
  Object? activeKey,
  Object? defaultActiveKey,
  ValueChanged<_SideData>? onChange,
}) {
  return AntSideBar<_SideData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) =>
        item.titleWidget ?? Text(item.title ?? item.key),
    badgeTextOf: (item) => item.badgeText,
    badgeDotOf: (item) => item.badgeDot,
    disabledOf: (item) => item.disabled,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
  );
}

TextStyle? _effectiveStyle(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.text.style;
}

Widget _wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      );

void main() {
  group('AntSideBar — 渲染', () {
    testWidgets('渲染所有项标题', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一'),
              const _SideData(key: 'b', title: '选项二'),
              const _SideData(key: 'c', title: '选项三'),
            ],
          ),
        ),
      );

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项三'), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', titleWidget: Text('自定义标题')),
            ],
          ),
        ),
      );

      expect(find.text('自定义标题'), findsOneWidget);
    });

    testWidgets('默认激活第一项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一'),
              const _SideData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      // 第一项激活 → 颜色不同
      final textA = _effectiveStyle(tester, '选项一')!;
      final textB = _effectiveStyle(tester, '选项二')!;
      expect(textA.color, isNot(equals(textB.color)));
      expect(textA.fontWeight, FontWeight.w600);
      expect(textB.fontWeight, FontWeight.w400);
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            defaultActiveKey: 'b',
            items: [
              const _SideData(key: 'a', title: '选项一'),
              const _SideData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      expect(_effectiveStyle(tester, '选项二')?.fontWeight, FontWeight.w600);
    });

    testWidgets('渲染圆点角标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一', badgeDot: true),
            ],
          ),
        ),
      );

      // 圆点是一个圆形小 Container
      final dot = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(dot, findsOneWidget);
    });

    testWidgets('渲染文字角标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一', badgeText: '9'),
            ],
          ),
        ),
      );

      expect(find.text('9'), findsOneWidget);
    });

    testWidgets('文字角标高度不撑满整行', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一', badgeText: '9'),
            ],
          ),
        ),
      );

      final badge = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).borderRadius ==
                BorderRadius.circular(100),
      );
      expect(badge, findsOneWidget);

      final badgeRect = tester.getRect(badge);
      final titleRect = tester.getRect(find.text('选项一'));
      // 角标是 14 高的小胶囊，不应被行高拉满
      expect(badgeRect.height, lessThanOrEqualTo(titleRect.height));
      expect(badgeRect.shortestSide, greaterThan(0));
    });
  });

  group('AntSideBar — 交互', () {
    testWidgets('点击切换触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _wrap(
            _sideBar(
              items: const [
                _SideData(key: 'a', title: '选项一'),
                _SideData(key: 'b', title: '选项二'),
              ],
              onChange: (key) => setState(() => changed = key.key),
            ),
          ),
        ),
      );

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(changed, 'b');
    });

    testWidgets('受控模式由外部控制', (tester) async {
      String activeKey = 'a';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _wrap(
            _sideBar(
              activeKey: activeKey,
              items: const [
                _SideData(key: 'a', title: '选项一'),
                _SideData(key: 'b', title: '选项二'),
              ],
              onChange: (key) => setState(() => activeKey = key.key),
            ),
          ),
        ),
      );

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(activeKey, 'b');
    });

    testWidgets('点击当前激活项不触发 onChange', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: const [
              _SideData(key: 'a', title: '选项一'),
              _SideData(key: 'b', title: '选项二'),
            ],
            onChange: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('禁用项不可点击', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: const [
              _SideData(key: 'a', title: '选项一'),
              _SideData(key: 'b', title: '选项二', disabled: true),
            ],
            onChange: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('禁用项文字使用 colorTextDisabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一'),
              const _SideData(key: 'b', title: '选项二', disabled: true),
            ],
          ),
        ),
      );

      // 禁用项颜色与激活项不同（非 colorPrimary）
      final textA = _effectiveStyle(tester, '选项一')!;
      final textB = _effectiveStyle(tester, '选项二')!;
      expect(textB.color, isNot(equals(textA.color)));
    });
  });

  group('AntSideBar — 布局', () {
    testWidgets('激活项高亮条有色，非激活项透明', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _sideBar(
            items: [
              const _SideData(key: 'a', title: '选项一'),
              const _SideData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      // 两项各有一个 AnimatedContainer 高亮条
      final highlights = find.byType(AnimatedContainer);
      expect(highlights, findsNWidgets(2));

      // 第一项激活 → 高亮条有色
      final decorationA = tester
          .widget<AnimatedContainer>(highlights.at(0))
          .decoration as BoxDecoration;
      expect(decorationA.color, isNot(Colors.transparent));

      // 第二项非激活 → 高亮条透明
      final decorationB = tester
          .widget<AnimatedContainer>(highlights.at(1))
          .decoration as BoxDecoration;
      expect(decorationB.color, Colors.transparent);
    });
  });
}
