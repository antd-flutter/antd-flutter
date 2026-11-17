import 'package:antd_flutter_ui/src/display/tag/ant_tag.dart';
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
  group('AntTag', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '标签')));
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('default tag has border', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '默认')));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('bordered false removes border', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '无边框', bordered: false)));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('success color uses success theme', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '成功', color: AntTagColor.success)));
      expect(find.text('成功'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      // 背景应为 successBg 色（非默认 colorBgContainer）
      expect(decoration.color, isNot(equals(AntThemeData.light().colorBgContainer)));
    });

    testWidgets('error color renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '错误', color: AntTagColor.error)));
      expect(find.text('错误'), findsOneWidget);
    });

    testWidgets('warning color renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '警告', color: AntTagColor.warning)));
      expect(find.text('警告'), findsOneWidget);
    });

    testWidgets('processing color renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '处理中', color: AntTagColor.processing)));
      expect(find.text('处理中'), findsOneWidget);
    });

    testWidgets('custom color applies tint', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(
        child: '自定义',
        customColor: Colors.purple,
      ),),);
      expect(find.text('自定义'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.purple.withValues(alpha: 0.15));
    });

    testWidgets('closable shows close icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(child: '可关闭', closable: true)));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('tap close removes tag and fires onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntTag(
        child: '可关闭',
        closable: true,
        onClose: () => closed = true,
      ),),);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(closed, isTrue);
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('icon renders before text', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(
        child: '带图标',
        icon: Icon(Icons.check_circle),
      ),),);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('带图标'), findsOneWidget);
    });

    testWidgets('custom padding applies', (tester) async {
      await tester.pumpWidget(_wrap(const AntTag(
        child: '自定义间距',
        padding: EdgeInsets.all(12),
      ),),);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, const EdgeInsets.all(12));
    });
  });
}