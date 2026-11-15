import 'package:flutter_test/flutter_test.dart';
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  group('antGenFontSizes（对齐 antd genFontSizes）', () {
    test('fontSize=14 生成 10 阶字号表', () {
      final pairs = antGenFontSizes(14);
      expect(pairs.length, 10);

      final sizes = pairs.map((p) => p.size).toList();
      // 对齐 antd 快照: [12, 14, 16, 20, 24, 30, 38, 46, 56, 68]
      expect(sizes[0], 12); // fontSizeSM
      expect(sizes[1], 14); // fontSize (base)
      expect(sizes[2], 16); // fontSizeLG
      expect(sizes[3], 20); // fontSizeXL
      expect(sizes[4], 24); // fontSizeHeading3
      expect(sizes[5], 30); // fontSizeHeading2
      expect(sizes[6], 38); // fontSizeHeading1
      expect(sizes[7], 46);
      expect(sizes[8], 56);
      expect(sizes[9], 68);
    });

    test('行高公式 (fontSize + 8) / fontSize', () {
      final pairs = antGenFontSizes(14);
      expect(pairs[1].lineHeight, closeTo(22 / 14, 1e-10));
      expect(pairs[0].lineHeight, closeTo(20 / 12, 1e-10));
      expect(pairs[2].lineHeight, closeTo(24 / 16, 1e-10));
    });

    test('fontSize=12 基准', () {
      final pairs = antGenFontSizes(12);
      final sizes = pairs.map((p) => p.size).toList();
      expect(sizes[0], 10);
      expect(sizes[1], 12);
      expect(sizes[2], 14);
    });
  });

  group('antGenFontMapToken（对齐 antd genFontMapToken）', () {
    test('fontSize=14 映射令牌', () {
      final t = antGenFontMapToken(14);
      expect(t.fontSizeSM, 12);
      expect(t.fontSize, 14);
      expect(t.fontSizeLG, 16);
      expect(t.fontSizeXL, 20);
      expect(t.fontSizeHeading1, 38);
      expect(t.fontSizeHeading2, 30);
      expect(t.fontSizeHeading3, 24);
      expect(t.fontSizeHeading4, 20);
      expect(t.fontSizeHeading5, 16);
    });

    test('行高', () {
      final t = antGenFontMapToken(14);
      expect(t.lineHeight, closeTo(22 / 14, 1e-10));
      expect(t.lineHeightSM, closeTo(20 / 12, 1e-10));
      expect(t.lineHeightLG, closeTo(24 / 16, 1e-10));
    });

    test('fontHeight = round(lineHeight * fontSize)', () {
      final t = antGenFontMapToken(14);
      expect(t.fontHeight, 22);
      expect(t.fontHeightSM, 20);
      expect(t.fontHeightLG, 24);
    });

    test('heading 行高', () {
      final t = antGenFontMapToken(14);
      expect(t.lineHeightHeading1, closeTo((38 + 8) / 38, 1e-10));
      expect(t.lineHeightHeading5, closeTo((16 + 8) / 16, 1e-10));
    });
  });

  group('antGenRadius（对齐 antd genRadius）', () {
    test('borderRadius=6（默认）', () {
      final t = antGenRadius(6);
      expect(t.borderRadius, 6);
      expect(t.borderRadiusLG, 8);
      expect(t.borderRadiusSM, 4);
      expect(t.borderRadiusXS, 2);
      expect(t.borderRadiusOuter, 4);
    });

    test('borderRadius=2', () {
      final t = antGenRadius(2);
      expect(t.borderRadius, 2);
      expect(t.borderRadiusXS, 1);
      expect(t.borderRadiusOuter, 2); // 不满足 >4 条件，保持原值
    });

    test('borderRadius=10', () {
      final t = antGenRadius(10);
      expect(t.borderRadiusLG, 12);
      expect(t.borderRadiusSM, 6);
      expect(t.borderRadiusXS, 2);
      expect(t.borderRadiusOuter, 6);
    });

    test('borderRadius=20（>=16 上限）', () {
      final t = antGenRadius(20);
      expect(t.borderRadiusLG, 16);
      expect(t.borderRadiusSM, 8);
      expect(t.borderRadiusXS, 2);
      expect(t.borderRadiusOuter, 6);
    });
  });

  group('antGenSizeMapToken（对齐 antd genSizeMapToken）', () {
    test('sizeUnit=4, sizeStep=4（默认）', () {
      final t = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
      expect(t.sizeXXL, 48);
      expect(t.sizeXL, 32);
      expect(t.sizeLG, 24);
      expect(t.sizeMD, 20);
      expect(t.sizeMS, 16);
      expect(t.size, 16);
      expect(t.sizeSM, 12);
      expect(t.sizeXS, 8);
      expect(t.sizeXXS, 4);
    });

    test('sizeUnit=2, sizeStep=5', () {
      final t = antGenSizeMapToken(sizeUnit: 2, sizeStep: 5);
      expect(t.sizeXXL, 2 * (5 + 8)); // 26
      expect(t.size, 2 * 5); // 10
      expect(t.sizeXXS, 2 * (5 - 3)); // 4
    });
  });

  group('antGenControlHeight（对齐 antd genControlHeight）', () {
    test('controlHeight=32（默认）', () {
      final t = antGenControlHeight(32);
      expect(t.controlHeightSM, 24);
      expect(t.controlHeightXS, 16);
      expect(t.controlHeightLG, 40);
    });

    test('controlHeight=40', () {
      final t = antGenControlHeight(40);
      expect(t.controlHeightSM, 30);
      expect(t.controlHeightXS, 20);
      expect(t.controlHeightLG, 50);
    });
  });

  group('antGenMotionDuration（对齐 antd formatToken motion 逻辑）', () {
    test('motion=true（默认）', () {
      final t = antGenMotionDuration(
        motionUnit: 0.1,
        motionBase: 0,
        motion: true,
      );
      expect(t.fast, 0.1);
      expect(t.mid, 0.2);
      expect(t.slow, 0.3);
    });

    test('motion=false 全部归零', () {
      final t = antGenMotionDuration(
        motionUnit: 0.1,
        motionBase: 0,
        motion: false,
      );
      expect(t.fast, 0);
      expect(t.mid, 0);
      expect(t.slow, 0);
    });

    test('自定义 motionBase', () {
      final t = antGenMotionDuration(
        motionUnit: 0.15,
        motionBase: 0.1,
        motion: true,
      );
      // antd 用 toFixed(1)：0.25→'0.3'（半值取大）、0.4→'0.4'、
      // 0.1+0.15*3=0.54999...（浮点）→'0.5'
      expect(t.fast, closeTo(0.3, 1e-10));
      expect(t.mid, closeTo(0.4, 1e-10));
      expect(t.slow, closeTo(0.5, 1e-10));
    });
  });
}