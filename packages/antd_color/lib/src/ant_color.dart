/// Ant Design 色板包装类。
///
/// 封装 10 阶色板（antd ColorMap 1-10），提供按步阶访问
/// 与 Flutter [Color] 转换。
///
/// CSS 颜色解析工具 [antParseColor] 拆分至 `ant_parse_color.dart`。
///
/// @docImport 'ant_parse_color.dart';
library;

import 'dart:ui';

import 'ant_color_palette.dart';
import 'ant_parse_color.dart';
import 'config/ant_palette_options.dart';

/// Ant Design 色板。
///
/// 封装 antd ColorMap（1-10 步阶）的色板数据，
/// 同时提供 hex 字符串与 Flutter [Color] 两种访问方式。
/// 亮色与暗色主题分别通过 [AntColor.fromSeed] 与 [AntColor.fromSeedDark] 生成，
/// 步阶语义与 antd Token（如 `colorPrimaryBg`、`colorPrimaryHover`）一一对应。
///
/// ```dart
/// final palette = AntColor.fromSeed('#1677FF');
/// print(palette.main); // 第 6 阶 hex，如 '#1677ff'
/// print(palette.mainColor); // 对应的 Flutter Color
/// print(palette[3]); // 按步阶号取 hex
/// ```
class AntColor {
  /// 10 阶色板 hex 字符串列表。
  ///
  /// `_palette[0]` 对应 antd ColorMap 第 1 阶（最浅），
  /// `_palette[9]` 对应第 10 阶（最深）。
  final List<String> _palette;

  /// 从已映射的 10 阶色板构造。
  ///
  /// [palette] 长度必须为 10，顺序为 antd ColorMap 1-10。
  const AntColor._(this._palette);

  /// 从种子色生成亮色主题色板。
  ///
  /// [seedColor] 为种子色 hex 字符串（如 `'#1677FF'`），对应 antd 默认主题下
  /// 由 `generate()` 亮色输出映射出的 10 阶色板（步阶 8-10 复用第 5-7 阶）。
  ///
  /// ```dart
  /// final palette = AntColor.fromSeed('#1677FF');
  /// ```
  factory AntColor.fromSeed(String seedColor) {
    final raw = antGeneratePalette(seedColor);
    // 亮色映射: {1..7}=colors[0..6], {8,9,10}=colors[4,5,6]
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3], raw[4],
      raw[5], raw[6], raw[4], raw[5], raw[6],
    ]);
  }

  /// 从种子色生成暗色主题色板。
  ///
  /// [seedColor] 为种子色 hex 字符串；[background] 为暗色背景色 hex 字符串，
  /// 传入 `null` 时使用 antd 默认暗色背景 `#141414`。
  ///
  /// ```dart
  /// final dark = AntColor.fromSeedDark('#1677FF');
  /// ```
  factory AntColor.fromSeedDark(String seedColor, {String? background}) {
    final raw = antGeneratePalette(
      seedColor,
      AntPaletteOptions(theme: 'dark', backgroundColor: background),
    );
    // 暗色映射: {1..4}=colors[0..3], {5}=colors[6], {6}=colors[5],
    //           {7}=colors[4], {8,9,10}=colors[6,5,4]
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3],
      raw[6], raw[5], raw[4],
      raw[6], raw[5], raw[4],
    ]);
  }

  /// 从原始 generate() 输出直接构造（亮色映射）。
  ///
  /// [raw] 为 [antGeneratePalette] 的亮色输出（长度 10），按 antd 亮色映射
  /// 规则重排为 1-10 步阶；超出前 7 位的元素被忽略。
  factory AntColor.fromRawPalette(List<String> raw) {
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3], raw[4],
      raw[5], raw[6], raw[4], raw[5], raw[6],
    ]);
  }

  /// 从原始 generate() 输出直接构造（暗色映射）。
  ///
  /// [raw] 为 [antGeneratePalette] 暗色主题（`theme: 'dark'`）的输出，
  /// 按antd 暗色映射规则重排为 1-10 步阶。
  factory AntColor.fromRawPaletteDark(List<String> raw) {
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3],
      raw[6], raw[5], raw[4],
      raw[6], raw[5], raw[4],
    ]);
  }

  /// 直接从 10 阶映射后的色板构造。
  ///
  /// [mapped] 必须恰好包含 10 个 hex 字符串，顺序为步阶 1-10；
  /// 长度不符时在调试模式触发断言失败。构造后的色板不可修改。
  factory AntColor.fromMapped(List<String> mapped) {
    assert(mapped.length == 10, 'AntColor palette must have exactly 10 steps');
    return AntColor._(List.unmodifiable(mapped));
  }

  // ==================== 步阶访问 (Hex) ====================

  /// 第 1 阶（最浅），对应 antd `colorPrimaryBg` 等。
  String get step1 => _palette[0];
  /// 第 2 阶，对应 antd `colorPrimaryBgHover` 等浅色背景场景。
  String get step2 => _palette[1];

  /// 第 3 阶，对应 antd `colorPrimaryBorder` 等边框场景。
  String get step3 => _palette[2];

  /// 第 4 阶，对应 antd `colorPrimaryBorderHover` 等边框悬浮场景。
  String get step4 => _palette[3];

  /// 第 5 阶，对应 antd `colorPrimaryHover` 等。
  String get step5 => _palette[4];
  /// 第 6 阶（主色），对应 antd `colorPrimary` 等。
  String get step6 => _palette[5];
  /// 第 7 阶，对应 antd `colorPrimaryActive` 等激活态场景。
  String get step7 => _palette[6];

  /// 第 8 阶，用于深色填充/悬浮态（亮色主题下与第 5 阶同值）。
  String get step8 => _palette[7];

  /// 第 9 阶，用于更深填充态（亮色主题下与第 6 阶同值）。
  String get step9 => _palette[8];

  /// 第 10 阶（最深），用于文本/图标强调（亮色主题下与第 7 阶同值）。
  String get step10 => _palette[9];

  /// 主色（第 6 阶），即 antd 的 `colorPrimary`。
  String get main => step6;

  /// 按步阶号获取 hex 字符串（1-10）。
  ///
  /// [step] 取值 1-10，1 为最浅、10 为最深；超出范围时抛出 [RangeError]。
  ///
  /// ```dart
  /// final palette = AntColor.fromSeed('#1677FF');
  /// print(palette[6]); // 主色 hex
  /// ```
  String operator [](int step) => _palette[step - 1];

  // ==================== 步阶访问 (Flutter Color) ====================

  /// 第 1 阶 Flutter [Color]。
  Color get step1Color => antParseColor(step1);
  /// 第 2 阶 Flutter [Color]。
  Color get step2Color => antParseColor(step2);

  /// 第 3 阶 Flutter [Color]。
  Color get step3Color => antParseColor(step3);

  /// 第 4 阶 Flutter [Color]。
  Color get step4Color => antParseColor(step4);

  /// 第 5 阶 Flutter [Color]。
  Color get step5Color => antParseColor(step5);
  /// 第 6 阶 Flutter [Color]（主色）。
  Color get step6Color => antParseColor(step6);

  /// 第 7 阶 Flutter [Color]。
  Color get step7Color => antParseColor(step7);

  /// 第 8 阶 Flutter [Color]。
  Color get step8Color => antParseColor(step8);

  /// 第 9 阶 Flutter [Color]。
  Color get step9Color => antParseColor(step9);

  /// 第 10 阶 Flutter [Color]。
  Color get step10Color => antParseColor(step10);

  /// 主色 Flutter [Color]。
  Color get mainColor => step6Color;

  /// 按步阶号获取 Flutter [Color]（1-10）。
  ///
  /// [step] 取值 1-10，超出范围时抛出 [RangeError]。
  Color colorAt(int step) => antParseColor(_palette[step - 1]);

  /// 原始色板列表（步阶 1-10 顺序的 hex 字符串，只读视图）。
  List<String> get palette => _palette;

  @override
  bool operator ==(Object other) =>
      other is AntColor && _listEquals(_palette, other._palette);

  @override
  int get hashCode => Object.hashAll(_palette);

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() => 'AntColor(main: $main)';
}