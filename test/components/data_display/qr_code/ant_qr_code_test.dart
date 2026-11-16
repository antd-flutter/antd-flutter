import 'package:antd_flutter_plus/src/components/data_display/qr_code/ant_qr_code.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

void main() {
  group('AntQRCode', () {
    testWidgets('renders QR for value', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'hello')));
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('hello')), findsOneWidget);
    });

    testWidgets('value change rebuilds QR data', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'first')));
      expect(find.byKey(const ValueKey<String>('first')), findsOneWidget);

      await tester.pumpWidget(_wrap(const AntQRCode(value: 'second')));
      expect(find.byKey(const ValueKey<String>('second')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('first')), findsNothing);
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

    testWidgets('errorLevel L maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.l)),
      );
      expect(
        tester
            .widget<QrImageView>(find.byType(QrImageView))
            .errorCorrectionLevel,
        QrErrorCorrectLevel.L,
      );
    });

    testWidgets('errorLevel Q maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.q)),
      );
      expect(
        tester
            .widget<QrImageView>(find.byType(QrImageView))
            .errorCorrectionLevel,
        QrErrorCorrectLevel.Q,
      );
    });

    testWidgets('errorLevel H maps correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', errorLevel: AntQRCodeErrorLevel.h)),
      );
      expect(
        tester
            .widget<QrImageView>(find.byType(QrImageView))
            .errorCorrectionLevel,
        QrErrorCorrectLevel.H,
      );
    });

    testWidgets('custom color and bgColor apply', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntQRCode(value: 'a', color: Colors.red, bgColor: Colors.yellow)),
      );
      final qr = tester.widget<QrImageView>(find.byType(QrImageView));
      expect(qr.eyeStyle.color, Colors.red);
      expect(qr.backgroundColor, Colors.yellow);
    });

    testWidgets('default colors follow theme tokens', (tester) async {
      await tester.pumpWidget(_wrap(const AntQRCode(value: 'a')));
      final qr = tester.widget<QrImageView>(find.byType(QrImageView));
      final theme = AntThemeData.light();
      expect(qr.backgroundColor, theme.colorBgContainer);
      expect(qr.eyeStyle.color, theme.colorText);
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
  });
}
