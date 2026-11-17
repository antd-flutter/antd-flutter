import 'package:antd_flutter_plus/src/components/data_display/empty/ant_empty.dart';
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

void main() {
  group('AntEmpty', () {
    testWidgets('renders default description', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty()));
      expect(find.text('暂无数据'), findsOneWidget);
    });

    testWidgets('renders custom description', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(description: '没有找到结果')));
      expect(find.text('没有找到结果'), findsOneWidget);
      expect(find.text('暂无数据'), findsNothing);
    });

    testWidgets('null description hides text', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(description: null)));
      expect(find.text('暂无数据'), findsNothing);
    });

    testWidgets('default image renders CustomPaint', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty()));
      // Empty 内部有 CustomPaint 插画
      expect(
        find.descendant(
          of: find.byType(AntEmpty),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('simple image renders inbox icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(image: AntEmptyImage.simple)));
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('custom imageWidget overrides preset', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(
        imageWidget: Icon(Icons.search_off),
      ),),);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      // Empty 内部不应有 CustomPaint（被 imageWidget 覆盖）
      expect(
        find.descendant(
          of: find.byType(AntEmpty),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets('child renders below description', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(
        child: Text('刷新'),
      ),),);
      expect(find.text('刷新'), findsOneWidget);
      expect(find.text('暂无数据'), findsOneWidget);
    });

    testWidgets('child renders with spacing', (tester) async {
      await tester.pumpWidget(_wrap(const AntEmpty(
        child: SizedBox(key: Key('extra'), width: 10, height: 10),
      ),),);
      expect(find.byKey(const Key('extra')), findsOneWidget);
    });
  });
}