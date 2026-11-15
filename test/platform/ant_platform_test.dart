import 'package:antd_flutter/src/platform/ant_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntPlatform', () {
    test('isWeb 与 kIsWeb 一致', () {
      expect(AntPlatform.isWeb, kIsWeb);
    });

    test('isDesktop 与 isMobile 互斥', () {
      expect(AntPlatform.isDesktop, !AntPlatform.isMobile);
    });

    test('桌面端 supportsHover 为 true', () {
      // 测试环境 defaultTargetPlatform 为 android（移动端）
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(AntPlatform.isDesktop, isTrue);
      expect(AntPlatform.supportsHover, isTrue);
      expect(AntPlatform.useTouchRipple, isFalse);
      expect(AntPlatform.showScrollbar, isTrue);
      expect(AntPlatform.supportsKeyboard, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('移动端 useTouchRipple 为 true', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(AntPlatform.isMobile, isTrue);
      expect(AntPlatform.useTouchRipple, isTrue);
      expect(AntPlatform.supportsHover, isFalse);
      expect(AntPlatform.showScrollbar, isFalse);
      expect(AntPlatform.supportsKeyboard, isFalse);
      debugDefaultTargetPlatformOverride = null;
    });

    test('isOhos 标准 SDK 下恒为 false', () {
      // 标准Flutter SDK 下 Platform.operatingSystem 不可能为 'ohos'
      // 该测试验证隔离逻辑的正确性
      expect(AntPlatform.isOhos, isFalse);
    });

    test('name 返回有效平台名', () {
      expect(AntPlatform.name, isNotEmpty);
      expect(
        AntPlatform.name,
        anyOf(
          equals('web'),
          equals('android'),
          equals('ios'),
          equals('windows'),
          equals('macos'),
          equals('linux'),
          equals('ohos'),
        ),
      );
    });
  });
}