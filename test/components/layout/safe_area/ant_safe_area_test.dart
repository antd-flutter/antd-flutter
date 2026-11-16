/// AntSafeArea Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  EdgeInsets padding = EdgeInsets.zero,
  EdgeInsets viewPadding = EdgeInsets.zero,
}) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(padding: padding, viewPadding: viewPadding),
          child: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

/// 获取 AntSafeArea 内部 SizedBox 的高度（占位模式）。
double? _placeholderHeight(WidgetTester tester) {
  final sizedBox = tester.widget<SizedBox>(
    find.descendant(
      of: find.byType(AntSafeArea),
      matching: find.byType(SizedBox),
    ),
  );
  return sizedBox.height;
}

void main() {
  group('AntSafeArea — 占位模式', () {
    testWidgets('position=top renders padding.top height', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(position: AntSafeAreaPosition.top),
          padding: const EdgeInsets.only(top: 50),
        ),
      );
      expect(_placeholderHeight(tester), 50);
    });

    testWidgets('position=bottom renders padding.bottom height',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(position: AntSafeAreaPosition.bottom),
          padding: const EdgeInsets.only(bottom: 34),
        ),
      );
      expect(_placeholderHeight(tester), 34);
    });

    testWidgets('position=both renders top + bottom height',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(position: AntSafeAreaPosition.both),
          padding: const EdgeInsets.only(top: 50, bottom: 34),
        ),
      );
      expect(_placeholderHeight(tester), 84);
    });

    testWidgets('zero padding renders zero height', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSafeArea(position: AntSafeAreaPosition.both)),
      );
      expect(_placeholderHeight(tester), 0);
    });

    testWidgets('maintainBottomViewPadding uses viewPadding.bottom',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            position: AntSafeAreaPosition.bottom,
            maintainBottomViewPadding: true,
          ),
          padding: const EdgeInsets.only(bottom: 0),
          viewPadding: const EdgeInsets.only(bottom: 34),
        ),
      );
      expect(_placeholderHeight(tester), 34);
    });

    testWidgets(
        'maintainBottomViewPadding=false uses padding.bottom (keyboard consumed)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            position: AntSafeAreaPosition.bottom,
            maintainBottomViewPadding: false,
          ),
          padding: const EdgeInsets.only(bottom: 0),
          viewPadding: const EdgeInsets.only(bottom: 34),
        ),
      );
      expect(_placeholderHeight(tester), 0);
    });
  });

  group('AntSafeArea — 包装模式', () {
    testWidgets('wraps child with SafeArea', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSafeArea(child: Text('content'))),
      );
      expect(find.text('content'), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('position=top sets SafeArea top=true bottom=false',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            position: AntSafeAreaPosition.top,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.top, isTrue);
      expect(safeArea.bottom, isFalse);
    });

    testWidgets('position=bottom sets SafeArea top=false bottom=true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            position: AntSafeAreaPosition.bottom,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.top, isFalse);
      expect(safeArea.bottom, isTrue);
    });

    testWidgets('position=both sets top=true bottom=true (default)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSafeArea(child: Text('content'))),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.top, isTrue);
      expect(safeArea.bottom, isTrue);
    });

    testWidgets('left=false disables left safe area', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            left: false,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.left, isFalse);
      expect(safeArea.right, isTrue);
    });

    testWidgets('right=false disables right safe area', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            right: false,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.right, isFalse);
      expect(safeArea.left, isTrue);
    });

    testWidgets('minimum padding is passed through', (tester) async {
      const minPadding = EdgeInsets.all(8);
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            minimum: minPadding,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.minimum, minPadding);
    });

    testWidgets('maintainBottomViewPadding is passed through',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSafeArea(
            maintainBottomViewPadding: true,
            child: Text('content'),
          ),
        ),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.maintainBottomViewPadding, isTrue);
    });
  });
}