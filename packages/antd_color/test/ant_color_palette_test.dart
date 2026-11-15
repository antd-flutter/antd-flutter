/// 色板生成单元测试。
///
/// 断言值取自 `@ant-design/colors` v7.x Jest 快照
/// `tests/__snapshots__/presets.test.ts.snap`，与 antd v6.7.0 一致。
library;

import 'package:antd_color/antd_color.dart';
import 'package:flutter_test/flutter_test.dart';

/// antd 快照：亮色 blue 色板
const List<String> kBlueLight = [
  '#e6f4ff', '#bae0ff', '#91caff', '#69b1ff', '#4096ff',
  '#1677ff', '#0958d9', '#003eb3', '#002c8c', '#001d66',
];

/// antd 快照：暗色 blue 色板
const List<String> kBlueDark = [
  '#111a2c', '#112545', '#15325b', '#15417e', '#1554ad',
  '#1668dc', '#3c89e8', '#65a9f3', '#8dc5f8', '#b7dcfa',
];

/// antd 快照：亮色 red 色板
const List<String> kRedLight = [
  '#fff1f0', '#ffccc7', '#ffa39e', '#ff7875', '#ff4d4f',
  '#f5222d', '#cf1322', '#a8071a', '#820014', '#5c0011',
];

/// antd 快照：亮色 green 色板
const List<String> kGreenLight = [
  '#f6ffed', '#d9f7be', '#b7eb8f', '#95de64', '#73d13d',
  '#52c41a', '#389e0d', '#237804', '#135200', '#092b00',
];

/// antd 快照：亮色 gold 色板
const List<String> kGoldLight = [
  '#fffbe6', '#fff1b8', '#ffe58f', '#ffd666', '#ffc53d',
  '#faad14', '#d48806', '#ad6800', '#874d00', '#613400',
];

/// antd 快照：亮色 grey 色板
const List<String> kGreyLight = [
  '#a6a6a6', '#999999', '#8c8c8c', '#808080', '#737373',
  '#666666', '#404040', '#1a1a1a', '#000000', '#000000',
];

/// antd 快照：暗色 grey 色板
const List<String> kGreyDark = [
  '#151515', '#1f1f1f', '#2d2d2d', '#393939', '#494949',
  '#5a5a5a', '#6a6a6a', '#7b7b7b', '#888888', '#969696',
];

void main() {
  group('antGeneratePalette - 亮色主题', () {
    test('blue 色板与快照一致', () {
      final palette = antGeneratePalette('#1677FF');
      expect(palette, kBlueLight);
    });

    test('red 色板与快照一致', () {
      final palette = antGeneratePalette('#F5222D');
      expect(palette, kRedLight);
    });

    test('green 色板与快照一致', () {
      final palette = antGeneratePalette('#52C41A');
      expect(palette, kGreenLight);
    });

    test('gold 色板与快照一致', () {
      final palette = antGeneratePalette('#FAAD14');
      expect(palette, kGoldLight);
    });

    test('grey 色板与快照一致', () {
      final palette = antGeneratePalette('#666666');
      expect(palette, kGreyLight);
    });

    test('输出长度恒为 10', () {
      expect(antGeneratePalette('#1677FF').length, 10);
      expect(antGeneratePalette('#722ED1').length, 10);
    });

    test('主色位于索引 5（第 6 阶）', () {
      final palette = antGeneratePalette('#1677FF');
      expect(palette[5], '#1677ff');
    });
  });

  group('antGeneratePalette - 暗色主题', () {
    test('blue 暗色色板与快照一致', () {
      final palette = antGeneratePalette(
        '#1677FF',
        const AntPaletteOptions(theme: 'dark'),
      );
      expect(palette, kBlueDark);
    });

    test('grey 暗色色板与快照一致', () {
      final palette = antGeneratePalette(
        '#666666',
        const AntPaletteOptions(theme: 'dark'),
      );
      expect(palette, kGreyDark);
    });

    test('暗色自定义背景色', () {
      final palette = antGeneratePalette(
        '#1677FF',
        const AntPaletteOptions(theme: 'dark', backgroundColor: '#141414'),
      );
      expect(palette, kBlueDark);
    });
  });

  group('antGeneratePresetPalettes - 全量预设', () {
    test('亮色全量与快照 presetPalettes 一致', () {
      final palettes = antGeneratePresetPalettes();
      // 抽样断言关键色（antd defaultPresetColors 不含 grey，grey 在主题层单独生成）
      expect(palettes['blue'], kBlueLight);
      expect(palettes['red'], kRedLight);
      expect(palettes['green'], kGreenLight);
      expect(palettes['gold'], kGoldLight);
      // 全部 13 色（含 deprecated pink）
      expect(palettes.length, 13);
      for (final entry in palettes.entries) {
        expect(entry.value.length, 10, reason: '${entry.key} 色板长度应为 10');
      }
    });

    test('暗色全量与快照 presetDarkPalettes 一致', () {
      final palettes = antGeneratePresetPalettes(dark: true);
      expect(palettes['blue'], kBlueDark);
      expect(palettes.length, 13);
    });
  });

  group('AntPresetColors - 种子值', () {
    test('种子值与 antd defaultPresetColors 一致', () {
      expect(AntPresetColors.blue, '#1677FF');
      expect(AntPresetColors.purple, '#722ED1');
      expect(AntPresetColors.cyan, '#13C2C2');
      expect(AntPresetColors.green, '#52C41A');
      expect(AntPresetColors.magenta, '#EB2F96');
      expect(AntPresetColors.pink, '#EB2F96'); // deprecated = magenta
      expect(AntPresetColors.red, '#F5222D');
      expect(AntPresetColors.orange, '#FA8C16');
      expect(AntPresetColors.yellow, '#FADB14');
      expect(AntPresetColors.volcano, '#FA541C');
      expect(AntPresetColors.geekblue, '#2F54EB');
      expect(AntPresetColors.gold, '#FAAD14');
      expect(AntPresetColors.lime, '#A0D911');
      expect(AntPresetColors.all.length, 13);
    });
  });
}