import 'package:antd_flutter_plus/src/components/feedback/skeleton/ant_skeleton.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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

void main() {
  group('AntSkeleton', () {
    testWidgets('loading=true renders skeleton elements', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        avatar: AntSkeletonAvatar(),
        title: AntSkeletonTitle(),
        paragraph: AntSkeletonParagraph(),
      ),),);
      // 骨架占位是 Container，无文本内容
      expect(find.text('内容'), findsNothing);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('loading=false renders child', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: false,
        child: Text('实际内容'),
      ),),);
      expect(find.text('实际内容'), findsOneWidget);
    });

    testWidgets('avatar shown when configured', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        avatar: AntSkeletonAvatar(),
      ),),);
      // 圆形头像：存在 circle 形状 Container
      final circles = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).shape == BoxShape.circle,)
          .length;
      expect(circles, 1);
    });

    testWidgets('avatar hidden by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(loading: true)));
      final circles = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).shape == BoxShape.circle,)
          .length;
      expect(circles, 0);
    });

    testWidgets('title hidden when show=false', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        title: AntSkeletonTitle(show: false),
        paragraph: AntSkeletonParagraph(),
      ),),);
      // 仅剩段落条，无 16 高度的标题条
      final bars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => (c.constraints?.maxHeight ?? 0) == 16)
          .length;
      expect(bars, 0);
    });

    testWidgets('paragraph hidden when show=false', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        paragraph: AntSkeletonParagraph(show: false),
      ),),);
      // 仅剩标题条（高度 16），无段落条（高度 14）
      final bars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => (c.constraints?.maxHeight ?? 0) == 14)
          .length;
      expect(bars, 0);
    });

    testWidgets('paragraph rows controls bar count', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        paragraph: AntSkeletonParagraph(rows: 4),
      ),),);
      final bars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => (c.constraints?.maxHeight ?? 0) == 14)
          .length;
      expect(bars, 4);
    });

    testWidgets('default paragraph rows is 3', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(loading: true)));
      final bars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => (c.constraints?.maxHeight ?? 0) == 14)
          .length;
      expect(bars, 3);
    });

    testWidgets('active renders pulse animation container', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        active: true,
      ),),);
      await tester.pump();
      expect(
        find.byWidgetPredicate((w) => w is AnimatedBuilder),
        findsWidgets,
      );
    });

    testWidgets('active=false has no animation container', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        active: false,
      ),),);
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(AntSkeleton),
          matching: find.byWidgetPredicate((w) => w is AnimatedBuilder),
        ),
        findsNothing,
      );
    });

    testWidgets('custom children replaces default skeleton', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        children: [
          SizedBox(width: 100, height: 20, key: Key('custom-bar')),
        ],
      ),),);
      expect(find.byKey(const Key('custom-bar')), findsOneWidget);
      // 默认标题/段落条不存在
      final bars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => (c.constraints?.maxHeight ?? 0) == 14)
          .length;
      expect(bars, 0);
    });

    testWidgets('full combo default renders all elements', (tester) async {
      await tester.pumpWidget(_wrap(const AntSkeleton(
        loading: true,
        avatar: AntSkeletonAvatar(),
        title: AntSkeletonTitle(),
        paragraph: AntSkeletonParagraph(rows: 3),
        round: true,
      ),),);
      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .toList();
      // 圆形头像 + 标题 + 3 段落
      expect(
        decorations.where((d) => d.shape == BoxShape.circle).length,
        1,
      );
      // round 模式使用胶囊圆角
      expect(
        decorations.any((d) =>
            d.borderRadius == BorderRadius.circular(999),),
        isTrue,
      );
    });
  });
}
