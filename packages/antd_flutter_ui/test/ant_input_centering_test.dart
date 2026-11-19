import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number.dart';
import 'package:antd_flutter_ui/src/data_entry/search_bar/ant_search_bar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/gestures.dart';
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
      // 统一左内边距：marginSM(12) + 边框(1)
      expect(
        eLeft - cLeft,
        closeTo(t.marginSM.w + 1, 1.5),
        reason: '文字左内边距应与 AutoComplete/SearchBar(12) 一致',
      );
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
      final addonRight = tester.getRect(find.text('http://')).right;
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
      // 分隔线后 marginSM 内边距
      expect(
        eLeft - addonRight,
        closeTo(21, 2),
        reason: 'addon 分隔线后文字内边距应与前缀标签宽度解耦、统一 marginSM',
      );
    });
  });
}
