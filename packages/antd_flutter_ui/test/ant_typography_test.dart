/// AntTypography Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
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

/// 窄容器（强制触发省略溢出，用于展开/收起相关用例）。
Widget _narrow(Widget child, {double width = 150}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(width: width, child: child),
  );
}


/// 在 span 树中定位直接持有 WidgetSpan 的业务 span。
TextSpan? _findHostSpan(TextSpan span) {
  if (span.children == null) return null;
  if (span.children!.any((c) => c is WidgetSpan)) return span;
  for (final child in span.children!.whereType<TextSpan>()) {
    final found = _findHostSpan(child);
    if (found != null) return found;
  }
  return null;
}

/// 找到包含 [match] 文本且带内联 WidgetSpan 图标的业务 TextSpan。
TextSpan _hostSpan(WidgetTester tester, String match) {
  final hosts = tester
      .widgetList<RichText>(find.byType(RichText))
      .map((r) => _findHostSpan(r.text as TextSpan))
      .whereType<TextSpan>()
      .where((s) => s.toPlainText().contains(match))
      .toList();
  expect(hosts, hasLength(1));
  return hosts.first;
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

    testWidgets('copy icon is inline WidgetSpan in the same Text.rich',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(text: 'Copy me', copyable: true)),
      );
      // 主文本与复制图标同处一个 RichText（WidgetSpan 内联）
      final span = _hostSpan(tester, 'Copy me');
      expect(span.toPlainText(), contains('Copy me'));
      expect(span.children!.whereType<WidgetSpan>(), hasLength(1));
      expect(
        find.descendant(
          of: find.byType(RichText),
          matching: find.byIcon(AntIcons.copyOutlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('copyConfig.position=before puts icon before text',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(
          text: 'Copy me',
          copyConfig: AntCopyConfig(position: AntCopyIconPosition.before),
        ),),
      );
      final span = _hostSpan(tester, 'Copy me');
      // 第一个 WidgetSpan（复制图标）应排在文本 TextSpan 之前
      final children = span.children!;
      expect(children.first, isA<WidgetSpan>());
      expect(children.last, isA<TextSpan>());
    });

    testWidgets('copyConfig.tooltip=false hides tooltip', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntText(
          text: 'Copy me',
          copyConfig: AntCopyConfig(tooltip: false),
        ),),
      );
      expect(find.byType(AntTooltip), findsNothing);
    });

    testWidgets('copy and expand actions show together when overflowing',
        (tester) async {
      await tester.pumpWidget(_wrap(_narrow(const AntParagraph(
        text: 'A fairly long content line that overflows the narrow container',
        ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        copyable: true,
      ),),),);
      expect(find.text('展开'), findsOneWidget);
      expect(find.byIcon(AntIcons.copyOutlined), findsOneWidget);
      // 同一 Text.rich 内含文本 + 展开 + 复制共 2 个 WidgetSpan
      final span = _hostSpan(tester, '');
      // 截断文本保留前缀且与展开/复制图标同处一个 span
      expect(span.toPlainText(), startsWith('A'));
      expect(span.children!.whereType<WidgetSpan>(), hasLength(2));
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

    testWidgets('edit state renders input box + enter icon below, commit works',
        (tester) async {
      String? changed;
      await tester.pumpWidget(
        _wrap(AntText(
          text: 'Original',
          editConfig: AntEditConfig(onChange: (v) => changed = v),
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.editOutlined));
      await tester.pump();

      // 编辑态：输入框 + 下方回车（keyboard return）图标
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(AntIcons.enterOutlined), findsOneWidget);
      // 回车图标位于输入框下方（垂直对齐：左边缘不超出输入框）
      final inputRect = tester.getRect(find.byType(TextField));
      final enterRect = tester.getRect(find.byIcon(AntIcons.enterOutlined));
      expect(enterRect.top, greaterThan(inputRect.top));
      expect(enterRect.left, greaterThanOrEqualTo(inputRect.left - 0.5));

      // 点击回车图标确认提交
      await tester.enterText(find.byType(TextField), 'Modified');
      await tester.tap(find.byIcon(AntIcons.enterOutlined));
      await tester.pump();
      expect(changed, 'Modified');
    });

    testWidgets('esc key cancels edit without onChange', (tester) async {
      String? changed;
      var cancelled = false;
      await tester.pumpWidget(
        _wrap(AntText(
          text: 'Original',
          editConfig: AntEditConfig(
            onChange: (v) => changed = v,
            onCancel: () => cancelled = true,
          ),
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.editOutlined));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Draft');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(cancelled, true);
      expect(changed, isNull);
      expect(find.byType(TextField), findsNothing);
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
        _wrap(_narrow(const AntParagraph(
          text: 'Long paragraph content here',
          ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        ),),),
      );
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('no expand button when text does not overflow',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntParagraph(
          text: 'Short',
          ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        ),),
      );
      expect(find.text('展开'), findsNothing);
    });

    testWidgets('overflow re-measured on width change', (tester) async {
      // 初始窄容器：溢出 → 显示展开按钮
      await tester.pumpWidget(
        _wrap(_narrow(
          const AntParagraph(
            text: 'Long paragraph content here',
            ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
          ),
          width: 120,
        ),),
      );
      expect(find.text('展开'), findsOneWidget);

      // 容器变宽：不再溢出 → 展开按钮消失
      await tester.pumpWidget(
        _wrap(_narrow(
          const AntParagraph(
            text: 'Long paragraph content here',
            ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
          ),
          width: 800,
        ),),
      );
      expect(find.text('展开'), findsNothing);
    });

    testWidgets('tapping expand toggles to collapse', (tester) async {
      await tester.pumpWidget(
        _wrap(_narrow(const AntParagraph(
          text: 'Long paragraph content here',
          ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
        ),),),
      );

      await tester.tap(find.text('展开'));
      await tester.pump();

      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('onExpand callback fires', (tester) async {
      bool? expanded;
      await tester.pumpWidget(
        _wrap(_narrow(AntParagraph(
          text: 'A fairly long content line that overflows the narrow container',
          ellipsis: AntEllipsisConfig(
            rows: 1,
            expandable: true,
            onExpand: (v) => expanded = v,
          ),
        ),),),
      );

      await tester.tap(find.text('展开'));
      await tester.pump();

      expect(expanded, true);
    });

    testWidgets('expand icon is inline with text (same RichText WidgetSpan)',
        (tester) async {
      await tester.pumpWidget(_wrap(_narrow(const AntParagraph(
        text: 'A long paragraph that will be truncated at the end of line',
        ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
      ),),),);

      // 文字与展开图标应位于同一 Text.rich（RichText）的 WidgetSpan 中，
      // 而不是作为独立兄弟节点排在下一行。
      final span = _hostSpan(tester, 'A lo');
      expect(span.toPlainText(), contains('A lon'));
      final widgetSpans =
          span.children!.whereType<WidgetSpan>().toList();
      expect(widgetSpans, hasLength(1));
      // WidgetSpan 子树包含展开按钮文本
      expect(
        find.descendant(
          of: find.byWidget(widgetSpans.first.child),
          matching: find.text('展开'),
        ),
        findsOneWidget,
      );
      // 展开按钮不是 Row/Wrap 中的独立兄弟（无以“展开”为直接文本的第二个节点行）
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('collapse icon also inline after expanding', (tester) async {
      await tester.pumpWidget(_wrap(_narrow(const AntParagraph(
        text: 'A fairly long content line that overflows the narrow container',
        ellipsis: AntEllipsisConfig(rows: 1, expandable: true),
      ),),),);
      await tester.tap(find.text('展开'));
      await tester.pump();

      final span = _hostSpan(tester, 'A fairly');
      expect(span.toPlainText(), contains('A fairly'));
      expect(span.children!.whereType<WidgetSpan>(), hasLength(1));
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