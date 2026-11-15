/// AntFastColor 单元测试。
///
/// 断言值对齐 `@ant-design/fast-color` 与 antd v6.7.0 源码行为。
library;

import 'package:antd_color/antd_color.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntFastColor.fromString - hex 解析', () {
    test('6 位 hex', () {
      final c = AntFastColor.fromString('#1677ff');
      expect(c.r, 0x16);
      expect(c.g, 0x77);
      expect(c.b, 0xff);
      expect(c.a, 1.0);
    });

    test('3 位 hex 展开', () {
      final c = AntFastColor.fromString('#f53');
      expect(c.r, 0xff);
      expect(c.g, 0x55);
      expect(c.b, 0x33);
    });

    test('8 位 hex 含 alpha', () {
      final c = AntFastColor.fromString('#1677ff80');
      expect(c.r, 0x16);
      expect(c.g, 0x77);
      expect(c.b, 0xff);
      expect(c.a, closeTo(0x80 / 255, 0.001));
    });

    test('无 # 前缀 hex', () {
      final c = AntFastColor.fromString('1677ff');
      expect(c.r, 0x16);
      expect(c.g, 0x77);
      expect(c.b, 0xff);
    });
  });

  group('AntFastColor.fromString - rgb/rgba 解析', () {
    test('rgb()', () {
      final c = AntFastColor.fromString('rgb(22, 119, 255)');
      expect(c.r, 22);
      expect(c.g, 119);
      expect(c.b, 255);
      expect(c.a, 1.0);
    });

    test('rgba()', () {
      final c = AntFastColor.fromString('rgba(0, 0, 0, 0.88)');
      expect(c.r, 0);
      expect(c.g, 0);
      expect(c.b, 0);
      expect(c.a, closeTo(0.88, 0.001));
    });

    test('rgba 百分比 alpha', () {
      final c = AntFastColor.fromString('rgba(255, 255, 255, 45%)');
      expect(c.r, 255);
      expect(c.g, 255);
      expect(c.b, 255);
      expect(c.a, closeTo(0.45, 0.001));
    });
  });

  group('AntFastColor.fromString - hsl/hsv 解析', () {
    test('hsl()', () {
      final c = AntFastColor.fromString('hsl(210, 100%, 50%)');
      expect(c.r, 0);
      expect(c.g, closeTo(128, 1));
      expect(c.b, 255);
    });

    test('hsv()', () {
      final c = AntFastColor.fromString('hsv(210, 100%, 100%)');
      expect(c.r, 0);
      expect(c.g, closeTo(128, 1));
      expect(c.b, 255);
    });
  });

  group('AntFastColor 转换', () {
    test('toHexString 6 位', () {
      final c = AntFastColor.fromRgb(22, 119, 255);
      expect(c.toHexString(), '#1677ff');
    });

    test('toHexString 含 alpha < 1', () {
      final c = AntFastColor.fromRgb(0, 0, 0)..a = 0.88;
      expect(c.toHexString(), '#000000e0');
    });

    test('toRgbString', () {
      final c = AntFastColor.fromRgb(0, 0, 0)..a = 0.88;
      expect(c.toRgbString(), 'rgba(0,0,0,0.88)');
    });

    test('toHsl 往返', () {
      final c = AntFastColor.fromString('#1677ff');
      final hsl = c.toHsl();
      final back = AntFastColor.fromHsl(hsl.h, hsl.s, hsl.l);
      expect(back.r, closeTo(c.r, 2));
      expect(back.g, closeTo(c.g, 2));
      expect(back.b, closeTo(c.b, 2));
    });

    test('toHsv 往返', () {
      final c = AntFastColor.fromString('#52c41a');
      final hsv = c.toHsv();
      final back = AntFastColor.fromHsv(hsv.h, hsv.s, hsv.v);
      expect(back.r, closeTo(c.r, 2));
      expect(back.g, closeTo(c.g, 2));
      expect(back.b, closeTo(c.b, 2));
    });
  });

  group('AntFastColor 操作', () {
    test('darken', () {
      final c = AntFastColor.fromString('#ffffff');
      final dark = c.darken(15);
      expect(dark.r, 217); // 255 * (1 - 0.15) = 216.75 → 217
      expect(dark.toHexString(), '#d9d9d9');
    });

    test('lighten', () {
      final c = AntFastColor.fromString('#000000');
      final light = c.lighten(50);
      expect(light.r, 128); // 0 + 255 * 0.5 = 127.5 → 128
    });

    test('mix', () {
      final white = AntFastColor.fromString('#ffffff');
      final black = AntFastColor.fromString('#000000');
      final mid = white.mix(black, 50);
      expect(mid.r, 128);
      expect(mid.g, 128);
      expect(mid.b, 128);
    });

    test('isDark / isLight', () {
      expect(AntFastColor.fromString('#000000').isDark(), isTrue);
      expect(AntFastColor.fromString('#ffffff').isLight(), isTrue);
      // #1677ff brightness = (22*299+119*587+255*114)/1000 ≈ 105.5 < 128 → dark
      expect(AntFastColor.fromString('#1677ff').isDark(), isTrue);
      // #91caff brightness ≈ 191 ≥ 128 → light
      expect(AntFastColor.fromString('#91caff').isLight(), isTrue);
    });
  });

  group('AntFastColor.of 多态构造', () {
    test('接受 String', () {
      final c = AntFastColor.of('#1677ff');
      expect(c.r, 0x16);
    });

    test('接受 AntFastColor', () {
      final orig = AntFastColor.fromRgb(1, 2, 3);
      final c = AntFastColor.of(orig);
      expect(c.r, 1);
      expect(c.g, 2);
      expect(c.b, 3);
    });
  });
}