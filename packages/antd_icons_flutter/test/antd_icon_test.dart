import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  group('AntIcons (TTF constants)', () {
    test('icons have correct font family', () {
      expect(AntIcons.checkOutlined.fontFamily, 'AntIcons');
      expect(AntIcons.checkCircleFilled.fontFamily, 'AntIcons');
      expect(AntIcons.heartFilled.fontFamily, 'AntIcons');
    });

    test('codepoints are in Private Use Area', () {
      expect(AntIcons.checkOutlined.codePoint, inInclusiveRange(0xe000, 0xf8ff));
      expect(AntIcons.searchOutlined.codePoint, inInclusiveRange(0xe000, 0xf8ff));
      expect(AntIcons.heartFilled.codePoint, inInclusiveRange(0xe000, 0xf8ff));
    });

    test('enumeration lists match expected counts', () {
      expect(AntIcons.outlinedIcons.length, 447);
      expect(AntIcons.filledIcons.length, 251);
    });

    test('enumeration entries have matching names and icons', () {
      final first = AntIcons.outlinedIcons.first;
      expect(first.$1, 'accountBookOutlined');
      expect(first.$2, AntIcons.accountBookOutlined);
    });
  });

  group('AntIconsTwotone (SVG asset paths)', () {
    test('paths point to twotone assets', () {
      expect(AntIconsTwotone.checkCircleTwoTone, startsWith('assets/twotone/'));
      expect(AntIconsTwotone.checkCircleTwoTone, endsWith('.svg'));
      expect(AntIconsTwotone.heartTwoTone, 'assets/twotone/heart.svg');
    });

    test('enumeration list matches expected count', () {
      expect(AntIconsTwotone.twotoneIcons.length, 150);
    });
  });

  group('AntdIcon widget', () {
    testWidgets('renders TTF icon via Icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntIcons.checkOutlined, size: 32),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, AntIcons.checkOutlined);
      expect(icon.size, 32);
    });

    testWidgets('renders TwoTone SVG icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntIconsTwotone.checkCircleTwoTone, size: 32),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AntdIcon), findsOneWidget);
    });

    testWidgets('asserts on invalid icon type', (tester) async {
      expect(
        () => AntdIcon(42),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}