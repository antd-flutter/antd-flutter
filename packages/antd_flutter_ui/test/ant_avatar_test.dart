import 'package:antd_flutter_plus/src/components/data_display/avatar/ant_avatar.dart';
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
  group('AntAvatar', () {
    testWidgets('text avatar renders child text', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatar(child: 'A')));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('icon avatar renders custom icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(icon: Icon(Icons.person_outline))),
      );
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('fallback shows person icon when no content', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatar()));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('custom size affects container dimensions', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatar(child: 'B', size: 64)));
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, 64);
    });

    testWidgets('presetSize small resolves to 24', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(child: 'C', presetSize: AntAvatarSize.small)),
      );
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, 24);
    });

    testWidgets('presetSize large resolves to 40', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(child: 'D', presetSize: AntAvatarSize.large)),
      );
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, 40);
    });

    testWidgets('default size resolves to 32', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatar(child: 'E')));
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, 32);
    });

    testWidgets('square shape uses non-circular radius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(child: 'F', shape: AntAvatarShape.square)),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius is BorderRadius, isTrue);
      final radius = decoration.borderRadius! as BorderRadius;
      expect(radius.topLeft.x, lessThan(16));
    });

    testWidgets('circle shape uses full radius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(child: 'G', shape: AntAvatarShape.circle)),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      final radius = decoration.borderRadius! as BorderRadius;
      expect(radius.topLeft.x, 16);
    });

    testWidgets('custom backgroundColor overrides theme', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(child: 'H', backgroundColor: Colors.red)),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('long text scales down with FittedBox', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatar(child: 'LongName')));
      expect(find.text('LongName'), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
    });

    testWidgets('image src renders Image widget', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAvatar(src: 'https://example.com/a.png')),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('image error triggers onError and shows fallback', (tester) async {
      var errorCalled = false;
      await tester.pumpWidget(
        _wrap(AntAvatar(
          src: 'https://example.com/bad.png',
          onError: () => errorCalled = true,
        ),),
      );
      await tester.pumpAndSettle();
      expect(errorCalled, isTrue);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('AntAvatarGroup', () {
    testWidgets('renders all avatars when under maxCount', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatarGroup(
        children: [
          AntAvatar(child: 'A'),
          AntAvatar(child: 'B'),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('maxCount truncates and shows +N', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatarGroup(
        maxCount: 3,
        children: [
          AntAvatar(child: 'A'),
          AntAvatar(child: 'B'),
          AntAvatar(child: 'C'),
          AntAvatar(child: 'D'),
          AntAvatar(child: 'E'),
        ],
      ),),);
      // 显示 2 个头像 + "+3"
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsNothing);
      expect(find.text('+3'), findsOneWidget);
    });

    testWidgets('group size applies to all children', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatarGroup(
        size: 48,
        children: [
          AntAvatar(child: 'A'),
          AntAvatar(child: 'B'),
        ],
      ),),);
      final sizeA = tester.getSize(
        find.ancestor(of: find.text('A'), matching: find.byType(Container)).first,
      );
      final sizeB = tester.getSize(
        find.ancestor(of: find.text('B'), matching: find.byType(Container)).first,
      );
      expect(sizeA.width, 48);
      expect(sizeB.width, 48);
    });

    testWidgets('negative spacing creates overlap', (tester) async {
      await tester.pumpWidget(_wrap(const AntAvatarGroup(
        spacing: -8,
        children: [
          AntAvatar(child: 'A'),
          AntAvatar(child: 'B'),
        ],
      ),),);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      // 第二个头像左边距应小于第一个头像右边距（重叠）
      final rectA = tester.getRect(
        find.ancestor(of: find.text('A'), matching: find.byType(Container)).first,
      );
      final rectB = tester.getRect(
        find.ancestor(of: find.text('B'), matching: find.byType(Container)).first,
      );
      expect(rectB.left, lessThan(rectA.right));
    });
  });
}