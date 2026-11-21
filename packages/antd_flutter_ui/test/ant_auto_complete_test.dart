/// AntAutoComplete 双端字号与垂直居中回归
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Center(
            child: SizedBox(width: 300, child: child),
          ),
        ),
      ),
    ),
  );
}

Widget _autoComplete() => const AntAutoComplete<String>(
      defaultValue: 'Ruby',
      options: ['Ruby', 'Dart'],
      placeholder: '请输入',
    );

EditableText _editable(WidgetTester tester) {
  return tester.widget<EditableText>(
    find
        .descendant(
          of: find.byType(AntAutoComplete<String>),
          matching: find.byType(EditableText),
        )
        .first,
  );
}

void main() {
  testWidgets('desktop: text is vertically centered in the field', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    tester.view.physicalSize = const Size(1728, 972);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(_wrap(_autoComplete()));
    await tester.pumpAndSettle();

    final box = tester.getRect(find.byType(AntAutoComplete<String>));
    final ed = tester.getRect(
      find
          .descendant(
            of: find.byType(AntAutoComplete<String>),
            matching: find.byType(EditableText),
          )
          .first,
    );
    expect((ed.center.dy - box.center.dy).abs(), lessThanOrEqualTo(1.5));
  });

  testWidgets('desktop: font size follows antd (14)', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    tester.view.physicalSize = const Size(1728, 972);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(_wrap(_autoComplete()));
    await tester.pumpAndSettle();

    expect(_editable(tester).style.fontSize, 14);
  });

  testWidgets('mobile: font size follows antd-mobile (17, no width scaling)', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    tester.view.physicalSize = const Size(2007, 2853);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(_wrap(_autoComplete()));
    await tester.pumpAndSettle();

    // 669 逻辑宽下若仍用 .sp 会放大到约 25px
    expect(_editable(tester).style.fontSize, 17);
  });

  testWidgets('mobile: text is vertically centered in the field', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    tester.view.physicalSize = const Size(2007, 2853);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(_wrap(_autoComplete()));
    await tester.pumpAndSettle();

    final box = tester.getRect(find.byType(AntAutoComplete<String>));
    final ed = tester.getRect(
      find
          .descendant(
            of: find.byType(AntAutoComplete<String>),
            matching: find.byType(EditableText),
          )
          .first,
    );
    expect((ed.center.dy - box.center.dy).abs(), lessThanOrEqualTo(2.5));
  });
}
