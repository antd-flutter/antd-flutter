// ignore_for_file: lines_longer_than_80_chars
/// antd_theme → Flutter ThemeData 桥接单元测试：
/// 映射表关键断言（主色 / surface / 文字样式）、亮暗两套生成、Theme.of 就近读取。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================================================================
  // 亮色映射
  // ================================================================
  group('AntThemeData.light().toThemeData()', () {
    final theme = AntThemeData.light();
    final materialTheme = theme.toThemeData();
    final colorScheme = materialTheme.colorScheme;

    test('主色映射 — colorPrimary #1677ff → colorScheme.primary', () {
      expect(colorScheme.brightness, Brightness.light);
      expect(colorScheme.primary, const Color(0xFF1677FF));
      expect(colorScheme.primary, theme.colorPrimary);
    });

    test('错误色映射 — colorError → colorScheme.error', () {
      expect(colorScheme.error, theme.colorError);
    });

    test('surface / 背景映射', () {
      // surface = colorBgContainer (#ffffff)
      expect(colorScheme.surface, theme.colorBgContainer);
      expect(colorScheme.surface, const Color(0xFFFFFFFF));
      // scaffoldBackgroundColor = colorBgLayout (#f5f5f5)
      expect(materialTheme.scaffoldBackgroundColor, theme.colorBgLayout);
      expect(materialTheme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });

    test('文本/边框/遮罩映射', () {
      expect(colorScheme.onSurface, theme.colorText);
      expect(colorScheme.onSurfaceVariant, theme.colorTextSecondary);
      expect(colorScheme.outline, theme.colorBorder);
      expect(colorScheme.outlineVariant, theme.colorSplit);
      expect(colorScheme.scrim, theme.colorBgMask);
    });

    test('文字样式映射 — 标题与正文', () {
      // 正文：fontSize 14 / lineHeight / colorText
      final body = materialTheme.textTheme.bodyMedium!;
      expect(body.fontSize, theme.fontSize);
      expect(body.fontSize, 14);
      expect(body.height, theme.lineHeight);
      expect(body.color, theme.colorText);
      // 标题：Heading 1 = 38 / w600 / colorTextHeading
      final headline = materialTheme.textTheme.headlineLarge!;
      expect(headline.fontSize, theme.fontSizeHeading1);
      expect(headline.fontSize, 38);
      expect(headline.fontWeight, FontWeight.w600);
      expect(headline.color, theme.colorTextHeading);
    });

    test('组件级映射 — 主按钮 / 卡片 / 输入框', () {
      // 主按钮背景 = antd 主色
      final elevated =
          materialTheme.elevatedButtonTheme.style!.backgroundColor!.resolve({});
      expect(elevated, theme.colorPrimary);
      // 卡片：容器背景 + 无阴影 + 圆角 LG
      expect(materialTheme.cardTheme.color, theme.colorBgContainer);
      expect(materialTheme.cardTheme.elevation, 0);
      // 输入框：聚焦边框 = 主色、宽度 lineWidthBold
      final focusedBorder = materialTheme.inputDecorationTheme.focusedBorder!
          as OutlineInputBorder;
      expect(focusedBorder.borderSide.color, theme.colorPrimary);
      expect(focusedBorder.borderSide.width, theme.lineWidthBold);
    });

    test('字体家族传导', () {
      expect(materialTheme.fontFamily, theme.fontFamily);
    });
  });

  // ================================================================
  // 暗色映射
  // ================================================================
  group('AntThemeData.dark().toThemeData()', () {
    final theme = AntThemeData.dark();
    final materialTheme = theme.toThemeData();

    test('暗色色系 — brightness.dark + 暗色主色', () {
      expect(materialTheme.colorScheme.brightness, Brightness.dark);
      expect(materialTheme.colorScheme.primary, const Color(0xFF1668DC));
      expect(materialTheme.colorScheme.primary, theme.colorPrimary);
    });

    test('暗色 surface / 背景为暗色 token', () {
      expect(materialTheme.colorScheme.surface, const Color(0xFF141414));
      // colorBgLayout（暗色）= #000000
      expect(materialTheme.scaffoldBackgroundColor, theme.colorBgLayout);
    });

    test('暗色文字样式为白色系', () {
      final body = materialTheme.textTheme.bodyMedium!;
      expect(body.color, theme.colorText);
      expect(theme.colorText, const Color.fromARGB(217, 255, 255, 255));
    });
  });

  // ================================================================
  // brightness 参数 — 同一 seed 派生另一套明暗
  // ================================================================
  group('toThemeData(brightness:)', () {
    test('亮色 antd 主题请求暗色 ThemeData → 得到暗色 token 体系', () {
      final light = AntThemeData.light();
      final dark = light.toThemeData(brightness: Brightness.dark);
      expect(dark.colorScheme.brightness, Brightness.dark);
      expect(dark.colorScheme.primary, const Color(0xFF1668DC));
      expect(dark.colorScheme.surface, const Color(0xFF141414));
    });

    test('暗色 antd 主题请求亮色 ThemeData → 得到亮色 token 体系', () {
      final dark = AntThemeData.dark();
      final light = dark.toThemeData(brightness: Brightness.light);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(light.colorScheme.primary, const Color(0xFF1677FF));
    });
  });

  // ================================================================
  // AntTheme 自动注入 Theme — Theme.of 就近读取
  // ================================================================
  group('AntTheme 注入 Theme', () {
    testWidgets('Theme.of(context) 取到 antd 派生的 Material 主题', (tester) async {
      late ThemeData captured;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.light(),
          child: Builder(
            builder: (context) {
              captured = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured.colorScheme.primary, const Color(0xFF1677FF));
      expect(captured.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });

    testWidgets('暗色 AntTheme → Theme.of 为暗色派生主题', (tester) async {
      late ThemeData captured;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.dark(),
          child: Builder(
            builder: (context) {
              captured = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured.colorScheme.brightness, Brightness.dark);
      expect(captured.colorScheme.primary, const Color(0xFF1668DC));
    });

    testWidgets('嵌套 AntTheme 时 Theme.of 就近取内层', (tester) async {
      late ThemeData outer;
      late ThemeData inner;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.light(),
          child: AntTheme(
            data: AntThemeData.dark(),
            child: Builder(
              builder: (context) {
                inner = Theme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      // 外层再取一次验证隔离
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.light(),
          child: Builder(
            builder: (context) {
              outer = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(outer.colorScheme.brightness, Brightness.light);
      expect(inner.colorScheme.brightness, Brightness.dark);
    });

    testWidgets('AntTheme.of 行为不变 — 与注入的 Theme 同源', (tester) async {
      late AntThemeData antTheme;
      late ThemeData materialTheme;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.dark(),
          child: Builder(
            builder: (context) {
              antTheme = AntTheme.of(context);
              materialTheme = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(antTheme.isDark, isTrue);
      expect(materialTheme.colorScheme.primary, antTheme.colorPrimary);
    });

    testWidgets('data 变更时 Theme 通知依赖方重建', (tester) async {
      var buildCount = 0;
      late ThemeData captured;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.light(),
          child: Builder(
            builder: (context) {
              buildCount++;
              captured = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(buildCount, 1);
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.dark(),
          child: Builder(
            builder: (context) {
              buildCount++;
              captured = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();
      expect(buildCount, 2);
      expect(captured.colorScheme.brightness, Brightness.dark);
    });
  });
}
