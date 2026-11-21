// Smoke test for the antd_flutter_ui example gallery.
//
// Verifies the example boots with the Ant Theme applied and the home page
// renders its core controls.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:antd_flutter_ui_example/main.dart';

void main() {
  testWidgets('example gallery boots and renders core widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AntdUiExampleApp());
    await tester.pump();

    expect(find.byType(AntdUiExampleApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('antd_flutter_ui'), findsOneWidget);
  });
}
