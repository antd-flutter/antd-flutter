import 'package:antd_flutter_plus/src/components/data_display/footer/ant_footer.dart';
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
  group('AntFooter', () {
    testWidgets('renders default content', (tester) async {
      await tester.pumpWidget(_wrap(const AntFooter()));
      expect(find.text('Foot 返回顶部'), findsOneWidget);
    });

    testWidgets('renders custom content', (tester) async {
      await tester.pumpWidget(_wrap(const AntFooter(content: '自定义页脚')));
      expect(find.text('自定义页脚'), findsOneWidget);
      expect(find.text('Foot 返回顶部'), findsNothing);
    });

    testWidgets('onClick fires on tap', (tester) async {
      var clicked = false;
      await tester.pumpWidget(_wrap(AntFooter(onClick: () => clicked = true)));
      await tester.tap(find.text('Foot 返回顶部'));
      await tester.pump();
      expect(clicked, isTrue);
    });

    testWidgets('child overrides default content', (tester) async {
      await tester.pumpWidget(_wrap(const AntFooter(
        child: Icon(Icons.vertical_align_top),
      ),),);
      expect(find.byIcon(Icons.vertical_align_top), findsOneWidget);
      expect(find.text('Foot 返回顶部'), findsNothing);
    });

    testWidgets('custom style applies background', (tester) async {
      await tester.pumpWidget(_wrap(const AntFooter(
        style: BoxDecoration(color: Colors.amber),
      ),),);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.amber);
    });

    testWidgets('default style uses theme layout background', (tester) async {
      await tester.pumpWidget(_wrap(const AntFooter()));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorBgLayout);
    });

    testWidgets('child click does not fire onClick', (tester) async {
      var clicked = false;
      await tester.pumpWidget(_wrap(AntFooter(
        onClick: () => clicked = true,
        child: const Text('自定义'),
      ),),);
      await tester.tap(find.text('自定义'));
      await tester.pump();
      expect(clicked, isFalse);
    });
  });
}
