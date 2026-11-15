/// Ant Design 色板生成算法。
///
/// 精确移植 `@ant-design/colors` 的 `generate` 函数，
/// 从单一种子色生成 10 阶色板（浅→深），并支持暗色主题映射。
library;

import 'ant_fast_color.dart';

/// 色相阶梯
const double _hueStep = 2;

/// 饱和度阶梯，浅色部分
const double _saturationStep = 0.16;

/// 饱和度阶梯，深色部分
const double _saturationStep2 = 0.05;

/// 亮度阶梯，浅色部分
const double _brightnessStep1 = 0.05;

/// 亮度阶梯，深色部分
const double _brightnessStep2 = 0.15;

/// 浅色数量（主色之上）
const int _lightColorCount = 5;

/// 深色数量（主色之下）
const int _darkColorCount = 4;

/// 暗色主题颜色映射关系表
///
/// 每项 {index, amount} 表示将亮色色板的第 index 位颜色
/// 与暗色背景色按 amount% 混合。
const List<MapEntry<int, double>> _darkColorMap = [
  MapEntry(7, 15),
  MapEntry(6, 25),
  MapEntry(5, 30),
  MapEntry(5, 45),
  MapEntry(5, 65),
  MapEntry(5, 85),
  MapEntry(4, 90),
  MapEntry(3, 95),
  MapEntry(2, 97),
  MapEntry(1, 98),
];

double _getHue(AntHsv hsv, int i, {bool light = false}) {
  double hue;
  final rounded = hsv.h.round();
  if (rounded >= 60 && rounded <= 240) {
    hue = light
        ? (rounded - _hueStep * i)
        : (rounded + _hueStep * i);
  } else {
    hue = light
        ? (rounded + _hueStep * i)
        : (rounded - _hueStep * i);
  }
  if (hue < 0) {
    hue += 360;
  } else if (hue >= 360) {
    hue -= 360;
  }
  return hue;
}

double _getSaturation(AntHsv hsv, int i, {bool light = false}) {
  // 灰度色饱和度不变
  if (hsv.h == 0 && hsv.s == 0) {
    return hsv.s;
  }

  double saturation;
  if (light) {
    saturation = hsv.s - _saturationStep * i;
  } else if (i == _darkColorCount) {
    saturation = hsv.s + _saturationStep;
  } else {
    saturation = hsv.s + _saturationStep2 * i;
  }

  // 边界值修正
  if (saturation > 1) {
    saturation = 1;
  }
  // 第一格的 s 限制在 0.06-0.1 之间
  if (light && i == _lightColorCount && saturation > 0.1) {
    saturation = 0.1;
  }
  if (saturation < 0.06) {
    saturation = 0.06;
  }
  return (saturation * 100).round() / 100;
}

double _getValue(AntHsv hsv, int i, {bool light = false}) {
  double value;
  if (light) {
    value = hsv.v + _brightnessStep1 * i;
  } else {
    value = hsv.v - _brightnessStep2 * i;
  }
  value = value.clamp(0.0, 1.0);
  return (value * 100).round() / 100;
}

/// 色板生成选项。
class AntPaletteOptions {
  /// 主题模式：`dark` 或 `default`。
  final String theme;

  /// 暗色主题背景色（默认 `#141414`）。
  final String? backgroundColor;

  const AntPaletteOptions({this.theme = 'default', this.backgroundColor});
}

/// 从单一种子色生成 10 阶色板。
///
/// 与 `@ant-design/colors` 的 `generate` 函数行为完全一致。
///
/// - [color] 种子色（hex 字符串或 [AntFastColor]）。
/// - [opts] 可选参数，指定暗色主题及背景色。
///
/// 返回长度为 10 的 hex 字符串列表，索引 0-9 对应 antd 的 palette 1-10。
List<String> antGeneratePalette(Object color, [AntPaletteOptions? opts]) {
  final patterns = <AntFastColor>[];
  final pColor = AntFastColor.of(color);
  final hsv = pColor.toHsv();

  // 浅色部分：从 lightColorCount 到 1
  for (var i = _lightColorCount; i > 0; i--) {
    patterns.add(AntFastColor.fromHsv(
      _getHue(hsv, i, light: true),
      _getSaturation(hsv, i, light: true),
      _getValue(hsv, i, light: true),
    ),);
  }
  // 主色
  patterns.add(pColor);
  // 深色部分：从 1 到 darkColorCount
  for (var i = 1; i <= _darkColorCount; i++) {
    patterns.add(AntFastColor.fromHsv(
      _getHue(hsv, i),
      _getSaturation(hsv, i),
      _getValue(hsv, i),
    ),);
  }

  // 暗色主题映射
  if (opts?.theme == 'dark') {
    final bgColor = opts?.backgroundColor ?? '#141414';
    return _darkColorMap
        .map((entry) => AntFastColor.fromString(bgColor)
            .mix(patterns[entry.key], entry.value)
            .toHexString(),)
        .toList();
  }

  return patterns.map((c) => c.toHexString()).toList();
}

// ============================================================
// 预设色板（与 antd presetColors 对齐）
// ============================================================

/// Ant Design 预设主色种子值。
///
/// 与 antd `components/theme/themes/seed.ts` 中的 `presetColors` 一致。
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
/// 返回 `Map<String, List<String>>`，键为色名，每个值为 10 阶色板。
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