/// Ant Design 色板包装类。
///
/// 封装 10 阶色板（antd ColorMap 1-10），提供按步阶访问
/// 与 Flutter [Color] 转换。
library;

import 'dart:ui';

import 'ant_color_palette.dart';

/// 解析 CSS 颜色字符串为 Flutter [Color]。
///
/// 支持 `#rgb`、`#rrggbb`、`#rrggbbaa`、`rgb(r,g,b)`、`rgba(r,g,b,a)` 格式。
Color antParseColor(String cssColor) {
  final trimmed = cssColor.trim();

  if (trimmed.startsWith('#')) {
    final hex = trimmed.substring(1);
    if (hex.length == 3) {
      final r = int.parse(hex[0] * 2, radix: 16);
      final g = int.parse(hex[1] * 2, radix: 16);
      final b = int.parse(hex[2] * 2, radix: 16);
      return Color.fromARGB(255, r, g, b);
    }
    if (hex.length == 6) {
      final value = int.parse(hex, radix: 16);
      return Color.fromARGB(255, (value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF);
    }
    if (hex.length == 8) {
      final value = int.parse(hex, radix: 16);
      return Color.fromARGB(
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      );
    }
  }

  if (trimmed.startsWith('rgb')) {
    final inner = trimmed
        .replaceAll(RegExp(r'^[^(]*\('), '')
        .replaceAll(RegExp(r'\).*$'), '');
    final parts = inner.split(',').map((s) => s.trim()).toList();
    if (parts.length >= 3) {
      final r = double.tryParse(parts[0])?.round() ?? 0;
      final g = double.tryParse(parts[1])?.round() ?? 0;
      final b = double.tryParse(parts[2])?.round() ?? 0;
      var a = 255;
      if (parts.length >= 4) {
        final aVal = double.tryParse(parts[3]) ?? 1;
        a = (aVal * 255).round().clamp(0, 255);
      }
      return Color.fromARGB(a, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
    }
  }

  // Fallback: 黑色
  return const Color.fromARGB(255, 0, 0, 0);
}

/// Ant Design 色板。
///
/// 封装 antd ColorMap（1-10 步阶）的色板数据，
/// 同时提供 hex 字符串与 Flutter [Color] 两种访问方式。
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
  factory AntColor.fromSeed(String seedColor) {
    final raw = antGeneratePalette(seedColor);
    // 亮色映射: {1..7}=colors[0..6], {8,9,10}=colors[4,5,6]
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3], raw[4],
      raw[5], raw[6], raw[4], raw[5], raw[6],
    ]);
  }

  /// 从种子色生成暗色主题色板。
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
  factory AntColor.fromRawPalette(List<String> raw) {
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3], raw[4],
      raw[5], raw[6], raw[4], raw[5], raw[6],
    ]);
  }

  /// 从原始 generate() 输出直接构造（暗色映射）。
  factory AntColor.fromRawPaletteDark(List<String> raw) {
    return AntColor._([
      raw[0], raw[1], raw[2], raw[3],
      raw[6], raw[5], raw[4],
      raw[6], raw[5], raw[4],
    ]);
  }

  /// 直接从 10 阶映射后的色板构造。
  factory AntColor.fromMapped(List<String> mapped) {
    assert(mapped.length == 10, 'AntColor palette must have exactly 10 steps');
    return AntColor._(List.unmodifiable(mapped));
  }

  // ==================== 步阶访问 (Hex) ====================

  /// 第 1 阶（最浅），对应 antd `colorPrimaryBg` 等。
  String get step1 => _palette[0];
  String get step2 => _palette[1];
  String get step3 => _palette[2];
  String get step4 => _palette[3];
  /// 第 5 阶，对应 antd `colorPrimaryHover` 等。
  String get step5 => _palette[4];
  /// 第 6 阶（主色），对应 antd `colorPrimary` 等。
  String get step6 => _palette[5];
  String get step7 => _palette[6];
  String get step8 => _palette[7];
  String get step9 => _palette[8];
  String get step10 => _palette[9];

  /// 主色（第 6 阶），即 antd 的 `colorPrimary`。
  String get main => step6;

  /// 按步阶号获取 hex 字符串（1-10）。
  String operator [](int step) => _palette[step - 1];

  // ==================== 步阶访问 (Flutter Color) ====================

  /// 第 1 阶 Flutter [Color]。
  Color get step1Color => antParseColor(step1);
  Color get step2Color => antParseColor(step2);
  Color get step3Color => antParseColor(step3);
  Color get step4Color => antParseColor(step4);
  Color get step5Color => antParseColor(step5);
  /// 第 6 阶 Flutter [Color]（主色）。
  Color get step6Color => antParseColor(step6);
  Color get step7Color => antParseColor(step7);
  Color get step8Color => antParseColor(step8);
  Color get step9Color => antParseColor(step9);
  Color get step10Color => antParseColor(step10);

  /// 主色 Flutter [Color]。
  Color get mainColor => step6Color;

  /// 按步阶号获取 Flutter [Color]（1-10）。
  Color colorAt(int step) => antParseColor(_palette[step - 1]);

  /// 原始色板列表（只读）。
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