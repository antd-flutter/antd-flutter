import 'package:antd_flutter_ui/src/display/empty/ant_empty.dart';
import 'package:antd_flutter_ui/src/display/list/ant_list.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Size size = const Size(400, 800)}) {
  return AntScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

AntList<String> _list({
  Widget? header,
  Widget? footer,
  bool bordered = false,
  bool split = true,
  AntListSize size = AntListSize.middle,
  List<String>? dataSource,
  int? pageSize,
  bool loading = false,
}) {
  return AntList<String>(
    header: header,
    footer: footer,
    bordered: bordered,
    split: split,
    size: size,
    pageSize: pageSize,
    loading: loading,
    dataSource: dataSource ?? const ['条目一', '条目二', '条目三'],
    itemKey: (item, index) => item,
    renderItem: (item, index) => AntListItem(content: Text(item)),
  );
}

void main() {
  group('AntList', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(height: 600, child: _list())));
      expect(find.text('条目一'), findsOneWidget);
      expect(find.text('条目二'), findsOneWidget);
      expect(find.text('条目三'), findsOneWidget);
    });

    testWidgets('renderItem builds custom item widgets', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: AntList<String>(
          dataSource: const ['a', 'b'],
          itemKey: (item, _) => item,
          renderItem: (item, index) =>
              AntListItem(content: Text('自定义-$item-$index')),
        ),
      ),),);
      expect(find.text('自定义-a-0'), findsOneWidget);
      expect(find.text('自定义-b-1'), findsOneWidget);
    });

    testWidgets('header and footer render', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(header: const Text('头部'), footer: const Text('底部')),
      ),),);
      expect(find.text('头部'), findsOneWidget);
      expect(find.text('底部'), findsOneWidget);
    });

    testWidgets('bordered adds outer border', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(bordered: true),
      ),),);
      final decorated = tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byType(AntList<String>),
              matching: find.byType(DecoratedBox),
            ).first,
          );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('split false removes dividers', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(split: false),
      ),),);
      final containers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AntList<String>),
              matching: find.byType(Container),
            ),
          )
          .where((c) => c.decoration is BoxDecoration)
          .toList();
      final withBorder = containers
          .where((c) => (c.decoration! as BoxDecoration).border != null)
          .length;
      expect(withBorder, 0);
    });

    testWidgets('size large uses larger font than small', (tester) async {
      await tester.pumpWidget(_wrap(Column(
        children: [
          SizedBox(height: 300, child: _list(size: AntListSize.large)),
          SizedBox(height: 300, child: _list(size: AntListSize.small)),
        ],
      ),),);
      final largeText = tester.widget<DefaultTextStyle>(
        find.ancestor(of: find.text('条目一').first, matching: find.byType(DefaultTextStyle)).first,
      );
      final smallText = tester.widget<DefaultTextStyle>(
        find.ancestor(of: find.text('条目一').last, matching: find.byType(DefaultTextStyle)).first,
      );
      expect(
        largeText.style.fontSize,
        greaterThan(smallText.style.fontSize ?? 0),
      );
    });

    testWidgets('actions render and are tappable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: AntList<String>(
          dataSource: const ['条目一'],
          itemKey: (item, _) => item,
          renderItem: (item, _) => AntListItem(
            content: Text(item),
            actions: [
              AntListAction(
                child: const Text('操作'),
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      ),),);
      expect(find.text('操作'), findsOneWidget);
      await tester.tap(find.text('操作'));
      expect(tapped, isTrue);
    });

    testWidgets('extra renders on the right', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: AntList<String>(
          dataSource: const ['条目一'],
          itemKey: (item, _) => item,
          renderItem: (item, _) => AntListItem(
            content: Text(item),
            extra: const Text('右侧'),
          ),
        ),
      ),),);
      expect(find.text('右侧'), findsOneWidget);
      final row = tester.widget<Row>(
        find.ancestor(of: find.text('条目一'), matching: find.byType(Row)).first,
      );
      expect(row.children.last, isA<Text>());
    });

    testWidgets('empty dataSource shows AntEmpty', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(dataSource: const []),
      ),),);
      expect(find.byType(AntEmpty), findsOneWidget);
      expect(find.text('条目一'), findsNothing);
    });

    testWidgets('loading shows spinner instead of items', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(loading: true),
      ),),);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('条目一'), findsNothing);
    });

    testWidgets('long list builds only visible items lazily',
        (tester) async {
      final dataSource =
          List<String>.generate(100, (i) => '长列表条目$i');
      await tester.pumpWidget(_wrap(SizedBox(
        height: 200,
        child: AntList<String>(
          dataSource: dataSource,
          itemKey: (item, _) => item,
          renderItem: (item, _) => AntListItem(content: Text(item)),
        ),
      ),),);
      await tester.pumpAndSettle();
      // 100 条只构建可见行
      final built = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(AntList<String>),
              matching: find.byType(Text),
            ),
          )
          .where((t) => t.data!.startsWith('长列表条目'))
          .length;
      expect(built, lessThan(100));
      expect(built, greaterThan(0));
    });

    testWidgets('pageSize paging switches pages', (tester) async {
      final dataSource =
          List<String>.generate(5, (i) => '分页条目${i + 1}');
      await tester.pumpWidget(_wrap(SizedBox(
        height: 600,
        child: _list(dataSource: dataSource, pageSize: 2),
      ),),);
      expect(find.text('分页条目1'), findsOneWidget);
      expect(find.text('分页条目2'), findsOneWidget);
      expect(find.text('分页条目3'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('list_page_2')));
      await tester.pumpAndSettle();
      expect(find.text('分页条目3'), findsOneWidget);
      expect(find.text('分页条目4'), findsOneWidget);
      expect(find.text('分页条目1'), findsNothing);
    });
  });
}
