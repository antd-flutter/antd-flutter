/// AntSafeArea 适配层 Widget 测试
///
/// 适配层定位：AntSafeArea 继承 Flutter 原生 SafeArea，Flutter 参数透传 +
/// antd 增强（position 枚举、child 为 null 的占位模式）。
/// 本测试覆盖：
/// - 默认参数值命中 Flutter SafeArea 原生默认（P08 适配层默认参数值单测）
/// - position 枚举构造级映射 top/bottom
/// - 占位模式与包装模式行为
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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
  group('AntSafeArea — 适配层默认参数值（对齐 Flutter SafeArea 原生默认）', () {
    test('is a SafeArea subtype（类型兼容原生位置）', () {
      const antSafeArea = AntSafeArea();
      expect(antSafeArea, isA<SafeArea>());
    });

    test('defaults match Flutter SafeArea native defaults', () {
      const antSafeArea = AntSafeArea();
      const native = SafeArea(child: SizedBox());
      expect(antSafeArea.left, native.left);
      expect(antSafeArea.top, native.top);
      expect(antSafeArea.right, native.right);
      expect(antSafeArea.bottom, native.bottom);
      expect(antSafeArea.maintainBottomViewPadding,
          native.maintainBottomViewPadding,);
      expect(antSafeArea.minimum, native.minimum);
    });

    test('minimum 保持 Flutter 原生默认 EdgeInsets.zero', () {
      const antSafeArea = AntSafeArea();
      expect(antSafeArea.minimum, EdgeInsets.zero);
    });

    test('position=both maps to top=true bottom=true (native default)', () {
      const antSafeArea = AntSafeArea();
      expect(antSafeArea.top, isTrue);
      expect(antSafeArea.bottom, isTrue);
    });

    test('position=top maps to top=true bottom=false', () {
      const antSafeArea = AntSafeArea(position: AntSafeAreaPosition.top);
      expect(antSafeArea.top, isTrue);
      expect(antSafeArea.bottom, isFalse);
    });

    test('position=bottom maps to top=false bottom=true', () {
      const antSafeArea = AntSafeArea(position: AntSafeAreaPosition.bottom);
      expect(antSafeArea.top, isFalse);
      expect(antSafeArea.bottom, isTrue);
    });

    test('Flutter 参数经 super 透传（用户显式传参优先）', () {
      const minPadding = EdgeInsets.all(8);
      const antSafeArea = AntSafeArea(
        minimum: minPadding,
        maintainBottomViewPadding: true,
        left: false,
        right: false,
      );
      expect(antSafeArea.minimum, minPadding);
      expect(antSafeArea.maintainBottomViewPadding, isTrue);
      expect(antSafeArea.left, isFalse);
      expect(antSafeArea.right, isFalse);
    });
  });

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
      expect(find.byWidgetPredicate((w) => w is SafeArea), findsOneWidget);
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
      expect(safeArea.top, isFalse);
      expect(safeArea.bottom, isTrue);
    });

    testWidgets('position=both sets top=true bottom=true (default)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSafeArea(child: Text('content'))),
      );
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
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
      final safeArea = tester.widget<SafeArea>(find.byType(AntSafeArea));
      expect(safeArea.maintainBottomViewPadding, isTrue);
    });
  });
}
