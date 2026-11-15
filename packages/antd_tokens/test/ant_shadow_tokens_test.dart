// ignore_for_file: lines_longer_than_80_chars
/// AntShadowTokens 单元测试 — 阴影层数和参数与 antd v6 alias.ts 逐一断言对齐。
library;

import 'dart:ui';

import 'package:antd_tokens/antd_tokens.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================================================================
  // 亮色主题（colorShadow = '#000', baseAlpha = 1.0）
  // ================================================================
  group('AntShadowTokens.light', () {
    final t = AntShadowTokens.generate('#000');

    test('boxShadow 3 层结构', () {
      expect(t.boxShadow, hasLength(3));
      // 0 6px 16px 0 rgba(0,0,0,0.08)
      expect(t.boxShadow[0].offset, const Offset(0, 6));
      expect(t.boxShadow[0].blurRadius, 16);
      expect(t.boxShadow[0].spreadRadius, 0);
      expect(t.boxShadow[0].color, const Color.fromARGB(20, 0, 0, 0));
      // 0 3px 6px -4px rgba(0,0,0,0.12)
      expect(t.boxShadow[1].offset, const Offset(0, 3));
      expect(t.boxShadow[1].blurRadius, 6);
      expect(t.boxShadow[1].spreadRadius, -4);
      expect(t.boxShadow[1].color, const Color.fromARGB(31, 0, 0, 0));
      // 0 9px 28px 8px rgba(0,0,0,0.05)
      expect(t.boxShadow[2].offset, const Offset(0, 9));
      expect(t.boxShadow[2].blurRadius, 28);
      expect(t.boxShadow[2].spreadRadius, 8);
      expect(t.boxShadow[2].color, const Color.fromARGB(13, 0, 0, 0));
    });

    test('boxShadowSecondary 与 boxShadow 一致', () {
      expect(t.boxShadowSecondary, equals(t.boxShadow));
    });

    test('boxShadowTertiary 3 层结构', () {
      expect(t.boxShadowTertiary, hasLength(3));
      // 0 1px 2px 0 rgba(0,0,0,0.05)
      expect(t.boxShadowTertiary[0].offset, const Offset(0, 1));
      expect(t.boxShadowTertiary[0].blurRadius, 2);
      expect(t.boxShadowTertiary[0].spreadRadius, 0);
      expect(t.boxShadowTertiary[0].color, const Color.fromARGB(13, 0, 0, 0));
      // 0 1px 6px -1px rgba(0,0,0,0.03)
      expect(t.boxShadowTertiary[1].offset, const Offset(0, 1));
      expect(t.boxShadowTertiary[1].blurRadius, 6);
      expect(t.boxShadowTertiary[1].spreadRadius, -1);
      expect(t.boxShadowTertiary[1].color, const Color.fromARGB(8, 0, 0, 0));
      // 0 2px 4px 0 rgba(0,0,0,0.03)
      expect(t.boxShadowTertiary[2].offset, const Offset(0, 2));
      expect(t.boxShadowTertiary[2].blurRadius, 4);
      expect(t.boxShadowTertiary[2].spreadRadius, 0);
      expect(t.boxShadowTertiary[2].color, const Color.fromARGB(8, 0, 0, 0));
    });

    test('boxShadowPopoverArrow 1 层', () {
      expect(t.boxShadowPopoverArrow, hasLength(1));
      // 2px 2px 5px rgba(0,0,0,0.05)
      expect(t.boxShadowPopoverArrow[0].offset, const Offset(2, 2));
      expect(t.boxShadowPopoverArrow[0].blurRadius, 5);
      expect(t.boxShadowPopoverArrow[0].spreadRadius, 0);
      expect(t.boxShadowPopoverArrow[0].color, const Color.fromARGB(13, 0, 0, 0));
    });

    test('boxShadowCard 3 层结构', () {
      expect(t.boxShadowCard, hasLength(3));
      // 0 1px 2px -2px rgba(0,0,0,0.16)
      expect(t.boxShadowCard[0].offset, const Offset(0, 1));
      expect(t.boxShadowCard[0].blurRadius, 2);
      expect(t.boxShadowCard[0].spreadRadius, -2);
      expect(t.boxShadowCard[0].color, const Color.fromARGB(41, 0, 0, 0));
      // 0 3px 6px 0 rgba(0,0,0,0.12)
      expect(t.boxShadowCard[1].offset, const Offset(0, 3));
      expect(t.boxShadowCard[1].blurRadius, 6);
      expect(t.boxShadowCard[1].spreadRadius, 0);
      expect(t.boxShadowCard[1].color, const Color.fromARGB(31, 0, 0, 0));
      // 0 5px 12px 4px rgba(0,0,0,0.09)
      expect(t.boxShadowCard[2].offset, const Offset(0, 5));
      expect(t.boxShadowCard[2].blurRadius, 12);
      expect(t.boxShadowCard[2].spreadRadius, 4);
      expect(t.boxShadowCard[2].color, const Color.fromARGB(23, 0, 0, 0));
    });

    test('Drawer 方向阴影', () {
      // Right: -6px 0 / -3px 0 / -9px 0
      expect(t.boxShadowDrawerRight, hasLength(3));
      expect(t.boxShadowDrawerRight[0].offset, const Offset(-6, 0));
      expect(t.boxShadowDrawerRight[1].offset, const Offset(-3, 0));
      expect(t.boxShadowDrawerRight[2].offset, const Offset(-9, 0));
      // Left: 6px 0 / 3px 0 / 9px 0
      expect(t.boxShadowDrawerLeft, hasLength(3));
      expect(t.boxShadowDrawerLeft[0].offset, const Offset(6, 0));
      expect(t.boxShadowDrawerLeft[1].offset, const Offset(3, 0));
      expect(t.boxShadowDrawerLeft[2].offset, const Offset(9, 0));
      // Up = popup
      expect(t.boxShadowDrawerUp, equals(t.boxShadow));
      // Down: 0 -6px / 0 -3px / 0 -9px
      expect(t.boxShadowDrawerDown, hasLength(3));
      expect(t.boxShadowDrawerDown[0].offset, const Offset(0, -6));
      expect(t.boxShadowDrawerDown[1].offset, const Offset(0, -3));
      expect(t.boxShadowDrawerDown[2].offset, const Offset(0, -9));
    });

    test('Tabs 溢出阴影（inset 近似）', () {
      expect(t.boxShadowTabsOverflowLeft, hasLength(1));
      expect(t.boxShadowTabsOverflowLeft[0].offset, const Offset(10, 0));
      expect(t.boxShadowTabsOverflowLeft[0].blurRadius, 8);
      expect(t.boxShadowTabsOverflowLeft[0].spreadRadius, -8);
      expect(t.boxShadowTabsOverflowRight[0].offset, const Offset(-10, 0));
      expect(t.boxShadowTabsOverflowTop[0].offset, const Offset(0, 10));
      expect(t.boxShadowTabsOverflowBottom[0].offset, const Offset(0, -10));
    });
  });

  // ================================================================
  // 暗色主题（colorShadow = 'rgba(255, 255, 255, 0.2)', baseAlpha = 0.2）
  // ================================================================
  group('AntShadowTokens.dark', () {
    final t = AntShadowTokens.generate('rgba(255, 255, 255, 0.2)');

    test('boxShadow 颜色 alpha 经过 _formatAlpha 精度对齐', () {
      expect(t.boxShadow, hasLength(3));
      // 0.2*0.08=0.016 → formatAlpha=0.02 → alpha byte=(0.02*255).round()=5
      expect(t.boxShadow[0].color, const Color.fromARGB(5, 255, 255, 255));
      // 0.2*0.12=0.024 → formatAlpha=0.02 → alpha byte=5
      expect(t.boxShadow[1].color, const Color.fromARGB(5, 255, 255, 255));
      // 0.2*0.05=0.01 → formatAlpha=0.01 → alpha byte=(0.01*255).round()=3
      expect(t.boxShadow[2].color, const Color.fromARGB(3, 255, 255, 255));
    });

    test('boxShadowCard 颜色', () {
      // 0.2*0.16=0.032 → formatAlpha=0.03 → alpha byte=8
      expect(t.boxShadowCard[0].color, const Color.fromARGB(8, 255, 255, 255));
      // 0.2*0.12=0.024 → formatAlpha=0.02 → alpha byte=5
      expect(t.boxShadowCard[1].color, const Color.fromARGB(5, 255, 255, 255));
      // 0.2*0.09=0.018 → formatAlpha=0.02 → alpha byte=5
      expect(t.boxShadowCard[2].color, const Color.fromARGB(5, 255, 255, 255));
    });

    test('boxShadowTertiary 颜色', () {
      // 0.2*0.05=0.01 → 3
      expect(t.boxShadowTertiary[0].color, const Color.fromARGB(3, 255, 255, 255));
      // 0.2*0.03=0.006 → formatAlpha=0.01 → 3
      expect(t.boxShadowTertiary[1].color, const Color.fromARGB(3, 255, 255, 255));
      expect(t.boxShadowTertiary[2].color, const Color.fromARGB(3, 255, 255, 255));
    });

    test('几何参数与亮色一致', () {
      expect(t.boxShadow[0].offset, const Offset(0, 6));
      expect(t.boxShadow[0].blurRadius, 16);
      expect(t.boxShadow[0].spreadRadius, 0);
      expect(t.boxShadowDrawerRight[0].offset, const Offset(-6, 0));
      expect(t.boxShadowTabsOverflowLeft[0].offset, const Offset(10, 0));
    });
  });
}