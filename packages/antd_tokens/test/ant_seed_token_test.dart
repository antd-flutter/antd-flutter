import 'package:flutter_test/flutter_test.dart';
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  group('AntSeedToken 默认值（对齐 antd seed.ts）', () {
    const seed = AntSeedToken();

    test('颜色种子', () {
      expect(seed.colorPrimary, '#1677ff');
      expect(seed.colorSuccess, '#52c41a');
      expect(seed.colorWarning, '#faad14');
      expect(seed.colorError, '#ff4d4f');
      expect(seed.colorInfo, '#1677ff');
      expect(seed.colorLink, '');
      expect(seed.colorTextBase, '');
      expect(seed.colorBgBase, '');
      expect(seed.colorShadow, '');
    });

    test('字体', () {
      expect(seed.fontSize, 14);
      expect(seed.fontFamily,
          "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'",);
      expect(seed.fontFamilyCode,
          "'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace",);
    });

    test('线宽/线型', () {
      expect(seed.lineWidth, 1);
      expect(seed.lineType, 'solid');
    });

    test('动效', () {
      expect(seed.motionUnit, 0.1);
      expect(seed.motionBase, 0);
      expect(seed.motion, true);
      expect(seed.motionEaseOutCirc, 'cubic-bezier(0.08, 0.82, 0.17, 1)');
      expect(seed.motionEaseInOutCirc, 'cubic-bezier(0.78, 0.14, 0.15, 0.86)');
      expect(seed.motionEaseOut, 'cubic-bezier(0.215, 0.61, 0.355, 1)');
      expect(seed.motionEaseInOut, 'cubic-bezier(0.645, 0.045, 0.355, 1)');
    });

    test('圆角/尺寸/控件', () {
      expect(seed.borderRadius, 6);
      expect(seed.sizeUnit, 4);
      expect(seed.sizeStep, 4);
      expect(seed.sizePopupArrow, 16);
      expect(seed.controlHeight, 32);
    });

    test('Z-Index/杂项', () {
      expect(seed.zIndexBase, 0);
      expect(seed.zIndexPopupBase, 1000);
      expect(seed.opacityImage, 1);
      expect(seed.wireframe, false);
      expect(seed.focusOutline, true);
    });
  });

  group('AntSeedToken.dark() 工厂', () {
    test('暗色种子覆盖', () {
      final dark = AntSeedToken.dark();
      // colorPrimary 保持不变，暗色主色由色板算法生成
      expect(dark.colorPrimary, '#1677ff');
      expect(dark.colorTextBase, '#fff');
      expect(dark.colorBgBase, '#000');
      expect(dark.colorShadow, 'rgba(255, 255, 255, 0.2)');
      // 其余值应与默认一致
      expect(dark.colorSuccess, '#52c41a');
      expect(dark.fontSize, 14);
      expect(dark.borderRadius, 6);
      expect(dark.controlHeight, 32);
    });

    test('暗色种子可自定义中性色', () {
      final dark = AntSeedToken.dark(colorTextBase: '#f0f0f0');
      expect(dark.colorTextBase, '#f0f0f0');
      expect(dark.colorBgBase, '#000');
    });
  });

  group('AntSeedToken.copyWith', () {
    test('覆盖部分值', () {
      const seed = AntSeedToken();
      final modified = seed.copyWith(
        colorPrimary: '#ff6600',
        fontSize: 16,
        borderRadius: 8,
      );
      expect(modified.colorPrimary, '#ff6600');
      expect(modified.fontSize, 16);
      expect(modified.borderRadius, 8);
      // 未覆盖的值保持不变
      expect(modified.colorSuccess, '#52c41a');
      expect(modified.controlHeight, 32);
    });
  });
}