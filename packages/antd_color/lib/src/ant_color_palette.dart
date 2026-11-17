/// Ant Design 色板生成算法。
///
/// 精确移植 `@ant-design/colors` 的 `generate` 函数，
/// 从单一种子色生成 10 阶色板（浅→深），并支持暗色主题映射。
///
/// 配置类 [AntPaletteOptions] 拆分至 `config/ant_palette_options.dart`，
/// 预设色板拆分至 `ant_color_presets.dart`。
///
/// @docImport 'config/ant_palette_options.dart';
/// @docImport 'ant_color_presets.dart';
library;

import 'ant_fast_color.dart';
import 'types/ant_color_models.dart';
import 'config/ant_palette_options.dart';

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

/// 从单一种子色生成 10 阶色板。
///
/// 与 `@ant-design/colors` 的 `generate` 函数行为完全一致：
/// 前 5 阶在种子色基础上提升亮度、降低饱和度（浅色），
/// 第 6 阶为种子色本身，后 4 阶降低亮度（深色）。
///
/// [color] 为种子色，支持 hex 字符串（如 `'#1677FF'`）、
/// `rgb()/hsl()/hsv()` 字符串或任意 [AntFastColor] 可接受的输入。
/// [opts] 为可选的 [AntPaletteOptions]，用于指定暗色主题及背景色。
///
/// 返回长度为 10 的 hex 字符串列表，索引 0-9 对应 antd 的 palette 1-10
/// （索引 0 最浅，索引 9 最深）。无法解析的输入按黑色种子处理，不抛出异常。
///
/// ```dart
/// final light = antGeneratePalette('#1677FF');
/// print(light[5]); // 主色 '#1677ff'
///
/// final dark = antGeneratePalette(
///   '#1677FF',
///   AntPaletteOptions(theme: 'dark'),
/// );
/// ```
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
