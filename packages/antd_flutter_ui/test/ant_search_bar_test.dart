/// AntSearchBar widget tests
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  group('AntSearchBar', () {
    testWidgets('renders with placeholder', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(placeholder: '搜索商品'),
      ),);
      expect(find.text('搜索商品'), findsOneWidget);
      expect(find.byIcon(AntIcons.searchOutlined), findsOneWidget);
    });

    testWidgets('defaultValue displays in input', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(defaultValue: '初始值'),
      ),);
      expect(find.text('初始值'), findsOneWidget);
    });

    testWidgets('controlled value displays', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(value: '受控值'),
      ),);
      expect(find.text('受控值'), findsOneWidget);
    });

    testWidgets('onChange fires on input', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(
        AntSearchBar(onChange: (v) => changed = v),
      ),);
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();
      expect(changed, 'abc');
    });

    testWidgets('onSearch fires on submit', (tester) async {
      String? searched;
      await tester.pumpWidget(_wrap(
        AntSearchBar(onSearch: (v) => searched = v),
      ),);
      await tester.enterText(find.byType(TextField), 'keyword');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(searched, 'keyword');
    });

    testWidgets('clear button appears when text exists', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(defaultValue: 'hello'),
      ),);
      expect(find.byIcon(AntIcons.closeCircleFilled), findsOneWidget);
    });

    testWidgets('clear button hidden when no text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(),
      ),);
      expect(find.byIcon(AntIcons.closeCircleFilled), findsNothing);
    });

    testWidgets('clearable=false hides clear button', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(defaultValue: 'hello', clearable: false),
      ),);
      expect(find.byIcon(AntIcons.closeCircleFilled), findsNothing);
    });

    testWidgets('onlyShowClearWhenFocus shows clear on focus only',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(
          defaultValue: 'hello',
          onlyShowClearWhenFocus: true,
        ),
      ),);
      // Not focused initially — no clear icon
      expect(find.byIcon(AntIcons.closeCircleFilled), findsNothing);

      // Focus the input
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.closeCircleFilled), findsOneWidget);
    });

    testWidgets('clear button clears text and calls onClear',
        (tester) async {
      bool cleared = false;
      String? changed;
      await tester.pumpWidget(_wrap(
        AntSearchBar(
          defaultValue: 'hello',
          onClear: () => cleared = true,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(cleared, isTrue);
      expect(changed, '');
      expect(find.text('hello'), findsNothing);
    });

    testWidgets('cancel button hidden by default (never mode)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(),
      ),);
      expect(find.text('取消'), findsNothing);
    });

    testWidgets('cancel button shows on focus (focus mode)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(
          showCancelButton: AntSearchBarCancelMode.focus,
        ),
      ),);
      expect(find.text('取消'), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('cancel button always shows (always mode)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(
          showCancelButton: AntSearchBarCancelMode.always,
        ),
      ),);
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('custom cancelText displays', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(
          showCancelButton: AntSearchBarCancelMode.always,
          cancelText: 'Close',
        ),
      ),);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('cancel button calls onCancel', (tester) async {
      bool cancelled = false;
      await tester.pumpWidget(_wrap(
        AntSearchBar(
          showCancelButton: AntSearchBarCancelMode.always,
          onCancel: () => cancelled = true,
        ),
      ),);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(cancelled, isTrue);
    });

    testWidgets('cancel clears text when clearOnCancel=true',
        (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(
        AntSearchBar(
          defaultValue: 'hello',
          showCancelButton: AntSearchBarCancelMode.always,
          clearOnCancel: true,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(changed, '');
      expect(find.text('hello'), findsNothing);
    });

    testWidgets('cancel does not clear when clearOnCancel=false',
        (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(
        AntSearchBar(
          defaultValue: 'hello',
          showCancelButton: AntSearchBarCancelMode.always,
          clearOnCancel: false,
          onChange: (v) => changed = v,
        ),
      ),);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('onFocus and onBlur fire', (tester) async {
      bool focused = false;
      bool blurred = false;
      await tester.pumpWidget(_wrap(
        AntSearchBar(
          onFocus: () => focused = true,
          onBlur: () => blurred = true,
        ),
      ),);
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(focused, isTrue);

      // Tap elsewhere to blur
      await tester.tapAt(const Offset(500, 500));
      await tester.pumpAndSettle();
      expect(blurred, isTrue);
    });

    testWidgets('maxLength limits input', (tester) async {
      await tester.pumpWidget(_wrap(
        AntSearchBar(maxLength: 3, onChange: (v) {}),
      ),);
      await tester.enterText(find.byType(TextField), 'abcdef');
      await tester.pumpAndSettle();
      // TextField maxLength truncates to 3 chars
      expect(find.text('abc'), findsOneWidget);
    });

    testWidgets('custom searchIcon displays', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntSearchBar(searchIcon: Icon(AntIcons.userOutlined)),
      ),);
      expect(find.byIcon(AntIcons.userOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.searchOutlined), findsNothing);
    });
  });
}