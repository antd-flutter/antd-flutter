import 'package:antd_flutter_plus/src/components/data_display/ellipsis/ant_ellipsis.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const String kLongText =
    'antd-mobile 是蚂蚁集团开源的移动端组件库，提供了大量高质量的移动端组件，'
    '包括基础组件、布局组件、数据展示组件、反馈组件、导航组件等等，'
    '支持 React、Vue、Angular 等多种框架，是国内使用最广泛的移动端组件库之一。';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(child: child),
          ),
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
      final text = tester.widget<Text>(find.textContaining('...')).data!;
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
      final text = tester.widget<Text>(find.textContaining('...')).data!;
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
      final text = tester.widget<Text>(find.textContaining('...')).data!;
      expect(text.contains('...'), isTrue);
      expect(text.startsWith(kLongText.substring(0, 2)), isTrue);
      expect(text.endsWith(kLongText.substring(kLongText.length - 2)),
          isTrue,);
    });

    testWidgets('tap expandText expands full text', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntEllipsis(content: kLongText, rows: 1, expandText: '展开')),
      );
      expect(find.text(kLongText), findsNothing);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(find.text(kLongText), findsOneWidget);
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
      expect(find.text(kLongText), findsOneWidget);
      await tester.tap(find.text('收起'));
      await tester.pump();
      expect(find.text(kLongText), findsNothing);
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
