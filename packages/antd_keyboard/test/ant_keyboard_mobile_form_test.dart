/// AntKeyboard 移动端形态回归用例（触控目标 / 无 hover / 安全区 / 平台形态判定）
///
/// - 移动端（Android/iOS 模拟）：键触控目标 ≥44、无 MouseRegion hover、
///   自定义过小 keyHeight 被钳制到 44、贴底 bottom inset 避让（R36）
/// - 桌面端（macOS 模拟）：未传主题时自动桌面密度（48 键高）+ MouseRegion
/// - SafeArea（overlay 弹出路径）消费 bottom inset 后不重复避让
library;

import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard.dart';
import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard_layout.dart';
import 'package:antd_keyboard/src/engines/ant_keyboard/ant_keyboard_theme.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 设置平台模拟（测试结束自动还原）
void _platform(TargetPlatform platform) {
  debugDefaultTargetPlatformOverride = platform;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
}

Widget _wrap(Widget child, {EdgeInsets safePadding = EdgeInsets.zero}) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(padding: safePadding),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

/// 取「label」键所在等高容器的高度（触控目标）
double _keyHeight(WidgetTester tester, String label) {
  final container = tester.widget<Container>(
    find
        .ancestor(
          of: find.text(label),
          matching: find.byType(Container),
        )
        .first,
  );
  final constraints = container.constraints;
  return constraints?.maxHeight ?? constraints?.minHeight ?? 0;
}

/// 键盘最外层 surface 容器（Text 的最后一个 Container 祖先）
Container _rootContainer(WidgetTester tester) {
  return tester.widget<Container>(
    find
        .ancestor(
          of: find.text('5'),
          matching: find.byType(Container),
        )
        .last,
  );
}

Finder _keyboardMouseRegions() => find.descendant(
      of: find.byType(AntKeyboard),
      matching: find.byType(MouseRegion),
    );

void main() {
  group('AntKeyboard — 移动端触控形态（Android / iOS 模拟）', () {
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      testWidgets('$platform：键触控目标 ≥44 且无 hover（MouseRegion 缺席）',
          (tester) async {
        _platform(platform);
        await tester.pumpWidget(
          _wrap(AntKeyboard(layout: AntKeyboardLayout.numeric())),
        );
        await tester.pumpAndSettle();

        for (final label in ['1', '5', '9']) {
          expect(
            _keyHeight(tester, label),
            greaterThanOrEqualTo(44.0),
            reason: label,
          );
        }
        expect(
          _keyboardMouseRegions(),
          findsNothing,
          reason: '触屏无悬停，移动端键盘不应注入 MouseRegion',
        );
      });

      testWidgets('$platform：自定义 keyHeight 过小被钳制到 44', (tester) async {
        _platform(platform);
        await tester.pumpWidget(
          _wrap(
            AntKeyboard(
              layout: AntKeyboardLayout.numeric(),
              theme: const AntKeyboardThemeData(keyHeight: 32),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(_keyHeight(tester, '5'), greaterThanOrEqualTo(44.0));
      });

      testWidgets('$platform：R36 贴底 bottom inset 避让（大于水平内边距）', (tester) async {
        _platform(platform);
        await tester.pumpWidget(
          _wrap(
            AntKeyboard(layout: AntKeyboardLayout.numeric()),
            safePadding: const EdgeInsets.only(bottom: 34),
          ),
        );
        await tester.pumpAndSettle();

        final padding = _rootContainer(tester).padding! as EdgeInsets;
        expect(
          padding.bottom,
          greaterThan(padding.left),
          reason: 'bottom inset 应叠加在 sectionPadding 之上',
        );
        expect(padding.bottom, greaterThanOrEqualTo(34.0));
      });

      testWidgets('$platform：SafeArea 消费 inset 后不重复避让（overlay 路径）',
          (tester) async {
        _platform(platform);
        await tester.pumpWidget(
          _wrap(
            SafeArea(
              top: false,
              child: AntKeyboard(layout: AntKeyboardLayout.numeric()),
            ),
            safePadding: const EdgeInsets.only(bottom: 34),
          ),
        );
        await tester.pumpAndSettle();

        final padding = _rootContainer(tester).padding! as EdgeInsets;
        expect(
          padding.bottom,
          equals(padding.left),
          reason: '外层 SafeArea 已消费 bottom inset，引擎不叠加',
        );
      });
    }
  });

  group('AntKeyboard — 桌面形态自动判定（macOS 模拟）', () {
    testWidgets('未传主题：桌面密度 48 键高 + MouseRegion 悬停注入', (tester) async {
      _platform(TargetPlatform.macOS);
      await tester.pumpWidget(
        _wrap(AntKeyboard(layout: AntKeyboardLayout.numeric())),
      );
      await tester.pumpAndSettle();

      expect(_keyHeight(tester, '5'), greaterThanOrEqualTo(48.0));
      expect(_keyboardMouseRegions(), findsWidgets);
    });

    testWidgets('显式主题 desktop: false：桌面端保持移动触控形态（API 兼容）', (tester) async {
      _platform(TargetPlatform.macOS);
      await tester.pumpWidget(
        _wrap(
          AntKeyboard(
            layout: AntKeyboardLayout.numeric(),
            theme: const AntKeyboardThemeData(desktop: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_keyboardMouseRegions(), findsNothing);
      // 重写后移动形态键高对齐 antd-mobile（48），不再钳到 44
      expect(_keyHeight(tester, '5'), greaterThanOrEqualTo(44.0));
      expect(_keyHeight(tester, '5'), lessThanOrEqualTo(48.0));
    });
  });

  group('AntKeyboard — 横屏布局', () {
    testWidgets('iOS 横屏宽屏下数字键盘无溢出、键高保持 ≥44', (tester) async {
      _platform(TargetPlatform.iOS);
      tester.view.physicalSize = const Size(852, 393) * 2; // iPhone 横屏
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _wrap(AntKeyboard(layout: AntKeyboardLayout.numeric())),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(_keyHeight(tester, '5'), greaterThanOrEqualTo(44.0));
      expect(find.text('9'), findsOneWidget);
    });
  });
}
