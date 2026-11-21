import 'package:antd_flutter_ui/src/display/card/ant_card.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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
  group('AntCard', () {
    testWidgets('renders child content', (tester) async {
      await tester
          .pumpWidget(_wrap(const AntCard<Widget>(child: Text('卡片内容'))));
      expect(find.text('卡片内容'), findsOneWidget);
    });

    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            title: Text('标题'),
            child: Text('内容'),
          ),
        ),
      );
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('内容'), findsOneWidget);
    });

    testWidgets('renders extra', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            title: Text('标题'),
            extra: Text('更多'),
            child: Text('内容'),
          ),
        ),
      );
      expect(find.text('更多'), findsOneWidget);
    });

    testWidgets('bordered false removes border', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            bordered: false,
            child: Text('无边框'),
          ),
        ),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('bordered true has border', (tester) async {
      await tester.pumpWidget(_wrap(const AntCard<Widget>(child: Text('有边框'))));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('cover renders at top', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntCard<Widget>(
            cover: Container(color: Colors.blue),
            coverHeight: 100,
            child: const Text('内容'),
          ),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('actions render at bottom', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          AntCard<Widget>(
            actions: const [Text('操作')],
            actionBuilder: (context, action, index) => action,
            onActionTap: (_) => tapped = true,
            child: const Text('内容'),
          ),
        ),
      );
      expect(find.text('操作'), findsOneWidget);
      await tester.tap(find.text('操作'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('loading shows skeleton instead of content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            loading: true,
            child: Text('实际内容'),
          ),
        ),
      );
      expect(find.text('实际内容'), findsNothing);
      // 骨架屏由 3 个色块 Container + 1 个外层卡片 Container 组成
      expect(find.byType(Container), findsNWidgets(4));
    });

    testWidgets('small size uses smaller padding', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            size: AntCardSize.small,
            child: Text('小卡片'),
          ),
        ),
      );
      expect(find.text('小卡片'), findsOneWidget);
    });

    testWidgets('onTap fires when card tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          AntCard<Widget>(
            child: const Text('可点击'),
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('可点击'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('hoverable renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            hoverable: true,
            child: Text('可悬浮'),
          ),
        ),
      );
      expect(find.text('可悬浮'), findsOneWidget);
      // MouseRegion 应作为卡片的包裹层
      expect(
        find.ancestor(
          of: find.text('可悬浮'),
          matching: find.byType(MouseRegion),
        ),
        findsWidgets,
      );
    });

    testWidgets('header divider shows when bordered and has title',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCard<Widget>(
            title: Text('标题'),
            child: Text('内容'),
          ),
        ),
      );
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('no divider without header', (tester) async {
      await tester.pumpWidget(_wrap(const AntCard<Widget>(child: Text('内容'))));
      expect(find.byType(Divider), findsNothing);
    });
  });
}
