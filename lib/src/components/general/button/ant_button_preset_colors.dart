/// AntButton 预设色板解析
///
/// 当 [AntButtonColor] 为预设色（blue/purple/…）时，
/// 使用 antd_color 的色板生成算法动态生成 10 阶色板，
/// 与 antd v6 `variant.ts` 中 `{colorKey}1`~`{colorKey}6` 的取值一致。
library;

import 'package:antd_color/antd_color.dart';
import 'package:flutter/painting.dart';

import 'ant_button_types.dart';

/// 预设色板缓存（亮色主题）。
final Map<AntButtonColor, AntColor> _lightCache = {};

/// 预设色板缓存（暗色主题）。
final Map<AntButtonColor, AntColor> _darkCache = {};

/// 判断 [AntButtonColor] 是否为预设色（非 default/primary/danger）。
bool isPresetColor(AntButtonColor color) {
  return switch (color) {
    AntButtonColor.normal ||
    AntButtonColor.primary ||
    AntButtonColor.danger ||
    AntButtonColor.link =>
      false,
    _ => true,
  };
}

/// 获取预设色板。
///
/// 与 antd 的 `presetColorPalettes` 对齐：
/// - 亮色：`AntColor.fromSeed`（1-7 = raw[0..6]，8-10 = raw[4..6]）
/// - 暗色：`AntColor.fromSeedDark`
AntColor getPresetPalette(AntButtonColor color, {required bool isDark}) {
  final cache = isDark ? _darkCache : _lightCache;
  return cache.putIfAbsent(color, () {
    final seed = _seedOf(color);
    return isDark
        ? AntColor.fromSeedDark(seed)
        : AntColor.fromSeed(seed);
  });
}

/// 预设色种子值映射。
String _seedOf(AntButtonColor color) {
  return switch (color) {
    AntButtonColor.blue => AntPresetColors.blue,
    AntButtonColor.purple => AntPresetColors.purple,
    AntButtonColor.cyan => AntPresetColors.cyan,
    AntButtonColor.green => AntPresetColors.green,
    AntButtonColor.magenta => AntPresetColors.magenta,
    AntButtonColor.red => AntPresetColors.red,
    AntButtonColor.orange => AntPresetColors.orange,
    AntButtonColor.yellow => AntPresetColors.yellow,
    AntButtonColor.volcano => AntPresetColors.volcano,
    AntButtonColor.geekblue => AntPresetColors.geekblue,
    AntButtonColor.gold => AntPresetColors.gold,
    AntButtonColor.lime => AntPresetColors.lime,
    _ => AntPresetColors.blue, // 不会到达，预设色专用
  };
}

/// 预设色第 N 阶对应的 Flutter [Color]（1-10）。
Color presetColorAt(AntButtonColor color, int step, {required bool isDark}) {
  return getPresetPalette(color, isDark: isDark).colorAt(step);
}