import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapsuleData {
  const _CapsuleData({
    required this.key,
    this.title,
    this.titleWidget,
    this.disabled = false,
    this.child,
  });

  final String key;
  final String? title;
  final Widget? titleWidget;
  final bool disabled;
  final Widget? child;
}

Widget _capsuleTabs({
  Key? key,
  required List<_CapsuleData> items,
  Object? activeKey,
  Object? defaultActiveKey,
  ValueChanged<_CapsuleData>? onChange,
}) {
  return AntCapsuleTabs<_CapsuleData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    titleBuilder: (context, item, index) =>
        item.titleWidget ?? Text(item.title ?? item.key),
    childBuilder: (context, item, index) => item.child,
    disabledOf: (item) => item.disabled,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
  );
}

Widget _wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      );

/// 取出胶囊项背景装饰（圆角 20 的 Container）。
List<BoxDecoration> _capsuleDecorations(WidgetTester tester) => tester
    .widgetList<Container>(
      find.descendant(
        of: find.byType(AntCapsuleTabs<_CapsuleData>),
        matching: find.byType(Container),
      ),
    )
    .map((c) => c.decoration)
    .whereType<BoxDecoration>()
    .where((d) => d.borderRadius == BorderRadius.circular(20))
    .toList();

TextStyle? _effectiveStyle(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.text.style;
}

void main() {
  group('AntCapsuleTabs — 渲染', () {
    testWidgets('渲染所有项标题', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: [
              const _CapsuleData(key: 'a', title: '选项一'),
              const _CapsuleData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('渲染 titleWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: [
              const _CapsuleData(key: 'a', titleWidget: Text('自定义')),
            ],
          ),
        ),
      );

      expect(find.text('自定义'), findsOneWidget);
    });

    testWidgets('默认激活第一项：主色胶囊 + 白字 + 15 号字', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: [
              const _CapsuleData(key: 'a', title: '选项一'),
              const _CapsuleData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      final theme = AntThemeData.light();
      final textA = _effectiveStyle(tester, '选项一')!;
      final textB = _effectiveStyle(tester, '选项二')!;
      expect(textA.color, theme.colorTextLightSolid);
      expect(textA.fontSize, 15);
      expect(textB.color, theme.colorText);

      final decos = _capsuleDecorations(tester);
      expect(decos, hasLength(2));
      expect(decos[0].color, theme.colorPrimary);
      expect(decos[1].color, theme.colorFillContent);
    });

    testWidgets('defaultActiveKey 指定激活项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            defaultActiveKey: 'b',
            items: [
              const _CapsuleData(key: 'a', title: '选项一'),
              const _CapsuleData(key: 'b', title: '选项二'),
            ],
          ),
        ),
      );

      expect(
        _effectiveStyle(tester, '选项二')?.color,
        AntThemeData.light().colorTextLightSolid,
      );
    });

    testWidgets('激活项展示 child 内容（padding 12）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: [
              const _CapsuleData(key: 'a', title: '选项一', child: Text('内容一')),
              const _CapsuleData(key: 'b', title: '选项二', child: Text('内容二')),
            ],
          ),
        ),
      );

      expect(find.text('内容一'), findsOneWidget);
      expect(find.text('内容二'), findsNothing);

      final padding = tester.widget<Padding>(
        find
            .ancestor(
              of: find.text('内容一'),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(12));
    });

    testWidgets('胶囊标签均分宽度', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: [
              const _CapsuleData(key: 'a', title: '选项一'),
              const _CapsuleData(key: 'b', title: '选项二'),
              const _CapsuleData(key: 'c', title: '选项三'),
            ],
          ),
        ),
      );

      final widthA = tester.getSize(find.text('选项一')).width;
      final widthB = tester.getSize(find.text('选项二')).width;
      expect(widthA, widthB);
    });
  });

  group('AntCapsuleTabs — 溢出的横向滚动', () {
    const manyItems = [
      _CapsuleData(key: 'a', title: '选项一'),
      _CapsuleData(key: 'b', title: '选项二'),
      _CapsuleData(key: 'c', title: '选项三'),
      _CapsuleData(key: 'd', title: '选项四'),
    ];

    testWidgets('宽度不足时保持文字宽度并可横向滚动', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 200,
            child: _capsuleTabs(items: manyItems),
          ),
        ),
      );

      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.maxScrollExtent, greaterThan(0));
    });

    testWidgets('溢出时右侧渐隐遮罩显示，滚到末尾后切到左侧', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 200,
            child: _capsuleTabs(items: manyItems),
          ),
        ),
      );
      await tester.pump();

      List<double> masks() => tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((e) => e.opacity)
          .toList();

      // 初始：左侧无遮罩，右侧有
      expect(masks(), [0.0, 1.0]);

      await tester.drag(
        find.byType(AntCapsuleTabs<_CapsuleData>),
        const Offset(-400, 0),
      );
      await tester.pumpAndSettle();

      // 末尾：左侧有遮罩，右侧无
      expect(masks(), [1.0, 0.0]);
    });
  });

  group('AntCapsuleTabs — 交互', () {
    testWidgets('点击切换触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _wrap(
            _capsuleTabs(
              items: const [
                _CapsuleData(key: 'a', title: '选项一'),
                _CapsuleData(key: 'b', title: '选项二'),
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
            _capsuleTabs(
              activeKey: activeKey,
              items: const [
                _CapsuleData(key: 'a', title: '选项一'),
                _CapsuleData(key: 'b', title: '选项二'),
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
      var callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: const [
              _CapsuleData(key: 'a', title: '选项一'),
              _CapsuleData(key: 'b', title: '选项二'),
            ],
            onChange: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('禁用项不可点击且透明度 0.5', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _capsuleTabs(
            items: const [
              _CapsuleData(key: 'a', title: '选项一'),
              _CapsuleData(key: 'b', title: '选项二', disabled: true),
            ],
            onChange: (_) => callCount++,
          ),
        ),
      );

      final opacity = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.text('选项二'),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0.5);

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });
}
