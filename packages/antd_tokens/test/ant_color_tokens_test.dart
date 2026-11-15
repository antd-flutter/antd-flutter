// ignore_for_file: lines_longer_than_80_chars
/// AntColorTokens 单元测试 — 亮/暗主题 CSS 值与 antd v6 源码逐一断言对齐。
library;

import 'dart:ui';

import 'package:antd_tokens/antd_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================================================================
  // 亮色主题
  // ================================================================
  group('AntColorTokens.light', () {
    final t = AntColorTokens.light(const AntSeedToken());
    final css = t.css;

    test('isDark 标志', () => expect(t.isDark, isFalse));

    test('基色', () {
      // antd 种子值直传：colorBgBase='#fff', colorTextBase='#000'
      expect(css.colorBgBase, '#fff');
      expect(css.colorTextBase, '#000');
      expect(css.colorWhite, '#fff');
      expect(css.colorShadow, '#000');
      expect(css.colorBgMask, 'rgba(0,0,0,0.45)');
    });

    test('文字颜色', () {
      expect(css.colorText, 'rgba(0,0,0,0.88)');
      expect(css.colorTextSecondary, 'rgba(0,0,0,0.65)');
      expect(css.colorTextTertiary, 'rgba(0,0,0,0.45)');
      expect(css.colorTextQuaternary, 'rgba(0,0,0,0.25)');
    });

    test('填充颜色', () {
      expect(css.colorFill, 'rgba(0,0,0,0.15)');
      expect(css.colorFillSecondary, 'rgba(0,0,0,0.06)');
      expect(css.colorFillTertiary, 'rgba(0,0,0,0.04)');
      expect(css.colorFillQuaternary, 'rgba(0,0,0,0.02)');
    });

    test('背景颜色', () {
      expect(css.colorBgLayout, '#f5f5f5');
      expect(css.colorBgContainer, '#ffffff');
      expect(css.colorBgElevated, '#ffffff');
      expect(css.colorBgSpotlight, 'rgba(0,0,0,0.85)');
      expect(css.colorBgBlur, 'transparent');
      expect(css.colorBgSolid, 'rgb(0,0,0)');
      expect(css.colorBgSolidHover, 'rgba(0,0,0,0.75)');
      expect(css.colorBgSolidActive, 'rgba(0,0,0,0.95)');
    });

    test('边框颜色', () {
      expect(css.colorBorder, '#d9d9d9');
      expect(css.colorBorderSecondary, '#f0f0f0');
      expect(css.colorBorderDisabled, '#d9d9d9');
    });

    test('Primary 色板（blue light）', () {
      expect(css.colorPrimaryBg, '#e6f4ff');
      expect(css.colorPrimaryBgHover, '#bae0ff');
      expect(css.colorPrimaryBorder, '#91caff');
      expect(css.colorPrimaryBorderHover, '#69b1ff');
      expect(css.colorPrimaryHover, '#4096ff');
      expect(css.colorPrimary, '#1677ff');
      expect(css.colorPrimaryActive, '#0958d9');
      expect(css.colorPrimaryTextHover, '#4096ff');
      expect(css.colorPrimaryText, '#1677ff');
      expect(css.colorPrimaryTextActive, '#0958d9');
    });

    test('Success 色板（green light）', () {
      expect(css.colorSuccessBg, '#f6ffed');
      expect(css.colorSuccessBgHover, '#d9f7be');
      expect(css.colorSuccessBorder, '#b7eb8f');
      expect(css.colorSuccessBorderHover, '#95de64');
      expect(css.colorSuccessHover, '#95de64');
      expect(css.colorSuccess, '#52c41a');
      expect(css.colorSuccessActive, '#389e0d');
    });

    test('Warning 色板（gold light）', () {
      expect(css.colorWarningBg, '#fffbe6');
      expect(css.colorWarningBgHover, '#fff1b8');
      expect(css.colorWarningBorder, '#ffe58f');
      expect(css.colorWarningBorderHover, '#ffd666');
      expect(css.colorWarningHover, '#ffd666');
      expect(css.colorWarning, '#faad14');
      expect(css.colorWarningActive, '#d48806');
    });

    test('Error 色板（red from #ff4d4f）', () {
      expect(css.colorErrorBg, '#fff2f0');
      expect(css.colorErrorBgHover, '#fff1f0');
      expect(css.colorErrorBgHoverFilled, '#ffcac7');
      expect(css.colorErrorBgActive, '#ffccc7');
      expect(css.colorErrorBorder, '#ffccc7');
      expect(css.colorErrorBorderHover, '#ffa39e');
      expect(css.colorErrorHover, '#ff7875');
      expect(css.colorError, '#ff4d4f');
      expect(css.colorErrorActive, '#d9363e');
    });

    test('Info/Link', () {
      expect(css.colorInfoBg, '#e6f4ff');
      expect(css.colorInfo, '#1677ff');
      expect(css.colorLink, '#1677ff');
      expect(css.colorLinkHover, '#69b1ff');
      expect(css.colorLinkActive, '#0958d9');
    });

    test('别名令牌', () {
      expect(css.colorFillContent, 'rgba(0,0,0,0.06)');
      expect(css.colorFillContentHover, 'rgba(0,0,0,0.15)');
      expect(css.colorFillAlter, 'rgba(0,0,0,0.02)');
      expect(css.colorBgContainerDisabled, 'rgba(0,0,0,0.04)');
      expect(css.colorBorderBg, '#ffffff');
      expect(css.colorSplit, 'rgba(5,5,5,0.06)');
      expect(css.colorTextPlaceholder, 'rgba(0,0,0,0.25)');
      expect(css.colorTextDisabled, 'rgba(0,0,0,0.25)');
      expect(css.colorTextHeading, 'rgba(0,0,0,0.88)');
      expect(css.colorTextLabel, 'rgba(0,0,0,0.65)');
      expect(css.colorTextDescription, 'rgba(0,0,0,0.45)');
      expect(css.colorTextLightSolid, '#fff');
      expect(css.colorHighlight, '#ff4d4f');
      expect(css.colorBgTextHover, 'rgba(0,0,0,0.06)');
      expect(css.colorBgTextActive, 'rgba(0,0,0,0.15)');
      expect(css.colorIcon, 'rgba(0,0,0,0.45)');
      expect(css.colorIconHover, 'rgba(0,0,0,0.88)');
      expect(css.colorErrorOutline, 'rgba(255,38,5,0.06)');
      expect(css.colorWarningOutline, 'rgba(255,215,5,0.1)');
      expect(css.colorErrorAffix, '#ff4d4f');
      expect(css.colorWarningAffix, '#faad14');
      expect(css.controlItemBgHover, 'rgba(0,0,0,0.04)');
      expect(css.controlItemBgActive, '#e6f4ff');
      expect(css.controlItemBgActiveHover, '#bae0ff');
      expect(css.controlItemBgActiveDisabled, 'rgba(0,0,0,0.15)');
      expect(css.controlTmpOutline, 'rgba(0,0,0,0.02)');
      expect(css.controlOutline, 'rgba(5,145,255,0.1)');
    });
  });

  // ================================================================
  // 暗色主题
  // ================================================================
  group('AntColorTokens.dark', () {
    final t = AntColorTokens.dark(AntSeedToken.dark());
    final css = t.css;

    test('isDark 标志', () => expect(t.isDark, isTrue));

    test('基色', () {
      // antd 种子值直传：colorBgBase='#000', colorTextBase='#fff'
      expect(css.colorBgBase, '#000');
      expect(css.colorTextBase, '#fff');
      expect(css.colorWhite, '#fff');
      expect(css.colorShadow, 'rgba(255, 255, 255, 0.2)');
      expect(css.colorBgMask, 'rgba(0,0,0,0.45)');
    });

    test('文字颜色', () {
      expect(css.colorText, 'rgba(255,255,255,0.85)');
      expect(css.colorTextSecondary, 'rgba(255,255,255,0.65)');
      expect(css.colorTextTertiary, 'rgba(255,255,255,0.45)');
      expect(css.colorTextQuaternary, 'rgba(255,255,255,0.25)');
    });

    test('填充颜色', () {
      expect(css.colorFill, 'rgba(255,255,255,0.18)');
      expect(css.colorFillSecondary, 'rgba(255,255,255,0.12)');
      expect(css.colorFillTertiary, 'rgba(255,255,255,0.08)');
      expect(css.colorFillQuaternary, 'rgba(255,255,255,0.04)');
    });

    test('背景颜色', () {
      expect(css.colorBgLayout, '#000000');
      expect(css.colorBgContainer, '#141414');
      expect(css.colorBgElevated, '#1f1f1f');
      expect(css.colorBgSpotlight, '#424242');
      expect(css.colorBgBlur, 'rgba(255,255,255,0.04)');
      expect(css.colorBgSolid, 'rgba(255,255,255,0.95)');
      expect(css.colorBgSolidHover, 'rgb(255,255,255)');
      expect(css.colorBgSolidActive, 'rgba(255,255,255,0.9)');
    });

    test('边框颜色', () {
      expect(css.colorBorder, '#424242');
      expect(css.colorBorderSecondary, '#303030');
      expect(css.colorBorderDisabled, '#424242');
    });

    test('Primary 色板（blue dark 映射）', () {
      // 暗色覆盖: colorPrimaryBg = colorPrimaryBorder
      expect(css.colorPrimaryBg, '#15325b');
      expect(css.colorPrimaryBgHover, '#15417e');
      expect(css.colorPrimaryBorder, '#15325b');
      expect(css.colorPrimaryBorderHover, '#15417e');
      expect(css.colorPrimaryHover, '#3c89e8');
      expect(css.colorPrimary, '#1668dc');
      expect(css.colorPrimaryActive, '#1554ad');
      expect(css.colorPrimaryTextHover, '#3c89e8');
      expect(css.colorPrimaryText, '#1668dc');
      expect(css.colorPrimaryTextActive, '#1554ad');
    });

    test('Success 色板（green dark 映射）', () {
      expect(css.colorSuccessBg, '#162312');
      expect(css.colorSuccessBgHover, '#1d3712');
      expect(css.colorSuccessBorder, '#274916');
      expect(css.colorSuccessBorderHover, '#306317');
      expect(css.colorSuccessHover, '#306317');
      expect(css.colorSuccess, '#49aa19');
      expect(css.colorSuccessActive, '#3c8618');
    });

    test('Warning 色板（gold dark 映射）', () {
      expect(css.colorWarningBg, '#2b2111');
      expect(css.colorWarningBgHover, '#443111');
      expect(css.colorWarningBorder, '#594214');
      expect(css.colorWarningBorderHover, '#7c5914');
      expect(css.colorWarningHover, '#7c5914');
      expect(css.colorWarning, '#d89614');
      expect(css.colorWarningActive, '#aa7714');
    });

    test('Error 色板（red dark from #ff4d4f）', () {
      expect(css.colorErrorBg, '#2c1618');
      expect(css.colorErrorBgHover, '#451d1f');
      expect(css.colorErrorBgHoverFilled, '#622627');
      expect(css.colorErrorBgActive, '#5b2526');
      expect(css.colorErrorBorder, '#5b2526');
      expect(css.colorErrorBorderHover, '#7e2e2f');
      expect(css.colorErrorHover, '#e86e6b');
      expect(css.colorError, '#dc4446');
      expect(css.colorErrorActive, '#ad393a');
    });

    test('Info/Link', () {
      expect(css.colorInfoBg, '#111a2c');
      expect(css.colorInfo, '#1668dc');
      expect(css.colorLink, '#1668dc');
      expect(css.colorLinkHover, '#15417e');
      expect(css.colorLinkActive, '#1554ad');
    });

    test('别名令牌', () {
      expect(css.colorFillContent, 'rgba(255,255,255,0.12)');
      expect(css.colorFillContentHover, 'rgba(255,255,255,0.18)');
      expect(css.colorFillAlter, 'rgba(255,255,255,0.04)');
      expect(css.colorBgContainerDisabled, 'rgba(255,255,255,0.08)');
      expect(css.colorBorderBg, '#141414');
      expect(css.colorSplit, 'rgba(253,253,253,0.12)');
      expect(css.colorTextPlaceholder, 'rgba(255,255,255,0.25)');
      expect(css.colorTextDisabled, 'rgba(255,255,255,0.25)');
      expect(css.colorTextHeading, 'rgba(255,255,255,0.85)');
      expect(css.colorTextLabel, 'rgba(255,255,255,0.65)');
      expect(css.colorTextDescription, 'rgba(255,255,255,0.45)');
      expect(css.colorTextLightSolid, '#fff');
      expect(css.colorHighlight, '#dc4446');
      expect(css.colorBgTextHover, 'rgba(255,255,255,0.12)');
      expect(css.colorBgTextActive, 'rgba(255,255,255,0.18)');
      expect(css.colorIcon, 'rgba(255,255,255,0.45)');
      expect(css.colorIconHover, 'rgba(255,255,255,0.85)');
      expect(css.colorErrorOutline, 'rgba(238,38,56,0.11)');
      expect(css.colorWarningOutline, 'rgba(173,107,0,0.15)');
      expect(css.colorErrorAffix, '#dc4446');
      expect(css.colorWarningAffix, '#d89614');
      expect(css.controlItemBgHover, 'rgba(255,255,255,0.08)');
      expect(css.controlItemBgActive, '#15325b');
      expect(css.controlItemBgActiveHover, '#15417e');
      expect(css.controlItemBgActiveDisabled, 'rgba(255,255,255,0.18)');
      expect(css.controlTmpOutline, 'rgba(255,255,255,0.04)');
      expect(css.controlOutline, 'rgba(23,117,249,0.31)');
    });
  });

  // ================================================================
  // Color getter 验证
  // ================================================================
  group('Color getter', () {
    test('亮色 colorPrimary 解析', () {
      final t = AntColorTokens.light(const AntSeedToken());
      // #1677ff → ARGB(255, 0x16, 0x77, 0xff)
      expect(t.colorPrimary, const Color.fromARGB(255, 0x16, 0x77, 0xFF));
    });

    test('亮色 colorText 解析（带透明度）', () {
      final t = AntColorTokens.light(const AntSeedToken());
      // rgba(0,0,0,0.88) → alpha = (0.88*255).round() = 224
      expect(t.colorText, const Color.fromARGB(224, 0, 0, 0));
    });

    test('暗色 colorPrimary 解析', () {
      final t = AntColorTokens.dark(AntSeedToken.dark());
      // #1668dc → ARGB(255, 0x16, 0x68, 0xdc)
      expect(t.colorPrimary, const Color.fromARGB(255, 0x16, 0x68, 0xDC));
    });

    test('暗色 colorShadow 解析', () {
      final t = AntColorTokens.dark(AntSeedToken.dark());
      // rgba(255, 255, 255, 0.2) → alpha = (0.2*255).round() = 51
      expect(t.colorShadow, const Color.fromARGB(51, 255, 255, 255));
    });
  });
}