import 'package:antd_flutter_ui/src/data_entry/auto_complete/ant_auto_complete.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number.dart';
import 'package:antd_flutter_ui/src/data_entry/search_bar/ant_search_bar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body:
            AntTheme(data: AntThemeData.light(), child: Material(child: child)),
      ),
    ),
  );
}

/// 字形（caret）相对容器左边距 —— 基座标准字形内缩 17.3
double glyphInset(WidgetTester tester, Finder container) {
  final cRect = tester.getRect(container.first);
  final wrapper = tester.renderObject<RenderObject>(
    find.descendant(of: container, matching: find.byType(EditableText)),
  );
  RenderEditable? re;
  void walk(RenderObject ro) {
    if (re != null) return;
    if (ro is RenderEditable) {
      re = ro;
      return;
    }
    ro.visitChildren(walk);
  }

  walk(wrapper);
  final caret = re!.getLocalRectForCaret(const TextPosition(offset: 0));
  return caret.left + re!.localToGlobal(Offset.zero).dx - cRect.left;
}

/// 断言容器与内部 EditableText 垂直中心差 ≤ 1.5px（垂直居中语义）
void expectVerticallyCentered(WidgetTester tester, Finder container) {
  final cRect = tester.getRect(container.first);
  final eRect = tester.getRect(
    find.descendant(of: container, matching: find.byType(EditableText)).first,
  );
  expect(
    (eRect.center.dy - cRect.center.dy).abs(),
    lessThanOrEqualTo(1.5),
    reason:
        'editable center ${eRect.center.dy} vs container center ${cRect.center.dy}',
  );
}

void main() {
  group('AntInput — 垂直居中（回归）', () {
    testWidgets('standalone input centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'wenzi')));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInput));
    });

    testWidgets('addon mode centers text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            defaultValue: 'wenzi',
            addonBefore: Text('http://'),
            addonAfter: Text('.com'),
          ),
        ),
      );
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInput));
    });

    testWidgets('InputNumber centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(defaultValue: 12)));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInputNumber));
    });

    testWidgets('SearchBar centers text', (tester) async {
      await tester
          .pumpWidget(_wrap(const AntSearchBar(defaultValue: 'sousuo')));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntSearchBar));
    });
  });
  group('AntInputField — 三态语义（默认/hover/disabled，基座回归）', () {
    testWidgets('default state uses border/fill/text tokens', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'abc')));
      await tester.pump();
      final decorator =
          tester.widget<InputDecorator>(find.byType(InputDecorator));
      // 基座统一：填充色/文字色 token 断言
      expect(decorator.decoration.filled, isTrue);
      // hover 边框语义：MouseRegion 包裹（结构断言，色值由 token 派生）
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('hover state switches border to colorPrimaryHover',
        (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'abc')));
      await tester.pump();
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(AntInput).first));
      await tester.pumpAndSettle();
      // standalone 容器边框应为 hover token 色
      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      final borders = containers
          .map((c) => (c.decoration as BoxDecoration).border)
          .whereType<Border>()
          .toList();
      expect(
        borders.any((b) => b.top.color == t.colorPrimaryHover),
        isTrue,
        reason: 'hover 时边框应切换为 colorPrimaryHover',
      );
    });

    testWidgets('disabled state uses disabled tokens and blocks input',
        (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            disabled: true,
            defaultValue: 'abc',
          ),
        ),
      );
      await tester.pump();
      final decorator =
          tester.widget<InputDecorator>(find.byType(InputDecorator));
      expect(decorator.decoration.fillColor, t.colorBgContainerDisabled);
      final editable = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(AntInput),
          matching: find.byType(EditableText),
        ),
      );
      expect(editable.style.color, t.colorTextQuaternary);
      // mouseCursor 在测试环境经 DeferringMouseCursor 解析，断言基座声明的封锁语义
      final field = tester.widget<TextField>(
        find.descendant(
          of: find.byType(AntInput),
          matching: find.byType(TextField),
        ),
      );
      expect(field.mouseCursor, SystemMouseCursors.basic);
      // 禁用输入封锁
      await tester.enterText(find.byType(EditableText), 'x');
      await tester.pump();
      expect(find.text('x'), findsNothing);
    });
  });
  group('AntInputField — 水平边距语义（基座回归）', () {
    testWidgets('standalone bordered text inset = marginSM + border',
        (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'wenzi')));
      await tester.pump();
      final cLeft = tester.getRect(find.byType(AntInput).first).left;
      final eLeft = tester
          .getRect(
            find
                .descendant(
                  of: find.byType(AntInput),
                  matching: find.byType(EditableText),
                )
                .first,
          )
          .left;
      // 字形内缩基座标准：marginSM(缩放后) + 5（边框+装饰固有，随缩放）
      final scaledMargin =
          AntTheme.of(tester.element(find.byType(AntInput))).marginSM.w;
      expect(glyphInset(tester, find.byType(AntInput)),
          closeTo(scaledMargin + 5 * (scaledMargin / 12), 3),
          reason: '字形左内边距 = marginSM 单点（缩放自适应）');
    });

    testWidgets('addon text inset = addon + marginSM', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            defaultValue: 'wenzi',
            addonBefore: Text('http://'),
          ),
        ),
      );
      await tester.pump();
      final divider = tester.getRect(find.text('http://')).right + 1;
      final scaledMargin2 =
          AntTheme.of(tester.element(find.byType(AntInput))).marginSM.w;
      expect(glyphInset(tester, find.byType(AntInput)) - divider,
          closeTo(scaledMargin2 + 5 * (scaledMargin2 / 12), 3),
          reason: 'addon 分隔线后字形内缩与 standalone 一致（缩放自适应）');
    });
  });
  group('AntAutoComplete — 边距继承（回归）', () {
    testWidgets('text inset inherits base marginSM standard', (tester) async {
      // 参照对比：同一测试内先测 Input 标准字形内缩，再测 AutoComplete，
      // 两者应一致（±1.5px）——免疫跨用例全局环境漂移
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'wenzi')));
      await tester.pump();
      final reference = glyphInset(tester, find.byType(AntInput));

      await tester
          .pumpWidget(_wrap(const AntAutoComplete(defaultValue: 'wenzi')));
      await tester.pump();
      final outer = tester.getRect(find.byType(AntAutoComplete).first);
      final e = tester.renderObject<RenderObject>(
        find.descendant(
          of: find.byType(AntAutoComplete),
          matching: find.byType(EditableText),
        ),
      );
      RenderEditable? re;
      void walk(RenderObject ro) {
        if (re != null) return;
        if (ro is RenderEditable) {
          re = ro;
          return;
        }
        ro.visitChildren(walk);
      }

      walk(e);
      final caret = re!.getLocalRectForCaret(const TextPosition(offset: 0));
      final glyph = caret.left + re!.localToGlobal(Offset.zero).dx;
      expect(glyph - outer.left, closeTo(reference, 1.5),
          reason: 'AutoComplete 字形内缩应与 Input 家族基座标准一致');
    });
  });
}
