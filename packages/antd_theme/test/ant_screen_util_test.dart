// AntScreenUtilInit 桌面最大宽度上限与等比放大 — 因子计算单元测试。
//
// 覆盖：非桌面（<=768）/ 桌面 768~maxWidth / >maxWidth 开关放大 /
// maxScaleFactor 封顶 / 默认参数行为不变。
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntScreenUtilInit.resolveDesktopScale 因子计算', () {
    group('非桌面模式（宽度 <= 768）', () {
      test('宽度 375 走手机设计稿，因子恒为 1', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(375, 812),
        );
        expect(result.designSize, const Size(375, 812));
        expect(result.scaleFactor, 1.0);
      });

      test('宽度恰为断点 768 属于桌面模式', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(768, 1024),
        );
        expect(result.designSize, const Size(768, 1024));
        expect(result.scaleFactor, 1.0);
      });

      test('宽度 767（< 断点）即使开启放大也不生效', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(767, 1024),
          maxWidth: 500,
          allowScaleUp: true,
        );
        expect(result.designSize, const Size(375, 812));
        expect(result.scaleFactor, 1.0);
      });

      test('desktopBreakpoint 为 null 禁用桌面自适应', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(1920, 1080),
          desktopBreakpoint: null,
        );
        expect(result.designSize, const Size(375, 812));
        expect(result.scaleFactor, 1.0);
      });
    });

    group('桌面模式 768 ~ maxWidth（未超上限）', () {
      test('宽度介于断点与 maxWidth 之间行为不变，因子 1', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(1440, 900),
          maxWidth: 1920,
          allowScaleUp: true,
        );
        expect(result.designSize, const Size(1440, 900));
        expect(result.scaleFactor, 1.0);
      });

      test('宽度恰为 maxWidth 因子仍为 1（<= 不放大）', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(1920, 1080),
          maxWidth: 1920,
          allowScaleUp: true,
        );
        expect(result.designSize, const Size(1920, 1080));
        expect(result.scaleFactor, 1.0);
      });
    });

    group('> maxWidth 开关放大', () {
      test('allowScaleUp: false（默认）永不放大', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(2400, 1080),
          maxWidth: 1920,
        );
        expect(result.designSize, const Size(2400, 1080));
        expect(result.scaleFactor, 1.0);
      });

      test('allowScaleUp: true 窗口 2400 / maxWidth 1920 → 因子 1.25', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(2400, 1080),
          maxWidth: 1920,
          allowScaleUp: true,
        );
        expect(result.scaleFactor, closeTo(1.25, 1e-9));
        // designSize = 窗口 / 因子 → .w 因子 = 窗口 / designSize.width = 因子。
        expect(result.designSize.width, closeTo(2400 / 1.25, 1e-9));
        expect(result.designSize.width, closeTo(1920, 1e-9));
        // 高度按同一因子等比换算，保持不变形。
        expect(result.designSize.height, closeTo(1080 / 1.25, 1e-9));
      });

      test('allowScaleUp: true 但 maxWidth 为 null 无法放大', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(2400, 1080),
          maxWidth: null,
          allowScaleUp: true,
        );
        expect(result.designSize, const Size(2400, 1080));
        expect(result.scaleFactor, 1.0);
      });
    });

    group('maxScaleFactor 封顶', () {
      test('窗口 3600 / maxWidth 1920 → 本应 1.875，封顶为 1.5', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(3600, 1200),
          maxWidth: 1920,
          allowScaleUp: true,
          maxScaleFactor: 1.5,
        );
        expect(result.scaleFactor, 1.5);
        expect(result.designSize.width, closeTo(3600 / 1.5, 1e-9));
        expect(result.designSize.height, closeTo(1200 / 1.5, 1e-9));
      });

      test('自定义封顶值生效', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(3600, 1200),
          maxWidth: 1920,
          allowScaleUp: true,
          maxScaleFactor: 1.2,
        );
        expect(result.scaleFactor, 1.2);
      });

      test('未超封顶时不截断', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(2400, 1080),
          maxWidth: 1920,
          allowScaleUp: true,
          maxScaleFactor: 1.5,
        );
        expect(result.scaleFactor, closeTo(1.25, 1e-9));
      });
    });

    group('默认参数行为不变', () {
      test('默认（不传新参数）桌面窗口恒为窗口尺寸、因子 1', () {
        final result = AntScreenUtilInit.resolveDesktopScale(
          designSize: const Size(375, 812),
          windowSize: const Size(3840, 2160),
        );
        expect(result.designSize, const Size(3840, 2160));
        expect(result.scaleFactor, 1.0);
      });

      test('默认 maxScaleFactor 常量为 1.5', () {
        expect(
          AntScreenUtilInit.defaultMaxScaleFactor,
          1.5,
        );
      });

      test('scaleFactorNotifier 初始为 1.0', () {
        expect(AntScreenUtilInit.scaleFactorNotifier.value, 1.0);
      });
    });
  });

  group('AntLayoutData.scaleFactor', () {
    const base = AntLayoutData(
      width: 2400,
      breakpoint: AntBreakpoint.xxxl,
      deviceType: AntDeviceType.desktop,
      orientation: AntOrientation.landscape,
      foldState: AntFoldState.flat,
      targetPlatform: TargetPlatform.macOS,
      isOhos: false,
      isDesktop: true,
    );

    test('默认 scaleFactor 为 1.0', () {
      expect(base.scaleFactor, 1.0);
    });

    test('scaleFactor 参与 == 与 hashCode', () {
      final scaled = base.copyWithForTestScale(1.25);
      expect(scaled.scaleFactor, 1.25);
      expect(scaled == base, isFalse);
      expect(scaled.hashCode, isNot(base.hashCode));

      final sameScaled = base.copyWithForTestScale(1.25);
      expect(scaled == sameScaled, isTrue);
      expect(scaled.hashCode, sameScaled.hashCode);
    });

    test('fromMediaQuery 透传 scaleFactor', () {
      final data = AntLayoutData.fromMediaQuery(
        const MediaQueryData(size: Size(2400, 1080)),
        scaleFactor: 1.25,
      );
      expect(data.scaleFactor, 1.25);
    });
  });
}

extension on AntLayoutData {
  /// 测试辅助：复制快照并替换 scaleFactor。
  AntLayoutData copyWithForTestScale(double scaleFactor) => AntLayoutData(
        width: width,
        breakpoint: breakpoint,
        deviceType: deviceType,
        orientation: orientation,
        foldState: foldState,
        targetPlatform: targetPlatform,
        isOhos: isOhos,
        isDesktop: isDesktop,
        scaleFactor: scaleFactor,
      );
}
