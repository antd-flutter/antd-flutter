/// AntTypography Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
      ),
    ),
  );
}

void main() {
  group('AntTitle', () {
    testWidgets('renders text content', (tester) async {
      await tester.pumpWidget(_wrap(const AntTitle('Hello Title')));
      expect(find.text('Hello Title'), findsOneWidget);
    });

    testWidgets('h1 level has largest font size', (tester) async {
      await tester.pumpWidget(_wrap(const AntTitle('H1', level: AntTitleLevel.h1)));
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.fontSize, greaterThan(30));
    });

    testWidgets('h5 level has smaller font size than h1', (tester) async {
      await tester.pumpWidget(_wrap(const AntTitle('H5', level: AntTitleLevel.h5)));
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final h5Size = textWidget.style?.fontSize;
      expect(h5Size, lessThan(20));
    });

    testWidgets('default heading color used', (tester) async {
      await tester.pumpWidget(_wrap(const AntTitle('Heading')));
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorTextHeading);
    });

    testWidgets('type=danger overrides heading color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntTitle('Danger', type: AntTypographyType.danger)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorErrorText);
    });

    testWidgets('title is bold by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntTitle('Bold')));
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });
  });

  group('AntText', () {
    testWidgets('renders text content', (tester) async {
      await tester.pumpWidget(_wrap(const AntText(text: 'Hello Text')));
      expect(find.text('Hello Text'), findsOneWidget);
    });

    testWidgets('type=secondary uses secondary color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Secondary', type: AntTypographyType.secondary)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorTextSecondary);
    });

    testWidgets('type=success uses success color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Success', type: AntTypographyType.success)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorSuccessText);
    });

    testWidgets('type=warning uses warning color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Warning', type: AntTypographyType.warning)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorWarningText);
    });

    testWidgets('type=danger uses error color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Danger', type: AntTypographyType.danger)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorErrorText);
    });

    testWidgets('disabled uses disabled color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Disabled', disabled: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorTextDisabled);
    });

    testWidgets('strong applies bold weight', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Bold', strong: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('italic applies italic style', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Italic', italic: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.fontStyle, FontStyle.italic);
    });

    testWidgets('underline applies underline decoration', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Underlined', underline: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.decoration, TextDecoration.underline);
    });

    testWidgets('delete applies line-through decoration', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Deleted', delete: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(
        textWidget.style?.decoration?.contains(TextDecoration.lineThrough),
        true,
      );
    });

    testWidgets('code wraps in container with border', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'code()', code: true)),
      );
      expect(find.text('code()'), findsOneWidget);
      // Container with BoxDecoration should exist
      final container = tester.widgetList<Container>(find.byType(Container));
      expect(container, isNotEmpty);
    });

    testWidgets('mark wraps in container with background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Marked', mark: true)),
      );
      expect(find.text('Marked'), findsOneWidget);
      final container = tester.widgetList<Container>(find.byType(Container));
      expect(container, isNotEmpty);
    });

    testWidgets('keyboard uses smaller font', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Ctrl', keyboard: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.fontSize, lessThan(theme.fontSize));
    });
  });

  group('AntParagraph', () {
    testWidgets('renders paragraph text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntParagraph(text: 'This is a paragraph.')),
      );
      expect(find.text('This is a paragraph.'), findsOneWidget);
    });

    testWidgets('paragraph has bottom margin', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntParagraph(text: 'Content')),
      );
      // Padding widget should exist for margin
      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('AntLink', () {
    testWidgets('renders link text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLink(text: 'Click me')),
      );
      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('link uses colorLink', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLink(text: 'Link')),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorLink);
    });

    testWidgets('link has underline by default', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLink(text: 'Link')),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.style?.decoration, TextDecoration.underline);
    });

    testWidgets('disabled link uses disabled color', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntLink(text: 'Disabled', disabled: true)),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      final theme = AntThemeData.light();
      expect(textWidget.style?.color, theme.colorTextDisabled);
    });

    testWidgets('onTap fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AntLink(text: 'Tap', onTap: () => tapped = true)),
      );
      await tester.tap(find.text('Tap'));
      expect(tapped, true);
    });
  });

  group('AntTypography copyable', () {
    testWidgets('shows copy icon when copyable', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Copy me', copyable: true)),
      );
      expect(find.byIcon(AntIcons.copyOutlined), findsOneWidget);
    });

    testWidgets('copy writes to clipboard', (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') return null;
        return null;
      });

      await tester.pumpWidget(
        _wrap(const AntText(text: 'Copy this', copyable: true)),
      );
      await tester.tap(find.byIcon(AntIcons.copyOutlined));
      await tester.pumpAndSettle();

      // After copy, icon should change to check
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);

      // Wait for the 2-second reset timer to fire (avoids pending timer)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });

  group('AntTypography editable', () {
    testWidgets('shows edit icon when editable', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Edit me', editable: true)),
      );
      expect(find.byIcon(AntIcons.editOutlined), findsOneWidget);
    });

    testWidgets('tapping edit icon shows TextField', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Edit me', editable: true)),
      );
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byIcon(AntIcons.editOutlined));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('commit edit calls onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(AntText(
          text: 'Original',
          editConfig: AntEditConfig(onChange: (v) => changed = v),
        ),),
      );

      await tester.tap(find.byIcon(AntIcons.editOutlined));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Modified');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changed, 'Modified');
    });
  });

  group('AntTypography ellipsis', () {
    testWidgets('ellipsis applies maxLines', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(
          text: 'A very long text that should be truncated',
          ellipsis: AntEllipsisConfig(rows: 1),
        ),),
      );
      final textWidget = tester.widget<Text>(find.byType(Text).first);
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('expandable shows expand button', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntParagraph(
          text: 'Long paragraph content here',
          ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        ),),
      );
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('tapping expand toggles to collapse', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntParagraph(
          text: 'Long paragraph content here',
          ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        ),),
      );

      await tester.tap(find.text('展开'));
      await tester.pump();

      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('onExpand callback fires', (tester) async {
      bool? expanded;
      await tester.pumpWidget(
        _wrap(AntParagraph(
          text: 'Content',
          ellipsis: AntEllipsisConfig(
            rows: 1,
            expandable: true,
            onExpand: (v) => expanded = v,
          ),
        ),),
      );

      await tester.tap(find.text('展开'));
      await tester.pump();

      expect(expanded, true);
    });
  });

  group('AntTypography onTap', () {
    testWidgets('onTap fires on text tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AntText(text: 'Clickable', onTap: () => tapped = true)),
      );
      await tester.tap(find.text('Clickable'));
      expect(tapped, true);
    });

    testWidgets('disabled does not fire onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AntText(text: 'No click', disabled: true, onTap: () => tapped = true)),
      );
      await tester.tap(find.text('No click'));
      expect(tapped, false);
    });
  });
}