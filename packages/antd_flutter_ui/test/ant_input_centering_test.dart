import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input_number/ant_input_number.dart';
import 'package:antd_flutter_ui/src/data_entry/search_bar/ant_search_bar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(data: AntThemeData.light(), child: Material(child: child)),
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
  expect((eRect.center.dy - cRect.center.dy).abs(), lessThanOrEqualTo(1.5),
      reason: 'editable center ${eRect.center.dy} vs container center ${cRect.center.dy}');
}

void main() {
  group('AntInput — 垂直居中（回归）', () {
    testWidgets('standalone input centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(defaultValue: 'wenzi')));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInput));
    });

    testWidgets('addon mode centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInput(
        defaultValue: 'wenzi',
        addonBefore: Text('http://'),
        addonAfter: Text('.com'),
      )));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInput));
    });

    testWidgets('InputNumber centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntInputNumber(defaultValue: 12)));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntInputNumber));
    });

    testWidgets('SearchBar centers text', (tester) async {
      await tester.pumpWidget(_wrap(const AntSearchBar(defaultValue: 'sousuo')));
      await tester.pump();
      expectVerticallyCentered(tester, find.byType(AntSearchBar));
    });
  });
}
