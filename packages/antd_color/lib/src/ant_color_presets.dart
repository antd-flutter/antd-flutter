/// Ant Design 预设色板。
///
/// 与 antd `presetColors` 对齐的预设主色种子值，
/// 及基于种子批量生成全量预设色板的工具函数。
///
/// @docImport 'ant_color_palette.dart';
/// @docImport 'config/ant_palette_options.dart';
library;

import 'ant_color_palette.dart';
import 'config/ant_palette_options.dart';

/// Ant Design 预设主色种子值。
///
/// 与 antd `components/theme/themes/seed.ts` 中的 `presetColors` 一致。
/// 每个常量为该预设色的种子 hex 值，可直接传给 [antGeneratePalette]
/// 或 `AntColor.fromSeed` 生成对应色板。
///
/// ```dart
/// final palette = antGeneratePalette(AntPresetColors.blue);
/// ```
class AntPresetColors {
  AntPresetColors._();

  static const String blue = '#1677FF';
  static const String purple = '#722ED1';
  static const String cyan = '#13C2C2';
  static const String green = '#52C41A';
  static const String magenta = '#EB2F96';
  /// pink 已废弃，等同 magenta。
  static const String pink = '#EB2F96';
  static const String red = '#F5222D';
  static const String orange = '#FA8C16';
  static const String yellow = '#FADB14';
  static const String volcano = '#FA541C';
  static const String geekblue = '#2F54EB';
  static const String gold = '#FAAD14';
  static const String lime = '#A0D911';

  /// 所有预设色名 → 种子值映射。
  static const Map<String, String> all = {
    'blue': blue,
    'purple': purple,
    'cyan': cyan,
    'green': green,
    'magenta': magenta,
    'pink': pink,
    'red': red,
    'orange': orange,
    'yellow': yellow,
    'volcano': volcano,
    'geekblue': geekblue,
    'gold': gold,
    'lime': lime,
  };
}

/// 生成所有预设色板。
///
/// [dark] 为 `true` 时生成暗色主题色板；[darkBackground] 为暗色背景色，
/// `null` 时使用 antd 默认暗色背景 `#141414`。
///
/// 返回 `Map<String, List<String>>`，键为色名，每个值为 10 阶色板
/// （索引 0-9 对应 antd palette 1-10）。
///
/// ```dart
/// final all = antGeneratePresetPalettes();
/// print(all['blue']![5]); // '#1677ff'
/// ```
Map<String, List<String>> antGeneratePresetPalettes({
  bool dark = false,
  String? darkBackground,
}) {
  return AntPresetColors.all.map((name, seed) {
    final palette = antGeneratePalette(
      seed,
      AntPaletteOptions(
        theme: dark ? 'dark' : 'default',
        backgroundColor: darkBackground,
      ),
    );
    return MapEntry(name, palette);
  });
}
