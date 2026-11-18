import 'package:antd_qrcode/src/qr_code/ant_qr_code.dart';
import 'package:antd_qrcode/src/engines/qr/ant_qr_engine.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: Center(child: child)),
        ),
      ),
    ),
  );
}

BoxDecoration _rootDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AntQRCode),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

AntQrPainter _painter(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is AntQrPainter,
    ),
  );
  return paint.painter! as AntQrPainter;
}

void main() {
  group('AntQRCode', () {
    testWidgets('renders QR via CustomPaint for value', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'hello')));
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.key == const ValueKey<String>('hello'),
        ),
        findsOneWidget,
      );
      expect(_painter(tester).value, 'hello');
      expect(_painter(tester), isA<AntQrPainter>());
    });

    testWidgets('value change rebuilds QR data', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'first')));
      expect(find.byKey(const ValueKey<String>('first')), findsOneWidget);

      await tester.pumpWidget(_wrap(const AntQRCode(value: 'second')));
      expect(find.byKey(const ValueKey<String>('second')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('first')), findsNothing);
      expect(_painter(tester).value, 'second');
    });

    testWidgets('custom size applies', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a', size: 200)));
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AntQRCode),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.constraints?.maxWidth, closeTo(200.w, 0.1));
    });

    testWidgets('painter sizes QR canvas to size', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a', size: 200)));
      expect(_painter(tester).matrix.moduleCount, greaterThan(0));
    });

    testWidgets('errorLevel L maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.l)),
      );
      expect(
        _painter(tester).matrix.errorCorrectLevel,
        AntQrErrorCorrectLevel.l,
      );
    });

    testWidgets('errorLevel Q maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.q)),
      );
      expect(
        _painter(tester).matrix.errorCorrectLevel,
        AntQrErrorCorrectLevel.q,
      );
    });

    testWidgets('errorLevel H maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.h)),
      );
      expect(
        _painter(tester).matrix.errorCorrectLevel,
        AntQrErrorCorrectLevel.h,
      );
    });

    testWidgets('custom color and bgColor apply', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', color: Colors.red, bgColor: Colors.yellow)),
      );
      final painter = _painter(tester);
      expect(painter.moduleColor, Colors.red);
      expect(painter.emptyColor, Colors.yellow);
    });

    testWidgets('default colors follow theme tokens', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a')));
      final painter = _painter(tester);
      final theme = AntThemeData.light();
      expect(painter.emptyColor, theme.colorBgContainer);
      expect(painter.moduleColor, theme.colorText);
    });

    testWidgets('bordered false removes border', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a', bordered: false)));
      expect(_rootDecoration(tester).border, isNull);
    });

    testWidgets('default bordered shows border', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a')));
      expect(_rootDecoration(tester).border, isNotNull);
    });

    testWidgets('expired status shows overlay and tap refreshes',
        (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(_wrap(AntQRCode(
        value: 'a',
        status: AntQRCodeStatus.expired,
        onRefresh: () => refreshed++,
      ),),);
      expect(find.text('二维码过期'), findsOneWidget);

      await tester.tap(find.text('二维码过期'));
      expect(refreshed, 1);
    });

    testWidgets('expired without onRefresh shows overlay without tap handler',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', status: AntQRCodeStatus.expired)),
      );
      expect(find.text('二维码过期'), findsOneWidget);
    });

    testWidgets('scanned status shows scanned overlay', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', status: AntQRCodeStatus.scanned)),
      );
      expect(find.text('已扫描'), findsOneWidget);
    });

    testWidgets('icon mode shows center icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', icon: true, iconSize: 50)),
      );
      expect(find.byIcon(Icons.qr_code_2), findsOneWidget);
    });

    testWidgets('icon hidden in non-active status', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(
          value: 'a',
          icon: true,
          status: AntQRCodeStatus.expired,
        ),),
      );
      expect(find.byIcon(Icons.qr_code_2), findsNothing);
      expect(find.text('二维码过期'), findsOneWidget);
    });

    testWidgets('painter repaints on value change', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a')));
      final first = _painter(tester);
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'b')));
      final second = _painter(tester);
      expect(first.shouldRepaint(second), isTrue);
      expect(second.shouldRepaint(second), isFalse);
    });
  });
}
