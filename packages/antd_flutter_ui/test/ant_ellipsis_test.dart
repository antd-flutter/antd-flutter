import 'package:antd_flutter_ui/src/display/ellipsis/ant_ellipsis.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const String kLongText =
    'antd-mobile 是蚂蚁集团开源的移动端组件库，提供了大量高质量的移动端组件，'
    '包括基础组件、布局组件、数据展示组件、反馈组件、导航组件等等，'
    '支持 React、Vue、Angular 等多种框架，是国内使用最广泛的移动端组件库之一。';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(child: child),
          ),
        ),
      ),
    );
}

void main() {
  group('AntEllipsis', () {
    testWidgets('renders full text when short', (tester) async {
      await tester.pumpWidget(_wrap(const AntEllipsis(content: '短文本')));
      expect(find.text('短文本'), findsOneWidget);
    });

    testWidgets('short text shows no expand action', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: '短文本', expandText: '展开')),
      );
      expect(find.text('展开'), findsNothing);
    });

    testWidgets('truncates long text with rows', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: kLongText, rows: 1, expandText: '展开')),
      );
      expect(find.text(kLongText), findsNothing);
      expect(find.textContaining('...'), findsOneWidget);
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('direction end truncates tail', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
          direction: AntEllipsisDirection.end,
        ),),
      );
      final text = _truncatedPlainText(tester);
      expect(text.startsWith(_prefixOf(kLongText)), isTrue);
      expect(text.endsWith('...'), isTrue);
    });

    testWidgets('direction start truncates head', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
          direction: AntEllipsisDirection.start,
        ),),
      );
      final text = _truncatedPlainText(tester);
      expect(text.startsWith('...'), isTrue);
      expect(text.endsWith(kLongText.substring(kLongText.length - 2)),
          isTrue,);
    });

    testWidgets('direction middle truncates center', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
          direction: AntEllipsisDirection.middle,
        ),),
      );
      final text = _truncatedPlainText(tester);
      expect(text.contains('...'), isTrue);
      expect(text.startsWith(kLongText.substring(0, 2)), isTrue);
      expect(text.endsWith(kLongText.substring(kLongText.length - 2)),
          isTrue,);
    });

    testWidgets('truncated text and action render in one Text.rich '
        'inline structure', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
        ),),
      );
      final text = tester.widget<Text>(find.byType(Text).first);
      final span = text.textSpan!;
      expect(text.data, isNull, reason: '渲染主体应为 Text.rich');
      final children = (span as TextSpan).children!;
      expect(children, hasLength(1));
      expect(children.first, isA<WidgetSpan>(), reason: '动作应为内联 WidgetSpan');
      // 展开动作与截断文字同一行（动作 rect 与文本行垂直区间有交集）
      final actionRect = tester.getRect(find.text('展开'));
      final textRect = tester.getRect(find.textContaining('...'));
      expect(actionRect.top, lessThan(textRect.bottom));
      expect(actionRect.bottom, greaterThan(textRect.top));
      // 动作位于行末：右侧贴近容器右边（同一行而非换行后独占）
      expect(actionRect.right, greaterThan(textRect.right - 0.01));
    });

    testWidgets('truncation reserves action width: text + action fits '
        'in one line width', (tester) async {
      const actionText = '展开';
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: actionText,
        ),),
      );
      final actionRect = tester.getRect(find.text(actionText));
      final bodyRect = tester.getRect(find.textContaining('...'));
      final availableWidth = tester.getSize(find.byType(AntEllipsis)).width;
      // Text.rich 段落宽度 = 截断文字 + 内联动作，必须整行放下不换行
      expect(bodyRect.width, lessThan(availableWidth + 0.01));
      // 动作在行末且与正文同一行（顶部对齐、右缘贴近正文右缘）
      expect(actionRect.top, closeTo(bodyRect.top, 1.0));
      expect((bodyRect.right - actionRect.right).abs(), lessThan(1.0));
      // 预留生效：截断文字部分 ≈ 行宽 − 动作宽度（预留后占满预算但不超）
      final textOnlyWidth = bodyRect.width - actionRect.width;
      expect(textOnlyWidth,
          lessThanOrEqualTo(availableWidth - actionRect.width + 0.5),);
    });

    testWidgets('expanded state shows collapse action inline', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
          collapseText: '收起',
        ),),
      );
      await tester.tap(find.text('展开'));
      await tester.pump();
      final text = tester.widget<Text>(find.textContaining(kLongText));
      final span = text.textSpan!;
      expect((span as TextSpan).children!.first, isA<WidgetSpan>());
      final actionRect = tester.getRect(find.text('收起'));
      final textRect = tester.getRect(find.textContaining(kLongText));
      // 收起动作内联跟随全文末行（动作底缘不超过文本块底缘，非独立换行块）
      expect(actionRect.top, greaterThan(textRect.top));
      expect(actionRect.bottom, lessThanOrEqualTo(textRect.bottom + 1.0));
      expect(actionRect.left, greaterThan(textRect.left));
    });

    testWidgets('tap expandText expands full text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: kLongText, rows: 1, expandText: '展开')),
      );
      expect(find.text(kLongText), findsNothing);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(find.textContaining(kLongText), findsOneWidget);
      expect(find.text('展开'), findsNothing);
    });

    testWidgets('tap collapseText collapses back', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(
          content: kLongText,
          rows: 1,
          expandText: '展开',
          collapseText: '收起',
        ),),
      );
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(find.textContaining(kLongText), findsOneWidget);
      await tester.tap(find.text('收起'));
      await tester.pump();
      expect(find.textContaining(kLongText), findsNothing);
      expect(find.textContaining('...'), findsOneWidget);
    });

    testWidgets('no expandText means not expandable', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: kLongText, rows: 1)),
      );
      expect(find.textContaining('...'), findsOneWidget);
      // 点击文本不会展开全文
      await tester.tap(find.textContaining('...'));
      await tester.pump();
      expect(find.text(kLongText), findsNothing);
    });

    testWidgets('onContentClick fires on text tap', (tester) async {
      var clicked = false;
      await tester.pumpWidget(_wrap(AntEllipsis(
        content: kLongText,
        rows: 1,
        expandText: '展开',
        onContentClick: () => clicked = true,
      ),),);
      await tester.tap(find.textContaining('...'), warnIfMissed: false);
      await tester.pump();
      expect(clicked, isTrue);
    });

    testWidgets('multi-row long text truncates by rows', (tester) async {
      await tester.pumpWidget(
        _wrap(AntEllipsis(
          content: kLongText * 3,
          rows: 3,
          expandText: '展开',
        ),),
      );
      expect(find.text(kLongText * 3), findsNothing);
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('style passes through to text', (tester) async {
      await tester.pumpWidget(_wrap(const AntEllipsis(
        content: '样式透传',
        style: TextStyle(fontSize: 18, color: Colors.purple),
      ),),);
      final text = tester.widget<Text>(find.text('样式透传'));
      expect(text.style!.fontSize, 18);
      expect(text.style!.color, Colors.purple);
    });

    testWidgets('expanded text does not overflow rows', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: kLongText, rows: 2, expandText: '展开')),
      );
      await tester.tap(find.text('展开'));
      await tester.pump();
      final text = tester.widget<Text>(find.text(kLongText));
      expect(text.maxLines, isNull);
    });
  });
}

String _prefixOf(String source) => source.substring(0, 4);

/// 获取截断文本的纯文本内容（Text.rich 结构下走 textSpan，
/// 并去掉尾部 WidgetSpan 占位符 \uFFFC）。
String _truncatedPlainText(WidgetTester tester) {
  final text = tester.widget<Text>(find.textContaining('...'));
  return (text.data ?? text.textSpan!.toPlainText())
      .replaceAll('\uFFFC', '');
}
