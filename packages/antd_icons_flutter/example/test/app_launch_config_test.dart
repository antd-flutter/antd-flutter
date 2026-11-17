import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:antd_icons_example/app_launch_config.dart';

void main() {
  group('AppLaunchConfig.fromUri', () {
    test('非 web 平台返回默认配置', () {
      const config = AppLaunchConfig.fallback();
      expect(config.embedded, isFalse);
      expect(config.isDark, isFalse);
      expect(config.primaryColor, AppLaunchConfig.defaultPrimaryColor);
    });

    test('解析 embed=1', () {
      final config = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/icons/?embed=1'),
      );
      expect(config.embedded, isTrue);
    });

    test('解析 theme=dark / theme=light', () {
      expect(
        AppLaunchConfig.fromUri(
          Uri.parse('https://example.com/?theme=dark'),
        ).isDark,
        isTrue,
      );
      expect(
        AppLaunchConfig.fromUri(
          Uri.parse('https://example.com/?theme=light'),
        ).isDark,
        isFalse,
      );
      // 非法取值回退亮色。
      expect(
        AppLaunchConfig.fromUri(
          Uri.parse('https://example.com/?theme=xxx'),
        ).isDark,
        isFalse,
      );
    });

    test('解析 primary 主题色参数', () {
      final config = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/?primary=0xFF52C41A'),
      );
      expect(config.primaryColor, const Color(0xFF52C41A));

      final hex = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/?primary=%2352c41a'),
      );
      expect(hex.primaryColor, const Color(0xFF52C41A));

      final sixDigits = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/?primary=52c41a'),
      );
      expect(sixDigits.primaryColor, const Color(0xFF52C41A));

      // 非法值回退默认主题色。
      final invalid = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/?primary=zzz'),
      );
      expect(invalid.primaryColor, AppLaunchConfig.defaultPrimaryColor);
    });

    test('组合参数', () {
      final config = AppLaunchConfig.fromUri(
        Uri.parse('https://example.com/?embed=1&theme=dark&primary=0xFF722ED1'),
      );
      expect(config.embedded, isTrue);
      expect(config.isDark, isTrue);
      expect(config.primaryColor, const Color(0xFF722ED1));
    });
  });
}
