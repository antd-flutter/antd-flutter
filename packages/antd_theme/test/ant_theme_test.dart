// ignore_for_file: lines_longer_than_80_chars
/// antd_theme 单元测试 — 断点、主题数据、InheritedWidget 注入。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tokens/antd_tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================================================================
  // AntBreakpoint
  // ================================================================
  group('AntBreakpoint', () {
    test('fromWidth 边界 — 各断点 minWidth 精确命中', () {
      expect(AntBreakpoint.fromWidth(0), isNull);
      expect(AntBreakpoint.fromWidth(479), isNull);
      expect(AntBreakpoint.fromWidth(480), AntBreakpoint.xs);
      expect(AntBreakpoint.fromWidth(575), AntBreakpoint.xs);
      expect(AntBreakpoint.fromWidth(576), AntBreakpoint.sm);
      expect(AntBreakpoint.fromWidth(767), AntBreakpoint.sm);
      expect(AntBreakpoint.fromWidth(768), AntBreakpoint.md);
      expect(AntBreakpoint.fromWidth(991), AntBreakpoint.md);
      expect(AntBreakpoint.fromWidth(992), AntBreakpoint.lg);
      expect(AntBreakpoint.fromWidth(1199), AntBreakpoint.lg);
      expect(AntBreakpoint.fromWidth(1200), AntBreakpoint.xl);
      expect(AntBreakpoint.fromWidth(1599), AntBreakpoint.xl);
      expect(AntBreakpoint.fromWidth(1600), AntBreakpoint.xxl);
      expect(AntBreakpoint.fromWidth(1919), AntBreakpoint.xxl);
      expect(AntBreakpoint.fromWidth(1920), AntBreakpoint.xxxl);
      expect(AntBreakpoint.fromWidth(9999), AntBreakpoint.xxxl);
    });

    test('minWidth 值与 antd Grid 断点一致', () {
      expect(AntBreakpoint.xs.minWidth, 480);
      expect(AntBreakpoint.sm.minWidth, 576);
      expect(AntBreakpoint.md.minWidth, 768);
      expect(AntBreakpoint.lg.minWidth, 992);
      expect(AntBreakpoint.xl.minWidth, 1200);
      expect(AntBreakpoint.xxl.minWidth, 1600);
      expect(AntBreakpoint.xxxl.minWidth, 1920);
    });

    test('比较运算符', () {
      expect(AntBreakpoint.md >= AntBreakpoint.sm, isTrue);
      expect(AntBreakpoint.md >= AntBreakpoint.md, isTrue);
      expect(AntBreakpoint.sm >= AntBreakpoint.md, isFalse);
      expect(AntBreakpoint.md > AntBreakpoint.sm, isTrue);
      expect(AntBreakpoint.md > AntBreakpoint.md, isFalse);
      expect(AntBreakpoint.sm < AntBreakpoint.md, isTrue);
      expect(AntBreakpoint.sm <= AntBreakpoint.sm, isTrue);
      expect(AntBreakpoint.lg <= AntBreakpoint.md, isFalse);
    });

    testWidgets('of(context) 基于 MediaQuery 宽度解析', (tester) async {
      AntBreakpoint? captured;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                captured = AntBreakpoint.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(captured, AntBreakpoint.md);
    });
  });

  // ================================================================
  // AntBreakpoints 工具类
  // ================================================================
  group('AntBreakpoints', () {
    Widget buildWithSize(double width, Widget Function(BuildContext) builder) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(builder: builder),
        ),
      );
    }

    testWidgets('isUp / isDown', (tester) async {
      late bool isUpMd;
      late bool isDownMd;
      await tester.pumpWidget(
        buildWithSize(800, (context) {
          isUpMd = AntBreakpoints.isUp(context, AntBreakpoint.md);
          isDownMd = AntBreakpoints.isDown(context, AntBreakpoint.md);
          return const SizedBox.shrink();
        }),
      );
      expect(isUpMd, isTrue); // 800 >= 768
      expect(isDownMd, isFalse);
    });

    testWidgets('isBetween', (tester) async {
      late bool betweenSmAndLg;
      await tester.pumpWidget(
        buildWithSize(800, (context) {
          betweenSmAndLg = AntBreakpoints.isBetween(
            context,
            AntBreakpoint.sm,
            AntBreakpoint.lg,
          );
          return const SizedBox.shrink();
        }),
      );
      expect(betweenSmAndLg, isTrue); // 800 >= 576 && 800 < 992
    });
  });

  // ================================================================
  // AntThemeData.light
  // ================================================================
  group('AntThemeData.light', () {
    final theme = AntThemeData.light();

    test('isDark = false', () {
      expect(theme.isDark, isFalse);
    });

    test('颜色便捷访问器与 colors 一致', () {
      expect(theme.colorPrimary, theme.colors.colorPrimary);
      expect(theme.colorText, theme.colors.colorText);
      expect(theme.colorBgContainer, theme.colors.colorBgContainer);
      expect(theme.colorBorder, theme.colors.colorBorder);
    });

    test('亮色默认关键色值', () {
      // colorPrimary = #1677ff
      expect(theme.colorPrimary, const Color(0xFF1677FF));
      // colorText = rgba(0,0,0,0.88) → alpha 224
      expect(theme.colorText, const Color.fromARGB(224, 0, 0, 0));
      // colorBgContainer = #fff
      expect(theme.colorBgContainer, const Color(0xFFFFFFFF));
      // colorBorder = #d9d9d9
      expect(theme.colorBorder, const Color(0xFFD9D9D9));
    });

    test('字体令牌默认值', () {
      expect(theme.fontSize, 14);
      expect(theme.fontSizeSM, 12);
      expect(theme.fontSizeLG, 16);
      expect(theme.fontSizeXL, 20);
      expect(theme.fontSizeHeading1, 38);
      expect(theme.fontSizeHeading2, 30);
      expect(theme.fontSizeHeading3, 24);
      expect(theme.fontSizeHeading4, 20);
      expect(theme.fontSizeHeading5, 16);
      expect(theme.fontSizeIcon, 12);
      expect(theme.lineHeight, 1.5714285714285714);
      expect(theme.fontWeightStrong, 600);
    });

    test('圆角令牌默认值', () {
      expect(theme.borderRadius, 6);
      expect(theme.borderRadiusXS, 2);
      expect(theme.borderRadiusSM, 4);
      expect(theme.borderRadiusLG, 8);
      expect(theme.borderRadiusOuter, 4);
    });

    test('尺寸令牌默认值', () {
      expect(theme.sizeXXS, 4);
      expect(theme.sizeXS, 8);
      expect(theme.sizeSM, 12);
      expect(theme.size, 16);
      expect(theme.sizeMS, 16);
      expect(theme.sizeMD, 20);
      expect(theme.sizeLG, 24);
      expect(theme.sizeXL, 32);
      expect(theme.sizeXXL, 48);
    });

    test('控件高度默认值', () {
      expect(theme.controlHeight, 32);
      expect(theme.controlHeightSM, 24);
      expect(theme.controlHeightXS, 16);
      expect(theme.controlHeightLG, 40);
      expect(theme.controlInteractiveSize, 16);
    });

    test('间距别名（padding/margin 转发 size）', () {
      expect(theme.paddingXXS, 4);
      expect(theme.paddingXS, 8);
      expect(theme.paddingSM, 12);
      expect(theme.padding, 16);
      expect(theme.paddingMD, 20);
      expect(theme.paddingLG, 24);
      expect(theme.paddingXL, 32);
      expect(theme.paddingContentHorizontal, 16);
      expect(theme.paddingContentVertical, 12);
      expect(theme.paddingContentHorizontalSM, 16);
      expect(theme.paddingContentVerticalSM, 8);
      expect(theme.paddingContentHorizontalLG, 24);
      expect(theme.paddingContentVerticalLG, 16);
      expect(theme.controlPaddingHorizontal, 12);
      expect(theme.controlPaddingHorizontalSM, 8);
      expect(theme.marginXXS, 4);
      expect(theme.margin, 16);
      expect(theme.marginXXL, 48);
    });

    test('线宽', () {
      expect(theme.lineWidth, 1);
      expect(theme.lineWidthBold, 2);
      expect(theme.lineWidthFocus, 3); // focusOutline=true → lineWidth*3
      expect(theme.controlOutlineWidth, 2);
      expect(theme.lineType, 'solid');
    });

    test('动效令牌', () {
      expect(theme.motionDurationFast, const Duration(milliseconds: 100));
      expect(theme.motionDurationMid, const Duration(milliseconds: 200));
      expect(theme.motionDurationSlow, const Duration(milliseconds: 300));
      // 曲线解析为 Cubic
      expect(theme.motionEaseOutCirc, isA<Cubic>());
      // easeOutCirc = cubic-bezier(0.08, 0.82, 0.17, 1)
      final cubic = theme.motionEaseOutCirc as Cubic;
      expect(cubic.a, closeTo(0.08, 0.001));
      expect(cubic.b, closeTo(0.82, 0.001));
      expect(cubic.c, closeTo(0.17, 0.001));
      expect(cubic.d, 1.0);
    });

    test('阴影令牌非空', () {
      expect(theme.boxShadow, hasLength(3));
      expect(theme.boxShadowCard, hasLength(3));
      expect(theme.boxShadowTertiary, hasLength(3));
      expect(theme.boxShadowDrawerRight, hasLength(3));
      expect(theme.boxShadowTabsOverflowLeft, hasLength(1));
    });

    test('Z-Index / 透明度', () {
      expect(theme.zIndexBase, 0);
      expect(theme.zIndexPopupBase, 1000);
      expect(theme.opacityLoading, 0.65);
      expect(theme.opacityImage, 1);
    });

    test('屏幕断点', () {
      expect(theme.screenXS, 480);
      expect(theme.screenXSMax, 575);
      expect(theme.screenSM, 576);
      expect(theme.screenMD, 768);
      expect(theme.screenLG, 992);
      expect(theme.screenXL, 1200);
      expect(theme.screenXXL, 1600);
      expect(theme.screenXXXL, 1920);
    });
  });

  // ================================================================
  // AntThemeData.dark
  // ================================================================
  group('AntThemeData.dark', () {
    final theme = AntThemeData.dark();

    test('isDark = true', () {
      expect(theme.isDark, isTrue);
    });

    test('暗色默认关键色值', () {
      expect(theme.colorPrimary, const Color(0xFF1668DC));
      expect(theme.colorBgContainer, const Color(0xFF141414));
      // colorText = rgba(255,255,255,0.85) → alpha byte = (0.85*255).round() = 217
      expect(theme.colorText, const Color.fromARGB(217, 255, 255, 255));
    });

    test('暗色阴影颜色为白色低透明度', () {
      // colorShadow = rgba(255,255,255,0.2) → ARGB 51,255,255,255
      expect(theme.colorShadow, const Color.fromARGB(51, 255, 255, 255));
      // boxShadow 底层 alpha 经过 formatAlpha
      expect(theme.boxShadow[0].color, const Color.fromARGB(5, 255, 255, 255));
    });
  });

  // ================================================================
  // AntThemeData.fromSeed — 自定义种子
  // ================================================================
  group('AntThemeData.fromSeed', () {
    test('自定义 borderRadius 传导到圆角令牌', () {
      final theme = AntThemeData.fromSeed(
        const AntSeedToken(borderRadius: 10),
      );
      // genRadius(10): LG=12, SM=6, XS=2, Outer=6
      expect(theme.borderRadius, 10);
      expect(theme.borderRadiusLG, 12);
      expect(theme.borderRadiusSM, 6);
      expect(theme.borderRadiusXS, 2);
      expect(theme.borderRadiusOuter, 6);
    });

    test('自定义 fontSize 传导到字体令牌', () {
      final theme = AntThemeData.fromSeed(
        const AntSeedToken(fontSize: 16),
      );
      expect(theme.fontSize, 16);
      expect(theme.fontSizeSM, 14);
      expect(theme.fontSizeLG, 18);
    });

    test('motion=false 全部归零', () {
      final theme = AntThemeData.fromSeed(
        const AntSeedToken(motion: false),
      );
      expect(theme.motionDurationFast, Duration.zero);
      expect(theme.motionDurationMid, Duration.zero);
      expect(theme.motionDurationSlow, Duration.zero);
    });

    test('focusOutline=false → lineWidthFocus = 0', () {
      final theme = AntThemeData.fromSeed(
        const AntSeedToken(focusOutline: false),
      );
      expect(theme.lineWidthFocus, 0);
    });
  });

  // ================================================================
  // AntTheme InheritedWidget
  // ================================================================
  group('AntTheme', () {
    testWidgets('of() 返回注入的主题数据', (tester) async {
      final darkTheme = AntThemeData.dark();
      AntThemeData? captured;
      await tester.pumpWidget(
        AntTheme(
          data: darkTheme,
          child: Builder(
            builder: (context) {
              captured = AntTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, same(darkTheme));
      expect(captured!.isDark, isTrue);
    });

    testWidgets('无 AntTheme 祖先时返回默认亮色主题', (tester) async {
      AntThemeData? captured;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            captured = AntTheme.of(context);
            return const SizedBox.shrink();
          },
        ),
      );
      expect(captured, isNotNull);
      expect(captured!.isDark, isFalse);
    });

    testWidgets('AntThemeBuilder 提供主题', (tester) async {
      AntThemeData? captured;
      await tester.pumpWidget(
        AntTheme(
          data: AntThemeData.light(),
          child: AntThemeBuilder(
            builder: (context, theme) {
              captured = theme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, isNotNull);
      expect(captured!.isDark, isFalse);
    });

    testWidgets('updateShouldNotify — data 变更时通知', (tester) async {
      var buildCount = 0;
      late AntThemeData currentTheme;
      final lightTheme = AntThemeData.light();
      final darkTheme = AntThemeData.dark();

      await tester.pumpWidget(
        AntTheme(
          data: lightTheme,
          child: AntThemeBuilder(
            builder: (context, theme) {
              currentTheme = theme;
              buildCount++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(buildCount, 1);
      expect(currentTheme.isDark, isFalse);

      // 切换到暗色 → 应触发重建
      await tester.pumpWidget(
        AntTheme(
          data: darkTheme,
          child: AntThemeBuilder(
            builder: (context, theme) {
              currentTheme = theme;
              buildCount++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();
      expect(buildCount, 2);
      expect(currentTheme.isDark, isTrue);
    });
  });
}
