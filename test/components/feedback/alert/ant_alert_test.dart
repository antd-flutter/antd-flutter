import 'package:antd_flutter_plus/src/components/feedback/alert/ant_alert.dart';
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

Container _alertContainer(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(
      of: find.text('提示'),
      matching: find.byType(Container),
    ).first,
  );
  return container;
}

void main() {
  group('AntAlert', () {
    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      expect(find.text('提示'), findsOneWidget);
    });

    testWidgets('success type uses success background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.success)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorSuccessBg),
      );
    });

    testWidgets('warning type uses warning background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.warning)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorWarningBg),
      );
    });

    testWidgets('error type uses error background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.error)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorErrorBg),
      );
    });

    testWidgets('info type uses info background', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorInfoBg),
      );
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', description: '这是描述内容')),
      );
      expect(find.text('提示'), findsOneWidget);
      expect(find.text('这是描述内容'), findsOneWidget);
    });

    testWidgets('showIcon true shows default icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', showIcon: true)),
      );
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('showIcon false hides icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      expect(find.byIcon(Icons.info), findsNothing);
    });

    testWidgets('closable shows close icon, tap closes and fires onClose',
        (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntAlert(
        message: '提示',
        closable: true,
        onClose: () => closed = true,
      ),),);
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.text('提示'), findsNothing);
    });

    testWidgets('action area renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        action: Text('撤销'),
      ),),);
      expect(find.text('撤销'), findsOneWidget);
    });

    testWidgets('banner has no border and rounded corners', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        banner: true,
      ),),);
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('提示'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
      expect(decoration.borderRadius, equals(BorderRadius.zero));
    });

    testWidgets('non-banner has left accent strip and light border',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.error)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.left.width, equals(border.right.width));
      // 左侧语义色竖条
      final accent = tester.widgetList<Container>(
        find.byType(Container),
      ).where((c) {
        final d = c.decoration;
        return d is BoxDecoration &&
            d.color == AntThemeData.light().colorError;
      });
      expect(accent, isNotEmpty);
    });

    testWidgets('custom icon overrides default icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        showIcon: true,
        icon: Icon(Icons.star),
      ),),);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.info), findsNothing);
    });
  });
}
